BEGIN;

SELECT plan(16);

SELECT ok(
  (
    SELECT p.prosecdef
      AND COALESCE(p.proconfig, ARRAY[]::TEXT[]) @> ARRAY['search_path=""']
    FROM pg_proc AS p
    JOIN pg_namespace AS n ON n.oid = p.pronamespace
    WHERE n.nspname = 'public'
      AND p.proname = 'publish_content'
      AND pg_get_function_identity_arguments(p.oid)
        = 'p_entity_type text, p_entity_id uuid, p_change_summary text'
  ),
  'publish_content is SECURITY DEFINER with an empty search path'
);

SELECT ok(
  has_function_privilege(
    'authenticated',
    'public.publish_content(text,uuid,text)',
    'EXECUTE'
  ),
  'authenticated callers can reach the server-authorized publish RPC'
);

SELECT ok(
  NOT has_function_privilege(
    'anon',
    'public.publish_content(text,uuid,text)',
    'EXECUTE'
  ),
  'anonymous callers cannot publish content'
);

SELECT ok(
  NOT EXISTS (
    SELECT 1
    FROM pg_proc AS p
    JOIN pg_namespace AS n ON n.oid = p.pronamespace
    WHERE n.nspname = 'public'
      AND p.proname IN (
        'emit_lesson_gamification_event',
        'emit_pronunciation_gamification_event',
        'emit_review_gamification_event',
        'emit_streak_achievement_check',
        'emit_video_gamification_event',
        'emit_voice_gamification_event',
        'emit_xp_gamification_event',
        'update_total_coins',
        'update_total_xp'
      )
      AND (
        has_function_privilege('anon', p.oid, 'EXECUTE')
        OR has_function_privilege('authenticated', p.oid, 'EXECUTE')
      )
  ),
  'internal trigger helpers are not exposed as Data API RPCs'
);

SELECT throws_ok(
  $$ SELECT public.publish_content('course', gen_random_uuid(), NULL) $$,
  '42501',
  'Authentication required',
  'publication requires an authenticated caller'
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
VALUES
  (
    '29000000-0000-4000-8000-000000000001',
    'authenticated',
    'authenticated',
    'publish-editor@example.invalid',
    '{"provider":"email","providers":["email"]}'::JSONB,
    '{"display_name":"Publish Editor"}'::JSONB,
    NOW(),
    NOW()
  ),
  (
    '29000000-0000-4000-8000-000000000002',
    'authenticated',
    'authenticated',
    'publish-admin@example.invalid',
    '{"provider":"email","providers":["email"]}'::JSONB,
    '{"display_name":"Publish Admin"}'::JSONB,
    NOW(),
    NOW()
  );

UPDATE public.profiles
SET role = CASE id
  WHEN '29000000-0000-4000-8000-000000000001'::UUID THEN 'editor'
  ELSE 'admin'
END
WHERE id IN (
  '29000000-0000-4000-8000-000000000001',
  '29000000-0000-4000-8000-000000000002'
);

INSERT INTO public.courses (id, title, level, status)
VALUES
  (
    '29000000-0000-4000-8000-000000000010',
    'Publish hardening draft',
    'starter',
    'draft'
  ),
  (
    '29000000-0000-4000-8000-000000000011',
    'Publish hardening archive',
    'starter',
    'archived'
  );

SET LOCAL "request.jwt.claim.sub" =
  '29000000-0000-4000-8000-000000000001';
SET LOCAL "request.jwt.claim.role" = 'authenticated';

SELECT throws_ok(
  $$
    SELECT public.publish_content(
      'course',
      '29000000-0000-4000-8000-000000000010',
      'Editor publish attempt'
    )
  $$,
  '42501',
  'Permission denied',
  'editors cannot publish content'
);

SET LOCAL "request.jwt.claim.sub" =
  '29000000-0000-4000-8000-000000000002';

SELECT throws_ok(
  $$
    SELECT public.publish_content(
      'unsupported',
      '29000000-0000-4000-8000-000000000010',
      NULL
    )
  $$,
  '22023',
  'Unknown entity type: unsupported',
  'only allowlisted entity types can be published'
);

SELECT throws_ok(
  $$
    SELECT public.publish_content(
      'course',
      '29000000-0000-4000-8000-000000000099',
      NULL
    )
  $$,
  'P0002',
  'Content not found',
  'missing content cannot create a null version'
);

SELECT throws_ok(
  $$
    SELECT public.publish_content(
      'course',
      '29000000-0000-4000-8000-000000000010',
      repeat('x', 1001)
    )
  $$,
  '22023',
  'Change summary is too long',
  'unbounded change summaries are rejected'
);

SELECT throws_ok(
  $$
    SELECT public.publish_content(
      'course',
      '29000000-0000-4000-8000-000000000011',
      NULL
    )
  $$,
  '22023',
  'Archived content cannot be published',
  'archived content requires an explicit restore workflow'
);

SELECT lives_ok(
  $$
    SELECT public.publish_content(
      'course',
      '29000000-0000-4000-8000-000000000010',
      'Reviewed for release'
    )
  $$,
  'an admin can publish an existing draft'
);

SELECT is(
  (
    SELECT status
    FROM public.courses
    WHERE id = '29000000-0000-4000-8000-000000000010'
  ),
  'published',
  'the authorized entity is published'
);

SELECT is(
  (
    SELECT COUNT(*)::INTEGER
    FROM public.content_versions
    WHERE entity_type = 'course'
      AND entity_id = '29000000-0000-4000-8000-000000000010'
  ),
  1,
  'publication creates one version'
);

SELECT is(
  (
    SELECT snapshot ->> 'status'
    FROM public.content_versions
    WHERE entity_type = 'course'
      AND entity_id = '29000000-0000-4000-8000-000000000010'
  ),
  'draft',
  'the version preserves the pre-publication snapshot'
);

SELECT is(
  (
    SELECT created_by
    FROM public.content_versions
    WHERE entity_type = 'course'
      AND entity_id = '29000000-0000-4000-8000-000000000010'
  ),
  '29000000-0000-4000-8000-000000000002'::UUID,
  'the version records the authenticated admin'
);

SELECT is(
  (
    SELECT COUNT(*)::INTEGER
    FROM public.admin_activity_logs
    WHERE user_id = '29000000-0000-4000-8000-000000000002'
      AND action = 'PUBLISH'
      AND resource_id = '29000000-0000-4000-8000-000000000010'
  ),
  1,
  'publication creates an auditable admin activity record'
);

SELECT * FROM finish();

ROLLBACK;
