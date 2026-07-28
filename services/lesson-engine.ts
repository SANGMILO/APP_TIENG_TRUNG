import { supabase } from '@/lib/supabase';
import { Exercise, ExerciseOption, ExerciseResult, LessonResult } from '@/types';

export interface LessonExercise extends Exercise {
  exercise_options?: ExerciseOption[];
}

export interface LessonCompletionResponse {
  success: true;
  completion_id: string;
  lesson_id: string;
  score: number;
  correct_answers: number;
  total_exercises: number;
  xp_earned: number;
  lesson_xp_total: number;
  base_xp: number;
  perfect_bonus: number;
  already_processed: boolean;
  next_lesson_id: string | null;
  course_completed: boolean;
  course_percent_complete: number;
  review_words_seeded: number;
  mistakes_recorded: number;
}

/**
 * Fetch all exercises for a lesson from database
 */
export async function fetchLessonExercises(lessonId: string): Promise<LessonExercise[]> {
  const { data, error } = await supabase
    .from('exercises')
    .select(`
      *,
      exercise_options (*)
    `)
    .eq('lesson_id', lessonId)
    .order('order_index');

  if (error) throw error;
  return (data ?? []) as LessonExercise[];
}

/**
 * Fetch the configured XP reward for a lesson.
 * The route keeps a conservative fallback if this metadata cannot be loaded.
 */
export async function fetchLessonXpReward(lessonId: string): Promise<number> {
  const { data, error } = await supabase
    .from('lessons')
    .select('xp_reward')
    .eq('id', lessonId)
    .single();

  if (error) throw error;
  return typeof data?.xp_reward === 'number' ? data.xp_reward : 15;
}

/**
 * Validate an answer for an exercise
 * Returns whether the answer is correct
 */
export function validateAnswer(exercise: LessonExercise, userAnswer: string): boolean {
  const type = exercise.exercise_type;

  switch (type) {
    case 'multiple_choice':
    case 'listening': {
      // For multiple choice, check if the selected option is correct
      if (exercise.exercise_options?.length) {
        const correctOption = exercise.exercise_options.find(o => o.is_correct);
        return correctOption?.text === userAnswer;
      }
      return normalizeAnswer(userAnswer) === normalizeAnswer(exercise.correct_answer);
    }

    case 'translation': {
      // Support multiple acceptable answers stored in data.acceptable_answers
      const acceptable = (exercise.data as any)?.acceptable_answers as string[] | undefined;
      const normalized = normalizeChineseAnswer(userAnswer);

      if (acceptable?.length) {
        return acceptable.some(a => normalizeChineseAnswer(a) === normalized);
      }
      return normalizeChineseAnswer(exercise.correct_answer) === normalized;
    }

    case 'sentence_builder': {
      return normalizeChineseAnswer(userAnswer) === normalizeChineseAnswer(exercise.correct_answer);
    }

    case 'vocabulary':
    case 'flashcard':
      // These are informational - always "correct" (user just views)
      return true;

    default:
      return normalizeAnswer(userAnswer) === normalizeAnswer(exercise.correct_answer);
  }
}

/**
 * Normalize a generic answer for comparison
 */
function normalizeAnswer(answer: string): string {
  return answer.trim().toLowerCase();
}

/**
 * Normalize a Chinese answer: handle punctuation differences, whitespace
 */
function normalizeChineseAnswer(answer: string): string {
  return answer
    .trim()
    // Normalize Chinese punctuation to ASCII equivalents for comparison
    .replace(/[，]/g, ',')
    .replace(/[。]/g, '.')
    .replace(/[！]/g, '!')
    .replace(/[？]/g, '?')
    .replace(/[、]/g, ',')
    .replace(/[；]/g, ';')
    .replace(/[：]/g, ':')
    // Remove all whitespace for Chinese text comparison
    .replace(/\s+/g, '')
    // Remove trailing punctuation for leniency
    .replace(/[,.!?;:]+$/, '');
}

/**
 * Calculate lesson results from exercise results
 */
export function calculateLessonResult(
  lessonId: string,
  exercises: LessonExercise[],
  results: ExerciseResult[],
  xpReward: number
): LessonResult {
  const correctAnswers = results.filter(r => r.is_correct).length;
  const totalExercises = results.length;
  const accuracy = totalExercises > 0 ? (correctAnswers / totalExercises) * 100 : 0;
  const perfect = correctAnswers === totalExercises;
  const totalTime = results.reduce((sum, r) => sum + r.time_spent_seconds, 0);

  // Bonus XP for perfect lesson
  const bonusXp = perfect ? 5 : 0;
  const totalXp = xpReward + bonusXp;

  return {
    lesson_id: lessonId,
    total_exercises: totalExercises,
    correct_answers: correctAnswers,
    xp_earned: totalXp,
    accuracy,
    perfect,
    time_spent_seconds: totalTime,
  };
}

/**
 * Submit lesson completion to the server.
 *
 * The server ignores client correctness and XP estimates. completionId must be
 * retained across retries so a network replay cannot duplicate attempts or XP.
 */
export async function submitLessonCompletion(
  result: LessonResult,
  attempts: ExerciseResult[],
  completionId: string,
): Promise<LessonCompletionResponse> {
  const { data, error } = await supabase.rpc('complete_lesson_transactional', {
    p_completion_id: completionId,
    p_lesson_id: result.lesson_id,
    p_attempts: attempts.map((attempt) => ({
      exercise_id: attempt.exercise_id,
      user_answer: attempt.user_answer,
      time_spent_seconds: attempt.time_spent_seconds,
    })),
  });

  if (error) throw error;

  if (
    !data
    || data.success !== true
    || typeof data.completion_id !== 'string'
    || typeof data.lesson_id !== 'string'
    || typeof data.score !== 'number'
    || typeof data.correct_answers !== 'number'
    || typeof data.total_exercises !== 'number'
    || typeof data.xp_earned !== 'number'
    || typeof data.lesson_xp_total !== 'number'
    || typeof data.base_xp !== 'number'
    || typeof data.perfect_bonus !== 'number'
    || typeof data.already_processed !== 'boolean'
    || (data.next_lesson_id !== null && typeof data.next_lesson_id !== 'string')
    || typeof data.course_completed !== 'boolean'
    || typeof data.course_percent_complete !== 'number'
    || typeof data.review_words_seeded !== 'number'
    || typeof data.mistakes_recorded !== 'number'
  ) {
    throw new Error('The lesson completion response was invalid.');
  }

  return data as LessonCompletionResponse;
}
