import { supabase } from '@/lib/supabase';
import type { SRSRating, SRSState } from '@/services/srs-engine';

export interface ReviewWord {
  id: string;
  vocabulary_id: string;
  chinese: string;
  pinyin: string;
  meaning_vi: string;
  audio_url: string | null;
  example_sentence: string | null;
  example_pinyin: string | null;
  example_meaning: string | null;
  difficulty: number;
  interval_days: number;
  review_count: number;
  memory_strength: number;
  state: SRSState;
}

export interface VocabularyReviewResult {
  success: true;
  submission_id: string;
  progress_id: string;
  vocabulary_id: string;
  rating: SRSRating;
  next_review_at: string;
  difficulty: number;
  interval_days: number;
  review_count: number;
  memory_strength: number;
  state: SRSState;
  already_processed: boolean;
}

export interface MistakeReviewResult {
  success: true;
  submission_id: string;
  mistake_id: string;
  is_correct: boolean;
  resolved: boolean;
  already_processed: boolean;
}

export async function fetchDueReviewWords(
  userId: string,
  limit = 20,
): Promise<ReviewWord[]> {
  const { data, error } = await supabase
    .from('user_vocabulary_progress')
    .select(`
      id, vocabulary_id, difficulty, interval_days, review_count,
      memory_strength, state,
      vocabulary:vocabulary_id (
        chinese, pinyin, meaning_vi, audio_url, example_sentence,
        example_pinyin, example_meaning
      )
    `)
    .eq('user_id', userId)
    .lte('next_review_at', new Date().toISOString())
    .order('next_review_at')
    .limit(Math.max(1, Math.min(50, Math.round(limit))));

  if (error) throw error;

  return (data ?? []).flatMap((item: any) => {
    const vocabulary = Array.isArray(item.vocabulary)
      ? item.vocabulary[0]
      : item.vocabulary;
    if (
      !vocabulary
      || typeof vocabulary.chinese !== 'string'
      || typeof vocabulary.pinyin !== 'string'
      || typeof vocabulary.meaning_vi !== 'string'
    ) {
      return [];
    }

    return [{
      id: item.id,
      vocabulary_id: item.vocabulary_id,
      chinese: vocabulary.chinese,
      pinyin: vocabulary.pinyin,
      meaning_vi: vocabulary.meaning_vi,
      audio_url: vocabulary.audio_url ?? null,
      example_sentence: vocabulary.example_sentence ?? null,
      example_pinyin: vocabulary.example_pinyin ?? null,
      example_meaning: vocabulary.example_meaning ?? null,
      difficulty: item.difficulty,
      interval_days: item.interval_days,
      review_count: item.review_count,
      memory_strength: item.memory_strength,
      state: item.state,
    } satisfies ReviewWord];
  });
}

export async function submitVocabularyReview(
  submissionId: string,
  progressId: string,
  rating: SRSRating,
): Promise<VocabularyReviewResult> {
  const { data, error } = await supabase.rpc('submit_vocabulary_review', {
    p_submission_id: submissionId,
    p_progress_id: progressId,
    p_rating: rating,
  });

  if (error) throw error;
  if (!isVocabularyReviewResult(data)) {
    throw new Error('The vocabulary review response was invalid.');
  }
  return data;
}

export async function submitMistakeReview(
  submissionId: string,
  mistakeId: string,
  answer: string,
): Promise<MistakeReviewResult> {
  const { data, error } = await supabase.rpc('submit_mistake_review', {
    p_submission_id: submissionId,
    p_mistake_id: mistakeId,
    p_answer: answer,
  });

  if (error) throw error;
  if (
    !data
    || data.success !== true
    || typeof data.submission_id !== 'string'
    || typeof data.mistake_id !== 'string'
    || typeof data.is_correct !== 'boolean'
    || typeof data.resolved !== 'boolean'
    || typeof data.already_processed !== 'boolean'
  ) {
    throw new Error('The mistake review response was invalid.');
  }
  return data as MistakeReviewResult;
}

function isVocabularyReviewResult(
  value: unknown,
): value is VocabularyReviewResult {
  if (!value || typeof value !== 'object') return false;
  const result = value as Record<string, unknown>;
  return result.success === true
    && typeof result.submission_id === 'string'
    && typeof result.progress_id === 'string'
    && typeof result.vocabulary_id === 'string'
    && ['again', 'hard', 'good', 'easy'].includes(String(result.rating))
    && typeof result.next_review_at === 'string'
    && typeof result.difficulty === 'number'
    && typeof result.interval_days === 'number'
    && typeof result.review_count === 'number'
    && typeof result.memory_strength === 'number'
    && ['new', 'learning', 'review', 'mastered'].includes(String(result.state))
    && typeof result.already_processed === 'boolean';
}
