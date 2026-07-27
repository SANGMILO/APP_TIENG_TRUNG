import React, { useState } from 'react';
import { View, Text, StyleSheet, FlatList, TouchableOpacity, TextInput, ActivityIndicator } from 'react-native';
import { router } from 'expo-router';
import { useQuery } from '@tanstack/react-query';
import { useThemeStore } from '@/stores/theme-store';
import { fetchUsers } from '@/services/admin-service';
import { FontSize, Spacing, BorderRadius } from '@/constants/theme';

export default function AdminUsersScreen() {
  const { colors } = useThemeStore();
  const [search, setSearch] = useState('');
  const [page, setPage] = useState(0);

  const { data, isLoading } = useQuery({
    queryKey: ['admin-users', search, page],
    queryFn: () => fetchUsers(page, 20, search || undefined),
  });

  return (
    <View style={[styles.container, { backgroundColor: colors.background }]}>
      <View style={styles.header}>
        <TouchableOpacity onPress={() => router.back()}>
          <Text style={[styles.backBtn, { color: colors.primary }]}>← Dashboard</Text>
        </TouchableOpacity>
        <Text style={[styles.title, { color: colors.text }]}>Users</Text>
        <Text style={[styles.total, { color: colors.textTertiary }]}>{data?.total ?? 0} users</Text>
      </View>

      <TextInput
        style={[styles.search, { backgroundColor: colors.surface, borderColor: colors.border, color: colors.text }]}
        placeholder="Tìm user..."
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
              <View style={[styles.avatar, { backgroundColor: colors.surfaceElevated }]}>
                <Text style={styles.avatarText}>{(item.display_name || item.email || '?')[0].toUpperCase()}</Text>
              </View>
              <View style={styles.rowInfo}>
                <Text style={[styles.name, { color: colors.text }]}>{item.display_name || item.username || 'No name'}</Text>
                <Text style={[styles.email, { color: colors.textSecondary }]}>{item.email}</Text>
              </View>
              <View style={styles.rowRight}>
                <Text style={[styles.roleBadge, { color: item.role === 'admin' || item.role === 'super_admin' ? colors.error : colors.textTertiary }]}>{item.role}</Text>
                <Text style={[styles.levelText, { color: colors.xp }]}>Lv.{item.current_level}</Text>
              </View>
            </View>
          )}
        />
      )}
    </View>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1 },
  header: { paddingHorizontal: Spacing.xl, paddingTop: Spacing['5xl'], gap: Spacing.xs },
  backBtn: { fontSize: FontSize.base, fontWeight: '500', marginBottom: Spacing.sm },
  title: { fontSize: FontSize['2xl'], fontWeight: 'bold' },
  total: { fontSize: FontSize.sm },
  search: { marginHorizontal: Spacing.xl, marginTop: Spacing.lg, borderWidth: 1, borderRadius: BorderRadius.lg, paddingHorizontal: Spacing.lg, paddingVertical: Spacing.sm, fontSize: FontSize.base },
  list: { paddingHorizontal: Spacing.xl, paddingTop: Spacing.md },
  row: { flexDirection: 'row', alignItems: 'center', paddingVertical: Spacing.md, borderBottomWidth: 1, gap: Spacing.md },
  avatar: { width: 36, height: 36, borderRadius: 18, justifyContent: 'center', alignItems: 'center' },
  avatarText: { fontSize: FontSize.md, fontWeight: '600' },
  rowInfo: { flex: 1, gap: 2 },
  name: { fontSize: FontSize.base, fontWeight: '500' },
  email: { fontSize: FontSize.sm },
  rowRight: { alignItems: 'flex-end', gap: 2 },
  roleBadge: { fontSize: FontSize.xs, fontWeight: '600' },
  levelText: { fontSize: FontSize.xs, fontWeight: '500' },
});
