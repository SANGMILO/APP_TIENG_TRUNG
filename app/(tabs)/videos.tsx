import React, { useState } from 'react';
import { View, Text, StyleSheet, ScrollView, TouchableOpacity, ActivityIndicator, TextInput, Image } from 'react-native';
import { LinearGradient } from 'expo-linear-gradient';
import { Ionicons } from '@expo/vector-icons';
import { router } from 'expo-router';
import { useSafeAreaInsets } from 'react-native-safe-area-context';
import { useQuery } from '@tanstack/react-query';
import { useThemeStore } from '@/stores/theme-store';
import { useAuthStore } from '@/stores/auth-store';
import { supabase } from '@/lib/supabase';
import { hasPotentialPlayableSource } from '@/services/video-service';
import { FadeInView, AnimatedPressable, EmptyState } from '@/components/ui';
import { getPremiumTabContentInset } from '@/components/navigation/PremiumTabBar';
import { Shadow, FontWeight, FontFamily } from '@/constants/theme';

// ─── Filter tabs — use level-based filtering (preserved from original, matches video-service.ts) ───
const LEVELS = ['all', 'starter', 'beginner', 'elementary', 'intermediate', 'advanced'];
const LEVEL_LABELS: Record<string, string> = { all: 'Tất cả', starter: 'Mới bắt đầu', beginner: 'Sơ cấp', elementary: 'Cơ bản', intermediate: 'Trung cấp', advanced: 'Nâng cao' };

export default function VideosScreen() {
  const { colors } = useThemeStore();
  const { profile } = useAuthStore();
  const insets = useSafeAreaInsets();
  const [selectedLevel, setSelectedLevel] = useState('all');
  const [search, setSearch] = useState('');

  // ─── Data Queries (preserved — level-based filtering restored) ───
  const { data: videos, isLoading, isError, refetch } = useQuery({
    queryKey: ['videos', selectedLevel],
    queryFn: async () => {
      let query = supabase
        .from('videos')
        .select('*')
        .eq('status', 'published')
        .eq('is_premium', false)
        .order('created_at', { ascending: false })
        .limit(30);
      if (selectedLevel !== 'all') query = query.eq('level', selectedLevel);
      const { data, error } = await query;
      if (error) throw error;
      return (data ?? []).filter((item: any) => hasPotentialPlayableSource(item));
    },
  });

  const { data: continueWatching } = useQuery({
    queryKey: ['continue-watching'],
    queryFn: async () => {
      if (!profile) return [];
      const { data, error } = await supabase
        .from('user_video_progress')
        .select(`
          video_id, progress_percent, last_position_ms,
          videos:video_id (
            id, title, level, category, duration_seconds, is_premium,
            thumbnail_url, video_url, video_path, external_url,
            playback_type, processing_status, status, source_type
          )
        `)
        .eq('user_id', profile.id)
        .is('completed_at', null)
        .gt('last_position_ms', 0)
        .order('last_watched_at', { ascending: false })
        .limit(5);
      if (error) throw error;
      return (data ?? []).filter(
        (item: any) => item.videos && hasPotentialPlayableSource(item.videos),
      );
    },
    enabled: !!profile,
  });

  const filteredVideos = search.trim()
    ? (videos ?? []).filter((v: any) => v.title.toLowerCase().includes(search.toLowerCase()) || v.description?.toLowerCase().includes(search.toLowerCase()))
    : videos ?? [];

  // Use first video as featured if available
  const featuredVideo = filteredVideos.length > 0 ? filteredVideos[0] : null;
  const remainingVideos = filteredVideos.slice(1);

  return (
    <View style={[styles.screen, { backgroundColor: colors.background }]}>
      {/* ─── TopAppBar ─── */}
      <View style={[styles.topBar, { paddingTop: insets.top + 12 }]}>
        <Ionicons name="flame" size={20} color={colors.primary} />
        <Text style={[styles.topBarBrand, { color: colors.primary }]}>Học Tiếng Trung</Text>
        <Text style={[styles.topBarXp, { color: colors.primary }]}>{profile?.total_xp ?? 0} XP</Text>
      </View>

      <ScrollView
        contentContainerStyle={[
          styles.scrollContent,
          { paddingBottom: getPremiumTabContentInset(insets.bottom) },
        ]}
        showsVerticalScrollIndicator={false}
      >
        {/* ─── Search Bar — Stitch: h-[56px] rounded-xl border shadow-ambient ─── */}
        <FadeInView delay={50} animation="slideUp">
          <View style={[styles.searchBar, { backgroundColor: colors.card, borderColor: colors.border + '4D' }]}>
            <Ionicons name="search" size={20} color={colors.textSecondary} />
            <TextInput
              style={[styles.searchInput, { color: colors.text }]}
              placeholder="Tìm kiếm video, từ vựng..."
              placeholderTextColor={colors.textTertiary}
              value={search}
              onChangeText={setSearch}
            />
            {search.length > 0 && (
              <TouchableOpacity onPress={() => setSearch('')}>
                <Ionicons name="close-circle" size={18} color={colors.textTertiary} />
              </TouchableOpacity>
            )}
          </View>
        </FadeInView>

        {/* ─── Level Filter Tabs — Stitch: horizontal scroll, pill chips ─── */}
        <FadeInView delay={100} animation="slideUp">
          <ScrollView horizontal showsHorizontalScrollIndicator={false} style={styles.tabsScroll} contentContainerStyle={styles.tabsContainer}>
            {LEVELS.map(level => (
              <TouchableOpacity
                key={level}
                style={[
                  styles.tabChip,
                  selectedLevel === level
                    ? { backgroundColor: colors.primary }
                    : { backgroundColor: colors.card, borderWidth: 1, borderColor: colors.border },
                ]}
                onPress={() => setSelectedLevel(level)}
                activeOpacity={0.7}
              >
                <Text style={[
                  styles.tabLabel,
                  { color: selectedLevel === level ? '#FFFFFF' : colors.text },
                ]}>
                  {LEVEL_LABELS[level]}
                </Text>
              </TouchableOpacity>
            ))}
          </ScrollView>
        </FadeInView>

        {/* ─── Featured Hero Video ─── */}
        {featuredVideo && (
          <FadeInView delay={150} animation="slideUp">
            <AnimatedPressable
              scaleValue={0.98}
              onPress={() => router.push(`/videos/${featuredVideo.id}`)}
            >
              <View style={styles.featuredCard}>
                {/* Thumbnail — real image or fallback */}
                <View style={[styles.featuredThumb, { backgroundColor: colors.surfaceMuted }]}>
                  {featuredVideo.thumbnail_url ? (
                    <Image
                      source={{ uri: featuredVideo.thumbnail_url }}
                      style={styles.featuredImage}
                      resizeMode="cover"
                    />
                  ) : (
                    <Ionicons name="film-outline" size={48} color={colors.textTertiary + '50'} />
                  )}
                </View>
                {/* Gradient overlay */}
                <LinearGradient
                  colors={['transparent', 'rgba(0,0,0,0.3)', 'rgba(0,0,0,0.8)']}
                  style={styles.featuredGradient}
                />
                {/* Play button center */}
                <View style={styles.featuredPlayWrap}>
                  <View style={styles.featuredPlayBtn}>
                    <Ionicons name="play" size={28} color="#FFFFFF" />
                  </View>
                </View>
                {/* "Nổi bật" badge */}
                <View style={styles.featuredBadge}>
                  <Text style={styles.featuredBadgeText}>Nổi bật hôm nay</Text>
                </View>
                {/* Continue watching badge */}
                {(continueWatching ?? []).some((cw: any) => cw.video_id === featuredVideo.id) && (
                  <View style={[styles.continueTag, { backgroundColor: colors.card + 'E6' }]}>
                    <Ionicons name="time-outline" size={14} color={colors.primary} />
                    <Text style={[styles.continueTagText, { color: colors.primary }]}>Tiếp tục xem</Text>
                  </View>
                )}
                {/* Bottom content */}
                <View style={styles.featuredContent}>
                  <Text style={styles.featuredTitle} numberOfLines={2}>
                    {featuredVideo.title}
                  </Text>
                  <View style={styles.featuredMeta}>
                    <Ionicons name="time-outline" size={14} color="rgba(255,255,255,0.7)" />
                    <Text style={styles.featuredMetaText}>{formatDuration(featuredVideo.duration_seconds)}</Text>
                    <Ionicons name="bar-chart-outline" size={14} color="rgba(255,255,255,0.7)" />
                    <Text style={styles.featuredMetaText}>{featuredVideo.level || 'Tất cả'}</Text>
                  </View>
                </View>
              </View>
            </AnimatedPressable>
          </FadeInView>
        )}

        {/* ─── Continue Watching (horizontal) ─── */}
        {(continueWatching ?? []).length > 0 && (
          <FadeInView delay={200} animation="slideUp">
            <Text style={[styles.sectionTitle, { color: colors.text }]}>Tiếp tục xem</Text>
            <ScrollView horizontal showsHorizontalScrollIndicator={false} contentContainerStyle={styles.continueList}>
              {(continueWatching ?? []).map((item: any) => (
                <AnimatedPressable
                  key={item.video_id}
                  scaleValue={0.97}
                  onPress={() => router.push(`/videos/${item.video_id}`)}
                  style={styles.continueCard}
                >
                  <View style={[styles.continueThumb, { backgroundColor: colors.surfaceMuted }]}>
                    {item.videos?.thumbnail_url ? (
                      <Image
                        source={{ uri: item.videos.thumbnail_url }}
                        style={styles.continueImage}
                        resizeMode="cover"
                      />
                    ) : (
                      <Ionicons name="play-circle" size={24} color={colors.textTertiary + '80'} />
                    )}
                    {/* Duration badge */}
                    <View style={styles.durationBadge}>
                      <Text style={styles.durationText}>{formatDuration(item.videos?.duration_seconds || 0)}</Text>
                    </View>
                    {/* Progress bar */}
                    <View style={styles.progressBarTrack}>
                      <View style={[styles.progressBarFill, { width: `${Math.max(0, Math.min(100, item.progress_percent ?? 0))}%` as any, backgroundColor: colors.primary }]} />
                    </View>
                  </View>
                  <Text style={[styles.continueTitle, { color: colors.text }]} numberOfLines={2}>
                    {item.videos?.title || ''}
                  </Text>
                </AnimatedPressable>
              ))}
            </ScrollView>
          </FadeInView>
        )}

        {/* ─── Video Feed — Stitch: horizontal row items ─── */}
        <FadeInView delay={300} animation="slideUp">
          <Text style={[styles.sectionTitle, { color: colors.text }]}>Gợi ý cho bạn</Text>
          {isLoading ? (
            <ActivityIndicator size="small" color={colors.primary} style={{ paddingVertical: 24 }} />
          ) : isError ? (
            <EmptyState
              iconName="cloud-offline-outline"
              title="Không thể tải video"
              description="Kiểm tra kết nối rồi thử lại."
              actionLabel="Thử lại"
              onAction={() => { void refetch(); }}
            />
          ) : remainingVideos.length === 0 && !featuredVideo ? (
            <View style={styles.emptyState}>
              <Ionicons name="videocam-off-outline" size={40} color={colors.textTertiary} />
              <Text style={[styles.emptyText, { color: colors.textSecondary }]}>Chưa có video nào</Text>
            </View>
          ) : (
            <View style={styles.videoFeed}>
              {remainingVideos.map((video: any, i: number) => (
                <FadeInView key={video.id} delay={350 + i * 50} animation="slideUp">
                  <VideoFeedItem video={video} colors={colors} />
                </FadeInView>
              ))}
            </View>
          )}
        </FadeInView>
      </ScrollView>
    </View>
  );
}

// ─── Video Feed Item (Stitch horizontal row layout) ───

function VideoFeedItem({ video, colors }: { video: any; colors: any }) {
  const levelColor = colors.jade;

  return (
    <AnimatedPressable
      scaleValue={0.98}
      onPress={() => router.push(`/videos/${video.id}`)}
    >
      <View style={[styles.feedItem, { backgroundColor: colors.card, borderColor: colors.border + '33' }]}>
        {/* Thumbnail */}
        <View style={[styles.feedThumb, { backgroundColor: colors.surfaceMuted }]}>
          {video.thumbnail_url ? (
            <Image
              source={{ uri: video.thumbnail_url }}
              style={styles.feedImage}
              resizeMode="cover"
            />
          ) : (
            <Ionicons name="play-circle" size={20} color={colors.textTertiary + '60'} />
          )}
          {/* Duration */}
          <View style={styles.feedDurationBadge}>
            <Text style={styles.feedDurationText}>{formatDuration(video.duration_seconds)}</Text>
          </View>
        </View>

        {/* Info */}
        <View style={styles.feedInfo}>
          {/* Category chip */}
          {video.category && (
            <View style={[styles.feedCategoryChip, { backgroundColor: colors.surfaceElevated }]}>
              <Text style={[styles.feedCategoryText, { color: colors.textTertiary }]}>
                {video.category}
              </Text>
            </View>
          )}
          <Text style={[styles.feedTitle, { color: colors.text }]} numberOfLines={2}>
            {video.title}
          </Text>
          <View style={styles.feedMeta}>
            <View style={[styles.feedLevelChip, { backgroundColor: levelColor + '15' }]}>
              <Text style={[styles.feedLevelText, { color: levelColor }]}>
                {video.level || 'Tất cả'}
              </Text>
            </View>
          </View>
        </View>
      </View>
    </AnimatedPressable>
  );
}

// ─── Helpers ───

function formatDuration(seconds: number): string {
  if (!seconds) return '0:00';
  const m = Math.floor(seconds / 60);
  const s = seconds % 60;
  return `${m}:${s.toString().padStart(2, '0')}`;
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
  topBarBrand: {
    fontSize: 28,
    fontFamily: FontFamily.heading,
    fontWeight: FontWeight.bold,
    lineHeight: 34,
    letterSpacing: -0.5,
  },
  topBarXp: {
    fontSize: 12,
    fontFamily: FontFamily.semibold,
    fontWeight: FontWeight.semibold,
    lineHeight: 16,
  },

  // Scroll
  scrollContent: {
    paddingHorizontal: 20, // Stitch container-margin
    paddingTop: 24,
    paddingBottom: 100,
    maxWidth: 512,
    alignSelf: 'center',
    width: '100%',
  },

  // ─── Search — Stitch: h-[56px] rounded-xl border shadow-ambient ───
  searchBar: {
    flexDirection: 'row',
    alignItems: 'center',
    height: 56,
    borderRadius: 12, // Stitch rounded-xl
    borderWidth: 1,
    paddingHorizontal: 16, // Stitch px-md
    gap: 12,
    marginBottom: 24,
    ...Shadow.sm,
  },
  searchInput: {
    flex: 1,
    fontSize: 16, // Stitch body-vn
    fontFamily: FontFamily.regular,
    height: '100%',
  },

  // ─── Category Tabs ───
  tabsScroll: {
    marginBottom: 24,
    marginHorizontal: -20, // extend to screen edge
  },
  tabsContainer: {
    paddingHorizontal: 20,
    gap: 12, // Stitch gap-sm
  },
  tabChip: {
    paddingHorizontal: 16, // Stitch px-md
    paddingVertical: 8, // Stitch py-2
    borderRadius: 9999, // Stitch rounded-full
    ...Shadow.xs,
  },
  tabLabel: {
    fontSize: 12, // Stitch label-sm
    fontFamily: FontFamily.semibold,
    fontWeight: FontWeight.semibold,
    lineHeight: 16,
  },

  // ─── Featured Hero ───
  featuredCard: {
    width: '100%',
    height: 240,
    borderRadius: 12, // Stitch rounded-xl
    overflow: 'hidden',
    position: 'relative',
    marginBottom: 32,
    ...Shadow.md,
  },
  featuredThumb: {
    position: 'absolute',
    top: 0,
    left: 0,
    right: 0,
    bottom: 0,
    justifyContent: 'center',
    alignItems: 'center',
  },
  featuredImage: {
    width: '100%',
    height: '100%',
  },
  featuredGradient: {
    position: 'absolute',
    top: 0,
    left: 0,
    right: 0,
    bottom: 0,
  },
  featuredPlayWrap: {
    position: 'absolute',
    top: 0,
    left: 0,
    right: 0,
    bottom: 0,
    justifyContent: 'center',
    alignItems: 'center',
  },
  featuredPlayBtn: {
    width: 64,
    height: 64,
    borderRadius: 32,
    backgroundColor: 'rgba(172, 0, 30, 0.9)',
    justifyContent: 'center',
    alignItems: 'center',
    ...Shadow.lg,
  },
  featuredBadge: {
    position: 'absolute',
    bottom: 64,
    left: 16,
    backgroundColor: 'rgba(59, 119, 91, 0.8)',
    paddingHorizontal: 8,
    paddingVertical: 4,
    borderRadius: 4,
  },
  featuredBadgeText: {
    fontSize: 10,
    fontFamily: FontFamily.semibold,
    fontWeight: FontWeight.semibold,
    color: '#FFFFFF',
    letterSpacing: 0.5,
    textTransform: 'uppercase',
  },
  continueTag: {
    position: 'absolute',
    top: 16,
    right: 16,
    flexDirection: 'row',
    alignItems: 'center',
    gap: 6,
    paddingHorizontal: 12,
    paddingVertical: 6,
    borderRadius: 9999,
    ...Shadow.xs,
  },
  continueTagText: {
    fontSize: 12,
    fontFamily: FontFamily.semibold,
    fontWeight: FontWeight.semibold,
    lineHeight: 16,
  },
  featuredContent: {
    position: 'absolute',
    bottom: 16,
    left: 16,
    right: 16,
  },
  featuredTitle: {
    fontSize: 28, // Stitch headline-lg-mobile
    fontFamily: FontFamily.heading,
    fontWeight: FontWeight.bold,
    lineHeight: 34,
    color: '#FFFFFF',
    marginBottom: 8,
  },
  featuredMeta: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 8,
  },
  featuredMetaText: {
    fontSize: 12,
    fontFamily: FontFamily.semibold,
    fontWeight: FontWeight.semibold,
    color: 'rgba(255,255,255,0.7)',
  },

  // ─── Continue Watching ───
  continueList: {
    gap: 16, // Stitch gap-md
    paddingRight: 20,
  },
  continueCard: {
    width: 160,
  },
  continueThumb: {
    width: 160,
    height: 96,
    borderRadius: 8,
    overflow: 'hidden',
    justifyContent: 'center',
    alignItems: 'center',
    position: 'relative',
    marginBottom: 8,
  },
  continueImage: {
    width: '100%',
    height: '100%',
    position: 'absolute',
  },
  durationBadge: {
    position: 'absolute',
    bottom: 6,
    right: 6,
    backgroundColor: 'rgba(0,0,0,0.75)',
    paddingHorizontal: 6,
    paddingVertical: 2,
    borderRadius: 4,
  },
  durationText: {
    fontSize: 10,
    fontWeight: FontWeight.semibold,
    color: '#FFFFFF',
  },
  progressBarTrack: {
    position: 'absolute',
    bottom: 0,
    left: 0,
    right: 0,
    height: 3,
    backgroundColor: 'rgba(255,255,255,0.3)',
  },
  progressBarFill: {
    height: '100%',
  },
  continueTitle: {
    fontSize: 14,
    fontFamily: FontFamily.medium,
    fontWeight: FontWeight.medium,
    lineHeight: 18,
  },

  // ─── Section title ───
  sectionTitle: {
    fontSize: 28, // Stitch headline-lg-mobile
    fontFamily: FontFamily.heading,
    fontWeight: FontWeight.bold,
    lineHeight: 34,
    marginBottom: 16,
  },

  // ─── Video Feed (Stitch: horizontal row items with thumb left) ───
  videoFeed: {
    gap: 16, // Stitch gap-lg
  },
  feedItem: {
    flexDirection: 'row',
    gap: 16, // Stitch gap-md
    padding: 12, // Stitch p-sm
    borderRadius: 12, // Stitch rounded-xl
    borderWidth: 1,
    ...Shadow.sm,
  },
  feedThumb: {
    width: 128, // Stitch w-32
    height: 96, // Stitch h-24
    borderRadius: 8, // Stitch rounded-lg
    overflow: 'hidden',
    justifyContent: 'center',
    alignItems: 'center',
    position: 'relative',
  },
  feedImage: {
    width: '100%',
    height: '100%',
    position: 'absolute',
  },
  feedDurationBadge: {
    position: 'absolute',
    bottom: 4,
    right: 4,
    backgroundColor: 'rgba(0,0,0,0.75)',
    paddingHorizontal: 6,
    paddingVertical: 2,
    borderRadius: 4,
  },
  feedDurationText: {
    fontSize: 10,
    fontWeight: FontWeight.semibold,
    color: '#FFFFFF',
  },
  feedInfo: {
    flex: 1,
    justifyContent: 'space-between',
    paddingVertical: 4,
  },
  feedCategoryChip: {
    alignSelf: 'flex-start',
    paddingHorizontal: 8,
    paddingVertical: 2,
    borderRadius: 9999,
    marginBottom: 4,
  },
  feedCategoryText: {
    fontSize: 10,
    fontFamily: FontFamily.semibold,
    fontWeight: FontWeight.semibold,
  },
  feedTitle: {
    fontSize: 16, // Stitch body-vn font-semibold
    fontFamily: FontFamily.semibold,
    fontWeight: FontWeight.semibold,
    lineHeight: 22,
  },
  feedMeta: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 8,
    marginTop: 8,
  },
  feedLevelChip: {
    paddingHorizontal: 6,
    paddingVertical: 2,
    borderRadius: 4,
  },
  feedLevelText: {
    fontSize: 10,
    fontFamily: FontFamily.bold,
    fontWeight: FontWeight.bold,
  },

  // ─── Empty ───
  emptyState: { alignItems: 'center', paddingVertical: 40, gap: 12 },
  emptyText: { fontSize: 16, fontFamily: FontFamily.regular },
});
