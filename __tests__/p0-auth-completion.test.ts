import type { Session } from '@supabase/supabase-js';
import type { Profile } from '../types';
import {
  AUTH_ROUTES,
  getAuthGuardRedirect,
} from '../services/auth-navigation';
import {
  loginWithPassword,
  registerWithPassword,
  requestPasswordReset,
  signOutSession,
  updateRecoveryPassword,
  MissingRecoverySessionError,
} from '../services/auth-flow';
import {
  completeRecoveryCallback,
  getRecoveryRedirectUrl,
} from '../services/auth-recovery';
import { isBootstrapReady } from '../services/bootstrap';

const session = {
  user: { id: 'user-1' },
} as Session;

const profile = {
  id: 'user-1',
  onboarding_completed: true,
} as Profile;

const incompleteProfile = {
  ...profile,
  onboarding_completed: false,
};

const successfulAuthResult = {
  data: { session },
  error: null,
};

const noSessionAuthResult = {
  data: { session: null },
  error: null,
};

describe('P0-B route guard', () => {
  const baseState = {
    hasSession: false,
    isInitialized: true,
    isLoading: false,
    isAuthTransitioning: false,
    isRecoverySession: false,
    profile: null,
    profileStatus: 'idle' as const,
  };

  it('redirects an unauthenticated protected route', () => {
    expect(getAuthGuardRedirect({
      ...baseState,
      segments: ['(tabs)', 'learn'],
    })).toBe(AUTH_ROUTES.welcome);
  });

  it('redirects an authenticated user away from Login', () => {
    expect(getAuthGuardRedirect({
      ...baseState,
      segments: ['(auth)', 'login'],
      hasSession: true,
      profile,
      profileStatus: 'ready',
    })).toBe(AUTH_ROUTES.home);
  });

  it('sends an incomplete authenticated profile to onboarding', () => {
    expect(getAuthGuardRedirect({
      ...baseState,
      segments: ['(auth)', 'welcome'],
      hasSession: true,
      profile: incompleteProfile,
      profileStatus: 'ready',
    })).toBe(AUTH_ROUTES.onboarding);
  });

  it('does not redirect while auth is initializing', () => {
    expect(getAuthGuardRedirect({
      ...baseState,
      segments: ['(tabs)', 'learn'],
      isInitialized: false,
      isLoading: true,
    })).toBeNull();
  });

  it('prevents loops on the correct destination and during explicit transitions', () => {
    expect(getAuthGuardRedirect({
      ...baseState,
      segments: ['(tabs)', 'learn'],
      hasSession: true,
      profile,
      profileStatus: 'ready',
    })).toBeNull();

    expect(getAuthGuardRedirect({
      ...baseState,
      segments: ['(auth)', 'login'],
      hasSession: true,
      profile,
      profileStatus: 'ready',
      isAuthTransitioning: true,
    })).toBeNull();
  });
});

describe('P0-B email auth flows', () => {
  it('navigates successful Login from the loaded profile', async () => {
    const signInWithPassword = jest.fn().mockResolvedValue(successfulAuthResult);
    const completeSession = jest.fn().mockResolvedValue(incompleteProfile);

    await expect(loginWithPassword({
      signInWithPassword,
      completeSession,
    }, {
      email: 'learner@example.com',
      password: 'password',
    })).resolves.toEqual({ destination: AUTH_ROUTES.onboarding });
    expect(completeSession).toHaveBeenCalledWith(session);
  });

  it('preserves a Login error and does not complete a session', async () => {
    const error = new Error('Invalid login credentials');
    const completeSession = jest.fn();

    await expect(loginWithPassword({
      signInWithPassword: jest.fn().mockResolvedValue({
        data: { session: null },
        error,
      }),
      completeSession,
    }, {
      email: 'learner@example.com',
      password: 'wrong-password',
    })).rejects.toBe(error);
    expect(completeSession).not.toHaveBeenCalled();
  });

  it('handles Registration with an immediate session', async () => {
    await expect(registerWithPassword({
      signUp: jest.fn().mockResolvedValue(successfulAuthResult),
      completeSession: jest.fn().mockResolvedValue(incompleteProfile),
    }, {
      email: 'new@example.com',
      password: 'password',
      displayName: 'New Learner',
    })).resolves.toEqual({
      status: 'authenticated',
      destination: AUTH_ROUTES.onboarding,
    });
  });

  it('handles Registration requiring email confirmation', async () => {
    const completeSession = jest.fn();

    await expect(registerWithPassword({
      signUp: jest.fn().mockResolvedValue(noSessionAuthResult),
      completeSession,
    }, {
      email: 'confirm@example.com',
      password: 'password',
      displayName: 'Confirm Me',
    })).resolves.toEqual({
      status: 'confirmation_required',
      email: 'confirm@example.com',
    });
    expect(completeSession).not.toHaveBeenCalled();
  });

  it('clears local auth only after Logout succeeds', async () => {
    const clearLocalSession = jest.fn();

    await signOutSession({
      signOut: jest.fn().mockResolvedValue({ error: null }),
      clearLocalSession,
    });
    expect(clearLocalSession).toHaveBeenCalledTimes(1);
  });

  it('keeps local auth when Logout fails', async () => {
    const error = new Error('Network unavailable');
    const clearLocalSession = jest.fn();

    await expect(signOutSession({
      signOut: jest.fn().mockResolvedValue({ error }),
      clearLocalSession,
    })).rejects.toBe(error);
    expect(clearLocalSession).not.toHaveBeenCalled();
  });

  it('sends Forgot Password with the platform redirect URL', async () => {
    const resetPasswordForEmail = jest.fn().mockResolvedValue({ error: null });
    const redirectTo = getRecoveryRedirectUrl('web', 'http://localhost:8081');

    await requestPasswordReset(
      { resetPasswordForEmail },
      'learner@example.com',
      redirectTo,
    );
    expect(resetPasswordForEmail).toHaveBeenCalledWith(
      'learner@example.com',
      { redirectTo: 'http://localhost:8081/callback' },
    );
    expect(getRecoveryRedirectUrl('ios')).toBe('mandarin-master://callback');
    expect(getRecoveryRedirectUrl('android')).toBe('mandarin-master://callback');
  });

  it('does not report Forgot Password success when Supabase fails', async () => {
    const error = new Error('Rate limit exceeded');

    await expect(requestPasswordReset({
      resetPasswordForEmail: jest.fn().mockResolvedValue({ error }),
    }, 'learner@example.com', 'mandarin-master://callback')).rejects.toBe(error);
  });
});

describe('P0-B recovery and reset', () => {
  let exchangeCodeForSession: jest.Mock;
  let setSession: jest.Mock;
  let verifyOtp: jest.Mock;
  let getSession: jest.Mock;

  beforeEach(() => {
    exchangeCodeForSession = jest.fn().mockResolvedValue(successfulAuthResult);
    setSession = jest.fn().mockResolvedValue(successfulAuthResult);
    verifyOtp = jest.fn().mockResolvedValue(successfulAuthResult);
    getSession = jest.fn().mockResolvedValue(successfulAuthResult);
  });

  const recoveryDependencies = () => ({
    exchangeCodeForSession,
    setSession,
    verifyOtp,
    getSession,
  });

  it('exchanges a recovery callback PKCE code', async () => {
    await expect(completeRecoveryCallback(
      recoveryDependencies(),
      'mandarin-master://callback?code=recovery-code&type=recovery',
    )).resolves.toBe(session);
    expect(exchangeCodeForSession).toHaveBeenCalledWith('recovery-code');
  });

  it('establishes a recovery session from access and refresh tokens', async () => {
    await expect(completeRecoveryCallback(
      recoveryDependencies(),
      'mandarin-master://callback#access_token=access&refresh_token=refresh&type=recovery',
    )).resolves.toBe(session);
    expect(setSession).toHaveBeenCalledWith({
      access_token: 'access',
      refresh_token: 'refresh',
    });
  });

  it('verifies a recovery token hash', async () => {
    await expect(completeRecoveryCallback(
      recoveryDependencies(),
      'mandarin-master://callback?token_hash=hashed-token&type=recovery',
    )).resolves.toBe(session);
    expect(verifyOtp).toHaveBeenCalledWith({
      token_hash: 'hashed-token',
      type: 'recovery',
    });
  });

  it('accepts an existing session only after PASSWORD_RECOVERY was observed', async () => {
    await expect(completeRecoveryCallback(
      recoveryDependencies(),
      'http://localhost:8081/callback',
      { hasRecoverySession: true },
    )).resolves.toBe(session);
    expect(getSession).toHaveBeenCalledTimes(1);
  });

  it('rejects parameterless callbacks for normal authenticated sessions', async () => {
    await expect(completeRecoveryCallback(
      recoveryDependencies(),
      'http://localhost:8081/callback',
    )).rejects.toThrow('không hợp lệ hoặc đã hết hạn');
    expect(getSession).not.toHaveBeenCalled();
  });

  it('rejects incomplete implicit-token callbacks without creating a session', async () => {
    await expect(completeRecoveryCallback(
      recoveryDependencies(),
      'mandarin-master://callback#access_token=access&type=recovery',
    )).rejects.toThrow('thiếu thông tin phiên');
    expect(setSession).not.toHaveBeenCalled();
    expect(getSession).not.toHaveBeenCalled();
  });

  it('updates the password only with a recovery session', async () => {
    const updateUser = jest.fn().mockResolvedValue({ error: null });

    await updateRecoveryPassword({ updateUser }, 'new-password', true);
    expect(updateUser).toHaveBeenCalledWith({ password: 'new-password' });
  });

  it('preserves a Reset Password Supabase failure', async () => {
    const error = new Error('Recovery session expired');

    await expect(updateRecoveryPassword({
      updateUser: jest.fn().mockResolvedValue({ error }),
    }, 'new-password', true)).rejects.toBe(error);
  });

  it('rejects a missing or expired recovery session before calling Supabase', async () => {
    const updateUser = jest.fn();

    await expect(updateRecoveryPassword(
      { updateUser },
      'new-password',
      false,
    )).rejects.toBeInstanceOf(MissingRecoverySessionError);
    expect(updateUser).not.toHaveBeenCalled();
  });
});

describe('P0-B bootstrap fallback', () => {
  it('continues with fallback fonts after a font error or timeout', () => {
    expect(isBootstrapReady({
      isAuthInitialized: true,
      fontsLoaded: false,
      fontError: new Error('Font download failed'),
      fontTimedOut: false,
    })).toBe(true);

    expect(isBootstrapReady({
      isAuthInitialized: true,
      fontsLoaded: false,
      fontError: null,
      fontTimedOut: true,
    })).toBe(true);
  });

  it('never treats unfinished auth initialization as ready', () => {
    expect(isBootstrapReady({
      isAuthInitialized: false,
      fontsLoaded: true,
      fontError: null,
      fontTimedOut: false,
    })).toBe(false);
  });
});
