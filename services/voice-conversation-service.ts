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
  const { data: limitOk } = await supabase.rpc('check_voice_daily_limit', { p_user_id: user.id });
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

export async function endVoiceSession(
  sessionId: string,
  totalDurationMs: number,
  userSpeechMs: number,
  aiSpeechMs: number,
  turnCount: number
): Promise<VoiceSessionSummary> {
  const { data, error } = await supabase.rpc('complete_voice_session', {
    p_session_id: sessionId,
    p_total_duration_ms: totalDurationMs,
    p_user_speech_ms: userSpeechMs,
    p_ai_speech_ms: aiSpeechMs,
    p_turn_count: turnCount,
  });

  return {
    sessionId,
    totalDurationMs,
    userSpeechMs,
    aiSpeechMs,
    turnCount,
    newWordsCount: 0, // Could be calculated from conversation
    correctionsCount: 0,
    xpEarned: userSpeechMs >= 30000 && turnCount >= 3 ? 10 : 0,
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
  const sttResult = await transcribeAudio(audioUri);
  const sttLatency = Date.now() - sttStart;

  if (!sttResult.success) {
    return {
      success: false,
      error: sttResult.error,
      errorCode: sttResult.errorCode,
      latency: { sttMs: sttLatency, aiMs: 0, ttsMs: 0, totalMs: Date.now() - turnStart },
    };
  }

  if (!sttResult.text?.trim()) {
    return {
      success: false,
      error: 'Mình chưa nghe rõ. Hãy thử nói lại nhé.',
      errorCode: 'NO_SPEECH',
      latency: { sttMs: sttLatency, aiMs: 0, ttsMs: 0, totalMs: Date.now() - turnStart },
    };
  }

  // Step 2: AI Tutor (reuse Phase 5)
  const aiStart = Date.now();
  const aiResult = await sendToAITutor(sttResult.text, conversationId, mode, clientTurnId);
  const aiLatency = Date.now() - aiStart;

  if (!aiResult.success) {
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
  const ttsResult = await synthesizeSpeech(chineseText);
  const ttsLatency = Date.now() - ttsStart;

  // Save voice turn
  await saveVoiceTurn(sessionId, sttResult.text, chineseText, sttLatency, aiLatency, ttsLatency, sttResult.durationMs);

  return {
    success: true,
    transcript: sttResult.text,
    aiResponse: aiResult.structured,
    aiText: chineseText,
    ttsAudioUri: ttsResult?.audioUri,
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
  durationMs: number;
  error?: string;
  errorCode?: string;
}

async function transcribeAudio(audioUri: string): Promise<STTFunctionResult> {
  try {
    const response = await fetch(audioUri);
    const blob = await response.blob();
    const buffer = await blob.arrayBuffer();
    const base64 = arrayBufferToBase64(buffer);

    const { data, error } = await supabase.functions.invoke('voice-transcribe', {
      body: { audio: base64, language: 'zh' },
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
      durationMs: data?.durationMs || 0,
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
    return {
      success: true,
      text: msg.content,
      structured: msg.structured_data,
    };
  } catch {
    return { success: false, error: 'Lỗi kết nối AI.' };
  }
}

// ============================================
// TTS via Edge Function
// ============================================

interface TTSFunctionResult {
  audioUri?: string;
}

async function synthesizeSpeech(text: string): Promise<TTSFunctionResult | null> {
  if (!text.trim()) return null;

  try {
    const { data, error } = await supabase.functions.invoke('voice-synthesize', {
      body: { text, language: 'zh-CN' },
    });

    if (error || !data?.audio) return null;

    // Convert base64 audio to local URI for playback
    // In production: use blob URL or temp file
    return { audioUri: `data:audio/mp3;base64,${data.audio}` };
  } catch {
    return null;
  }
}

// ============================================
// SAVE TURN
// ============================================

async function saveVoiceTurn(
  sessionId: string,
  userTranscript: string,
  assistantTranscript: string,
  sttLatencyMs: number,
  aiLatencyMs: number,
  ttsLatencyMs: number,
  userAudioDurationMs: number
) {
  const user = (await supabase.auth.getUser()).data.user;
  if (!user) return;

  await supabase.from('voice_turns').insert({
    session_id: sessionId,
    user_id: user.id,
    user_transcript: userTranscript,
    assistant_transcript: assistantTranscript,
    stt_latency_ms: sttLatencyMs,
    ai_latency_ms: aiLatencyMs,
    tts_latency_ms: ttsLatencyMs,
    total_latency_ms: sttLatencyMs + aiLatencyMs + ttsLatencyMs,
    user_audio_duration_ms: userAudioDurationMs,
    status: 'completed',
  });
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
