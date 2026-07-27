/**
 * Supabase Edge Function: pronunciation-assess
 * 
 * Accepts audio + reference text from authenticated client,
 * calls Azure Speech Pronunciation Assessment API,
 * returns normalized result.
 * 
 * Azure Speech Key is ONLY available server-side.
 * Secrets are read at request time (not module scope) to ensure
 * latest values from Supabase secrets are always used.
 */

import { serve } from 'https://deno.land/std@0.168.0/http/server.ts';
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2.49.4';

const MAX_AUDIO_SIZE = 5 * 1024 * 1024; // 5MB
const DAILY_LIMIT = 20;

interface RequestBody {
  audio: string;           // base64 encoded audio
  referenceText: string;
  pinyin?: string;         // optional pinyin for reference text
  locale: string;
  exerciseId?: string;
  lessonId?: string;
  vocabularyId?: string;
  clientAttemptId: string;
}

serve(async (req) => {
  // CORS headers
  if (req.method === 'OPTIONS') {
    return new Response(null, {
      headers: {
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Methods': 'POST',
        'Access-Control-Allow-Headers': 'authorization, content-type, x-client-info, apikey',
      },
    });
  }

  try {
    // Read secrets at request time (not cached at module level)
    const azureSpeechKey = Deno.env.get('AZURE_SPEECH_KEY')?.trim();
    const azureSpeechRegion = Deno.env.get('AZURE_SPEECH_REGION')?.trim() || 'eastasia';
    const supabaseUrl = Deno.env.get('SUPABASE_URL')!;
    const supabaseServiceRoleKey = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!;

    // Debug log (NEVER log the actual key)
    console.log({
      hasAzureSpeechKey: Boolean(azureSpeechKey),
      azureSpeechRegion,
      hasSupabaseUrl: Boolean(supabaseUrl),
    });

    // Verify authentication
    const authHeader = req.headers.get('Authorization');
    if (!authHeader) {
      return jsonResponse({ error: 'Unauthorized' }, 401);
    }

    const supabase = createClient(supabaseUrl, supabaseServiceRoleKey);
    const token = authHeader.replace('Bearer ', '');
    const { data: { user }, error: authError } = await supabase.auth.getUser(token);

    if (authError || !user) {
      return jsonResponse({ error: 'Unauthorized' }, 401);
    }

    // Check if Azure is configured
    if (!azureSpeechKey) {
      return jsonResponse({
        error: 'Pronunciation service is not configured.',
        errorCode: 'NOT_CONFIGURED',
      }, 503);
    }

    // Parse request
    const body: RequestBody = await req.json();

    if (!body.audio || !body.referenceText || !body.clientAttemptId) {
      return jsonResponse({ error: 'Missing required fields' }, 400);
    }

    // Check audio size
    const audioBytes = base64ToArrayBuffer(body.audio);
    if (audioBytes.byteLength > MAX_AUDIO_SIZE) {
      return jsonResponse({ error: 'Audio too large', errorCode: 'AUDIO_TOO_LARGE' }, 400);
    }

    // Validate audio format (must be WAV after client normalization)
    const audioUint8 = new Uint8Array(audioBytes);
    const detectedFormat = detectAudioContainer(audioUint8);
    const wavMeta = parseWavHeader(audioUint8);
    const signalInfo = computeSignalMetrics(audioUint8, wavMeta);

    console.log({
      detectedContainer: detectedFormat,
      audioByteSize: audioBytes.byteLength,
      ...wavMeta,
      ...signalInfo,
    });

    if (detectedFormat !== 'wav') {
      return jsonResponse({
        error: `Unsupported audio format: ${detectedFormat}. Expected WAV.`,
        errorCode: 'UNSUPPORTED_AUDIO_FORMAT',
      }, 400);
    }

    // Check daily limit
    const limitOk = await checkDailyLimit(supabase, user.id, DAILY_LIMIT);
    if (!limitOk) {
      return jsonResponse({
        error: 'Daily pronunciation limit reached',
        errorCode: 'RATE_LIMITED',
      }, 429);
    }

    // Call Azure Speech Pronunciation Assessment
    const result = await callAzurePronunciation(
      audioBytes,
      body.referenceText,
      body.locale || 'zh-CN',
      azureSpeechKey,
      azureSpeechRegion
    );

    if (!result) {
      return jsonResponse({
        error: 'Internal assessment error',
        errorCode: 'SERVER_ERROR',
      }, 500);
    }

    if (result.__noMatch) {
      const status = result.recognitionStatus;
      if (status === 'InitialSilenceTimeout') {
        return jsonResponse({
          error: 'Chưa phát hiện giọng nói. Hãy nói gần micro hơn.',
          errorCode: 'SPEECH_NOT_DETECTED',
        }, 200);
      }
      if (status === 'BabbleTimeout') {
        return jsonResponse({
          error: 'Âm thanh có nhiều nhiễu. Hãy thử ở nơi yên tĩnh hơn.',
          errorCode: 'SPEECH_NOISE_ONLY',
        }, 200);
      }
      // NoMatch: speech detected but not recognized as target language
      return jsonResponse({
        error: 'Azure nghe thấy âm thanh nhưng chưa nhận dạng được câu tiếng Trung. Hãy thử nói rõ hơn.',
        errorCode: 'AZURE_NO_MATCH',
        recognitionStatus: status,
      }, 200);
    }

    // Track usage
    console.log({ stage: 'saving_usage' });
    const { error: usageError } = await supabase.from('usage_tracking').insert({
      user_id: user.id,
      service: 'azure_speech',
      usage_type: 'pronunciation_assessment',
      amount: 1,
    });
    if (usageError) {
      console.error({ stage: 'saving_usage_failed', code: usageError.code, message: usageError.message, details: usageError.details, hint: usageError.hint });
      // Non-blocking: don't fail assessment because of usage tracking
    } else {
      console.log({ stage: 'usage_saved' });
    }

    // Persist pronunciation attempt server-side (trusted score)
    console.log({ stage: 'saving_attempt' });
    const { data: attemptData, error: attemptError } = await supabase.from('pronunciation_attempts').insert({
      user_id: user.id,
      reference_text: body.referenceText,
      pinyin: body.pinyin ?? null,
      recognized_text: result.recognizedText,
      locale: body.locale || 'zh-CN',
      overall_score: result.overallScore,
      accuracy_score: result.accuracyScore,
      fluency_score: result.fluencyScore,
      completeness_score: result.completenessScore,
      provider: result.provider,
      duration_ms: result.durationMs,
      exercise_id: body.exerciseId || null,
      lesson_id: body.lessonId || null,
      vocabulary_id: body.vocabularyId || null,
      client_attempt_id: body.clientAttemptId,
      feedback: { words: result.words },
    }).select('id').single();

    if (attemptError) {
      console.error({
        stage: 'saving_attempt_failed',
        code: attemptError.code,
        message: attemptError.message,
        details: attemptError.details,
        hint: attemptError.hint,
      });
      return jsonResponse({
        error: 'Failed to save pronunciation result',
        errorCode: 'PERSIST_FAILED',
      }, 500);
    }

    console.log({ stage: 'attempt_saved', attemptId: attemptData.id });

    return jsonResponse({ result });
  } catch (err: any) {
    console.error({
      stage: 'unhandled_exception',
      name: err instanceof Error ? err.name : 'Unknown',
      message: err instanceof Error ? err.message : String(err),
      stack: err instanceof Error ? err.stack?.split('\n').slice(0, 5).join('\n') : undefined,
    });
    return jsonResponse({ error: 'Internal assessment error', errorCode: 'SERVER_ERROR' }, 500);
  }
});

async function callAzurePronunciation(
  audioBuffer: ArrayBuffer,
  referenceText: string,
  locale: string,
  azureSpeechKey: string,
  azureSpeechRegion: string
): Promise<any | null> {
  const endpoint = `https://${azureSpeechRegion}.stt.speech.microsoft.com/speech/recognition/conversation/cognitiveservices/v1`;

  // Pronunciation assessment config
  const pronunciationConfig = {
    ReferenceText: referenceText,
    GradingSystem: 'HundredMark',
    Granularity: 'Word',
    Dimension: 'Comprehensive',
    EnableMiscue: true,
  };

  const configBase64 = utf8ToBase64(JSON.stringify(pronunciationConfig));

  console.log({
    azureEndpoint: endpoint,
    audioByteSize: audioBuffer.byteLength,
    referenceTextLength: referenceText.length,
    locale,
  });

  const response = await fetch(
    `${endpoint}?language=${locale}&format=detailed`,
    {
      method: 'POST',
      headers: {
        'Ocp-Apim-Subscription-Key': azureSpeechKey,
        'Content-Type': 'audio/wav; codecs=audio/pcm; samplerate=16000',
        'Pronunciation-Assessment': configBase64,
        'Accept': 'application/json',
      },
      body: audioBuffer,
    }
  );

  if (!response.ok) {
    const errorText = await response.text();
    console.error('Azure API error:', {
      status: response.status,
      contentType: response.headers.get('content-type'),
      body: errorText.slice(0, 500),
      audioByteSize: audioBuffer.byteLength,
    });
    if (response.status === 401 || response.status === 403) {
      throw new Error('Azure authentication failed');
    }
    return null;
  }

  const data = await response.json();

  // Log safe response metadata
  console.log({
    azureHttpStatus: response.status,
    recognitionStatus: data.RecognitionStatus,
    nBestCount: data.NBest?.length ?? 0,
    offset: data.Offset,
    duration: data.Duration,
  });

  // Check if speech was recognized
  if (data.RecognitionStatus !== 'Success' || !data.NBest?.length) {
    // Return specific error code based on Azure status
    return { __noMatch: true, recognitionStatus: data.RecognitionStatus };
  }

  const best = data.NBest[0];

  console.log({
    stage: 'azure_raw_received',
    recognitionStatus: data.RecognitionStatus,
    hasNBest: Array.isArray(data.NBest),
    nBestCount: data.NBest?.length ?? 0,
    bestKeys: best ? Object.keys(best) : [],
    hasPronunciationAssessment: Boolean(best?.PronunciationAssessment),
  });

  console.log({ stage: 'parsing_scores' });

  // Support BOTH response shapes:
  // Format A (nested): best.PronunciationAssessment.AccuracyScore
  // Format B (flat):   best.AccuracyScore
  const scoreSource = best.PronunciationAssessment ??
    (best.AccuracyScore !== undefined || best.FluencyScore !== undefined ||
     best.CompletenessScore !== undefined || best.PronScore !== undefined
      ? best
      : null);

  if (!scoreSource) {
    console.error({
      stage: 'pronunciation_scores_missing',
      recognitionStatus: data.RecognitionStatus,
      bestKeys: Object.keys(best),
    });
    throw new Error('Azure response missing pronunciation scores');
  }

  const responseShape = best.PronunciationAssessment ? 'nested' : 'flat';

  // Normalize word-level scores (support both nested and flat)
  const words = (best.Words || []).map((w: any) => {
    const wScore = w.PronunciationAssessment ?? w;
    return {
      word: w.Word ?? w.word ?? '',
      accuracyScore: wScore.AccuracyScore ?? wScore.accuracyScore ?? 0,
      errorType: mapErrorType(wScore.ErrorType ?? wScore.errorType),
    };
  });

  const parsedResult = {
    overallScore: Math.round(scoreSource.PronScore ?? scoreSource.PronunciationScore ?? 0),
    accuracyScore: Math.round(scoreSource.AccuracyScore ?? 0),
    fluencyScore: Math.round(scoreSource.FluencyScore ?? 0),
    completenessScore: scoreSource.CompletenessScore != null ? Math.round(scoreSource.CompletenessScore) : null,
    recognizedText: best.Display ?? data.DisplayText ?? best.Lexical ?? '',
    expectedText: referenceText,
    words,
    provider: 'azure',
    durationMs: Math.round((best.Duration || 0) / 10000),
    assessedAt: new Date().toISOString(),
  };

  console.log({
    stage: 'scores_parsed',
    responseShape,
    recognizedTextPresent: Boolean(parsedResult.recognizedText),
    overallScore: parsedResult.overallScore,
    accuracyScore: parsedResult.accuracyScore,
    fluencyScore: parsedResult.fluencyScore,
    completenessScore: parsedResult.completenessScore,
  });

  return parsedResult;
}

function mapErrorType(azureType?: string): string {
  switch (azureType) {
    case 'None': return 'None';
    case 'Mispronunciation': return 'Mispronunciation';
    case 'Omission': return 'Omission';
    case 'Insertion': return 'Insertion';
    default: return 'Unknown';
  }
}

async function checkDailyLimit(supabase: any, userId: string, limit: number): Promise<boolean> {
  const today = new Date();
  today.setHours(0, 0, 0, 0);

  const { count } = await supabase
    .from('pronunciation_attempts')
    .select('*', { count: 'exact', head: true })
    .eq('user_id', userId)
    .gte('created_at', today.toISOString());

  return (count ?? 0) < limit;
}

/**
 * Parse WAV file header to extract audio metadata
 */
function parseWavHeader(bytes: Uint8Array): Record<string, any> {
  if (bytes.length < 44) return { error: 'too_short' };
  const view = new DataView(bytes.buffer, bytes.byteOffset, bytes.byteLength);
  try {
    return {
      audioFormat: view.getUint16(20, true),    // 1 = PCM
      channels: view.getUint16(22, true),
      sampleRate: view.getUint32(24, true),
      byteRate: view.getUint32(28, true),
      bitsPerSample: view.getUint16(34, true),
      dataSize: view.getUint32(40, true),
      durationSeconds: +(view.getUint32(40, true) / view.getUint32(28, true)).toFixed(2),
    };
  } catch {
    return { error: 'parse_failed' };
  }
}

/**
 * Compute signal metrics from PCM16 WAV data
 */
function computeSignalMetrics(bytes: Uint8Array, wavMeta: Record<string, any>): Record<string, any> {
  if (wavMeta.error || bytes.length < 46) return {};
  const dataStart = 44;
  const dataEnd = Math.min(bytes.length, dataStart + (wavMeta.dataSize || bytes.length - 44));
  const view = new DataView(bytes.buffer, bytes.byteOffset, bytes.byteLength);
  
  let peak = 0;
  let sumSquares = 0;
  let zeroCount = 0;
  let sampleCount = 0;

  for (let i = dataStart; i + 1 < dataEnd; i += 2) {
    const sample = view.getInt16(i, true);
    const normalized = sample / 32768;
    const abs = Math.abs(normalized);
    if (abs > peak) peak = abs;
    sumSquares += normalized * normalized;
    if (sample === 0) zeroCount++;
    sampleCount++;
  }

  if (sampleCount === 0) return { peakAmplitude: 0, rmsAmplitude: 0, zeroSampleRatio: 1 };

  return {
    peakAmplitude: +peak.toFixed(4),
    rmsAmplitude: +Math.sqrt(sumSquares / sampleCount).toFixed(4),
    zeroSampleRatio: +(zeroCount / sampleCount).toFixed(4),
    sampleCount,
  };
}

/**
 * Detect audio container format from magic bytes
 */
function detectAudioContainer(bytes: Uint8Array): string {
  if (bytes.length < 4) return 'unknown';
  if (bytes[0] === 0x52 && bytes[1] === 0x49 && bytes[2] === 0x46 && bytes[3] === 0x46) return 'wav';
  if (bytes[0] === 0x4F && bytes[1] === 0x67 && bytes[2] === 0x67 && bytes[3] === 0x53) return 'ogg';
  if (bytes[0] === 0x1A && bytes[1] === 0x45 && bytes[2] === 0xDF && bytes[3] === 0xA3) return 'webm';
  return 'unknown';
}

/**
 * Encode a UTF-8 string to Base64 (supports Unicode/Chinese characters)
 */
function utf8ToBase64(value: string): string {
  const bytes = new TextEncoder().encode(value);
  let binary = '';
  const chunkSize = 0x8000;
  for (let i = 0; i < bytes.length; i += chunkSize) {
    binary += String.fromCharCode(...bytes.subarray(i, i + chunkSize));
  }
  return btoa(binary);
}

function base64ToArrayBuffer(base64: string): ArrayBuffer {
  const binaryString = atob(base64);
  const bytes = new Uint8Array(binaryString.length);
  for (let i = 0; i < binaryString.length; i++) {
    bytes[i] = binaryString.charCodeAt(i);
  }
  return bytes.buffer;
}

function jsonResponse(body: any, status = 200) {
  return new Response(JSON.stringify(body), {
    status,
    headers: {
      'Content-Type': 'application/json',
      'Access-Control-Allow-Origin': '*',
    },
  });
}
