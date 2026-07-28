import type { Session } from '@supabase/supabase-js';

export const APP_SCHEME = 'mandarin-master';
export const RECOVERY_CALLBACK_PATH = '/callback';

interface AuthErrorLike {
  message: string;
}

interface SessionResult {
  data: {
    session: Session | null;
  };
  error: AuthErrorLike | null;
}

interface RecoveryDependencies {
  exchangeCodeForSession: (code: string) => Promise<SessionResult>;
  setSession: (tokens: {
    access_token: string;
    refresh_token: string;
  }) => Promise<SessionResult>;
  verifyOtp: (params: {
    token_hash: string;
    type: 'recovery';
  }) => Promise<SessionResult>;
  getSession: () => Promise<SessionResult>;
}

export class RecoveryLinkError extends Error {
  constructor(message: string) {
    super(message);
    this.name = 'RecoveryLinkError';
  }
}

function trimTrailingSlash(value: string): string {
  return value.replace(/\/+$/, '');
}

export function getRecoveryRedirectUrl(
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

function parseRecoveryParameters(url: string): URLSearchParams {
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

function requireSession(result: SessionResult): Session {
  if (result.error) {
    throw result.error;
  }

  if (!result.data.session) {
    throw new RecoveryLinkError(
      'Liên kết đặt lại mật khẩu không hợp lệ hoặc đã hết hạn.',
    );
  }

  return result.data.session;
}

export async function completeRecoveryCallback(
  dependencies: RecoveryDependencies,
  url: string,
  context: { hasRecoverySession: boolean } = { hasRecoverySession: false },
): Promise<Session> {
  let parameters: URLSearchParams;

  try {
    parameters = parseRecoveryParameters(url);
  } catch {
    throw new RecoveryLinkError('Không thể đọc liên kết đặt lại mật khẩu.');
  }

  const providerError = parameters.get('error_description') ?? parameters.get('error');
  if (providerError) {
    throw new RecoveryLinkError(decodeURIComponent(providerError.replace(/\+/g, ' ')));
  }

  const type = parameters.get('type');
  if (type && type !== 'recovery') {
    throw new RecoveryLinkError('Liên kết này không phải liên kết đặt lại mật khẩu.');
  }

  const code = parameters.get('code');
  if (code) {
    return requireSession(await dependencies.exchangeCodeForSession(code));
  }

  const tokenHash = parameters.get('token_hash');
  if (tokenHash) {
    return requireSession(await dependencies.verifyOtp({
      token_hash: tokenHash,
      type: 'recovery',
    }));
  }

  const accessToken = parameters.get('access_token');
  const refreshToken = parameters.get('refresh_token');
  if (accessToken && refreshToken) {
    return requireSession(await dependencies.setSession({
      access_token: accessToken,
      refresh_token: refreshToken,
    }));
  }

  if (accessToken || refreshToken) {
    throw new RecoveryLinkError('Liên kết đặt lại mật khẩu thiếu thông tin phiên.');
  }

  if (!context.hasRecoverySession) {
    throw new RecoveryLinkError(
      'Liên kết đặt lại mật khẩu không hợp lệ hoặc đã hết hạn.',
    );
  }

  return requireSession(await dependencies.getSession());
}
