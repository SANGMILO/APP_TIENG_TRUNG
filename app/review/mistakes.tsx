import React, { useState } from 'react';
import { View, Text, StyleSheet, FlatList, TouchableOpacity, ActivityIndicator } from 'react-native';
import { router } from 'expo-router';
import { useQuery } from '@tanstack/react-query';
import { useThemeStore } from '@/stores/theme-store';
import { useAuthStore } from '@/stores/auth-store';
import { supabase } from '@/lib/supabase';
import { FontSize, Spacing, BorderRadius } from '@/constants/theme';

type CategoryFilter = 'all' | 'vocabulary' | 'grammar' | 'listening' | 'writing';

export default function MistakesScreen() {
  const { colors } = useThemeStore();
  const { profile } = useAuthStore();
  const [category, setCategory] = useState<CategoryFilter>('all');

  const { data: mistakes, isLoading } = useQuery({
    queryKey: ['mistakes', category],
    queryFn: async () => {
      if (!profile) return [];

      let query = supabase
        .from('mistakes')
        .select('*')
        .eq('user_id', profile.id)
        .eq('reviewed', false)
        .order('created_at', { ascending: false })
        .limit(50);

      if (category !== 'all') {
        query = query.eq('category', category);
      }

      const { data, error } = await query;
      if (error) throw error;
      return data ?? [];
    },
    enabled: !!profile,
  });

  const categories: { key: CategoryFilter; label: string }[] = [
    { key: 'all', label: 'Tất cả' },
    { key: 'vocabulary', label: 'Từ vựng' },
    { key: 'grammar', label: 'Ngữ pháp' },
    { key: 'listening', label: 'Nghe' },
    { key: 'writing', label: 'Viết' },
  ];

  return (
    <View style={[styles.container, { backgroundColor: colors.background }]}>
      <View style={styles.header}>
        <TouchableOpacity onPress={() => router.back()}>
          <Text style={[styles.backBtn, { color: colors.primary }]}>← Quay lại</Text>
        </TouchableOpacity>
        <Text style={[styles.title, { color: colors.text }]}>Sổ lỗi sai</Text>
      </View>

      {/* Category filters */}
      <View style={styles.filterRow}>
        {categories.map(cat => (
          <TouchableOpacity
            key={cat.key}
            style={[styles.filterChip, { backgroundColor: category === cat.key ? colors.primary + '20' : colors.surface, borderColor: category === cat.key ? colors.primary : colors.border }]}
            onPress={() => setCategory(cat.key)}
          >
            <Text style={[styles.filterLabel, { color: category === cat.key ? colors.primary : colors.textSecondary }]}>
              {cat.label}
            </Text>
          </TouchableOpacity>
        ))}
      </View>

      {isLoading ? (
        <ActivityIndicator size="small" color={colors.primary} style={{ marginTop: Spacing['2xl'] }} />
      ) : (
        <FlatList
          data={mistakes}
          keyExtractor={(item: any) => item.id}
          contentContainerStyle={styles.list}
          renderItem={({ item }: { item: any }) => (
            <View style={[styles.mistakeCard, { backgroundColor: colors.surface, borderColor: colors.border }]}>
              <Text style={[styles.mistakeQuestion, { color: colors.text }]}>{item.question}</Text>
              <View style={styles.answersRow}>
                <View style={styles.answerCol}>
                  <Text style={[styles.answerLabel, { color: colors.error }]}>Bạn trả lời:</Text>
                  <Text style={[styles.answerText, { color: colors.error }]}>{item.user_answer}</Text>
                </View>
                <View style={styles.answerCol}>
                  <Text style={[styles.answerLabel, { color: colors.success }]}>Đáp án:</Text>
                  <Text style={[styles.answerText, { color: colors.success }]}>{item.correct_answer}</Text>
                </View>
              </View>
              <Text style={[styles.mistakeCategory, { color: colors.textTertiary }]}>
                {item.category} • {item.times_wrong}x sai
              </Text>
            </View>
          )}
          ListEmptyComponent={
            <View style={styles.empty}>
              <Text style={styles.emptyEmoji}>🎉</Text>
              <Text style={[styles.emptyText, { color: colors.textSecondary }]}>
                Không có lỗi sai nào!
              </Text>
            </View>
          }
        />
      )}
    </View>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1 },
  header: { paddingHorizontal: Spacing.xl, paddingTop: Spacing['5xl'], gap: Spacing.sm },
  backBtn: { fontSize: FontSize.base, fontWeight: '500' },
  title: { fontSize: FontSize['2xl'], fontWeight: 'bold' },
  filterRow: { flexDirection: 'row', gap: Spacing.sm, paddingHorizontal: Spacing.xl, paddingTop: Spacing.lg, flexWrap: 'wrap' },
  filterChip: { paddingHorizontal: Spacing.md, paddingVertical: Spacing.sm, borderRadius: BorderRadius.full, borderWidth: 1 },
  filterLabel: { fontSize: FontSize.sm, fontWeight: '500' },
  list: { paddingHorizontal: Spacing.xl, paddingTop: Spacing.lg, gap: Spacing.md },
  mistakeCard: { borderRadius: BorderRadius.xl, borderWidth: 1, padding: Spacing.lg, gap: Spacing.md },
  mistakeQuestion: { fontSize: FontSize.base, fontWeight: '500' },
  answersRow: { flexDirection: 'row', gap: Spacing.xl },
  answerCol: { flex: 1, gap: 2 },
  answerLabel: { fontSize: FontSize.xs, fontWeight: '500' },
  answerText: { fontSize: FontSize.md, fontWeight: '600' },
  mistakeCategory: { fontSize: FontSize.xs },
  empty: { alignItems: 'center', paddingTop: Spacing['3xl'] },
  emptyEmoji: { fontSize: 40, marginBottom: Spacing.md },
  emptyText: { fontSize: FontSize.md },
});
