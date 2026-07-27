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
import { FadeInView, AnimatedPressable, ProgressBar, GlassCard } from '@/components/ui';
import { FontSize, Spacing, BorderRadius, Shadow, FontWeight } from '@/constants/theme';
import { ConversationMode } from '@/lib/ai';

interface ScenarioData {
  mode: ConversationMode;
  title: string;
  desc: string;
  gradient: [string, string];
  iconName: string;
  xp: number;
  difficulty: string;
}

const SCENARIOS: ScenarioData[] = [
  { mode: 'restaurant', title: 'Nhà hàng', desc: 'Thử gọi món hoàn toàn bằng tiếng Trung', gradient: ['#D72638', '#EF4444'], iconName: 'restaurant-outline', xp: 30, difficulty: 'Beginner' },
  { mode: 'travel', title: 'Du lịch', desc: 'Hỏi đường, mua vé, đặt phòng', gradient: ['#2563EB', '#3B82F6'], iconName: 'airplane-outline', xp: 35, difficulty: 'Beginner' },
  { mode: 'general', title: 'Trò chuyện', desc: 'Chat tự do về mọi chủ đề', gradient: ['#059669', '#2D8B6F'], iconName: 'chatbubbles-outline', xp: 25, difficulty: 'Mọi cấp' },
  { mode: 'work', title: 'Công việc', desc: 'Giao tiếp chuyên nghiệp', gradient: ['#D4A017', '#F5D042'], iconName: 'briefcase-outline', xp: 40, difficulty: 'Intermediate' },
  { mode: 'hsk', title: 'Luyện HSK', desc: 'Ôn tập từ vựng và ngữ pháp HSK', gradient: ['#7C3AED', '#9333EA'], iconName: 'school-outline', xp: 45, difficulty: 'Theo HSK' },
  { mode: 'grammar', title: 'Ngữ pháp', desc: 'Sửa lỗi và giải thích cấu trúc', gradient: ['#EA580C', '#F97316'], iconName: 'construct-outline', xp: 30, difficulty: 'Mọi cấp' },
];

export default function AiTutorScreen() {
  const { colors } = useThemeStore();
  const { profile } = useAuthStore();
  const insets = useSafeAreaInsets();

  const { data: conversations } = useQuery({
    queryKey: ['ai-conversations'],
    queryFn: fetchConversations,
    enabled: !!profile,
  });

  const { data: limitInfo } = useQuery({
    queryKey: ['ai-daily-limit'],
    queryFn: checkDailyLimit,
    enabled: !!profile,
  });

  const recentConversations = (conversations ?? []).slice(0, 3);
  const limitUsed = limitInfo?.used ?? 0;
  const limitTotal = limitInfo?.limit ?? 50;
  const limitPercent = Math.min(100, (limitUsed / limitTotal) * 100);

  return (
    <View style={[styles.screen, { backgroundColor: colors.background }]}>
      <ScrollView
        contentContainerStyle={[styles.content, { paddingTop: insets.top + Spacing.lg, paddingBottom: 100 }]}
        showsVerticalScrollIndicator={false}
      >
        {/* Header */}
        <FadeInView delay={50} animation="slideUp">
          <Text style={[styles.screenTitle, { color: colors.text }]}>AI Tutor</Text>
          <Text style={[styles.screenSub, { color: colors.textSecondary }]}>
            Chọn tình huống để luyện hội thoại
          </Text>
        </FadeInView>

        {/* Usage indicator */}
        {limitInfo && (
          <FadeInView delay={100} animation="slideUp">
            <GlassCard variant="subtle" padding="sm" style={styles.usageCard}>
              <View style={styles.usageRow}>
                <Ionicons name="chatbubble-outline" size={16} color={colors.textSecondary} />
                <Text style={[styles.usageText, { color: colors.textSecondary }]}>
                  {limitUsed}/{limitTotal} tin nhắn hôm nay
                </Text>
                <View style={{ flex: 1 }} />
              </View>
              <ProgressBar progress={limitPercent} height={4} color={limitPercent > 80 ? colors.warning : colors.jade} />
            </GlassCard>
          </FadeInView>
        )}

        {/* Featured Scenario */}
        <FadeInView delay={150} animation="slideUp">
          <AnimatedPressable
            scaleValue={0.97}
            onPress={() => router.push(`/ai-chat?mode=${SCENARIOS[0].mode}`)}
          >
            <LinearGradient
              colors={SCENARIOS[0].gradient}
              start={{ x: 0, y: 0 }}
              end={{ x: 1, y: 1 }}
              style={styles.featuredCard}
            >
              <View style={styles.featuredBadge}>
                <Ionicons name="star" size={10} color="#fff" />
                <Text style={styles.featuredBadgeText}>Đề xuất</Text>
              </View>
              <View style={styles.featuredContent}>
                <View style={{ flex: 1 }}>
                  <Text style={styles.featuredTitle}>{SCENARIOS[0].title}</Text>
                  <Text style={styles.featuredDesc}>{SCENARIOS[0].desc}</Text>
                  <View style={styles.featuredMeta}>
                    <Text style={styles.featuredMetaText}>{SCENARIOS[0].difficulty}</Text>
                    <Text style={styles.featuredMetaText}>+{SCENARIOS[0].xp} XP</Text>
                  </View>
                </View>
                <View style={styles.featuredIconWrap}>
                  <Ionicons name={SCENARIOS[0].iconName as any} size={36} color="rgba(255,255,255,0.9)" />
                </View>
              </View>
            </LinearGradient>
          </AnimatedPressable>
        </FadeInView>

        {/* Scenario Grid */}
        <FadeInView delay={250} animation="slideUp">
          <Text style={[styles.sectionTitle, { color: colors.text }]}>Tình huống</Text>
          <View style={styles.scenarioGrid}>
            {SCENARIOS.slice(1).map((scenario, i) => (
              <ScenarioCard key={scenario.mode} scenario={scenario} colors={colors} delay={i * 50} />
            ))}
          </View>
        </FadeInView>

        {/* Recent Conversations */}
        {recentConversations.length > 0 && (
          <FadeInView delay={400} animation="slideUp">
            <Text style={[styles.sectionTitle, { color: colors.text }]}>Gần đây</Text>
            <View style={[styles.recentList, { backgroundColor: colors.card }]}>
              {recentConversations.map((conv: any, i: number) => (
                <TouchableOpacity
                  key={conv.id}
                  style={[styles.recentItem, i < recentConversations.length - 1 && { borderBottomColor: colors.borderLight, borderBottomWidth: 1 }]}
                  onPress={() => router.push(`/ai-chat?conversationId=${conv.id}&mode=${conv.mode}`)}
                  activeOpacity={0.6}
                >
                  <View style={[styles.recentIconWrap, { backgroundColor: colors.surfaceElevated }]}>
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

function ScenarioCard({ scenario, colors, delay }: { scenario: ScenarioData; colors: any; delay: number }) {
  return (
    <AnimatedPressable
      scaleValue={0.95}
      onPress={() => router.push(`/ai-chat?mode=${scenario.mode}`)}
      style={styles.scenarioWrapper}
    >
      <View style={[styles.scenarioCard, { backgroundColor: colors.card }]}>
        <View style={[styles.scenarioIconBg, { backgroundColor: scenario.gradient[0] + '12' }]}>
          <Ionicons name={scenario.iconName as any} size={22} color={scenario.gradient[0]} />
        </View>
        <Text style={[styles.scenarioTitle, { color: colors.text }]}>{scenario.title}</Text>
        <Text style={[styles.scenarioDesc, { color: colors.textTertiary }]} numberOfLines={2}>{scenario.desc}</Text>
        <View style={styles.scenarioFooter}>
          <Text style={[styles.scenarioDiff, { color: colors.textTertiary }]}>{scenario.difficulty}</Text>
          <Text style={[styles.scenarioXp, { color: colors.jade }]}>+{scenario.xp} XP</Text>
        </View>
      </View>
    </AnimatedPressable>
  );
}

const styles = StyleSheet.create({
  screen: { flex: 1 },
  content: { paddingHorizontal: Spacing.xl, maxWidth: 500, alignSelf: 'center', width: '100%' },
  screenTitle: { fontSize: FontSize['2xl'], fontWeight: FontWeight.bold, letterSpacing: -0.3, marginBottom: Spacing.xs },
  screenSub: { fontSize: FontSize.md, marginBottom: Spacing.xl },

  // Usage
  usageCard: { marginBottom: Spacing.xl },
  usageRow: { flexDirection: 'row', alignItems: 'center', gap: Spacing.sm, marginBottom: Spacing.sm },
  usageText: { fontSize: FontSize.sm, fontWeight: FontWeight.medium },

  // Featured
  featuredCard: { borderRadius: BorderRadius['2xl'], padding: Spacing.xl, marginBottom: Spacing['2xl'], position: 'relative', overflow: 'hidden', ...Shadow.lg },
  featuredBadge: { flexDirection: 'row', alignItems: 'center', gap: 4, backgroundColor: 'rgba(255,255,255,0.2)', alignSelf: 'flex-start', paddingHorizontal: Spacing.sm + 2, paddingVertical: 3, borderRadius: BorderRadius.full, marginBottom: Spacing.md },
  featuredBadgeText: { color: '#fff', fontSize: FontSize.xs, fontWeight: FontWeight.bold },
  featuredContent: { flexDirection: 'row', alignItems: 'center' },
  featuredTitle: { color: '#fff', fontSize: FontSize.xl, fontWeight: FontWeight.bold, marginBottom: 4 },
  featuredDesc: { color: 'rgba(255,255,255,0.85)', fontSize: FontSize.sm, fontWeight: FontWeight.medium, marginBottom: Spacing.sm },
  featuredMeta: { flexDirection: 'row', gap: Spacing.md },
  featuredMetaText: { color: 'rgba(255,255,255,0.7)', fontSize: FontSize.xs, fontWeight: FontWeight.semibold },
  featuredIconWrap: { width: 64, height: 64, borderRadius: 32, backgroundColor: 'rgba(255,255,255,0.15)', justifyContent: 'center', alignItems: 'center' },

  // Section
  sectionTitle: { fontSize: FontSize.lg, fontWeight: FontWeight.bold, marginBottom: Spacing.lg, letterSpacing: -0.2 },

  // Scenario grid
  scenarioGrid: { flexDirection: 'row', flexWrap: 'wrap', gap: Spacing.md, marginBottom: Spacing['2xl'] },
  scenarioWrapper: { width: '47%' },
  scenarioCard: { padding: Spacing.lg, borderRadius: BorderRadius.xl, gap: Spacing.sm, ...Shadow.sm },
  scenarioIconBg: { width: 40, height: 40, borderRadius: BorderRadius.md, justifyContent: 'center', alignItems: 'center' },
  scenarioTitle: { fontSize: FontSize.md, fontWeight: FontWeight.semibold },
  scenarioDesc: { fontSize: FontSize.xs, lineHeight: 16 },
  scenarioFooter: { flexDirection: 'row', justifyContent: 'space-between', marginTop: Spacing.xs },
  scenarioDiff: { fontSize: FontSize['2xs'], fontWeight: FontWeight.medium },
  scenarioXp: { fontSize: FontSize['2xs'], fontWeight: FontWeight.bold },

  // Recent
  recentList: { borderRadius: BorderRadius.xl, overflow: 'hidden', ...Shadow.sm },
  recentItem: { flexDirection: 'row', alignItems: 'center', padding: Spacing.lg, gap: Spacing.md },
  recentIconWrap: { width: 36, height: 36, borderRadius: 18, justifyContent: 'center', alignItems: 'center' },
  recentTitle: { fontSize: FontSize.md, fontWeight: FontWeight.medium },
  recentMeta: { fontSize: FontSize.xs, marginTop: 2 },
});
