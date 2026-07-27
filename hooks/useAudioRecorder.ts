/**
 * useAudioRecorder hook
 * Manages microphone recording with state machine pattern
 * Works on Web + Android + iOS via expo-av
 */

import { useState, useRef, useCallback, useEffect } from 'react';
import { Audio } from 'expo-av';
import { Platform } from 'react-native';
import { RecordingState } from '@/lib/speech';

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

  const recordingRef = useRef<Audio.Recording | null>(null);
  const playbackRef = useRef<Audio.Sound | null>(null);
  const timerRef = useRef<ReturnType<typeof setInterval> | null>(null);
  const startTimeRef = useRef<number>(0);

  // Cleanup on unmount
  useEffect(() => {
    return () => {
      cleanup();
    };
  }, []);

  const cleanup = useCallback(async () => {
    if (timerRef.current) {
      clearInterval(timerRef.current);
      timerRef.current = null;
    }
    if (recordingRef.current) {
      try {
        await recordingRef.current.stopAndUnloadAsync();
      } catch {}
      recordingRef.current = null;
    }
    if (playbackRef.current) {
      try {
        await playbackRef.current.unloadAsync();
      } catch {}
      playbackRef.current = null;
    }
  }, []);

  const requestPermission = useCallback(async (): Promise<boolean> => {
    setState('requesting_permission');
    try {
      const { status } = await Audio.requestPermissionsAsync();
      if (status !== 'granted') {
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
      await Audio.setAudioModeAsync({
        allowsRecordingIOS: true,
        playsInSilentModeIOS: true,
      });

      // Create recording with settings optimized for speech
      const { recording } = await Audio.Recording.createAsync(
        {
          android: {
            extension: '.wav',
            outputFormat: Audio.AndroidOutputFormat.DEFAULT,
            audioEncoder: Audio.AndroidAudioEncoder.DEFAULT,
            sampleRate: 16000,
            numberOfChannels: 1,
            bitRate: 256000,
          },
          ios: {
            extension: '.wav',
            audioQuality: Audio.IOSAudioQuality.HIGH,
            sampleRate: 16000,
            numberOfChannels: 1,
            bitRate: 256000,
            linearPCMBitDepth: 16,
            linearPCMIsBigEndian: false,
            linearPCMIsFloat: false,
          },
          web: {
            mimeType: 'audio/webm',
            bitsPerSecond: 128000,
          },
        }
      );

      recordingRef.current = recording;
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
          stopRecording();
        }
      }, 100);
    } catch (err: any) {
      setState('error');
      setError('Không thể bắt đầu thu âm. Vui lòng thử lại.');
      console.error('Start recording error:', err);
    }
  }, [maxDurationMs, requestPermission]);

  const stopRecording = useCallback(async (): Promise<RecorderResult | null> => {
    if (timerRef.current) {
      clearInterval(timerRef.current);
      timerRef.current = null;
    }

    if (!recordingRef.current) {
      setState('idle');
      return null;
    }

    try {
      await recordingRef.current.stopAndUnloadAsync();
      const uri = recordingRef.current.getURI();
      const finalDuration = Date.now() - startTimeRef.current;

      recordingRef.current = null;

      // Reset audio mode
      await Audio.setAudioModeAsync({
        allowsRecordingIOS: false,
        playsInSilentModeIOS: true,
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
    } catch (err: any) {
      setState('error');
      setError('Lỗi khi dừng thu âm.');
      console.error('Stop recording error:', err);
      return null;
    }
  }, [onRecordingComplete]);

  const cancelRecording = useCallback(async () => {
    if (timerRef.current) {
      clearInterval(timerRef.current);
      timerRef.current = null;
    }
    if (recordingRef.current) {
      try {
        await recordingRef.current.stopAndUnloadAsync();
      } catch {}
      recordingRef.current = null;
    }
    setRecordingUri(null);
    setDurationMs(0);
    setState('idle');
  }, []);

  const playRecording = useCallback(async () => {
    if (!recordingUri) return;

    try {
      if (playbackRef.current) {
        await playbackRef.current.unloadAsync();
      }

      const { sound } = await Audio.Sound.createAsync(
        { uri: recordingUri },
        { shouldPlay: true }
      );

      playbackRef.current = sound;

      sound.setOnPlaybackStatusUpdate((status) => {
        if (status.isLoaded && status.didJustFinish) {
          playbackRef.current = null;
        }
      });
    } catch (err) {
      console.error('Playback error:', err);
    }
  }, [recordingUri]);

  const stopPlayback = useCallback(async () => {
    if (playbackRef.current) {
      try {
        await playbackRef.current.stopAsync();
        await playbackRef.current.unloadAsync();
      } catch {}
      playbackRef.current = null;
    }
  }, []);

  const reset = useCallback(() => {
    cleanup();
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
