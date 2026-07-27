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
  errorCode?: 'NOT_CONFIGURED' | 'RATE_LIMITED' | 'AUDIO_TOO_LARGE' | 'NETWORK_ERROR' | 'SPEECH_NOT_DETECTED' | 'SERVER_ERROR';
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

      // Development debug: log normalization metadata
      if (__DEV__) {
        console.log('[Pronunciation] Normalized audio:', {
          mimeType: normalized.mimeType,
          sampleRate: normalized.sampleRate,
          channels: normalized.channels,
          bitsPerSample: normalized.bitsPerSample,
          outputByteSize: audioBuffer.byteLength,
          outputDurationSec: (audioBuffer.byteLength - 44) / (normalized.sampleRate * normalized.channels * (normalized.bitsPerSample / 8)),
        });

        // Debug playback: create blob URL for manual verification
        try {
          const debugBlob = new Blob([audioBuffer], { type: 'audio/wav' });
          const debugUrl = URL.createObjectURL(debugBlob);
          console.log('[Pronunciation] Debug WAV playback URL:', debugUrl);
          // Revoke after 60 seconds
          setTimeout(() => URL.revokeObjectURL(debugUrl), 60000);
        } catch {}
      }
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
      body: {
        audio: base64Audio,
        referenceText: input.referenceText,
        locale: input.locale || 'zh-CN',
        exerciseId: input.exerciseId,
        lessonId: input.lessonId,
        vocabularyId: input.vocabularyId,
        clientAttemptId: input.clientAttemptId,
      },
    });

    if (error) {
      // Parse edge function errors
      if (error.message?.includes('rate limit') || error.message?.includes('429')) {
        return { success: false, error: 'Bạn đã đạt giới hạn luyện phát âm hôm nay. Thử lại sau.', errorCode: 'RATE_LIMITED' };
      }
      if (error.message?.includes('not configured') || error.message?.includes('503')) {
        return { success: false, error: 'Dịch vụ phát âm chưa được cấu hình.', errorCode: 'NOT_CONFIGURED' };
      }
      return { success: false, error: 'Lỗi kết nối. Vui lòng thử lại.', errorCode: 'NETWORK_ERROR' };
    }

    if (!data?.result) {
      if (data?.errorCode === 'SPEECH_NOT_DETECTED') {
        return { success: false, error: 'Chưa nghe rõ giọng nói. Hãy thử nói gần micro hơn.', errorCode: 'SPEECH_NOT_DETECTED' };
      }
      return { success: false, error: 'Không nhận được kết quả. Vui lòng thử lại.', errorCode: 'SERVER_ERROR' };
    }

    return { success: true, result: data.result as PronunciationAssessmentResult };
  } catch (err: any) {
    console.error('Pronunciation assessment error:', err);
    return { success: false, error: 'Lỗi kết nối. Vui lòng kiểm tra mạng và thử lại.', errorCode: 'NETWORK_ERROR' };
  }
}

/**
 * savePronunciationAttempt is now handled server-side by the
 * pronunciation-assess Edge Function. Client no longer persists scores.
 * This function is kept as a no-op for backward compatibility.
 */
export async function savePronunciationAttempt(
  _result: PronunciationAssessmentResult,
  _input: PronunciationAssessmentInput
): Promise<void> {
  // Server-side persistence: Edge Function saves after assessment.
  // Client does NOT write scores directly.
}

function arrayBufferToBase64(buffer: ArrayBuffer): string {
  const bytes = new Uint8Array(buffer);
  let binary = '';
  for (let i = 0; i < bytes.byteLength; i++) {
    binary += String.fromCharCode(bytes[i]);
  }
  return btoa(binary);
}
