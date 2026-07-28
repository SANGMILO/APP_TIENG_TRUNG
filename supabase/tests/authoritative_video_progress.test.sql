BEGIN;

SELECT plan(26);

SELECT ok(
  has_function_privilege(
    'authenticated',
    'public.record_video_progress(uuid,uuid,integer,integer,integer)',
    'EXECUTE'
  ),
  'authenticated users can record bounded video progress events'
);

SELECT ok(
  has_function_privilege(
    'authenticated',
    'public.submit_video_question_answer(uuid,uuid,text)',
    'EXECUTE'
  ),
  'authenticated users can submit server-scored video answers'
);

SELECT ok(
  has_function_privilege(
    'authenticated',
    'public.complete_video_transactional(uuid)',
    'EXECUTE'
  )
  AND NOT has_function_privilege(
    'authenticated',
    'public.complete_video(uuid,integer,integer,integer)',
    'EXECUTE'
  ),
  'only the authoritative completion RPC is client-callable'
);

SELECT throws_ok(
  $$
    SELECT public.record_video_progress(
      '23000000-0000-0000-0000-000000000001',
      '23000000-0000-0000-0000-000000000010',
      1000,
      1000,
      10000
    )
  $$,
  '42501',
  'Authentication required',
  'progress recording requires auth.uid()'
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
  '23000000-0000-0000-0000-000000000001',
  'authenticated',
  'authenticated',
  'video-progress-test@example.invalid',
  '{"provider":"email","providers":["email"]}'::JSONB,
  '{"display_name":"Video Test"}'::JSONB,
  NOW(),
  NOW()
);

SET LOCAL "request.jwt.claim.sub" = '23000000-0000-0000-0000-000000000001';

INSERT INTO public.videos (
  id,
  title,
  video_url,
  level,
  duration_seconds,
  status,
  xp_reward,
  processing_status,
  is_premium,
  playback_type,
  source_type
)
VALUES (
  '23000000-0000-0000-0000-000000000010',
  'Transactional video test',
  'https://media.example.invalid/test.mp4',
  'starter',
  10,
  'published',
  12,
  'ready',
  FALSE,
  'progressive',
  'uploaded'
);

INSERT INTO public.video_questions (
  id,
  video_id,
  timestamp_seconds,
  timestamp_ms,
  question,
  correct_answer,
  options,
  is_required,
  sequence
)
VALUES (
  '23000000-0000-0000-0000-000000000020',
  '23000000-0000-0000-0000-000000000010',
  5,
  5000,
  'Choose the correct answer',
  'correct',
  '["correct","wrong"]'::JSONB,
  TRUE,
  1
);

INSERT INTO public.video_question_options (
  question_id,
  text,
  is_correct,
  sequence
)
VALUES
  ('23000000-0000-0000-0000-000000000020', 'correct', TRUE, 1),
  ('23000000-0000-0000-0000-000000000020', 'wrong', FALSE, 2);

SELECT lives_ok(
  $$
    SELECT public.record_video_progress(
      '23000000-0000-0000-0000-000000000101',
      '23000000-0000-0000-0000-000000000010',
      5000,
      5000,
      10000
    )
  $$,
  'the first real-player progress event is accepted'
);

SELECT results_eq(
  $$
    SELECT
      progress.last_position_ms,
      progress.furthest_position_ms,
      progress.watch_time_ms,
      ROUND(progress.progress_percent::NUMERIC, 1)
    FROM public.user_video_progress AS progress
    WHERE progress.user_id = '23000000-0000-0000-0000-000000000001'
      AND progress.video_id = '23000000-0000-0000-0000-000000000010'
  $$,
  $$ VALUES (5000::INTEGER, 5000::INTEGER, 5000::INTEGER, 50.0::NUMERIC) $$,
  'position, furthest point, cumulative watch time, and percentage are persisted'
);

SELECT lives_ok(
  $$
    SELECT public.record_video_progress(
      '23000000-0000-0000-0000-000000000102',
      '23000000-0000-0000-0000-000000000010',
      3000,
      2000,
      10000
    )
  $$,
  'seeking backward records current position'
);

SELECT results_eq(
  $$
    SELECT
      progress.last_position_ms,
      progress.furthest_position_ms,
      progress.watch_time_ms,
      ROUND(progress.progress_percent::NUMERIC, 1)
    FROM public.user_video_progress AS progress
    WHERE progress.user_id = '23000000-0000-0000-0000-000000000001'
      AND progress.video_id = '23000000-0000-0000-0000-000000000010'
  $$,
  $$ VALUES (3000::INTEGER, 5000::INTEGER, 7000::INTEGER, 50.0::NUMERIC) $$,
  'seeking backward never regresses furthest position or progress'
);

SELECT lives_ok(
  $$
    SELECT public.record_video_progress(
      '23000000-0000-0000-0000-000000000102',
      '23000000-0000-0000-0000-000000000010',
      9000,
      30000,
      10000
    )
  $$,
  'replaying an event identifier is idempotent'
);

SELECT results_eq(
  $$
    SELECT
      (
        SELECT COUNT(*)::INTEGER
        FROM public.video_progress_events AS event
        WHERE event.user_id = progress.user_id
          AND event.video_id = progress.video_id
      ),
      progress.watch_time_ms
    FROM public.user_video_progress AS progress
    WHERE progress.user_id = '23000000-0000-0000-0000-000000000001'
      AND progress.video_id = '23000000-0000-0000-0000-000000000010'
  $$,
  $$ VALUES (2::INTEGER, 7000::INTEGER) $$,
  'an event retry cannot double-count watch time'
);

SELECT lives_ok(
  $$
    SELECT public.submit_video_question_answer(
      '23000000-0000-0000-0000-000000000201',
      '23000000-0000-0000-0000-000000000020',
      'wrong'
    )
  $$,
  'a video question answer is scored server-side'
);

SELECT results_eq(
  $$
    SELECT
      progress.questions_answered,
      progress.questions_correct
    FROM public.user_video_progress AS progress
    WHERE progress.user_id = '23000000-0000-0000-0000-000000000001'
      AND progress.video_id = '23000000-0000-0000-0000-000000000010'
  $$,
  $$ VALUES (1::INTEGER, 0::INTEGER) $$,
  'answered count is distinct from correct count'
);

SELECT is(
  (
    SELECT attempt.is_correct
    FROM public.user_video_question_attempts AS attempt
    WHERE attempt.client_attempt_id = '23000000-0000-0000-0000-000000000201'
  ),
  FALSE,
  'the client cannot label a wrong answer correct'
);

SELECT is(
  (
    SELECT COUNT(*)::INTEGER
    FROM public.user_video_question_attempts AS attempt
    WHERE attempt.user_id = '23000000-0000-0000-0000-000000000001'
      AND attempt.question_id = '23000000-0000-0000-0000-000000000020'
  ),
  1,
  'one answer creates one question attempt'
);

SELECT lives_ok(
  $$
    SELECT public.submit_video_question_answer(
      '23000000-0000-0000-0000-000000000201',
      '23000000-0000-0000-0000-000000000020',
      'correct'
    )
  $$,
  'an exact question submission retry returns the original result'
);

SELECT results_eq(
  $$
    SELECT COUNT(*)::INTEGER, BOOL_OR(attempt.is_correct)
    FROM public.user_video_question_attempts AS attempt
    WHERE attempt.user_id = '23000000-0000-0000-0000-000000000001'
      AND attempt.question_id = '23000000-0000-0000-0000-000000000020'
  $$,
  $$ VALUES (1::INTEGER, FALSE) $$,
  'a retry cannot duplicate or change the scored answer'
);

SELECT throws_ok(
  $$
    SELECT public.complete_video_transactional(
      '23000000-0000-0000-0000-000000000010'
    )
  $$,
  '22023',
  'Video has not been watched long enough to complete',
  'seeking or partial progress cannot complete the video early'
);

SELECT lives_ok(
  $$
    SELECT public.record_video_progress(
      '23000000-0000-0000-0000-000000000103',
      '23000000-0000-0000-0000-000000000010',
      9500,
      2000,
      10000
    )
  $$,
  'a later real-player event reaches completion eligibility'
);

SELECT lives_ok(
  $$
    SELECT public.complete_video_transactional(
      '23000000-0000-0000-0000-000000000010'
    )
  $$,
  'eligible persisted progress completes the video'
);

SELECT results_eq(
  $$
    SELECT
      ROUND(progress.progress_percent::NUMERIC, 0),
      progress.questions_answered,
      progress.questions_correct,
      progress.completed_at IS NOT NULL
    FROM public.user_video_progress AS progress
    WHERE progress.user_id = '23000000-0000-0000-0000-000000000001'
      AND progress.video_id = '23000000-0000-0000-0000-000000000010'
  $$,
  $$ VALUES (100::NUMERIC, 1::INTEGER, 0::INTEGER, TRUE) $$,
  'completion stores authoritative progress and question counts'
);

SELECT results_eq(
  $$
    SELECT transaction.amount
    FROM public.xp_transactions AS transaction
    WHERE transaction.user_id = '23000000-0000-0000-0000-000000000001'
      AND transaction.source_type = 'video'
      AND transaction.source_id = '23000000-0000-0000-0000-000000000010'
  $$,
  $$ VALUES (12::INTEGER) $$,
  'video XP comes from the authoritative video reward'
);

SELECT lives_ok(
  $$
    SELECT public.complete_video_transactional(
      '23000000-0000-0000-0000-000000000010'
    )
  $$,
  'completion is safe to retry'
);

SELECT is(
  (
    SELECT COUNT(*)::INTEGER
    FROM public.xp_transactions AS transaction
    WHERE transaction.user_id = '23000000-0000-0000-0000-000000000001'
      AND transaction.source_type = 'video'
      AND transaction.source_id = '23000000-0000-0000-0000-000000000010'
  ),
  1,
  'completion retry cannot duplicate XP'
);

INSERT INTO public.videos (
  id,
  title,
  video_url,
  level,
  duration_seconds,
  status,
  processing_status,
  is_premium
)
VALUES
  (
    '23000000-0000-0000-0000-000000000011',
    'Premium test',
    'https://media.example.invalid/premium.mp4',
    'starter',
    10,
    'published',
    'ready',
    TRUE
  ),
  (
    '23000000-0000-0000-0000-000000000012',
    'Missing media test',
    '',
    'starter',
    10,
    'published',
    'ready',
    FALSE
  );

SELECT throws_ok(
  $$
    SELECT public.record_video_progress(
      '23000000-0000-0000-0000-000000000104',
      '23000000-0000-0000-0000-000000000011',
      1000,
      1000,
      10000
    )
  $$,
  '42501',
  'Premium video entitlement is unavailable',
  'premium playback cannot use a client-only entitlement bypass'
);

SELECT throws_ok(
  $$
    SELECT public.record_video_progress(
      '23000000-0000-0000-0000-000000000105',
      '23000000-0000-0000-0000-000000000012',
      1000,
      1000,
      10000
    )
  $$,
  '22023',
  'Video has no playable source',
  'published metadata without media cannot pretend to play'
);

SELECT ok(
  NOT has_table_privilege('authenticated', 'public.user_video_progress', 'INSERT')
  AND NOT has_table_privilege('authenticated', 'public.user_video_progress', 'UPDATE')
  AND NOT has_table_privilege(
    'authenticated',
    'public.user_video_question_attempts',
    'INSERT'
  ),
  'clients cannot bypass authoritative video progress or scoring'
);

SELECT * FROM finish();

ROLLBACK;
