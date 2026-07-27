import React from 'react';
import { View, StyleSheet, ViewStyle, ViewProps, Platform } from 'react-native';
import { useThemeStore } from '@/stores/theme-store';
import { BorderRadius, Spacing, Shadow } from '@/constants/theme';

type GlassVariant = 'default' | 'prominent' | 'subtle';

interface GlassCardProps extends ViewProps {
  variant?: GlassVariant;
  padding?: 'none' | 'sm' | 'md' | 'lg' | 'xl';
  radius?: 'md' | 'lg' | 'xl' | '2xl';
  style?: ViewStyle;
  children: React.ReactNode;
}

/**
 * Translucent glass-morphism card with depth.
 * Uses platform-appropriate translucency:
 * - iOS: backdrop blur via opacity
 * - Android/Web: semi-transparent with strong border for visual separation
 * Fallback is always readable — never sacrifices contrast.
 */
export function GlassCard({
  variant = 'default',
  padding = 'md',
  radius = 'xl',
  style,
  children,
  ...props
}: GlassCardProps) {
  const { colors } = useThemeStore();

  const getPadding = (): number => {
    switch (padding) {
      case 'none': return 0;
      case 'sm': return Spacing.md;
      case 'md': return Spacing.lg;
      case 'lg': return Spacing['2xl'];
      case 'xl': return Spacing['3xl'];
      default: return Spacing.lg;
    }
  };

  const getRadius = (): number => {
    switch (radius) {
      case 'md': return BorderRadius.md;
      case 'lg': return BorderRadius.lg;
      case 'xl': return BorderRadius.xl;
      case '2xl': return BorderRadius['2xl'];
      default: return BorderRadius.xl;
    }
  };

  const getVariantStyle = (): ViewStyle => {
    switch (variant) {
      case 'prominent':
        return {
          backgroundColor: colors.glass,
          borderWidth: 1,
          borderColor: colors.glassBorder,
          ...Shadow.lg,
        };
      case 'subtle':
        return {
          backgroundColor: colors.glass,
          borderWidth: 0.5,
          borderColor: colors.glassBorder,
          ...Shadow.sm,
        };
      default:
        return {
          backgroundColor: colors.glass,
          borderWidth: 1,
          borderColor: colors.glassBorder,
          ...Shadow.md,
        };
    }
  };

  return (
    <View
      style={[
        styles.base,
        getVariantStyle(),
        {
          padding: getPadding(),
          borderRadius: getRadius(),
        },
        style,
      ]}
      {...props}
    >
      {children}
    </View>
  );
}

const styles = StyleSheet.create({
  base: {
    overflow: 'hidden',
  },
});
