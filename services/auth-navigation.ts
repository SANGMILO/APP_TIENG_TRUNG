import type { Profile } from '@/types';

export const AUTH_ROUTES = {
  welcome: '/(auth)/welcome',
  login: '/(auth)/login',
  resetPassword: '/(auth)/reset-password',
  onboarding: '/onboarding',
  home: '/(tabs)/learn',
} as const;

export type AuthDestination =
  | typeof AUTH_ROUTES.welcome
  | typeof AUTH_ROUTES.login
  | typeof AUTH_ROUTES.resetPassword
  | typeof AUTH_ROUTES.onboarding
  | typeof AUTH_ROUTES.home;

export type ProfileStatus = 'idle' | 'loading' | 'ready' | 'error';

interface GuardState {
  segments: readonly string[];
  hasSession: boolean;
  isInitialized: boolean;
  isLoading: boolean;
  isAuthTransitioning: boolean;
  isRecoverySession: boolean;
  profile: Profile | null;
  profileStatus: ProfileStatus;
}

const AUTH_ENTRY_SCREENS = new Set(['welcome', 'login', 'register']);
const RECOVERY_SCREENS = new Set(['callback', 'reset-password']);
const PUBLIC_ROOT_ROUTES = new Set(['', 'index', 'privacy', '+not-found']);

export function getPostAuthDestination(
  profile: Pick<Profile, 'onboarding_completed'>,
): AuthDestination {
  return profile.onboarding_completed ? AUTH_ROUTES.home : AUTH_ROUTES.onboarding;
}

export function isAuthEntryRoute(segments: readonly string[]): boolean {
  return segments[0] === '(auth)' && AUTH_ENTRY_SCREENS.has(segments[1] ?? '');
}

export function isRecoveryRoute(segments: readonly string[]): boolean {
  return segments[0] === '(auth)' && RECOVERY_SCREENS.has(segments[1] ?? '');
}

export function isProtectedRoute(segments: readonly string[]): boolean {
  const root = segments[0] ?? '';

  if (root === '(auth)' || PUBLIC_ROOT_ROUTES.has(root)) {
    return false;
  }

  return true;
}

export function getAuthGuardRedirect(state: GuardState): AuthDestination | null {
  if (!state.isInitialized || state.isLoading || state.isAuthTransitioning) {
    return null;
  }

  if (state.isRecoverySession && !isRecoveryRoute(state.segments)) {
    return AUTH_ROUTES.resetPassword;
  }

  if (isRecoveryRoute(state.segments)) {
    return null;
  }

  if (!state.hasSession) {
    return isProtectedRoute(state.segments) ? AUTH_ROUTES.welcome : null;
  }

  if (state.profileStatus !== 'ready' || !state.profile) {
    return null;
  }

  if (isAuthEntryRoute(state.segments)) {
    return getPostAuthDestination(state.profile);
  }

  if (
    state.segments[0] === 'onboarding'
    && state.profile.onboarding_completed
  ) {
    return AUTH_ROUTES.home;
  }

  return null;
}
