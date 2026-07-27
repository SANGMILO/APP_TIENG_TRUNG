import React from 'react';
import { View, Text, StyleSheet, FlatList, TouchableOpacity, ActivityIndicator } from 'react-native';
import { Ionicons } from '@expo/vector-icons';
import { router } from 'expo-router';
import { useSafeAreaInsets } from 'react-native-safe-area-context';
import { useQuery } from '@tanstack/react-query';
import { useThemeStore } from '@/stores/theme-store';
import { useAuthStore } from '@/stores/auth-store';
import { supabase } from '@/lib/supabase';
import { getScoreLevel, getScoreLevelColor } from '@/lib/speech';
import { EmptyState } from '@/components/ui';
import { FontSize, Spacing, BorderRadius, Shadow, FontWeight } from '@/constants/theme';

export default function PronunciationHistoryScreen() {
  const { colors } = useThemeStore();
  const { profile } = useAuthStore();
  const insets = useSafeAreaInsets();

  const { data: attempts, isLoading } = useQuery({
    queryKey: ['pronunciation-history'],
    queryFn: async () => {
      if (!profile) return [];
      const { data, error } = await supabase
        .from('pronunciation_attempts').select('*').eq('user_id', profile.id).order('created_at', { ascending: false }).limit(50);
      if (error) throw error;
      return data ?? [];
    },
    enabled: !!profile,
  });

  return (
    <View style={[styles.screen, { backgroundColor: colors.background }]}>
      {/* Header */}
      <View style={[styles.header, { paddingTop: insets.top + Spacing.md }]}>
        <TouchableOpacity onPress={() => router.back()} style={[styles.backBtn, { backgroundColor: colors.surfaceElevated }]}>
          <Ionicons name="chevron-back" size={20} color={colors.text} />
        </TouchableOpacity>
        <Text style={[styles.screenTitle, { color: colors.text }]}>Lịch sử phát âm</Text>
        <View style={{ width: 36 }} />
      </View>

      {isLoading ? (
        <View style={styles.center}><ActivityIndicator size="large" color={colors.primary} /></View>
      ) : (
        <FlatList
          data={attempts}
          keyExtractor={(item: any) => item.id}
          contentContainerStyle={styles.list}
          renderItem={({ item }: { item: any }) => {
            const level = getScoreLevel(item.overall_score);
            const levelColor = getScoreLevelColor(level, colors);
            const date = new Date(item.created_at);

            return (
              <View style={[styles.card, { backgroundColor: colors.card }]}>
                <View style={styles.cardRow}>
                  <View style={{ flex: 1 }}>
                    <Text style={[styles.cardChinese, { color: colors.text }]}>{item.reference_text}</Text>
                    <View style={styles.cardMeta}>
                      <Text style={[styles.metaText, { color: colors.textSecondary }]}>
                        Accuracy {item.accuracy_score}
                      </Text>
                      <Text style={[styles.metaDot, { color: colors.border }]}>·</Text>
                      <Text style={[styles.metaText, { color: colors.textSecondary }]}>
                        Fluency {item.fluency_score}
                      </Text>
                    </View>
                    <Text style={[styles.dateText, { color: colors.textTertiary }]}>
                      {date.toLocaleDateString('vi-VN')} {date.toLocaleTimeString('vi-VN', { hour: '2-digit', minute: '2-digit' })}
                    </Text>
                  </View>
                  <View style={[styles.scoreBadge, { backgroundColor: levelColor + '15' }]}>
                    <Text style={[styles.scoreText, { color: levelColor }]}>{item.overall_score}</Text>
                  </View>
                </View>
              </View>
            );
          }}
          ListEmptyComponent={<EmptyState iconName="analytics-outline" title="Chưa có lịch sử" description="Bắt đầu luyện phát âm để theo dõi tiến trình" />}
        />
      )}
    </View>
  );
}

const styles = StyleSheet.create({
  screen: { flex: 1 },
  header: { paddingHorizontal: Spacing.xl, flexDirection: 'row', alignItems: 'center', gap: Spacing.md, marginBottom: Spacing.lg },
  backBtn: { width: 36, height: 36, borderRadius: 18, justifyContent: 'center', alignItems: 'center' },
  screenTitle: { flex: 1, fontSize: FontSize.xl, fontWeight: FontWeight.bold, textAlign: 'center' },
  center: { flex: 1, justifyContent: 'center', alignItems: 'center' },
  list: { paddingHorizontal: Spacing.xl, paddingBottom: Spacing['4xl'], gap: Spacing.md, maxWidth: 500, alignSelf: 'center', width: '100%' },
  card: { borderRadius: BorderRadius.xl, padding: Spacing.lg, ...Shadow.sm },
  cardRow: { flexDirection: 'row', alignItems: 'center', gap: Spacing.md },
  cardChinese: { fontSize: FontSize.lg, fontWeight: FontWeight.semibold, marginBottom: Spacing.xs },
  cardMeta: { flexDirection: 'row', alignItems: 'center', gap: Spacing.xs },
  metaText: { fontSize: FontSize.sm },
  metaDot: { fontSize: FontSize.sm },
  dateText: { fontSize: FontSize.xs, marginTop: Spacing.xs },
  scoreBadge: { width: 48, height: 48, borderRadius: 24, justifyContent: 'center', alignItems: 'center' },
  scoreText: { fontSize: FontSize.lg, fontWeight: FontWeight.bold },
});
