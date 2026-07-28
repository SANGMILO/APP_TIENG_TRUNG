import React, { useState } from 'react';
import { View, Text, StyleSheet, FlatList, TouchableOpacity, TextInput, ActivityIndicator } from 'react-native';
import { router } from 'expo-router';
import { useQuery } from '@tanstack/react-query';
import { useThemeStore } from '@/stores/theme-store';
import { fetchAdminList } from '@/services/admin-service';
import { Button } from '@/components/ui';
import { FontSize, Spacing, BorderRadius } from '@/constants/theme';

export default function AdminVocabularyScreen() {
  const { colors } = useThemeStore();
  const [search, setSearch] = useState('');
  const [page, setPage] = useState(0);

  const { data, isLoading } = useQuery({
    queryKey: ['admin-vocabulary', search, page],
    queryFn: () => fetchAdminList('vocabulary', { search: search || undefined }, page, 30),
  });

  return (
    <View style={[styles.container, { backgroundColor: colors.background }]}>
      <View style={styles.header}>
        <TouchableOpacity onPress={() => router.back()}>
          <Text style={[styles.backBtn, { color: colors.primary }]}>← Dashboard</Text>
        </TouchableOpacity>
        <View style={styles.headerRow}>
          <Text style={[styles.title, { color: colors.text }]}>Vocabulary</Text>
        </View>
        <Text style={[styles.total, { color: colors.textTertiary }]}>{data?.total ?? 0} từ vựng</Text>
      </View>

      <TextInput
        style={[styles.search, { backgroundColor: colors.surface, borderColor: colors.border, color: colors.text }]}
        placeholder="Tìm: 中文, pinyin, nghĩa..."
        placeholderTextColor={colors.textTertiary}
        value={search}
        onChangeText={setSearch}
      />

      {isLoading ? <ActivityIndicator color={colors.primary} style={{ marginTop: Spacing.xl }} /> : (
        <FlatList
          data={data?.data ?? []}
          keyExtractor={(item: any) => item.id}
          contentContainerStyle={styles.list}
          renderItem={({ item }: { item: any }) => (
            <View style={[styles.row, { borderBottomColor: colors.borderLight }]}>
              <View style={styles.rowInfo}>
                <Text style={[styles.chinese, { color: colors.text }]}>{item.chinese}</Text>
                <Text style={[styles.pinyin, { color: colors.primary }]}>{item.pinyin}</Text>
                <Text style={[styles.meaning, { color: colors.textSecondary }]}>{item.meaning_vi}</Text>
              </View>
              <View style={styles.rowRight}>
                <Text style={[styles.statusText, { color: item.status === 'published' ? colors.success : colors.textTertiary }]}>{item.status}</Text>
                {item.hsk_level && <Text style={[styles.hskBadge, { color: colors.info }]}>HSK{item.hsk_level}</Text>}
              </View>
            </View>
          )}
        />
      )}

      {/* Pagination */}
      {(data?.total ?? 0) > 30 && (
        <View style={styles.pagination}>
          <Button title="← Trước" variant="ghost" size="sm" disabled={page === 0} onPress={() => setPage(p => p - 1)} />
          <Text style={[styles.pageText, { color: colors.textSecondary }]}>Trang {page + 1}</Text>
          <Button title="Sau →" variant="ghost" size="sm" disabled={(page + 1) * 30 >= (data?.total ?? 0)} onPress={() => setPage(p => p + 1)} />
        </View>
      )}
    </View>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1 },
  header: { paddingHorizontal: Spacing.xl, paddingTop: Spacing['5xl'], gap: Spacing.xs },
  backBtn: { fontSize: FontSize.base, fontWeight: '500', marginBottom: Spacing.sm },
  headerRow: { flexDirection: 'row', justifyContent: 'space-between', alignItems: 'center' },
  title: { fontSize: FontSize['2xl'], fontWeight: 'bold' },
  total: { fontSize: FontSize.sm },
  search: { marginHorizontal: Spacing.xl, marginTop: Spacing.lg, borderWidth: 1, borderRadius: BorderRadius.lg, paddingHorizontal: Spacing.lg, paddingVertical: Spacing.sm, fontSize: FontSize.base },
  list: { paddingHorizontal: Spacing.xl, paddingTop: Spacing.md },
  row: { flexDirection: 'row', alignItems: 'center', paddingVertical: Spacing.md, borderBottomWidth: 1 },
  rowInfo: { flex: 1, gap: 2 },
  chinese: { fontSize: FontSize.lg, fontWeight: '600' },
  pinyin: { fontSize: FontSize.sm },
  meaning: { fontSize: FontSize.sm },
  rowRight: { alignItems: 'flex-end', gap: 2 },
  statusText: { fontSize: FontSize.xs, fontWeight: '500' },
  hskBadge: { fontSize: FontSize.xs, fontWeight: '600' },
  pagination: { flexDirection: 'row', justifyContent: 'center', alignItems: 'center', paddingVertical: Spacing.lg, gap: Spacing.lg },
  pageText: { fontSize: FontSize.sm },
});
