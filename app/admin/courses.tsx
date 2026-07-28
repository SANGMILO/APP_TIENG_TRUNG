import React, { useState } from 'react';
import { View, Text, StyleSheet, FlatList, TouchableOpacity, TextInput, ActivityIndicator } from 'react-native';
import { router } from 'expo-router';
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { useThemeStore } from '@/stores/theme-store';
import { fetchAdminList, publishContent } from '@/services/admin-service';
import { FontSize, Spacing, BorderRadius } from '@/constants/theme';

export default function AdminCoursesScreen() {
  const { colors } = useThemeStore();
  const queryClient = useQueryClient();
  const [statusFilter, setStatusFilter] = useState('');
  const [search, setSearch] = useState('');

  const { data, isLoading } = useQuery({
    queryKey: ['admin-courses', statusFilter, search],
    queryFn: () => fetchAdminList('courses', { status: statusFilter || undefined, search: search || undefined }),
  });

  const publishMutation = useMutation({
    mutationFn: (id: string) => publishContent('course', id, 'Published from admin'),
    onSuccess: () => queryClient.invalidateQueries({ queryKey: ['admin-courses'] }),
  });

  const statusColors: Record<string, string> = { draft: colors.textTertiary, review: colors.warning, published: colors.success, archived: colors.error };

  return (
    <View style={[styles.container, { backgroundColor: colors.background }]}>
      <View style={styles.header}>
        <TouchableOpacity onPress={() => router.back()}>
          <Text style={[styles.backBtn, { color: colors.primary }]}>← Dashboard</Text>
        </TouchableOpacity>
        <View style={styles.headerRow}>
          <Text style={[styles.title, { color: colors.text }]}>Courses</Text>
        </View>
      </View>

      {/* Filters */}
      <TextInput
        style={[styles.search, { backgroundColor: colors.surface, borderColor: colors.border, color: colors.text }]}
        placeholder="Tìm khóa học..."
        placeholderTextColor={colors.textTertiary}
        value={search}
        onChangeText={setSearch}
      />

      <View style={styles.filterRow}>
        {['', 'draft', 'review', 'published', 'archived'].map(s => (
          <TouchableOpacity key={s} style={[styles.filterChip, { backgroundColor: statusFilter === s ? colors.primary + '20' : colors.surface, borderColor: statusFilter === s ? colors.primary : colors.border }]} onPress={() => setStatusFilter(s)}>
            <Text style={[styles.filterLabel, { color: statusFilter === s ? colors.primary : colors.textSecondary }]}>{s || 'All'}</Text>
          </TouchableOpacity>
        ))}
      </View>

      {/* List */}
      {isLoading ? <ActivityIndicator color={colors.primary} /> : (
        <FlatList
          data={data?.data ?? []}
          keyExtractor={(item: any) => item.id}
          contentContainerStyle={styles.list}
          renderItem={({ item }: { item: any }) => (
            <View style={[styles.row, { borderBottomColor: colors.borderLight }]}>
              <View style={styles.rowInfo}>
                <Text style={[styles.rowTitle, { color: colors.text }]}>{item.title}</Text>
                <View style={styles.rowMeta}>
                  <Text style={[styles.statusBadge, { color: statusColors[item.status] || colors.text }]}>{item.status}</Text>
                  <Text style={[styles.rowLevel, { color: colors.textTertiary }]}>{item.level}</Text>
                </View>
              </View>
              <View style={styles.rowActions}>
                {item.status === 'draft' && (
                  <TouchableOpacity onPress={() => publishMutation.mutate(item.id)}>
                    <Text style={[styles.actionBtn, { color: colors.success }]}>Publish</Text>
                  </TouchableOpacity>
                )}
              </View>
            </View>
          )}
          ListFooterComponent={<Text style={[styles.countText, { color: colors.textTertiary }]}>{data?.total ?? 0} courses</Text>}
        />
      )}
    </View>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1 },
  header: { paddingHorizontal: Spacing.xl, paddingTop: Spacing['5xl'], gap: Spacing.md },
  backBtn: { fontSize: FontSize.base, fontWeight: '500' },
  headerRow: { flexDirection: 'row', justifyContent: 'space-between', alignItems: 'center' },
  title: { fontSize: FontSize['2xl'], fontWeight: 'bold' },
  search: { marginHorizontal: Spacing.xl, marginTop: Spacing.lg, borderWidth: 1, borderRadius: BorderRadius.lg, paddingHorizontal: Spacing.lg, paddingVertical: Spacing.sm, fontSize: FontSize.base },
  filterRow: { flexDirection: 'row', gap: Spacing.sm, paddingHorizontal: Spacing.xl, paddingTop: Spacing.md, flexWrap: 'wrap' },
  filterChip: { paddingHorizontal: Spacing.md, paddingVertical: Spacing.xs, borderRadius: BorderRadius.full, borderWidth: 1 },
  filterLabel: { fontSize: FontSize.sm, fontWeight: '500' },
  list: { paddingHorizontal: Spacing.xl, paddingTop: Spacing.md },
  row: { flexDirection: 'row', alignItems: 'center', paddingVertical: Spacing.lg, borderBottomWidth: 1 },
  rowInfo: { flex: 1, gap: 4 },
  rowTitle: { fontSize: FontSize.base, fontWeight: '500' },
  rowMeta: { flexDirection: 'row', gap: Spacing.md },
  statusBadge: { fontSize: FontSize.sm, fontWeight: '600' },
  rowLevel: { fontSize: FontSize.sm },
  rowActions: { flexDirection: 'row', gap: Spacing.md },
  actionBtn: { fontSize: FontSize.sm, fontWeight: '600' },
  countText: { textAlign: 'center', paddingVertical: Spacing.lg, fontSize: FontSize.sm },
});
