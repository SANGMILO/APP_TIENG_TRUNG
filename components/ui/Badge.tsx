import React from 'react';
import { View, Text, StyleSheet, ViewStyle } from 'react-native';
import { useThemeStore } from '@/stores/theme-store';
import { BorderRadius, FontSize, Spacing, FontWeight } from '@/constants/theme';

type BadgeVariant = 'primary' | 'success' | 'warning' | 'error' | 'info' | 'xp' | 'streak' | 'coin' | 'custom';
type BadgeSize = 'sm' | 'md' | 'lg';

interface BadgeProps {
  label: string;
  icon?: string;
  variant?: BadgeVariant;
  size?: BadgeSize;
  customColor?: string;
  customBg?: string;
  style?: ViewStyle;
}

export function Badge({
  label,
  icon,
  variant = 'primary',
  size = 'md',
  customColor,
  customBg,
  style,
}: BadgeProps) {
  const { colors } = useThemeStore();

  const getColors = (): { bg: string; text: string } => {
    switch (variant) {
      case 'primary': return { bg: colors.primaryLight + '20', text: colors.primary };
      case 'success': return { bg: colors.successLight, text: colors.success };
      case 'warning': return { bg: colors.warningLight, text: colors.warning };
      case 'error': return { bg: colors.errorLight, text: colors.error };
      case 'info': return { bg: colors.infoLight, text: colors.info };
      case 'xp': return { bg: colors.xpLight, text: colors.xp };
      case 'streak': return { bg: colors.streakLight, text: colors.streak };
      case 'coin': return { bg: colors.coinLight, text: colors.coin };
      case 'custom': return { bg: customBg || colors.surfaceElevated, text: customColor || colors.text };
      default: return { bg: colors.primaryLight + '20', text: colors.primary };
    }
  };

  const getSizeStyle = (): ViewStyle => {
    switch (size) {
      case 'sm': return { paddingHorizontal: Spacing.sm, paddingVertical: Spacing.xs - 1 };
      case 'md': return { paddingHorizontal: Spacing.md, paddingVertical: Spacing.xs + 1 };
      case 'lg': return { paddingHorizontal: Spacing.lg, paddingVertical: Spacing.sm };
      default: return { paddingHorizontal: Spacing.md, paddingVertical: Spacing.xs + 1 };
    }
  };

  const getFontSize = (): number => {
    switch (size) {
      case 'sm': return FontSize.xs;
      case 'md': return FontSize.sm;
      case 'lg': return FontSize.md;
      default: return FontSize.sm;
    }
  };

  const { bg, text } = getColors();

  return (
    <View style={[styles.badge, getSizeStyle(), { backgroundColor: bg }, style]}>
      {icon && <Text style={[styles.icon, { fontSize: getFontSize() }]}>{icon}</Text>}
      <Text style={[styles.label, { color: text, fontSize: getFontSize() }]}>
        {label}
      </Text>
    </View>
  );
}

const styles = StyleSheet.create({
  badge: {
    flexDirection: 'row',
    alignItems: 'center',
    borderRadius: BorderRadius.full,
    gap: Spacing.xs,
  },
  icon: {
    // emoji size
  },
  label: {
    fontWeight: FontWeight.semibold,
    letterSpacing: 0.2,
  },
});
