import { findCurrentCue, findPendingQuestion, parseSrt, SubtitleCue, VideoQuestion } from '../services/video-service';

// Mock supabase to avoid react-native import
jest.mock('../lib/supabase', () => ({
  supabase: { from: jest.fn(), rpc: jest.fn() },
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
      { id: 'q1', timestamp_ms: 5000, question: 'Q1', correct_answer: 'A', question_type: 'multiple_choice', options: ['A', 'B'], explanation: null, is_required: true, xp_reward: 5 },
      { id: 'q2', timestamp_ms: 15000, question: 'Q2', correct_answer: 'B', question_type: 'multiple_choice', options: ['A', 'B'], explanation: null, is_required: false, xp_reward: 5 },
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
