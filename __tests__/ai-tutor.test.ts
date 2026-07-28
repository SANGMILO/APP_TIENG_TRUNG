import { parseStructuredResponse, buildSystemPrompt } from '../services/ai-context-builder';
import { TutorResponse, LearningContext } from '../lib/ai/types';

describe('AI Tutor - Context Builder', () => {
  describe('buildSystemPrompt', () => {
    const baseContext: LearningContext = {
      level: 'beginner',
      recentVocabulary: ['你好', '谢谢', '再见'],
      recentMistakes: [{ question: '我是学生', error: '我是学生。需要句号' }],
      dailyGoal: 20,
      streak: 5,
      learningPurpose: 'communication',
    };

    it('includes user level in prompt', () => {
      const prompt = buildSystemPrompt(baseContext, 'general');
      expect(prompt).toContain('beginner');
    });

    it('includes recent vocabulary', () => {
      const prompt = buildSystemPrompt(baseContext, 'general');
      expect(prompt).toContain('你好');
      expect(prompt).toContain('谢谢');
    });

    it('includes recent mistakes', () => {
      const prompt = buildSystemPrompt(baseContext, 'general');
      expect(prompt).toContain('我是学生');
    });

    it('includes mode instructions', () => {
      const prompt = buildSystemPrompt(baseContext, 'restaurant');
      expect(prompt).toContain('restaurant');
    });

    it('limits vocabulary context', () => {
      const ctx = { ...baseContext, recentVocabulary: Array(50).fill('词') };
      const prompt = buildSystemPrompt(ctx, 'general');
      // Should not include all 50
      const vocabSection = prompt.split('Recent vocabulary:')[1]?.split('\n')[0] || '';
      expect(vocabSection.split('词').length).toBeLessThanOrEqual(16); // 15 + trailing
    });

    it('includes JSON response format instruction', () => {
      const prompt = buildSystemPrompt(baseContext, 'general');
      expect(prompt).toContain('JSON');
      expect(prompt).toContain('"reply"');
    });

    it('includes security rules', () => {
      const prompt = buildSystemPrompt(baseContext, 'general');
      expect(prompt).toContain('Never reveal');
      expect(prompt).toContain('Never execute');
    });
  });

  describe('parseStructuredResponse', () => {
    it('parses valid structured response', () => {
      const raw = JSON.stringify({
        reply: { chinese: '你好！', pinyin: 'nǐ hǎo!', translationVi: 'Xin chào!' },
        correction: null,
        newVocabulary: [],
        suggestedReplies: ['我叫...', '你好'],
        learningTip: null,
        practiceExercise: null,
      });

      const result = parseStructuredResponse(raw);
      expect(result).not.toBeNull();
      expect(result!.reply.chinese).toBe('你好！');
      expect(result!.reply.pinyin).toBe('nǐ hǎo!');
      expect(result!.suggestedReplies).toHaveLength(2);
    });

    it('parses JSON wrapped in code block', () => {
      const raw = '```json\n{"reply":{"chinese":"好的","pinyin":"hǎo de","translationVi":"Được"},"correction":null,"newVocabulary":[],"suggestedReplies":[],"learningTip":null,"practiceExercise":null}\n```';

      const result = parseStructuredResponse(raw);
      expect(result).not.toBeNull();
      expect(result!.reply.chinese).toBe('好的');
    });

    it('parses response with correction', () => {
      const raw = JSON.stringify({
        reply: { chinese: '我是学生。', pinyin: 'wǒ shì xuéshēng.', translationVi: 'Tôi là học sinh.' },
        correction: { original: '我是学生了', corrected: '我是学生', explanationVi: 'Không cần 了 ở đây', errorType: 'particle', severity: 'minor' },
        newVocabulary: [{ chinese: '学生', pinyin: 'xuéshēng', meaningVi: 'học sinh' }],
        suggestedReplies: [],
        learningTip: 'Lưu ý: 是 không dùng với 了',
        practiceExercise: null,
      });

      const result = parseStructuredResponse(raw);
      expect(result!.correction).not.toBeNull();
      expect(result!.correction!.errorType).toBe('particle');
      expect(result!.newVocabulary).toHaveLength(1);
      expect(result!.learningTip).toContain('是');
    });

    it('returns null for invalid JSON', () => {
      expect(parseStructuredResponse('not json at all')).toBeNull();
    });

    it('returns null for missing reply field', () => {
      expect(parseStructuredResponse('{"correction": null}')).toBeNull();
    });

    it('limits newVocabulary to 5 items', () => {
      const raw = JSON.stringify({
        reply: { chinese: 'test', pinyin: 'test', translationVi: 'test' },
        correction: null,
        newVocabulary: Array(10).fill({ chinese: '词', pinyin: 'cí', meaningVi: 'từ' }),
        suggestedReplies: [],
        learningTip: null,
        practiceExercise: null,
      });

      const result = parseStructuredResponse(raw);
      expect(result!.newVocabulary.length).toBeLessThanOrEqual(5);
    });

    it('limits suggestedReplies to 3', () => {
      const raw = JSON.stringify({
        reply: { chinese: 'test', pinyin: 'test', translationVi: 'test' },
        correction: null,
        newVocabulary: [],
        suggestedReplies: ['a', 'b', 'c', 'd', 'e'],
        learningTip: null,
        practiceExercise: null,
      });

      const result = parseStructuredResponse(raw);
      expect(result!.suggestedReplies.length).toBeLessThanOrEqual(3);
    });

    it('sanitizes malformed optional model fields before rendering', () => {
      const raw = JSON.stringify({
        reply: { chinese: ' 你好\u0000 ', pinyin: 123, translationVi: null },
        correction: { original: 'x' },
        newVocabulary: [
          { chinese: '好', pinyin: 'hǎo', meaningVi: 'tốt' },
          { chinese: '<bad>', pinyin: null, meaningVi: {} },
        ],
        suggestedReplies: [' 好的 ', { text: 'unsafe' }, '', '再见'],
        learningTip: { text: 'invalid' },
        practiceExercise: { type: 'unknown', question: 'x' },
      });

      const result = parseStructuredResponse(raw);
      expect(result).not.toBeNull();
      expect(result!.reply).toEqual({ chinese: '你好', pinyin: '', translationVi: '' });
      expect(result!.correction).toBeNull();
      expect(result!.newVocabulary).toEqual([{ chinese: '好', pinyin: 'hǎo', meaningVi: 'tốt' }]);
      expect(result!.suggestedReplies).toEqual(['好的', '再见']);
      expect(result!.learningTip).toBeNull();
      expect(result!.practiceExercise).toBeNull();
    });

    it('rejects non-string required reply content', () => {
      expect(parseStructuredResponse('{"reply":{"chinese":{"html":"bad"}}}')).toBeNull();
    });
  });
});
