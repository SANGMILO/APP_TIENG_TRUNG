/**
 * Supabase Edge Function: voice-transcribe
 * Speech-to-Text via OpenAI Whisper API
 * Server-side only - API key never exposed to client
 */

import { serve } from 'https://deno.land/std@0.168.0/http/server.ts';
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2.49.4';

const OPENAI_API_KEY = Deno.env.get('OPENAI_API_KEY');
const OPENAI_STT_MODEL = Deno.env.get('OPENAI_STT_MODEL') || 'whisper-1';
const SUPABASE_URL = Deno.env.get('SUPABASE_URL')!;
const SUPABASE_SERVICE_ROLE_KEY = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!;

const MAX_AUDIO_SIZE = 25 * 1024 * 1024; // 25MB (Whisper limit)
const MAX_TURN_DURATION_MS = 60000;

serve(async (req) => {
  if (req.method === 'OPTIONS') {
    return corsResponse(null, 204);
  }

  try {
    // Auth
    const authHeader = req.headers.get('Authorization');
    if (!authHeader) return corsResponse({ error: 'Unauthorized' }, 401);

    const supabase = createClient(SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY);
    const token = authHeader.replace('Bearer ', '');
    const { data: { user }, error: authError } = await supabase.auth.getUser(token);
    if (authError || !user) return corsResponse({ error: 'Unauthorized' }, 401);

    // Check configured
    if (!OPENAI_API_KEY) {
      return corsResponse({ error: 'STT not configured', errorCode: 'NOT_CONFIGURED' }, 503);
    }

    // Check voice daily limit
    const { data: limitOk } = await supabase.rpc('check_voice_daily_limit', { p_user_id: user.id });
    if (!limitOk) {
      return corsResponse({ error: 'Daily voice limit reached', errorCode: 'RATE_LIMITED' }, 429);
    }

    const body = await req.json();
    if (
      !body.audio ||
      typeof body.sessionId !== 'string' ||
      typeof body.clientTurnId !== 'string' ||
      !body.clientTurnId.trim() ||
      body.clientTurnId.length > 200
    ) {
      return corsResponse({ error: 'Missing voice turn fields', errorCode: 'INVALID_REQUEST' }, 400);
    }

    const { data: session, error: sessionError } = await supabase
      .from('voice_sessions')
      .select('id, user_id, status')
      .eq('id', body.sessionId)
      .eq('user_id', user.id)
      .maybeSingle();
    if (sessionError || !session || session.status !== 'active') {
      return corsResponse({ error: 'Voice session unavailable', errorCode: 'SESSION_FORBIDDEN' }, 403);
    }

    const { data: existingTurn, error: existingError } = await supabase
      .from('voice_turns')
      .select('id, user_transcript, user_audio_duration_ms')
      .eq('session_id', body.sessionId)
      .eq('user_id', user.id)
      .eq('client_turn_id', body.clientTurnId)
      .maybeSingle();
    if (existingError) {
      return corsResponse({ error: 'Voice turn unavailable', errorCode: 'TURN_READ_FAILED' }, 500);
    }
    if (existingTurn?.user_transcript) {
      return corsResponse({
        turnId: existingTurn.id,
        text: existingTurn.user_transcript,
        language: body.language || 'zh',
        durationMs: existingTurn.user_audio_duration_ms || 0,
        provider: 'openai',
        model: OPENAI_STT_MODEL,
      });
    }

    // Decode base64 audio
    const audioBytes = base64ToUint8Array(body.audio);
    if (audioBytes.length > MAX_AUDIO_SIZE) {
      return corsResponse({ error: 'Audio too large' }, 400);
    }

    // Call OpenAI Whisper
    const formData = new FormData();
    const audioBlob = new Blob([audioBytes], { type: 'audio/wav' });
    formData.append('file', audioBlob, 'audio.wav');
    formData.append('model', OPENAI_STT_MODEL);
    formData.append('language', body.language || 'zh');
    formData.append('response_format', 'verbose_json');
    if (body.prompt) formData.append('prompt', body.prompt);

    const response = await fetch('https://api.openai.com/v1/audio/transcriptions', {
      method: 'POST',
      headers: { 'Authorization': `Bearer ${OPENAI_API_KEY}` },
      body: formData,
    });

    if (!response.ok) {
      console.error(`Whisper API error: ${response.status}`);
      return corsResponse({ error: 'Transcription failed' }, 500);
    }

    const result = await response.json();
    const transcript = typeof result.text === 'string' ? result.text.trim() : '';
    const providerDurationMs = Number.isFinite(Number(result.duration))
      ? Math.round(Number(result.duration) * 1000)
      : Math.round(audioBytes.length / 32);
    const durationMs = Math.max(0, Math.min(MAX_TURN_DURATION_MS, providerDurationMs));

    if (!transcript) {
      return corsResponse({
        text: '',
        language: body.language || 'zh',
        durationMs: 0,
        provider: 'openai',
        model: OPENAI_STT_MODEL,
      });
    }

    const { data: persistedTurn, error: turnSaveError } = await supabase
      .from('voice_turns')
      .upsert({
        session_id: body.sessionId,
        user_id: user.id,
        client_turn_id: body.clientTurnId,
        user_transcript: transcript,
        transcription_provider: 'openai',
        transcription_model: OPENAI_STT_MODEL,
        user_audio_duration_ms: durationMs,
        status: 'transcribing',
      }, { onConflict: 'session_id,client_turn_id' })
      .select('id')
      .single();
    if (turnSaveError || !persistedTurn) {
      return corsResponse({ error: 'Voice turn could not be saved', errorCode: 'TURN_SAVE_FAILED' }, 500);
    }

    // Track usage
    const { error: usageError } = await supabase.from('voice_usage').insert({
      user_id: user.id,
      session_id: body.sessionId,
      service: 'stt',
      provider: 'openai',
      model: OPENAI_STT_MODEL,
      input_duration_ms: durationMs,
      status: 'success',
    });
    if (usageError) {
      console.error('Voice transcription usage save failed');
    }

    return corsResponse({
      turnId: persistedTurn.id,
      text: transcript,
      language: body.language || 'zh',
      durationMs,
      provider: 'openai',
      model: OPENAI_STT_MODEL,
    });
  } catch {
    console.error('Voice transcription request failed');
    return corsResponse({ error: 'Server error' }, 500);
  }
});

function base64ToUint8Array(base64: string): Uint8Array {
  const binaryString = atob(base64);
  const bytes = new Uint8Array(binaryString.length);
  for (let i = 0; i < binaryString.length; i++) {
    bytes[i] = binaryString.charCodeAt(i);
  }
  return bytes;
}

function corsResponse(body: any, status = 200) {
  return new Response(body ? JSON.stringify(body) : null, {
    status,
    headers: {
      'Content-Type': 'application/json',
      'Access-Control-Allow-Origin': '*',
      'Access-Control-Allow-Methods': 'POST, OPTIONS',
      'Access-Control-Allow-Headers': 'authorization, content-type, x-client-info, apikey',
    },
  });
}
