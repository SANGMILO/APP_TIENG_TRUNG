import React from 'react';
import { View, Text, StyleSheet, ScrollView, TouchableOpacity, ActivityIndicator } from 'react-native';
import { router } from 'expo-router';
import { useQuery } from '@tanstack/react-query';
import { useThemeStore } from '@/stores/theme-store';
import { fetchAdminDashboard } from '@/services/admin-service';
import { EmptyState } from '@/components/ui';
import { FontSize, Spacing, BorderRadius } from '@/constants/theme';

export default function AdminAnalyticsScreen() {
  const { colors } = useThemeStore();

  const { data: stats, isLoading, isError, refetch } = useQuery({
    queryKey: ['admin-analytics'],
    queryFn: fetchAdminDashboard,
  });

  return (
    <ScrollView style={[styles.container, { backgroundColor: colors.background }]} contentContainerStyle={styles.content}>
      <TouchableOpacity onPress={() => router.back()}>
        <Text style={[styles.backBtn, { color: colors.primary }]}>← Dashboard</Text>
      </TouchableOpacity>
      <Text style={[styles.title, { color: colors.text }]}>Analytics</Text>

      {isLoading ? <ActivityIndicator color={colors.primary} /> : isError ? (
        <EmptyState
          iconName="cloud-offline-outline"
          title="Không thể tải analytics"
          description="Kiểm tra quyền truy cập hoặc kết nối rồi thử lại."
          actionLabel="Thử lại"
          onAction={() => { void refetch(); }}
        />
      ) : stats ? (
        <View style={styles.metricsGrid}>
          <MetricCard label="Total Users" value={stats.totalUsers} colors={colors} />
          <MetricCard label="Active Today" value={stats.activeToday} colors={colors} />
          <MetricCard label="XP Today" value={stats.todayXpTotal} colors={colors} />
          <MetricCard label="Lessons Today" value={stats.todayLessonsCompleted} colors={colors} />
          <MetricCard label="AI Sessions Today" value={stats.todayAiSessions} colors={colors} />
          <MetricCard label="Content In Review" value={stats.contentInReview} colors={colors} />
        </View>
      ) : null}

      <Text style={[styles.note, { color: colors.textTertiary }]}>
        Các chỉ số trên được tổng hợp trực tiếp từ dữ liệu hệ thống hiện tại.
      </Text>
    </ScrollView>
  );
}

function MetricCard({ label, value, colors }: { label: string; value: number; colors: any }) {
  return (
    <View style={[styles.metricCard, { backgroundColor: colors.surface, borderColor: colors.border }]}>
      <Text style={[styles.metricValue, { color: colors.primary }]}>{value.toLocaleString()}</Text>
      <Text style={[styles.metricLabel, { color: colors.textSecondary }]}>{label}</Text>
    </View>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1 },
  content: { paddingHorizontal: Spacing.xl, paddingTop: Spacing['5xl'], paddingBottom: Spacing['4xl'] },
  backBtn: { fontSize: FontSize.base, fontWeight: '500', marginBottom: Spacing.lg },
  title: { fontSize: FontSize['2xl'], fontWeight: 'bold', marginBottom: Spacing.xl },
  metricsGrid: { flexDirection: 'row', flexWrap: 'wrap', gap: Spacing.md },
  metricCard: { width: '47%', padding: Spacing.lg, borderRadius: BorderRadius.xl, borderWidth: 1, alignItems: 'center', gap: Spacing.xs },
  metricValue: { fontSize: FontSize['2xl'], fontWeight: 'bold' },
  metricLabel: { fontSize: FontSize.sm, textAlign: 'center' },
  note: { marginTop: Spacing['2xl'], fontSize: FontSize.sm, textAlign: 'center' },
});
