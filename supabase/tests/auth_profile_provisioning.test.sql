BEGIN;

SELECT plan(15);

SELECT ok(
  EXISTS (
    SELECT 1
    FROM pg_trigger AS t
    JOIN pg_class AS c ON c.oid = t.tgrelid
    JOIN pg_namespace AS n ON n.oid = c.relnamespace
    WHERE n.nspname = 'auth'
      AND c.relname = 'users'
      AND t.tgname = 'on_auth_user_created'
      AND NOT t.tgisinternal
  ),
  'auth.users profile provisioning trigger exists'
);

SELECT ok(
  (
    SELECT p.prosecdef
    FROM pg_proc AS p
    JOIN pg_namespace AS n ON n.oid = p.pronamespace
    WHERE n.nspname = 'public'
      AND p.proname = 'handle_new_user'
      AND p.pronargs = 0
  ),
  'handle_new_user is SECURITY DEFINER'
);

SELECT is(
  (
    SELECT p.pronargs::INTEGER
    FROM pg_proc AS p
    JOIN pg_namespace AS n ON n.oid = p.pronamespace
    WHERE n.nspname = 'public'
      AND p.proname = 'ensure_current_user_profile'
  ),
  0,
  'ensure_current_user_profile accepts no arbitrary user id'
);

SELECT ok(
  has_function_privilege(
    'authenticated',
    'public.ensure_current_user_profile()',
    'EXECUTE'
  ),
  'authenticated can call the caller-only ensure RPC'
);

SELECT ok(
  NOT has_function_privilege(
    'anon',
    'public.ensure_current_user_profile()',
    'EXECUTE'
  ),
  'anonymous users cannot call the ensure RPC'
);

INSERT INTO auth.users (
  id,
  aud,
  role,
  email,
  raw_app_meta_data,
  raw_user_meta_data,
  created_at,
  updated_at
)
VALUES (
  '10000000-0000-0000-0000-000000000001',
  'authenticated',
  'authenticated',
  'google-profile-test@example.invalid',
  '{"provider":"google","providers":["google"]}'::JSONB,
  '{"full_name":"Google Learner","picture":"https://example.invalid/avatar.png"}'::JSONB,
  NOW(),
  NOW()
);

SELECT ok(
  EXISTS (
    SELECT 1
    FROM public.profiles
    WHERE id = '10000000-0000-0000-0000-000000000001'
  ),
  'a new Google auth user receives a profile'
);

SELECT is(
  (
    SELECT display_name
    FROM public.profiles
    WHERE id = '10000000-0000-0000-0000-000000000001'
  ),
  'Google Learner',
  'safe Google display-name metadata is initialized'
);

INSERT INTO auth.users (
  id,
  aud,
  role,
  email,
  raw_app_meta_data,
  raw_user_meta_data,
  created_at,
  updated_at
)
VALUES (
  '10000000-0000-0000-0000-000000000002',
  'authenticated',
  'authenticated',
  'email-profile-test@example.invalid',
  '{"provider":"email","providers":["email"]}'::JSONB,
  '{"display_name":"Email Learner"}'::JSONB,
  NOW(),
  NOW()
);

SELECT ok(
  EXISTS (
    SELECT 1
    FROM public.profiles
    WHERE id = '10000000-0000-0000-0000-000000000002'
  ),
  'an email/password auth user still receives a profile'
);

UPDATE public.profiles
SET display_name = 'Customized Name'
WHERE id = '10000000-0000-0000-0000-000000000001';

SET LOCAL "request.jwt.claim.sub" = '10000000-0000-0000-0000-000000000001';
SELECT lives_ok(
  $$ SELECT public.ensure_current_user_profile() $$,
  'the ensure RPC is idempotent for an existing profile'
);

SELECT is(
  (
    SELECT display_name
    FROM public.profiles
    WHERE id = '10000000-0000-0000-0000-000000000001'
  ),
  'Customized Name',
  'the ensure RPC does not overwrite customized profile values'
);

DELETE FROM public.profiles
WHERE id = '10000000-0000-0000-0000-000000000002';

SELECT lives_ok(
  $$ SELECT public.ensure_current_user_profile() $$,
  'ensuring one caller does not attempt another user profile'
);

SELECT ok(
  NOT EXISTS (
    SELECT 1
    FROM public.profiles
    WHERE id = '10000000-0000-0000-0000-000000000002'
  ),
  'the ensure RPC cannot create another user profile'
);

SET LOCAL "request.jwt.claim.sub" = '10000000-0000-0000-0000-000000000002';
SELECT lives_ok(
  $$ SELECT public.ensure_current_user_profile() $$,
  'an orphaned current user can recover their own profile'
);

SELECT results_eq(
  $$
    SELECT role, total_xp, total_coins, current_level, current_streak, hearts
    FROM public.profiles
    WHERE id = '10000000-0000-0000-0000-000000000002'
  $$,
  $$
    VALUES ('student'::TEXT, 0::INTEGER, 0::INTEGER, 1::INTEGER, 0::INTEGER, 5::INTEGER)
  $$,
  'server-controlled profile fields retain safe defaults'
);

SELECT ok(
  NOT has_column_privilege('authenticated', 'public.profiles', 'role', 'UPDATE')
  AND NOT has_column_privilege('authenticated', 'public.profiles', 'total_xp', 'UPDATE')
  AND NOT has_column_privilege('authenticated', 'public.profiles', 'total_coins', 'UPDATE')
  AND NOT has_column_privilege('authenticated', 'public.profiles', 'current_level', 'UPDATE')
  AND NOT has_column_privilege('authenticated', 'public.profiles', 'hearts', 'UPDATE'),
  'P0-A protected profile columns remain client-inaccessible'
);

SELECT * FROM finish();

ROLLBACK;
