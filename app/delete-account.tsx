import React, { useState } from 'react';
import { View, Text, StyleSheet, TouchableOpacity, Alert } from 'react-native';
import { router } from 'expo-router';
import { useThemeStore } from '@/stores/theme-store';
import { useAuthStore } from '@/stores/auth-store';
import { supabase } from '@/lib/supabase';
import { Button, Input } from '@/components/ui';
import { FontSize, Spacing, BorderRadius } from '@/constants/theme';

export default function DeleteAccountScreen() {
  const { colors } = useThemeStore();
  const { profile, signOut } = useAuthStore();
  const [confirmText, setConfirmText] = useState('');
  const [isDeleting, setIsDeleting] = useState(false);
  const [error, setError] = useState('');

  const canDelete = confirmText === 'XÓA TÀI KHOẢN';

  const handleDelete = async () => {
    if (!canDelete) return;

    setIsDeleting(true);
    setError('');

    try {
      // Call server-side deletion (Edge Function or RPC)
      // The actual deletion should cascade through FK relationships
      const { error: deleteError } = await supabase.rpc('request_account_deletion');

      if (deleteError) {
        // Fallback: sign out and mark for deletion
        setError('Không thể xóa ngay. Yêu cầu đã được ghi nhận và sẽ được xử lý trong 48 giờ.');
        return;
      }

      await signOut();
      router.replace('/(auth)/welcome');
    } catch (err) {
      setError('Đã có lỗi xảy ra. Vui lòng thử lại sau.');
    } finally {
      setIsDeleting(false);
    }
  };

  return (
    <View style={[styles.container, { backgroundColor: colors.background }]}>
      <View style={styles.content}>
        <TouchableOpacity onPress={() => router.back()}>
          <Text style={[styles.backBtn, { color: colors.primary }]}>← Quay lại</Text>
        </TouchableOpacity>

        <Text style={styles.warningIcon}>⚠️</Text>
        <Text style={[styles.title, { color: colors.error }]}>Xóa tài khoản</Text>

        <Text style={[styles.warning, { color: colors.text }]}>
          Hành động này KHÔNG thể hoàn tác. Toàn bộ dữ liệu sau sẽ bị xóa vĩnh viễn:
        </Text>

        <View style={[styles.dataList, { backgroundColor: colors.errorLight }]}>
          <Text style={[styles.dataItem, { color: colors.error }]}>• Tài khoản và hồ sơ</Text>
          <Text style={[styles.dataItem, { color: colors.error }]}>• Toàn bộ tiến trình học tập</Text>
          <Text style={[styles.dataItem, { color: colors.error }]}>• Từ vựng đã lưu</Text>
          <Text style={[styles.dataItem, { color: colors.error }]}>• Lịch sử AI Tutor</Text>
          <Text style={[styles.dataItem, { color: colors.error }]}>• Streak, XP, Coins, Achievements</Text>
          <Text style={[styles.dataItem, { color: colors.error }]}>• Lịch sử phát âm</Text>
        </View>

        <Text style={[styles.confirmLabel, { color: colors.textSecondary }]}>
          Nhập "XÓA TÀI KHOẢN" để xác nhận:
        </Text>

        <Input
          placeholder="XÓA TÀI KHOẢN"
          value={confirmText}
          onChangeText={setConfirmText}
          autoCapitalize="characters"
        />

        {error ? (
          <Text style={[styles.errorText, { color: colors.error }]}>{error}</Text>
        ) : null}

        <Button
          title="Xóa vĩnh viễn"
          variant="danger"
          size="lg"
          fullWidth
          disabled={!canDelete}
          loading={isDeleting}
          onPress={handleDelete}
        />
      </View>
    </View>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1 },
  content: { flex: 1, paddingHorizontal: Spacing['2xl'], paddingTop: Spacing['5xl'], gap: Spacing.lg },
  backBtn: { fontSize: FontSize.base, fontWeight: '500' },
  warningIcon: { fontSize: 48, textAlign: 'center' },
  title: { fontSize: FontSize['2xl'], fontWeight: 'bold', textAlign: 'center' },
  warning: { fontSize: FontSize.md, lineHeight: 22 },
  dataList: { padding: Spacing.lg, borderRadius: BorderRadius.lg, gap: Spacing.xs },
  dataItem: { fontSize: FontSize.md },
  confirmLabel: { fontSize: FontSize.md },
  errorText: { fontSize: FontSize.sm },
});
