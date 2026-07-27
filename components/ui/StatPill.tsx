import React from 'react';
import { View, Text, StyleSheet, ViewStyle, TouchableOpacity } from 'react-native';
import { Ionicons } from '@expo/vector-icons';
import { useThemeStore } from '@/stores/theme-store';
import { BorderRadius, FontSize, Spacing, FontWeight } from '@/constants/theme';

type StatVariant = 'streak' | 'xp' | 'hearts' | 'coins' | 'level';

interface StatPillProps {
  icon?: string;
  iconName?: string;
  value: number | string;
  label?: string;
  variant?: StatVariant;
  onPress?: () => void;
  compact?: boolean;
  style?: ViewStyle;
}

/**
 * Polished gamification stat display — used in headers and dashboards.
 * Supports both emoji icons (icon prop) and Ionicons (iconName prop).
 * Responsive, dark mode aware, and pressable for drill-down.
 */
export function StatPill({
  icon,
  iconName,
  value,
  label,
  variant = 'xp',
  onPress,
  compact = false,
  style,
}: StatPillProps) {
  const { colors } = useThemeStore();

  const getColors = (): { bg: string; text: string; border: string } => {
    switch (variant) {
      case 'streak':
        return { bg: colors.streakLight, text: colors.streak, border: colors.streak + '30' };
      case 'xp':
        return { bg: colors.xpLight, text: colors.xp, border: colors.xp + '30' };
      case 'hearts':
        return { bg: colors.heartLight, text: colors.heart, border: colors.heart + '30' };
      case 'coins':
        return { bg: colors.coinLight, text: colors.coin, border: colors.coin + '30' };
      case 'level':
        return { bg: colors.levelLight, text: colors.level, border: colors.level + '30' };
      default:
        return { bg: colors.xpLight, text: colors.xp, border: colors.xp + '30' };
    }
  };

  const { bg, text, border } = getColors();
  const iconSize = compact ? 13 : 16;

  const content = (
    <View
      style={[
        styles.pill,
        compact ? styles.compact : styles.standard,
        { backgroundColor: bg, borderColor: border },
        style,
      ]}
    >
      {iconName ? (
        <Ionicons name={iconName as any} size={iconSize} color={text} />
      ) : icon ? (
        <Text style={[styles.iconText, compact && styles.iconCompact]}>{icon}</Text>
      ) : null}
      <Text style={[styles.value, compact && styles.valueCompact, { color: text }]}>
        {value}
      </Text>
      {label && !compact && (
        <Text style={[styles.label, { color: text + 'AA' }]}>{label}</Text>
      )}
    </View>
  );

  if (onPress) {
    return (
      <TouchableOpacity activeOpacity={0.7} onPress={onPress}>
        {content}
      </TouchableOpacity>
    );
  }

  return content;
}

const styles = StyleSheet.create({
  pill: {
    flexDirection: 'row',
    alignItems: 'center',
    borderRadius: BorderRadius.full,
    borderWidth: 1,
  },
  standard: {
    paddingHorizontal: Spacing.md,
    paddingVertical: Spacing.sm,
    gap: Spacing.xs,
  },
  compact: {
    paddingHorizontal: Spacing.sm + 2,
    paddingVertical: Spacing.xs + 1,
    gap: 3,
  },
  iconText: {
    fontSize: 16,
  },
  iconCompact: {
    fontSize: 13,
  },
  value: {
    fontSize: FontSize.md,
    fontWeight: FontWeight.bold,
  },
  valueCompact: {
    fontSize: FontSize.sm,
  },
  label: {
    fontSize: FontSize.xs,
    fontWeight: FontWeight.medium,
    marginLeft: 2,
  },
});
