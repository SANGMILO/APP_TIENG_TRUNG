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
    if (!body.audio) return corsResponse({ error: 'Missing audio' }, 400);

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

    // Track usage
    await supabase.from('voice_usage').insert({
      user_id: user.id,
      service: 'stt',
      provider: 'openai',
      model: OPENAI_STT_MODEL,
      input_duration_ms: Math.round(audioBytes.length / 32), // rough estimate
      status: 'success',
    });

    return corsResponse({
      text: result.text || '',
      language: body.language || 'zh',
      durationMs: Math.round(audioBytes.length / 32),
      provider: 'openai',
      model: OPENAI_STT_MODEL,
    });
  } catch (err: any) {
    console.error('Voice transcribe error:', err);
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
