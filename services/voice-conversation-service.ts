/**
 * Voice Conversation Service - Turn-Based Implementation
 * Pipeline: Record → STT → AI Tutor → TTS → Playback
 * Reuses Phase 5 AI Tutor for intelligence
 */

import { supabase } from '@/lib/supabase';
import { VoiceSessionConfig, VoiceSessionSummary, TranscriptionResult, TTSResult } from '@/lib/voice';
import { TutorResponse } from '@/lib/ai';

// ============================================
// SESSION MANAGEMENT
// ============================================

export async function createVoiceSession(config: VoiceSessionConfig): Promise<string> {
  const user = (await supabase.auth.getUser()).data.user;
  if (!user) throw new Error('Not authenticated');

  // Check daily limit
  const { data: limitOk, error: limitError } = await supabase.rpc('check_voice_daily_limit', { p_user_id: user.id });
  if (limitError) throw limitError;
  if (!limitOk) throw new Error('Daily voice limit reached');

  const { data, error } = await supabase
    .from('voice_sessions')
    .insert({
      user_id: user.id,
      conversation_id: config.conversationId,
      scenario_id: config.scenarioId || null,
      mode: config.mode,
      transport: config.transport,
      status: 'active',
    })
    .select('id')
    .single();

  if (error) throw error;
  return data.id;
}

export async function endVoiceSession(sessionId: string): Promise<VoiceSessionSummary> {
  const { data, error } = await supabase.rpc('complete_voice_session_authoritative', {
    p_session_id: sessionId,
  });
  if (error) throw error;
  if (!data || data.sessionId !== sessionId) throw new Error('Invalid voice summary');

  return {
    sessionId,
    totalDurationMs: safeCount(data.totalDurationMs),
    userSpeechMs: safeCount(data.userSpeechMs),
    aiSpeechMs: safeCount(data.aiSpeechMs),
    turnCount: safeCount(data.turnCount),
    newWordsCount: safeCount(data.newWordsCount),
    correctionsCount: safeCount(data.correctionsCount),
    xpEarned: safeCount(data.xpEarned),
  };
}

// ============================================
// TURN-BASED VOICE PIPELINE
// ============================================

export interface VoiceTurnResult {
  success: boolean;
  transcript?: string;
  aiResponse?: TutorResponse;
  aiText?: string;
  ttsAudioUri?: string;
  turnId?: string;
  userAudioDurationMs?: number;
  assistantAudioDurationMs?: number;
  error?: string;
  errorCode?: string;
  latency: {
    sttMs: number;
    aiMs: number;
    ttsMs: number;
    totalMs: number;
  };
}

/**
 * Execute a full voice turn: STT → AI → TTS
 * All via authenticated Edge Functions
 */
export async function executeVoiceTurn(
  audioUri: string,
  conversationId: string,
  sessionId: string,
  mode: string,
  clientTurnId: string
): Promise<VoiceTurnResult> {
  const turnStart = Date.now();

  // Step 1: STT (Speech-to-Text)
  const sttStart = Date.now();
  const sttResult = await transcribeAudio(audioUri, sessionId, clientTurnId);
  const sttLatency = Date.now() - sttStart;

  if (!sttResult.success) {
    return {
      success: false,
      error: sttResult.error,
      errorCode: sttResult.errorCode,
      latency: { sttMs: sttLatency, aiMs: 0, ttsMs: 0, totalMs: Date.now() - turnStart },
    };
  }

  if (!sttResult.text?.trim() || !sttResult.turnId) {
    return {
      success: false,
      error: sttResult.text?.trim()
        ? 'Không thể lưu lượt nói. Hãy thử lại nhé.'
        : 'Mình chưa nghe rõ. Hãy thử nói lại nhé.',
      errorCode: sttResult.text?.trim() ? 'TURN_SAVE_FAILED' : 'NO_SPEECH',
      latency: { sttMs: sttLatency, aiMs: 0, ttsMs: 0, totalMs: Date.now() - turnStart },
    };
  }

  // Step 2: AI Tutor (reuse Phase 5)
  const aiStart = Date.now();
  const aiResult = await sendToAITutor(sttResult.text, conversationId, mode, clientTurnId);
  const aiLatency = Date.now() - aiStart;

  if (!aiResult.success || !aiResult.assistantMessageId) {
    return {
      success: false,
      transcript: sttResult.text,
      error: aiResult.error,
      errorCode: 'AI_ERROR',
      latency: { sttMs: sttLatency, aiMs: aiLatency, ttsMs: 0, totalMs: Date.now() - turnStart },
    };
  }

  // Step 3: TTS for AI response
  const ttsStart = Date.now();
  const chineseText = aiResult.structured?.reply?.chinese || aiResult.text || '';
  const ttsResult = await synthesizeSpeech(
    sessionId,
    sttResult.turnId,
    aiResult.assistantMessageId,
  );
  const ttsLatency = Date.now() - ttsStart;

  if (!ttsResult.success) {
    return {
      success: false,
      transcript: sttResult.text,
      aiResponse: aiResult.structured,
      aiText: chineseText,
      error: ttsResult.error,
      errorCode: ttsResult.errorCode,
      latency: { sttMs: sttLatency, aiMs: aiLatency, ttsMs: ttsLatency, totalMs: Date.now() - turnStart },
    };
  }

  return {
    success: true,
    transcript: sttResult.text,
    aiResponse: aiResult.structured,
    aiText: chineseText,
    ttsAudioUri: ttsResult.audioUri,
    turnId: sttResult.turnId,
    userAudioDurationMs: sttResult.durationMs,
    assistantAudioDurationMs: ttsResult.durationMs,
    latency: {
      sttMs: sttLatency,
      aiMs: aiLatency,
      ttsMs: ttsLatency,
      totalMs: Date.now() - turnStart,
    },
  };
}

// ============================================
// STT via Edge Function
// ============================================

interface STTFunctionResult {
  success: boolean;
  text?: string;
  turnId?: string;
  durationMs: number;
  error?: string;
  errorCode?: string;
}

async function transcribeAudio(
  audioUri: string,
  sessionId: string,
  clientTurnId: string,
): Promise<STTFunctionResult> {
  try {
    const response = await fetch(audioUri);
    const blob = await response.blob();
    const buffer = await blob.arrayBuffer();
    const base64 = arrayBufferToBase64(buffer);

    const { data, error } = await supabase.functions.invoke('voice-transcribe', {
      body: { audio: base64, language: 'zh', sessionId, clientTurnId },
    });

    if (error) {
      if (error.message?.includes('not configured')) {
        return { success: false, durationMs: 0, error: 'Dịch vụ giọng nói chưa cấu hình.', errorCode: 'NOT_CONFIGURED' };
      }
      return { success: false, durationMs: 0, error: 'Lỗi nhận dạng giọng nói.', errorCode: 'STT_ERROR' };
    }

    return {
      success: true,
      text: data?.text || '',
      turnId: typeof data?.turnId === 'string' ? data.turnId : undefined,
      durationMs: safeCount(data?.durationMs),
    };
  } catch (err) {
    return { success: false, durationMs: 0, error: 'Lỗi kết nối.', errorCode: 'NETWORK_ERROR' };
  }
}

// ============================================
// AI Tutor (reuse Phase 5 endpoint)
// ============================================

interface AIFunctionResult {
  success: boolean;
  text?: string;
  structured?: TutorResponse;
  assistantMessageId?: string;
  error?: string;
}

async function sendToAITutor(transcript: string, conversationId: string, mode: string, clientMessageId: string): Promise<AIFunctionResult> {
  try {
    const { data, error } = await supabase.functions.invoke('ai-tutor-chat', {
      body: {
        conversationId,
        message: transcript,
        mode,
        clientMessageId,
      },
    });

    if (error) return { success: false, error: 'AI không phản hồi.' };
    if (!data?.assistantMessage) return { success: false, error: 'Không có phản hồi.' };

    const msg = data.assistantMessage;
    if (typeof msg.id !== 'string' || !msg.structured_data?.reply?.chinese) {
      return { success: false, error: 'Phản hồi AI không hợp lệ.' };
    }
    return {
      success: true,
      text: msg.content,
      structured: msg.structured_data,
      assistantMessageId: msg.id,
    };
  } catch {
    return { success: false, error: 'Lỗi kết nối AI.' };
  }
}

// ============================================
// TTS via Edge Function
// ============================================

interface TTSFunctionResult {
  success: boolean;
  audioUri?: string;
  durationMs?: number;
  error?: string;
  errorCode?: string;
}

async function synthesizeSpeech(
  sessionId: string,
  turnId: string,
  assistantMessageId: string,
): Promise<TTSFunctionResult> {
  try {
    const { data, error } = await supabase.functions.invoke('voice-synthesize', {
      body: { sessionId, turnId, assistantMessageId, language: 'zh-CN' },
    });

    if (error || !data?.audio) {
      return { success: false, error: 'Không thể tạo giọng nói AI.', errorCode: 'TTS_ERROR' };
    }

    return {
      success: true,
      audioUri: `data:audio/mp3;base64,${data.audio}`,
      durationMs: safeCount(data.durationMs),
    };
  } catch {
    return { success: false, error: 'Lỗi kết nối giọng nói AI.', errorCode: 'NETWORK_ERROR' };
  }
}

// ============================================
// HELPERS
// ============================================

function arrayBufferToBase64(buffer: ArrayBuffer): string {
  const bytes = new Uint8Array(buffer);
  let binary = '';
  for (let i = 0; i < bytes.byteLength; i++) {
    binary += String.fromCharCode(bytes[i]);
  }
  return btoa(binary);
}

function safeCount(value: unknown): number {
  const parsed = Number(value);
  return Number.isFinite(parsed) ? Math.max(0, Math.round(parsed)) : 0;
}
