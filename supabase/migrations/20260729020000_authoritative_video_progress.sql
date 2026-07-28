-- Authoritative, idempotent video progress and question scoring.
--
-- Real playback events submit bounded watch-time deltas with stable event IDs.
-- The database owns furthest-position, cumulative watch time, question
-- correctness, completion eligibility, and XP. Premium videos remain blocked
-- until an authoritative entitlement model exists.

CREATE TABLE IF NOT EXISTS public.video_progress_events (
  id UUID PRIMARY KEY,
  user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  video_id UUID NOT NULL REFERENCES public.videos(id) ON DELETE CASCADE,
  position_ms INTEGER NOT NULL CHECK (position_ms >= 0),
  played_delta_ms INTEGER NOT NULL CHECK (
    played_delta_ms >= 0 AND played_delta_ms <= 30000
  ),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_video_progress_events_user_video
  ON public.video_progress_events(user_id, video_id, created_at DESC);

ALTER TABLE public.video_progress_events ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Own video progress events"
  ON public.video_progress_events;
CREATE POLICY "Own video progress events"
  ON public.video_progress_events
  FOR SELECT
  USING (user_id = auth.uid());

REVOKE ALL ON TABLE public.video_progress_events
  FROM PUBLIC, anon, authenticated;
GRANT SELECT ON TABLE public.video_progress_events TO authenticated;
GRANT SELECT, INSERT ON TABLE public.video_progress_events TO service_role;

ALTER TABLE public.user_video_question_attempts
  ADD COLUMN IF NOT EXISTS client_attempt_id UUID;

CREATE UNIQUE INDEX IF NOT EXISTS idx_video_question_client_attempt
  ON public.user_video_question_attempts(client_attempt_id)
  WHERE client_attempt_id IS NOT NULL;

CREATE OR REPLACE FUNCTION public.normalize_video_answer(p_answer TEXT)
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

REVOKE ALL ON FUNCTION public.normalize_video_answer(TEXT)
  FROM PUBLIC, anon, authenticated;

CREATE OR REPLACE FUNCTION public.record_video_progress(
  p_event_id UUID,
  p_video_id UUID,
  p_position_ms INTEGER,
  p_played_delta_ms INTEGER,
  p_duration_ms INTEGER
)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = ''
AS $$
DECLARE
  v_user_id UUID := auth.uid();
  v_video public.videos%ROWTYPE;
  v_existing_event public.video_progress_events%ROWTYPE;
  v_progress public.user_video_progress%ROWTYPE;
  v_duration_ms INTEGER;
  v_position_ms INTEGER;
  v_played_delta_ms INTEGER;
BEGIN
  IF v_user_id IS NULL THEN
    RAISE EXCEPTION USING
      ERRCODE = '42501',
      MESSAGE = 'Authentication required';
  END IF;

  IF p_event_id IS NULL OR p_video_id IS NULL THEN
    RAISE EXCEPTION USING
      ERRCODE = '22023',
      MESSAGE = 'Progress event and video identifiers are required';
  END IF;

  SELECT event.*
  INTO v_existing_event
  FROM public.video_progress_events AS event
  WHERE event.id = p_event_id;

  IF FOUND THEN
    IF v_existing_event.user_id <> v_user_id
      OR v_existing_event.video_id <> p_video_id
    THEN
      RAISE EXCEPTION USING
        ERRCODE = '22023',
        MESSAGE = 'Progress event identifier is already in use';
    END IF;

    SELECT progress.*
    INTO v_progress
    FROM public.user_video_progress AS progress
    WHERE progress.user_id = v_user_id
      AND progress.video_id = p_video_id;

    RETURN to_jsonb(v_progress) || jsonb_build_object('already_processed', TRUE);
  END IF;

  SELECT video.*
  INTO v_video
  FROM public.videos AS video
  WHERE video.id = p_video_id
    AND video.status = 'published'
    AND video.processing_status = 'ready';

  IF NOT FOUND THEN
    RAISE EXCEPTION USING
      ERRCODE = '22023',
      MESSAGE = 'Video is unavailable';
  END IF;

  IF v_video.is_premium THEN
    RAISE EXCEPTION USING
      ERRCODE = '42501',
      MESSAGE = 'Premium video entitlement is unavailable';
  END IF;

  IF COALESCE(
    NULLIF(BTRIM(v_video.video_url), ''),
    NULLIF(BTRIM(v_video.video_path), ''),
    NULLIF(BTRIM(v_video.external_url), '')
  ) IS NULL THEN
    RAISE EXCEPTION USING
      ERRCODE = '22023',
      MESSAGE = 'Video has no playable source';
  END IF;

  v_duration_ms :=
    CASE
      WHEN v_video.duration_seconds > 0
        THEN LEAST(v_video.duration_seconds * 1000, 43200000)
      ELSE LEAST(GREATEST(COALESCE(p_duration_ms, 0), 1), 43200000)
    END;
  v_position_ms := LEAST(
    v_duration_ms,
    GREATEST(COALESCE(p_position_ms, 0), 0)
  );
  v_played_delta_ms := LEAST(
    30000,
    GREATEST(COALESCE(p_played_delta_ms, 0), 0)
  );

  PERFORM pg_catalog.pg_advisory_xact_lock(
    pg_catalog.hashtextextended(v_user_id::TEXT || ':video:' || p_video_id::TEXT, 0)
  );

  SELECT event.*
  INTO v_existing_event
  FROM public.video_progress_events AS event
  WHERE event.id = p_event_id;

  IF FOUND THEN
    IF v_existing_event.user_id <> v_user_id
      OR v_existing_event.video_id <> p_video_id
    THEN
      RAISE EXCEPTION USING
        ERRCODE = '22023',
        MESSAGE = 'Progress event identifier is already in use';
    END IF;

    SELECT progress.*
    INTO v_progress
    FROM public.user_video_progress AS progress
    WHERE progress.user_id = v_user_id
      AND progress.video_id = p_video_id;

    RETURN to_jsonb(v_progress) || jsonb_build_object('already_processed', TRUE);
  END IF;

  INSERT INTO public.video_progress_events (
    id,
    user_id,
    video_id,
    position_ms,
    played_delta_ms
  )
  VALUES (
    p_event_id,
    v_user_id,
    p_video_id,
    v_position_ms,
    v_played_delta_ms
  );

  INSERT INTO public.user_video_progress (
    user_id,
    video_id,
    last_position_ms,
    furthest_position_ms,
    watch_time_ms,
    progress_percent,
    started_at,
    last_watched_at
  )
  VALUES (
    v_user_id,
    p_video_id,
    v_position_ms,
    v_position_ms,
    v_played_delta_ms,
    LEAST(100, (v_position_ms::REAL / v_duration_ms::REAL) * 100),
    NOW(),
    NOW()
  )
  ON CONFLICT (user_id, video_id)
  DO UPDATE SET
    last_position_ms = v_position_ms,
    furthest_position_ms = GREATEST(
      public.user_video_progress.furthest_position_ms,
      v_position_ms
    ),
    watch_time_ms =
      public.user_video_progress.watch_time_ms + v_played_delta_ms,
    progress_percent = LEAST(
      100,
      (
        GREATEST(
          public.user_video_progress.furthest_position_ms,
          v_position_ms
        )::REAL
        / v_duration_ms::REAL
      ) * 100
    ),
    last_watched_at = NOW()
  RETURNING *
  INTO v_progress;

  RETURN to_jsonb(v_progress) || jsonb_build_object('already_processed', FALSE);
END;
$$;

REVOKE ALL ON FUNCTION public.record_video_progress(UUID, UUID, INTEGER, INTEGER, INTEGER)
  FROM PUBLIC, anon, authenticated;
GRANT EXECUTE ON FUNCTION public.record_video_progress(UUID, UUID, INTEGER, INTEGER, INTEGER)
  TO authenticated;

CREATE OR REPLACE FUNCTION public.submit_video_question_answer(
  p_attempt_id UUID,
  p_question_id UUID,
  p_answer TEXT
)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = ''
AS $$
DECLARE
  v_user_id UUID := auth.uid();
  v_question public.video_questions%ROWTYPE;
  v_video public.videos%ROWTYPE;
  v_attempt public.user_video_question_attempts%ROWTYPE;
  v_is_correct BOOLEAN;
  v_answer TEXT;
  v_answered INTEGER;
  v_correct INTEGER;
BEGIN
  IF v_user_id IS NULL THEN
    RAISE EXCEPTION USING
      ERRCODE = '42501',
      MESSAGE = 'Authentication required';
  END IF;

  IF p_attempt_id IS NULL OR p_question_id IS NULL THEN
    RAISE EXCEPTION USING
      ERRCODE = '22023',
      MESSAGE = 'Attempt and question identifiers are required';
  END IF;

  v_answer := LEFT(COALESCE(p_answer, ''), 2000);
  IF BTRIM(v_answer) = '' THEN
    RAISE EXCEPTION USING
      ERRCODE = '22023',
      MESSAGE = 'An answer is required';
  END IF;

  SELECT question.*
  INTO v_question
  FROM public.video_questions AS question
  WHERE question.id = p_question_id;

  IF NOT FOUND THEN
    RAISE EXCEPTION USING
      ERRCODE = '22023',
      MESSAGE = 'Video question is unavailable';
  END IF;

  SELECT video.*
  INTO v_video
  FROM public.videos AS video
  WHERE video.id = v_question.video_id
    AND video.status = 'published'
    AND video.processing_status = 'ready';

  IF NOT FOUND THEN
    RAISE EXCEPTION USING
      ERRCODE = '22023',
      MESSAGE = 'Video is unavailable';
  END IF;

  IF v_video.is_premium THEN
    RAISE EXCEPTION USING
      ERRCODE = '42501',
      MESSAGE = 'Premium video entitlement is unavailable';
  END IF;

  IF COALESCE(
    NULLIF(BTRIM(v_video.video_url), ''),
    NULLIF(BTRIM(v_video.video_path), ''),
    NULLIF(BTRIM(v_video.external_url), '')
  ) IS NULL THEN
    RAISE EXCEPTION USING
      ERRCODE = '22023',
      MESSAGE = 'Video has no playable source';
  END IF;

  PERFORM pg_catalog.pg_advisory_xact_lock(
    pg_catalog.hashtextextended(
      v_user_id::TEXT || ':video_question:' || p_question_id::TEXT,
      0
    )
  );

  SELECT attempt.*
  INTO v_attempt
  FROM public.user_video_question_attempts AS attempt
  WHERE attempt.client_attempt_id = p_attempt_id;

  IF FOUND THEN
    IF v_attempt.user_id <> v_user_id
      OR v_attempt.question_id <> p_question_id
    THEN
      RAISE EXCEPTION USING
        ERRCODE = '22023',
        MESSAGE = 'Question attempt identifier is already in use';
    END IF;
  ELSE
    SELECT attempt.*
    INTO v_attempt
    FROM public.user_video_question_attempts AS attempt
    WHERE attempt.user_id = v_user_id
      AND attempt.question_id = p_question_id
    ORDER BY attempt.answered_at
    LIMIT 1;
  END IF;

  IF FOUND THEN
    IF v_attempt.client_attempt_id IS NULL THEN
      UPDATE public.user_video_question_attempts
      SET client_attempt_id = p_attempt_id
      WHERE id = v_attempt.id
      RETURNING *
      INTO v_attempt;
    END IF;

    SELECT
      COUNT(DISTINCT attempt.question_id)::INTEGER,
      COUNT(DISTINCT attempt.question_id)
        FILTER (WHERE attempt.is_correct)::INTEGER
    INTO v_answered, v_correct
    FROM public.user_video_question_attempts AS attempt
    WHERE attempt.user_id = v_user_id
      AND attempt.video_id = v_question.video_id;

    RETURN jsonb_build_object(
      'success', TRUE,
      'attempt_id', v_attempt.client_attempt_id,
      'question_id', v_attempt.question_id,
      'video_id', v_attempt.video_id,
      'is_correct', v_attempt.is_correct,
      'questions_answered', v_answered,
      'questions_correct', v_correct,
      'already_processed', TRUE
    );
  END IF;

  IF EXISTS (
    SELECT 1
    FROM public.video_question_options AS option
    WHERE option.question_id = p_question_id
  ) THEN
    SELECT EXISTS (
      SELECT 1
      FROM public.video_question_options AS option
      WHERE option.question_id = p_question_id
        AND option.is_correct
        AND public.normalize_video_answer(option.text)
          = public.normalize_video_answer(v_answer)
    )
    INTO v_is_correct;
  ELSE
    v_is_correct :=
      public.normalize_video_answer(v_question.correct_answer)
      = public.normalize_video_answer(v_answer);
  END IF;

  INSERT INTO public.user_video_question_attempts (
    user_id,
    video_id,
    question_id,
    selected_answer,
    is_correct,
    attempt_number,
    client_attempt_id
  )
  VALUES (
    v_user_id,
    v_question.video_id,
    p_question_id,
    v_answer,
    v_is_correct,
    1,
    p_attempt_id
  )
  RETURNING *
  INTO v_attempt;

  SELECT
    COUNT(DISTINCT attempt.question_id)::INTEGER,
    COUNT(DISTINCT attempt.question_id)
      FILTER (WHERE attempt.is_correct)::INTEGER
  INTO v_answered, v_correct
  FROM public.user_video_question_attempts AS attempt
  WHERE attempt.user_id = v_user_id
    AND attempt.video_id = v_question.video_id;

  INSERT INTO public.user_video_progress (
    user_id,
    video_id,
    questions_answered,
    questions_correct,
    started_at,
    last_watched_at
  )
  VALUES (
    v_user_id,
    v_question.video_id,
    v_answered,
    v_correct,
    NOW(),
    NOW()
  )
  ON CONFLICT (user_id, video_id)
  DO UPDATE SET
    questions_answered = v_answered,
    questions_correct = v_correct,
    last_watched_at = NOW();

  RETURN jsonb_build_object(
    'success', TRUE,
    'attempt_id', p_attempt_id,
    'question_id', p_question_id,
    'video_id', v_question.video_id,
    'is_correct', v_is_correct,
    'questions_answered', v_answered,
    'questions_correct', v_correct,
    'already_processed', FALSE
  );
END;
$$;

REVOKE ALL ON FUNCTION public.submit_video_question_answer(UUID, UUID, TEXT)
  FROM PUBLIC, anon, authenticated;
GRANT EXECUTE ON FUNCTION public.submit_video_question_answer(UUID, UUID, TEXT)
  TO authenticated;

CREATE OR REPLACE FUNCTION public.complete_video_transactional(p_video_id UUID)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = ''
AS $$
DECLARE
  v_user_id UUID := auth.uid();
  v_video public.videos%ROWTYPE;
  v_progress public.user_video_progress%ROWTYPE;
  v_duration_ms INTEGER;
  v_required_questions INTEGER;
  v_required_answered INTEGER;
  v_questions_answered INTEGER;
  v_questions_correct INTEGER;
  v_rewarded BOOLEAN := FALSE;
  v_xp_awarded INTEGER := 0;
  v_already_completed BOOLEAN;
BEGIN
  IF v_user_id IS NULL THEN
    RAISE EXCEPTION USING
      ERRCODE = '42501',
      MESSAGE = 'Authentication required';
  END IF;

  IF p_video_id IS NULL THEN
    RAISE EXCEPTION USING
      ERRCODE = '22023',
      MESSAGE = 'Video identifier is required';
  END IF;

  SELECT video.*
  INTO v_video
  FROM public.videos AS video
  WHERE video.id = p_video_id
    AND video.status = 'published'
    AND video.processing_status = 'ready';

  IF NOT FOUND THEN
    RAISE EXCEPTION USING
      ERRCODE = '22023',
      MESSAGE = 'Video is unavailable';
  END IF;

  IF v_video.is_premium THEN
    RAISE EXCEPTION USING
      ERRCODE = '42501',
      MESSAGE = 'Premium video entitlement is unavailable';
  END IF;

  IF COALESCE(
    NULLIF(BTRIM(v_video.video_url), ''),
    NULLIF(BTRIM(v_video.video_path), ''),
    NULLIF(BTRIM(v_video.external_url), '')
  ) IS NULL THEN
    RAISE EXCEPTION USING
      ERRCODE = '22023',
      MESSAGE = 'Video has no playable source';
  END IF;

  IF v_video.duration_seconds <= 0 THEN
    RAISE EXCEPTION USING
      ERRCODE = '22023',
      MESSAGE = 'Video duration is unavailable';
  END IF;
  v_duration_ms := LEAST(v_video.duration_seconds * 1000, 43200000);

  PERFORM pg_catalog.pg_advisory_xact_lock(
    pg_catalog.hashtextextended(v_user_id::TEXT || ':video:' || p_video_id::TEXT, 0)
  );

  SELECT progress.*
  INTO v_progress
  FROM public.user_video_progress AS progress
  WHERE progress.user_id = v_user_id
    AND progress.video_id = p_video_id;

  IF NOT FOUND
    OR v_progress.furthest_position_ms < (v_duration_ms * 0.9)
    OR v_progress.progress_percent < 90
    OR v_progress.watch_time_ms < GREATEST(1000, (v_duration_ms * 0.8)::INTEGER)
  THEN
    RAISE EXCEPTION USING
      ERRCODE = '22023',
      MESSAGE = 'Video has not been watched long enough to complete';
  END IF;

  SELECT COUNT(*)::INTEGER
  INTO v_required_questions
  FROM public.video_questions AS question
  WHERE question.video_id = p_video_id
    AND question.is_required;

  SELECT COUNT(DISTINCT attempt.question_id)::INTEGER
  INTO v_required_answered
  FROM public.user_video_question_attempts AS attempt
  JOIN public.video_questions AS question
    ON question.id = attempt.question_id
    AND question.is_required
  WHERE attempt.user_id = v_user_id
    AND attempt.video_id = p_video_id;

  IF v_required_answered < v_required_questions THEN
    RAISE EXCEPTION USING
      ERRCODE = '22023',
      MESSAGE = 'Required video questions are incomplete';
  END IF;

  SELECT
    COUNT(DISTINCT attempt.question_id)::INTEGER,
    COUNT(DISTINCT attempt.question_id)
      FILTER (WHERE attempt.is_correct)::INTEGER
  INTO v_questions_answered, v_questions_correct
  FROM public.user_video_question_attempts AS attempt
  WHERE attempt.user_id = v_user_id
    AND attempt.video_id = p_video_id;

  v_already_completed := v_progress.completed_at IS NOT NULL;

  UPDATE public.user_video_progress
  SET
    last_position_ms = v_duration_ms,
    furthest_position_ms = GREATEST(furthest_position_ms, v_duration_ms),
    progress_percent = 100,
    completed_at = COALESCE(completed_at, NOW()),
    questions_answered = v_questions_answered,
    questions_correct = v_questions_correct,
    last_watched_at = NOW()
  WHERE user_id = v_user_id
    AND video_id = p_video_id;

  v_rewarded := public.reward_xp(
    v_user_id,
    GREATEST(v_video.xp_reward, 0),
    'video_complete',
    'video',
    p_video_id,
    v_user_id::TEXT || ':video_complete:' || p_video_id::TEXT
  );
  v_xp_awarded :=
    CASE WHEN v_rewarded THEN GREATEST(v_video.xp_reward, 0) ELSE 0 END;

  IF NOT v_already_completed THEN
    PERFORM public.update_user_streak(v_user_id);
  END IF;

  RETURN jsonb_build_object(
    'success', TRUE,
    'video_id', p_video_id,
    'xp_earned', v_xp_awarded,
    'already_completed', v_already_completed,
    'progress_percent', 100,
    'watch_time_ms', v_progress.watch_time_ms,
    'questions_answered', v_questions_answered,
    'questions_correct', v_questions_correct
  );
END;
$$;

REVOKE ALL ON FUNCTION public.complete_video_transactional(UUID)
  FROM PUBLIC, anon, authenticated;
GRANT EXECUTE ON FUNCTION public.complete_video_transactional(UUID)
  TO authenticated;

-- Retain the old function for rollback, but prevent client-controlled watch time
-- and question counts from bypassing the authoritative flow.
REVOKE ALL ON FUNCTION public.complete_video(UUID, INTEGER, INTEGER, INTEGER)
  FROM PUBLIC, anon, authenticated;

REVOKE INSERT, UPDATE, DELETE ON TABLE public.user_video_progress
  FROM PUBLIC, anon, authenticated;
REVOKE INSERT, UPDATE, DELETE ON TABLE public.user_video_question_attempts
  FROM PUBLIC, anon, authenticated;

GRANT SELECT ON TABLE public.user_video_progress TO authenticated;
GRANT SELECT ON TABLE public.user_video_question_attempts TO authenticated;

COMMENT ON FUNCTION public.record_video_progress(UUID, UUID, INTEGER, INTEGER, INTEGER)
IS 'Idempotently records a bounded real-player progress event without regressing furthest position or cumulative watch time.';

COMMENT ON FUNCTION public.submit_video_question_answer(UUID, UUID, TEXT)
IS 'Scores one caller-owned video question server-side and returns authoritative answered/correct counts.';

COMMENT ON FUNCTION public.complete_video_transactional(UUID)
IS 'Completes a non-premium published video only after persisted watch progress and required questions satisfy server rules.';
