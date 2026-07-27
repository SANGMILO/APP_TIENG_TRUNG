// Speech Service Abstraction Layer - Phase 3 Complete

/**
 * Normalized pronunciation assessment result.
 * Provider-agnostic - maps any provider's response to this format.
 */
export interface PronunciationAssessmentResult {
  overallScore: number;       // 0-100
  accuracyScore: number;      // 0-100
  fluencyScore: number;       // 0-100
  completenessScore: number | null; // 0-100, null if provider doesn't support
  recognizedText: string;
  expectedText: string;
  words: WordAssessment[];
  provider: SpeechProviderType;
  durationMs: number;
  assessedAt: string;         // ISO timestamp
}

export interface WordAssessment {
  word: string;
  accuracyScore: number;
  errorType: 'None' | 'Mispronunciation' | 'Omission' | 'Insertion' | 'Unknown';
}

export interface PronunciationAssessmentInput {
  audio: ArrayBuffer | Blob;
  audioUri?: string;          // Preferred: raw recording URI for normalization
  referenceText: string;
  locale: string;             // e.g. 'zh-CN'
  exerciseId?: string;
  lessonId?: string;
  vocabularyId?: string;
  clientAttemptId: string;    // Idempotency key from client
}

export interface SpeechConfig {
  language: string;
  referenceText: string;
}

/**
 * Provider interface - implemented by each speech backend
 */
export interface ISpeechProvider {
  readonly name: SpeechProviderType;

  assessPronunciation(
    audio: ArrayBuffer,
    config: SpeechConfig
  ): Promise<PronunciationAssessmentResult>;

  textToSpeech(text: string, language?: string): Promise<ArrayBuffer>;

  speechToText(audio: ArrayBuffer, language?: string): Promise<string>;

  isConfigured(): boolean;
}

export type SpeechProviderType = 'azure' | 'google' | 'openai' | 'mock';

/**
 * Recording state machine states
 */
export type RecordingState =
  | 'idle'
  | 'requesting_permission'
  | 'ready'
  | 'recording'
  | 'recorded'
  | 'uploading'
  | 'assessing'
  | 'success'
  | 'error';

/**
 * Pronunciation feedback levels
 */
export type ScoreLevel = 'excellent' | 'good' | 'practice' | 'try_again';

export function getScoreLevel(score: number): ScoreLevel {
  if (score >= 90) return 'excellent';
  if (score >= 75) return 'good';
  if (score >= 60) return 'practice';
  return 'try_again';
}

export function getScoreLevelLabel(level: ScoreLevel): string {
  switch (level) {
    case 'excellent': return 'Tuyệt vời!';
    case 'good': return 'Khá tốt!';
    case 'practice': return 'Gần đúng rồi!';
    case 'try_again': return 'Thử lại một lần nữa nhé.';
  }
}

export function getScoreLevelColor(level: ScoreLevel, colors: any): string {
  switch (level) {
    case 'excellent': return colors.success;
    case 'good': return colors.info;
    case 'practice': return colors.warning;
    case 'try_again': return colors.error;
  }
}
