export interface NormalizedTutorResponse {
  reply: {
    chinese: string;
    pinyin: string;
    translationVi: string;
  };
  correction: {
    original: string;
    corrected: string;
    explanationVi: string;
    errorType:
      | 'grammar'
      | 'word_choice'
      | 'word_order'
      | 'measure_word'
      | 'particle'
      | 'tone_confusion'
      | 'naturalness'
      | 'other';
    severity: 'minor' | 'moderate' | 'major';
  } | null;
  newVocabulary: Array<{
    chinese: string;
    pinyin: string;
    meaningVi: string;
  }>;
  suggestedReplies: string[];
  learningTip: string | null;
  practiceExercise: {
    type: 'multiple_choice' | 'translation' | 'fill_blank';
    question: string;
    options?: string[];
    answer: string;
    explanationVi: string;
  } | null;
}

const ERROR_TYPES = new Set([
  'grammar',
  'word_choice',
  'word_order',
  'measure_word',
  'particle',
  'tone_confusion',
  'naturalness',
  'other',
]);
const SEVERITIES = new Set(['minor', 'moderate', 'major']);
const EXERCISE_TYPES = new Set(['multiple_choice', 'translation', 'fill_blank']);

function isRecord(value: unknown): value is Record<string, unknown> {
  return typeof value === 'object' && value !== null && !Array.isArray(value);
}

function cleanText(value: unknown, maxLength: number, required = false): string | null {
  if (typeof value !== 'string') return required ? null : '';
  const cleaned = value.replace(/[\u0000-\u0008\u000B\u000C\u000E-\u001F\u007F]/g, '').trim();
  if (required && !cleaned) return null;
  return cleaned.slice(0, maxLength);
}

/**
 * Converts untrusted model output to the exact UI schema.
 * Invalid required fields reject the whole response; malformed optional fields
 * are discarded rather than reaching render code.
 */
export function normalizeTutorResponse(value: unknown): NormalizedTutorResponse | null {
  if (!isRecord(value) || !isRecord(value.reply)) return null;

  const chinese = cleanText(value.reply.chinese, 500, true);
  if (!chinese) return null;

  const pinyin = cleanText(value.reply.pinyin, 1000) ?? '';
  const translationVi = cleanText(value.reply.translationVi, 1500) ?? '';

  let correction: NormalizedTutorResponse['correction'] = null;
  if (isRecord(value.correction)) {
    const original = cleanText(value.correction.original, 500, true);
    const corrected = cleanText(value.correction.corrected, 500, true);
    const explanationVi = cleanText(value.correction.explanationVi, 1500, true);
    const errorType = value.correction.errorType;
    const severity = value.correction.severity;
    if (
      original &&
      corrected &&
      explanationVi &&
      typeof errorType === 'string' &&
      ERROR_TYPES.has(errorType) &&
      typeof severity === 'string' &&
      SEVERITIES.has(severity)
    ) {
      correction = {
        original,
        corrected,
        explanationVi,
        errorType: errorType as NonNullable<NormalizedTutorResponse['correction']>['errorType'],
        severity: severity as NonNullable<NormalizedTutorResponse['correction']>['severity'],
      };
    }
  }

  const newVocabulary = Array.isArray(value.newVocabulary)
    ? value.newVocabulary
        .filter(isRecord)
        .map((item) => ({
          chinese: cleanText(item.chinese, 100, true),
          pinyin: cleanText(item.pinyin, 200, true),
          meaningVi: cleanText(item.meaningVi, 300, true),
        }))
        .filter(
          (item): item is { chinese: string; pinyin: string; meaningVi: string } =>
            Boolean(item.chinese && item.pinyin && item.meaningVi),
        )
        .slice(0, 5)
    : [];

  const suggestedReplies = Array.isArray(value.suggestedReplies)
    ? value.suggestedReplies
        .map((reply) => cleanText(reply, 300, true))
        .filter((reply): reply is string => Boolean(reply))
        .slice(0, 3)
    : [];

  const learningTip =
    value.learningTip === null || value.learningTip === undefined
      ? null
      : cleanText(value.learningTip, 1000, true);

  let practiceExercise: NormalizedTutorResponse['practiceExercise'] = null;
  if (isRecord(value.practiceExercise)) {
    const type = value.practiceExercise.type;
    const question = cleanText(value.practiceExercise.question, 1000, true);
    const answer = cleanText(value.practiceExercise.answer, 500, true);
    const explanationVi = cleanText(value.practiceExercise.explanationVi, 1500, true);
    if (
      typeof type === 'string' &&
      EXERCISE_TYPES.has(type) &&
      question &&
      answer &&
      explanationVi
    ) {
      const options = Array.isArray(value.practiceExercise.options)
        ? value.practiceExercise.options
            .map((option) => cleanText(option, 300, true))
            .filter((option): option is string => Boolean(option))
            .slice(0, 6)
        : undefined;
      practiceExercise = {
        type: type as NonNullable<NormalizedTutorResponse['practiceExercise']>['type'],
        question,
        answer,
        explanationVi,
        ...(options?.length ? { options } : {}),
      };
    }
  }

  return {
    reply: { chinese, pinyin, translationVi },
    correction,
    newVocabulary,
    suggestedReplies,
    learningTip,
    practiceExercise,
  };
}
