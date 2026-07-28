import { useEffect, useRef, useState } from 'react';
import { ActivityIndicator, StyleSheet, Text, View } from 'react-native';
import * as Linking from 'expo-linking';
import { router } from 'expo-router';
import { useThemeStore } from '@/stores/theme-store';
import { useAuthStore } from '@/stores/auth-store';
import { supabase } from '@/lib/supabase';
import { Button } from '@/components/ui';
import { FontFamily, FontSize, Spacing } from '@/constants/theme';
import { completeRecoveryCallback } from '@/services/auth-recovery';

function getCurrentCallbackUrl(linkingUrl: string | null): string | null {
  if (linkingUrl) {
    return linkingUrl;
  }

  if (typeof window !== 'undefined') {
    return window.location.href;
  }

  return null;
}

export default function AuthCallbackScreen() {
  const { colors } = useThemeStore();
  const linkingUrl = Linking.useURL();
  const handledUrl = useRef<string | null>(null);
  const completed = useRef(false);
  const [error, setError] = useState('');
  const {
    setSession,
    fetchProfile,
    setRecoverySession,
    isRecoverySession,
  } = useAuthStore();

  useEffect(() => {
    const url = getCurrentCallbackUrl(linkingUrl);
    const recoveryAttemptKey = `${url ?? ''}:${isRecoverySession}`;
    if (completed.current || !url || handledUrl.current === recoveryAttemptKey) {
      return;
    }
    handledUrl.current = recoveryAttemptKey;

    const complete = async () => {
      setError('');

      try {
        const session = await completeRecoveryCallback({
          exchangeCodeForSession: (code) => supabase.auth.exchangeCodeForSession(code),
          setSession: (tokens) => supabase.auth.setSession(tokens),
          verifyOtp: (params) => supabase.auth.verifyOtp(params),
          getSession: () => supabase.auth.getSession(),
        }, url, { hasRecoverySession: isRecoverySession });

        completed.current = true;
        setSession(session);
        setRecoverySession(true);
        void fetchProfile(session.user.id);
        router.replace('/(auth)/reset-password');
      } catch (err: unknown) {
        setRecoverySession(false);
        setError(
          err instanceof Error && err.message
            ? err.message
            : 'Liên kết đặt lại mật khẩu không hợp lệ hoặc đã hết hạn.',
        );
      }
    };

    void complete();
  }, [
    fetchProfile,
    isRecoverySession,
    linkingUrl,
    setRecoverySession,
    setSession,
  ]);

  if (error) {
    return (
      <View style={[styles.container, { backgroundColor: colors.background }]}>
        <Text style={[styles.icon, { color: colors.error }]}>!</Text>
        <Text style={[styles.title, { color: colors.text }]}>Liên kết không hợp lệ</Text>
        <Text style={[styles.message, { color: colors.textSecondary }]}>{error}</Text>
        <Button
          title="Yêu cầu liên kết mới"
          variant="primary"
          size="lg"
          onPress={() => router.replace('/(auth)/forgot-password')}
        />
      </View>
    );
  }

  return (
    <View style={[styles.container, { backgroundColor: colors.background }]}>
      <ActivityIndicator size="large" color={colors.primary} />
      <Text style={[styles.message, { color: colors.textSecondary }]}>
        Đang xác minh liên kết đặt lại mật khẩu...
      </Text>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
    paddingHorizontal: Spacing['2xl'],
  },
  icon: {
    width: 56,
    height: 56,
    borderRadius: 28,
    borderWidth: 2,
    textAlign: 'center',
    textAlignVertical: 'center',
    fontSize: FontSize['3xl'],
    fontFamily: FontFamily.bold,
    marginBottom: Spacing.xl,
  },
  title: {
    fontSize: FontSize['2xl'],
    fontFamily: FontFamily.heading,
    textAlign: 'center',
    marginBottom: Spacing.md,
  },
  message: {
    fontSize: FontSize.base,
    fontFamily: FontFamily.regular,
    lineHeight: 24,
    textAlign: 'center',
    marginTop: Spacing.lg,
    marginBottom: Spacing['2xl'],
  },
});
