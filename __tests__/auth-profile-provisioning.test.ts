import type { Profile } from '../types';
import { createProfileLoader, ProfileLoadError } from '../services/profile-service';
import { getPostAuthDestination, AUTH_ROUTES } from '../services/auth-navigation';

declare const require: (moduleName: string) => any;
declare const __dirname: string;

const fs = require('fs');
const path = require('path');

const migrationPath = path.join(
  __dirname,
  '..',
  'supabase',
  'migrations',
  '20260729000000_fix_auth_profile_provisioning.sql',
);
const migration = fs.readFileSync(migrationPath, 'utf8');
const authStore = fs.readFileSync(path.join(
  __dirname,
  '..',
  'stores',
  'auth-store.ts',
), 'utf8');

const profile = {
  id: 'user-1',
  email: 'learner@example.com',
  onboarding_completed: false,
} as Profile;

describe('provider-agnostic profile provisioning migration', () => {
  it('recreates an auth.users AFTER INSERT trigger using a safe definer function', () => {
    expect(migration).toMatch(
      /CREATE OR REPLACE FUNCTION public\.handle_new_user\(\)[\s\S]*SECURITY DEFINER SET search_path = '';/,
    );
    expect(migration).toMatch(
      /CREATE TRIGGER on_auth_user_created\s+AFTER INSERT ON auth\.users[\s\S]*EXECUTE FUNCTION public\.handle_new_user\(\);/,
    );
  });

  it('initializes Google and future OAuth-safe metadata without protected columns', () => {
    expect(migration).toContain("NEW.raw_user_meta_data ->> 'full_name'");
    expect(migration).toContain("NEW.raw_user_meta_data ->> 'name'");
    expect(migration).toContain("NEW.raw_user_meta_data ->> 'avatar_url'");
    expect(migration).toContain("NEW.raw_user_meta_data ->> 'picture'");

    const triggerInsertColumns = migration.match(
      /INSERT INTO public\.profiles \(\s*([\s\S]*?)\s*\)\s*VALUES \(/,
    );
    expect(triggerInsertColumns).not.toBeNull();
    const columns = triggerInsertColumns![1]
      .split(',')
      .map((column: string) => column.trim());

    expect(columns).toEqual(['id', 'email', 'display_name', 'avatar_url']);
    expect(columns).not.toEqual(expect.arrayContaining([
      'role',
      'total_xp',
      'total_coins',
      'current_level',
      'current_streak',
      'hearts',
    ]));
  });

  it('never overwrites an existing customized profile', () => {
    expect(migration.match(/ON CONFLICT \(id\) DO NOTHING;/g)?.length).toBeGreaterThanOrEqual(3);
    expect(migration).not.toMatch(/ON CONFLICT \(id\)\s+DO UPDATE/);
  });

  it('backfills existing orphaned auth users and their missing streak rows', () => {
    expect(migration).toMatch(
      /FROM auth\.users AS u\s+WHERE NOT EXISTS \(\s*SELECT 1\s+FROM public\.profiles AS p\s+WHERE p\.id = u\.id/,
    );
    expect(migration).toMatch(
      /INSERT INTO public\.streaks \(user_id\)\s+SELECT p\.id\s+FROM public\.profiles AS p\s+WHERE NOT EXISTS/,
    );
  });

  it('exposes only a caller-derived, no-argument ensure RPC', () => {
    expect(migration).toContain(
      'CREATE OR REPLACE FUNCTION public.ensure_current_user_profile()',
    );
    expect(migration).toContain('v_user_id UUID := auth.uid();');
    expect(migration).toMatch(/FROM auth\.users\s+WHERE id = v_user_id;/);
    expect(migration).not.toContain('p_user_id');
    expect(migration).toMatch(
      /REVOKE ALL ON FUNCTION public\.ensure_current_user_profile\(\)\s+FROM PUBLIC, anon, authenticated;/,
    );
    expect(migration).toMatch(
      /GRANT EXECUTE ON FUNCTION public\.ensure_current_user_profile\(\)\s+TO authenticated;/,
    );
  });

  it('keeps the client on maybeSingle and a no-argument ensure RPC', () => {
    expect(authStore).toContain('.maybeSingle()');
    expect(authStore).toContain("supabase.rpc('ensure_current_user_profile')");
    expect(authStore).not.toContain("supabase.rpc('ensure_current_user_profile',");
  });
});

describe('bounded client profile recovery', () => {
  it('returns an existing profile without calling the ensure RPC', async () => {
    const queryProfile = jest.fn().mockResolvedValue({
      data: profile,
      error: null,
    });
    const ensureCurrentUserProfile = jest.fn();

    await expect(createProfileLoader({
      queryProfile,
      ensureCurrentUserProfile,
    })('user-1')).resolves.toBe(profile);
    expect(queryProfile).toHaveBeenCalledTimes(1);
    expect(ensureCurrentUserProfile).not.toHaveBeenCalled();
  });

  it('handles zero rows by ensuring once and refetching without PGRST116', async () => {
    const queryProfile = jest.fn()
      .mockResolvedValueOnce({ data: null, error: null })
      .mockResolvedValueOnce({ data: profile, error: null });
    const ensureCurrentUserProfile = jest.fn().mockResolvedValue({ error: null });

    await expect(createProfileLoader({
      queryProfile,
      ensureCurrentUserProfile,
    })('user-1')).resolves.toBe(profile);
    expect(queryProfile).toHaveBeenCalledTimes(2);
    expect(ensureCurrentUserProfile).toHaveBeenCalledTimes(1);
  });

  it('shares concurrent loads and calls the ensure RPC at most once', async () => {
    let resolveFirstQuery: ((value: {
      data: Profile | null;
      error: null;
    }) => void) | undefined;
    const firstQuery = new Promise<{
      data: Profile | null;
      error: null;
    }>((resolve) => {
      resolveFirstQuery = resolve;
    });
    const queryProfile = jest.fn()
      .mockReturnValueOnce(firstQuery)
      .mockResolvedValueOnce({ data: profile, error: null });
    const ensureCurrentUserProfile = jest.fn().mockResolvedValue({ error: null });
    const loadProfile = createProfileLoader({
      queryProfile,
      ensureCurrentUserProfile,
    });

    const first = loadProfile('user-1');
    const second = loadProfile('user-1');
    resolveFirstQuery?.({ data: null, error: null });

    await expect(Promise.all([first, second])).resolves.toEqual([profile, profile]);
    expect(ensureCurrentUserProfile).toHaveBeenCalledTimes(1);
    expect(queryProfile).toHaveBeenCalledTimes(2);
  });

  it('surfaces an ensure failure as a recoverable profile error', async () => {
    const loadProfile = createProfileLoader({
      queryProfile: jest.fn().mockResolvedValue({ data: null, error: null }),
      ensureCurrentUserProfile: jest.fn().mockResolvedValue({
        error: {
          code: '42501',
          message: 'Authentication required',
        },
      }),
    });

    await expect(loadProfile('user-1')).rejects.toEqual(expect.objectContaining({
      name: 'ProfileLoadError',
      code: '42501',
      message: 'Authentication required',
    }));
  });

  it('does not silently accept a profile that remains missing after ensure', async () => {
    const loadProfile = createProfileLoader({
      queryProfile: jest.fn().mockResolvedValue({ data: null, error: null }),
      ensureCurrentUserProfile: jest.fn().mockResolvedValue({ error: null }),
    });

    await expect(loadProfile('user-1')).rejects.toBeInstanceOf(ProfileLoadError);
  });

  it('routes a provisioned first-time Google profile to onboarding', () => {
    expect(getPostAuthDestination({
      ...profile,
      onboarding_completed: false,
    })).toBe(AUTH_ROUTES.onboarding);
  });

  it('routes a returning profile to the authenticated tabs', () => {
    expect(getPostAuthDestination({
      ...profile,
      onboarding_completed: true,
    })).toBe(AUTH_ROUTES.home);
  });
});
