import type { Session } from '@supabase/supabase-js';
import type { Profile } from '../types';
import {
  createAuthCodeExchanger,
  createGoogleOAuthStarter,
  classifyExchangedSession,
  getGoogleOAuthRedirectUrl,
  isExplicitRecoveryCallback,
  isGoogleSession,
  isOAuthCallback,
  OAuthCallbackReplayError,
} from '../services/google-oauth';
import { getPostAuthDestination, getAuthGuardRedirect, AUTH_ROUTES } from '../services/auth-navigation';
import { completeRecoveryCallback } from '../services/auth-recovery';
import { signOutSession } from '../services/auth-flow';

const googleSession = {
  user: {
    id: 'google-user',
    app_metadata: {
      provider: 'google',
      providers: ['google'],
    },
    identities: [{ provider: 'google' }],
  },
} as unknown as Session;

const emailSession = {
  user: {
    id: 'email-user',
    app_metadata: {
      provider: 'email',
      providers: ['email'],
    },
    identities: [{ provider: 'email' }],
  },
} as unknown as Session;

describe('Google OAuth start flow', () => {
  it('builds the configured Web and native redirect URLs', () => {
    expect(getGoogleOAuthRedirectUrl(
      'web',
      'http://localhost:8081',
    )).toBe('http://localhost:8081/callback');
    expect(getGoogleOAuthRedirectUrl('ios')).toBe('mandarin-master://callback');
    expect(getGoogleOAuthRedirectUrl('android')).toBe('mandarin-master://callback');
  });

  it('starts Web OAuth with Google and without skipBrowserRedirect', async () => {
    const signInWithOAuth = jest.fn().mockResolvedValue({
      data: { url: 'https://accounts.google.com/oauth' },
      error: null,
    });
    const openAuthSession = jest.fn();

    await expect(createGoogleOAuthStarter()({
      signInWithOAuth,
      openAuthSession,
    }, {
      platform: 'web',
      redirectTo: 'http://localhost:8081/callback',
    })).resolves.toEqual({ status: 'redirecting' });

    expect(signInWithOAuth).toHaveBeenCalledWith({
      provider: 'google',
      options: {
        redirectTo: 'http://localhost:8081/callback',
      },
    });
    expect(openAuthSession).not.toHaveBeenCalled();
  });

  it('preserves a Supabase OAuth start error', async () => {
    const error = new Error('Google provider is disabled');

    await expect(createGoogleOAuthStarter()({
      signInWithOAuth: jest.fn().mockResolvedValue({
        data: { url: null },
        error,
      }),
      openAuthSession: jest.fn(),
    }, {
      platform: 'web',
      redirectTo: 'http://localhost:8081/callback',
    })).rejects.toBe(error);
  });

  it('blocks a duplicate Google start while the first request is pending', async () => {
    let resolveFirst: ((result: {
      data: { url: string };
      error: null;
    }) => void) | undefined;
    const firstResult = new Promise<{
      data: { url: string };
      error: null;
    }>((resolve) => {
      resolveFirst = resolve;
    });
    const starter = createGoogleOAuthStarter();
    const dependencies = {
      signInWithOAuth: jest.fn().mockReturnValue(firstResult),
      openAuthSession: jest.fn(),
    };

    const first = starter(dependencies, {
      platform: 'web',
      redirectTo: 'http://localhost:8081/callback',
    });
    await expect(starter(dependencies, {
      platform: 'web',
      redirectTo: 'http://localhost:8081/callback',
    })).resolves.toEqual({ status: 'duplicate' });

    resolveFirst?.({
      data: { url: 'https://accounts.google.com/oauth' },
      error: null,
    });
    await expect(first).resolves.toEqual({ status: 'redirecting' });
    expect(dependencies.signInWithOAuth).toHaveBeenCalledTimes(1);
  });

  it('uses the browser auth session only on native', async () => {
    const signInWithOAuth = jest.fn().mockResolvedValue({
      data: { url: 'https://accounts.google.com/oauth' },
      error: null,
    });
    const openAuthSession = jest.fn().mockResolvedValue({
      type: 'success',
      url: 'mandarin-master://callback?code=native-code',
    });

    await expect(createGoogleOAuthStarter()({
      signInWithOAuth,
      openAuthSession,
    }, {
      platform: 'android',
      redirectTo: 'mandarin-master://callback',
    })).resolves.toEqual({
      status: 'native_callback',
      url: 'mandarin-master://callback?code=native-code',
    });
    expect(signInWithOAuth).toHaveBeenCalledWith({
      provider: 'google',
      options: {
        redirectTo: 'mandarin-master://callback',
        skipBrowserRedirect: true,
      },
    });
  });
});

describe('Google OAuth callback', () => {
  it('exchanges a Google PKCE callback into a session', async () => {
    const exchangeCodeForSession = jest.fn().mockResolvedValue({
      data: { session: googleSession },
      error: null,
    });

    await expect(createAuthCodeExchanger()(
      exchangeCodeForSession,
      'http://localhost:8081/callback?code=google-code',
    )).resolves.toBe(googleSession);
    expect(exchangeCodeForSession).toHaveBeenCalledWith('google-code');
  });

  it('preserves an exchangeCodeForSession failure', async () => {
    const error = new Error('PKCE code verifier missing');

    await expect(createAuthCodeExchanger()(
      jest.fn().mockResolvedValue({
        data: { session: null },
        error,
      }),
      'http://localhost:8081/callback?code=bad-code',
    )).rejects.toBe(error);
  });

  it('prevents replaying the same callback code', async () => {
    const exchanger = createAuthCodeExchanger();
    const exchangeCodeForSession = jest.fn().mockResolvedValue({
      data: { session: googleSession },
      error: null,
    });
    const callbackUrl = 'http://localhost:8081/callback?code=single-use-code';

    await exchanger(exchangeCodeForSession, callbackUrl);
    await expect(exchanger(
      exchangeCodeForSession,
      callbackUrl,
    )).rejects.toBeInstanceOf(OAuthCallbackReplayError);
    expect(exchangeCodeForSession).toHaveBeenCalledTimes(1);
  });

  it('routes first-time and completed Google users by their real profile', () => {
    expect(getPostAuthDestination({
      onboarding_completed: false,
    } as Profile)).toBe(AUTH_ROUTES.onboarding);
    expect(getPostAuthDestination({
      onboarding_completed: true,
    } as Profile)).toBe(AUTH_ROUTES.home);
  });

  it('rejects invalid OAuth callbacks before any exchange', async () => {
    const exchangeCodeForSession = jest.fn();

    await expect(createAuthCodeExchanger()(
      exchangeCodeForSession,
      'http://localhost:8081/callback',
    )).rejects.toThrow('thiếu mã xác thực');
    expect(exchangeCodeForSession).not.toHaveBeenCalled();
  });

  it('never classifies an ordinary Google callback as recovery', () => {
    const url = 'http://localhost:8081/callback?code=google-code';

    expect(isOAuthCallback(url)).toBe(true);
    expect(isExplicitRecoveryCallback(url)).toBe(false);
    expect(isGoogleSession(googleSession)).toBe(true);
    expect(isGoogleSession(emailSession)).toBe(false);
    expect(classifyExchangedSession(googleSession, false)).toBe('google');
  });

  it('keeps PASSWORD_RECOVERY authoritative even for a Google-backed user', () => {
    expect(classifyExchangedSession(googleSession, true)).toBe('recovery');
    expect(classifyExchangedSession(emailSession, true)).toBe('recovery');
  });

  it('allows the auth guard to route after the Google profile is loaded', () => {
    expect(getAuthGuardRedirect({
      segments: ['(auth)', 'login'],
      hasSession: true,
      isInitialized: true,
      isLoading: false,
      isAuthTransitioning: false,
      isRecoverySession: false,
      profile: {
        onboarding_completed: true,
      } as Profile,
      profileStatus: 'ready',
    })).toBe(AUTH_ROUTES.home);
  });
});

describe('Google OAuth regression safety', () => {
  it('keeps PKCE password recovery routing separate from Google', async () => {
    const recoveryUrl = 'http://localhost:8081/callback?code=recovery-code&type=recovery';

    expect(isExplicitRecoveryCallback(recoveryUrl)).toBe(true);
    await expect(completeRecoveryCallback({
      exchangeCodeForSession: jest.fn().mockResolvedValue({
        data: { session: emailSession },
        error: null,
      }),
      setSession: jest.fn(),
      verifyOtp: jest.fn(),
      getSession: jest.fn(),
    }, recoveryUrl)).resolves.toBe(emailSession);
  });

  it('still clears the local session after a Google logout succeeds', async () => {
    const clearLocalSession = jest.fn();

    await signOutSession({
      signOut: jest.fn().mockResolvedValue({ error: null }),
      clearLocalSession,
    });
    expect(clearLocalSession).toHaveBeenCalledTimes(1);
  });
});
