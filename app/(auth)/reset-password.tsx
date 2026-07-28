import { useState } from 'react';
import {
  KeyboardAvoidingView,
  Platform,
  StyleSheet,
  Text,
  View,
} from 'react-native';
import { router } from 'expo-router';
import { Controller, useForm } from 'react-hook-form';
import { zodResolver } from '@hookform/resolvers/zod';
import { z } from 'zod';
import { useThemeStore } from '@/stores/theme-store';
import { useAuthStore } from '@/stores/auth-store';
import { supabase } from '@/lib/supabase';
import { Button, Input } from '@/components/ui';
import { FontFamily, FontSize, Spacing } from '@/constants/theme';
import { updateRecoveryPassword } from '@/services/auth-flow';
import { AUTH_ROUTES, getPostAuthDestination } from '@/services/auth-navigation';

const resetPasswordSchema = z.object({
  password: z.string().min(8, 'Mật khẩu ít nhất 8 ký tự'),
  confirmPassword: z.string(),
}).refine((data) => data.password === data.confirmPassword, {
  message: 'Mật khẩu không khớp',
  path: ['confirmPassword'],
});

type ResetPasswordForm = z.infer<typeof resetPasswordSchema>;

export default function ResetPasswordScreen() {
  const { colors } = useThemeStore();
  const {
    session,
    profile,
    isRecoverySession,
    setRecoverySession,
  } = useAuthStore();
  const [isLoading, setIsLoading] = useState(false);
  const [error, setError] = useState('');
  const [updated, setUpdated] = useState(false);
  const { control, handleSubmit, formState: { errors } } = useForm<ResetPasswordForm>({
    resolver: zodResolver(resetPasswordSchema),
    defaultValues: {
      password: '',
      confirmPassword: '',
    },
  });

  const onSubmit = async (data: ResetPasswordForm) => {
    if (isLoading) return;

    setIsLoading(true);
    setError('');

    try {
      await updateRecoveryPassword({
        updateUser: (attributes) => supabase.auth.updateUser(attributes),
      }, data.password, isRecoverySession && Boolean(session));
      setRecoverySession(false);
      setUpdated(true);
    } catch (err: unknown) {
      setError(
        err instanceof Error && err.message
          ? err.message
          : 'Không thể cập nhật mật khẩu. Vui lòng thử lại.',
      );
    } finally {
      setIsLoading(false);
    }
  };

  const continueAfterSuccess = () => {
    const destination = session && profile
      ? getPostAuthDestination(profile)
      : AUTH_ROUTES.login;
    router.replace(destination);
  };

  if (updated) {
    return (
      <View style={[styles.center, { backgroundColor: colors.background }]}>
        <Text style={styles.successIcon}>✓</Text>
        <Text style={[styles.title, { color: colors.text }]}>Đã cập nhật mật khẩu</Text>
        <Text style={[styles.subtitle, { color: colors.textSecondary }]}>
          Mật khẩu mới đã được lưu thành công.
        </Text>
        <Button
          title={session ? 'Tiếp tục vào ứng dụng' : 'Quay lại đăng nhập'}
          variant="primary"
          size="lg"
          onPress={continueAfterSuccess}
          style={styles.actionButton}
        />
      </View>
    );
  }

  if (!isRecoverySession || !session) {
    return (
      <View style={[styles.center, { backgroundColor: colors.background }]}>
        <Text style={[styles.title, { color: colors.text }]}>Liên kết không còn hiệu lực</Text>
        <Text style={[styles.subtitle, { color: colors.textSecondary }]}>
          Liên kết đặt lại mật khẩu bị thiếu, không hợp lệ hoặc đã hết hạn.
        </Text>
        <Button
          title="Yêu cầu liên kết mới"
          variant="primary"
          size="lg"
          onPress={() => router.replace('/(auth)/forgot-password')}
          style={styles.actionButton}
        />
      </View>
    );
  }

  return (
    <KeyboardAvoidingView
      style={[styles.container, { backgroundColor: colors.background }]}
      behavior={Platform.OS === 'ios' ? 'padding' : 'height'}
    >
      <View style={styles.content}>
        <Text style={[styles.title, { color: colors.text }]}>Đặt mật khẩu mới</Text>
        <Text style={[styles.subtitle, { color: colors.textSecondary }]}>
          Mật khẩu cần có ít nhất 8 ký tự.
        </Text>

        {error ? (
          <Text style={[styles.error, { color: colors.error }]}>{error}</Text>
        ) : null}

        <Controller
          control={control}
          name="password"
          render={({ field: { onChange, onBlur, value } }) => (
            <Input
              label="Mật khẩu mới"
              placeholder="Nhập mật khẩu mới"
              secureTextEntry
              autoCapitalize="none"
              value={value}
              onChangeText={onChange}
              onBlur={onBlur}
              error={errors.password?.message}
            />
          )}
        />

        <Controller
          control={control}
          name="confirmPassword"
          render={({ field: { onChange, onBlur, value } }) => (
            <Input
              label="Xác nhận mật khẩu"
              placeholder="Nhập lại mật khẩu mới"
              secureTextEntry
              autoCapitalize="none"
              value={value}
              onChangeText={onChange}
              onBlur={onBlur}
              error={errors.confirmPassword?.message}
            />
          )}
        />

        <Button
          title="Cập nhật mật khẩu"
          variant="primary"
          size="lg"
          fullWidth
          loading={isLoading}
          disabled={isLoading}
          onPress={handleSubmit(onSubmit)}
        />
      </View>
    </KeyboardAvoidingView>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
  },
  content: {
    flex: 1,
    width: '100%',
    maxWidth: 430,
    alignSelf: 'center',
    justifyContent: 'center',
    paddingHorizontal: Spacing['2xl'],
  },
  center: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
    paddingHorizontal: Spacing['2xl'],
  },
  title: {
    fontSize: FontSize['3xl'],
    fontFamily: FontFamily.heading,
    textAlign: 'center',
    marginBottom: Spacing.sm,
  },
  subtitle: {
    fontSize: FontSize.base,
    fontFamily: FontFamily.regular,
    lineHeight: 24,
    textAlign: 'center',
    marginBottom: Spacing['2xl'],
  },
  error: {
    fontSize: FontSize.sm,
    fontFamily: FontFamily.medium,
    lineHeight: 20,
    marginBottom: Spacing.lg,
  },
  successIcon: {
    width: 64,
    height: 64,
    borderRadius: 32,
    backgroundColor: '#205E44',
    color: '#FFFFFF',
    textAlign: 'center',
    textAlignVertical: 'center',
    fontSize: FontSize['3xl'],
    marginBottom: Spacing.xl,
  },
  actionButton: {
    marginTop: Spacing.sm,
    minWidth: 220,
  },
});
