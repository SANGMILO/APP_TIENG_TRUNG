import React from 'react';
import { View, Text, StyleSheet, TouchableOpacity } from 'react-native';
import { useThemeStore } from '@/stores/theme-store';
import { ProgressBar } from '@/components/ui';
import { FontSize, Spacing, BorderRadius } from '@/constants/theme';

interface VideoCardProps {
  title: string;
  level: string;
  category: string | null;
  durationSeconds: number;
  progress?: number; // 0-100
  isPremium?: boolean;
  thumbnailUrl?: string | null;
  onPress: () => void;
}

export function VideoCard({
  title,
  level,
  category,
  durationSeconds,
  progress = 0,
  isPremium = false,
  onPress,
}: VideoCardProps) {
  const { colors } = useThemeStore();
  const duration = formatDuration(durationSeconds);

  return (
    <TouchableOpacity
      style={[styles.container, { backgroundColor: colors.surface, borderColor: colors.border }]}
      onPress={onPress}
      activeOpacity={0.7}
    >
      {/* Thumbnail placeholder */}
      <View style={[styles.thumbnail, { backgroundColor: colors.surfaceElevated }]}>
        <Text style={styles.thumbnailIcon}>🎬</Text>
        {isPremium && (
          <View style={[styles.premiumBadge, { backgroundColor: colors.secondary }]}>
            <Text style={styles.premiumText}>PRO</Text>
          </View>
        )}
        <View style={[styles.durationBadge, { backgroundColor: 'rgba(0,0,0,0.7)' }]}>
          <Text style={styles.durationText}>{duration}</Text>
        </View>
      </View>

      {/* Info */}
      <View style={styles.info}>
        <Text style={[styles.title, { color: colors.text }]} numberOfLines={2}>
          {title}
        </Text>
        <View style={styles.meta}>
          <Text style={[styles.level, { color: colors.primary }]}>{level}</Text>
          {category && <Text style={[styles.category, { color: colors.textTertiary }]}>• {category}</Text>}
        </View>
        {progress > 0 && <ProgressBar progress={progress} height={4} color={colors.primary} />}
      </View>
    </TouchableOpacity>
  );
}

function formatDuration(seconds: number): string {
  const m = Math.floor(seconds / 60);
  const s = seconds % 60;
  return `${m}:${s.toString().padStart(2, '0')}`;
}

const styles = StyleSheet.create({
  container: { borderRadius: BorderRadius.xl, borderWidth: 1, overflow: 'hidden' },
  thumbnail: { height: 120, justifyContent: 'center', alignItems: 'center' },
  thumbnailIcon: { fontSize: 36 },
  premiumBadge: { position: 'absolute', top: 8, left: 8, paddingHorizontal: 6, paddingVertical: 2, borderRadius: 4 },
  premiumText: { color: '#fff', fontSize: 10, fontWeight: '700' },
  durationBadge: { position: 'absolute', bottom: 8, right: 8, paddingHorizontal: 6, paddingVertical: 2, borderRadius: 4 },
  durationText: { color: '#fff', fontSize: FontSize.xs },
  info: { padding: Spacing.md, gap: Spacing.xs },
  title: { fontSize: FontSize.md, fontWeight: '600' },
  meta: { flexDirection: 'row', gap: Spacing.xs },
  level: { fontSize: FontSize.xs, fontWeight: '500' },
  category: { fontSize: FontSize.xs },
});
