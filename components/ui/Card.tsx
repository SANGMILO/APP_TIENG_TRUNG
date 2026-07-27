import React from 'react';
import { View, StyleSheet, ViewStyle, ViewProps, TouchableOpacity } from 'react-native';
import { LinearGradient } from 'expo-linear-gradient';
import { useThemeStore } from '@/stores/theme-store';
import { BorderRadius, Spacing, Shadow } from '@/constants/theme';

interface CardProps extends ViewProps {
  variant?: 'default' | 'elevated' | 'outlined' | 'gradient' | 'glass';
  padding?: 'none' | 'sm' | 'md' | 'lg' | 'xl';
  onPress?: () => void;
  gradientColors?: string[];
  shadow?: 'none' | 'sm' | 'md' | 'lg';
}

export function Card({
  children,
  variant = 'default',
  padding = 'md',
  onPress,
  gradientColors,
  shadow,
  style,
  ...props
}: CardProps) {
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

  const getShadow = (): ViewStyle => {
    if (shadow) {
      switch (shadow) {
        case 'none': return {};
        case 'sm': return Shadow.sm;
        case 'md': return Shadow.md;
        case 'lg': return Shadow.lg;
        default: return Shadow.sm;
      }
    }
    switch (variant) {
      case 'elevated': return Shadow.md;
      case 'glass': return Shadow.lg;
      case 'default': return Shadow.sm;
      default: return {};
    }
  };

  const getVariantStyle = (): ViewStyle => {
    switch (variant) {
      case 'elevated':
        return {
          backgroundColor: colors.surface,
        };
      case 'outlined':
        return {
          backgroundColor: colors.surface,
          borderWidth: 1,
          borderColor: colors.border,
        };
      case 'glass':
        return {
          backgroundColor: colors.surface + 'E6', // 90% opacity
          borderWidth: 1,
          borderColor: colors.border + '40',
        };
      case 'gradient':
        return {};
      default:
        return {
          backgroundColor: colors.card,
        };
    }
  };

  const cardStyle: ViewStyle[] = [
    styles.base,
    getVariantStyle(),
    getShadow(),
    { padding: getPadding() },
    style as ViewStyle,
  ];

  if (variant === 'gradient') {
    const gradColors = gradientColors || (colors.gradientPrimary as unknown as string[]);
    const content = (
      <LinearGradient
        colors={gradColors as [string, string]}
        start={{ x: 0, y: 0 }}
        end={{ x: 1, y: 1 }}
        style={[styles.base, getShadow(), { padding: getPadding() }, style as ViewStyle]}
      >
        {children}
      </LinearGradient>
    );

    if (onPress) {
      return (
        <TouchableOpacity activeOpacity={0.85} onPress={onPress} style={getShadow()}>
          {content}
        </TouchableOpacity>
      );
    }
    return content;
  }

  if (onPress) {
    return (
      <TouchableOpacity activeOpacity={0.85} onPress={onPress} style={cardStyle}>
        {children}
      </TouchableOpacity>
    );
  }

  return (
    <View style={cardStyle} {...props}>
      {children}
    </View>
  );
}

const styles = StyleSheet.create({
  base: {
    borderRadius: BorderRadius.xl,
    overflow: 'hidden',
  },
});
