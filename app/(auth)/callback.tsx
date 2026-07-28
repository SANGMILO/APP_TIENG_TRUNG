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
import {
  exchangeAuthCodeOnce,
  classifyExchangedSession,
  isExplicitRecoveryCallback,
  isOAuthCallback,
  GoogleOAuthError,
} from '@/services/google-oauth';
import { getPostAuthDestination } from '@/services/auth-navigation';

type CallbackErrorKind = 'oauth' | 'recovery';

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
  const processing = useRef(false);
  const [error, setError] = useState('');
  const [errorKind, setErrorKind] = useState<CallbackErrorKind>('oauth');
  const {
    setSession,
    fetchProfile,
    setRecoverySession,
    isRecoverySession,
    beginAuthTransition,
    endAuthTransition,
  } = useAuthStore();

  useEffect(() => {
    const url = getCurrentCallbackUrl(linkingUrl);
    const recoveryAttemptKey = `${url ?? ''}:${isRecoverySession}`;
    if (
      completed.current
      || processing.current
      || !url
      || handledUrl.current === recoveryAttemptKey
    ) {
      return;
    }
    handledUrl.current = recoveryAttemptKey;
    processing.current = true;
    beginAuthTransition();

    const complete = async () => {
      setError('');
      const explicitRecovery = isExplicitRecoveryCallback(url);
      let currentErrorKind: CallbackErrorKind = (
        explicitRecovery || isRecoverySession
      ) ? 'recovery' : 'oauth';

      try {
        if (explicitRecovery || (!isOAuthCallback(url) && isRecoverySession)) {
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
          endAuthTransition();
          router.replace('/(auth)/reset-password');
          return;
        }

        if (!isOAuthCallback(url)) {
          throw new GoogleOAuthError('Phản hồi xác thực không hợp lệ hoặc đã hết hạn.');
        }

        const session = await exchangeAuthCodeOnce(
          (code) => supabase.auth.exchangeCodeForSession(code),
          url,
        );
        const recoveryDetected = useAuthStore.getState().isRecoverySession;
        const exchangedSessionKind = classifyExchangedSession(
          session,
          recoveryDetected,
        );

        if (exchangedSessionKind === 'recovery') {
          currentErrorKind = 'recovery';
          completed.current = true;
          setSession(session);
          setRecoverySession(true);
          void fetchProfile(session.user.id);
          endAuthTransition();
          router.replace('/(auth)/reset-password');
          return;
        }

        if (exchangedSessionKind !== 'google') {
          throw new GoogleOAuthError(
            'Phản hồi xác thực không thuộc nhà cung cấp Google.',
          );
        }

        setRecoverySession(false);
        setSession(session);
        const profile = await fetchProfile(session.user.id);
        if (!profile) {
          throw new GoogleOAuthError(
            useAuthStore.getState().profileError
              ?? 'Không thể tải hồ sơ. Vui lòng thử lại.',
          );
        }

        completed.current = true;
        router.replace(getPostAuthDestination(profile));
      } catch (err: unknown) {
        endAuthTransition();
        setRecoverySession(false);
        setErrorKind(currentErrorKind);
        setError(
          err instanceof Error && err.message
            ? err.message
            : currentErrorKind === 'recovery'
              ? 'Liên kết đặt lại mật khẩu không hợp lệ hoặc đã hết hạn.'
              : 'Không thể hoàn tất đăng nhập Google.',
        );
      } finally {
        if (!completed.current) {
          processing.current = false;
        }
      }
    };

    void complete();
  }, [
    fetchProfile,
    beginAuthTransition,
    endAuthTransition,
    isRecoverySession,
    linkingUrl,
    setRecoverySession,
    setSession,
  ]);

  if (error) {
    return (
      <View style={[styles.container, { backgroundColor: colors.background }]}>
        <Text style={[styles.icon, { color: colors.error }]}>!</Text>
        <Text style={[styles.title, { color: colors.text }]}>
          {errorKind === 'recovery' ? 'Liên kết không hợp lệ' : 'Không thể hoàn tất đăng nhập'}
        </Text>
        <Text style={[styles.message, { color: colors.textSecondary }]}>{error}</Text>
        <Button
          title={errorKind === 'recovery' ? 'Yêu cầu liên kết mới' : 'Quay lại đăng nhập'}
          variant="primary"
          size="lg"
          onPress={() => router.replace(
            errorKind === 'recovery'
              ? '/(auth)/forgot-password'
              : '/(auth)/login'
          )}
        />
      </View>
    );
  }

  return (
    <View style={[styles.container, { backgroundColor: colors.background }]}>
      <ActivityIndicator size="large" color={colors.primary} />
      <Text style={[styles.message, { color: colors.textSecondary }]}>
        Đang xác minh phiên đăng nhập...
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
