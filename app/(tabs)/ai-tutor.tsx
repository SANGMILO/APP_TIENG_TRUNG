import React from 'react';
import { View, Text, StyleSheet, ScrollView, TouchableOpacity } from 'react-native';
import { LinearGradient } from 'expo-linear-gradient';
import { Ionicons } from '@expo/vector-icons';
import { router } from 'expo-router';
import { useSafeAreaInsets } from 'react-native-safe-area-context';
import { useQuery } from '@tanstack/react-query';
import { useThemeStore } from '@/stores/theme-store';
import { useAuthStore } from '@/stores/auth-store';
import { fetchConversations, checkDailyLimit } from '@/services/ai-tutor-service';
import { FadeInView, AnimatedPressable, EmptyState } from '@/components/ui';
import { getPremiumTabContentInset } from '@/components/navigation/PremiumTabBar';
import { Shadow, FontWeight, FontFamily } from '@/constants/theme';
import { ConversationMode } from '@/lib/ai';

// ─── Scenario data (existing, preserved) ───

interface ScenarioData {
  mode: ConversationMode;
  title: string;
  desc: string;
  iconName: string;
  xp: number;
  difficulty: string;
  difficultyColor: 'easy' | 'hard' | 'medium';
}

const SCENARIOS: ScenarioData[] = [
  { mode: 'restaurant', title: 'Tại nhà hàng', desc: 'Gọi món, thanh toán, hỏi đường.', iconName: 'restaurant-outline', xp: 50, difficulty: 'Dễ', difficultyColor: 'easy' },
  { mode: 'work', title: 'Phỏng vấn xin việc', desc: 'Giới thiệu bản thân, kỹ năng, kinh nghiệm.', iconName: 'briefcase-outline', xp: 150, difficulty: 'Khó', difficultyColor: 'hard' },
  { mode: 'travel', title: 'Đi du lịch', desc: 'Hỏi đường, đặt vé, mua sắm.', iconName: 'airplane-outline', xp: 100, difficulty: 'Trung bình', difficultyColor: 'medium' },
  { mode: 'general', title: 'Trò chuyện', desc: 'Chat tự do về mọi chủ đề.', iconName: 'chatbubbles-outline', xp: 25, difficulty: 'Mọi cấp', difficultyColor: 'easy' },
  { mode: 'hsk', title: 'Luyện HSK', desc: 'Ôn tập từ vựng và ngữ pháp HSK.', iconName: 'school-outline', xp: 45, difficulty: 'Theo HSK', difficultyColor: 'medium' },
  { mode: 'grammar', title: 'Ngữ pháp', desc: 'Sửa lỗi và giải thích cấu trúc.', iconName: 'construct-outline', xp: 30, difficulty: 'Mọi cấp', difficultyColor: 'easy' },
];

export default function AiTutorScreen() {
  const { colors } = useThemeStore();
  const { profile } = useAuthStore();
  const insets = useSafeAreaInsets();

  // ─── Data queries (preserved) ───
  const {
    data: conversations,
    isError: conversationsError,
    refetch: refetchConversations,
  } = useQuery({
    queryKey: ['ai-conversations'],
    queryFn: fetchConversations,
    enabled: !!profile,
  });

  const {
    data: limitInfo,
    isError: limitError,
    refetch: refetchLimit,
  } = useQuery({
    queryKey: ['ai-daily-limit'],
    queryFn: checkDailyLimit,
    enabled: !!profile,
  });

  const recentConversations = (conversations ?? []).slice(0, 3);
  const limitUsed = limitInfo?.used ?? 0;
  const limitTotal = limitInfo?.limit ?? 50;

  return (
    <View style={[styles.screen, { backgroundColor: colors.background }]}>
      {/* ─── TopAppBar ─── */}
      <View style={[styles.topBar, { paddingTop: insets.top + 12 }]}>
        <View style={styles.topBarLeft}>
          <Ionicons name="flame" size={20} color={colors.primary} />
          <Text style={[styles.topBarBrand, { color: colors.primary }]}>Học Tiếng Trung</Text>
        </View>
        <TouchableOpacity style={[styles.topBarXpPill]} activeOpacity={0.7}>
          <Text style={[styles.topBarXpText, { color: colors.primary }]}>
            {profile?.total_xp ?? 0} XP
          </Text>
          <Ionicons name="star" size={12} color={colors.primary} />
        </TouchableOpacity>
      </View>

      <ScrollView
        contentContainerStyle={[
          styles.scrollContent,
          { paddingBottom: getPremiumTabContentInset(insets.bottom) },
        ]}
        showsVerticalScrollIndicator={false}
      >
        {/* ─── Hero Section ─── */}
        <FadeInView delay={50} animation="slideUp">
          <View style={[styles.heroCard, { backgroundColor: colors.surfaceElevated, borderColor: colors.border + '4D' }]}>
            <View style={styles.heroContent}>
              {/* Premium badge */}
              <View style={[styles.heroBadge, { backgroundColor: colors.card, borderColor: colors.border }]}>
                <Ionicons name="checkmark-circle" size={14} color={colors.primary} />
                <Text style={[styles.heroBadgeText, { color: colors.text }]}>Mandarin Master</Text>
              </View>

              {/* Heading */}
              <Text style={[styles.heroTitle, { color: colors.text }]}>
                Trò chuyện cùng <Text style={{ color: colors.primary }}>AI</Text>
              </Text>

              {/* Description */}
              <Text style={[styles.heroDesc, { color: colors.textSecondary }]}>
                Nâng cao kỹ năng giao tiếp với gia sư AI 24/7. Nhận phản hồi phát âm ngay lập tức.
              </Text>

              {/* CTA Button */}
              <AnimatedPressable
                scaleValue={0.98}
                onPress={() => router.push('/ai-tutor/voice')}
                style={styles.heroCtaWrap}
              >
                <LinearGradient
                  colors={[colors.primary, colors.primaryLight]}
                  start={{ x: 0, y: 0 }}
                  end={{ x: 1, y: 1 }}
                  style={styles.heroCta}
                >
                  <Ionicons name="mic" size={20} color="#FFFFFF" />
                  <Text style={styles.heroCtaText}>Bắt đầu hội thoại</Text>
                </LinearGradient>
              </AnimatedPressable>
            </View>

            {/* Voice wave visualization (decorative) */}
            <View style={styles.heroVisual}>
              <View style={styles.waveContainer}>
                {[8, 16, 12, 20, 10].map((h, i) => (
                  <View key={i} style={[styles.waveBar, { height: h * 2, backgroundColor: colors.primary + '60' }]} />
                ))}
              </View>
            </View>
          </View>
        </FadeInView>

        {/* ─── Usage indicator ─── */}
        {limitInfo && (
          <FadeInView delay={100} animation="slideUp">
            <View style={[styles.usageRow, { backgroundColor: colors.card, borderColor: colors.border }]}>
              <Ionicons name="chatbubble-outline" size={16} color={colors.textSecondary} />
              <Text style={[styles.usageText, { color: colors.textSecondary }]}>
                {limitUsed}/{limitTotal} tin nhắn hôm nay
              </Text>
              <View style={{ flex: 1 }} />
              <View style={[styles.usageBar, { backgroundColor: colors.border }]}>
                <View style={[styles.usageBarFill, { backgroundColor: colors.jade, width: `${Math.min(100, (limitUsed / limitTotal) * 100)}%` as any }]} />
              </View>
            </View>
          </FadeInView>
        )}

        {(conversationsError || limitError) && (
          <FadeInView delay={120} animation="slideUp">
            <EmptyState
              iconName="cloud-offline-outline"
              title="Không thể cập nhật hoạt động AI"
              description="Các tình huống luyện tập vẫn sẵn sàng. Hãy thử tải lại dữ liệu gần đây."
              actionLabel="Thử lại"
              onAction={() => {
                void refetchConversations();
                void refetchLimit();
              }}
            />
          </FadeInView>
        )}

        {/* ─── Conversation Scenarios ─── */}
        <FadeInView delay={200} animation="slideUp">
          <Text style={[styles.sectionTitle, { color: colors.text }]}>Tình huống giao tiếp</Text>
        </FadeInView>

        <View style={styles.scenarioGrid}>
          {SCENARIOS.slice(0, 3).map((scenario, i) => (
            <FadeInView key={scenario.mode} delay={250 + i * 80} animation="slideUp">
              <ScenarioCard scenario={scenario} colors={colors} />
            </FadeInView>
          ))}
        </View>

        {/* More scenarios (remaining) */}
        <FadeInView delay={500} animation="slideUp">
          <View style={styles.moreGrid}>
            {SCENARIOS.slice(3).map((scenario) => (
              <AnimatedPressable
                key={scenario.mode}
                scaleValue={0.96}
                onPress={() => router.push(`/ai-chat?mode=${scenario.mode}`)}
                style={styles.miniCardWrap}
              >
                <View style={[styles.miniCard, { backgroundColor: colors.card, borderColor: colors.border }]}>
                  <View style={[styles.miniIcon, { backgroundColor: colors.surfaceElevated }]}>
                    <Ionicons name={scenario.iconName as any} size={20} color={colors.text} />
                  </View>
                  <Text style={[styles.miniTitle, { color: colors.text }]}>{scenario.title}</Text>
                  <Text style={[styles.miniXp, { color: colors.primary }]}>+{scenario.xp}</Text>
                </View>
              </AnimatedPressable>
            ))}
          </View>
        </FadeInView>

        {/* ─── Recent Conversations ─── */}
        {recentConversations.length > 0 && (
          <FadeInView delay={600} animation="slideUp">
            <Text style={[styles.sectionTitle, { color: colors.text }]}>Gần đây</Text>
            <View style={[styles.recentList, { backgroundColor: colors.card, borderColor: colors.border }]}>
              {recentConversations.map((conv: any, i: number) => (
                <TouchableOpacity
                  key={conv.id}
                  style={[
                    styles.recentItem,
                    i < recentConversations.length - 1 && { borderBottomColor: colors.borderLight, borderBottomWidth: 1 },
                  ]}
                  onPress={() => router.push(`/ai-chat?conversationId=${conv.id}&mode=${conv.mode}`)}
                  activeOpacity={0.6}
                >
                  <View style={[styles.recentIcon, { backgroundColor: colors.surfaceElevated }]}>
                    <Ionicons name="chatbubble-outline" size={16} color={colors.textSecondary} />
                  </View>
                  <View style={{ flex: 1 }}>
                    <Text style={[styles.recentTitle, { color: colors.text }]}>{conv.title || 'Trò chuyện'}</Text>
                    <Text style={[styles.recentMeta, { color: colors.textTertiary }]}>{conv.message_count} tin • {conv.mode}</Text>
                  </View>
                  <Ionicons name="chevron-forward" size={18} color={colors.textTertiary} />
                </TouchableOpacity>
              ))}
            </View>
          </FadeInView>
        )}
      </ScrollView>
    </View>
  );
}

// ─── Scenario Card (Stitch style) ───

function ScenarioCard({ scenario, colors }: { scenario: ScenarioData; colors: any }) {
  const diffBg = scenario.difficultyColor === 'easy'
    ? colors.jadeLight + '30'
    : scenario.difficultyColor === 'hard'
      ? colors.primary + '12'
      : colors.border;
  const diffColor = scenario.difficultyColor === 'easy'
    ? colors.jade
    : scenario.difficultyColor === 'hard'
      ? colors.primary
      : colors.textTertiary;

  return (
    <AnimatedPressable
      scaleValue={0.97}
      onPress={() => router.push(`/ai-chat?mode=${scenario.mode}`)}
    >
      <View style={[styles.scenarioCard, { backgroundColor: colors.card, borderColor: colors.border }]}>
        {/* Header: difficulty + XP */}
        <View style={styles.scenarioHeader}>
          <View style={[styles.diffBadge, { backgroundColor: diffBg }]}>
            <Text style={[styles.diffText, { color: diffColor }]}>{scenario.difficulty}</Text>
          </View>
          <View style={styles.xpBadge}>
            <Text style={[styles.xpText, { color: colors.primary }]}>+{scenario.xp}</Text>
            <Ionicons name="flash" size={12} color={colors.primary} />
          </View>
        </View>

        {/* Icon */}
        <View style={[styles.scenarioIconCircle, { backgroundColor: colors.surfaceElevated }]}>
          <Ionicons name={scenario.iconName as any} size={24} color={colors.text} />
        </View>

        {/* Title + desc */}
        <Text style={[styles.scenarioTitle, { color: colors.text }]}>{scenario.title}</Text>
        <Text style={[styles.scenarioDesc, { color: colors.textSecondary }]}>{scenario.desc}</Text>
      </View>
    </AnimatedPressable>
  );
}

// ─── Styles ───

const styles = StyleSheet.create({
  screen: { flex: 1 },

  // TopAppBar
  topBar: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    paddingHorizontal: 20,
    paddingBottom: 12,
    ...Shadow.xs,
  },
  topBarLeft: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 8,
  },
  topBarBrand: {
    fontSize: 28, // Stitch headline-lg-mobile
    fontFamily: FontFamily.heading,
    fontWeight: FontWeight.bold,
    lineHeight: 34,
    letterSpacing: -0.5,
  },
  topBarXpPill: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 4,
  },
  topBarXpText: {
    fontSize: 12,
    fontFamily: FontFamily.semibold,
    fontWeight: FontWeight.semibold,
    lineHeight: 16,
  },

  // Scroll
  scrollContent: {
    paddingHorizontal: 20,
    paddingTop: 24,
    paddingBottom: 100,
    maxWidth: 512,
    alignSelf: 'center',
    width: '100%',
  },

  // ─── Hero ───
  heroCard: {
    borderRadius: 16, // Stitch rounded-2xl
    borderWidth: 1,
    padding: 24, // Stitch p-lg
    flexDirection: 'column',
    gap: 24,
    marginBottom: 32,
    overflow: 'hidden',
    ...Shadow.sm,
  },
  heroContent: {
    gap: 16, // Stitch space-y-md
  },
  heroBadge: {
    alignSelf: 'flex-start',
    flexDirection: 'row',
    alignItems: 'center',
    gap: 8,
    paddingHorizontal: 12,
    paddingVertical: 6,
    borderRadius: 9999,
    borderWidth: 1,
    ...Shadow.xs,
  },
  heroBadgeText: {
    fontSize: 12,
    fontFamily: FontFamily.semibold,
    fontWeight: FontWeight.semibold,
    lineHeight: 16,
  },
  heroTitle: {
    fontSize: 28, // Stitch headline-lg-mobile
    fontFamily: FontFamily.heading,
    fontWeight: FontWeight.bold,
    lineHeight: 34,
  },
  heroDesc: {
    fontSize: 16, // Stitch body-vn → text-secondary
    fontFamily: FontFamily.regular,
    lineHeight: 24,
    maxWidth: 320,
  },
  heroCtaWrap: {
    alignSelf: 'stretch',
  },
  heroCta: {
    height: 56, // Stitch h-[56px]
    borderRadius: 12, // Stitch rounded-xl
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'center',
    gap: 12,
    shadowColor: '#AC001E',
    shadowOffset: { width: 0, height: 4 },
    shadowOpacity: 0.2,
    shadowRadius: 20,
    elevation: 6,
  },
  heroCtaText: {
    fontSize: 12, // Stitch label-sm
    fontFamily: FontFamily.semibold,
    fontWeight: FontWeight.semibold,
    lineHeight: 16,
    color: '#FFFFFF',
  },
  heroVisual: {
    height: 80,
    justifyContent: 'center',
    alignItems: 'center',
    borderRadius: 12,
    overflow: 'hidden',
  },
  waveContainer: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 4,
  },
  waveBar: {
    width: 6, // Stitch w-1.5
    borderRadius: 3,
  },

  // ─── Usage ───
  usageRow: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 12,
    padding: 16,
    borderRadius: 12,
    borderWidth: 1,
    marginBottom: 32,
    ...Shadow.xs,
  },
  usageText: {
    fontSize: 13,
    fontFamily: FontFamily.medium,
    fontWeight: FontWeight.medium,
  },
  usageBar: {
    width: 60,
    height: 4,
    borderRadius: 2,
    overflow: 'hidden',
  },
  usageBarFill: {
    height: '100%',
    borderRadius: 2,
  },

  // ─── Section title ───
  sectionTitle: {
    fontSize: 24, // Stitch text-[24px]
    fontFamily: FontFamily.heading,
    fontWeight: FontWeight.bold,
    marginBottom: 16, // Stitch space-y-md
  },

  // ─── Scenario Grid ───
  scenarioGrid: {
    gap: 16, // Stitch gap-md
    marginBottom: 24,
  },
  scenarioCard: {
    borderRadius: 12, // Stitch rounded-xl
    borderWidth: 1,
    padding: 16, // Stitch p-md
    ...Shadow.sm,
  },
  scenarioHeader: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'flex-start',
    marginBottom: 16, // Stitch mb-md
  },
  diffBadge: {
    paddingHorizontal: 8,
    paddingVertical: 4,
    borderRadius: 6, // Stitch rounded-md
  },
  diffText: {
    fontSize: 10, // Stitch text-[10px]
    fontFamily: FontFamily.semibold,
    fontWeight: FontWeight.semibold,
  },
  xpBadge: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 4,
  },
  xpText: {
    fontSize: 14, // Stitch text-sm
    fontFamily: FontFamily.semibold,
    fontWeight: FontWeight.semibold,
  },
  scenarioIconCircle: {
    width: 48, // Stitch w-12
    height: 48,
    borderRadius: 24,
    justifyContent: 'center',
    alignItems: 'center',
    marginBottom: 16, // Stitch mb-md
  },
  scenarioTitle: {
    fontSize: 16, // Stitch text-[16px]
    fontFamily: FontFamily.semibold,
    fontWeight: FontWeight.semibold,
    marginBottom: 4, // Stitch mb-1
  },
  scenarioDesc: {
    fontSize: 14, // Stitch text-sm
    fontFamily: FontFamily.regular,
    lineHeight: 20,
  },

  // ─── Mini cards (remaining scenarios) ───
  moreGrid: {
    flexDirection: 'row',
    flexWrap: 'wrap',
    gap: 12,
    marginBottom: 32,
  },
  miniCardWrap: {
    width: '47%',
    flexGrow: 1,
  },
  miniCard: {
    borderRadius: 12,
    borderWidth: 1,
    padding: 16,
    alignItems: 'center',
    gap: 8,
    ...Shadow.xs,
  },
  miniIcon: {
    width: 40,
    height: 40,
    borderRadius: 10,
    justifyContent: 'center',
    alignItems: 'center',
  },
  miniTitle: {
    fontSize: 14,
    fontFamily: FontFamily.semibold,
    fontWeight: FontWeight.semibold,
    textAlign: 'center',
  },
  miniXp: {
    fontSize: 12,
    fontFamily: FontFamily.bold,
    fontWeight: FontWeight.bold,
  },

  // ─── Recent ───
  recentList: {
    borderRadius: 12,
    borderWidth: 1,
    overflow: 'hidden',
    ...Shadow.sm,
  },
  recentItem: {
    flexDirection: 'row',
    alignItems: 'center',
    padding: 16,
    gap: 16,
  },
  recentIcon: {
    width: 36,
    height: 36,
    borderRadius: 18,
    justifyContent: 'center',
    alignItems: 'center',
  },
  recentTitle: {
    fontSize: 16,
    fontFamily: FontFamily.medium,
    fontWeight: FontWeight.medium,
  },
  recentMeta: {
    fontSize: 12,
    fontFamily: FontFamily.regular,
    marginTop: 2,
  },
});
