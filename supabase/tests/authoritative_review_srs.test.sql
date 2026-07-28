BEGIN;

SELECT plan(30);

SELECT ok(
  has_function_privilege(
    'authenticated',
    'public.submit_vocabulary_review(uuid,uuid,text)',
    'EXECUTE'
  ),
  'authenticated users can submit vocabulary reviews'
);

SELECT ok(
  NOT has_function_privilege(
    'anon',
    'public.submit_vocabulary_review(uuid,uuid,text)',
    'EXECUTE'
  ),
  'anonymous users cannot submit vocabulary reviews'
);

SELECT ok(
  has_function_privilege(
    'authenticated',
    'public.submit_mistake_review(uuid,uuid,text)',
    'EXECUTE'
  ),
  'authenticated users can submit mistake practice answers'
);

SELECT ok(
  NOT has_table_privilege(
    'authenticated',
    'public.user_vocabulary_progress',
    'INSERT'
  )
  AND NOT has_table_privilege(
    'authenticated',
    'public.user_vocabulary_progress',
    'UPDATE'
  )
  AND NOT has_table_privilege(
    'authenticated',
    'public.user_vocabulary_progress',
    'DELETE'
  ),
  'clients cannot mutate SRS state directly'
);

SELECT ok(
  NOT has_table_privilege(
    'authenticated',
    'public.vocabulary_review_submissions',
    'INSERT'
  )
  AND NOT has_table_privilege(
    'authenticated',
    'public.mistake_review_submissions',
    'INSERT'
  ),
  'clients cannot forge review submission records'
);

SELECT throws_ok(
  $$
    SELECT public.submit_vocabulary_review(
      '24000000-0000-0000-0000-000000000010',
      '24000000-0000-0000-0000-000000000020',
      'good'
    )
  $$,
  '42501',
  'Authentication required',
  'vocabulary review requires auth.uid()'
);

SELECT throws_ok(
  $$
    SELECT public.submit_mistake_review(
      '24000000-0000-0000-0000-000000000030',
      '24000000-0000-0000-0000-000000000040',
      'answer'
    )
  $$,
  '42501',
  'Authentication required',
  'mistake review requires auth.uid()'
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
  '24000000-0000-0000-0000-000000000001',
  'authenticated',
  'authenticated',
  'review-srs-test@example.invalid',
  '{"provider":"email","providers":["email"]}'::JSONB,
  '{"display_name":"Review Test"}'::JSONB,
  NOW(),
  NOW()
);

SET LOCAL "request.jwt.claim.sub" = '24000000-0000-0000-0000-000000000001';

INSERT INTO public.user_vocabulary_progress (
  id,
  user_id,
  vocabulary_id,
  next_review_at,
  review_count,
  difficulty,
  memory_strength,
  last_reviewed_at,
  interval_days,
  state
)
VALUES (
  '24000000-0000-0000-0000-000000000020',
  '24000000-0000-0000-0000-000000000001',
  'f0000000-0000-0000-0000-000000000001',
  NOW() - INTERVAL '1 minute',
  2,
  2.5,
  0.4,
  NOW() - INTERVAL '4 days',
  4,
  'review'
);

SELECT lives_ok(
  $$
    SELECT public.submit_vocabulary_review(
      '24000000-0000-0000-0000-000000000010',
      '24000000-0000-0000-0000-000000000020',
      'good'
    )
  $$,
  'a due vocabulary review is accepted'
);

SELECT is(
  (
    SELECT ROW(
      interval_days,
      review_count,
      ROUND(difficulty::NUMERIC, 2),
      ROUND(memory_strength::NUMERIC, 2),
      state
    )
    FROM public.user_vocabulary_progress
    WHERE id = '24000000-0000-0000-0000-000000000020'
  ),
  ROW(10, 3, 2.50::NUMERIC, 0.60::NUMERIC, 'review'::TEXT),
  'good persists the prior interval, count, strength, and state'
);

SELECT ok(
  (
    SELECT next_review_at BETWEEN
      NOW() + INTERVAL '9 days 23 hours 59 minutes'
      AND NOW() + INTERVAL '10 days 1 minute'
    FROM public.user_vocabulary_progress
    WHERE id = '24000000-0000-0000-0000-000000000020'
  ),
  'good persists the next due date from the resulting interval'
);

SELECT is(
  (
    SELECT COUNT(*)::INTEGER
    FROM public.vocabulary_review_submissions
    WHERE id = '24000000-0000-0000-0000-000000000010'
  ),
  1,
  'one vocabulary submission is recorded'
);

SELECT lives_ok(
  $$
    SELECT public.submit_vocabulary_review(
      '24000000-0000-0000-0000-000000000010',
      '24000000-0000-0000-0000-000000000020',
      'good'
    )
  $$,
  'an exact vocabulary retry is accepted'
);

SELECT is(
  (
    SELECT review_count
    FROM public.user_vocabulary_progress
    WHERE id = '24000000-0000-0000-0000-000000000020'
  ),
  3,
  'an exact retry does not apply the rating twice'
);

SELECT throws_ok(
  $$
    SELECT public.submit_vocabulary_review(
      '24000000-0000-0000-0000-000000000010',
      '24000000-0000-0000-0000-000000000020',
      'easy'
    )
  $$,
  '22023',
  'Review submission identifier is already in use',
  'a vocabulary submission ID cannot be reused with another rating'
);

SELECT throws_ok(
  $$
    SELECT public.submit_vocabulary_review(
      '24000000-0000-0000-0000-000000000011',
      '24000000-0000-0000-0000-000000000020',
      'good'
    )
  $$,
  '22023',
  'Review card is not due yet',
  'a future card cannot be reviewed early'
);

UPDATE public.user_vocabulary_progress
SET next_review_at = NOW() - INTERVAL '1 second'
WHERE id = '24000000-0000-0000-0000-000000000020';

SELECT lives_ok(
  $$
    SELECT public.submit_vocabulary_review(
      '24000000-0000-0000-0000-000000000012',
      '24000000-0000-0000-0000-000000000020',
      'again'
    )
  $$,
  'again is accepted when the card becomes due'
);

SELECT is(
  (
    SELECT ROW(
      interval_days,
      review_count,
      ROUND(difficulty::NUMERIC, 2),
      ROUND(memory_strength::NUMERIC, 2),
      state
    )
    FROM public.user_vocabulary_progress
    WHERE id = '24000000-0000-0000-0000-000000000020'
  ),
  ROW(0, 4, 2.30::NUMERIC, 0.30::NUMERIC, 'learning'::TEXT),
  'again resets the interval and persists learning state'
);

UPDATE public.user_vocabulary_progress
SET next_review_at = NOW() - INTERVAL '1 second'
WHERE id = '24000000-0000-0000-0000-000000000020';

SELECT lives_ok(
  $$
    SELECT public.submit_vocabulary_review(
      '24000000-0000-0000-0000-000000000013',
      '24000000-0000-0000-0000-000000000020',
      'hard'
    )
  $$,
  'hard is accepted after the learning step becomes due'
);

SELECT is(
  (
    SELECT ROW(interval_days, review_count, state)
    FROM public.user_vocabulary_progress
    WHERE id = '24000000-0000-0000-0000-000000000020'
  ),
  ROW(1, 5, 'review'::TEXT),
  'hard graduates a zero-interval learning card to one day'
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
  '24000000-0000-0000-0000-000000000002',
  'authenticated',
  'authenticated',
  'review-srs-other@example.invalid',
  '{"provider":"email","providers":["email"]}'::JSONB,
  '{"display_name":"Other Review Test"}'::JSONB,
  NOW(),
  NOW()
);

SET LOCAL "request.jwt.claim.sub" = '24000000-0000-0000-0000-000000000002';

SELECT throws_ok(
  $$
    SELECT public.submit_vocabulary_review(
      '24000000-0000-0000-0000-000000000014',
      '24000000-0000-0000-0000-000000000020',
      'good'
    )
  $$,
  '22023',
  'Review card is unavailable',
  'one user cannot review another user''s vocabulary card'
);

SET LOCAL "request.jwt.claim.sub" = '24000000-0000-0000-0000-000000000001';

INSERT INTO public.mistakes (
  id,
  user_id,
  exercise_id,
  lesson_id,
  mistake_key,
  category,
  question,
  user_answer,
  correct_answer,
  reviewed,
  times_wrong,
  last_wrong_at
)
VALUES (
  '24000000-0000-0000-0000-000000000040',
  '24000000-0000-0000-0000-000000000001',
  'e0000000-0000-0000-0000-000000000002',
  '10000000-0000-0000-0000-000000000001',
  'review-test-mistake',
  'vocabulary',
  'What does 你好 mean?',
  'Tạm biệt',
  'Xin chào',
  FALSE,
  1,
  NOW()
);

SELECT lives_ok(
  $$
    SELECT public.submit_mistake_review(
      '24000000-0000-0000-0000-000000000030',
      '24000000-0000-0000-0000-000000000040',
      'Tạm biệt'
    )
  $$,
  'an incorrect mistake practice answer is recorded'
);

SELECT isnt(
  (
    SELECT reviewed
    FROM public.mistakes
    WHERE id = '24000000-0000-0000-0000-000000000040'
  ),
  TRUE,
  'an incorrect practice answer does not resolve the mistake'
);

SELECT is(
  (
    SELECT COUNT(*)::INTEGER
    FROM public.mistake_review_submissions
    WHERE mistake_id = '24000000-0000-0000-0000-000000000040'
  ),
  1,
  'one incorrect mistake submission is stored'
);

SELECT lives_ok(
  $$
    SELECT public.submit_mistake_review(
      '24000000-0000-0000-0000-000000000030',
      '24000000-0000-0000-0000-000000000040',
      'Tạm biệt'
    )
  $$,
  'an exact mistake submission retry is accepted'
);

SELECT is(
  (
    SELECT COUNT(*)::INTEGER
    FROM public.mistake_review_submissions
    WHERE mistake_id = '24000000-0000-0000-0000-000000000040'
  ),
  1,
  'an exact mistake retry does not duplicate the attempt'
);

SELECT throws_ok(
  $$
    SELECT public.submit_mistake_review(
      '24000000-0000-0000-0000-000000000030',
      '24000000-0000-0000-0000-000000000040',
      'Xin chào'
    )
  $$,
  '22023',
  'Mistake submission identifier is already in use',
  'a mistake submission ID cannot be reused with another answer'
);

SELECT lives_ok(
  $$
    SELECT public.submit_mistake_review(
      '24000000-0000-0000-0000-000000000031',
      '24000000-0000-0000-0000-000000000040',
      '  XIN CHÀO! '
    )
  $$,
  'a normalized correct practice answer is accepted'
);

SELECT is(
  (
    SELECT reviewed
    FROM public.mistakes
    WHERE id = '24000000-0000-0000-0000-000000000040'
  ),
  TRUE,
  'a correct practice answer resolves the mistake'
);

SELECT is(
  (
    SELECT COUNT(*)::INTEGER
    FROM public.mistake_review_submissions
    WHERE mistake_id = '24000000-0000-0000-0000-000000000040'
  ),
  2,
  'wrong and correct practice submissions are both auditable'
);

SET LOCAL "request.jwt.claim.sub" = '24000000-0000-0000-0000-000000000002';

SELECT throws_ok(
  $$
    SELECT public.submit_mistake_review(
      '24000000-0000-0000-0000-000000000032',
      '24000000-0000-0000-0000-000000000040',
      'Xin chào'
    )
  $$,
  '22023',
  'Mistake is unavailable',
  'one user cannot practice another user''s mistake'
);

SELECT * FROM finish();

ROLLBACK;
