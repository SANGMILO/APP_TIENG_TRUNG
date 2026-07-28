import { useState } from 'react';
import { Platform } from 'react-native';
import { router } from 'expo-router';
import { makeRedirectUri } from 'expo-auth-session';
import * as WebBrowser from 'expo-web-browser';
import { supabase } from '@/lib/supabase';
import { useAuthStore } from '@/stores/auth-store';
import {
  exchangeAuthCodeOnce,
  getGoogleOAuthRedirectUrl,
  isGoogleSession,
  startGoogleOAuth,
} from '@/services/google-oauth';
import { getPostAuthDestination } from '@/services/auth-navigation';

type ErrorSetter = (message: string) => void;

function getRuntimePlatform(): 'web' | 'ios' | 'android' {
  if (Platform.OS === 'web') return 'web';
  if (Platform.OS === 'ios') return 'ios';
  return 'android';
}

function getRuntimeRedirectUrl(platform: 'web' | 'ios' | 'android'): string {
  if (platform === 'web') {
    return getGoogleOAuthRedirectUrl('web');
  }

  const nativeRedirect = getGoogleOAuthRedirectUrl(platform);
  return makeRedirectUri({
    scheme: 'mandarin-master',
    path: 'callback',
    native: nativeRedirect,
  });
}

export function useGoogleOAuth(setError: ErrorSetter) {
  const [isGoogleLoading, setIsGoogleLoading] = useState(false);
  const {
    setSession,
    fetchProfile,
    setRecoverySession,
    beginAuthTransition,
    endAuthTransition,
  } = useAuthStore();

  const start = async () => {
    if (isGoogleLoading) return;

    const platform = getRuntimePlatform();
    const redirectTo = getRuntimeRedirectUrl(platform);
    let keepLoadingForBrowserRedirect = false;

    setIsGoogleLoading(true);
    setError('');
    beginAuthTransition();

    try {
      const result = await startGoogleOAuth({
        signInWithOAuth: (params) => supabase.auth.signInWithOAuth(params),
        openAuthSession: (authUrl, callbackUrl) =>
          WebBrowser.openAuthSessionAsync(authUrl, callbackUrl),
      }, {
        platform,
        redirectTo,
      });

      if (result.status === 'duplicate') {
        keepLoadingForBrowserRedirect = true;
        return;
      }

      if (result.status === 'cancelled') {
        endAuthTransition();
        return;
      }

      if (result.status === 'redirecting') {
        keepLoadingForBrowserRedirect = true;
        return;
      }

      const session = await exchangeAuthCodeOnce(
        (code) => supabase.auth.exchangeCodeForSession(code),
        result.url,
      );

      if (!isGoogleSession(session)) {
        throw new Error('Phản hồi xác thực không thuộc nhà cung cấp Google.');
      }

      setRecoverySession(false);
      setSession(session);
      const profile = await fetchProfile(session.user.id);
      if (!profile) {
        throw new Error('Không thể tải hồ sơ. Vui lòng thử lại.');
      }

      router.replace(getPostAuthDestination(profile));
    } catch (error: unknown) {
      endAuthTransition();
      setError(
        error instanceof Error && error.message
          ? error.message
          : 'Không thể bắt đầu đăng nhập Google. Vui lòng thử lại.',
      );
    } finally {
      if (!keepLoadingForBrowserRedirect) {
        setIsGoogleLoading(false);
      }
    }
  };

  return {
    isGoogleLoading,
    startGoogleOAuth: start,
  };
}
