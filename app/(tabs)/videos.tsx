import React, { useState } from 'react';
import { View, Text, StyleSheet, ScrollView, TouchableOpacity, ActivityIndicator, TextInput } from 'react-native';
import { LinearGradient } from 'expo-linear-gradient';
import { Ionicons } from '@expo/vector-icons';
import { router } from 'expo-router';
import { useSafeAreaInsets } from 'react-native-safe-area-context';
import { useQuery } from '@tanstack/react-query';
import { useThemeStore } from '@/stores/theme-store';
import { useAuthStore } from '@/stores/auth-store';
import { supabase } from '@/lib/supabase';
import { VideoCard } from '@/components/video';
import { FadeInView, AnimatedPressable, ProgressBar } from '@/components/ui';
import { FontSize, Spacing, BorderRadius, Shadow, FontWeight } from '@/constants/theme';

const LEVELS = ['all', 'starter', 'beginner', 'elementary', 'intermediate', 'advanced'];
const LEVEL_LABELS: Record<string, string> = { all: 'Tất cả', starter: 'Mới bắt đầu', beginner: 'Sơ cấp', elementary: 'Cơ bản', intermediate: 'Trung cấp', advanced: 'Nâng cao' };

export default function VideosScreen() {
  const { colors } = useThemeStore();
  const { profile } = useAuthStore();
  const insets = useSafeAreaInsets();
  const [selectedLevel, setSelectedLevel] = useState('all');
  const [search, setSearch] = useState('');

  const { data: videos, isLoading } = useQuery({
    queryKey: ['videos', selectedLevel],
    queryFn: async () => {
      let query = supabase.from('videos').select('*').eq('status', 'published').order('created_at', { ascending: false }).limit(30);
      if (selectedLevel !== 'all') query = query.eq('level', selectedLevel);
      const { data, error } = await query;
      if (error) throw error;
      return data ?? [];
    },
  });

  const { data: continueWatching } = useQuery({
    queryKey: ['continue-watching'],
    queryFn: async () => {
      if (!profile) return [];
      const { data, error } = await supabase
        .from('user_video_progress')
        .select('video_id, progress_percent, last_position_ms, videos:video_id (id, title, level, category, duration_seconds, is_premium)')
        .eq('user_id', profile.id)
        .is('completed_at', null)
        .gt('last_position_ms', 0)
        .order('last_watched_at', { ascending: false })
        .limit(5);
      if (error) throw error;
      return data ?? [];
    },
    enabled: !!profile,
  });

  const filteredVideos = search.trim()
    ? (videos ?? []).filter((v: any) => v.title.toLowerCase().includes(search.toLowerCase()) || v.description?.toLowerCase().includes(search.toLowerCase()))
    : videos ?? [];

  return (
    <View style={[styles.screen, { backgroundColor: colors.background }]}>
      <ScrollView
        contentContainerStyle={[styles.content, { paddingTop: insets.top + Spacing.lg, paddingBottom: 100 }]}
        showsVerticalScrollIndicator={false}
      >
        {/* Header */}
        <FadeInView delay={50} animation="slideUp">
          <Text style={[styles.screenTitle, { color: colors.text }]}>Video</Text>
          <Text style={[styles.screenSub, { color: colors.textSecondary }]}>Học tiếng Trung qua video tương tác</Text>
        </FadeInView>

        {/* Search */}
        <FadeInView delay={100} animation="slideUp">
          <View style={[styles.searchWrap, { backgroundColor: colors.surfaceElevated }]}>
            <Ionicons name="search-outline" size={18} color={colors.textTertiary} />
            <TextInput
              style={[styles.searchInput, { color: colors.text }]}
              placeholder="Tìm video..."
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

        {/* Level filter */}
        <FadeInView delay={150} animation="slideUp">
          <ScrollView horizontal showsHorizontalScrollIndicator={false} style={styles.filterScroll}>
            <View style={styles.filterRow}>
              {LEVELS.map(l => (
                <TouchableOpacity
                  key={l}
                  style={[
                    styles.filterChip,
                    selectedLevel === l
                      ? { backgroundColor: colors.primary, borderColor: colors.primary }
                      : { backgroundColor: colors.card, borderColor: 'transparent' },
                  ]}
                  onPress={() => setSelectedLevel(l)}
                >
                  <Text style={[styles.filterLabel, { color: selectedLevel === l ? '#fff' : colors.textSecondary }]}>
                    {LEVEL_LABELS[l] || l}
                  </Text>
                </TouchableOpacity>
              ))}
            </View>
          </ScrollView>
        </FadeInView>

        {/* Featured placeholder */}
        <FadeInView delay={200} animation="slideUp">
          <AnimatedPressable scaleValue={0.98}>
            <LinearGradient
              colors={colors.gradientNight as unknown as [string, string, ...string[]]}
              start={{ x: 0, y: 0 }}
              end={{ x: 1, y: 1 }}
              style={styles.featuredCard}
            >
              <View style={styles.featuredOverlay}>
                <View style={styles.featuredBadge}>
                  <Ionicons name="star" size={10} color="#fff" />
                  <Text style={styles.featuredBadgeText}>Nổi bật</Text>
                </View>
                <Text style={styles.featuredTitle}>Tiếng Trung qua phim</Text>
                <Text style={styles.featuredDesc}>Học từ vựng & ngữ pháp qua cảnh phim nổi tiếng</Text>
                <View style={styles.featuredMeta}>
                  <Ionicons name="play-circle" size={14} color="rgba(255,255,255,0.7)" />
                  <Text style={styles.featuredMetaText}>12 tập • Beginner</Text>
                </View>
              </View>
              <View style={styles.featuredIconWrap}>
                <Ionicons name="film-outline" size={40} color="rgba(255,255,255,0.5)" />
              </View>
            </LinearGradient>
          </AnimatedPressable>
        </FadeInView>

        {/* Continue Watching */}
        {(continueWatching ?? []).length > 0 && (
          <FadeInView delay={250} animation="slideUp">
            <Text style={[styles.sectionTitle, { color: colors.text }]}>Tiếp tục xem</Text>
            <ScrollView horizontal showsHorizontalScrollIndicator={false}>
              <View style={styles.horizontalList}>
                {(continueWatching ?? []).map((item: any) => (
                  <View key={item.video_id} style={{ width: 220 }}>
                    <VideoCard
                      title={item.videos?.title || ''}
                      level={item.videos?.level || ''}
                      category={item.videos?.category}
                      durationSeconds={item.videos?.duration_seconds || 0}
                      progress={item.progress_percent}
                      isPremium={item.videos?.is_premium}
                      onPress={() => router.push(`/videos/${item.video_id}`)}
                    />
                  </View>
                ))}
              </View>
            </ScrollView>
          </FadeInView>
        )}

        {/* All Videos */}
        <FadeInView delay={300} animation="slideUp">
          <Text style={[styles.sectionTitle, { color: colors.text }]}>
            {selectedLevel === 'all' ? 'Tất cả video' : LEVEL_LABELS[selectedLevel]}
          </Text>
          {isLoading ? (
            <ActivityIndicator size="small" color={colors.primary} style={{ paddingVertical: Spacing['2xl'] }} />
          ) : filteredVideos.length === 0 ? (
            <View style={styles.emptyState}>
              <Ionicons name="videocam-off-outline" size={40} color={colors.textTertiary} />
              <Text style={[styles.emptyText, { color: colors.textSecondary }]}>Chưa có video nào</Text>
            </View>
          ) : (
            <View style={styles.videoGrid}>
              {filteredVideos.map((video: any) => (
                <View key={video.id} style={styles.videoItem}>
                  <VideoCard
                    title={video.title}
                    level={video.level}
                    category={video.category}
                    durationSeconds={video.duration_seconds}
                    isPremium={video.is_premium}
                    onPress={() => router.push(`/videos/${video.id}`)}
                  />
                </View>
              ))}
            </View>
          )}
        </FadeInView>
      </ScrollView>
    </View>
  );
}

const styles = StyleSheet.create({
  screen: { flex: 1 },
  content: { paddingHorizontal: Spacing.xl, maxWidth: 500, alignSelf: 'center', width: '100%' },
  screenTitle: { fontSize: FontSize['2xl'], fontWeight: FontWeight.bold, letterSpacing: -0.3, marginBottom: Spacing.xs },
  screenSub: { fontSize: FontSize.md, marginBottom: Spacing.xl },

  // Search
  searchWrap: { flexDirection: 'row', alignItems: 'center', borderRadius: BorderRadius.lg, paddingHorizontal: Spacing.lg, paddingVertical: Spacing.md, gap: Spacing.sm, marginBottom: Spacing.lg },
  searchInput: { flex: 1, fontSize: FontSize.base },

  // Filter
  filterScroll: { marginBottom: Spacing.xl },
  filterRow: { flexDirection: 'row', gap: Spacing.sm },
  filterChip: { paddingHorizontal: Spacing.lg, paddingVertical: Spacing.sm + 2, borderRadius: BorderRadius.full },
  filterLabel: { fontSize: FontSize.sm, fontWeight: FontWeight.semibold },

  // Featured
  featuredCard: { borderRadius: BorderRadius['2xl'], padding: Spacing.xl, flexDirection: 'row', alignItems: 'center', marginBottom: Spacing['2xl'], minHeight: 140, overflow: 'hidden', ...Shadow.lg },
  featuredOverlay: { flex: 1 },
  featuredBadge: { flexDirection: 'row', alignItems: 'center', gap: 4, backgroundColor: 'rgba(255,255,255,0.15)', alignSelf: 'flex-start', paddingHorizontal: Spacing.sm + 2, paddingVertical: 3, borderRadius: BorderRadius.full, marginBottom: Spacing.md },
  featuredBadgeText: { color: '#fff', fontSize: FontSize.xs, fontWeight: FontWeight.bold },
  featuredTitle: { color: '#fff', fontSize: FontSize.lg, fontWeight: FontWeight.bold, marginBottom: 4 },
  featuredDesc: { color: 'rgba(255,255,255,0.75)', fontSize: FontSize.sm, marginBottom: Spacing.sm },
  featuredMeta: { flexDirection: 'row', alignItems: 'center', gap: 4 },
  featuredMetaText: { color: 'rgba(255,255,255,0.6)', fontSize: FontSize.xs, fontWeight: FontWeight.medium },
  featuredIconWrap: { width: 64, height: 64, borderRadius: 32, backgroundColor: 'rgba(255,255,255,0.08)', justifyContent: 'center', alignItems: 'center' },

  // Sections
  sectionTitle: { fontSize: FontSize.lg, fontWeight: FontWeight.bold, marginBottom: Spacing.lg, letterSpacing: -0.2 },
  horizontalList: { flexDirection: 'row', gap: Spacing.md },
  videoGrid: { gap: Spacing.md },
  videoItem: {},
  emptyState: { alignItems: 'center', paddingVertical: Spacing['4xl'], gap: Spacing.md },
  emptyText: { fontSize: FontSize.md },
});
