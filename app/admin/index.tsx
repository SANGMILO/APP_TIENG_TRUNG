import React from 'react';
import { View, Text, StyleSheet, ScrollView, TouchableOpacity, ActivityIndicator } from 'react-native';
import { router } from 'expo-router';
import { useQuery } from '@tanstack/react-query';
import { useThemeStore } from '@/stores/theme-store';
import { useAuthStore } from '@/stores/auth-store';
import { fetchAdminDashboard, hasPermission } from '@/services/admin-service';
import { Card } from '@/components/ui';
import { FontSize, Spacing, BorderRadius } from '@/constants/theme';

export default function AdminDashboard() {
  const { colors } = useThemeStore();
  const { profile } = useAuthStore();
  const role = profile?.role ?? 'student';

  const { data: stats, isLoading } = useQuery({
    queryKey: ['admin-dashboard'],
    queryFn: fetchAdminDashboard,
    enabled: hasPermission(role, 'view_analytics'),
  });

  const menuItems = [
    { icon: '📚', label: 'Courses', route: '/admin/courses', perm: 'edit_content' as const },
    { icon: '📝', label: 'Vocabulary', route: '/admin/vocabulary', perm: 'edit_content' as const },
    { icon: '👥', label: 'Users', route: '/admin/users', perm: 'manage_users' as const },
    { icon: '📊', label: 'Analytics', route: '/admin/analytics', perm: 'view_analytics' as const },
    { icon: '📋', label: 'Audit Log', route: '/admin/audit', perm: 'view_analytics' as const },
  ];

  return (
    <ScrollView style={[styles.container, { backgroundColor: colors.background }]} contentContainerStyle={styles.content}>
      <View style={styles.header}>
        <TouchableOpacity onPress={() => router.back()}>
          <Text style={[styles.backBtn, { color: colors.primary }]}>← App</Text>
        </TouchableOpacity>
        <Text style={[styles.title, { color: colors.text }]}>Admin Dashboard</Text>
        <Text style={[styles.role, { color: colors.textTertiary }]}>{profile?.role}</Text>
      </View>

      {/* Stats Grid */}
      {isLoading ? (
        <ActivityIndicator color={colors.primary} />
      ) : stats ? (
        <View style={styles.statsGrid}>
          <StatCard label="Users" value={stats.totalUsers} icon="👥" colors={colors} />
          <StatCard label="Active Today" value={stats.activeToday} icon="📈" colors={colors} />
          <StatCard label="Courses" value={stats.publishedCourses} icon="📚" colors={colors} />
          <StatCard label="Lessons" value={stats.publishedLessons} icon="📖" colors={colors} />
          <StatCard label="Vocabulary" value={stats.publishedVocabulary} icon="🔤" colors={colors} />
          <StatCard label="Videos" value={stats.publishedVideos} icon="🎬" colors={colors} />
          <StatCard label="In Review" value={stats.contentInReview} icon="⏳" colors={colors} />
          <StatCard label="XP Today" value={stats.todayXpTotal} icon="⚡" colors={colors} />
        </View>
      ) : null}

      {/* Menu */}
      <View style={styles.menu}>
        {menuItems.filter(item => hasPermission(role, item.perm)).map(item => (
          <TouchableOpacity
            key={item.route}
            style={[styles.menuItem, { backgroundColor: colors.surface, borderColor: colors.border }]}
            onPress={() => router.push(item.route as any)}
          >
            <Text style={styles.menuIcon}>{item.icon}</Text>
            <Text style={[styles.menuLabel, { color: colors.text }]}>{item.label}</Text>
            <Text style={[styles.chevron, { color: colors.textTertiary }]}>›</Text>
          </TouchableOpacity>
        ))}
      </View>
    </ScrollView>
  );
}

function StatCard({ label, value, icon, colors }: { label: string; value: number; icon: string; colors: any }) {
  return (
    <View style={[styles.statCard, { backgroundColor: colors.surface, borderColor: colors.border }]}>
      <Text style={styles.statIcon}>{icon}</Text>
      <Text style={[styles.statValue, { color: colors.text }]}>{value}</Text>
      <Text style={[styles.statLabel, { color: colors.textSecondary }]}>{label}</Text>
    </View>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1 },
  content: { paddingHorizontal: Spacing.xl, paddingTop: Spacing['5xl'], paddingBottom: Spacing['4xl'] },
  header: { marginBottom: Spacing['2xl'] },
  backBtn: { fontSize: FontSize.base, fontWeight: '500', marginBottom: Spacing.md },
  title: { fontSize: FontSize['2xl'], fontWeight: 'bold' },
  role: { fontSize: FontSize.sm, marginTop: 2 },
  statsGrid: { flexDirection: 'row', flexWrap: 'wrap', gap: Spacing.md, marginBottom: Spacing['2xl'] },
  statCard: { width: '47%', alignItems: 'center', paddingVertical: Spacing.lg, borderRadius: BorderRadius.xl, borderWidth: 1, gap: 2 },
  statIcon: { fontSize: 20 },
  statValue: { fontSize: FontSize.xl, fontWeight: 'bold' },
  statLabel: { fontSize: FontSize.xs },
  menu: { gap: Spacing.sm },
  menuItem: { flexDirection: 'row', alignItems: 'center', padding: Spacing.lg, borderRadius: BorderRadius.xl, borderWidth: 1, gap: Spacing.md },
  menuIcon: { fontSize: 22 },
  menuLabel: { flex: 1, fontSize: FontSize.base, fontWeight: '500' },
  chevron: { fontSize: 22 },
});
