import type { Profile } from '@/types';
import type { Session } from '@supabase/supabase-js';
import { getPostAuthDestination, type AuthDestination } from './auth-navigation';

interface AuthErrorLike {
  message: string;
}

interface AuthResult {
  data: {
    session: Session | null;
  };
  error: AuthErrorLike | null;
}

interface LoginDependencies {
  signInWithPassword: (credentials: {
    email: string;
    password: string;
  }) => Promise<AuthResult>;
  completeSession: (session: Session) => Promise<Profile | null>;
}

interface RegisterDependencies {
  signUp: (credentials: {
    email: string;
    password: string;
    options: {
      data: {
        display_name: string;
      };
    };
  }) => Promise<AuthResult>;
  completeSession: (session: Session) => Promise<Profile | null>;
}

interface SignOutDependencies {
  signOut: () => Promise<{ error: AuthErrorLike | null }>;
  clearLocalSession: () => void;
}

interface ForgotPasswordDependencies {
  resetPasswordForEmail: (
    email: string,
    options: { redirectTo: string },
  ) => Promise<{ error: AuthErrorLike | null }>;
}

interface ResetPasswordDependencies {
  updateUser: (
    attributes: { password: string },
  ) => Promise<{ error: AuthErrorLike | null }>;
}

export class AuthFlowError extends Error {
  constructor(message: string) {
    super(message);
    this.name = 'AuthFlowError';
  }
}

export class MissingRecoverySessionError extends AuthFlowError {
  constructor() {
    super('Liên kết đặt lại mật khẩu không hợp lệ hoặc đã hết hạn.');
    this.name = 'MissingRecoverySessionError';
  }
}

function requireProfile(profile: Profile | null): Profile {
  if (!profile) {
    throw new AuthFlowError('Không thể tải hồ sơ. Vui lòng thử lại.');
  }

  return profile;
}

export async function loginWithPassword(
  dependencies: LoginDependencies,
  credentials: { email: string; password: string },
): Promise<{ destination: AuthDestination }> {
  const { data, error } = await dependencies.signInWithPassword(credentials);

  if (error) {
    throw error;
  }

  if (!data.session) {
    throw new AuthFlowError('Đăng nhập không tạo được phiên hợp lệ.');
  }

  const profile = requireProfile(
    await dependencies.completeSession(data.session),
  );

  return { destination: getPostAuthDestination(profile) };
}

export type RegistrationResult =
  | {
      status: 'authenticated';
      destination: AuthDestination;
    }
  | {
      status: 'confirmation_required';
      email: string;
    };

export async function registerWithPassword(
  dependencies: RegisterDependencies,
  input: { email: string; password: string; displayName: string },
): Promise<RegistrationResult> {
  const { data, error } = await dependencies.signUp({
    email: input.email,
    password: input.password,
    options: {
      data: {
        display_name: input.displayName,
      },
    },
  });

  if (error) {
    throw error;
  }

  if (!data.session) {
    return {
      status: 'confirmation_required',
      email: input.email,
    };
  }

  const profile = requireProfile(
    await dependencies.completeSession(data.session),
  );

  return {
    status: 'authenticated',
    destination: getPostAuthDestination(profile),
  };
}

export async function signOutSession(
  dependencies: SignOutDependencies,
): Promise<void> {
  const { error } = await dependencies.signOut();

  if (error) {
    throw error;
  }

  dependencies.clearLocalSession();
}

export async function requestPasswordReset(
  dependencies: ForgotPasswordDependencies,
  email: string,
  redirectTo: string,
): Promise<void> {
  const { error } = await dependencies.resetPasswordForEmail(email, {
    redirectTo,
  });

  if (error) {
    throw error;
  }
}

export async function updateRecoveryPassword(
  dependencies: ResetPasswordDependencies,
  password: string,
  hasRecoverySession: boolean,
): Promise<void> {
  if (!hasRecoverySession) {
    throw new MissingRecoverySessionError();
  }

  const { error } = await dependencies.updateUser({ password });

  if (error) {
    throw error;
  }
}
