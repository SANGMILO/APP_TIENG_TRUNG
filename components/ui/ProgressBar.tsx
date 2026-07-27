import React, { useEffect, useRef } from 'react';
import { View, StyleSheet, Text, Animated } from 'react-native';
import { LinearGradient } from 'expo-linear-gradient';
import { useThemeStore } from '@/stores/theme-store';
import { BorderRadius, FontSize, Spacing, FontWeight } from '@/constants/theme';

interface ProgressBarProps {
  progress: number; // 0-100
  height?: number;
  color?: string;
  gradientColors?: string[];
  showLabel?: boolean;
  label?: string;
  animated?: boolean;
  showPercentage?: boolean;
}

export function ProgressBar({
  progress,
  height = 10,
  color,
  gradientColors,
  showLabel = false,
  label,
  animated = true,
  showPercentage = false,
}: ProgressBarProps) {
  const { colors } = useThemeStore();
  const clampedProgress = Math.min(100, Math.max(0, progress));
  const animatedWidth = useRef(new Animated.Value(0)).current;

  useEffect(() => {
    if (animated) {
      Animated.timing(animatedWidth, {
        toValue: clampedProgress,
        duration: 600,
        useNativeDriver: false,
      }).start();
    } else {
      animatedWidth.setValue(clampedProgress);
    }
  }, [clampedProgress, animated]);

  const widthInterpolation = animatedWidth.interpolate({
    inputRange: [0, 100],
    outputRange: ['0%', '100%'],
  });

  const useGradient = gradientColors && gradientColors.length >= 2;

  return (
    <View style={styles.container}>
      {(showLabel || showPercentage) && (
        <View style={styles.labelRow}>
          <Text style={[styles.label, { color: colors.textSecondary }]}>
            {label ?? ''}
          </Text>
          {showPercentage && (
            <Text style={[styles.percentage, { color: colors.text }]}>
              {Math.round(clampedProgress)}%
            </Text>
          )}
        </View>
      )}
      <View
        style={[
          styles.track,
          {
            height,
            backgroundColor: colors.borderLight,
            borderRadius: height / 2,
          },
        ]}
      >
        <Animated.View
          style={[
            styles.fillContainer,
            {
              width: widthInterpolation,
              height,
              borderRadius: height / 2,
            },
          ]}
        >
          {useGradient ? (
            <LinearGradient
              colors={gradientColors as [string, string]}
              start={{ x: 0, y: 0 }}
              end={{ x: 1, y: 0 }}
              style={[styles.gradient, { borderRadius: height / 2 }]}
            />
          ) : (
            <View
              style={[
                styles.fill,
                {
                  backgroundColor: color ?? colors.primary,
                  borderRadius: height / 2,
                },
              ]}
            />
          )}
        </Animated.View>
      </View>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    width: '100%',
  },
  labelRow: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginBottom: Spacing.sm,
  },
  label: {
    fontSize: FontSize.sm,
    fontWeight: FontWeight.medium,
  },
  percentage: {
    fontSize: FontSize.sm,
    fontWeight: FontWeight.bold,
  },
  track: {
    overflow: 'hidden',
  },
  fillContainer: {
    overflow: 'hidden',
  },
  gradient: {
    flex: 1,
  },
  fill: {
    flex: 1,
  },
});
