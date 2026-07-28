import { supabase } from '../lib/supabase';
import {
  submitLessonCompletion,
  validateAnswer,
} from '../services/lesson-engine';
import type { LessonExercise } from '../services/lesson-engine';
import type { ExerciseResult, LessonResult } from '../types';

// Mock supabase to avoid react-native import
jest.mock('../lib/supabase', () => ({
  supabase: {
    from: jest.fn(),
    rpc: jest.fn(),
  },
}));

describe('Lesson Engine - Answer Validation', () => {
  describe('Multiple Choice', () => {
    const exercise: LessonExercise = {
      id: '1',
      lesson_id: 'l1',
      exercise_type: 'multiple_choice',
      order_index: 1,
      question: 'Test',
      correct_answer: 'Xin chào',
      question_audio_url: null,
      explanation: null,
      hint: null,
      points: 1,
      data: {},
      created_at: '',
      exercise_options: [
        { id: '1', exercise_id: '1', text: 'Xin chào', is_correct: true, order_index: 0 },
        { id: '2', exercise_id: '1', text: 'Tạm biệt', is_correct: false, order_index: 1 },
      ],
    };

    it('correct answer returns true', () => {
      expect(validateAnswer(exercise, 'Xin chào')).toBe(true);
    });

    it('wrong answer returns false', () => {
      expect(validateAnswer(exercise, 'Tạm biệt')).toBe(false);
    });
  });

  describe('Translation', () => {
    const exercise: LessonExercise = {
      id: '2',
      lesson_id: 'l1',
      exercise_type: 'translation',
      order_index: 1,
      question: 'Translate',
      correct_answer: '你好',
      question_audio_url: null,
      explanation: null,
      hint: null,
      points: 1,
      data: { acceptable_answers: ['你好', '你好！'] },
      created_at: '',
    };

    it('exact match returns true', () => {
      expect(validateAnswer(exercise, '你好')).toBe(true);
    });

    it('with trailing punctuation is accepted', () => {
      expect(validateAnswer(exercise, '你好！')).toBe(true);
    });

    it('with spaces is accepted', () => {
      expect(validateAnswer(exercise, ' 你好 ')).toBe(true);
    });

    it('wrong answer returns false', () => {
      expect(validateAnswer(exercise, '再见')).toBe(false);
    });

    it('handles Chinese punctuation normalization', () => {
      const ex: LessonExercise = {
        ...exercise,
        correct_answer: '我是学生。',
        data: { acceptable_answers: ['我是学生。', '我是学生'] },
      };
      expect(validateAnswer(ex, '我是学生')).toBe(true);
      expect(validateAnswer(ex, '我是学生。')).toBe(true);
    });
  });

  describe('Vocabulary type', () => {
    it('always returns true (informational)', () => {
      const exercise: LessonExercise = {
        id: '3',
        lesson_id: 'l1',
        exercise_type: 'vocabulary',
        order_index: 1,
        question: 'Learn',
        correct_answer: '你好',
        question_audio_url: null,
        explanation: null,
        hint: null,
        points: 1,
        data: {},
        created_at: '',
      };
      expect(validateAnswer(exercise, 'anything')).toBe(true);
    });
  });
});

describe('Lesson Engine - Transactional completion', () => {
  const result: LessonResult = {
    lesson_id: '10000000-0000-0000-0000-000000000001',
    total_exercises: 2,
    correct_answers: 1,
    xp_earned: 999,
    accuracy: 50,
    perfect: false,
    time_spent_seconds: 12,
  };
  const attempts: ExerciseResult[] = [
    {
      exercise_id: 'e0000000-0000-0000-0000-000000000001',
      user_answer: '你好',
      is_correct: true,
      time_spent_seconds: 5,
    },
    {
      exercise_id: 'e0000000-0000-0000-0000-000000000002',
      user_answer: 'wrong',
      is_correct: false,
      time_spent_seconds: 7,
    },
  ];
  const response = {
    success: true,
    completion_id: '20000000-0000-0000-0000-000000000001',
    lesson_id: result.lesson_id,
    score: 50,
    correct_answers: 1,
    total_exercises: 2,
    xp_earned: 15,
    lesson_xp_total: 15,
    base_xp: 15,
    perfect_bonus: 0,
    already_processed: false,
    next_lesson_id: '10000000-0000-0000-0000-000000000002',
    course_completed: false,
    course_percent_complete: 20,
    review_words_seeded: 5,
    mistakes_recorded: 1,
  };

  beforeEach(() => {
    jest.clearAllMocks();
  });

  it('sends only raw attempts and a stable completion identifier', async () => {
    (supabase.rpc as jest.Mock).mockResolvedValue({
      data: response,
      error: null,
    });

    await expect(submitLessonCompletion(
      result,
      attempts,
      response.completion_id,
    )).resolves.toEqual(response);

    expect(supabase.rpc).toHaveBeenCalledWith(
      'complete_lesson_transactional',
      {
        p_completion_id: response.completion_id,
        p_lesson_id: result.lesson_id,
        p_attempts: [
          {
            exercise_id: attempts[0].exercise_id,
            user_answer: attempts[0].user_answer,
            time_spent_seconds: attempts[0].time_spent_seconds,
          },
          {
            exercise_id: attempts[1].exercise_id,
            user_answer: attempts[1].user_answer,
            time_spent_seconds: attempts[1].time_spent_seconds,
          },
        ],
      },
    );

    const rpcPayload = (supabase.rpc as jest.Mock).mock.calls[0][1];
    expect(rpcPayload).not.toHaveProperty('p_xp_earned');
    expect(rpcPayload.p_attempts[0]).not.toHaveProperty('is_correct');
  });

  it('surfaces server failures so the same completion can be retried', async () => {
    const serverError = { message: 'Lesson is locked', code: '42501' };
    (supabase.rpc as jest.Mock).mockResolvedValue({
      data: null,
      error: serverError,
    });

    await expect(submitLessonCompletion(
      result,
      attempts,
      response.completion_id,
    )).rejects.toBe(serverError);
  });

  it('rejects malformed success responses instead of showing false success', async () => {
    (supabase.rpc as jest.Mock).mockResolvedValue({
      data: { success: true, xp_earned: 15 },
      error: null,
    });

    await expect(submitLessonCompletion(
      result,
      attempts,
      response.completion_id,
    )).rejects.toThrow('lesson completion response was invalid');
  });
});
