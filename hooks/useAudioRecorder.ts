/**
 * useAudioRecorder hook
 * Manages microphone recording with state machine pattern
 * Works on Web + Android + iOS via expo-audio
 */

import { useState, useRef, useCallback, useEffect } from 'react';
import {
  AudioModule,
  AudioQuality,
  IOSOutputFormat,
  setAudioModeAsync,
  useAudioPlayer,
  useAudioRecorder as useExpoAudioRecorder,
  useAudioStream,
  type AudioStreamBuffer,
  type RecordingOptions,
} from 'expo-audio';
import { Platform } from 'react-native';
import { RecordingState } from '@/lib/speech';
import {
  encodePcm16ChunksAsWav,
  type Pcm16Chunk,
  wavArrayBufferToDataUri,
} from '@/utils/pcm-wav';

const SPEECH_RECORDING_OPTIONS: RecordingOptions = {
  extension: '.wav',
  sampleRate: 16000,
  numberOfChannels: 1,
  bitRate: 256000,
  android: {
    extension: '.m4a',
    outputFormat: 'mpeg4',
    audioEncoder: 'aac',
    sampleRate: 16000,
  },
  ios: {
    extension: '.wav',
    outputFormat: IOSOutputFormat.LINEARPCM,
    audioQuality: AudioQuality.HIGH,
    sampleRate: 16000,
    linearPCMBitDepth: 16,
    linearPCMIsBigEndian: false,
    linearPCMIsFloat: false,
  },
  web: {
    mimeType: 'audio/webm',
    bitsPerSecond: 128000,
  },
};

export interface RecorderResult {
  uri: string;
  durationMs: number;
}

interface UseAudioRecorderOptions {
  maxDurationMs?: number; // Default 15000 (15s)
  onRecordingComplete?: (result: RecorderResult) => void;
}

interface UseAudioRecorderReturn {
  state: RecordingState;
  durationMs: number;
  recordingUri: string | null;
  permissionDenied: boolean;

  startRecording: () => Promise<void>;
  stopRecording: () => Promise<RecorderResult | null>;
  cancelRecording: () => Promise<void>;
  playRecording: () => Promise<void>;
  stopPlayback: () => Promise<void>;
  reset: () => void;
  error: string | null;
}

export function useAudioRecorder(options: UseAudioRecorderOptions = {}): UseAudioRecorderReturn {
  const { maxDurationMs = 15_000, onRecordingComplete } = options;

  const [state, setState] = useState<RecordingState>('idle');
  const [durationMs, setDurationMs] = useState(0);
  const [recordingUri, setRecordingUri] = useState<string | null>(null);
  const [permissionDenied, setPermissionDenied] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const recorder = useExpoAudioRecorder(SPEECH_RECORDING_OPTIONS);
  const playbackPlayer = useAudioPlayer(null);
  const recordingActiveRef = useRef(false);
  const pcmChunksRef = useRef<Pcm16Chunk[]>([]);
  const capturePcmBuffer = useCallback((buffer: AudioStreamBuffer) => {
    pcmChunksRef.current.push({
      data: buffer.data.slice(0),
      sampleRate: buffer.sampleRate,
      channels: buffer.channels,
    });
  }, []);
  const { stream: pcmStream } = useAudioStream({
    sampleRate: 16000,
    channels: 1,
    encoding: 'int16',
    onBuffer: capturePcmBuffer,
  });
  const stopRecordingRef = useRef<() => Promise<RecorderResult | null>>(
    async () => null,
  );
  const timerRef = useRef<ReturnType<typeof setInterval> | null>(null);
  const startTimeRef = useRef<number>(0);

  const cleanup = useCallback(async () => {
    if (timerRef.current) {
      clearInterval(timerRef.current);
      timerRef.current = null;
    }
    if (recordingActiveRef.current) {
      try {
        if (Platform.OS === 'web') {
          await recorder.stop();
        } else {
          pcmStream.stop();
        }
      } catch {}
      recordingActiveRef.current = false;
    }
    playbackPlayer.pause();
    try {
      await setAudioModeAsync({
        allowsRecording: false,
        playsInSilentMode: true,
      });
    } catch {}
  }, [pcmStream, playbackPlayer, recorder]);

  // Cleanup on unmount
  useEffect(() => {
    return () => {
      void cleanup();
    };
  }, [cleanup]);

  const requestPermission = useCallback(async (): Promise<boolean> => {
    setState('requesting_permission');
    try {
      const permission = await AudioModule.requestRecordingPermissionsAsync();
      if (!permission.granted) {
        setPermissionDenied(true);
        setState('error');
        setError('Cần quyền truy cập micro để luyện phát âm.');
        return false;
      }
      setPermissionDenied(false);
      return true;
    } catch (err) {
      setState('error');
      setError('Không thể yêu cầu quyền micro.');
      return false;
    }
  }, []);

  const startRecording = useCallback(async () => {
    setError(null);

    const hasPermission = await requestPermission();
    if (!hasPermission) return;

    try {
      // Configure audio mode for recording
      await setAudioModeAsync({
        allowsRecording: true,
        playsInSilentMode: true,
      });

      if (Platform.OS === 'web') {
        await recorder.prepareToRecordAsync();
        recorder.record();
      } else {
        pcmChunksRef.current = [];
        await pcmStream.start();
      }
      recordingActiveRef.current = true;
      startTimeRef.current = Date.now();
      setDurationMs(0);
      setRecordingUri(null);
      setState('recording');

      // Duration timer
      timerRef.current = setInterval(() => {
        const elapsed = Date.now() - startTimeRef.current;
        setDurationMs(elapsed);

        // Auto-stop at max duration
        if (elapsed >= maxDurationMs) {
          void stopRecordingRef.current();
        }
      }, 100);
    } catch {
      await cleanup();
      setState('error');
      setError('Không thể bắt đầu thu âm. Vui lòng thử lại.');
    }
  }, [cleanup, maxDurationMs, pcmStream, recorder, requestPermission]);

  const stopRecording = useCallback(async (): Promise<RecorderResult | null> => {
    if (timerRef.current) {
      clearInterval(timerRef.current);
      timerRef.current = null;
    }

    if (!recordingActiveRef.current) {
      setState('idle');
      return null;
    }

    try {
      let uri: string | null;
      if (Platform.OS === 'web') {
        await recorder.stop();
        uri = recorder.uri;
      } else {
        pcmStream.stop();
        uri = pcmChunksRef.current.length > 0
          ? wavArrayBufferToDataUri(
              encodePcm16ChunksAsWav(pcmChunksRef.current),
            )
          : null;
      }
      const finalDuration = Date.now() - startTimeRef.current;

      recordingActiveRef.current = false;

      // Reset audio mode
      await setAudioModeAsync({
        allowsRecording: false,
        playsInSilentMode: true,
      });

      if (!uri) {
        setState('error');
        setError('Không có dữ liệu audio. Vui lòng thử lại.');
        return null;
      }

      // Check minimum duration (500ms)
      if (finalDuration < 500) {
        setState('error');
        setError('Recording quá ngắn. Hãy đọc chậm và rõ hơn.');
        return null;
      }

      setRecordingUri(uri);
      setDurationMs(finalDuration);
      setState('recorded');

      const result: RecorderResult = { uri, durationMs: finalDuration };
      onRecordingComplete?.(result);
      return result;
    } catch {
      await cleanup();
      setState('error');
      setError('Lỗi khi dừng thu âm.');
      return null;
    }
  }, [cleanup, onRecordingComplete, pcmStream, recorder]);

  stopRecordingRef.current = stopRecording;

  const cancelRecording = useCallback(async () => {
    await cleanup();
    pcmChunksRef.current = [];
    setRecordingUri(null);
    setDurationMs(0);
    setState('idle');
  }, [cleanup]);

  const playRecording = useCallback(async () => {
    if (!recordingUri) return;

    try {
      playbackPlayer.replace(recordingUri);
      playbackPlayer.play();
    } catch {
      setState('error');
      setError('Không thể phát lại bản thu. Vui lòng thử lại.');
    }
  }, [playbackPlayer, recordingUri]);

  const stopPlayback = useCallback(async () => {
    playbackPlayer.pause();
    try {
      await playbackPlayer.seekTo(0);
    } catch {}
  }, [playbackPlayer]);

  const reset = useCallback(() => {
    void cleanup();
    pcmChunksRef.current = [];
    setRecordingUri(null);
    setDurationMs(0);
    setError(null);
    setState('idle');
  }, [cleanup]);

  return {
    state,
    durationMs,
    recordingUri,
    permissionDenied,
    startRecording,
    stopRecording,
    cancelRecording,
    playRecording,
    stopPlayback,
    reset,
    error,
  };
}
