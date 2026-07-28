import React, { useState } from 'react';
import {
  ActivityIndicator,
  ScrollView,
  StyleSheet,
  Switch,
  Text,
  TouchableOpacity,
  View,
} from 'react-native';
import { router } from 'expo-router';
import { useQuery, useQueryClient } from '@tanstack/react-query';
import { useAuthStore } from '@/stores/auth-store';
import { useThemeStore } from '@/stores/theme-store';
import { supabase } from '@/lib/supabase';
import { EmptyState } from '@/components/ui';
import { BorderRadius, FontSize, Spacing } from '@/constants/theme';

interface NotificationPreferences {
  study_reminder: boolean;
  streak_warning: boolean;
  review_reminder: boolean;
  league_results: boolean;
  achievements: boolean;
}

const DEFAULT_PREFERENCES: NotificationPreferences = {
  study_reminder: true,
  streak_warning: true,
  review_reminder: true,
  league_results: true,
  achievements: true,
};

const OPTIONS: Array<{
  key: keyof NotificationPreferences;
  title: string;
  description: string;
}> = [
  {
    key: 'study_reminder',
    title: 'Nhắc lịch học',
    description: 'Nhắc bạn duy trì mục tiêu học hằng ngày.',
  },
  {
    key: 'review_reminder',
    title: 'Nhắc ôn tập',
    description: 'Thông báo khi có từ vựng đến hạn.',
  },
  {
    key: 'streak_warning',
    title: 'Cảnh báo chuỗi ngày',
    description: 'Nhắc trước khi chuỗi học liên tục bị gián đoạn.',
  },
  {
    key: 'achievements',
    title: 'Thành tích',
    description: 'Thông báo khi một thành tích được mở khóa.',
  },
  {
    key: 'league_results',
    title: 'Kết quả bảng xếp hạng',
    description: 'Nhận cập nhật kết quả thi đua theo tuần.',
  },
];

export default function NotificationSettingsScreen() {
  const { colors } = useThemeStore();
  const { profile } = useAuthStore();
  const queryClient = useQueryClient();
  const [savingKey, setSavingKey] = useState<keyof NotificationPreferences | null>(null);
  const [saveError, setSaveError] = useState('');
  const queryKey = ['notification-preferences', profile?.id];

  const { data, isLoading, isError, refetch } = useQuery({
    queryKey,
    enabled: Boolean(profile),
    queryFn: async (): Promise<NotificationPreferences> => {
      const { data: preferences, error } = await supabase
        .from('notification_preferences')
        .select('study_reminder, streak_warning, review_reminder, league_results, achievements')
        .eq('user_id', profile!.id)
        .maybeSingle();
      if (error) throw error;
      return preferences ?? DEFAULT_PREFERENCES;
    },
  });

  const updatePreference = async (
    key: keyof NotificationPreferences,
    value: boolean,
  ) => {
    if (!profile || savingKey) return;
    const previous = data ?? DEFAULT_PREFERENCES;
    const next = { ...previous, [key]: value };

    setSavingKey(key);
    setSaveError('');
    queryClient.setQueryData(queryKey, next);
    try {
      const { error } = await supabase
        .from('notification_preferences')
        .upsert(
          { user_id: profile.id, ...next, updated_at: new Date().toISOString() },
          { onConflict: 'user_id' },
        );
      if (error) throw error;
    } catch (reason: unknown) {
      queryClient.setQueryData(queryKey, previous);
      setSaveError(getErrorMessage(
        reason,
        'Không thể lưu tùy chọn thông báo. Vui lòng thử lại.',
      ));
    } finally {
      setSavingKey(null);
    }
  };

  return (
    <ScrollView
      style={[styles.screen, { backgroundColor: colors.background }]}
      contentContainerStyle={styles.content}
    >
      <TouchableOpacity onPress={() => router.back()}>
        <Text style={[styles.backButton, { color: colors.primary }]}>← Quay lại</Text>
      </TouchableOpacity>
      <Text style={[styles.title, { color: colors.text }]}>Thông báo</Text>
      <Text style={[styles.subtitle, { color: colors.textSecondary }]}>
        Chọn những cập nhật bạn muốn nhận.
      </Text>

      {isLoading ? (
        <ActivityIndicator size="large" color={colors.primary} />
      ) : isError ? (
        <EmptyState
          iconName="cloud-offline-outline"
          title="Không thể tải tùy chọn"
          description="Kiểm tra kết nối rồi thử lại."
          actionLabel="Thử lại"
          onAction={() => { void refetch(); }}
        />
      ) : (
        <View style={[styles.card, { backgroundColor: colors.card, borderColor: colors.border }]}>
          {OPTIONS.map((option, index) => (
            <View key={option.key}>
              <View style={styles.row}>
                <View style={styles.rowText}>
                  <Text style={[styles.rowTitle, { color: colors.text }]}>
                    {option.title}
                  </Text>
                  <Text style={[styles.rowDescription, { color: colors.textSecondary }]}>
                    {option.description}
                  </Text>
                </View>
                <Switch
                  value={(data ?? DEFAULT_PREFERENCES)[option.key]}
                  onValueChange={(value) => {
                    void updatePreference(option.key, value);
                  }}
                  disabled={savingKey !== null}
                  trackColor={{
                    false: colors.border,
                    true: `${colors.primary}80`,
                  }}
                  thumbColor={
                    (data ?? DEFAULT_PREFERENCES)[option.key]
                      ? colors.primary
                      : colors.surface
                  }
                />
              </View>
              {index < OPTIONS.length - 1 ? (
                <View style={[styles.divider, { backgroundColor: colors.borderLight }]} />
              ) : null}
            </View>
          ))}
        </View>
      )}

      {saveError ? (
        <Text style={[styles.error, { color: colors.error }]}>{saveError}</Text>
      ) : null}
    </ScrollView>
  );
}

function getErrorMessage(reason: unknown, fallback: string) {
  if (
    typeof reason === 'object'
    && reason !== null
    && 'message' in reason
    && typeof reason.message === 'string'
    && reason.message.trim()
  ) {
    return reason.message;
  }
  return fallback;
}

const styles = StyleSheet.create({
  screen: { flex: 1 },
  content: {
    width: '100%',
    maxWidth: 560,
    alignSelf: 'center',
    paddingHorizontal: Spacing.xl,
    paddingTop: Spacing['5xl'],
    paddingBottom: Spacing['4xl'],
  },
  backButton: {
    fontSize: FontSize.base,
    fontWeight: '500',
    marginBottom: Spacing.lg,
  },
  title: {
    fontSize: FontSize['2xl'],
    fontWeight: 'bold',
    marginBottom: Spacing.xs,
  },
  subtitle: {
    fontSize: FontSize.md,
    marginBottom: Spacing.xl,
  },
  card: {
    borderWidth: 1,
    borderRadius: BorderRadius.xl,
    overflow: 'hidden',
  },
  row: {
    minHeight: 76,
    flexDirection: 'row',
    alignItems: 'center',
    paddingHorizontal: Spacing.lg,
    paddingVertical: Spacing.md,
    gap: Spacing.lg,
  },
  rowText: { flex: 1, gap: 2 },
  rowTitle: { fontSize: FontSize.base, fontWeight: '600' },
  rowDescription: { fontSize: FontSize.sm, lineHeight: 19 },
  divider: { height: 1, marginHorizontal: Spacing.lg },
  error: { fontSize: FontSize.sm, textAlign: 'center', marginTop: Spacing.lg },
});
