import { supabase } from '@/lib/supabase';
import { Exercise, ExerciseOption, ExerciseResult, LessonResult } from '@/types';

export interface LessonExercise extends Exercise {
  exercise_options?: ExerciseOption[];
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
 * Submit lesson completion to the server
 */
export async function submitLessonCompletion(result: LessonResult): Promise<boolean> {
  const { data, error } = await supabase.rpc('complete_lesson', {
    p_lesson_id: result.lesson_id,
    p_score: result.accuracy,
    p_xp_earned: result.xp_earned,
    p_exercises_correct: result.correct_answers,
    p_exercises_total: result.total_exercises,
  });

  if (error) {
    console.error('Error completing lesson:', error);
    return false;
  }

  return true;
}
