import React from 'react';
import { View, Text, StyleSheet, FlatList, TouchableOpacity, ActivityIndicator } from 'react-native';
import { Ionicons } from '@expo/vector-icons';
import { router } from 'expo-router';
import { useSafeAreaInsets } from 'react-native-safe-area-context';
import { useQuery } from '@tanstack/react-query';
import { useThemeStore } from '@/stores/theme-store';
import { fetchAchievements } from '@/services/gamification-service';
import { ProgressBar, EmptyState } from '@/components/ui';
import { FontSize, Spacing, BorderRadius, Shadow, FontWeight } from '@/constants/theme';

export default function AchievementsScreen() {
  const { colors } = useThemeStore();
  const insets = useSafeAreaInsets();

  const { data: achievements, isLoading } = useQuery({
    queryKey: ['achievements'],
    queryFn: fetchAchievements,
  });

  const unlocked = (achievements ?? []).filter(a => a.unlocked);
  const locked = (achievements ?? []).filter(a => !a.unlocked && !a.is_hidden);
  const total = (achievements ?? []).length;
  const progress = total > 0 ? (unlocked.length / total) * 100 : 0;

  return (
    <View style={[styles.screen, { backgroundColor: colors.background }]}>
      {/* Header */}
      <View style={[styles.header, { paddingTop: insets.top + Spacing.md }]}>
        <TouchableOpacity onPress={() => router.back()} style={[styles.backBtn, { backgroundColor: colors.surfaceElevated }]}>
          <Ionicons name="chevron-back" size={20} color={colors.text} />
        </TouchableOpacity>
        <View style={styles.headerInfo}>
          <Text style={[styles.screenTitle, { color: colors.text }]}>Thành tích</Text>
          <Text style={[styles.screenSub, { color: colors.textSecondary }]}>{unlocked.length}/{total} đã mở khóa</Text>
        </View>
      </View>

      {/* Progress */}
      <View style={styles.progressWrap}>
        <ProgressBar progress={progress} gradientColors={colors.gradientGold as unknown as string[]} height={6} animated />
      </View>

      {isLoading ? (
        <View style={styles.center}><ActivityIndicator size="large" color={colors.primary} /></View>
      ) : (
        <FlatList
          data={[...unlocked, ...locked]}
          keyExtractor={(item) => item.id}
          contentContainerStyle={styles.list}
          numColumns={2}
          columnWrapperStyle={styles.gridRow}
          renderItem={({ item }) => {
            const isUnlocked = item.unlocked;
            return (
              <View style={[styles.card, { backgroundColor: colors.card, opacity: isUnlocked ? 1 : 0.55 }, isUnlocked && Shadow.sm]}>
                <View style={[styles.cardIconWrap, { backgroundColor: isUnlocked ? colors.coinLight : colors.surfaceElevated }]}>
                  <Text style={styles.cardIcon}>{item.icon}</Text>
                </View>
                <Text style={[styles.cardTitle, { color: colors.text }]} numberOfLines={1}>{item.title}</Text>
                <Text style={[styles.cardDesc, { color: colors.textSecondary }]} numberOfLines={2}>{item.description}</Text>
                {isUnlocked ? (
                  <View style={[styles.unlockedBadge, { backgroundColor: colors.jade + '15' }]}>
                    <Ionicons name="checkmark-circle" size={12} color={colors.jade} />
                    <Text style={[styles.badgeText, { color: colors.jade }]}>Đã mở</Text>
                  </View>
                ) : (
                  <Text style={[styles.rewardText, { color: colors.xp }]}>+{item.xp_reward} XP</Text>
                )}
              </View>
            );
          }}
          ListEmptyComponent={<EmptyState iconName="trophy-outline" title="Chưa có thành tích" description="Hoàn thành bài học để mở khóa thành tích" />}
        />
      )}
    </View>
  );
}

const styles = StyleSheet.create({
  screen: { flex: 1 },
  header: { paddingHorizontal: Spacing.xl, flexDirection: 'row', alignItems: 'center', gap: Spacing.md, marginBottom: Spacing.md },
  backBtn: { width: 36, height: 36, borderRadius: 18, justifyContent: 'center', alignItems: 'center' },
  headerInfo: {},
  screenTitle: { fontSize: FontSize.xl, fontWeight: FontWeight.bold, letterSpacing: -0.3 },
  screenSub: { fontSize: FontSize.sm, marginTop: 2 },
  progressWrap: { paddingHorizontal: Spacing.xl, marginBottom: Spacing.lg },
  center: { flex: 1, justifyContent: 'center', alignItems: 'center' },
  list: { paddingHorizontal: Spacing.xl, paddingBottom: Spacing['4xl'] },
  gridRow: { gap: Spacing.md, marginBottom: Spacing.md },
  card: { flex: 1, padding: Spacing.lg, borderRadius: BorderRadius.xl, alignItems: 'center', gap: Spacing.sm },
  cardIconWrap: { width: 48, height: 48, borderRadius: 24, justifyContent: 'center', alignItems: 'center' },
  cardIcon: { fontSize: 24 },
  cardTitle: { fontSize: FontSize.sm, fontWeight: FontWeight.semibold, textAlign: 'center' },
  cardDesc: { fontSize: FontSize.xs, textAlign: 'center', lineHeight: 15 },
  unlockedBadge: { flexDirection: 'row', alignItems: 'center', gap: 3, paddingHorizontal: Spacing.sm, paddingVertical: 2, borderRadius: BorderRadius.full },
  badgeText: { fontSize: FontSize['2xs'], fontWeight: FontWeight.bold },
  rewardText: { fontSize: FontSize.xs, fontWeight: FontWeight.bold },
});
