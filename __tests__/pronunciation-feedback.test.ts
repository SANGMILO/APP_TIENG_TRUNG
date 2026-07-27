import { generateFeedback } from '../services/pronunciation-feedback';
import { PronunciationAssessmentResult } from '../lib/speech/types';

describe('Pronunciation Feedback Engine', () => {
  it('generates excellent feedback for high scores', () => {
    const result: PronunciationAssessmentResult = {
      overallScore: 95,
      accuracyScore: 96,
      fluencyScore: 93,
      completenessScore: 100,
      recognizedText: '你好',
      expectedText: '你好',
      words: [
        { word: '你', accuracyScore: 95, errorType: 'None' },
        { word: '好', accuracyScore: 96, errorType: 'None' },
      ],
      provider: 'azure',
      durationMs: 1500,
      assessedAt: '2024-01-01T00:00:00Z',
    };

    const feedback = generateFeedback(result);
    expect(feedback.overallMessage).toContain('tự nhiên');
    expect(feedback.wordFeedback.every(w => w.status === 'good')).toBe(true);
    expect(feedback.encouragement).toContain('Xuất sắc');
  });

  it('identifies weak words', () => {
    const result: PronunciationAssessmentResult = {
      overallScore: 72,
      accuracyScore: 75,
      fluencyScore: 68,
      completenessScore: 100,
      recognizedText: '你好',
      expectedText: '你好',
      words: [
        { word: '你', accuracyScore: 90, errorType: 'None' },
        { word: '好', accuracyScore: 55, errorType: 'Mispronunciation' },
      ],
      provider: 'azure',
      durationMs: 2000,
      assessedAt: '2024-01-01T00:00:00Z',
    };

    const feedback = generateFeedback(result);
    expect(feedback.wordFeedback[0].status).toBe('good');
    expect(feedback.wordFeedback[1].status).toBe('error');
    expect(feedback.wordFeedback[1].message).toContain('好');
    expect(feedback.suggestions.length).toBeGreaterThan(0);
  });

  it('suggests slowing down for low fluency', () => {
    const result: PronunciationAssessmentResult = {
      overallScore: 65,
      accuracyScore: 80,
      fluencyScore: 50,
      completenessScore: 100,
      recognizedText: '你好',
      expectedText: '你好',
      words: [
        { word: '你', accuracyScore: 80, errorType: 'None' },
        { word: '好', accuracyScore: 80, errorType: 'None' },
      ],
      provider: 'azure',
      durationMs: 3000,
      assessedAt: '2024-01-01T00:00:00Z',
    };

    const feedback = generateFeedback(result);
    expect(feedback.suggestions.some(s => s.includes('chậm'))).toBe(true);
  });

  it('handles omission errors', () => {
    const result: PronunciationAssessmentResult = {
      overallScore: 50,
      accuracyScore: 60,
      fluencyScore: 40,
      completenessScore: 50,
      recognizedText: '你',
      expectedText: '你好',
      words: [
        { word: '你', accuracyScore: 80, errorType: 'None' },
        { word: '好', accuracyScore: 0, errorType: 'Omission' },
      ],
      provider: 'azure',
      durationMs: 1000,
      assessedAt: '2024-01-01T00:00:00Z',
    };

    const feedback = generateFeedback(result);
    expect(feedback.wordFeedback[1].message).toContain('chưa đọc');
    expect(feedback.suggestions.some(s => s.includes('đầy đủ'))).toBe(true);
  });

  it('limits suggestions to 3', () => {
    const result: PronunciationAssessmentResult = {
      overallScore: 30,
      accuracyScore: 30,
      fluencyScore: 30,
      completenessScore: 40,
      recognizedText: '',
      expectedText: '你好世界',
      words: [
        { word: '你', accuracyScore: 40, errorType: 'Mispronunciation' },
        { word: '好', accuracyScore: 30, errorType: 'Mispronunciation' },
        { word: '世', accuracyScore: 20, errorType: 'Mispronunciation' },
        { word: '界', accuracyScore: 10, errorType: 'Omission' },
      ],
      provider: 'azure',
      durationMs: 2000,
      assessedAt: '2024-01-01T00:00:00Z',
    };

    const feedback = generateFeedback(result);
    expect(feedback.suggestions.length).toBeLessThanOrEqual(3);
  });
});
