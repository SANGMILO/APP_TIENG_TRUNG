import React, { useState } from 'react';
import { ActivityIndicator, StyleSheet, Text, TouchableOpacity, View } from 'react-native';
import { router } from 'expo-router';
import { useQuery, useQueryClient } from '@tanstack/react-query';
import { useThemeStore } from '@/stores/theme-store';
import { useAuthStore } from '@/stores/auth-store';
import { supabase } from '@/lib/supabase';
import { Button, Input } from '@/components/ui';
import {
  AccountDeletionRequest,
  requestAccountDeletion,
} from '@/services/account-service';
import { BorderRadius, FontSize, Spacing } from '@/constants/theme';

export default function DeleteAccountScreen() {
  const { colors } = useThemeStore();
  const { profile } = useAuthStore();
  const queryClient = useQueryClient();
  const [confirmText, setConfirmText] = useState('');
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [error, setError] = useState('');
  const queryKey = ['account-deletion-request', profile?.id];

  const {
    data: existingRequest,
    isLoading,
    isError,
    refetch,
  } = useQuery({
    queryKey,
    enabled: Boolean(profile),
    queryFn: async (): Promise<AccountDeletionRequest | null> => {
      const { data, error: requestError } = await supabase
        .from('account_deletion_requests')
        .select('id, status, requested_at')
        .eq('user_id', profile!.id)
        .in('status', ['pending', 'processing'])
        .order('requested_at', { ascending: false })
        .limit(1)
        .maybeSingle();
      if (requestError) throw requestError;
      return data
        ? {
            request_id: data.id,
            status: data.status,
            requested_at: data.requested_at,
            already_requested: true,
          }
        : null;
    },
  });

  const canSubmit = confirmText === 'XÓA TÀI KHOẢN';

  const submit = async () => {
    if (!canSubmit || isSubmitting) return;
    setIsSubmitting(true);
    setError('');

    try {
      const request = await requestAccountDeletion(confirmText);
      queryClient.setQueryData(queryKey, request);
    } catch (reason: unknown) {
      setError(getErrorMessage(
        reason,
        'Không thể gửi yêu cầu xóa tài khoản. Vui lòng thử lại.',
      ));
    } finally {
      setIsSubmitting(false);
    }
  };

  if (isLoading) {
    return (
      <View style={[styles.container, styles.center, { backgroundColor: colors.background }]}>
        <ActivityIndicator size="large" color={colors.primary} />
      </View>
    );
  }

  if (isError) {
    return (
      <View style={[styles.container, styles.center, { backgroundColor: colors.background }]}>
        <Text style={[styles.title, { color: colors.text }]}>Không thể tải trạng thái yêu cầu</Text>
        <Button title="Thử lại" variant="primary" onPress={() => { void refetch(); }} />
        <Button title="Quay lại" variant="outline" onPress={() => router.back()} />
      </View>
    );
  }

  if (existingRequest) {
    const requestedAt = new Date(existingRequest.requested_at).toLocaleString('vi-VN');
    return (
      <View style={[styles.container, styles.center, { backgroundColor: colors.background }]}>
        <Text style={styles.statusIcon}>✓</Text>
        <Text style={[styles.title, { color: colors.text }]}>Yêu cầu đã được ghi nhận</Text>
        <Text style={[styles.statusText, { color: colors.textSecondary }]}>
          Trạng thái: {existingRequest.status === 'processing' ? 'Đang xử lý' : 'Đang chờ xử lý'}
          {'\n'}Gửi lúc: {requestedAt}
        </Text>
        <Text style={[styles.statusHint, { color: colors.textTertiary }]}>
          Tài khoản chưa bị xóa ngay. Đội vận hành cần xử lý yêu cầu theo chính
          sách lưu giữ dữ liệu trước khi xóa vĩnh viễn.
        </Text>
        <Button title="Quay lại hồ sơ" variant="primary" onPress={() => router.back()} />
      </View>
    );
  }

  return (
    <View style={[styles.container, { backgroundColor: colors.background }]}>
      <View style={styles.content}>
        <TouchableOpacity onPress={() => router.back()}>
          <Text style={[styles.backButton, { color: colors.primary }]}>← Quay lại</Text>
        </TouchableOpacity>

        <Text style={styles.warningIcon}>⚠️</Text>
        <Text style={[styles.title, { color: colors.error }]}>Yêu cầu xóa tài khoản</Text>

        <Text style={[styles.warning, { color: colors.text }]}>
          Yêu cầu sẽ được lưu để đội vận hành xác minh và xử lý. Sau khi được
          duyệt, dữ liệu liên quan sẽ bị xóa và không thể khôi phục:
        </Text>

        <View style={[styles.dataList, { backgroundColor: colors.errorLight }]}>
          <Text style={[styles.dataItem, { color: colors.error }]}>• Tài khoản và hồ sơ</Text>
          <Text style={[styles.dataItem, { color: colors.error }]}>• Toàn bộ tiến trình học tập</Text>
          <Text style={[styles.dataItem, { color: colors.error }]}>• Từ vựng đã lưu</Text>
          <Text style={[styles.dataItem, { color: colors.error }]}>• Lịch sử AI Tutor</Text>
          <Text style={[styles.dataItem, { color: colors.error }]}>• Streak, XP, Coins, thành tích</Text>
          <Text style={[styles.dataItem, { color: colors.error }]}>• Lịch sử phát âm</Text>
        </View>

        <Text style={[styles.confirmLabel, { color: colors.textSecondary }]}>
          Nhập “XÓA TÀI KHOẢN” để xác nhận gửi yêu cầu:
        </Text>

        <Input
          placeholder="XÓA TÀI KHOẢN"
          value={confirmText}
          onChangeText={setConfirmText}
          autoCapitalize="characters"
        />

        {error ? <Text style={[styles.error, { color: colors.error }]}>{error}</Text> : null}

        <Button
          title="Gửi yêu cầu xóa"
          variant="danger"
          size="lg"
          fullWidth
          disabled={!canSubmit || isSubmitting}
          loading={isSubmitting}
          onPress={() => { void submit(); }}
        />
      </View>
    </View>
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
  container: { flex: 1 },
  center: {
    justifyContent: 'center',
    alignItems: 'center',
    gap: Spacing.lg,
    paddingHorizontal: Spacing['2xl'],
  },
  content: {
    flex: 1,
    width: '100%',
    maxWidth: 560,
    alignSelf: 'center',
    paddingHorizontal: Spacing['2xl'],
    paddingTop: Spacing['5xl'],
    gap: Spacing.lg,
  },
  backButton: { fontSize: FontSize.base, fontWeight: '500' },
  warningIcon: { fontSize: 48, textAlign: 'center' },
  statusIcon: { fontSize: 48, color: '#205E44' },
  title: { fontSize: FontSize['2xl'], fontWeight: 'bold', textAlign: 'center' },
  warning: { fontSize: FontSize.md, lineHeight: 22 },
  dataList: { padding: Spacing.lg, borderRadius: BorderRadius.lg, gap: Spacing.xs },
  dataItem: { fontSize: FontSize.md },
  confirmLabel: { fontSize: FontSize.md },
  error: { fontSize: FontSize.sm },
  statusText: { fontSize: FontSize.base, lineHeight: 24, textAlign: 'center' },
  statusHint: { fontSize: FontSize.sm, lineHeight: 20, textAlign: 'center' },
});
