-- Transactional lesson completion.
--
-- The legacy complete_lesson RPC accepted client-calculated scores and did not
-- persist attempts, mistakes, review vocabulary, or progression. This additive
-- migration introduces an idempotent submission ledger and a new caller-only
-- RPC. Existing completion rows and XP transactions are preserved.

CREATE TABLE IF NOT EXISTS public.lesson_completion_submissions (
  id UUID PRIMARY KEY,
  user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  lesson_id UUID NOT NULL REFERENCES public.lessons(id) ON DELETE CASCADE,
  result JSONB NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_lesson_completion_submissions_user_lesson
  ON public.lesson_completion_submissions(user_id, lesson_id, created_at DESC);

ALTER TABLE public.lesson_completion_submissions ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Own lesson completion submissions"
  ON public.lesson_completion_submissions;
CREATE POLICY "Own lesson completion submissions"
  ON public.lesson_completion_submissions
  FOR SELECT
  USING (user_id = auth.uid());

REVOKE ALL ON TABLE public.lesson_completion_submissions
  FROM PUBLIC, anon, authenticated;
GRANT SELECT ON TABLE public.lesson_completion_submissions TO authenticated;
GRANT SELECT, INSERT ON TABLE public.lesson_completion_submissions TO service_role;

ALTER TABLE public.user_exercise_attempts
  ADD COLUMN IF NOT EXISTS completion_id UUID
    REFERENCES public.lesson_completion_submissions(id) ON DELETE SET NULL;

CREATE UNIQUE INDEX IF NOT EXISTS idx_exercise_attempt_completion
  ON public.user_exercise_attempts(user_id, completion_id, exercise_id)
  WHERE completion_id IS NOT NULL;

ALTER TABLE public.mistakes
  ADD COLUMN IF NOT EXISTS lesson_id UUID REFERENCES public.lessons(id) ON DELETE SET NULL;
ALTER TABLE public.mistakes
  ADD COLUMN IF NOT EXISTS mistake_key TEXT;

CREATE UNIQUE INDEX IF NOT EXISTS idx_mistakes_user_key
  ON public.mistakes(user_id, mistake_key)
  WHERE mistake_key IS NOT NULL;

CREATE OR REPLACE FUNCTION public.normalize_lesson_answer(p_answer TEXT)
RETURNS TEXT
LANGUAGE SQL
IMMUTABLE
SET search_path = ''
AS $$
  SELECT LOWER(
    REGEXP_REPLACE(
      COALESCE(p_answer, ''),
      '[[:space:]，。！？、；：,.!?;:"“”‘’]+',
      '',
      'g'
    )
  );
$$;

REVOKE ALL ON FUNCTION public.normalize_lesson_answer(TEXT)
  FROM PUBLIC, anon, authenticated;

CREATE OR REPLACE FUNCTION public.complete_lesson_transactional(
  p_completion_id UUID,
  p_lesson_id UUID,
  p_attempts JSONB
)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = ''
AS $$
DECLARE
  v_user_id UUID := auth.uid();
  v_existing_result JSONB;
  v_attempt JSONB;
  v_exercise public.exercises%ROWTYPE;
  v_user_answer TEXT;
  v_normalized_answer TEXT;
  v_is_correct BOOLEAN;
  v_pronunciation_score REAL;
  v_passing_score REAL;
  v_time_spent INTEGER;
  v_exercise_count INTEGER;
  v_attempt_count INTEGER;
  v_distinct_attempt_count INTEGER;
  v_correct_count INTEGER := 0;
  v_mistakes_recorded INTEGER := 0;
  v_review_words_seeded INTEGER := 0;
  v_base_xp INTEGER;
  v_requested_xp INTEGER;
  v_xp_awarded INTEGER := 0;
  v_rewarded BOOLEAN := FALSE;
  v_score REAL;
  v_perfect_bonus INTEGER := 0;
  v_lesson_xp_total INTEGER;
  v_course_id UUID;
  v_current_ordinal BIGINT;
  v_current_access TEXT;
  v_next_lesson_id UUID;
  v_next_unit_id UUID;
  v_next_chapter_id UUID;
  v_total_course_lessons INTEGER;
  v_completed_course_lessons INTEGER;
  v_percent_complete REAL;
  v_course_completed BOOLEAN;
  v_result JSONB;
  v_mistake_category TEXT;
BEGIN
  IF v_user_id IS NULL THEN
    RAISE EXCEPTION USING
      ERRCODE = '42501',
      MESSAGE = 'Authentication required';
  END IF;

  IF p_completion_id IS NULL OR p_lesson_id IS NULL THEN
    RAISE EXCEPTION USING
      ERRCODE = '22023',
      MESSAGE = 'Completion and lesson identifiers are required';
  END IF;

  SELECT submission.result
  INTO v_existing_result
  FROM public.lesson_completion_submissions AS submission
  WHERE submission.id = p_completion_id
    AND submission.user_id = v_user_id
    AND submission.lesson_id = p_lesson_id;

  IF FOUND THEN
    RETURN v_existing_result || jsonb_build_object('already_processed', TRUE);
  END IF;

  -- Serialize all completion attempts for the same user and lesson. This also
  -- closes the race between reward_xp's idempotency lookup and insert.
  PERFORM pg_catalog.pg_advisory_xact_lock(
    pg_catalog.hashtextextended(v_user_id::TEXT || ':' || p_lesson_id::TEXT, 0)
  );

  SELECT submission.result
  INTO v_existing_result
  FROM public.lesson_completion_submissions AS submission
  WHERE submission.id = p_completion_id
    AND submission.user_id = v_user_id
    AND submission.lesson_id = p_lesson_id;

  IF FOUND THEN
    RETURN v_existing_result || jsonb_build_object('already_processed', TRUE);
  END IF;

  IF EXISTS (
    SELECT 1
    FROM public.lesson_completion_submissions AS submission
    WHERE submission.id = p_completion_id
      AND (
        submission.user_id <> v_user_id
        OR submission.lesson_id <> p_lesson_id
      )
  ) THEN
    RAISE EXCEPTION USING
      ERRCODE = '22023',
      MESSAGE = 'Completion identifier is already in use';
  END IF;

  WITH ordered_lessons AS (
    SELECT
      course.id AS course_id,
      lesson.id AS lesson_id,
      ROW_NUMBER() OVER (
        PARTITION BY course.id
        ORDER BY
          course.order_index,
          unit.order_index,
          chapter.order_index,
          lesson.order_index,
          lesson.id
      ) AS lesson_ordinal
    FROM public.courses AS course
    JOIN public.units AS unit
      ON unit.course_id = course.id
      AND unit.status = 'published'
    JOIN public.chapters AS chapter
      ON chapter.unit_id = unit.id
      AND chapter.status = 'published'
    JOIN public.lessons AS lesson
      ON lesson.chapter_id = chapter.id
      AND lesson.status = 'published'
    WHERE course.status = 'published'
  )
  SELECT ordered.course_id, ordered.lesson_ordinal
  INTO v_course_id, v_current_ordinal
  FROM ordered_lessons AS ordered
  WHERE ordered.lesson_id = p_lesson_id;

  IF NOT FOUND THEN
    RAISE EXCEPTION USING
      ERRCODE = '22023',
      MESSAGE = 'Lesson is unavailable';
  END IF;

  SELECT progress.status
  INTO v_current_access
  FROM public.user_lesson_progress AS progress
  WHERE progress.user_id = v_user_id
    AND progress.lesson_id = p_lesson_id;

  IF v_current_ordinal <> 1
    AND COALESCE(v_current_access, 'locked') NOT IN ('available', 'in_progress', 'completed')
  THEN
    RAISE EXCEPTION USING
      ERRCODE = '42501',
      MESSAGE = 'Lesson is locked';
  END IF;

  SELECT GREATEST(lesson.xp_reward, 0), COUNT(exercise.id)::INTEGER
  INTO v_base_xp, v_exercise_count
  FROM public.lessons AS lesson
  LEFT JOIN public.exercises AS exercise ON exercise.lesson_id = lesson.id
  WHERE lesson.id = p_lesson_id
    AND lesson.status = 'published'
  GROUP BY lesson.id, lesson.xp_reward;

  IF v_exercise_count <= 0 THEN
    RAISE EXCEPTION USING
      ERRCODE = '22023',
      MESSAGE = 'Lesson has no exercises';
  END IF;

  IF p_attempts IS NULL OR jsonb_typeof(p_attempts) <> 'array' THEN
    RAISE EXCEPTION USING
      ERRCODE = '22023',
      MESSAGE = 'Exercise attempts must be an array';
  END IF;

  SELECT
    COUNT(*)::INTEGER,
    COUNT(DISTINCT item.value ->> 'exercise_id')::INTEGER
  INTO v_attempt_count, v_distinct_attempt_count
  FROM jsonb_array_elements(p_attempts) AS item(value)
  WHERE jsonb_typeof(item.value) = 'object';

  IF v_attempt_count <> v_exercise_count
    OR v_distinct_attempt_count <> v_exercise_count
    OR jsonb_array_length(p_attempts) <> v_exercise_count
  THEN
    RAISE EXCEPTION USING
      ERRCODE = '22023',
      MESSAGE = 'Exactly one attempt is required for every lesson exercise';
  END IF;

  -- Reserve the submission ID before inserting child exercise attempts. The
  -- row and all dependent writes are invisible until this transaction commits.
  INSERT INTO public.lesson_completion_submissions (
    id,
    user_id,
    lesson_id,
    result
  )
  VALUES (
    p_completion_id,
    v_user_id,
    p_lesson_id,
    '{"pending":true}'::JSONB
  );

  FOR v_attempt IN
    SELECT item.value
    FROM jsonb_array_elements(p_attempts) AS item(value)
  LOOP
    BEGIN
      SELECT exercise.*
      INTO STRICT v_exercise
      FROM public.exercises AS exercise
      WHERE exercise.id = (v_attempt ->> 'exercise_id')::UUID
        AND exercise.lesson_id = p_lesson_id;
    EXCEPTION
      WHEN NO_DATA_FOUND OR INVALID_TEXT_REPRESENTATION THEN
        RAISE EXCEPTION USING
          ERRCODE = '22023',
          MESSAGE = 'Attempt references an invalid lesson exercise';
    END;

    v_user_answer := LEFT(COALESCE(v_attempt ->> 'user_answer', ''), 4000);
    v_normalized_answer := public.normalize_lesson_answer(v_user_answer);
    v_pronunciation_score := NULL;
    v_is_correct := FALSE;

    IF v_exercise.exercise_type IN ('vocabulary', 'flashcard') THEN
      v_is_correct := TRUE;
    ELSIF v_exercise.exercise_type IN ('multiple_choice', 'listening') THEN
      IF EXISTS (
        SELECT 1
        FROM public.exercise_options AS option
        WHERE option.exercise_id = v_exercise.id
      ) THEN
        SELECT EXISTS (
          SELECT 1
          FROM public.exercise_options AS option
          WHERE option.exercise_id = v_exercise.id
            AND option.is_correct
            AND public.normalize_lesson_answer(option.text) = v_normalized_answer
        )
        INTO v_is_correct;
      ELSE
        v_is_correct :=
          public.normalize_lesson_answer(v_exercise.correct_answer) = v_normalized_answer;
      END IF;
    ELSIF v_exercise.exercise_type = 'translation' THEN
      v_is_correct :=
        public.normalize_lesson_answer(v_exercise.correct_answer) = v_normalized_answer
        OR EXISTS (
          SELECT 1
          FROM jsonb_array_elements_text(
            CASE
              WHEN jsonb_typeof(v_exercise.data -> 'acceptable_answers') = 'array'
                THEN v_exercise.data -> 'acceptable_answers'
              ELSE '[]'::JSONB
            END
          ) AS acceptable(answer)
          WHERE public.normalize_lesson_answer(acceptable.answer) = v_normalized_answer
        );
    ELSIF v_exercise.exercise_type = 'speaking' THEN
      SELECT attempt.overall_score
      INTO v_pronunciation_score
      FROM public.pronunciation_attempts AS attempt
      WHERE attempt.user_id = v_user_id
        AND attempt.exercise_id = v_exercise.id
        AND attempt.lesson_id = p_lesson_id
      ORDER BY attempt.created_at DESC
      LIMIT 1;

      v_passing_score :=
        CASE
          WHEN COALESCE(v_exercise.data ->> 'passing_score', '') ~ '^[0-9]+([.][0-9]+)?$'
            THEN LEAST(
              100,
              GREATEST(0, (v_exercise.data ->> 'passing_score')::REAL)
            )
          ELSE 60
        END;
      v_is_correct :=
        v_pronunciation_score IS NOT NULL
        AND v_pronunciation_score >= v_passing_score;
    ELSE
      v_is_correct :=
        public.normalize_lesson_answer(v_exercise.correct_answer) = v_normalized_answer;
    END IF;

    BEGIN
      v_time_spent := LEAST(
        3600,
        GREATEST(0, COALESCE((v_attempt ->> 'time_spent_seconds')::INTEGER, 0))
      );
    EXCEPTION
      WHEN INVALID_TEXT_REPRESENTATION OR NUMERIC_VALUE_OUT_OF_RANGE THEN
        v_time_spent := 0;
    END;

    INSERT INTO public.user_exercise_attempts (
      user_id,
      exercise_id,
      lesson_id,
      user_answer,
      is_correct,
      time_spent_seconds,
      pronunciation_score,
      completion_id
    )
    VALUES (
      v_user_id,
      v_exercise.id,
      p_lesson_id,
      v_user_answer,
      v_is_correct,
      v_time_spent,
      v_pronunciation_score,
      p_completion_id
    );

    IF v_is_correct THEN
      v_correct_count := v_correct_count + 1;
    ELSE
      v_mistake_category :=
        CASE v_exercise.exercise_type
          WHEN 'grammar' THEN 'grammar'
          WHEN 'listening' THEN 'listening'
          WHEN 'speaking' THEN 'speaking'
          WHEN 'sentence_builder' THEN 'writing'
          WHEN 'character_writing' THEN 'writing'
          ELSE 'vocabulary'
        END;

      INSERT INTO public.mistakes (
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
        v_user_id,
        v_exercise.id,
        p_lesson_id,
        'lesson:' || p_lesson_id::TEXT || ':exercise:' || v_exercise.id::TEXT,
        v_mistake_category,
        v_exercise.question,
        v_user_answer,
        v_exercise.correct_answer,
        FALSE,
        1,
        NOW()
      )
      ON CONFLICT (user_id, mistake_key)
        WHERE mistake_key IS NOT NULL
      DO UPDATE SET
        lesson_id = EXCLUDED.lesson_id,
        category = EXCLUDED.category,
        question = EXCLUDED.question,
        user_answer = EXCLUDED.user_answer,
        correct_answer = EXCLUDED.correct_answer,
        reviewed = FALSE,
        times_wrong = public.mistakes.times_wrong + 1,
        last_wrong_at = NOW();

      v_mistakes_recorded := v_mistakes_recorded + 1;
    END IF;
  END LOOP;

  v_score := (v_correct_count::REAL / v_exercise_count::REAL) * 100;
  v_perfect_bonus :=
    CASE WHEN v_correct_count = v_exercise_count THEN 5 ELSE 0 END;
  v_requested_xp := v_base_xp + v_perfect_bonus;

  v_rewarded := public.reward_xp(
    v_user_id,
    v_requested_xp,
    'lesson_complete',
    'lesson',
    p_lesson_id,
    v_user_id::TEXT || ':lesson_complete:' || p_lesson_id::TEXT
  );
  v_xp_awarded := CASE WHEN v_rewarded THEN v_requested_xp ELSE 0 END;

  INSERT INTO public.user_lesson_progress (
    user_id,
    lesson_id,
    status,
    score,
    xp_earned,
    started_at,
    completed_at,
    attempts
  )
  VALUES (
    v_user_id,
    p_lesson_id,
    'completed',
    v_score,
    v_xp_awarded,
    NOW(),
    NOW(),
    1
  )
  ON CONFLICT (user_id, lesson_id)
  DO UPDATE SET
    status = 'completed',
    score = GREATEST(
      COALESCE(public.user_lesson_progress.score, 0),
      EXCLUDED.score
    ),
    xp_earned = public.user_lesson_progress.xp_earned + v_xp_awarded,
    started_at = COALESCE(public.user_lesson_progress.started_at, NOW()),
    completed_at = COALESCE(public.user_lesson_progress.completed_at, NOW()),
    attempts = public.user_lesson_progress.attempts + 1;

  SELECT progress.xp_earned
  INTO v_lesson_xp_total
  FROM public.user_lesson_progress AS progress
  WHERE progress.user_id = v_user_id
    AND progress.lesson_id = p_lesson_id;

  INSERT INTO public.user_vocabulary_progress (
    user_id,
    vocabulary_id,
    next_review_at,
    review_count,
    difficulty,
    memory_strength
  )
  SELECT
    v_user_id,
    link.vocabulary_id,
    NOW(),
    0,
    2.5,
    0
  FROM public.lesson_vocabulary AS link
  JOIN public.vocabulary AS vocabulary
    ON vocabulary.id = link.vocabulary_id
    AND vocabulary.status = 'published'
  WHERE link.lesson_id = p_lesson_id
  ON CONFLICT (user_id, vocabulary_id) DO NOTHING;

  GET DIAGNOSTICS v_review_words_seeded = ROW_COUNT;

  WITH ordered_lessons AS (
    SELECT
      course.id AS course_id,
      unit.id AS unit_id,
      chapter.id AS chapter_id,
      lesson.id AS lesson_id,
      ROW_NUMBER() OVER (
        PARTITION BY course.id
        ORDER BY
          course.order_index,
          unit.order_index,
          chapter.order_index,
          lesson.order_index,
          lesson.id
      ) AS lesson_ordinal
    FROM public.courses AS course
    JOIN public.units AS unit
      ON unit.course_id = course.id
      AND unit.status = 'published'
    JOIN public.chapters AS chapter
      ON chapter.unit_id = unit.id
      AND chapter.status = 'published'
    JOIN public.lessons AS lesson
      ON lesson.chapter_id = chapter.id
      AND lesson.status = 'published'
    WHERE course.status = 'published'
  )
  SELECT ordered.lesson_id, ordered.unit_id, ordered.chapter_id
  INTO v_next_lesson_id, v_next_unit_id, v_next_chapter_id
  FROM ordered_lessons AS ordered
  WHERE ordered.course_id = v_course_id
    AND ordered.lesson_ordinal = v_current_ordinal + 1;

  IF v_next_lesson_id IS NOT NULL THEN
    INSERT INTO public.user_lesson_progress (
      user_id,
      lesson_id,
      status,
      started_at
    )
    VALUES (
      v_user_id,
      v_next_lesson_id,
      'available',
      NULL
    )
    ON CONFLICT (user_id, lesson_id)
    DO UPDATE SET
      status =
        CASE
          WHEN public.user_lesson_progress.status IN ('in_progress', 'completed')
            THEN public.user_lesson_progress.status
          ELSE 'available'
        END;
  END IF;

  SELECT COUNT(*)::INTEGER
  INTO v_total_course_lessons
  FROM public.units AS unit
  JOIN public.chapters AS chapter
    ON chapter.unit_id = unit.id
    AND chapter.status = 'published'
  JOIN public.lessons AS lesson
    ON lesson.chapter_id = chapter.id
    AND lesson.status = 'published'
  WHERE unit.course_id = v_course_id
    AND unit.status = 'published';

  SELECT COUNT(*)::INTEGER
  INTO v_completed_course_lessons
  FROM public.user_lesson_progress AS progress
  JOIN public.lessons AS lesson ON lesson.id = progress.lesson_id
  JOIN public.chapters AS chapter ON chapter.id = lesson.chapter_id
  JOIN public.units AS unit ON unit.id = chapter.unit_id
  WHERE progress.user_id = v_user_id
    AND progress.status = 'completed'
    AND unit.course_id = v_course_id
    AND unit.status = 'published'
    AND chapter.status = 'published'
    AND lesson.status = 'published';

  v_percent_complete :=
    CASE
      WHEN v_total_course_lessons > 0
        THEN LEAST(
          100,
          (v_completed_course_lessons::REAL / v_total_course_lessons::REAL) * 100
        )
      ELSE 0
    END;
  v_course_completed :=
    v_total_course_lessons > 0
    AND v_completed_course_lessons >= v_total_course_lessons;

  INSERT INTO public.user_course_progress (
    user_id,
    course_id,
    current_unit_id,
    current_chapter_id,
    current_lesson_id,
    percent_complete,
    started_at,
    completed_at
  )
  VALUES (
    v_user_id,
    v_course_id,
    v_next_unit_id,
    v_next_chapter_id,
    v_next_lesson_id,
    v_percent_complete,
    NOW(),
    CASE WHEN v_course_completed THEN NOW() ELSE NULL END
  )
  ON CONFLICT (user_id, course_id)
  DO UPDATE SET
    current_unit_id = EXCLUDED.current_unit_id,
    current_chapter_id = EXCLUDED.current_chapter_id,
    current_lesson_id = EXCLUDED.current_lesson_id,
    percent_complete = EXCLUDED.percent_complete,
    completed_at =
      CASE
        WHEN v_course_completed
          THEN COALESCE(public.user_course_progress.completed_at, NOW())
        ELSE NULL
      END;

  PERFORM public.update_user_streak(v_user_id);

  v_result := jsonb_build_object(
    'success', TRUE,
    'completion_id', p_completion_id,
    'lesson_id', p_lesson_id,
    'score', v_score,
    'correct_answers', v_correct_count,
    'total_exercises', v_exercise_count,
    'xp_earned', v_xp_awarded,
    'lesson_xp_total', v_lesson_xp_total,
    'base_xp', v_base_xp,
    'perfect_bonus', CASE WHEN v_rewarded THEN v_perfect_bonus ELSE 0 END,
    'already_processed', FALSE,
    'next_lesson_id', v_next_lesson_id,
    'course_completed', v_course_completed,
    'course_percent_complete', v_percent_complete,
    'review_words_seeded', v_review_words_seeded,
    'mistakes_recorded', v_mistakes_recorded
  );

  UPDATE public.lesson_completion_submissions
  SET result = v_result
  WHERE id = p_completion_id
    AND user_id = v_user_id
    AND lesson_id = p_lesson_id;

  RETURN v_result;
END;
$$;

REVOKE ALL ON FUNCTION public.complete_lesson_transactional(UUID, UUID, JSONB)
  FROM PUBLIC, anon, authenticated;
GRANT EXECUTE ON FUNCTION public.complete_lesson_transactional(UUID, UUID, JSONB)
  TO authenticated;

-- Prevent clients from bypassing the transactional flow. The old function is
-- retained so a rollback can restore its grant without rewriting history.
REVOKE ALL ON FUNCTION public.complete_lesson(UUID, REAL, INTEGER, INTEGER, INTEGER)
  FROM PUBLIC, anon, authenticated;

-- Lesson completion writes are now server-authoritative.
REVOKE INSERT, UPDATE, DELETE ON TABLE public.user_lesson_progress
  FROM PUBLIC, anon, authenticated;
REVOKE INSERT, UPDATE, DELETE ON TABLE public.user_exercise_attempts
  FROM PUBLIC, anon, authenticated;
REVOKE INSERT, UPDATE, DELETE ON TABLE public.mistakes
  FROM PUBLIC, anon, authenticated;

GRANT SELECT ON TABLE public.user_lesson_progress TO authenticated;
GRANT SELECT ON TABLE public.user_exercise_attempts TO authenticated;
GRANT SELECT ON TABLE public.mistakes TO authenticated;

COMMENT ON FUNCTION public.complete_lesson_transactional(UUID, UUID, JSONB)
IS 'Atomically validates and records one caller-owned lesson completion, awards authoritative XP once, seeds review vocabulary, records mistakes, and unlocks only the next published lesson.';
