/**
 * Supabase Edge Function: voice-synthesize
 * Text-to-Speech via OpenAI TTS API
 * Server-side only - API key never exposed
 */

import { serve } from 'https://deno.land/std@0.168.0/http/server.ts';
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2.49.4';

const OPENAI_API_KEY = Deno.env.get('OPENAI_API_KEY');
const OPENAI_TTS_MODEL = Deno.env.get('OPENAI_TTS_MODEL') || 'tts-1';
const OPENAI_TTS_VOICE = Deno.env.get('OPENAI_TTS_VOICE') || 'alloy';
const SUPABASE_URL = Deno.env.get('SUPABASE_URL')!;
const SUPABASE_SERVICE_ROLE_KEY = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!;

const MAX_TEXT_LENGTH = 4096;

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

    if (!OPENAI_API_KEY) {
      return corsResponse({ error: 'TTS not configured', errorCode: 'NOT_CONFIGURED' }, 503);
    }

    const body = await req.json();
    if (
      typeof body.sessionId !== 'string' ||
      typeof body.turnId !== 'string' ||
      typeof body.assistantMessageId !== 'string'
    ) {
      return corsResponse({ error: 'Missing voice turn fields', errorCode: 'INVALID_REQUEST' }, 400);
    }

    const { data: session, error: sessionError } = await supabase
      .from('voice_sessions')
      .select('id, user_id, conversation_id, status')
      .eq('id', body.sessionId)
      .eq('user_id', user.id)
      .maybeSingle();
    if (sessionError || !session || session.status !== 'active') {
      return corsResponse({ error: 'Voice session unavailable', errorCode: 'SESSION_FORBIDDEN' }, 403);
    }

    const { data: turn, error: turnError } = await supabase
      .from('voice_turns')
      .select('id')
      .eq('id', body.turnId)
      .eq('session_id', body.sessionId)
      .eq('user_id', user.id)
      .maybeSingle();
    if (turnError || !turn) {
      return corsResponse({ error: 'Voice turn unavailable', errorCode: 'TURN_FORBIDDEN' }, 403);
    }

    const { data: assistantMessage, error: messageError } = await supabase
      .from('ai_messages')
      .select('id, conversation_id, structured_data')
      .eq('id', body.assistantMessageId)
      .eq('conversation_id', session.conversation_id)
      .eq('user_id', user.id)
      .eq('role', 'assistant')
      .eq('status', 'completed')
      .maybeSingle();
    const text = assistantMessage?.structured_data?.reply?.chinese;
    if (messageError || !assistantMessage || typeof text !== 'string' || !text.trim() || text.length > MAX_TEXT_LENGTH) {
      return corsResponse({ error: 'Invalid tutor response', errorCode: 'MESSAGE_FORBIDDEN' }, 403);
    }

    // Call OpenAI TTS
    const voice = body.voice || OPENAI_TTS_VOICE;
    const speed = body.speed || 1.0;

    const response = await fetch('https://api.openai.com/v1/audio/speech', {
      method: 'POST',
      headers: {
        'Authorization': `Bearer ${OPENAI_API_KEY}`,
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        model: OPENAI_TTS_MODEL,
        input: text,
        voice,
        speed: Math.max(0.5, Math.min(2.0, speed)),
        response_format: 'mp3',
      }),
    });

    if (!response.ok) {
      console.error(`TTS API error: ${response.status}`);
      return corsResponse({ error: 'TTS failed' }, 500);
    }

    // Get audio as base64
    const audioBuffer = await response.arrayBuffer();
    const base64Audio = uint8ArrayToBase64(new Uint8Array(audioBuffer));
    const durationMs = Math.max(0, Math.min(60000, Math.round(text.length * 150)));

    const { error: turnSaveError } = await supabase
      .from('voice_turns')
      .update({
        assistant_message_id: assistantMessage.id,
        assistant_transcript: text,
        tts_provider: 'openai',
        tts_model: OPENAI_TTS_MODEL,
        tts_voice: voice,
        assistant_audio_duration_ms: durationMs,
        status: 'completed',
      })
      .eq('id', turn.id)
      .eq('user_id', user.id);
    if (turnSaveError) {
      return corsResponse({ error: 'Voice turn could not be saved', errorCode: 'TURN_SAVE_FAILED' }, 500);
    }

    // Track usage
    const { error: usageError } = await supabase.from('voice_usage').insert({
      user_id: user.id,
      session_id: body.sessionId,
      service: 'tts',
      provider: 'openai',
      model: OPENAI_TTS_MODEL,
      characters_processed: text.length,
      output_duration_ms: durationMs,
      status: 'success',
    });
    if (usageError) {
      console.error('Voice synthesis usage save failed');
    }

    return corsResponse({
      audio: base64Audio,
      mimeType: 'audio/mpeg',
      provider: 'openai',
      model: OPENAI_TTS_MODEL,
      voice,
      durationMs,
      turnId: turn.id,
    });
  } catch {
    console.error('Voice synthesis request failed');
    return corsResponse({ error: 'Server error' }, 500);
  }
});

function uint8ArrayToBase64(bytes: Uint8Array): string {
  let binary = '';
  for (let i = 0; i < bytes.length; i++) {
    binary += String.fromCharCode(bytes[i]);
  }
  return btoa(binary);
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
