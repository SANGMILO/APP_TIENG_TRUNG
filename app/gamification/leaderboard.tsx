import React from 'react';
import { View, Text, StyleSheet, FlatList, TouchableOpacity, ActivityIndicator } from 'react-native';
import { Ionicons } from '@expo/vector-icons';
import { router } from 'expo-router';
import { useSafeAreaInsets } from 'react-native-safe-area-context';
import { useQuery } from '@tanstack/react-query';
import { useThemeStore } from '@/stores/theme-store';
import { useAuthStore } from '@/stores/auth-store';
import { fetchLeaderboard } from '@/services/gamification-service';
import { EmptyState } from '@/components/ui';
import { FontSize, Spacing, BorderRadius, Shadow, FontWeight } from '@/constants/theme';

export default function LeaderboardScreen() {
  const { colors } = useThemeStore();
  const { profile } = useAuthStore();
  const insets = useSafeAreaInsets();

  const { data: entries, isLoading } = useQuery({
    queryKey: ['leaderboard'],
    queryFn: fetchLeaderboard,
  });

  const getRankDisplay = (index: number) => {
    if (index === 0) return { label: '1', bg: colors.coin, color: '#fff' };
    if (index === 1) return { label: '2', bg: colors.textTertiary, color: '#fff' };
    if (index === 2) return { label: '3', bg: colors.streak, color: '#fff' };
    return { label: `${index + 1}`, bg: colors.surfaceElevated, color: colors.textSecondary };
  };

  return (
    <View style={[styles.screen, { backgroundColor: colors.background }]}>
      {/* Header */}
      <View style={[styles.header, { paddingTop: insets.top + Spacing.md }]}>
        <TouchableOpacity onPress={() => router.back()} style={[styles.backBtn, { backgroundColor: colors.surfaceElevated }]}>
          <Ionicons name="chevron-back" size={20} color={colors.text} />
        </TouchableOpacity>
        <View style={styles.headerCenter}>
          <Text style={[styles.screenTitle, { color: colors.text }]}>Bảng xếp hạng</Text>
          <Text style={[styles.screenSub, { color: colors.textSecondary }]}>Tuần này</Text>
        </View>
        <View style={{ width: 36 }} />
      </View>

      {isLoading ? (
        <View style={styles.center}><ActivityIndicator size="large" color={colors.primary} /></View>
      ) : (
        <FlatList
          data={entries}
          keyExtractor={(item) => item.user_id}
          contentContainerStyle={styles.list}
          renderItem={({ item, index }) => {
            const isMe = item.user_id === profile?.id;
            const rank = getRankDisplay(index);

            return (
              <View style={[styles.row, isMe && { backgroundColor: colors.primary + '08' }, { borderColor: colors.borderLight }]}>
                <View style={[styles.rankBadge, { backgroundColor: rank.bg }]}>
                  <Text style={[styles.rankText, { color: rank.color }]}>{rank.label}</Text>
                </View>
                <View style={[styles.avatar, { backgroundColor: colors.surfaceElevated }]}>
                  <Text style={[styles.avatarText, { color: colors.textSecondary }]}>{(item.display_name || '?')[0].toUpperCase()}</Text>
                </View>
                <View style={{ flex: 1 }}>
                  <Text style={[styles.name, { color: colors.text }]} numberOfLines={1}>
                    {item.display_name || 'Người học'}
                    {isMe && <Text style={{ color: colors.primary }}> (bạn)</Text>}
                  </Text>
                </View>
                <View style={styles.xpWrap}>
                  <Ionicons name="flash" size={14} color={colors.xp} />
                  <Text style={[styles.xp, { color: colors.xp }]}>{item.xp_earned}</Text>
                </View>
              </View>
            );
          }}
          ListEmptyComponent={<EmptyState iconName="podium-outline" title="Chưa có dữ liệu" description="Học thêm để lên bảng xếp hạng tuần này" />}
        />
      )}
    </View>
  );
}

const styles = StyleSheet.create({
  screen: { flex: 1 },
  header: { paddingHorizontal: Spacing.xl, flexDirection: 'row', alignItems: 'center', gap: Spacing.md, marginBottom: Spacing.lg },
  backBtn: { width: 36, height: 36, borderRadius: 18, justifyContent: 'center', alignItems: 'center' },
  headerCenter: { flex: 1, alignItems: 'center' },
  screenTitle: { fontSize: FontSize.xl, fontWeight: FontWeight.bold },
  screenSub: { fontSize: FontSize.sm, marginTop: 2 },
  center: { flex: 1, justifyContent: 'center', alignItems: 'center' },
  list: { paddingHorizontal: Spacing.xl, paddingBottom: Spacing['4xl'], maxWidth: 500, alignSelf: 'center', width: '100%' },
  row: { flexDirection: 'row', alignItems: 'center', paddingVertical: Spacing.md, paddingHorizontal: Spacing.md, borderRadius: BorderRadius.lg, marginBottom: Spacing.sm, gap: Spacing.md },
  rankBadge: { width: 28, height: 28, borderRadius: 14, justifyContent: 'center', alignItems: 'center' },
  rankText: { fontSize: FontSize.sm, fontWeight: FontWeight.bold },
  avatar: { width: 36, height: 36, borderRadius: 18, justifyContent: 'center', alignItems: 'center' },
  avatarText: { fontSize: FontSize.md, fontWeight: FontWeight.semibold },
  name: { fontSize: FontSize.base, fontWeight: FontWeight.medium },
  xpWrap: { flexDirection: 'row', alignItems: 'center', gap: 3 },
  xp: { fontSize: FontSize.md, fontWeight: FontWeight.bold },
});
