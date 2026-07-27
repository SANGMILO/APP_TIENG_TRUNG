import React from 'react';
import { View, Text, StyleSheet, ScrollView, TouchableOpacity, ActivityIndicator } from 'react-native';
import { Ionicons } from '@expo/vector-icons';
import { router } from 'expo-router';
import { useSafeAreaInsets } from 'react-native-safe-area-context';
import { useQuery } from '@tanstack/react-query';
import { useThemeStore } from '@/stores/theme-store';
import { useAuthStore } from '@/stores/auth-store';
import { supabase } from '@/lib/supabase';
import { FadeInView, AnimatedPressable, GlassCard, ProgressBar } from '@/components/ui';
import { FontSize, Spacing, BorderRadius, Shadow, FontWeight } from '@/constants/theme';

export default function PronunciationScreen() {
  const { colors } = useThemeStore();
  const { profile } = useAuthStore();
  const insets = useSafeAreaInsets();

  const { data: stats, isLoading } = useQuery({
    queryKey: ['pronunciation-stats'],
    queryFn: async () => {
      if (!profile) return { totalAttempts: 0, avgScore: 0, todayAttempts: 0 };
      const today = new Date(); today.setHours(0, 0, 0, 0);
      const { data: all } = await supabase.from('pronunciation_attempts').select('overall_score').eq('user_id', profile.id);
      const { count: todayCount } = await supabase.from('pronunciation_attempts').select('*', { count: 'exact', head: true }).eq('user_id', profile.id).gte('created_at', today.toISOString());
      const scores = (all ?? []).map((a: any) => a.overall_score);
      const avg = scores.length > 0 ? Math.round(scores.reduce((s: number, v: number) => s + v, 0) / scores.length) : 0;
      return { totalAttempts: scores.length, avgScore: avg, todayAttempts: todayCount ?? 0 };
    },
    enabled: !!profile,
  });

  return (
    <View style={[styles.screen, { backgroundColor: colors.background }]}>
      <ScrollView contentContainerStyle={[styles.content, { paddingTop: insets.top + Spacing.lg }]} showsVerticalScrollIndicator={false}>
        {/* Header */}
        <FadeInView delay={50} animation="slideUp">
          <TouchableOpacity onPress={() => router.back()} style={[styles.backBtn, { backgroundColor: colors.surfaceElevated }]}>
            <Ionicons name="chevron-back" size={20} color={colors.text} />
          </TouchableOpacity>
          <Text style={[styles.screenTitle, { color: colors.text }]}>Luyện phát âm</Text>
          <Text style={[styles.screenSub, { color: colors.textSecondary }]}>Cải thiện giọng nói tiếng Trung</Text>
        </FadeInView>

        {/* Stats */}
        {isLoading ? (
          <ActivityIndicator size="small" color={colors.primary} style={{ marginVertical: Spacing.xl }} />
        ) : (
          <FadeInView delay={100} animation="slideUp">
            <View style={styles.statsRow}>
              <View style={[styles.statCard, { backgroundColor: colors.card }]}>
                <Ionicons name="speedometer-outline" size={20} color={colors.primary} />
                <Text style={[styles.statValue, { color: colors.primary }]}>{stats?.avgScore ?? 0}</Text>
                <Text style={[styles.statLabel, { color: colors.textSecondary }]}>Điểm TB</Text>
              </View>
              <View style={[styles.statCard, { backgroundColor: colors.card }]}>
                <Ionicons name="mic-outline" size={20} color={colors.xp} />
                <Text style={[styles.statValue, { color: colors.xp }]}>{stats?.totalAttempts ?? 0}</Text>
                <Text style={[styles.statLabel, { color: colors.textSecondary }]}>Lần luyện</Text>
              </View>
              <View style={[styles.statCard, { backgroundColor: colors.card }]}>
                <Ionicons name="today-outline" size={20} color={colors.streak} />
                <Text style={[styles.statValue, { color: colors.streak }]}>{stats?.todayAttempts ?? 0}</Text>
                <Text style={[styles.statLabel, { color: colors.textSecondary }]}>Hôm nay</Text>
              </View>
            </View>
          </FadeInView>
        )}

        {/* Actions */}
        <FadeInView delay={200} animation="slideUp">
          <Text style={[styles.sectionTitle, { color: colors.text }]}>Bắt đầu luyện</Text>
          <View style={styles.actions}>
            <ActionCard iconName="mic" title="Luyện tập nhanh" desc="Đọc từ vựng và nhận phản hồi AI" color={colors.primary} colors={colors} onPress={() => router.push('/pronunciation/practice')} />
            <ActionCard iconName="musical-notes" title="Luyện thanh điệu" desc="Nhận diện 4 thanh + thanh nhẹ" color={colors.jade} colors={colors} onPress={() => router.push('/pronunciation/tone-training')} />
            <ActionCard iconName="analytics" title="Lịch sử luyện tập" desc="Theo dõi tiến trình phát âm" color={colors.info} colors={colors} onPress={() => router.push('/pronunciation/history')} />
          </View>
        </FadeInView>
      </ScrollView>
    </View>
  );
}

function ActionCard({ iconName, title, desc, color, colors, onPress }: { iconName: string; title: string; desc: string; color: string; colors: any; onPress: () => void }) {
  return (
    <AnimatedPressable scaleValue={0.97} onPress={onPress}>
      <View style={[styles.actionCard, { backgroundColor: colors.card }]}>
        <View style={[styles.actionIcon, { backgroundColor: color + '12' }]}>
          <Ionicons name={iconName as any} size={22} color={color} />
        </View>
        <View style={{ flex: 1 }}>
          <Text style={[styles.actionTitle, { color: colors.text }]}>{title}</Text>
          <Text style={[styles.actionDesc, { color: colors.textSecondary }]}>{desc}</Text>
        </View>
        <Ionicons name="chevron-forward" size={18} color={colors.textTertiary} />
      </View>
    </AnimatedPressable>
  );
}

const styles = StyleSheet.create({
  screen: { flex: 1 },
  content: { paddingHorizontal: Spacing.xl, paddingBottom: Spacing['4xl'], maxWidth: 500, alignSelf: 'center', width: '100%' },
  backBtn: { width: 36, height: 36, borderRadius: 18, justifyContent: 'center', alignItems: 'center', marginBottom: Spacing.xl },
  screenTitle: { fontSize: FontSize['2xl'], fontWeight: FontWeight.bold, letterSpacing: -0.3, marginBottom: Spacing.xs },
  screenSub: { fontSize: FontSize.md, marginBottom: Spacing.xl },
  statsRow: { flexDirection: 'row', gap: Spacing.md, marginBottom: Spacing['2xl'] },
  statCard: { flex: 1, alignItems: 'center', paddingVertical: Spacing.lg, borderRadius: BorderRadius.xl, gap: Spacing.xs, ...Shadow.sm },
  statValue: { fontSize: FontSize.xl, fontWeight: FontWeight.bold },
  statLabel: { fontSize: FontSize.xs },
  sectionTitle: { fontSize: FontSize.lg, fontWeight: FontWeight.bold, marginBottom: Spacing.lg, letterSpacing: -0.2 },
  actions: { gap: Spacing.md },
  actionCard: { flexDirection: 'row', alignItems: 'center', padding: Spacing.lg, borderRadius: BorderRadius.xl, gap: Spacing.lg, ...Shadow.sm },
  actionIcon: { width: 44, height: 44, borderRadius: BorderRadius.lg, justifyContent: 'center', alignItems: 'center' },
  actionTitle: { fontSize: FontSize.base, fontWeight: FontWeight.semibold },
  actionDesc: { fontSize: FontSize.sm, marginTop: 2 },
});
