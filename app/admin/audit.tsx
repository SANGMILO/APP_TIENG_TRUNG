import React from 'react';
import { View, Text, StyleSheet, FlatList, TouchableOpacity, ActivityIndicator } from 'react-native';
import { router } from 'expo-router';
import { useQuery } from '@tanstack/react-query';
import { useThemeStore } from '@/stores/theme-store';
import { fetchAuditLogs } from '@/services/admin-service';
import { FontSize, Spacing, BorderRadius } from '@/constants/theme';

export default function AdminAuditScreen() {
  const { colors } = useThemeStore();

  const { data: logs, isLoading } = useQuery({
    queryKey: ['admin-audit'],
    queryFn: () => fetchAuditLogs(0, 50),
  });

  return (
    <View style={[styles.container, { backgroundColor: colors.background }]}>
      <View style={styles.header}>
        <TouchableOpacity onPress={() => router.back()}>
          <Text style={[styles.backBtn, { color: colors.primary }]}>← Dashboard</Text>
        </TouchableOpacity>
        <Text style={[styles.title, { color: colors.text }]}>Audit Log</Text>
      </View>

      {isLoading ? <ActivityIndicator color={colors.primary} style={{ marginTop: Spacing.xl }} /> : (
        <FlatList
          data={logs}
          keyExtractor={(item: any) => item.id}
          contentContainerStyle={styles.list}
          renderItem={({ item }: { item: any }) => {
            const date = new Date(item.created_at);
            return (
              <View style={[styles.logRow, { borderBottomColor: colors.borderLight }]}>
                <View style={styles.logInfo}>
                  <Text style={[styles.logAction, { color: colors.text }]}>{item.action}</Text>
                  <Text style={[styles.logResource, { color: colors.textSecondary }]}>{item.resource_type} • {item.resource_id?.slice(0, 8)}</Text>
                  <Text style={[styles.logActor, { color: colors.textTertiary }]}>
                    {item.profiles?.display_name || item.profiles?.email || 'System'}
                  </Text>
                </View>
                <Text style={[styles.logDate, { color: colors.textTertiary }]}>
                  {date.toLocaleDateString('vi-VN')}{'\n'}{date.toLocaleTimeString('vi-VN', { hour: '2-digit', minute: '2-digit' })}
                </Text>
              </View>
            );
          }}
          ListEmptyComponent={
            <Text style={[styles.emptyText, { color: colors.textSecondary }]}>Chưa có hoạt động admin nào</Text>
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
  list: { paddingHorizontal: Spacing.xl, paddingTop: Spacing.md },
  logRow: { flexDirection: 'row', alignItems: 'center', paddingVertical: Spacing.md, borderBottomWidth: 1 },
  logInfo: { flex: 1, gap: 2 },
  logAction: { fontSize: FontSize.base, fontWeight: '600' },
  logResource: { fontSize: FontSize.sm },
  logActor: { fontSize: FontSize.xs },
  logDate: { fontSize: FontSize.xs, textAlign: 'right' },
  emptyText: { textAlign: 'center', paddingTop: Spacing['3xl'], fontSize: FontSize.md },
});
