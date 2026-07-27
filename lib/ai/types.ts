/**
 * AI Provider Abstraction Layer - Phase 5
 * Provider-independent types for Chinese tutoring
 */

// ============================================
// PROVIDER INTERFACE
// ============================================

export interface ChatMessage {
  role: 'system' | 'user' | 'assistant';
  content: string;
}

export interface AIStreamChunk {
  delta: string;
  done: boolean;
}

export interface AIResponse {
  content: string;
  inputTokens: number;
  outputTokens: number;
  model: string;
  provider: AIProviderType;
  latencyMs: number;
  requestId?: string;
}

export interface AIConfig {
  model?: string;
  temperature?: number;
  maxTokens?: number;
}

export interface IAIProvider {
  readonly name: AIProviderType;
  chat(messages: ChatMessage[], config?: AIConfig): Promise<AIResponse>;
  isConfigured(): boolean;
}

export type AIProviderType = 'openai' | 'gemini' | 'claude' | 'mock';

// ============================================
// TUTOR RESPONSE STRUCTURE
// ============================================

export interface TutorResponse {
  reply: TutorReply;
  correction: TutorCorrection | null;
  newVocabulary: TutorVocabItem[];
  suggestedReplies: string[];
  learningTip: string | null;
  practiceExercise: TutorExercise | null;
}

export interface TutorReply {
  chinese: string;
  pinyin: string;
  translationVi: string;
}

export interface TutorCorrection {
  original: string;
  corrected: string;
  explanationVi: string;
  errorType: CorrectionErrorType;
  severity: 'minor' | 'moderate' | 'major';
}

export type CorrectionErrorType =
  | 'grammar'
  | 'word_choice'
  | 'word_order'
  | 'measure_word'
  | 'particle'
  | 'tone_confusion'
  | 'naturalness'
  | 'other';

export interface TutorVocabItem {
  chinese: string;
  pinyin: string;
  meaningVi: string;
}

export interface TutorExercise {
  type: 'multiple_choice' | 'translation' | 'fill_blank';
  question: string;
  options?: string[];
  answer: string;
  explanationVi: string;
}

// ============================================
// CONVERSATION TYPES
// ============================================

export type ConversationMode =
  | 'general'
  | 'beginner'
  | 'conversation'
  | 'travel'
  | 'restaurant'
  | 'shopping'
  | 'work'
  | 'business'
  | 'interview'
  | 'hsk'
  | 'free_talk'
  | 'grammar';

export interface Conversation {
  id: string;
  title: string | null;
  mode: ConversationMode;
  difficulty: string;
  status: string;
  message_count: number;
  last_message_at: string | null;
  created_at: string;
}

export interface Message {
  id: string;
  conversation_id: string;
  role: 'user' | 'assistant';
  content: string;
  structured_data: TutorResponse | null;
  status: MessageStatus;
  created_at: string;
}

export type MessageStatus = 'sending' | 'streaming' | 'completed' | 'failed' | 'cancelled';

// ============================================
// CONTEXT TYPES
// ============================================

export interface LearningContext {
  level: string;
  recentVocabulary: string[];
  recentMistakes: { question: string; error: string }[];
  dailyGoal: number;
  streak: number;
  learningPurpose: string | null;
}
