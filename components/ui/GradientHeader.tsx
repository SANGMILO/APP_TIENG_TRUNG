import React from 'react';
import { View, Text, StyleSheet, ViewStyle } from 'react-native';
import { LinearGradient } from 'expo-linear-gradient';
import { useSafeAreaInsets } from 'react-native-safe-area-context';
import { useThemeStore } from '@/stores/theme-store';
import { Spacing, FontSize, FontWeight, BorderRadius } from '@/constants/theme';

interface GradientHeaderProps {
  title?: string;
  subtitle?: string;
  gradientColors?: string[];
  height?: number;
  children?: React.ReactNode;
  leftContent?: React.ReactNode;
  rightContent?: React.ReactNode;
  style?: ViewStyle;
}

export function GradientHeader({
  title,
  subtitle,
  gradientColors,
  height = 200,
  children,
  leftContent,
  rightContent,
  style,
}: GradientHeaderProps) {
  const { colors } = useThemeStore();
  const insets = useSafeAreaInsets();

  const gradient = gradientColors || (colors.gradientPrimary as unknown as string[]);

  return (
    <LinearGradient
      colors={gradient as [string, string, ...string[]]}
      start={{ x: 0, y: 0 }}
      end={{ x: 1, y: 1 }}
      style={[
        styles.container,
        { paddingTop: insets.top + Spacing.lg, minHeight: height },
        style,
      ]}
    >
      {/* Top bar with left/right content */}
      {(leftContent || rightContent) && (
        <View style={styles.topBar}>
          <View>{leftContent}</View>
          <View>{rightContent}</View>
        </View>
      )}

      {/* Title area */}
      {(title || subtitle) && (
        <View style={styles.titleArea}>
          {title && <Text style={styles.title}>{title}</Text>}
          {subtitle && <Text style={styles.subtitle}>{subtitle}</Text>}
        </View>
      )}

      {/* Custom children */}
      {children}

      {/* Bottom curve overlay */}
      <View style={[styles.curve, { backgroundColor: colors.background }]} />
    </LinearGradient>
  );
}

const styles = StyleSheet.create({
  container: {
    paddingHorizontal: Spacing.xl,
    paddingBottom: Spacing['3xl'],
    position: 'relative',
  },
  topBar: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginBottom: Spacing.lg,
  },
  titleArea: {
    gap: Spacing.xs,
  },
  title: {
    fontSize: FontSize['2xl'],
    fontWeight: FontWeight.bold,
    color: '#FFFFFF',
    letterSpacing: -0.3,
  },
  subtitle: {
    fontSize: FontSize.base,
    color: 'rgba(255,255,255,0.85)',
    fontWeight: FontWeight.medium,
  },
  curve: {
    position: 'absolute',
    bottom: 0,
    left: 0,
    right: 0,
    height: 20,
    borderTopLeftRadius: BorderRadius['3xl'],
    borderTopRightRadius: BorderRadius['3xl'],
  },
});
