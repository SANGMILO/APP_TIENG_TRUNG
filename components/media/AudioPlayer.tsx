import React, { useState, useRef, useEffect } from 'react';
import { View, Text, StyleSheet, TouchableOpacity } from 'react-native';
import { useAudioPlayer, useAudioPlayerStatus } from 'expo-audio';
import { Ionicons } from '@expo/vector-icons';
import { useThemeStore } from '@/stores/theme-store';
import { FontFamily, FontSize, Spacing, BorderRadius, Shadow } from '@/constants/theme';

interface AudioPlayerProps {
  uri?: string | null;
  label?: string;
  size?: 'sm' | 'md' | 'lg';
  showSpeed?: boolean;
  autoPlay?: boolean;
  onPlayEnd?: () => void;
  variant?: 'default' | 'lesson';
}

const SPEEDS = [0.75, 1, 1.25];

export function AudioPlayer({
  uri,
  label,
  size = 'md',
  showSpeed = false,
  autoPlay = false,
  onPlayEnd,
  variant = 'default',
}: AudioPlayerProps) {
  const { colors } = useThemeStore();
  const [isLoading, setIsLoading] = useState(false);
  const [error, setError] = useState(false);
  const [speedIndex, setSpeedIndex] = useState(1); // 1x default
  const finishHandledRef = useRef(false);
  const player = useAudioPlayer(uri ?? null, { updateInterval: 100 });
  const status = useAudioPlayerStatus(player);
  const isPlaying = status.playing;

  useEffect(() => {
    finishHandledRef.current = false;
    setError(false);
    if (autoPlay && uri) {
      player.playbackRate = SPEEDS[speedIndex];
      player.shouldCorrectPitch = true;
      player.play();
    }
  }, [autoPlay, player, uri]);

  useEffect(() => {
    setIsLoading(Boolean(uri) && (status.isBuffering || !status.isLoaded));
    if (status.error) setError(true);
    if (status.didJustFinish && !finishHandledRef.current) {
      finishHandledRef.current = true;
      onPlayEnd?.();
    }
  }, [
    onPlayEnd,
    status.didJustFinish,
    status.error,
    status.isBuffering,
    status.isLoaded,
    uri,
  ]);

  const play = async () => {
    if (!uri) {
      setError(true);
      return;
    }

    setError(false);
    setIsLoading(true);

    try {
      if (status.didJustFinish || (
        status.duration > 0
        && status.currentTime >= status.duration
      )) {
        await player.seekTo(0);
      }
      finishHandledRef.current = false;
      player.playbackRate = SPEEDS[speedIndex];
      player.shouldCorrectPitch = true;
      player.play();
      setIsLoading(false);
    } catch {
      setIsLoading(false);
      setError(true);
    }
  };

  const handlePress = () => {
    if (isPlaying) {
      player.pause();
    } else {
      void play();
    }
  };

  const cycleSpeed = () => {
    const next = (speedIndex + 1) % SPEEDS.length;
    setSpeedIndex(next);
    player.setPlaybackRate(SPEEDS[next], 'high');
  };

  const iconSize = size === 'sm' ? 16 : size === 'lg' ? 28 : 22;
  const btnSize = size === 'sm' ? 36 : size === 'lg' ? 56 : 44;

  if (variant === 'lesson') {
    return (
      <View style={styles.lessonContainer}>
        <TouchableOpacity
          accessibilityRole="button"
          accessibilityLabel={isPlaying ? 'Tạm dừng âm thanh' : 'Phát âm thanh'}
          style={[
            styles.lessonButton,
            {
              backgroundColor: error ? colors.error : colors.primary,
              opacity: isLoading || !uri ? 0.55 : 1,
            },
          ]}
          onPress={handlePress}
          disabled={isLoading || !uri}
          activeOpacity={0.78}
        >
          <Ionicons
            name={isLoading ? 'hourglass-outline' : error ? 'alert' : isPlaying ? 'pause' : 'play'}
            size={48}
            color={colors.textOnPrimary}
          />
        </TouchableOpacity>
        <View style={styles.waveform}>
          {[18, 34, 24, 44, 28, 40, 20, 32, 16].map((height, index) => (
            <View
              key={`${height}-${index}`}
              style={[
                styles.waveBar,
                {
                  height: isPlaying ? Math.min(48, height + (index % 3) * 5) : height,
                  backgroundColor: colors.primary,
                },
              ]}
            />
          ))}
        </View>
        {label ? (
          <Text style={[styles.lessonLabel, { color: colors.textSecondary }]}>{label}</Text>
        ) : null}
        {showSpeed ? (
          <TouchableOpacity
            style={[styles.lessonSpeed, { backgroundColor: colors.surfaceElevated }]}
            onPress={cycleSpeed}
          >
            <Text style={[styles.speedText, { color: colors.textSecondary }]}>
              {SPEEDS[speedIndex]}x
            </Text>
          </TouchableOpacity>
        ) : null}
        {error ? (
          <TouchableOpacity onPress={play}>
            <Text style={[styles.retryText, { color: colors.primary }]}>Thử lại</Text>
          </TouchableOpacity>
        ) : null}
      </View>
    );
  }

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
  lessonContainer: {
    alignItems: 'center',
    justifyContent: 'center',
    gap: Spacing.md,
  },
  lessonButton: {
    width: 112,
    height: 112,
    borderRadius: 56,
    alignItems: 'center',
    justifyContent: 'center',
    ...Shadow.lg,
  },
  waveform: {
    height: 48,
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'center',
    gap: 5,
  },
  waveBar: {
    width: 4,
    borderRadius: 999,
  },
  lessonLabel: {
    fontFamily: FontFamily.regular,
    fontSize: FontSize.base,
  },
  lessonSpeed: {
    paddingHorizontal: Spacing.md,
    paddingVertical: Spacing.xs,
    borderRadius: BorderRadius.full,
  },
});
