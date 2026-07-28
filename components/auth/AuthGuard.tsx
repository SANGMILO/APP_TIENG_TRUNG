import { useEffect, useRef } from 'react';
import { router, usePathname, useSegments, type Href } from 'expo-router';
import { useAuthStore } from '@/stores/auth-store';
import {
  getAuthGuardRedirect,
  isAuthEntryRoute,
  isProtectedRoute,
} from '@/services/auth-navigation';

export function AuthGuard() {
  const segments = useSegments();
  const pathname = usePathname();
  const lastRedirectFrom = useRef<string | null>(null);
  const {
    session,
    profile,
    profileStatus,
    isLoading,
    isInitialized,
    isAuthTransitioning,
    isRecoverySession,
    endAuthTransition,
  } = useAuthStore();

  useEffect(() => {
    if (!isAuthTransitioning) {
      return;
    }

    const loginTransitionFinished = Boolean(session) && isProtectedRoute(segments);
    const logoutTransitionFinished = !session && isAuthEntryRoute(segments);

    if (loginTransitionFinished || logoutTransitionFinished) {
      endAuthTransition();
    }
  }, [endAuthTransition, isAuthTransitioning, segments, session]);

  const redirect = getAuthGuardRedirect({
    segments,
    hasSession: Boolean(session),
    isInitialized,
    isLoading,
    isAuthTransitioning,
    isRecoverySession,
    profile,
    profileStatus,
  });

  useEffect(() => {
    if (!redirect) {
      lastRedirectFrom.current = null;
      return;
    }

    if (lastRedirectFrom.current === pathname) {
      return;
    }

    lastRedirectFrom.current = pathname;
    router.replace(redirect as Href);
  }, [pathname, redirect]);

  return null;
}
