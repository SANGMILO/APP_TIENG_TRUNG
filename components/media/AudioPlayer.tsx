import React, { useState, useCallback, useRef, useEffect } from 'react';
import { View, Text, StyleSheet, TouchableOpacity } from 'react-native';
import { Audio } from 'expo-av';
import { useThemeStore } from '@/stores/theme-store';
import { FontSize, Spacing, BorderRadius } from '@/constants/theme';

interface AudioPlayerProps {
  uri?: string | null;
  label?: string;
  size?: 'sm' | 'md' | 'lg';
  showSpeed?: boolean;
  autoPlay?: boolean;
  onPlayEnd?: () => void;
}

const SPEEDS = [0.75, 1, 1.25];

export function AudioPlayer({
  uri,
  label,
  size = 'md',
  showSpeed = false,
  autoPlay = false,
  onPlayEnd,
}: AudioPlayerProps) {
  const { colors } = useThemeStore();
  const [isPlaying, setIsPlaying] = useState(false);
  const [isLoading, setIsLoading] = useState(false);
  const [error, setError] = useState(false);
  const [speedIndex, setSpeedIndex] = useState(1); // 1x default
  const soundRef = useRef<Audio.Sound | null>(null);

  const cleanup = useCallback(async () => {
    if (soundRef.current) {
      try {
        await soundRef.current.unloadAsync();
      } catch {}
      soundRef.current = null;
    }
  }, []);

  useEffect(() => {
    return () => { cleanup(); };
  }, [cleanup]);

  useEffect(() => {
    if (autoPlay && uri) {
      play();
    }
  }, [uri, autoPlay]);

  const play = async () => {
    if (!uri) {
      setError(true);
      return;
    }

    setError(false);
    setIsLoading(true);

    try {
      await cleanup();

      const { sound } = await Audio.Sound.createAsync(
        { uri },
        { shouldPlay: true, rate: SPEEDS[speedIndex], shouldCorrectPitch: true }
      );

      soundRef.current = sound;
      setIsPlaying(true);
      setIsLoading(false);

      sound.setOnPlaybackStatusUpdate((status) => {
        if (status.isLoaded && status.didJustFinish) {
          setIsPlaying(false);
          onPlayEnd?.();
        }
      });
    } catch (err) {
      setIsLoading(false);
      setError(true);
      console.error('Audio play error:', err);
    }
  };

  const handlePress = () => {
    if (isPlaying) {
      soundRef.current?.pauseAsync();
      setIsPlaying(false);
    } else {
      play();
    }
  };

  const cycleSpeed = () => {
    const next = (speedIndex + 1) % SPEEDS.length;
    setSpeedIndex(next);
    soundRef.current?.setRateAsync(SPEEDS[next], true);
  };

  const iconSize = size === 'sm' ? 16 : size === 'lg' ? 28 : 22;
  const btnSize = size === 'sm' ? 36 : size === 'lg' ? 56 : 44;

  return (
    <View style={styles.container}>
      <TouchableOpacity
        style={[
          styles.button,
          {
            width: btnSize,
            height: btnSize,
            backgroundColor: error ? colors.errorLight : colors.primary + '15',
            borderRadius: btnSize / 2,
          },
        ]}
        onPress={handlePress}
        disabled={isLoading || !uri}
        activeOpacity={0.7}
      >
        <Text style={{ fontSize: iconSize }}>
          {isLoading ? '⏳' : error ? '⚠️' : isPlaying ? '⏸' : '🔊'}
        </Text>
      </TouchableOpacity>

      {label && (
        <Text style={[styles.label, { color: colors.textSecondary, fontSize: size === 'sm' ? FontSize.xs : FontSize.sm }]}>
          {label}
        </Text>
      )}

      {showSpeed && (
        <TouchableOpacity
          style={[styles.speedBtn, { backgroundColor: colors.surfaceElevated }]}
          onPress={cycleSpeed}
        >
          <Text style={[styles.speedText, { color: colors.textSecondary }]}>
            {SPEEDS[speedIndex]}x
          </Text>
        </TouchableOpacity>
      )}

      {error && (
        <TouchableOpacity onPress={play}>
          <Text style={[styles.retryText, { color: colors.primary }]}>Thử lại</Text>
        </TouchableOpacity>
      )}
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: Spacing.sm,
  },
  button: {
    justifyContent: 'center',
    alignItems: 'center',
  },
  label: {},
  speedBtn: {
    paddingHorizontal: Spacing.sm,
    paddingVertical: Spacing.xs,
    borderRadius: BorderRadius.sm,
  },
  speedText: {
    fontSize: FontSize.xs,
    fontWeight: '600',
  },
  retryText: {
    fontSize: FontSize.sm,
    fontWeight: '500',
  },
});
