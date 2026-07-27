/**
 * Rule-based pronunciation feedback engine
 * Generates Vietnamese feedback based on scores and word assessments
 * No AI/API calls - fast, predictable, free
 */

import { PronunciationAssessmentResult, WordAssessment, ScoreLevel, getScoreLevel } from '@/lib/speech';

export interface PronunciationFeedback {
  overallMessage: string;
  wordFeedback: WordFeedbackItem[];
  suggestions: string[];
  encouragement: string;
}

export interface WordFeedbackItem {
  word: string;
  score: number;
  status: 'good' | 'warning' | 'error';
  message?: string;
}

/**
 * Generate feedback from pronunciation result
 */
export function generateFeedback(result: PronunciationAssessmentResult): PronunciationFeedback {
  const level = getScoreLevel(result.overallScore);
  const overallMessage = getOverallMessage(level, result.overallScore);
  const wordFeedback = generateWordFeedback(result.words);
  const suggestions = generateSuggestions(result, wordFeedback);
  const encouragement = getEncouragement(level, result);

  return {
    overallMessage,
    wordFeedback,
    suggestions,
    encouragement,
  };
}

function getOverallMessage(level: ScoreLevel, score: number): string {
  switch (level) {
    case 'excellent':
      return 'Rất tốt! Cách phát âm của bạn khá tự nhiên.';
    case 'good':
      return 'Khá tốt! Chỉ cần luyện thêm một chút nữa.';
    case 'practice':
      return 'Bạn đang tiến bộ. Hãy nghe lại mẫu và thử chậm hơn.';
    case 'try_again':
      return 'Hãy nghe kỹ phát âm mẫu và thử đọc từng từ một.';
  }
}

function generateWordFeedback(words: WordAssessment[]): WordFeedbackItem[] {
  return words.map(w => {
    let status: 'good' | 'warning' | 'error';
    let message: string | undefined;

    if (w.accuracyScore >= 85) {
      status = 'good';
    } else if (w.accuracyScore >= 60) {
      status = 'warning';
      message = `Hãy nghe lại âm "${w.word}" và thử đọc chậm hơn.`;
    } else {
      status = 'error';
      if (w.errorType === 'Omission') {
        message = `Bạn chưa đọc "${w.word}". Hãy đọc đầy đủ câu.`;
      } else if (w.errorType === 'Mispronunciation') {
        message = `Phần "${w.word}" chưa chính xác. Nghe lại mẫu nhé.`;
      } else {
        message = `Cần luyện thêm phần "${w.word}".`;
      }
    }

    return { word: w.word, score: w.accuracyScore, status, message };
  });
}

function generateSuggestions(result: PronunciationAssessmentResult, wordFeedback: WordFeedbackItem[]): string[] {
  const suggestions: string[] = [];

  const weakWords = wordFeedback.filter(w => w.status === 'error' || w.status === 'warning');

  if (result.fluencyScore < 70) {
    suggestions.push('Thử đọc chậm hơn và rõ ràng hơn.');
  }

  if (result.completenessScore !== null && result.completenessScore < 80) {
    suggestions.push('Đọc đầy đủ cả câu, đừng bỏ sót từ nào.');
  }

  if (weakWords.length > 0 && weakWords.length <= 2) {
    weakWords.forEach(w => {
      suggestions.push(`Luyện lại phần "${w.word}" bằng cách nghe mẫu nhiều lần.`);
    });
  } else if (weakWords.length > 2) {
    suggestions.push('Nhiều phần chưa chính xác. Hãy nghe mẫu và đọc từng từ một.');
  }

  if (suggestions.length === 0 && result.overallScore >= 85) {
    suggestions.push('Tiếp tục giữ nhịp độ và độ rõ ràng này!');
  }

  return suggestions.slice(0, 3); // Max 3 suggestions
}

function getEncouragement(level: ScoreLevel, result: PronunciationAssessmentResult): string {
  switch (level) {
    case 'excellent':
      return '🌟 Xuất sắc! Bạn phát âm rất tự nhiên.';
    case 'good':
      return '👍 Tốt lắm! Tiếp tục luyện tập nhé.';
    case 'practice':
      return '💪 Cố gắng thêm! Mỗi lần thử là một lần tiến bộ.';
    case 'try_again':
      return '🎯 Đừng nản! Phát âm tiếng Trung cần thời gian luyện tập.';
  }
}
