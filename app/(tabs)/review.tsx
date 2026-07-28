import React from 'react';
import {
  View,
  Text,
  StyleSheet,
  ScrollView,
  TouchableOpacity,
  ActivityIndicator,
} from 'react-native';
import { Ionicons } from '@expo/vector-icons';
import { router } from 'expo-router';
import { useSafeAreaInsets } from 'react-native-safe-area-context';
import { useQuery } from '@tanstack/react-query';
import Svg, { Circle } from 'react-native-svg';
import { useThemeStore } from '@/stores/theme-store';
import { useAuthStore } from '@/stores/auth-store';
import { supabase } from '@/lib/supabase';
import { FadeInView, AnimatedPressable, EmptyState } from '@/components/ui';
import { getPremiumTabContentInset } from '@/components/navigation/PremiumTabBar';
import { Shadow, FontWeight, FontFamily } from '@/constants/theme';

// SVG donut ring constants (Stitch uses viewBox 0 0 36 36, r=15.9155, circumference≈100)
const RING_RADIUS = 15.9155;
const RING_CIRCUMFERENCE = 100; // Stitch uses stroke-dasharray="N, 100"

export default function ReviewScreen() {
  const { colors } = useThemeStore();
  const { profile } = useAuthStore();
  const insets = useSafeAreaInsets();

  // ─── Data Query (preserved exactly) ───
  const { data: stats, isLoading, isError, refetch } = useQuery({
    queryKey: ['review-stats', profile?.id],
    queryFn: async () => {
      if (!profile) return { due: 0, learning: 0, mastered: 0, mistakes: 0, total: 0 };
      const now = new Date().toISOString();
      const { count: due, error: dueError } = await supabase.from('user_vocabulary_progress').select('*', { count: 'exact', head: true }).eq('user_id', profile.id).lte('next_review_at', now);
      if (dueError) throw dueError;
      const { count: learning, error: learningError } = await supabase.from('user_vocabulary_progress').select('*', { count: 'exact', head: true }).eq('user_id', profile.id).in('state', ['new', 'learning', 'review']);
      if (learningError) throw learningError;
      const { count: mastered, error: masteredError } = await supabase.from('user_vocabulary_progress').select('*', { count: 'exact', head: true }).eq('user_id', profile.id).eq('state', 'mastered');
      if (masteredError) throw masteredError;
      const { count: total, error: totalError } = await supabase.from('user_vocabulary_progress').select('*', { count: 'exact', head: true }).eq('user_id', profile.id);
      if (totalError) throw totalError;
      const { count: mistakes, error: mistakesError } = await supabase.from('mistakes').select('*', { count: 'exact', head: true }).eq('user_id', profile.id).eq('reviewed', false);
      if (mistakesError) throw mistakesError;
      return { due: due ?? 0, learning: learning ?? 0, mastered: mastered ?? 0, mistakes: mistakes ?? 0, total: total ?? 0 };
    },
    enabled: !!profile,
  });

  // ─── Derived state ───
  const total = stats?.total ?? 0;
  const duePercent = total > 0 ? Math.round(((stats?.due ?? 0) / total) * 100) : 0;
  const learningPercent = total > 0 ? Math.round(((stats?.learning ?? 0) / total) * 100) : 0;
  const masteredPercent = total > 0 ? Math.round(((stats?.mastered ?? 0) / total) * 100) : 0;
  const mistakesPercent = total > 0 ? Math.min(100, Math.round(((stats?.mistakes ?? 0) / total) * 100)) : 0;

  return (
    <View style={[styles.screen, { backgroundColor: colors.background }]}>
      {/* ─── TopAppBar (Mobile) ─── */}
      <View style={[styles.topBar, { paddingTop: insets.top + 12 }]}>
        <TouchableOpacity style={styles.topBarPill} activeOpacity={0.7}>
          <Ionicons name="flame" size={20} color={colors.primary} />
        </TouchableOpacity>
        <Text style={[styles.topBarTitle, { color: colors.primary }]}>Ôn tập</Text>
        <View style={[styles.topBarXpPill, { backgroundColor: colors.surfaceElevated }]}>
          <Text style={[styles.topBarXpText, { color: colors.primary }]}>
            {profile?.total_xp ?? 0} XP
          </Text>
        </View>
      </View>

      <ScrollView
        contentContainerStyle={[
          styles.scrollContent,
          { paddingBottom: getPremiumTabContentInset(insets.bottom) },
        ]}
        showsVerticalScrollIndicator={false}
      >
        {isLoading ? (
          <View style={styles.loading}>
            <ActivityIndicator size="large" color={colors.primary} />
          </View>
        ) : isError ? (
          <EmptyState
            iconName="cloud-offline-outline"
            title="Không thể tải dữ liệu ôn tập"
            description="Kiểm tra kết nối rồi thử lại."
            actionLabel="Thử lại"
            onAction={() => { void refetch(); }}
          />
        ) : (
          <>
            {/* ─── Review Summary Card ─── */}
            <FadeInView delay={50} animation="slideUp">
              <View style={[styles.summaryCard, { backgroundColor: colors.card, borderColor: colors.border }]}>
                {/* Decorative background icon */}
                <View style={styles.summaryDecor}>
                  <Ionicons name="time-outline" size={160} color={colors.primary + '08'} />
                </View>

                <View style={styles.summaryContent}>
                  <Text style={[styles.summaryTitle, { color: colors.text }]}>
                    Đến hạn hôm nay
                  </Text>
                  <Text style={[styles.summaryDesc, { color: colors.textSecondary }]}>
                    {(stats?.due ?? 0) > 0
                      ? `Bạn có ${stats?.due} từ vựng cần ôn tập để giữ vững trí nhớ.`
                      : 'Tuyệt vời! Không có từ nào cần ôn hôm nay.'}
                  </Text>

                  {/* Stat badges */}
                  <View style={styles.summaryBadges}>
                    <View style={styles.summaryBadge}>
                      <Ionicons name="checkmark-circle" size={20} color={colors.jade} />
                      <Text style={[styles.summaryBadgeText, { color: colors.textTertiary }]}>
                        {stats?.due ?? 0} Từ vựng
                      </Text>
                    </View>
                    <View style={styles.summaryBadge}>
                      <Ionicons name="book" size={20} color={colors.jade} />
                      <Text style={[styles.summaryBadgeText, { color: colors.textTertiary }]}>
                        {stats?.mistakes ?? 0} Lỗi sai
                      </Text>
                    </View>
                  </View>
                </View>

                {/* CTA Button */}
                <AnimatedPressable
                  scaleValue={0.95}
                  onPress={() => { if ((stats?.due ?? 0) > 0) router.push('/review/session'); }}
                  disabled={(stats?.due ?? 0) === 0}
                  style={styles.summaryCTAWrap}
                >
                  <View style={[styles.summaryCTA, { backgroundColor: colors.primary, opacity: (stats?.due ?? 0) > 0 ? 1 : 0.5 }]}>
                    <Text style={styles.summaryCTAText}>Bắt đầu ôn tập</Text>
                    <Ionicons name="play" size={20} color="#FFFFFF" />
                  </View>
                </AnimatedPressable>
              </View>
            </FadeInView>

            {/* ─── Memory Progress Grid (2x2 with SVG rings) ─── */}
            <FadeInView delay={150} animation="slideUp">
              <Text style={[styles.sectionTitle, { color: colors.text }]}>Tiến độ ghi nhớ</Text>
              <View style={styles.progressGrid}>
                <ProgressRingCard
                  icon="time-outline"
                  label="Cần ôn"
                  value={stats?.due ?? 0}
                  percent={duePercent}
                  ringColor={colors.error}
                  iconColor={colors.error}
                  colors={colors}
                  delay={50}
                />
                <ProgressRingCard
                  icon="book-outline"
                  label="Đang học"
                  value={stats?.learning ?? 0}
                  percent={learningPercent}
                  ringColor={colors.textTertiary}
                  iconColor={colors.textTertiary}
                  colors={colors}
                  delay={100}
                />
                <ProgressRingCard
                  icon="medal-outline"
                  label="Thành thạo"
                  value={stats?.mastered ?? 0}
                  percent={masteredPercent}
                  ringColor={colors.jade}
                  iconColor={colors.jade}
                  colors={colors}
                  delay={150}
                />
                <ProgressRingCard
                  icon="warning-outline"
                  label="Hay sai"
                  value={stats?.mistakes ?? 0}
                  percent={mistakesPercent}
                  ringColor={colors.textTertiary}
                  iconColor={colors.textTertiary}
                  colors={colors}
                  delay={200}
                />
              </View>
            </FadeInView>

            {/* ─── Tools Section ─── */}
            <FadeInView delay={300} animation="slideUp">
              <Text style={[styles.sectionTitle, { color: colors.text }]}>Công cụ ôn tập</Text>
              <View style={styles.toolsGrid}>
                <ToolCard
                  icon="list-outline"
                  title="Tất cả từ vựng"
                  desc="Duyệt và tìm kiếm toàn bộ kho từ vựng của bạn."
                  iconColor={colors.textTertiary}
                  iconBg={colors.surfaceMuted}
                  colors={colors}
                  onPress={() => router.push('/review/my-words')}
                />
                <ToolCard
                  icon="bandage-outline"
                  title="Luyện tập lỗi sai"
                  desc="Tập trung vào những từ bạn thường trả lời sai."
                  iconColor={colors.error}
                  iconBg={colors.errorLight}
                  colors={colors}
                  onPress={() => router.push('/review/mistakes')}
                />
              </View>
            </FadeInView>
          </>
        )}
      </ScrollView>
    </View>
  );
}

// ─── Progress Ring Card ───

function ProgressRingCard({ icon, label, value, percent, ringColor, iconColor, colors, delay }: {
  icon: string; label: string; value: number; percent: number;
  ringColor: string; iconColor: string; colors: any; delay: number;
}) {
  const strokeDash = Math.min(RING_CIRCUMFERENCE, (percent / 100) * RING_CIRCUMFERENCE);

  return (
    <AnimatedPressable scaleValue={0.97} style={[styles.ringCard, { backgroundColor: colors.card, borderColor: colors.border }]}>
      {/* SVG ring */}
      <View style={styles.ringWrap}>
        <Svg width={64} height={64} viewBox="0 0 36 36">
          {/* Track */}
          <Circle
            cx="18" cy="18" r={RING_RADIUS}
            fill="transparent"
            stroke={colors.border}
            strokeWidth={3}
            strokeDasharray="100, 100"
            transform="rotate(-90 18 18)"
          />
          {/* Fill */}
          <Circle
            cx="18" cy="18" r={RING_RADIUS}
            fill="transparent"
            stroke={ringColor}
            strokeWidth={3}
            strokeDasharray={`${strokeDash}, ${RING_CIRCUMFERENCE}`}
            strokeLinecap="round"
            transform="rotate(-90 18 18)"
          />
        </Svg>
        {/* Center icon */}
        <View style={styles.ringIconCenter}>
          <Ionicons name={icon as any} size={18} color={iconColor} />
        </View>
      </View>
      <Text style={[styles.ringLabel, { color: colors.text }]}>{label}</Text>
      <Text style={[styles.ringValue, { color: colors.textTertiary }]}>{value}</Text>
    </AnimatedPressable>
  );
}

// ─── Tool Card ───

function ToolCard({ icon, title, desc, iconColor, iconBg, colors, onPress }: {
  icon: string; title: string; desc: string; iconColor: string; iconBg: string; colors: any; onPress: () => void;
}) {
  return (
    <AnimatedPressable scaleValue={0.97} onPress={onPress}>
      <View style={[styles.toolCard, { backgroundColor: colors.card, borderColor: colors.border }]}>
        <View style={[styles.toolIconCircle, { backgroundColor: iconBg }]}>
          <Ionicons name={icon as any} size={24} color={iconColor} />
        </View>
        <View style={styles.toolTextWrap}>
          <Text style={[styles.toolTitle, { color: colors.text }]}>{title}</Text>
          <Text style={[styles.toolDesc, { color: colors.textSecondary }]}>{desc}</Text>
        </View>
        <Ionicons name="chevron-forward" size={20} color={colors.textTertiary} />
      </View>
    </AnimatedPressable>
  );
}

// ─── Styles ───

const styles = StyleSheet.create({
  screen: { flex: 1 },

  // TopAppBar — Stitch mobile header
  topBar: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    paddingHorizontal: 20,
    paddingBottom: 12,
    ...Shadow.xs,
  },
  topBarPill: {
    width: 40,
    height: 40,
    justifyContent: 'center',
    alignItems: 'center',
  },
  topBarTitle: {
    fontSize: 28, // Stitch headline-lg-mobile
    fontFamily: FontFamily.heading,
    fontWeight: FontWeight.bold,
    lineHeight: 34,
    letterSpacing: -0.5,
  },
  topBarXpPill: {
    paddingHorizontal: 12,
    paddingVertical: 6,
    borderRadius: 9999,
  },
  topBarXpText: {
    fontSize: 12,
    fontFamily: FontFamily.semibold,
    fontWeight: FontWeight.semibold,
    lineHeight: 16,
  },

  // Scroll
  scrollContent: {
    paddingHorizontal: 20, // Stitch container-margin
    paddingTop: 24, // Stitch pt-lg
    paddingBottom: 120, // Account for floating bottom nav (pb-28 = 112px)
    maxWidth: 512,
    alignSelf: 'center',
    width: '100%',
  },

  loading: { paddingVertical: 40, alignItems: 'center' },

  // ─── Summary Card ───
  summaryCard: {
    borderRadius: 12, // Stitch rounded-xl
    borderWidth: 1,
    padding: 24, // Stitch p-lg
    position: 'relative',
    overflow: 'hidden',
    marginBottom: 32, // Stitch space-y-xl
    ...Shadow.sm,
  },
  summaryDecor: {
    position: 'absolute',
    top: -64,
    right: -64,
    opacity: 1,
  },
  summaryContent: {
    gap: 12, // Stitch gap-sm
    marginBottom: 24,
  },
  summaryTitle: {
    fontSize: 28, // Stitch headline-lg-mobile
    fontFamily: FontFamily.heading,
    fontWeight: FontWeight.bold,
    lineHeight: 34,
  },
  summaryDesc: {
    fontSize: 16, // Stitch body-vn
    fontFamily: FontFamily.regular,
    lineHeight: 24,
  },
  summaryBadges: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 16, // Stitch gap-4
    marginTop: 8, // Stitch mt-2
  },
  summaryBadge: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 8, // Stitch gap-2
  },
  summaryBadgeText: {
    fontSize: 12, // Stitch label-sm
    fontFamily: FontFamily.semibold,
    fontWeight: FontWeight.semibold,
    lineHeight: 16,
  },
  summaryCTAWrap: {
    width: '100%',
  },
  summaryCTA: {
    width: '100%',
    height: 56, // Stitch h-[56px]
    borderRadius: 9999, // Stitch rounded-full
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'center',
    gap: 8,
    ...Shadow.md,
  },
  summaryCTAText: {
    fontSize: 12, // Stitch label-sm
    fontFamily: FontFamily.semibold,
    fontWeight: FontWeight.semibold,
    lineHeight: 16,
    color: '#FFFFFF',
  },

  // ─── Section title ───
  sectionTitle: {
    fontSize: 28, // Stitch headline-lg-mobile
    fontFamily: FontFamily.heading,
    fontWeight: FontWeight.bold,
    lineHeight: 34,
    marginBottom: 16, // Stitch space-y-md
  },

  // ─── Progress Ring Grid (2x2) ───
  progressGrid: {
    flexDirection: 'row',
    flexWrap: 'wrap',
    gap: 16, // Stitch gap-md
    marginBottom: 32,
  },
  ringCard: {
    width: '47%',
    flexGrow: 1,
    borderRadius: 12, // Stitch rounded-xl
    borderWidth: 1,
    padding: 16, // Stitch p-md
    alignItems: 'center',
    justifyContent: 'center',
    gap: 8, // Stitch gap-xs
    ...Shadow.sm,
  },
  ringWrap: {
    position: 'relative',
    width: 64, // Stitch w-16 h-16
    height: 64,
    justifyContent: 'center',
    alignItems: 'center',
    marginBottom: 8, // Stitch mb-2
  },
  ringIconCenter: {
    position: 'absolute',
    justifyContent: 'center',
    alignItems: 'center',
  },
  ringLabel: {
    fontSize: 12, // Stitch label-sm
    fontFamily: FontFamily.semibold,
    fontWeight: FontWeight.semibold,
    lineHeight: 16,
  },
  ringValue: {
    fontSize: 16, // Stitch body-vn font-bold
    fontFamily: FontFamily.bold,
    fontWeight: FontWeight.bold,
    lineHeight: 24,
  },

  // ─── Tools ───
  toolsGrid: {
    gap: 24, // Stitch gap-lg
    marginBottom: 32,
  },
  toolCard: {
    borderRadius: 12, // Stitch rounded-xl
    borderWidth: 1,
    padding: 24, // Stitch p-lg
    flexDirection: 'row',
    alignItems: 'center',
    gap: 16, // Stitch gap-md
    ...Shadow.sm,
  },
  toolIconCircle: {
    width: 56, // Stitch w-14
    height: 56,
    borderRadius: 28,
    justifyContent: 'center',
    alignItems: 'center',
  },
  toolTextWrap: {
    flex: 1,
  },
  toolTitle: {
    fontSize: 18, // Stitch font-bold text-lg
    fontFamily: FontFamily.semibold,
    fontWeight: FontWeight.bold,
    marginBottom: 4, // Stitch mb-1
  },
  toolDesc: {
    fontSize: 14, // Stitch text-sm
    fontFamily: FontFamily.regular,
    lineHeight: 20,
  },
});
