import type { Session } from '@supabase/supabase-js';
import { APP_SCHEME, RECOVERY_CALLBACK_PATH } from './auth-recovery';

interface AuthErrorLike {
  message: string;
}

interface OAuthStartResult {
  data: {
    url: string | null;
  };
  error: AuthErrorLike | null;
}

interface SessionResult {
  data: {
    session: Session | null;
  };
  error: AuthErrorLike | null;
}

interface GoogleOAuthDependencies {
  signInWithOAuth: (params: {
    provider: 'google';
    options: {
      redirectTo: string;
      skipBrowserRedirect?: boolean;
    };
  }) => Promise<OAuthStartResult>;
  openAuthSession: (
    authUrl: string,
    redirectTo: string,
  ) => Promise<{
    type: string;
    url?: string;
  }>;
}

export type GoogleOAuthStartResult =
  | { status: 'redirecting' }
  | { status: 'cancelled' }
  | { status: 'duplicate' }
  | { status: 'native_callback'; url: string };

export class GoogleOAuthError extends Error {
  constructor(message: string) {
    super(message);
    this.name = 'GoogleOAuthError';
  }
}

export class OAuthCallbackReplayError extends GoogleOAuthError {
  constructor() {
    super('Liên kết đăng nhập này đã được xử lý. Vui lòng đăng nhập lại.');
    this.name = 'OAuthCallbackReplayError';
  }
}

function trimTrailingSlash(value: string): string {
  return value.replace(/\/+$/, '');
}

function parseCallbackParameters(url: string): URLSearchParams {
  const parsed = new URL(url);
  const parameters = new URLSearchParams(parsed.search);
  const hash = parsed.hash.startsWith('#') ? parsed.hash.slice(1) : parsed.hash;

  new URLSearchParams(hash).forEach((value, key) => {
    if (!parameters.has(key)) {
      parameters.set(key, value);
    }
  });

  return parameters;
}

function getProviderError(parameters: URLSearchParams): string | null {
  const error = parameters.get('error_description') ?? parameters.get('error');
  if (!error) {
    return null;
  }

  try {
    return decodeURIComponent(error.replace(/\+/g, ' '));
  } catch {
    return error;
  }
}

export function getGoogleOAuthRedirectUrl(
  platform: 'web' | 'ios' | 'android',
  webOrigin?: string,
): string {
  if (platform === 'web') {
    const origin = webOrigin
      ?? (typeof window !== 'undefined' ? window.location.origin : 'http://localhost:8081');
    return `${trimTrailingSlash(origin)}${RECOVERY_CALLBACK_PATH}`;
  }

  return `${APP_SCHEME}://callback`;
}

export function hasAuthCode(url: string): boolean {
  try {
    return Boolean(parseCallbackParameters(url).get('code'));
  } catch {
    return false;
  }
}

export function isOAuthCallback(url: string): boolean {
  try {
    const parameters = parseCallbackParameters(url);
    return Boolean(
      parameters.get('code')
      || parameters.get('error')
      || parameters.get('error_description'),
    );
  } catch {
    return false;
  }
}

export function isExplicitRecoveryCallback(url: string): boolean {
  try {
    const parameters = parseCallbackParameters(url);
    return parameters.get('type') === 'recovery'
      || Boolean(parameters.get('token_hash'))
      || Boolean(parameters.get('access_token'))
      || Boolean(parameters.get('refresh_token'));
  } catch {
    return false;
  }
}

export function isGoogleSession(session: Session): boolean {
  const appMetadata = session.user.app_metadata;
  const providers = Array.isArray(appMetadata.providers)
    ? appMetadata.providers
    : [];

  return appMetadata.provider === 'google'
    || providers.includes('google')
    || (session.user.identities ?? []).some((identity) => identity.provider === 'google');
}

export function classifyExchangedSession(
  session: Session,
  recoveryDetected: boolean,
): 'google' | 'recovery' | 'invalid' {
  if (recoveryDetected) {
    return 'recovery';
  }

  return isGoogleSession(session) ? 'google' : 'invalid';
}

export function createGoogleOAuthStarter() {
  let isStarting = false;

  return async function startGoogleOAuth(
    dependencies: GoogleOAuthDependencies,
    input: {
      platform: 'web' | 'ios' | 'android';
      redirectTo: string;
    },
  ): Promise<GoogleOAuthStartResult> {
    if (isStarting) {
      return { status: 'duplicate' };
    }

    isStarting = true;

    try {
      const isWeb = input.platform === 'web';
      const { data, error } = await dependencies.signInWithOAuth({
        provider: 'google',
        options: {
          redirectTo: input.redirectTo,
          ...(!isWeb ? { skipBrowserRedirect: true } : {}),
        },
      });

      if (error) {
        throw error;
      }

      if (!data.url) {
        throw new GoogleOAuthError('Không nhận được địa chỉ đăng nhập Google.');
      }

      if (isWeb) {
        return { status: 'redirecting' };
      }

      const browserResult = await dependencies.openAuthSession(
        data.url,
        input.redirectTo,
      );

      if (browserResult.type === 'cancel' || browserResult.type === 'dismiss') {
        return { status: 'cancelled' };
      }

      if (browserResult.type !== 'success' || !browserResult.url) {
        throw new GoogleOAuthError('Không thể hoàn tất đăng nhập Google.');
      }

      return {
        status: 'native_callback',
        url: browserResult.url,
      };
    } finally {
      isStarting = false;
    }
  };
}

export function createAuthCodeExchanger() {
  const attemptedCodes = new Set<string>();

  return async function exchangeAuthCode(
    exchangeCodeForSession: (code: string) => Promise<SessionResult>,
    url: string,
  ): Promise<Session> {
    let parameters: URLSearchParams;

    try {
      parameters = parseCallbackParameters(url);
    } catch {
      throw new GoogleOAuthError('Không thể đọc phản hồi đăng nhập.');
    }

    const providerError = getProviderError(parameters);
    if (providerError) {
      throw new GoogleOAuthError(providerError);
    }

    const code = parameters.get('code');
    if (!code) {
      throw new GoogleOAuthError('Phản hồi đăng nhập thiếu mã xác thực.');
    }

    if (attemptedCodes.has(code)) {
      throw new OAuthCallbackReplayError();
    }
    attemptedCodes.add(code);

    const { data, error } = await exchangeCodeForSession(code);
    if (error) {
      throw error;
    }

    if (!data.session) {
      throw new GoogleOAuthError('Đăng nhập Google không tạo được phiên hợp lệ.');
    }

    return data.session;
  };
}

export const startGoogleOAuth = createGoogleOAuthStarter();
export const exchangeAuthCodeOnce = createAuthCodeExchanger();
