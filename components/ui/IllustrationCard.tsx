import React from 'react';
import { View, Text, StyleSheet, ViewStyle } from 'react-native';
import { LinearGradient } from 'expo-linear-gradient';
import { useThemeStore } from '@/stores/theme-store';
import { BorderRadius, Spacing, Shadow, FontSize, FontWeight } from '@/constants/theme';
import { AnimatedPressable } from './AnimatedPressable';

interface IllustrationCardProps {
  emoji: string;
  title: string;
  subtitle?: string;
  gradientColors?: string[];
  onPress?: () => void;
  style?: ViewStyle;
  badge?: string;
  size?: 'sm' | 'md' | 'lg';
}

/**
 * A vibrant card with large emoji illustration, gradient background,
 * and interactive scale animation. Inspired by Duolingo's lesson cards.
 */
export function IllustrationCard({
  emoji,
  title,
  subtitle,
  gradientColors,
  onPress,
  style,
  badge,
  size = 'md',
}: IllustrationCardProps) {
  const { colors } = useThemeStore();
  const gradient = gradientColors || (colors.gradientPrimary as unknown as string[]);

  const getEmojiSize = () => {
    switch (size) {
      case 'sm': return 36;
      case 'md': return 48;
      case 'lg': return 64;
    }
  };

  const getPadding = () => {
    switch (size) {
      case 'sm': return Spacing.lg;
      case 'md': return Spacing.xl;
      case 'lg': return Spacing['2xl'];
    }
  };

  const content = (
    <LinearGradient
      colors={gradient as [string, string]}
      start={{ x: 0, y: 0 }}
      end={{ x: 1, y: 1 }}
      style={[
        styles.card,
        { padding: getPadding() },
        Shadow.lg,
        style,
      ]}
    >
      {/* Decorative shapes */}
      <View style={styles.decoCircle1} />
      <View style={styles.decoCircle2} />

      {badge && (
        <View style={styles.badgeContainer}>
          <Text style={styles.badgeText}>{badge}</Text>
        </View>
      )}

      <Text style={[styles.emoji, { fontSize: getEmojiSize() }]}>{emoji}</Text>
      <Text style={[styles.title, size === 'sm' && { fontSize: FontSize.md }]}>{title}</Text>
      {subtitle && <Text style={styles.subtitle}>{subtitle}</Text>}
    </LinearGradient>
  );

  if (onPress) {
    return (
      <AnimatedPressable onPress={onPress} scaleValue={0.96}>
        {content}
      </AnimatedPressable>
    );
  }

  return content;
}

const styles = StyleSheet.create({
  card: {
    borderRadius: BorderRadius['2xl'],
    alignItems: 'center',
    justifyContent: 'center',
    overflow: 'hidden',
    position: 'relative',
  },
  decoCircle1: {
    position: 'absolute',
    width: 100,
    height: 100,
    borderRadius: 50,
    backgroundColor: 'rgba(255,255,255,0.1)',
    top: -20,
    right: -20,
  },
  decoCircle2: {
    position: 'absolute',
    width: 60,
    height: 60,
    borderRadius: 30,
    backgroundColor: 'rgba(255,255,255,0.08)',
    bottom: -10,
    left: -10,
  },
  badgeContainer: {
    position: 'absolute',
    top: 12,
    right: 12,
    backgroundColor: 'rgba(255,255,255,0.25)',
    paddingHorizontal: 10,
    paddingVertical: 4,
    borderRadius: BorderRadius.full,
  },
  badgeText: {
    color: '#FFFFFF',
    fontSize: FontSize.xs,
    fontWeight: FontWeight.bold,
  },
  emoji: {
    marginBottom: Spacing.sm,
  },
  title: {
    color: '#FFFFFF',
    fontSize: FontSize.lg,
    fontWeight: FontWeight.bold,
    textAlign: 'center',
    letterSpacing: -0.2,
  },
  subtitle: {
    color: 'rgba(255,255,255,0.8)',
    fontSize: FontSize.sm,
    fontWeight: FontWeight.medium,
    textAlign: 'center',
    marginTop: Spacing.xs,
  },
});
