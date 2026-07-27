/**
 * Test Azure Pronunciation Assessment response parsing
 * Supports both nested (PronunciationAssessment object) and flat (scores on NBest[0]) formats
 */

// Replicate the parser logic from Edge Function
function parseAzureResponse(data: any, referenceText: string) {
  if (data.RecognitionStatus !== 'Success' || !data.NBest?.length) {
    return { __noMatch: true, recognitionStatus: data.RecognitionStatus };
  }

  const best = data.NBest[0];
  const scoreSource = best.PronunciationAssessment ??
    (best.AccuracyScore !== undefined || best.FluencyScore !== undefined ||
     best.CompletenessScore !== undefined || best.PronScore !== undefined
      ? best : null);

  if (!scoreSource) {
    throw new Error('Azure response missing pronunciation scores');
  }

  const words = (best.Words || []).map((w: any) => {
    const wScore = w.PronunciationAssessment ?? w;
    return {
      word: w.Word ?? w.word ?? '',
      accuracyScore: wScore.AccuracyScore ?? wScore.accuracyScore ?? 0,
      errorType: wScore.ErrorType ?? wScore.errorType ?? 'Unknown',
    };
  });

  return {
    overallScore: Math.round(scoreSource.PronScore ?? scoreSource.PronunciationScore ?? 0),
    accuracyScore: Math.round(scoreSource.AccuracyScore ?? 0),
    fluencyScore: Math.round(scoreSource.FluencyScore ?? 0),
    completenessScore: scoreSource.CompletenessScore != null ? Math.round(scoreSource.CompletenessScore) : null,
    recognizedText: best.Display ?? data.DisplayText ?? best.Lexical ?? '',
    expectedText: referenceText,
    words,
    responseShape: best.PronunciationAssessment ? 'nested' : 'flat',
  };
}

describe('Azure Response Parser', () => {
  describe('Format A: Nested PronunciationAssessment', () => {
    it('parses nested format correctly', () => {
      const data = {
        RecognitionStatus: 'Success',
        NBest: [{
          Display: '你好',
          Lexical: '你好',
          PronunciationAssessment: {
            AccuracyScore: 92,
            FluencyScore: 88,
            CompletenessScore: 100,
            PronScore: 90,
          },
          Words: [
            { Word: '你', PronunciationAssessment: { AccuracyScore: 95, ErrorType: 'None' } },
            { Word: '好', PronunciationAssessment: { AccuracyScore: 89, ErrorType: 'None' } },
          ],
        }],
      };

      const result = parseAzureResponse(data, '你好');
      expect(result.responseShape).toBe('nested');
      expect(result.overallScore).toBe(90);
      expect(result.accuracyScore).toBe(92);
      expect(result.fluencyScore).toBe(88);
      expect(result.completenessScore).toBe(100);
      expect(result.recognizedText).toBe('你好');
      expect(result.words).toHaveLength(2);
      expect(result.words[0].word).toBe('你');
      expect(result.words[0].accuracyScore).toBe(95);
    });
  });

  describe('Format B: Flat scores on NBest[0] (production)', () => {
    it('parses flat format correctly', () => {
      const data = {
        RecognitionStatus: 'Success',
        NBest: [{
          Display: '你好',
          Lexical: '你好',
          Confidence: 0.95,
          AccuracyScore: 90,
          FluencyScore: 85,
          CompletenessScore: 100,
          PronScore: 89,
          Words: [
            { Word: '你', AccuracyScore: 92, ErrorType: 'None' },
            { Word: '好', AccuracyScore: 88, ErrorType: 'None' },
          ],
        }],
      };

      const result = parseAzureResponse(data, '你好');
      expect(result.responseShape).toBe('flat');
      expect(result.overallScore).toBe(89);
      expect(result.accuracyScore).toBe(90);
      expect(result.fluencyScore).toBe(85);
      expect(result.completenessScore).toBe(100);
      expect(result.recognizedText).toBe('你好');
      expect(result.words).toHaveLength(2);
      expect(result.words[0].word).toBe('你');
      expect(result.words[0].accuracyScore).toBe(92);
    });

    it('handles Chinese 谢谢', () => {
      const data = {
        RecognitionStatus: 'Success',
        NBest: [{ Display: '谢谢', AccuracyScore: 78, FluencyScore: 80, CompletenessScore: 100, PronScore: 79 }],
      };
      const result = parseAzureResponse(data, '谢谢');
      expect(result.overallScore).toBe(79);
      expect(result.recognizedText).toBe('谢谢');
    });
  });

  describe('Error cases', () => {
    it('returns __noMatch for NoMatch status', () => {
      const data = { RecognitionStatus: 'NoMatch', NBest: [] };
      const result = parseAzureResponse(data, '你好');
      expect(result.__noMatch).toBe(true);
    });

    it('returns __noMatch for InitialSilenceTimeout', () => {
      const data = { RecognitionStatus: 'InitialSilenceTimeout' };
      const result = parseAzureResponse(data, '你好');
      expect(result.__noMatch).toBe(true);
    });

    it('throws when NBest exists but no scores', () => {
      const data = { RecognitionStatus: 'Success', NBest: [{ Display: '你好', Confidence: 0.9 }] };
      expect(() => parseAzureResponse(data, '你好')).toThrow('missing pronunciation scores');
    });

    it('handles missing ProsodyScore gracefully', () => {
      const data = {
        RecognitionStatus: 'Success',
        NBest: [{ Display: '你好', AccuracyScore: 90, FluencyScore: 85, CompletenessScore: 100, PronScore: 88 }],
      };
      const result = parseAzureResponse(data, '你好');
      expect(result.overallScore).toBe(88);
      // No crash
    });

    it('falls back to DisplayText on root', () => {
      const data = {
        RecognitionStatus: 'Success',
        DisplayText: '你好世界',
        NBest: [{ AccuracyScore: 80, FluencyScore: 75, PronScore: 77 }],
      };
      const result = parseAzureResponse(data, '你好世界');
      expect(result.recognizedText).toBe('你好世界');
    });

    it('handles Words without nested PronunciationAssessment', () => {
      const data = {
        RecognitionStatus: 'Success',
        NBest: [{
          Display: '我是越南人',
          AccuracyScore: 82, FluencyScore: 78, CompletenessScore: 100, PronScore: 80,
          Words: [
            { Word: '我', AccuracyScore: 85, ErrorType: 'None' },
            { Word: '是', AccuracyScore: 80, ErrorType: 'None' },
            { Word: '越南人', AccuracyScore: 82, ErrorType: 'None' },
          ],
        }],
      };
      const result = parseAzureResponse(data, '我是越南人');
      expect(result.words).toHaveLength(3);
      expect(result.words[2].word).toBe('越南人');
      expect(result.words[2].accuracyScore).toBe(82);
    });
  });
});
