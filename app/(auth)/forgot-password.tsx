import React, { useState } from 'react';
import {
  View,
  Text,
  StyleSheet,
  TouchableOpacity,
  KeyboardAvoidingView,
  Platform,
} from 'react-native';
import { router } from 'expo-router';
import { useForm, Controller } from 'react-hook-form';
import { zodResolver } from '@hookform/resolvers/zod';
import { z } from 'zod';
import { useThemeStore } from '@/stores/theme-store';
import { supabase } from '@/lib/supabase';
import { Button, Input } from '@/components/ui';
import { FontSize, Spacing } from '@/constants/theme';

const schema = z.object({
  email: z.string().email('Email không hợp lệ'),
});

type ForgotForm = z.infer<typeof schema>;

export default function ForgotPasswordScreen() {
  const { colors } = useThemeStore();
  const [isLoading, setIsLoading] = useState(false);
  const [sent, setSent] = useState(false);

  const { control, handleSubmit, formState: { errors } } = useForm<ForgotForm>({
    resolver: zodResolver(schema),
    defaultValues: { email: '' },
  });

  const onSubmit = async (data: ForgotForm) => {
    setIsLoading(true);
    try {
      await supabase.auth.resetPasswordForEmail(data.email);
      setSent(true);
    } catch {
      // Still show success to prevent email enumeration
      setSent(true);
    } finally {
      setIsLoading(false);
    }
  };

  if (sent) {
    return (
      <View style={[styles.container, { backgroundColor: colors.background }]}>
        <View style={styles.center}>
          <Text style={[styles.emoji]}>📧</Text>
          <Text style={[styles.title, { color: colors.text }]}>Đã gửi email</Text>
          <Text style={[styles.subtitle, { color: colors.textSecondary }]}>
            Kiểm tra hộp thư để đặt lại mật khẩu
          </Text>
          <Button
            title="Quay lại đăng nhập"
            variant="primary"
            size="lg"
            onPress={() => router.replace('/(auth)/login')}
            style={{ marginTop: Spacing['2xl'] }}
          />
        </View>
      </View>
    );
  }

  return (
    <KeyboardAvoidingView
      style={[styles.container, { backgroundColor: colors.background }]}
      behavior={Platform.OS === 'ios' ? 'padding' : 'height'}
    >
      <View style={styles.content}>
        <TouchableOpacity
          style={styles.backButton}
          onPress={() => router.back()}
        >
          <Text style={[styles.backText, { color: colors.primary }]}>← Quay lại</Text>
        </TouchableOpacity>

        <View style={styles.header}>
          <Text style={[styles.title, { color: colors.text }]}>Quên mật khẩu</Text>
          <Text style={[styles.subtitle, { color: colors.textSecondary }]}>
            Nhập email để nhận link đặt lại mật khẩu
          </Text>
        </View>

        <Controller
          control={control}
          name="email"
          render={({ field: { onChange, onBlur, value } }) => (
            <Input
              label="Email"
              placeholder="email@example.com"
              keyboardType="email-address"
              autoCapitalize="none"
              value={value}
              onChangeText={onChange}
              onBlur={onBlur}
              error={errors.email?.message}
            />
          )}
        />

        <Button
          title="Gửi email"
          variant="primary"
          size="lg"
          fullWidth
          loading={isLoading}
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
    paddingHorizontal: Spacing['2xl'],
    paddingTop: Spacing['5xl'],
  },
  center: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    paddingHorizontal: Spacing['2xl'],
  },
  backButton: {
    marginBottom: Spacing['2xl'],
  },
  backText: {
    fontSize: FontSize.base,
    fontWeight: '500',
  },
  header: {
    marginBottom: Spacing['3xl'],
  },
  emoji: {
    fontSize: 48,
    marginBottom: Spacing.lg,
  },
  title: {
    fontSize: FontSize['3xl'],
    fontWeight: 'bold',
    marginBottom: Spacing.sm,
  },
  subtitle: {
    fontSize: FontSize.base,
    textAlign: 'center',
  },
});
