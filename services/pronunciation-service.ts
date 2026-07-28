/**
 * Pronunciation Service - Client-side orchestrator
 * Sends recorded audio to backend (Edge Function) for assessment
 * NEVER touches Azure/Speech keys directly
 */

import { supabase } from '@/lib/supabase';
import { PronunciationAssessmentResult, PronunciationAssessmentInput } from '@/lib/speech';
import { normalizeAudioForPronunciation } from '@/utils/audio-normalize';

const MAX_AUDIO_SIZE_BYTES = 5 * 1024 * 1024; // 5MB
const MAX_DURATION_MS = 30_000; // 30 seconds

export interface AssessmentRequestResult {
  success: boolean;
  result?: PronunciationAssessmentResult;
  error?: string;
  errorCode?:
    | 'NOT_CONFIGURED'
    | 'RATE_LIMITED'
    | 'AUDIO_TOO_LARGE'
    | 'UNSUPPORTED_AUDIO_FORMAT'
    | 'SPEECH_NOT_DETECTED'
    | 'SPEECH_NOISE_ONLY'
    | 'AZURE_NO_MATCH'
    | 'INVALID_REFERENCE'
    | 'PERSIST_FAILED'
    | 'NETWORK_ERROR'
    | 'SERVER_ERROR';
}

const UUID_PATTERN = /^[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/i;

export function buildAssessmentFunctionBody(
  input: PronunciationAssessmentInput,
  base64Audio: string,
): Record<string, unknown> {
  const exerciseId = validUuid(input.exerciseId);
  const lessonId = validUuid(input.lessonId);
  const vocabularyId = validUuid(input.vocabularyId);

  return {
    audio: base64Audio,
    referenceText: input.referenceText,
    pinyin: typeof input.pinyin === 'string' ? input.pinyin : '',
    locale: input.locale || 'zh-CN',
    clientAttemptId: input.clientAttemptId,
    ...(exerciseId ? { exerciseId } : {}),
    ...(lessonId ? { lessonId } : {}),
    ...(vocabularyId ? { vocabularyId } : {}),
  };
}

/**
 * Submit audio for pronunciation assessment via backend
 */
export async function assessPronunciation(
  input: PronunciationAssessmentInput
): Promise<AssessmentRequestResult> {
  // Client-side validation
  const audioSize = input.audio instanceof Blob ? input.audio.size : input.audio.byteLength;
  if (audioSize > MAX_AUDIO_SIZE_BYTES) {
    return { success: false, error: 'Audio quá lớn. Vui lòng thử lại với recording ngắn hơn.', errorCode: 'AUDIO_TOO_LARGE' };
  }

  if (audioSize === 0) {
    return { success: false, error: 'Không có audio. Vui lòng thu âm lại.', errorCode: 'AUDIO_TOO_LARGE' };
  }

  try {
    // Normalize audio to WAV PCM16 16kHz mono for Azure compatibility
    let audioBuffer: ArrayBuffer;
    if (input.audioUri) {
      const normalized = await normalizeAudioForPronunciation(input.audioUri);
      audioBuffer = normalized.buffer;

    } else if (input.audio instanceof Blob) {
      const tempUrl = URL.createObjectURL(input.audio);
      try {
        const normalized = await normalizeAudioForPronunciation(tempUrl);
        audioBuffer = normalized.buffer;
      } finally {
        URL.revokeObjectURL(tempUrl);
      }
    } else {
      audioBuffer = input.audio;
    }

    const base64Audio = arrayBufferToBase64(audioBuffer);

    // Call Supabase Edge Function
    const { data, error } = await supabase.functions.invoke('pronunciation-assess', {
      body: buildAssessmentFunctionBody(input, base64Audio),
    });

    if (error) {
      const details = await readFunctionError(error);
      if (details.errorCode === 'RATE_LIMITED' || details.status === 429) {
        return { success: false, error: 'Bạn đã đạt giới hạn luyện phát âm hôm nay. Thử lại sau.', errorCode: 'RATE_LIMITED' };
      }
      if (details.errorCode === 'NOT_CONFIGURED' || details.status === 503) {
        return { success: false, error: 'Dịch vụ phát âm chưa được cấu hình.', errorCode: 'NOT_CONFIGURED' };
      }
      if (details.errorCode === 'PERSIST_FAILED') {
        return { success: false, error: 'Kết quả chưa được lưu. Vui lòng thử lại.', errorCode: 'PERSIST_FAILED' };
      }
      if (details.errorCode === 'INVALID_REFERENCE') {
        return { success: false, error: 'Nội dung luyện phát âm không còn khả dụng.', errorCode: 'INVALID_REFERENCE' };
      }
      return { success: false, error: 'Lỗi kết nối. Vui lòng thử lại.', errorCode: 'NETWORK_ERROR' };
    }

    if (!data?.result) {
      const errorCode = typeof data?.errorCode === 'string' ? data.errorCode : 'SERVER_ERROR';
      if (errorCode === 'SPEECH_NOT_DETECTED') {
        return { success: false, error: data?.error || 'Chưa nghe rõ giọng nói. Hãy thử nói gần micro hơn.', errorCode };
      }
      if (errorCode === 'SPEECH_NOISE_ONLY' || errorCode === 'AZURE_NO_MATCH') {
        return {
          success: false,
          error: data?.error || 'Chưa nhận dạng được câu nói. Hãy thử lại ở nơi yên tĩnh.',
          errorCode,
        };
      }
      return { success: false, error: 'Không nhận được kết quả. Vui lòng thử lại.', errorCode: 'SERVER_ERROR' };
    }

    const result = normalizeAssessmentResult(data.result);
    if (!result) {
      return { success: false, error: 'Kết quả chấm phát âm không hợp lệ.', errorCode: 'SERVER_ERROR' };
    }

    return { success: true, result };
  } catch {
    return { success: false, error: 'Lỗi kết nối. Vui lòng kiểm tra mạng và thử lại.', errorCode: 'NETWORK_ERROR' };
  }
}

function arrayBufferToBase64(buffer: ArrayBuffer): string {
  const bytes = new Uint8Array(buffer);
  let binary = '';
  for (let i = 0; i < bytes.byteLength; i++) {
    binary += String.fromCharCode(bytes[i]);
  }
  return btoa(binary);
}

function validUuid(value: unknown): string | null {
  return typeof value === 'string' && UUID_PATTERN.test(value) ? value : null;
}

function normalizeAssessmentResult(value: any): PronunciationAssessmentResult | null {
  const scores = [
    Number(value?.overallScore),
    Number(value?.accuracyScore),
    Number(value?.fluencyScore),
  ];
  const completeness = value?.completenessScore === null
    ? null
    : Number(value?.completenessScore);
  if (
    scores.some(score => !Number.isFinite(score) || score < 0 || score > 100)
    || (completeness !== null && (!Number.isFinite(completeness) || completeness < 0 || completeness > 100))
    || typeof value?.recognizedText !== 'string'
    || typeof value?.expectedText !== 'string'
    || !['azure', 'google', 'openai'].includes(value?.provider)
  ) {
    return null;
  }

  const words = Array.isArray(value.words)
    ? value.words
        .filter((word: any) => (
          typeof word?.word === 'string'
          && Number.isFinite(Number(word?.accuracyScore))
          && Number(word.accuracyScore) >= 0
          && Number(word.accuracyScore) <= 100
        ))
        .map((word: any) => ({
          word: word.word,
          accuracyScore: Number(word.accuracyScore),
          errorType: ['None', 'Mispronunciation', 'Omission', 'Insertion', 'Unknown'].includes(word.errorType)
            ? word.errorType
            : 'Unknown',
        }))
    : [];

  return {
    overallScore: scores[0],
    accuracyScore: scores[1],
    fluencyScore: scores[2],
    completenessScore: completeness,
    recognizedText: value.recognizedText,
    expectedText: value.expectedText,
    words,
    provider: value.provider,
    durationMs: Number.isFinite(Number(value.durationMs)) ? Math.max(0, Number(value.durationMs)) : 0,
    assessedAt: typeof value.assessedAt === 'string' ? value.assessedAt : new Date().toISOString(),
  };
}

async function readFunctionError(error: any): Promise<{ status?: number; errorCode?: string }> {
  const response = error?.context;
  if (!response || typeof response.clone !== 'function') return {};
  try {
    const payload = await response.clone().json();
    return {
      status: response.status,
      errorCode: typeof payload?.errorCode === 'string' ? payload.errorCode : undefined,
    };
  } catch {
    return { status: response.status };
  }
}
