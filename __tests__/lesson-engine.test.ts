import { validateAnswer } from '../services/lesson-engine';
import type { LessonExercise } from '../services/lesson-engine';

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
