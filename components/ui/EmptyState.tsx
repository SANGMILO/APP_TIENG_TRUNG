import React from 'react';
import { View, Text, StyleSheet } from 'react-native';
import { Ionicons } from '@expo/vector-icons';
import { useThemeStore } from '@/stores/theme-store';
import { Button } from './Button';
import { FontFamily, FontSize, Spacing, FontWeight } from '@/constants/theme';

interface EmptyStateProps {
  iconName: string;
  title: string;
  description?: string;
  actionLabel?: string;
  onAction?: () => void;
}

export function EmptyState({ iconName, title, description, actionLabel, onAction }: EmptyStateProps) {
  const { colors } = useThemeStore();

  return (
    <View style={styles.container}>
      <View style={[styles.iconWrap, { backgroundColor: colors.surfaceElevated }]}>
        <Ionicons name={iconName as any} size={32} color={colors.textTertiary} />
      </View>
      <Text style={[styles.title, { color: colors.text }]}>{title}</Text>
      {description && <Text style={[styles.description, { color: colors.textSecondary }]}>{description}</Text>}
      {actionLabel && onAction && (
        <Button title={actionLabel} variant="primary" size="md" onPress={onAction} style={{ marginTop: Spacing.lg }} />
      )}
    </View>
  );
}

const styles = StyleSheet.create({
  container: { alignItems: 'center', paddingVertical: Spacing['4xl'], paddingHorizontal: Spacing.xl },
  iconWrap: { width: 64, height: 64, borderRadius: 32, justifyContent: 'center', alignItems: 'center', marginBottom: Spacing.lg },
  title: {
    fontSize: FontSize.lg,
    fontFamily: FontFamily.heading,
    fontWeight: FontWeight.bold,
    marginBottom: Spacing.xs,
    textAlign: 'center',
  },
  description: {
    fontSize: FontSize.md,
    fontFamily: FontFamily.regular,
    textAlign: 'center',
    lineHeight: 20,
  },
});
