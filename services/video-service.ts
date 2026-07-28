/**
 * Video Learning Service
 * Manages video progress, subtitle lookup, question triggering
 */

import { supabase } from '@/lib/supabase';

// ============================================
// TYPES
// ============================================

export interface VideoItem {
  id: string;
  title: string;
  description: string | null;
  video_url: string;
  video_path: string | null;
  external_url: string | null;
  thumbnail_url: string | null;
  thumbnail_path: string | null;
  level: string;
  category: string | null;
  duration_seconds: number;
  xp_reward: number;
  is_premium: boolean;
  source_type: string;
  playback_type: string;
  processing_status: string;
  status: string;
}

export interface SubtitleCue {
  id: string;
  start_ms: number;
  end_ms: number;
  chinese_text: string | null;
  pinyin: string | null;
  vietnamese_text: string | null;
  sequence: number;
}

export interface VideoQuestion {
  id: string;
  timestamp_ms: number;
  question: string;
  question_type: string;
  options: string[];
  explanation: string | null;
  is_required: boolean;
  xp_reward: number;
}

export interface VideoProgress {
  last_position_ms: number;
  furthest_position_ms: number;
  watch_time_ms: number;
  progress_percent: number;
  completed_at: string | null;
  questions_answered: number;
  questions_correct: number;
}

export interface ResolvedVideoSource {
  uri: string;
  contentType: 'progressive' | 'hls';
}

export interface VideoQuestionState {
  answeredIds: Set<string>;
  questionsAnswered: number;
  questionsCorrect: number;
}

export interface VideoAnswerResult {
  success: true;
  attempt_id: string;
  question_id: string;
  video_id: string;
  is_correct: boolean;
  questions_answered: number;
  questions_correct: number;
  already_processed: boolean;
}

export interface VideoCompletionResult {
  success: true;
  video_id: string;
  xp_earned: number;
  already_completed: boolean;
  progress_percent: number;
  watch_time_ms: number;
  questions_answered: number;
  questions_correct: number;
}

export class VideoUnavailableError extends Error {
  constructor(message: string, public readonly code: string) {
    super(message);
    this.name = 'VideoUnavailableError';
  }
}

const DIRECT_MEDIA_PATTERN = /\.(mp4|m4v|mov|webm|m3u8)(?:$|[?#])/i;
const EMBED_HOST_PATTERN = /(^|\.)((youtube|youtu)\.be|youtube\.com|vimeo\.com)$/i;

export function isDirectPlayableUrl(
  value: string | null | undefined,
  playbackType: string,
): boolean {
  const candidate = value?.trim();
  if (!candidate) return false;

  try {
    const url = new URL(candidate);
    if (!['http:', 'https:'].includes(url.protocol)) return false;
    if (url.username || url.password || EMBED_HOST_PATTERN.test(url.hostname)) return false;
    if (DIRECT_MEDIA_PATTERN.test(url.href)) return true;
    return playbackType === 'progressive' || playbackType === 'hls';
  } catch {
    return false;
  }
}

export function hasPotentialPlayableSource(video: VideoItem): boolean {
  if (
    video.status !== 'published'
    || video.processing_status !== 'ready'
    || video.is_premium
  ) {
    return false;
  }

  return isDirectPlayableUrl(video.video_url, video.playback_type)
    || isDirectPlayableUrl(video.external_url, video.playback_type)
    || Boolean(video.video_path?.trim());
}

export async function resolveVideoSource(
  video: VideoItem,
): Promise<ResolvedVideoSource> {
  if (video.is_premium) {
    throw new VideoUnavailableError(
      'Nội dung Premium chưa thể xác minh quyền truy cập.',
      'PREMIUM_ENTITLEMENT_UNAVAILABLE',
    );
  }
  if (video.processing_status !== 'ready') {
    throw new VideoUnavailableError(
      'Video vẫn đang được xử lý.',
      'VIDEO_NOT_READY',
    );
  }

  const directUrl = isDirectPlayableUrl(video.video_url, video.playback_type)
    ? video.video_url.trim()
    : isDirectPlayableUrl(video.external_url, video.playback_type)
      ? video.external_url!.trim()
      : null;

  if (directUrl) {
    return {
      uri: directUrl,
      contentType: video.playback_type === 'hls' ? 'hls' : 'progressive',
    };
  }

  if (video.video_path?.trim()) {
    const { data, error } = await supabase.functions.invoke('video-playback-url', {
      body: { videoId: video.id },
    });
    if (error) {
      throw new VideoUnavailableError(
        error.message || 'Không thể cấp quyền phát video.',
        'PLAYBACK_URL_FAILED',
      );
    }
    if (
      !data
      || !isDirectPlayableUrl(data.url, data.playbackType)
      || !['progressive', 'hls'].includes(data.playbackType)
    ) {
      throw new VideoUnavailableError(
        'Máy chủ không trả về nguồn video hợp lệ.',
        'INVALID_PLAYBACK_SOURCE',
      );
    }
    return {
      uri: data.url,
      contentType: data.playbackType,
    };
  }

  throw new VideoUnavailableError(
    'Video này chưa có tệp media có thể phát.',
    'MEDIA_UNAVAILABLE',
  );
}

// ============================================
// SUBTITLE LOOKUP (binary search for performance)
// ============================================

/**
 * Find the current subtitle cue for a given playback time
 * Uses binary search for efficiency with large subtitle lists
 */
export function findCurrentCue(cues: SubtitleCue[], timeMs: number): SubtitleCue | null {
  if (cues.length === 0) return null;

  let low = 0;
  let high = cues.length - 1;

  while (low <= high) {
    const mid = Math.floor((low + high) / 2);
    const cue = cues[mid];

    if (timeMs >= cue.start_ms && timeMs < cue.end_ms) {
      return cue;
    } else if (timeMs < cue.start_ms) {
      high = mid - 1;
    } else {
      low = mid + 1;
    }
  }

  return null;
}

/**
 * Find the next question that should trigger at or after the given time
 */
export function findPendingQuestion(
  questions: VideoQuestion[],
  timeMs: number,
  answeredIds: Set<string>
): VideoQuestion | null {
  for (const q of questions) {
    if (q.timestamp_ms <= timeMs && !answeredIds.has(q.id)) {
      return q;
    }
  }
  return null;
}

// ============================================
// DATABASE QUERIES
// ============================================

export async function fetchVideos(level?: string, category?: string) {
  let query = supabase
    .from('videos')
    .select('*')
    .eq('status', 'published')
    .order('created_at', { ascending: false });

  if (level) query = query.eq('level', level);
  if (category) query = query.eq('category', category);

  const { data, error } = await query.limit(20);
  if (error) throw error;
  return ((data ?? []) as VideoItem[]).filter(hasPotentialPlayableSource);
}

export async function fetchVideoById(videoId: string) {
  const { data, error } = await supabase
    .from('videos')
    .select('*')
    .eq('id', videoId)
    .single();

  if (error) throw error;
  return data as VideoItem;
}

export async function fetchSubtitles(videoId: string): Promise<SubtitleCue[]> {
  const { data, error } = await supabase
    .from('video_subtitles')
    .select('id, start_ms, end_ms, chinese_text, pinyin, vietnamese_text, sequence')
    .eq('video_id', videoId)
    .order('sequence');

  if (error) throw error;
  return (data ?? []) as SubtitleCue[];
}

export async function fetchVideoQuestions(videoId: string): Promise<VideoQuestion[]> {
  const { data, error } = await supabase
    .from('video_questions')
    .select(`
      id, timestamp_ms, question, question_type, options, explanation, is_required, xp_reward
    `)
    .eq('video_id', videoId)
    .order('timestamp_ms');

  if (error) throw error;
  return (data ?? []).map((q: any) => ({
    ...q,
    options: Array.isArray(q.options) ? q.options : [],
  })) as VideoQuestion[];
}

export async function fetchVideoProgress(userId: string, videoId: string): Promise<VideoProgress | null> {
  const { data, error } = await supabase
    .from('user_video_progress')
    .select('*')
    .eq('user_id', userId)
    .eq('video_id', videoId)
    .maybeSingle();

  if (error) throw error;
  return data as VideoProgress | null;
}

export async function fetchAnsweredVideoQuestions(
  userId: string,
  videoId: string,
): Promise<VideoQuestionState> {
  const { data, error } = await supabase
    .from('user_video_question_attempts')
    .select('question_id, is_correct')
    .eq('user_id', userId)
    .eq('video_id', videoId);

  if (error) throw error;

  const attempts = data ?? [];
  return {
    answeredIds: new Set(attempts.map((attempt) => attempt.question_id)),
    questionsAnswered: new Set(attempts.map((attempt) => attempt.question_id)).size,
    questionsCorrect: new Set(
      attempts
        .filter((attempt) => attempt.is_correct)
        .map((attempt) => attempt.question_id),
    ).size,
  };
}

export async function saveVideoProgress(
  eventId: string,
  videoId: string,
  positionMs: number,
  playedDeltaMs: number,
  durationMs: number,
): Promise<VideoProgress> {
  const { data, error } = await supabase.rpc('record_video_progress', {
    p_event_id: eventId,
    p_video_id: videoId,
    p_position_ms: Math.max(0, Math.round(positionMs)),
    p_played_delta_ms: Math.max(0, Math.min(30000, Math.round(playedDeltaMs))),
    p_duration_ms: Math.max(0, Math.round(durationMs)),
  });

  if (error) throw error;
  if (!isVideoProgress(data)) {
    throw new Error('The video progress response was invalid.');
  }
  return data;
}

export async function completeVideo(
  videoId: string,
): Promise<VideoCompletionResult> {
  const { data, error } = await supabase.rpc('complete_video_transactional', {
    p_video_id: videoId,
  });

  if (error) throw error;
  if (
    !data
    || data.success !== true
    || typeof data.video_id !== 'string'
    || typeof data.xp_earned !== 'number'
    || typeof data.already_completed !== 'boolean'
    || typeof data.progress_percent !== 'number'
    || typeof data.watch_time_ms !== 'number'
    || typeof data.questions_answered !== 'number'
    || typeof data.questions_correct !== 'number'
  ) {
    throw new Error('The video completion response was invalid.');
  }
  return data as VideoCompletionResult;
}

export async function saveVideoAnswer(
  attemptId: string,
  questionId: string,
  answer: string,
): Promise<VideoAnswerResult> {
  const { data, error } = await supabase.rpc('submit_video_question_answer', {
    p_attempt_id: attemptId,
    p_question_id: questionId,
    p_answer: answer,
  });

  if (error) throw error;
  if (
    !data
    || data.success !== true
    || typeof data.attempt_id !== 'string'
    || typeof data.question_id !== 'string'
    || typeof data.video_id !== 'string'
    || typeof data.is_correct !== 'boolean'
    || typeof data.questions_answered !== 'number'
    || typeof data.questions_correct !== 'number'
    || typeof data.already_processed !== 'boolean'
  ) {
    throw new Error('The video answer response was invalid.');
  }
  return data as VideoAnswerResult;
}

function isVideoProgress(value: unknown): value is VideoProgress {
  if (!value || typeof value !== 'object') return false;
  const progress = value as Record<string, unknown>;
  return typeof progress.last_position_ms === 'number'
    && typeof progress.furthest_position_ms === 'number'
    && typeof progress.watch_time_ms === 'number'
    && typeof progress.progress_percent === 'number'
    && (progress.completed_at === null || typeof progress.completed_at === 'string')
    && typeof progress.questions_answered === 'number'
    && typeof progress.questions_correct === 'number';
}

// ============================================
// SUBTITLE SRT PARSER
// ============================================

export interface ParsedSrtCue {
  sequence: number;
  start_ms: number;
  end_ms: number;
  text: string;
}

/**
 * Parse SRT subtitle format
 */
export function parseSrt(srtContent: string): ParsedSrtCue[] {
  const cues: ParsedSrtCue[] = [];
  const blocks = srtContent.trim().split(/\n\n+/);

  for (const block of blocks) {
    const lines = block.split('\n');
    if (lines.length < 3) continue;

    const sequence = parseInt(lines[0].trim());
    if (isNaN(sequence)) continue;

    const timeLine = lines[1].trim();
    const timeMatch = timeLine.match(
      /(\d{2}):(\d{2}):(\d{2})[,.](\d{3})\s*-->\s*(\d{2}):(\d{2}):(\d{2})[,.](\d{3})/
    );
    if (!timeMatch) continue;

    const start_ms =
      parseInt(timeMatch[1]) * 3600000 +
      parseInt(timeMatch[2]) * 60000 +
      parseInt(timeMatch[3]) * 1000 +
      parseInt(timeMatch[4]);

    const end_ms =
      parseInt(timeMatch[5]) * 3600000 +
      parseInt(timeMatch[6]) * 60000 +
      parseInt(timeMatch[7]) * 1000 +
      parseInt(timeMatch[8]);

    const text = lines.slice(2).join('\n').trim();

    if (start_ms < end_ms && text) {
      cues.push({ sequence, start_ms, end_ms, text });
    }
  }

  return cues;
}
