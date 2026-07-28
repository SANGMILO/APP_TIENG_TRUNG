import React, { useEffect, useState } from 'react';
import {
  ScrollView,
  StyleSheet,
  Text,
  TouchableOpacity,
  View,
} from 'react-native';
import { router } from 'expo-router';
import { useAuthStore } from '@/stores/auth-store';
import { useThemeStore } from '@/stores/theme-store';
import { Button, Input } from '@/components/ui';
import { BorderRadius, FontSize, Spacing } from '@/constants/theme';

export default function AccountScreen() {
  const { colors } = useThemeStore();
  const { profile, updateProfile } = useAuthStore();
  const [displayName, setDisplayName] = useState(profile?.display_name ?? '');
  const [username, setUsername] = useState(profile?.username ?? '');
  const [saving, setSaving] = useState(false);
  const [error, setError] = useState('');
  const [saved, setSaved] = useState(false);

  useEffect(() => {
    setDisplayName(profile?.display_name ?? '');
    setUsername(profile?.username ?? '');
  }, [profile?.display_name, profile?.username]);

  const save = async () => {
    if (saving) return;
    const normalizedName = displayName.trim();
    const normalizedUsername = username.trim();

    if (!normalizedName) {
      setError('Tên hiển thị không được để trống.');
      return;
    }
    if (
      normalizedUsername
      && !/^[A-Za-z0-9_]{3,30}$/.test(normalizedUsername)
    ) {
      setError('Tên người dùng cần 3–30 ký tự chữ, số hoặc dấu gạch dưới.');
      return;
    }

    setSaving(true);
    setError('');
    setSaved(false);
    try {
      await updateProfile({
        display_name: normalizedName,
        username: normalizedUsername || null,
      });
      setSaved(true);
    } catch (reason: unknown) {
      const message = getErrorMessage(
        reason,
        'Không thể cập nhật hồ sơ. Vui lòng thử lại.',
      );
      setError(
        message.toLowerCase().includes('unique')
          ? 'Tên người dùng này đã được sử dụng.'
          : message,
      );
    } finally {
      setSaving(false);
    }
  };

  return (
    <ScrollView
      style={[styles.screen, { backgroundColor: colors.background }]}
      contentContainerStyle={styles.content}
      keyboardShouldPersistTaps="handled"
    >
      <TouchableOpacity onPress={() => router.back()}>
        <Text style={[styles.backButton, { color: colors.primary }]}>← Quay lại</Text>
      </TouchableOpacity>

      <Text style={[styles.title, { color: colors.text }]}>Tài khoản & Hồ sơ</Text>
      <Text style={[styles.subtitle, { color: colors.textSecondary }]}>
        Cập nhật thông tin hiển thị của bạn.
      </Text>

      <View style={[styles.card, { backgroundColor: colors.card, borderColor: colors.border }]}>
        <Input
          label="Tên hiển thị"
          value={displayName}
          onChangeText={(value) => {
            setDisplayName(value);
            setSaved(false);
          }}
          placeholder="Tên của bạn"
          maxLength={80}
        />
        <Input
          label="Tên người dùng"
          value={username}
          onChangeText={(value) => {
            setUsername(value);
            setSaved(false);
          }}
          placeholder="ten_nguoi_dung"
          autoCapitalize="none"
          maxLength={30}
        />
        <Text style={[styles.emailLabel, { color: colors.textTertiary }]}>
          Email: {profile?.email ?? '—'}
        </Text>

        {error ? <Text style={[styles.message, { color: colors.error }]}>{error}</Text> : null}
        {saved ? (
          <Text style={[styles.message, { color: colors.success }]}>
            Hồ sơ đã được cập nhật.
          </Text>
        ) : null}

        <Button
          title="Lưu thay đổi"
          variant="primary"
          size="lg"
          fullWidth
          loading={saving}
          disabled={saving}
          onPress={() => { void save(); }}
        />
      </View>

      <View style={[styles.card, { backgroundColor: colors.card, borderColor: colors.border }]}>
        <Text style={[styles.dangerTitle, { color: colors.error }]}>Xóa tài khoản</Text>
        <Text style={[styles.dangerDescription, { color: colors.textSecondary }]}>
          Gửi yêu cầu xóa tài khoản và toàn bộ dữ liệu liên quan để đội vận hành xử lý.
        </Text>
        <Button
          title="Yêu cầu xóa tài khoản"
          variant="danger"
          size="md"
          fullWidth
          onPress={() => router.push('/delete-account')}
        />
      </View>
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
    padding: Spacing.xl,
    gap: Spacing.lg,
    marginBottom: Spacing.xl,
  },
  emailLabel: { fontSize: FontSize.sm },
  message: { fontSize: FontSize.sm, textAlign: 'center' },
  dangerTitle: { fontSize: FontSize.lg, fontWeight: '600' },
  dangerDescription: { fontSize: FontSize.sm, lineHeight: 20 },
});
