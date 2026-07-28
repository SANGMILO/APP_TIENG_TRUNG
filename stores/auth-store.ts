import { create } from 'zustand';
import { Session, User } from '@supabase/supabase-js';
import { supabase } from '@/lib/supabase';
import { Profile } from '@/types';
import { signOutSession } from '@/services/auth-flow';
import type { ProfileStatus } from '@/services/auth-navigation';
import { createProfileLoader } from '@/services/profile-service';

export type EditableProfileUpdate = Partial<Pick<
  Profile,
  | 'username'
  | 'display_name'
  | 'avatar_url'
  | 'native_language'
  | 'timezone'
  | 'chinese_level'
  | 'daily_goal_minutes'
  | 'daily_goal_xp'
  | 'learning_purpose'
  | 'onboarding_completed'
>>;

interface AuthState {
  session: Session | null;
  user: User | null;
  profile: Profile | null;
  profileStatus: ProfileStatus;
  profileError: string | null;
  isLoading: boolean;
  isInitialized: boolean;
  initializationError: string | null;
  isAuthTransitioning: boolean;
  isRecoverySession: boolean;

  // Actions
  initialize: () => Promise<void>;
  setSession: (session: Session | null) => void;
  setProfile: (profile: Profile | null) => void;
  fetchProfile: (userId?: string) => Promise<Profile | null>;
  clearLocalSession: () => void;
  beginAuthTransition: () => void;
  endAuthTransition: () => void;
  setRecoverySession: (isRecoverySession: boolean) => void;
  signOut: () => Promise<void>;
  updateProfile: (updates: EditableProfileUpdate) => Promise<void>;
}

let authSubscription: { unsubscribe: () => void } | null = null;
let initializationPromise: Promise<void> | null = null;

const loadAuthenticatedProfile = createProfileLoader({
  queryProfile: async (userId) => {
    const { data, error } = await supabase
      .from('profiles')
      .select('*')
      .eq('id', userId)
      .maybeSingle();

    return {
      data: data as Profile | null,
      error,
    };
  },
  ensureCurrentUserProfile: async () => {
    const { error } = await supabase.rpc('ensure_current_user_profile');
    return { error };
  },
});

function getErrorMessage(error: unknown): string {
  if (error instanceof Error) {
    return error.message;
  }

  if (typeof error === 'object' && error && 'message' in error) {
    return String(error.message);
  }

  return 'Không thể khởi tạo phiên đăng nhập. Vui lòng thử lại.';
}

export const useAuthStore = create<AuthState>((set, get) => ({
  session: null,
  user: null,
  profile: null,
  profileStatus: 'idle',
  profileError: null,
  isLoading: true,
  isInitialized: false,
  initializationError: null,
  isAuthTransitioning: false,
  isRecoverySession: false,

  initialize: async () => {
    if (initializationPromise) {
      return initializationPromise;
    }

    const run = (async () => {
      set({
        isLoading: true,
        initializationError: null,
      });

      authSubscription?.unsubscribe();
      const { data: listener } = supabase.auth.onAuthStateChange((event, session) => {
        if (event === 'SIGNED_OUT' || !session) {
          set({
            session: null,
            user: null,
            profile: null,
            profileStatus: 'idle',
            profileError: null,
            isRecoverySession: false,
          });
          return;
        }

        const currentUserId = get().user?.id;
        set({
          session,
          user: session.user,
          isRecoverySession: event === 'PASSWORD_RECOVERY'
            ? true
            : get().isRecoverySession,
        });

        const shouldRefreshProfile = (
          event === 'SIGNED_IN'
          || event === 'PASSWORD_RECOVERY'
          || event === 'USER_UPDATED'
        ) && (
          currentUserId !== session.user.id
          || get().profileStatus === 'idle'
        ) && !get().isAuthTransitioning;

        if (shouldRefreshProfile) {
          void get().fetchProfile(session.user.id);
        }
      });
      authSubscription = listener.subscription;

      try {
        const { data: { session }, error } = await supabase.auth.getSession();
        if (error) {
          throw error;
        }

        set({
          session,
          user: session?.user ?? null,
          profile: session ? get().profile : null,
          profileStatus: session ? 'loading' : 'idle',
        });

        if (session?.user) {
          const profile = await get().fetchProfile(session.user.id);
          if (!profile) {
            throw new Error(
              get().profileError
                ?? 'Không thể tải hồ sơ người dùng. Vui lòng thử lại.',
            );
          }
        }
      } catch (error) {
        set({ initializationError: getErrorMessage(error) });
      } finally {
        set({ isLoading: false, isInitialized: true });
      }
    })();

    initializationPromise = run;
    try {
      await run;
    } finally {
      if (initializationPromise === run) {
        initializationPromise = null;
      }
    }
  },

  setSession: (session) => {
    set({ session, user: session?.user ?? null });
  },

  setProfile: (profile) => {
    set({
      profile,
      profileStatus: profile ? 'ready' : 'idle',
      profileError: null,
    });
  },

  fetchProfile: async (userId) => {
    const resolvedUserId = userId ?? get().user?.id;
    if (!resolvedUserId) {
      set({
        profile: null,
        profileStatus: 'idle',
        profileError: null,
      });
      return null;
    }

    set({
      profileStatus: 'loading',
      profileError: null,
    });

    try {
      const profile = await loadAuthenticatedProfile(resolvedUserId);
      set({
        profile,
        profileStatus: 'ready',
        profileError: null,
        initializationError: null,
      });
      return profile;
    } catch (error) {
      set({
        profile: null,
        profileStatus: 'error',
        profileError: getErrorMessage(error),
      });
      return null;
    }
  },

  clearLocalSession: () => {
    set({
      session: null,
      user: null,
      profile: null,
      profileStatus: 'idle',
      profileError: null,
      isRecoverySession: false,
    });
  },

  beginAuthTransition: () => {
    set({ isAuthTransitioning: true });
  },

  endAuthTransition: () => {
    set({ isAuthTransitioning: false });
  },

  setRecoverySession: (isRecoverySession) => {
    set({ isRecoverySession });
  },

  signOut: async () => {
    await signOutSession({
      signOut: () => supabase.auth.signOut(),
      clearLocalSession: get().clearLocalSession,
    });
  },

  updateProfile: async (updates) => {
    const { user, profile } = get();
    if (!user) return;

    const { data, error } = await supabase
      .from('profiles')
      .update(updates)
      .eq('id', user.id)
      .select()
      .single();

    if (error) {
      throw error;
    }

    set({ profile: { ...profile, ...data } as Profile });
  },
}));
