import React, { useState } from 'react';
import {
  View,
  Text,
  StyleSheet,
  ScrollView,
  ActivityIndicator,
  TouchableOpacity,
} from 'react-native';
import { Ionicons } from '@expo/vector-icons';
import { LinearGradient } from 'expo-linear-gradient';
import { router } from 'expo-router';
import { useSafeAreaInsets } from 'react-native-safe-area-context';
import { useQuery } from '@tanstack/react-query';
import Svg, { Circle } from 'react-native-svg';
import { useThemeStore } from '@/stores/theme-store';
import { useAuthStore } from '@/stores/auth-store';
import { supabase } from '@/lib/supabase';
import { FadeInView, AnimatedPressable, PulsingDot, EmptyState } from '@/components/ui';
import { getPremiumTabContentInset } from '@/components/navigation/PremiumTabBar';
import { getGamificationSummary } from '@/services/gamification-service';
import { Shadow, FontWeight, FontFamily } from '@/constants/theme';
import { Lesson } from '@/types';

export default function LearnScreen() {
  const { colors } = useThemeStore();
  const { profile } = useAuthStore();
  const insets = useSafeAreaInsets();
  const [showAllLessons, setShowAllLessons] = useState(false);

  // ─── Data Queries (preserved exactly) ───
  const { data: courseData, isLoading, isError, refetch } = useQuery({
    queryKey: ['learning-path'],
    queryFn: async () => {
      const { data: courses, error: coursesError } = await supabase
        .from('courses').select('id, title, level').eq('status', 'published').order('order_index').limit(1);
      if (coursesError) throw coursesError;
      if (!courses?.length) return { course: null, lessons: [] as Lesson[] };
      const course = courses[0];
      const { data: units, error: unitsError } = await supabase
        .from('units').select('id').eq('course_id', course.id).eq('status', 'published').order('order_index').limit(1);
      if (unitsError) throw unitsError;
      if (!units?.length) return { course, lessons: [] as Lesson[] };
      const { data: chapters, error: chaptersError } = await supabase
        .from('chapters').select('id').eq('unit_id', units[0].id).eq('status', 'published').order('order_index').limit(1);
      if (chaptersError) throw chaptersError;
      if (!chapters?.length) return { course, lessons: [] as Lesson[] };
      const { data: lessonData, error: lessonsError } = await supabase
        .from('lessons').select('*').eq('chapter_id', chapters[0].id).eq('status', 'published').order('order_index');
      if (lessonsError) throw lessonsError;
      return { course, lessons: (lessonData ?? []) as Lesson[] };
    },
    enabled: !!profile,
  });

  const lessons = courseData?.lessons;
  const courseLevel = courseData?.course?.level ?? 'HSK 1'; // Fallback if no course data
  const courseTitle = courseData?.course?.title ?? 'Hành trình học';

  const {
    data: progress,
    isLoading: progressLoading,
    isError: progressError,
    refetch: refetchProgress,
  } = useQuery({
    queryKey: ['lesson-progress'],
    queryFn: async () => {
      if (!profile) return {};
      const { data, error } = await supabase
        .from('user_lesson_progress').select('lesson_id, status').eq('user_id', profile.id);
      if (error) throw error;
      const map: Record<string, string> = {};
      (data ?? []).forEach((p: any) => { map[p.lesson_id] = p.status; });
      return map;
    },
    enabled: !!profile,
  });

  const {
    data: gamificationSummary,
    isError: gamificationError,
    refetch: refetchGamification,
  } = useQuery({
    queryKey: ['gamification-summary'],
    queryFn: getGamificationSummary,
    enabled: !!profile,
  });

  // ─── Derived State (preserved) ───
  const dailyGoal = Math.max(
    1,
    gamificationSummary?.dailyGoalXp ?? profile?.daily_goal_xp ?? 20,
  );
  const todayXp = gamificationSummary?.todayXp ?? 0;
  const dailyProgress = Math.min(100, (todayXp / dailyGoal) * 100);
  const completedCount = lessons?.filter((_, i) => (progress ?? {})[lessons[i]?.id] === 'completed').length ?? 0;
  const totalLessons = lessons?.length ?? 0;
  const courseProgress = totalLessons > 0 ? Math.round((completedCount / totalLessons) * 100) : 0;

  // Find current lesson for hero card
  const currentLesson = progressError ? undefined : lessons?.find(
    (lesson, index) => getStatus(lesson.id, index, progress ?? {}) === 'current',
  ) ?? lessons?.find(
    (lesson, index) => getStatus(lesson.id, index, progress ?? {}) === 'available',
  ) ?? [...(lessons ?? [])].reverse().find(
    (lesson) => (progress ?? {})[lesson.id] === 'completed',
  );
  const currentLessonIndex = currentLesson ? (lessons?.indexOf(currentLesson) ?? 0) + 1 : 1;
  const visibleLessons = showAllLessons ? lessons : lessons?.slice(0, 4);

  // SVG circular progress calculations (Stitch: r=40, stroke-width=8, circumference=2πr=251.2)
  const CIRCLE_RADIUS = 40;
  const CIRCLE_CIRCUMFERENCE = 2 * Math.PI * CIRCLE_RADIUS;
  const dailyStrokeDashoffset = CIRCLE_CIRCUMFERENCE * (1 - dailyProgress / 100);

  return (
    <View style={[styles.screen, { backgroundColor: colors.background }]}>
      {/* ─── TopAppBar ─── */}
      <View style={[styles.topBar, { paddingTop: insets.top + 12 }]}>
        {/* Streak */}
        <View style={styles.topBarPill}>
          <Ionicons name="flame" size={20} color={colors.primary} />
          <Text style={[styles.topBarPillText, { color: colors.text }]}>
            {profile?.current_streak ?? 0}
          </Text>
        </View>

        {/* Brand */}
        <Text style={[styles.topBarBrand, { color: colors.primary }]}>Học Tiếng Trung</Text>

        {/* XP */}
        <View style={styles.topBarRight}>
          <View style={styles.topBarPill}>
            <Ionicons name="diamond-outline" size={16} color={colors.textSecondary} />
            <Text style={[styles.topBarPillText, { color: colors.text }]}>
              {profile?.total_xp ?? 0}
            </Text>
          </View>
        </View>
      </View>

      <ScrollView
        contentContainerStyle={[
          styles.scrollContent,
          { paddingBottom: getPremiumTabContentInset(insets.bottom) },
        ]}
        showsVerticalScrollIndicator={false}
      >
        {/* ─── Greeting ─── */}
        <FadeInView delay={50} animation="slideUp">
          <View style={styles.greetingSection}>
            <Text style={[styles.greetingTitle, { color: colors.text }]}>
              Chào bạn, {profile?.display_name || profile?.username || 'Bạn'}
            </Text>
            <Text style={[styles.greetingSub, { color: colors.textSecondary }]}>
              Sẵn sàng để tiếp tục hành trình hôm nay?
            </Text>
          </View>
        </FadeInView>

        {/* ─── Bento Grid ─── */}
        <View style={styles.bentoGrid}>
          {/* Hero: Continue Learning Card */}
          <FadeInView delay={150} animation="slideUp">
            <AnimatedPressable
              scaleValue={0.98}
              onPress={() => {
                if (currentLesson) router.push(`/lesson/${currentLesson.id}`);
              }}
              disabled={!currentLesson}
              accessibilityState={{ disabled: !currentLesson }}
            >
              <View style={[
                styles.heroCard,
                {
                  backgroundColor: colors.card,
                  borderColor: colors.border + '4D',
                  opacity: currentLesson ? 1 : 0.65,
                },
              ]}>
                {/* Decorative accent */}
                <View style={[styles.heroAccent, { backgroundColor: colors.primaryLight }]} />

                <View style={styles.heroTop}>
                  <View style={{ flex: 1 }}>
                    {/* Level badge */}
                    <View style={[styles.heroBadge, { backgroundColor: colors.jade + '15' }]}>
                      <Text style={[styles.heroBadgeText, { color: colors.jade }]}>{courseLevel}</Text>
                    </View>
                    {/* Title */}
                    <Text style={[styles.heroTitle, { color: colors.text }]}>
                      Bài {currentLessonIndex}:{'\n'}{currentLesson?.title || 'Bắt đầu học'}
                    </Text>
                  </View>
                  {/* Hanzi circle — display first CJK char from lesson title if available */}
                  <View style={[styles.heroHanzi, { backgroundColor: colors.surfaceElevated + '80' }]}>
                    <Text style={[styles.heroHanziText, { color: colors.primary }]}>
                      {getDisplayChar(currentLesson?.title)}
                    </Text>
                  </View>
                </View>

                {/* Progress */}
                <View style={styles.heroProgress}>
                  <View style={styles.heroProgressHeader}>
                    <Text style={[styles.heroProgressLabel, { color: colors.textSecondary }]}>
                      Tiến độ bài học
                    </Text>
                    <Text style={[styles.heroProgressLabel, { color: colors.textSecondary }]}>
                      {courseProgress}%
                    </Text>
                  </View>
                  <View style={[styles.heroProgressTrack, { backgroundColor: colors.jade + '1A' }]}>
                    <View style={[styles.heroProgressFill, { backgroundColor: colors.jade, width: `${courseProgress}%` as any }]} />
                  </View>
                </View>

                {/* CTA */}
                <View style={[styles.heroCta, { backgroundColor: colors.primary }]}>
                  <Text style={styles.heroCtaText}>
                    {currentLesson ? 'Tiếp tục học' : 'Chưa có bài học'}
                  </Text>
                  <Ionicons name="arrow-forward" size={20} color="#FFFFFF" />
                </View>
              </View>
            </AnimatedPressable>
          </FadeInView>

          {/* Row: Daily Goal + AI Tutor */}
          <View style={styles.bentoRow}>
            {/* Daily Goal Widget */}
            <FadeInView delay={250} animation="slideUp" style={{ flex: 1 }}>
              <View style={[styles.smallCard, { backgroundColor: colors.card, borderColor: colors.border + '4D' }]}>
                <Text style={[styles.smallCardLabel, { color: colors.textSecondary }]}>
                  MỤC TIÊU NGÀY
                </Text>
                {/* SVG Circular Progress — matches Stitch: w-24 h-24, r=40, stroke-width=8 */}
                <View style={styles.circularWrap}>
                  <Svg width={96} height={96} style={{ transform: [{ rotate: '-90deg' }] }}>
                    {/* Track */}
                    <Circle
                      cx={48}
                      cy={48}
                      r={CIRCLE_RADIUS}
                      fill="transparent"
                      stroke={colors.borderLight}
                      strokeWidth={8}
                    />
                    {/* Progress fill */}
                    <Circle
                      cx={48}
                      cy={48}
                      r={CIRCLE_RADIUS}
                      fill="transparent"
                      stroke={colors.primary}
                      strokeWidth={8}
                      strokeLinecap="round"
                      strokeDasharray={CIRCLE_CIRCUMFERENCE}
                      strokeDashoffset={dailyStrokeDashoffset}
                    />
                  </Svg>
                  {/* Center icon */}
                  <View style={styles.circularCenter}>
                    <Ionicons name="flash" size={24} color={colors.primary} />
                  </View>
                </View>
                <Text style={[styles.dailyValue, { color: colors.text }]}>
                  {todayXp ?? 0}/{dailyGoal}
                  <Text style={[styles.dailyUnit, { color: colors.textSecondary }]}> XP</Text>
                </Text>
                {gamificationError ? (
                  <TouchableOpacity onPress={() => { void refetchGamification(); }}>
                    <Text style={[styles.dailyHint, { color: colors.error }]}>
                      Không thể cập nhật · Thử lại
                    </Text>
                  </TouchableOpacity>
                ) : (
                  <Text style={[styles.dailyHint, { color: colors.textSecondary }]}>
                    {dailyProgress >= 100 ? 'Hoàn thành! 🎉' : 'Cố lên, sắp đạt mục tiêu!'}
                  </Text>
                )}
              </View>
            </FadeInView>

            {/* AI Tutor Teaser */}
            <FadeInView delay={350} animation="slideUp" style={{ flex: 1 }}>
              <AnimatedPressable
                scaleValue={0.97}
                onPress={() => router.push('/(tabs)/ai-tutor')}
                style={{ flex: 1 }}
              >
                <View style={[styles.smallCard, styles.aiCard, { backgroundColor: colors.card, borderColor: colors.border + '4D' }]}>
                  <View style={styles.aiCardHeader}>
                    <View style={[styles.aiIconCircle, { backgroundColor: colors.primary + '15' }]}>
                      <Ionicons name="chatbubble-ellipses-outline" size={20} color={colors.primary} />
                    </View>
                    <Text style={[styles.aiTitle, { color: colors.text }]}>Luyện nói với AI</Text>
                  </View>
                  <Text style={[styles.aiDesc, { color: colors.textSecondary }]}>
                    Chỉnh sửa phát âm chuẩn như người bản xứ.
                  </Text>
                  <View style={styles.aiChevron}>
                    <Ionicons name="chevron-forward" size={18} color={colors.textSecondary} />
                  </View>
                </View>
              </AnimatedPressable>
            </FadeInView>
          </View>
        </View>

        {/* ─── Learning Journey ─── */}
        <FadeInView delay={450} animation="slideUp">
          <View style={styles.journeyHeader}>
            <Text style={[styles.journeyTitle, { color: colors.text }]}>
              {courseTitle.length > 20 ? `Hành trình ${courseLevel}` : courseTitle}
            </Text>
            {totalLessons > 4 ? (
              <TouchableOpacity
                onPress={() => setShowAllLessons((visible) => !visible)}
                accessibilityRole="button"
                accessibilityState={{ expanded: showAllLessons }}
              >
                <Text style={[styles.journeySeeAll, { color: colors.primary }]}>
                  {showAllLessons ? 'Thu gọn' : 'Xem tất cả'}
                </Text>
              </TouchableOpacity>
            ) : null}
          </View>
        </FadeInView>

        {isLoading || progressLoading ? (
          <View style={styles.loading}>
            <ActivityIndicator size="large" color={colors.primary} />
          </View>
        ) : isError || progressError ? (
          <EmptyState
            iconName="cloud-offline-outline"
            title="Không thể tải hành trình học"
            description="Kiểm tra kết nối rồi thử lại."
            actionLabel="Thử lại"
            onAction={() => {
              void refetch();
              void refetchProgress();
            }}
          />
        ) : !lessons?.length ? (
          <FadeInView delay={500} animation="slideUp">
            <View style={[styles.emptyCard, { backgroundColor: colors.card, borderColor: colors.border }]}>
              <Text style={styles.emptyEmoji}>📚</Text>
              <Text style={[styles.emptyTitle, { color: colors.text }]}>Sắp có bài học mới!</Text>
              <Text style={[styles.emptyText, { color: colors.textSecondary }]}>Hãy quay lại sau nhé.</Text>
            </View>
          </FadeInView>
        ) : (
          <View style={styles.journeyContainer}>
            {/* Path line with gradient progress */}
            <View style={[styles.journeyPath, { backgroundColor: colors.border }]}>
              <LinearGradient
                colors={['#D4AF37', colors.primary]}
                start={{ x: 0, y: 0 }}
                end={{ x: 1, y: 0 }}
                style={[styles.journeyPathProgress, { width: `${Math.min(100, (completedCount / Math.max(1, totalLessons)) * 100)}%` as any }]}
              />
            </View>
            {/* Nodes */}
            <View style={styles.journeyNodes}>
              {visibleLessons?.map((lesson, i) => {
                const status = getStatus(lesson.id, i, progress ?? {});
                return (
                  <FadeInView key={lesson.id} delay={500 + i * 100} animation="slideUp">
                    <JourneyNode
                      lesson={lesson}
                      status={status}
                      index={i}
                      colors={colors}
                      onPress={() => { if (status !== 'locked') router.push(`/lesson/${lesson.id}`); }}
                    />
                  </FadeInView>
                );
              })}
            </View>
          </View>
        )}
      </ScrollView>
    </View>
  );
}

// ─── Helpers (preserved) ───

function getStatus(id: string, i: number, progress: Record<string, string>): 'completed' | 'current' | 'available' | 'locked' {
  const p = progress[id];
  if (p === 'completed') return 'completed';
  if (p === 'in_progress') return 'current';
  if (i === 0 && !p) return 'current';
  if (i > 0) {
    return p === 'available' ? 'available' : 'locked';
  }
  return 'locked';
}

/**
 * Extract a display character from lesson title.
 * Tries to find the first CJK character; falls back to a thematic character based on order.
 */
const CJK_REGEX = /[\u4e00-\u9fff]/;
const FALLBACK_CHARS = ['学', '说', '听', '写', '读', '词', '句', '文', '语', '话'];

function getDisplayChar(title?: string | null, orderIndex?: number): string {
  if (title) {
    const match = title.match(CJK_REGEX);
    if (match) return match[0];
  }
  return FALLBACK_CHARS[(orderIndex ?? 0) % FALLBACK_CHARS.length];
}

// ─── Journey Node ───

function JourneyNode({ lesson, status, index, colors, onPress }: {
  lesson: Lesson; status: string; index: number; colors: any; onPress: () => void;
}) {
  const isCurrent = status === 'current';
  const isCompleted = status === 'completed';
  const isLocked = status === 'locked';

  const charSymbol = getDisplayChar(lesson.title, lesson.order_index);

  const nodeSize = isCurrent ? 80 : 64;
  const isStaggered = index % 2 === 1;

  return (
    <AnimatedPressable
      onPress={onPress}
      disabled={isLocked}
      scaleValue={0.95}
      style={[styles.journeyNodeWrap, isStaggered && { marginTop: 32 }]}
    >
      {/* Pulsing ring for current */}
      {isCurrent && (
        <PulsingDot size={nodeSize + 16} color={colors.primary + '30'} style={styles.nodeRing} />
      )}

      <View style={[
        styles.journeyNodeCircle,
        {
          width: nodeSize,
          height: nodeSize,
          borderRadius: nodeSize / 2,
          backgroundColor: isCurrent ? colors.primary : isCompleted ? colors.card : colors.surfaceElevated,
          borderWidth: isCompleted ? 3 : isCurrent ? 4 : 3,
          borderColor: isCompleted ? colors.secondary : isCurrent ? colors.background : colors.border,
        },
        (isCurrent || isCompleted) && Shadow.colored(isCurrent ? colors.primary : colors.secondary),
      ]}>
        {isLocked ? (
          <Ionicons name="lock-closed" size={24} color={colors.textTertiary} />
        ) : isCompleted ? (
          <Ionicons name="checkmark" size={24} color={colors.secondary} />
        ) : (
          <Text style={[styles.nodeChar, { color: isCurrent ? '#FFFFFF' : colors.text }]}>{charSymbol}</Text>
        )}
      </View>

      <Text style={[
        styles.nodeLabel,
        { color: isCurrent ? colors.primary : isLocked ? colors.textTertiary : colors.textSecondary },
        isCurrent && { fontFamily: FontFamily.semibold, fontWeight: FontWeight.bold },
      ]} numberOfLines={1}>
        Bài {index + 1}
      </Text>
    </AnimatedPressable>
  );
}

// ─── Styles ───

const styles = StyleSheet.create({
  screen: { flex: 1 },

  // TopAppBar — Stitch: sticky, bg-surface/80, backdrop-blur, shadow-ambient
  topBar: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    paddingHorizontal: 20,
    paddingBottom: 12,
    ...Shadow.xs,
  },
  topBarPill: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 4,
    paddingHorizontal: 8,
    paddingVertical: 4,
    borderRadius: 8,
  },
  topBarPillText: {
    fontSize: 12,
    fontFamily: FontFamily.semibold,
    fontWeight: FontWeight.semibold,
    lineHeight: 16,
  },
  topBarBrand: {
    fontSize: 20,
    fontFamily: FontFamily.heading,
    fontWeight: FontWeight.bold,
    letterSpacing: -0.5,
  },
  topBarRight: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 12,
  },

  // Scroll content
  scrollContent: {
    paddingHorizontal: 20, // Stitch container-margin
    paddingTop: 24, // Stitch pt-lg
    paddingBottom: 100,
    maxWidth: 512, // Stitch max-w-lg
    alignSelf: 'center',
    width: '100%',
  },

  // Greeting — Stitch: animate-breathing-entrance
  greetingSection: {
    marginBottom: 32, // Stitch space-y-xl
  },
  greetingTitle: {
    fontSize: 28, // Stitch headline-lg-mobile
    fontFamily: FontFamily.heading,
    fontWeight: FontWeight.bold,
    lineHeight: 34,
    marginBottom: 4, // Stitch mb-1
  },
  greetingSub: {
    fontSize: 16, // Stitch body-vn
    fontFamily: FontFamily.regular,
    lineHeight: 24,
  },

  // Bento Grid — Stitch: grid grid-cols-1 md:grid-cols-2 gap-md
  bentoGrid: {
    gap: 16, // Stitch gap-md
    marginBottom: 32,
  },
  bentoRow: {
    flexDirection: 'row',
    gap: 16,
  },

  // Hero Card — Stitch: bg-surface-container-lowest rounded-xl shadow-ambient border p-lg
  heroCard: {
    borderRadius: 12, // Stitch rounded-xl
    borderWidth: 1,
    padding: 24, // Stitch p-lg
    position: 'relative',
    overflow: 'hidden',
    ...Shadow.sm,
  },
  heroAccent: {
    position: 'absolute',
    top: -40,
    right: -40,
    width: 128, // Stitch w-32
    height: 128,
    borderRadius: 64,
    opacity: 0.2,
  },
  heroTop: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'flex-start',
    marginBottom: 16,
  },
  heroBadge: {
    alignSelf: 'flex-start',
    paddingHorizontal: 12,
    paddingVertical: 4,
    borderRadius: 9999,
    marginBottom: 8, // Stitch mb-2
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
  heroHanzi: {
    width: 64, // Stitch w-16
    height: 64,
    borderRadius: 32,
    justifyContent: 'center',
    alignItems: 'center',
  },
  heroHanziText: {
    fontSize: 32, // Stitch text-[32px]
    fontFamily: FontFamily.chinese,
    fontWeight: FontWeight.medium,
  },
  heroProgress: {
    marginTop: 8, // Stitch mt-2
    marginBottom: 8,
  },
  heroProgressHeader: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    marginBottom: 4, // Stitch mb-1
  },
  heroProgressLabel: {
    fontSize: 12,
    fontFamily: FontFamily.semibold,
    fontWeight: FontWeight.semibold,
    lineHeight: 16,
  },
  heroProgressTrack: {
    height: 8, // Stitch h-2
    borderRadius: 4,
    overflow: 'hidden',
  },
  heroProgressFill: {
    height: '100%',
    borderRadius: 4,
  },
  heroCta: {
    marginTop: 8,
    width: '100%',
    height: 56, // Stitch h-[56px]
    borderRadius: 8, // Stitch rounded-lg
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'center',
    gap: 8,
    shadowColor: '#AC001E',
    shadowOffset: { width: 0, height: 4 },
    shadowOpacity: 0.3,
    shadowRadius: 14,
    elevation: 6,
  },
  heroCtaText: {
    fontSize: 12, // Stitch label-sm
    fontFamily: FontFamily.semibold,
    fontWeight: FontWeight.semibold,
    lineHeight: 16,
    color: '#FFFFFF',
  },

  // Small cards — Stitch: rounded-xl shadow-ambient border p-md
  smallCard: {
    flex: 1,
    borderRadius: 12,
    borderWidth: 1,
    padding: 16,
    alignItems: 'center',
    justifyContent: 'center',
    gap: 8,
    ...Shadow.sm,
  },
  smallCardLabel: {
    fontSize: 12,
    fontFamily: FontFamily.semibold,
    fontWeight: FontWeight.semibold,
    lineHeight: 16,
    letterSpacing: 1,
    textTransform: 'uppercase',
    width: '100%',
    textAlign: 'left',
  },
  circularWrap: {
    marginVertical: 8,
    position: 'relative',
    width: 96,
    height: 96,
    alignItems: 'center',
    justifyContent: 'center',
  },
  circularCenter: {
    position: 'absolute',
    justifyContent: 'center',
    alignItems: 'center',
  },
  dailyValue: {
    fontSize: 20,
    fontFamily: FontFamily.heading,
    fontWeight: FontWeight.bold,
  },
  dailyUnit: {
    fontSize: 12,
    fontFamily: FontFamily.semibold,
  },
  dailyHint: {
    fontSize: 13,
    fontFamily: FontFamily.regular,
    textAlign: 'center',
  },

  // AI Card
  aiCard: {
    justifyContent: 'space-between',
    alignItems: 'flex-start',
  },
  aiCardHeader: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 12,
  },
  aiIconCircle: {
    width: 40, // Stitch w-10
    height: 40,
    borderRadius: 20,
    justifyContent: 'center',
    alignItems: 'center',
  },
  aiTitle: {
    fontSize: 12,
    fontFamily: FontFamily.semibold,
    fontWeight: FontWeight.semibold,
    lineHeight: 16,
  },
  aiDesc: {
    fontSize: 14,
    fontFamily: FontFamily.regular,
    lineHeight: 20,
  },
  aiChevron: {
    alignSelf: 'flex-end',
  },

  // Journey section
  journeyHeader: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginBottom: 24, // Stitch mb-lg
  },
  journeyTitle: {
    fontSize: 22, // Stitch text-[22px]
    fontFamily: FontFamily.heading,
    fontWeight: FontWeight.bold,
  },
  journeySeeAll: {
    fontSize: 12,
    fontFamily: FontFamily.semibold,
    fontWeight: FontWeight.semibold,
    lineHeight: 16,
  },

  // Journey path visualization
  journeyContainer: {
    position: 'relative',
    paddingVertical: 32,
  },
  journeyPath: {
    position: 'absolute',
    top: '50%',
    left: 50,
    right: 50,
    height: 4,
    borderRadius: 2,
    marginTop: -2,
  },
  journeyPathProgress: {
    position: 'absolute',
    top: 0,
    left: 0,
    height: '100%',
    borderRadius: 2,
    overflow: 'hidden',
  },
  journeyNodes: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    paddingHorizontal: 16,
  },
  journeyNodeWrap: {
    alignItems: 'center',
    gap: 8,
  },
  nodeRing: {
    position: 'absolute',
  },
  journeyNodeCircle: {
    justifyContent: 'center',
    alignItems: 'center',
  },
  nodeChar: {
    fontSize: 24,
    fontFamily: FontFamily.chinese,
    fontWeight: FontWeight.medium,
  },
  nodeLabel: {
    fontSize: 11,
    fontFamily: FontFamily.semibold,
    fontWeight: FontWeight.semibold,
  },

  // Empty/Loading states
  loading: { paddingVertical: 40, alignItems: 'center' },
  emptyCard: {
    borderRadius: 12,
    borderWidth: 1,
    padding: 32,
    alignItems: 'center',
    gap: 8,
    ...Shadow.sm,
  },
  emptyEmoji: { fontSize: 48 },
  emptyTitle: { fontSize: 18, fontFamily: FontFamily.heading, fontWeight: FontWeight.bold },
  emptyText: { fontSize: 16, fontFamily: FontFamily.regular, textAlign: 'center' },
});
