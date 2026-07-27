/**
 * Audio Normalization for Pronunciation Assessment
 * Converts any recorded audio to WAV PCM16 16kHz mono
 * Required because:
 * - Web MediaRecorder outputs WebM/Opus
 * - Azure Speech requires WAV PCM or supported format
 * - iOS/Android expo-av already output WAV, but we validate anyway
 */

import { Platform } from 'react-native';

export interface NormalizedAudio {
  buffer: ArrayBuffer;
  mimeType: string;
  sampleRate: number;
  channels: number;
  bitsPerSample: number;
}

/**
 * Normalize recorded audio blob to WAV PCM16 16kHz mono
 * On Web: decodes WebM via AudioContext, re-encodes as WAV
 * On Native: validates existing WAV format
 */
export async function normalizeAudioForPronunciation(
  audioUri: string
): Promise<NormalizedAudio> {
  const response = await fetch(audioUri);
  const blob = await response.blob();
  const arrayBuffer = await blob.arrayBuffer();

  // Check if already valid WAV
  const bytes = new Uint8Array(arrayBuffer);
  const container = detectAudioContainer(bytes);

  if (Platform.OS !== 'web' && container === 'wav') {
    // Native already outputs WAV PCM - use as-is
    return {
      buffer: arrayBuffer,
      mimeType: 'audio/wav',
      sampleRate: 16000,
      channels: 1,
      bitsPerSample: 16,
    };
  }

  if (Platform.OS === 'web') {
    // Web: decode and re-encode as WAV PCM16 16kHz mono
    return await webDecodeAndEncodeWav(arrayBuffer);
  }

  // Native non-WAV (unlikely with current config, but handle)
  // Try to pass through - Azure may accept some formats
  return {
    buffer: arrayBuffer,
    mimeType: blob.type || 'audio/wav',
    sampleRate: 16000,
    channels: 1,
    bitsPerSample: 16,
  };
}

/**
 * Web-specific: Decode any audio format via AudioContext → encode WAV
 */
async function webDecodeAndEncodeWav(inputBuffer: ArrayBuffer): Promise<NormalizedAudio> {
  const targetSampleRate = 16000;
  const targetChannels = 1;

  // Decode the input audio (WebM, Opus, etc.)
  const audioContext = new (window.AudioContext || (window as any).webkitAudioContext)({
    sampleRate: targetSampleRate,
  });

  let audioBuffer: AudioBuffer;
  try {
    audioBuffer = await audioContext.decodeAudioData(inputBuffer.slice(0));
  } catch (err) {
    await audioContext.close();
    throw new Error(`Failed to decode audio: ${err}`);
  }

  // Log source metadata for debugging
  if (typeof __DEV__ !== 'undefined' && __DEV__) {
    console.log('[AudioNormalize] Source:', {
      sourceSampleRate: audioBuffer.sampleRate,
      sourceDuration: audioBuffer.duration,
      sourceChannels: audioBuffer.numberOfChannels,
      sourceFrames: audioBuffer.length,
    });
  }

  // Get mono channel data (mix down if stereo)
  let samples: Float32Array;
  if (audioBuffer.numberOfChannels === 1) {
    samples = audioBuffer.getChannelData(0);
  } else {
    // Mix to mono
    const left = audioBuffer.getChannelData(0);
    const right = audioBuffer.numberOfChannels > 1 ? audioBuffer.getChannelData(1) : left;
    samples = new Float32Array(left.length);
    for (let i = 0; i < left.length; i++) {
      samples[i] = (left[i] + right[i]) / 2;
    }
  }

  // Note: AudioContext was created with sampleRate=16000,
  // so decodeAudioData should already resample to 16kHz.
  // But if it didn't (some browsers), do manual resample.
  let finalSamples = samples;
  if (audioBuffer.sampleRate !== targetSampleRate) {
    finalSamples = resample(samples, audioBuffer.sampleRate, targetSampleRate);
  }

  const outputDuration = finalSamples.length / targetSampleRate;

  if (typeof __DEV__ !== 'undefined' && __DEV__) {
    // Compute signal metrics
    let peak = 0;
    let sumSquares = 0;
    let zeroCount = 0;
    for (let i = 0; i < finalSamples.length; i++) {
      const abs = Math.abs(finalSamples[i]);
      if (abs > peak) peak = abs;
      sumSquares += finalSamples[i] * finalSamples[i];
      if (finalSamples[i] === 0) zeroCount++;
    }
    const rms = Math.sqrt(sumSquares / finalSamples.length);
    console.log('[AudioNormalize] Output:', {
      outputSampleRate: targetSampleRate,
      outputDuration,
      outputChannels: targetChannels,
      outputFrames: finalSamples.length,
      peakAmplitude: peak.toFixed(4),
      rmsAmplitude: rms.toFixed(4),
      zeroSampleRatio: (zeroCount / finalSamples.length).toFixed(4),
    });
  }

  // Encode as WAV PCM16
  const wavBuffer = encodeWavPCM16(finalSamples, targetSampleRate, targetChannels);

  await audioContext.close();

  return {
    buffer: wavBuffer,
    mimeType: 'audio/wav',
    sampleRate: targetSampleRate,
    channels: targetChannels,
    bitsPerSample: 16,
  };
}

/**
 * Simple linear resampling
 */
function resample(samples: Float32Array, fromRate: number, toRate: number): Float32Array {
  const ratio = fromRate / toRate;
  const newLength = Math.round(samples.length / ratio);
  const output = new Float32Array(newLength);

  for (let i = 0; i < newLength; i++) {
    const srcIndex = i * ratio;
    const low = Math.floor(srcIndex);
    const high = Math.min(low + 1, samples.length - 1);
    const frac = srcIndex - low;
    output[i] = samples[low] * (1 - frac) + samples[high] * frac;
  }

  return output;
}

/**
 * Encode Float32 PCM samples as RIFF WAV PCM16
 */
function encodeWavPCM16(samples: Float32Array, sampleRate: number, channels: number): ArrayBuffer {
  const bitsPerSample = 16;
  const bytesPerSample = bitsPerSample / 8;
  const dataLength = samples.length * bytesPerSample;
  const headerLength = 44;
  const totalLength = headerLength + dataLength;

  const buffer = new ArrayBuffer(totalLength);
  const view = new DataView(buffer);

  // RIFF header
  writeString(view, 0, 'RIFF');
  view.setUint32(4, totalLength - 8, true);
  writeString(view, 8, 'WAVE');

  // fmt chunk
  writeString(view, 12, 'fmt ');
  view.setUint32(16, 16, true);              // chunk size
  view.setUint16(20, 1, true);               // PCM format
  view.setUint16(22, channels, true);        // channels
  view.setUint32(24, sampleRate, true);      // sample rate
  view.setUint32(28, sampleRate * channels * bytesPerSample, true); // byte rate
  view.setUint16(32, channels * bytesPerSample, true); // block align
  view.setUint16(34, bitsPerSample, true);   // bits per sample

  // data chunk
  writeString(view, 36, 'data');
  view.setUint32(40, dataLength, true);

  // PCM samples (float32 → int16)
  let offset = 44;
  for (let i = 0; i < samples.length; i++) {
    const s = Math.max(-1, Math.min(1, samples[i]));
    const val = s < 0 ? s * 0x8000 : s * 0x7FFF;
    view.setInt16(offset, val, true);
    offset += 2;
  }

  return buffer;
}

function writeString(view: DataView, offset: number, str: string) {
  for (let i = 0; i < str.length; i++) {
    view.setUint8(offset + i, str.charCodeAt(i));
  }
}

/**
 * Detect audio container format from magic bytes
 */
export function detectAudioContainer(bytes: Uint8Array): 'wav' | 'ogg' | 'webm' | 'unknown' {
  if (bytes.length < 4) return 'unknown';
  if (bytes[0] === 0x52 && bytes[1] === 0x49 && bytes[2] === 0x46 && bytes[3] === 0x46) return 'wav';
  if (bytes[0] === 0x4F && bytes[1] === 0x67 && bytes[2] === 0x67 && bytes[3] === 0x53) return 'ogg';
  if (bytes[0] === 0x1A && bytes[1] === 0x45 && bytes[2] === 0xDF && bytes[3] === 0xA3) return 'webm';
  return 'unknown';
}
