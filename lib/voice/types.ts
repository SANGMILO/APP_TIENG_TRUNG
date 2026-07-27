/**
 * Voice Conversation Types - Phase 6
 * Transport-independent abstractions for voice AI tutoring
 */

// ============================================
// STATE MACHINE
// ============================================

export type VoiceState =
  | 'idle'
  | 'connecting'
  | 'ready'
  | 'listening'
  | 'recording'
  | 'transcribing'
  | 'thinking'
  | 'generating_audio'
  | 'speaking'
  | 'interrupted'
  | 'reconnecting'
  | 'error'
  | 'ended';

// ============================================
// TRANSPORT ABSTRACTION
// ============================================

export type VoiceTransportType = 'turn_based' | 'realtime';

export interface VoiceSessionConfig {
  mode: string;
  conversationId?: string;
  scenarioId?: string;
  difficulty: string;
  transport: VoiceTransportType;
  maxTurnDurationMs: number;
  language: string;
  ttsVoice?: string;
  ttsSpeed?: 'slow' | 'normal';
}

// ============================================
// STT (Speech-to-Text) PROVIDER
// ============================================

export interface TranscriptionResult {
  text: string;
  language: string;
  durationMs: number;
  provider: string;
  model: string;
  confidence?: number;
}

export interface ISTTProvider {
  readonly name: string;
  transcribe(audio: ArrayBuffer, options?: STTOptions): Promise<TranscriptionResult>;
  isConfigured(): boolean;
}

export interface STTOptions {
  language?: string;  // e.g. 'zh'
  prompt?: string;    // context hint
}

// ============================================
// TTS (Text-to-Speech) PROVIDER
// ============================================

export interface TTSResult {
  audio: ArrayBuffer;
  mimeType: string;
  durationMs: number | null;
  provider: string;
  model: string;
  voice: string;
}

export interface ITTSProvider {
  readonly name: string;
  synthesize(text: string, options?: TTSOptions): Promise<TTSResult>;
  isConfigured(): boolean;
}

export interface TTSOptions {
  voice?: string;
  speed?: number;   // 0.5 - 2.0
  language?: string;
}

// ============================================
// VOICE TURN
// ============================================

export interface VoiceTurn {
  id: string;
  userTranscript: string;
  assistantTranscript: string;
  assistantChinese?: string;
  assistantPinyin?: string;
  assistantVietnamese?: string;
  sttLatencyMs: number;
  aiLatencyMs: number;
  ttsLatencyMs: number;
  totalLatencyMs: number;
  userAudioDurationMs: number;
  assistantAudioDurationMs: number | null;
}

// ============================================
// VOICE SESSION SUMMARY
// ============================================

export interface VoiceSessionSummary {
  sessionId: string;
  totalDurationMs: number;
  userSpeechMs: number;
  aiSpeechMs: number;
  turnCount: number;
  newWordsCount: number;
  correctionsCount: number;
  xpEarned: number;
}
