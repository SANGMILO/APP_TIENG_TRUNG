BEGIN;

SELECT plan(14);

SELECT ok(
  has_function_privilege(
    'authenticated',
    'public.request_account_deletion(text)',
    'EXECUTE'
  ),
  'authenticated users can request account deletion'
);

SELECT ok(
  NOT has_function_privilege(
    'anon',
    'public.request_account_deletion(text)',
    'EXECUTE'
  ),
  'anonymous users cannot request account deletion'
);

SELECT ok(
  has_table_privilege(
    'authenticated',
    'public.account_deletion_requests',
    'SELECT'
  ),
  'users can read their own deletion request status'
);

SELECT ok(
  NOT has_table_privilege(
    'authenticated',
    'public.account_deletion_requests',
    'INSERT'
  )
  AND NOT has_table_privilege(
    'authenticated',
    'public.account_deletion_requests',
    'UPDATE'
  )
  AND NOT has_table_privilege(
    'authenticated',
    'public.account_deletion_requests',
    'DELETE'
  ),
  'clients cannot forge or process deletion requests directly'
);

SELECT throws_ok(
  $$ SELECT public.request_account_deletion('XÓA TÀI KHOẢN') $$,
  '42501',
  'Authentication required',
  'deletion requests require auth.uid()'
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
  '25000000-0000-0000-0000-000000000001',
  'authenticated',
  'authenticated',
  'account-deletion-test@example.invalid',
  '{"provider":"email","providers":["email"]}'::JSONB,
  '{"display_name":"Deletion Test"}'::JSONB,
  NOW(),
  NOW()
);

SET LOCAL "request.jwt.claim.sub" = '25000000-0000-0000-0000-000000000001';

SELECT throws_ok(
  $$ SELECT public.request_account_deletion('delete') $$,
  '22023',
  'Account deletion confirmation is invalid',
  'the exact destructive confirmation phrase is required'
);

SELECT lives_ok(
  $$ SELECT public.request_account_deletion('XÓA TÀI KHOẢN') $$,
  'a confirmed deletion request is accepted'
);

SELECT is(
  (
    SELECT ROW(user_id, status)
    FROM public.account_deletion_requests
    WHERE user_id = '25000000-0000-0000-0000-000000000001'
  ),
  ROW(
    '25000000-0000-0000-0000-000000000001'::UUID,
    'pending'::TEXT
  ),
  'the request is owned by auth.uid and starts pending'
);

SELECT lives_ok(
  $$ SELECT public.request_account_deletion('XÓA TÀI KHOẢN') $$,
  'an exact request retry is accepted'
);

SELECT is(
  (
    SELECT COUNT(*)::INTEGER
    FROM public.account_deletion_requests
    WHERE user_id = '25000000-0000-0000-0000-000000000001'
  ),
  1,
  'a retry does not duplicate an active request'
);

SELECT is(
  (
    public.request_account_deletion('XÓA TÀI KHOẢN')
      ->> 'already_requested'
  )::BOOLEAN,
  TRUE,
  'a retry reports the existing request honestly'
);

SELECT throws_ok(
  $$ SELECT public.request_account_deletion('XÓA TÀI KHOẢN ') $$,
  '22023',
  'Account deletion confirmation is invalid',
  'an invalid confirmation cannot change request state'
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
  '25000000-0000-0000-0000-000000000002',
  'authenticated',
  'authenticated',
  'account-deletion-other@example.invalid',
  '{"provider":"email","providers":["email"]}'::JSONB,
  '{"display_name":"Other Deletion Test"}'::JSONB,
  NOW(),
  NOW()
);

SET LOCAL "request.jwt.claim.sub" = '25000000-0000-0000-0000-000000000002';

SELECT lives_ok(
  $$ SELECT public.request_account_deletion('XÓA TÀI KHOẢN') $$,
  'a second user can create only their own request'
);

SELECT is(
  (SELECT COUNT(*)::INTEGER FROM public.account_deletion_requests),
  2,
  'each authenticated user has a distinct auditable request'
);

SELECT * FROM finish();

ROLLBACK;
