BEGIN;

SELECT plan(21);

SELECT ok(
  has_function_privilege(
    'authenticated',
    'public.complete_lesson_transactional(uuid,uuid,jsonb)',
    'EXECUTE'
  ),
  'authenticated users can call transactional lesson completion'
);

SELECT ok(
  NOT has_function_privilege(
    'anon',
    'public.complete_lesson_transactional(uuid,uuid,jsonb)',
    'EXECUTE'
  ),
  'anonymous users cannot call transactional lesson completion'
);

SELECT ok(
  NOT has_function_privilege(
    'authenticated',
    'public.complete_lesson(uuid,real,integer,integer,integer)',
    'EXECUTE'
  ),
  'the legacy client-controlled completion RPC is no longer callable'
);

SELECT throws_ok(
  $$
    SELECT public.complete_lesson_transactional(
      '21000000-0000-0000-0000-000000000000',
      '10000000-0000-0000-0000-000000000001',
      '[]'::JSONB
    )
  $$,
  '42501',
  'Authentication required',
  'completion requires auth.uid()'
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
  '21000000-0000-0000-0000-000000000001',
  'authenticated',
  'authenticated',
  'transactional-lesson-test@example.invalid',
  '{"provider":"email","providers":["email"]}'::JSONB,
  '{"display_name":"Lesson Test"}'::JSONB,
  NOW(),
  NOW()
);

SET LOCAL "request.jwt.claim.sub" = '21000000-0000-0000-0000-000000000001';

-- Existing advanced review progress must never be downgraded by lesson seeding.
INSERT INTO public.user_vocabulary_progress (
  user_id,
  vocabulary_id,
  next_review_at,
  review_count,
  difficulty,
  memory_strength,
  last_reviewed_at
)
VALUES (
  '21000000-0000-0000-0000-000000000001',
  'f0000000-0000-0000-0000-000000000001',
  NOW() + INTERVAL '30 days',
  10,
  3.0,
  1.0,
  NOW()
);

-- The speaking exercise is graded from this trusted server-side assessment,
-- not from a boolean or score in the completion payload.
INSERT INTO public.pronunciation_attempts (
  user_id,
  reference_text,
  pinyin,
  recognized_text,
  overall_score,
  accuracy_score,
  fluency_score,
  completeness_score,
  exercise_id,
  lesson_id
)
VALUES (
  '21000000-0000-0000-0000-000000000001',
  '你好',
  'ni hao',
  '你好',
  90,
  90,
  90,
  90,
  'e0000000-0000-0000-0000-000000000006',
  '10000000-0000-0000-0000-000000000001'
);

-- Newly imported speaking exercises require the same trusted assessment path.
-- Keep this dynamic so additive curriculum batches do not make the security
-- contract test depend on a fixed exercise count.
INSERT INTO public.pronunciation_attempts (
  user_id,
  reference_text,
  recognized_text,
  overall_score,
  accuracy_score,
  fluency_score,
  completeness_score,
  exercise_id,
  lesson_id
)
SELECT
  '21000000-0000-0000-0000-000000000001',
  exercise.correct_answer,
  exercise.correct_answer,
  90,
  90,
  90,
  90,
  exercise.id,
  exercise.lesson_id
FROM public.exercises AS exercise
WHERE exercise.lesson_id = '10000000-0000-0000-0000-000000000001'
  AND exercise.exercise_type = 'speaking'
  AND exercise.id <> 'e0000000-0000-0000-0000-000000000006';

SELECT lives_ok(
  $$
    SELECT public.complete_lesson_transactional(
      '21000000-0000-0000-0000-000000000010',
      '10000000-0000-0000-0000-000000000001',
      (
        SELECT jsonb_agg(
          jsonb_build_object(
            'exercise_id', exercise.id,
            'user_answer',
              CASE
                WHEN exercise.id = 'e0000000-0000-0000-0000-000000000002'
                  THEN '__deliberately_wrong__'
                ELSE exercise.correct_answer
              END,
            'is_correct', TRUE,
            'time_spent_seconds', 3
          )
          ORDER BY exercise.order_index
        )
        FROM public.exercises AS exercise
        WHERE exercise.lesson_id = '10000000-0000-0000-0000-000000000001'
      )
    )
  $$,
  'the first published lesson completes atomically'
);

SELECT is(
  (
    SELECT progress.status
    FROM public.user_lesson_progress AS progress
    WHERE progress.user_id = '21000000-0000-0000-0000-000000000001'
      AND progress.lesson_id = '10000000-0000-0000-0000-000000000001'
  ),
  'completed',
  'the current lesson is completed'
);

SELECT ok(
  (
    SELECT ABS(
      progress.score
      - (
        SELECT (COUNT(*) - 1) * 100.0 / COUNT(*)
        FROM public.exercises AS exercise
        WHERE exercise.lesson_id = progress.lesson_id
      )
    ) < 0.01
    FROM public.user_lesson_progress AS progress
    WHERE progress.user_id = '21000000-0000-0000-0000-000000000001'
      AND progress.lesson_id = '10000000-0000-0000-0000-000000000001'
  ),
  'the score is calculated from server-validated answers'
);

SELECT results_eq(
  $$
    SELECT transaction.amount
    FROM public.xp_transactions AS transaction
    WHERE transaction.user_id = '21000000-0000-0000-0000-000000000001'
      AND transaction.source_type = 'lesson'
      AND transaction.source_id = '10000000-0000-0000-0000-000000000001'
  $$,
  $$ VALUES (15::INTEGER) $$,
  'authoritative lesson XP is awarded once without a false perfect bonus'
);

SELECT is(
  (
    SELECT COUNT(*)::INTEGER
    FROM public.user_exercise_attempts AS attempt
    WHERE attempt.user_id = '21000000-0000-0000-0000-000000000001'
      AND attempt.completion_id = '21000000-0000-0000-0000-000000000010'
  ),
  (
    SELECT COUNT(*)::INTEGER
    FROM public.exercises AS exercise
    WHERE exercise.lesson_id = '10000000-0000-0000-0000-000000000001'
  ),
  'one exercise attempt is stored for every exercise'
);

SELECT results_eq(
  $$
    SELECT mistake.exercise_id, mistake.lesson_id, mistake.times_wrong, mistake.reviewed
    FROM public.mistakes AS mistake
    WHERE mistake.user_id = '21000000-0000-0000-0000-000000000001'
  $$,
  $$
    VALUES (
      'e0000000-0000-0000-0000-000000000002'::UUID,
      '10000000-0000-0000-0000-000000000001'::UUID,
      1::INTEGER,
      FALSE
    )
  $$,
  'the incorrect answer is recorded as an unreviewed lesson mistake'
);

SELECT is(
  (
    SELECT COUNT(*)::INTEGER
    FROM public.user_vocabulary_progress AS progress
    JOIN public.lesson_vocabulary AS link
      ON link.vocabulary_id = progress.vocabulary_id
    WHERE progress.user_id = '21000000-0000-0000-0000-000000000001'
      AND link.lesson_id = '10000000-0000-0000-0000-000000000001'
  ),
  5,
  'all lesson vocabulary is available to Review'
);

SELECT results_eq(
  $$
    SELECT progress.review_count, progress.difficulty, progress.memory_strength
    FROM public.user_vocabulary_progress AS progress
    WHERE progress.user_id = '21000000-0000-0000-0000-000000000001'
      AND progress.vocabulary_id = 'f0000000-0000-0000-0000-000000000001'
  $$,
  $$ VALUES (10::INTEGER, 3.0::REAL, 1.0::REAL) $$,
  'existing advanced vocabulary progress is not downgraded'
);

SELECT is(
  (
    SELECT progress.status
    FROM public.user_lesson_progress AS progress
    WHERE progress.user_id = '21000000-0000-0000-0000-000000000001'
      AND progress.lesson_id = '10000000-0000-0000-0000-000000000002'
  ),
  'available',
  'lesson one unlocks lesson two'
);

SELECT is(
  (
    SELECT COUNT(*)::INTEGER
    FROM public.user_lesson_progress AS progress
    WHERE progress.user_id = '21000000-0000-0000-0000-000000000001'
      AND progress.lesson_id IN (
        '10000000-0000-0000-0000-000000000003',
        '10000000-0000-0000-0000-000000000004',
        '10000000-0000-0000-0000-000000000005'
      )
  ),
  0,
  'later lessons remain locked and receive no progress rows'
);

SELECT ok(
  (
    SELECT
      progress.current_lesson_id = '10000000-0000-0000-0000-000000000002'
      AND ABS(
        progress.percent_complete
        - (
          SELECT 100.0 / COUNT(*)
          FROM public.lessons AS lesson
          JOIN public.chapters AS chapter ON chapter.id = lesson.chapter_id
          JOIN public.units AS unit ON unit.id = chapter.unit_id
          WHERE unit.course_id = progress.course_id
            AND unit.status = 'published'
            AND chapter.status = 'published'
            AND lesson.status = 'published'
        )
      ) < 0.01
    FROM public.user_course_progress AS progress
    WHERE progress.user_id = '21000000-0000-0000-0000-000000000001'
      AND progress.course_id = 'c0000000-0000-0000-0000-000000000001'
  ),
  'course progression points only to the next lesson'
);

SELECT lives_ok(
  $$
    SELECT public.complete_lesson_transactional(
      '21000000-0000-0000-0000-000000000010',
      '10000000-0000-0000-0000-000000000001',
      '[]'::JSONB
    )
  $$,
  'an exact retry returns the stored authoritative result'
);

SELECT results_eq(
  $$
    SELECT
      progress.attempts,
      progress.xp_earned,
      (
        SELECT COUNT(*)::INTEGER
        FROM public.xp_transactions AS transaction
        WHERE transaction.user_id = progress.user_id
          AND transaction.source_type = 'lesson'
          AND transaction.source_id = progress.lesson_id
      ) AS xp_rows
    FROM public.user_lesson_progress AS progress
    WHERE progress.user_id = '21000000-0000-0000-0000-000000000001'
      AND progress.lesson_id = '10000000-0000-0000-0000-000000000001'
  $$,
  $$ VALUES (1::INTEGER, 15::INTEGER, 1::INTEGER) $$,
  'a retry cannot duplicate attempts or XP'
);

SELECT is(
  (
    SELECT mistake.times_wrong
    FROM public.mistakes AS mistake
    WHERE mistake.user_id = '21000000-0000-0000-0000-000000000001'
      AND mistake.exercise_id = 'e0000000-0000-0000-0000-000000000002'
  ),
  1,
  'a retry cannot duplicate the mistake'
);

SELECT throws_ok(
  $$
    SELECT public.complete_lesson_transactional(
      '21000000-0000-0000-0000-000000000011',
      '10000000-0000-0000-0000-000000000003',
      '[]'::JSONB
    )
  $$,
  '42501',
  'Lesson is locked',
  'a later locked lesson cannot be completed directly'
);

SELECT ok(
  NOT has_table_privilege(
    'authenticated',
    'public.user_lesson_progress',
    'INSERT'
  )
  AND NOT has_table_privilege(
    'authenticated',
    'public.user_lesson_progress',
    'UPDATE'
  )
  AND NOT has_table_privilege(
    'authenticated',
    'public.user_exercise_attempts',
    'INSERT'
  ),
  'clients cannot bypass server-authoritative lesson writes'
);

SELECT ok(
  NOT has_table_privilege('authenticated', 'public.mistakes', 'INSERT')
  AND NOT has_table_privilege('authenticated', 'public.mistakes', 'UPDATE'),
  'clients cannot forge or clear lesson mistakes directly'
);

SELECT * FROM finish();

ROLLBACK;
