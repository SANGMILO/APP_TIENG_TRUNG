import React, { useState } from 'react';
import { View, Text, StyleSheet, FlatList, TouchableOpacity, TextInput, ActivityIndicator } from 'react-native';
import { router } from 'expo-router';
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { useThemeStore } from '@/stores/theme-store';
import { useAuthStore } from '@/stores/auth-store';
import { supabase } from '@/lib/supabase';
import { Card } from '@/components/ui';
import { FontSize, Spacing, BorderRadius } from '@/constants/theme';

type Filter = 'all' | 'new' | 'learning' | 'review' | 'mastered';

export default function MyWordsScreen() {
  const { colors } = useThemeStore();
  const { profile } = useAuthStore();
  const [filter, setFilter] = useState<Filter>('all');
  const [search, setSearch] = useState('');
  const queryClient = useQueryClient();

  const { data: words, isLoading } = useQuery({
    queryKey: ['my-words', filter, search],
    queryFn: async () => {
      if (!profile) return [];

      let query = supabase
        .from('saved_words')
        .select(`
          id, created_at,
          vocabulary:vocabulary_id (id, chinese, pinyin, meaning_vi, audio_url)
        `)
        .eq('user_id', profile.id)
        .order('created_at', { ascending: false });

      const { data, error } = await query;
      if (error) throw error;

      let results = (data ?? []).map((item: any) => ({
        saved_id: item.id,
        ...item.vocabulary,
        created_at: item.created_at,
      }));

      // Client-side search filter
      if (search.trim()) {
        const s = search.toLowerCase();
        results = results.filter((w: any) =>
          w.chinese?.includes(s) || w.pinyin?.toLowerCase().includes(s) || w.meaning_vi?.toLowerCase().includes(s)
        );
      }

      return results;
    },
    enabled: !!profile,
  });

  const removeMutation = useMutation({
    mutationFn: async (savedId: string) => {
      const { error } = await supabase.from('saved_words').delete().eq('id', savedId);
      if (error) throw error;
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['my-words'] });
    },
  });

  return (
    <View style={[styles.container, { backgroundColor: colors.background }]}>
      {/* Header */}
      <View style={styles.header}>
        <TouchableOpacity onPress={() => router.back()}>
          <Text style={[styles.backBtn, { color: colors.primary }]}>← Quay lại</Text>
        </TouchableOpacity>
        <Text style={[styles.title, { color: colors.text }]}>Từ của tôi</Text>
      </View>

      {/* Search */}
      <View style={styles.searchContainer}>
        <TextInput
          style={[styles.searchInput, { backgroundColor: colors.surface, borderColor: colors.border, color: colors.text }]}
          placeholder="Tìm từ..."
          placeholderTextColor={colors.textTertiary}
          value={search}
          onChangeText={setSearch}
        />
      </View>

      {/* Word count */}
      <Text style={[styles.count, { color: colors.textSecondary }]}>
        {words?.length ?? 0} từ đã lưu
      </Text>

      {/* List */}
      {isLoading ? (
        <ActivityIndicator size="small" color={colors.primary} style={{ marginTop: Spacing['2xl'] }} />
      ) : (
        <FlatList
          data={words}
          keyExtractor={(item: any) => item.saved_id}
          contentContainerStyle={styles.list}
          renderItem={({ item }: { item: any }) => (
            <View style={[styles.wordRow, { borderBottomColor: colors.borderLight }]}>
              <View style={styles.wordInfo}>
                <Text style={[styles.wordChinese, { color: colors.text }]}>{item.chinese}</Text>
                <Text style={[styles.wordPinyin, { color: colors.primary }]}>{item.pinyin}</Text>
                <Text style={[styles.wordMeaning, { color: colors.textSecondary }]}>{item.meaning_vi}</Text>
              </View>
              <TouchableOpacity onPress={() => removeMutation.mutate(item.saved_id)} style={styles.removeBtn}>
                <Text style={{ color: colors.error, fontSize: 16 }}>✕</Text>
              </TouchableOpacity>
            </View>
          )}
          ListEmptyComponent={
            <View style={styles.empty}>
              <Text style={[styles.emptyText, { color: colors.textSecondary }]}>
                {search ? 'Không tìm thấy từ nào' : 'Chưa lưu từ nào. Bấm ⭐ khi học để lưu từ.'}
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
  searchContainer: { paddingHorizontal: Spacing.xl, paddingTop: Spacing.lg },
  searchInput: { borderWidth: 1, borderRadius: BorderRadius.lg, paddingHorizontal: Spacing.lg, paddingVertical: Spacing.md, fontSize: FontSize.base },
  count: { paddingHorizontal: Spacing.xl, paddingTop: Spacing.md, fontSize: FontSize.sm },
  list: { paddingHorizontal: Spacing.xl, paddingTop: Spacing.md },
  wordRow: { flexDirection: 'row', alignItems: 'center', paddingVertical: Spacing.lg, borderBottomWidth: 1 },
  wordInfo: { flex: 1, gap: 2 },
  wordChinese: { fontSize: FontSize.xl, fontWeight: '600' },
  wordPinyin: { fontSize: FontSize.sm },
  wordMeaning: { fontSize: FontSize.md },
  removeBtn: { padding: Spacing.sm },
  empty: { alignItems: 'center', paddingTop: Spacing['3xl'] },
  emptyText: { fontSize: FontSize.md, textAlign: 'center' },
});
