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
  thumbnail_url: string | null;
  thumbnail_path: string | null;
  level: string;
  category: string | null;
  duration_seconds: number;
  xp_reward: number;
  is_premium: boolean;
  source_type: string;
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
  correct_answer: string;
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
  return (data ?? []) as VideoItem[];
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
      id, timestamp_ms, question, correct_answer, question_type, options, explanation, is_required, xp_reward
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
    .single();

  if (error && error.code !== 'PGRST116') throw error; // PGRST116 = not found
  return data as VideoProgress | null;
}

export async function saveVideoProgress(
  userId: string,
  videoId: string,
  positionMs: number,
  watchTimeMs: number,
  durationMs: number
) {
  const progressPercent = durationMs > 0 ? Math.min(100, (positionMs / durationMs) * 100) : 0;

  const { error } = await supabase
    .from('user_video_progress')
    .upsert({
      user_id: userId,
      video_id: videoId,
      last_position_ms: positionMs,
      furthest_position_ms: positionMs,
      watch_time_ms: watchTimeMs,
      progress_percent: progressPercent,
      last_watched_at: new Date().toISOString(),
    }, { onConflict: 'user_id,video_id' });

  if (error) console.error('Save video progress error:', error);
}

export async function completeVideo(
  videoId: string,
  watchTimeMs: number,
  questionsAnswered: number,
  questionsCorrect: number
): Promise<boolean> {
  const { data, error } = await supabase.rpc('complete_video', {
    p_video_id: videoId,
    p_watch_time_ms: watchTimeMs,
    p_questions_answered: questionsAnswered,
    p_questions_correct: questionsCorrect,
  });

  if (error) {
    console.error('Complete video error:', error);
    return false;
  }
  return true;
}

export async function saveVideoAnswer(
  userId: string,
  videoId: string,
  questionId: string,
  answer: string,
  isCorrect: boolean
) {
  await supabase.from('user_video_question_attempts').insert({
    user_id: userId,
    video_id: videoId,
    question_id: questionId,
    selected_answer: answer,
    is_correct: isCorrect,
  });
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
