import { supabase } from '../lib/supabase';
import {
  VideoItem,
  findCurrentCue,
  findPendingQuestion,
  hasPotentialPlayableSource,
  isDirectPlayableUrl,
  parseSrt,
  resolveVideoSource,
  saveVideoAnswer,
  saveVideoProgress,
  SubtitleCue,
  VideoQuestion,
} from '../services/video-service';
import { authorizePrivateVideoPlayback } from '../supabase/functions/_shared/video-playback-authorization';

// Mock supabase to avoid react-native import
jest.mock('../lib/supabase', () => ({
  supabase: {
    from: jest.fn(),
    rpc: jest.fn(),
    functions: { invoke: jest.fn() },
  },
}));

describe('Video Service', () => {
  describe('findCurrentCue', () => {
    const cues: SubtitleCue[] = [
      { id: '1', start_ms: 0, end_ms: 3000, chinese_text: '你好', pinyin: 'nǐ hǎo', vietnamese_text: 'Xin chào', sequence: 1 },
      { id: '2', start_ms: 3000, end_ms: 6000, chinese_text: '我叫小明', pinyin: 'wǒ jiào xiǎo míng', vietnamese_text: 'Tôi tên Tiểu Minh', sequence: 2 },
      { id: '3', start_ms: 8000, end_ms: 12000, chinese_text: '再见', pinyin: 'zàijiàn', vietnamese_text: 'Tạm biệt', sequence: 3 },
    ];

    it('finds cue for time within range', () => {
      expect(findCurrentCue(cues, 1500)?.id).toBe('1');
      expect(findCurrentCue(cues, 4000)?.id).toBe('2');
      expect(findCurrentCue(cues, 10000)?.id).toBe('3');
    });

    it('returns null for time between cues', () => {
      expect(findCurrentCue(cues, 7000)).toBeNull(); // gap between cue 2 and 3
    });

    it('returns null for time before first cue', () => {
      // First cue starts at 0, so -1 should be null
      expect(findCurrentCue(cues, -1)).toBeNull();
    });

    it('returns null for time after last cue', () => {
      expect(findCurrentCue(cues, 15000)).toBeNull();
    });

    it('returns cue at exact start time', () => {
      expect(findCurrentCue(cues, 3000)?.id).toBe('2');
    });

    it('returns null at exact end time (exclusive)', () => {
      expect(findCurrentCue(cues, 6000)).toBeNull(); // 6000 is end of cue 2 but before cue 3
    });

    it('handles empty array', () => {
      expect(findCurrentCue([], 1000)).toBeNull();
    });
  });

  describe('findPendingQuestion', () => {
    const questions: VideoQuestion[] = [
      { id: 'q1', timestamp_ms: 5000, question: 'Q1', question_type: 'multiple_choice', options: ['A', 'B'], explanation: null, is_required: true, xp_reward: 5 },
      { id: 'q2', timestamp_ms: 15000, question: 'Q2', question_type: 'multiple_choice', options: ['A', 'B'], explanation: null, is_required: false, xp_reward: 5 },
    ];

    it('finds first unanswered question at or before time', () => {
      const result = findPendingQuestion(questions, 6000, new Set());
      expect(result?.id).toBe('q1');
    });

    it('skips answered questions', () => {
      const result = findPendingQuestion(questions, 6000, new Set(['q1']));
      expect(result).toBeNull();
    });

    it('returns null when time is before any question', () => {
      const result = findPendingQuestion(questions, 3000, new Set());
      expect(result).toBeNull();
    });

    it('finds second question when first is answered', () => {
      const result = findPendingQuestion(questions, 20000, new Set(['q1']));
      expect(result?.id).toBe('q2');
    });
  });

  describe('parseSrt', () => {
    it('parses basic SRT content', () => {
      const srt = `1
00:00:00,000 --> 00:00:03,000
你好！

2
00:00:03,000 --> 00:00:06,000
我叫小明。`;

      const result = parseSrt(srt);
      expect(result).toHaveLength(2);
      expect(result[0].start_ms).toBe(0);
      expect(result[0].end_ms).toBe(3000);
      expect(result[0].text).toBe('你好！');
      expect(result[1].start_ms).toBe(3000);
      expect(result[1].text).toBe('我叫小明。');
    });

    it('handles hours in timestamps', () => {
      const srt = `1
01:30:15,500 --> 01:30:20,000
Test`;

      const result = parseSrt(srt);
      expect(result[0].start_ms).toBe(5415500); // 1*3600000 + 30*60000 + 15*1000 + 500
      expect(result[0].end_ms).toBe(5420000);
    });

    it('handles multiline text', () => {
      const srt = `1
00:00:00,000 --> 00:00:03,000
Line 1
Line 2`;

      const result = parseSrt(srt);
      expect(result[0].text).toBe('Line 1\nLine 2');
    });

    it('handles dot separator', () => {
      const srt = `1
00:00:00.000 --> 00:00:03.000
你好`;

      const result = parseSrt(srt);
      expect(result).toHaveLength(1);
    });

    it('skips invalid blocks', () => {
      const srt = `invalid

1
00:00:00,000 --> 00:00:03,000
Valid`;

      const result = parseSrt(srt);
      expect(result).toHaveLength(1);
    });

    it('rejects start >= end', () => {
      const srt = `1
00:00:05,000 --> 00:00:03,000
Bad timing`;

      const result = parseSrt(srt);
      expect(result).toHaveLength(0);
    });
  });
});

describe('Video playback sources', () => {
  const video: VideoItem = {
    id: 'a1d00000-0000-0000-0000-000000000001',
    title: 'Playable',
    description: null,
    video_url: 'https://cdn.example.invalid/lesson.mp4',
    video_path: null,
    external_url: null,
    thumbnail_url: null,
    thumbnail_path: null,
    level: 'starter',
    category: null,
    duration_seconds: 120,
    xp_reward: 15,
    is_premium: false,
    source_type: 'uploaded',
    playback_type: 'progressive',
    processing_status: 'ready',
    status: 'published',
  };

  beforeEach(() => {
    jest.clearAllMocks();
  });

  it('accepts direct media but rejects embeds and unsafe schemes', () => {
    expect(isDirectPlayableUrl(video.video_url, 'progressive')).toBe(true);
    expect(isDirectPlayableUrl('https://youtube.com/watch?v=abc', 'external')).toBe(false);
    expect(isDirectPlayableUrl('javascript:alert(1)', 'progressive')).toBe(false);
    expect(isDirectPlayableUrl('', 'progressive')).toBe(false);
  });

  it('hides empty, premium, processing, and non-published records', () => {
    expect(hasPotentialPlayableSource(video)).toBe(true);
    expect(hasPotentialPlayableSource({ ...video, video_url: '' })).toBe(false);
    expect(hasPotentialPlayableSource({ ...video, is_premium: true })).toBe(false);
    expect(hasPotentialPlayableSource({ ...video, processing_status: 'processing' })).toBe(false);
    expect(hasPotentialPlayableSource({ ...video, status: 'draft' })).toBe(false);
  });

  it('resolves a direct source without requesting a signed URL', async () => {
    await expect(resolveVideoSource(video)).resolves.toEqual({
      uri: video.video_url,
      contentType: 'progressive',
    });
    expect(supabase.functions.invoke).not.toHaveBeenCalled();
  });

  it('requests a signed URL only for a valid private storage path', async () => {
    (supabase.functions.invoke as jest.Mock).mockResolvedValue({
      data: {
        url: 'https://project.supabase.co/storage/v1/object/sign/video-content/video.mp4?token=test',
        playbackType: 'progressive',
      },
      error: null,
    });

    await expect(resolveVideoSource({
      ...video,
      video_url: '',
      video_path: `${video.id}/playback.mp4`,
    })).resolves.toEqual({
      uri: 'https://project.supabase.co/storage/v1/object/sign/video-content/video.mp4?token=test',
      contentType: 'progressive',
    });
    expect(supabase.functions.invoke).toHaveBeenCalledWith(
      'video-playback-url',
      { body: { videoId: video.id } },
    );
  });
});

describe('Video progress and question persistence', () => {
  beforeEach(() => {
    jest.clearAllMocks();
  });

  it('records bounded idempotent real-player deltas through the RPC', async () => {
    const progress = {
      last_position_ms: 25000,
      furthest_position_ms: 40000,
      watch_time_ms: 18000,
      progress_percent: 33.3,
      completed_at: null,
      questions_answered: 0,
      questions_correct: 0,
    };
    (supabase.rpc as jest.Mock).mockResolvedValue({ data: progress, error: null });

    await expect(saveVideoProgress(
      '22000000-0000-0000-0000-000000000001',
      'a1d00000-0000-0000-0000-000000000001',
      25000,
      45000,
      120000,
    )).resolves.toEqual(progress);

    expect(supabase.rpc).toHaveBeenCalledWith('record_video_progress', {
      p_event_id: '22000000-0000-0000-0000-000000000001',
      p_video_id: 'a1d00000-0000-0000-0000-000000000001',
      p_position_ms: 25000,
      p_played_delta_ms: 30000,
      p_duration_ms: 120000,
    });
  });

  it('uses server-scored answers rather than a client correctness boolean', async () => {
    const result = {
      success: true,
      attempt_id: '22000000-0000-0000-0000-000000000002',
      question_id: 'b2000000-0000-0000-0000-000000000001',
      video_id: 'a1d00000-0000-0000-0000-000000000001',
      is_correct: false,
      questions_answered: 1,
      questions_correct: 0,
      already_processed: false,
    };
    (supabase.rpc as jest.Mock).mockResolvedValue({ data: result, error: null });

    await expect(saveVideoAnswer(
      result.attempt_id,
      result.question_id,
      'answer',
    )).resolves.toEqual(result);
    expect(supabase.rpc).toHaveBeenCalledWith(
      'submit_video_question_answer',
      {
        p_attempt_id: result.attempt_id,
        p_question_id: result.question_id,
        p_answer: 'answer',
      },
    );
  });
});

describe('Private video playback authorization', () => {
  const record = {
    id: 'a1d00000-0000-0000-0000-000000000001',
    status: 'published',
    processing_status: 'ready',
    is_premium: false,
    video_path: 'a1d00000-0000-0000-0000-000000000001/playback.mp4',
    playback_type: 'progressive',
  };

  it('authorizes a normalized non-premium storage object path', () => {
    expect(authorizePrivateVideoPlayback(record)).toEqual({
      authorized: true,
      objectPath: record.video_path,
      playbackType: 'progressive',
    });
  });

  it('blocks premium content when no authoritative entitlement exists', () => {
    expect(authorizePrivateVideoPlayback({
      ...record,
      is_premium: true,
    })).toEqual(expect.objectContaining({
      authorized: false,
      errorCode: 'PREMIUM_ENTITLEMENT_UNAVAILABLE',
    }));
  });

  it('rejects path traversal before storage access', () => {
    expect(authorizePrivateVideoPlayback({
      ...record,
      video_path: '../private.mp4',
    })).toEqual(expect.objectContaining({
      authorized: false,
      errorCode: 'INVALID_VIDEO_PATH',
    }));
  });
});
