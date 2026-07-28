-- Persistent, server-authoritative spaced repetition and mistake practice.
--
-- The original client reconstructed every card with interval_days = 0 and
-- updated progress directly. These additive fields and idempotent submission
-- RPCs preserve the existing SRS algorithm while making retries safe.

ALTER TABLE public.user_vocabulary_progress
  ADD COLUMN IF NOT EXISTS interval_days INTEGER NOT NULL DEFAULT 0;
ALTER TABLE public.user_vocabulary_progress
  ADD COLUMN IF NOT EXISTS state TEXT NOT NULL DEFAULT 'new';

ALTER TABLE public.user_vocabulary_progress
  DROP CONSTRAINT IF EXISTS user_vocabulary_progress_interval_days_check;
ALTER TABLE public.user_vocabulary_progress
  ADD CONSTRAINT user_vocabulary_progress_interval_days_check
  CHECK (interval_days >= 0 AND interval_days <= 36500);

ALTER TABLE public.user_vocabulary_progress
  DROP CONSTRAINT IF EXISTS user_vocabulary_progress_state_check;
ALTER TABLE public.user_vocabulary_progress
  ADD CONSTRAINT user_vocabulary_progress_state_check
  CHECK (state IN ('new', 'learning', 'review', 'mastered'));

-- Recover the best available interval from existing timestamps. New lesson
-- seeds retain interval 0/state new; previously reviewed cards keep their
-- existing next due date rather than being reset.
UPDATE public.user_vocabulary_progress
SET interval_days =
  CASE
    WHEN review_count <= 0 THEN 0
    WHEN last_reviewed_at IS NULL THEN 0
    WHEN next_review_at <= last_reviewed_at THEN 0
    ELSE LEAST(
      36500,
      GREATEST(
        1,
        CEIL(
          EXTRACT(EPOCH FROM (next_review_at - last_reviewed_at)) / 86400
        )::INTEGER
      )
    )
  END
WHERE interval_days = 0;

UPDATE public.user_vocabulary_progress
SET state =
  CASE
    WHEN review_count <= 0 THEN 'new'
    WHEN interval_days >= 21 THEN 'mastered'
    WHEN interval_days > 0 THEN 'review'
    ELSE 'learning'
  END;

CREATE TABLE IF NOT EXISTS public.vocabulary_review_submissions (
  id UUID PRIMARY KEY,
  user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  progress_id UUID NOT NULL
    REFERENCES public.user_vocabulary_progress(id) ON DELETE CASCADE,
  vocabulary_id UUID NOT NULL REFERENCES public.vocabulary(id) ON DELETE CASCADE,
  rating TEXT NOT NULL CHECK (rating IN ('again', 'hard', 'good', 'easy')),
  next_review_at TIMESTAMPTZ NOT NULL,
  difficulty REAL NOT NULL,
  interval_days INTEGER NOT NULL CHECK (
    interval_days >= 0 AND interval_days <= 36500
  ),
  review_count INTEGER NOT NULL CHECK (review_count >= 0),
  memory_strength REAL NOT NULL CHECK (
    memory_strength >= 0 AND memory_strength <= 1
  ),
  state TEXT NOT NULL CHECK (
    state IN ('new', 'learning', 'review', 'mastered')
  ),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_vocabulary_review_submissions_user_created
  ON public.vocabulary_review_submissions(user_id, created_at DESC);

CREATE TABLE IF NOT EXISTS public.mistake_review_submissions (
  id UUID PRIMARY KEY,
  user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  mistake_id UUID NOT NULL REFERENCES public.mistakes(id) ON DELETE CASCADE,
  submitted_answer TEXT NOT NULL,
  is_correct BOOLEAN NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_mistake_review_submissions_user_mistake
  ON public.mistake_review_submissions(user_id, mistake_id, created_at DESC);

ALTER TABLE public.vocabulary_review_submissions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.mistake_review_submissions ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Own vocabulary review submissions"
  ON public.vocabulary_review_submissions;
CREATE POLICY "Own vocabulary review submissions"
  ON public.vocabulary_review_submissions
  FOR SELECT
  USING (user_id = auth.uid());

DROP POLICY IF EXISTS "Own mistake review submissions"
  ON public.mistake_review_submissions;
CREATE POLICY "Own mistake review submissions"
  ON public.mistake_review_submissions
  FOR SELECT
  USING (user_id = auth.uid());

REVOKE ALL ON TABLE public.vocabulary_review_submissions
  FROM PUBLIC, anon, authenticated;
REVOKE ALL ON TABLE public.mistake_review_submissions
  FROM PUBLIC, anon, authenticated;
GRANT SELECT ON TABLE public.vocabulary_review_submissions TO authenticated;
GRANT SELECT ON TABLE public.mistake_review_submissions TO authenticated;
GRANT SELECT, INSERT ON TABLE public.vocabulary_review_submissions TO service_role;
GRANT SELECT, INSERT ON TABLE public.mistake_review_submissions TO service_role;

CREATE OR REPLACE FUNCTION public.normalize_review_answer(p_answer TEXT)
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

REVOKE ALL ON FUNCTION public.normalize_review_answer(TEXT)
  FROM PUBLIC, anon, authenticated;

CREATE OR REPLACE FUNCTION public.submit_vocabulary_review(
  p_submission_id UUID,
  p_progress_id UUID,
  p_rating TEXT
)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = ''
AS $$
DECLARE
  v_user_id UUID := auth.uid();
  v_rating TEXT := LOWER(BTRIM(COALESCE(p_rating, '')));
  v_existing public.vocabulary_review_submissions%ROWTYPE;
  v_progress public.user_vocabulary_progress%ROWTYPE;
  v_next_review_at TIMESTAMPTZ;
  v_difficulty REAL;
  v_interval_days INTEGER;
  v_review_count INTEGER;
  v_memory_strength REAL;
  v_state TEXT;
BEGIN
  IF v_user_id IS NULL THEN
    RAISE EXCEPTION USING
      ERRCODE = '42501',
      MESSAGE = 'Authentication required';
  END IF;

  IF p_submission_id IS NULL OR p_progress_id IS NULL THEN
    RAISE EXCEPTION USING
      ERRCODE = '22023',
      MESSAGE = 'Review submission and progress identifiers are required';
  END IF;

  IF v_rating NOT IN ('again', 'hard', 'good', 'easy') THEN
    RAISE EXCEPTION USING
      ERRCODE = '22023',
      MESSAGE = 'Review rating is invalid';
  END IF;

  SELECT submission.*
  INTO v_existing
  FROM public.vocabulary_review_submissions AS submission
  WHERE submission.id = p_submission_id;

  IF FOUND THEN
    IF v_existing.user_id <> v_user_id
      OR v_existing.progress_id <> p_progress_id
      OR v_existing.rating <> v_rating
    THEN
      RAISE EXCEPTION USING
        ERRCODE = '22023',
        MESSAGE = 'Review submission identifier is already in use';
    END IF;

    RETURN jsonb_build_object(
      'success', TRUE,
      'submission_id', v_existing.id,
      'progress_id', v_existing.progress_id,
      'vocabulary_id', v_existing.vocabulary_id,
      'rating', v_existing.rating,
      'next_review_at', v_existing.next_review_at,
      'difficulty', v_existing.difficulty,
      'interval_days', v_existing.interval_days,
      'review_count', v_existing.review_count,
      'memory_strength', v_existing.memory_strength,
      'state', v_existing.state,
      'already_processed', TRUE
    );
  END IF;

  PERFORM pg_catalog.pg_advisory_xact_lock(
    pg_catalog.hashtextextended(
      v_user_id::TEXT || ':vocabulary_review:' || p_progress_id::TEXT,
      0
    )
  );

  -- Recheck after the caller-owned lock so a network retry cannot apply twice.
  SELECT submission.*
  INTO v_existing
  FROM public.vocabulary_review_submissions AS submission
  WHERE submission.id = p_submission_id;

  IF FOUND THEN
    IF v_existing.user_id <> v_user_id
      OR v_existing.progress_id <> p_progress_id
      OR v_existing.rating <> v_rating
    THEN
      RAISE EXCEPTION USING
        ERRCODE = '22023',
        MESSAGE = 'Review submission identifier is already in use';
    END IF;

    RETURN jsonb_build_object(
      'success', TRUE,
      'submission_id', v_existing.id,
      'progress_id', v_existing.progress_id,
      'vocabulary_id', v_existing.vocabulary_id,
      'rating', v_existing.rating,
      'next_review_at', v_existing.next_review_at,
      'difficulty', v_existing.difficulty,
      'interval_days', v_existing.interval_days,
      'review_count', v_existing.review_count,
      'memory_strength', v_existing.memory_strength,
      'state', v_existing.state,
      'already_processed', TRUE
    );
  END IF;

  SELECT progress.*
  INTO v_progress
  FROM public.user_vocabulary_progress AS progress
  JOIN public.vocabulary AS vocabulary
    ON vocabulary.id = progress.vocabulary_id
    AND vocabulary.status = 'published'
  WHERE progress.id = p_progress_id
    AND progress.user_id = v_user_id
  FOR UPDATE OF progress;

  IF NOT FOUND THEN
    RAISE EXCEPTION USING
      ERRCODE = '22023',
      MESSAGE = 'Review card is unavailable';
  END IF;

  IF v_progress.next_review_at > NOW() THEN
    RAISE EXCEPTION USING
      ERRCODE = '22023',
      MESSAGE = 'Review card is not due yet';
  END IF;

  v_difficulty := LEAST(
    3.0,
    GREATEST(1.3, COALESCE(v_progress.difficulty, 2.5))
  );
  v_interval_days := LEAST(
    36500,
    GREATEST(0, COALESCE(v_progress.interval_days, 0))
  );
  v_review_count := GREATEST(0, v_progress.review_count) + 1;
  v_memory_strength := LEAST(
    1.0,
    GREATEST(0.0, COALESCE(v_progress.memory_strength, 0))
  );

  CASE v_rating
    WHEN 'again' THEN
      v_interval_days := 0;
      v_difficulty := GREATEST(1.3, v_difficulty - 0.2);
      v_memory_strength := GREATEST(0.0, v_memory_strength - 0.3);
      v_state := 'learning';
      v_next_review_at := NOW() + INTERVAL '10 minutes';
    WHEN 'hard' THEN
      v_difficulty := GREATEST(1.3, v_difficulty - 0.15);
      v_interval_days :=
        CASE
          WHEN v_interval_days = 0 THEN 1
          ELSE LEAST(36500, CEIL(v_interval_days * 1.2)::INTEGER)
        END;
      v_memory_strength := LEAST(1.0, v_memory_strength + 0.1);
    WHEN 'good' THEN
      v_interval_days :=
        CASE
          WHEN v_interval_days = 0 THEN 1
          ELSE LEAST(
            36500,
            CEIL(v_interval_days * v_difficulty)::INTEGER
          )
        END;
      v_memory_strength := LEAST(1.0, v_memory_strength + 0.2);
    WHEN 'easy' THEN
      v_difficulty := LEAST(3.0, v_difficulty + 0.15);
      v_interval_days :=
        CASE
          WHEN v_interval_days = 0 THEN 4
          ELSE LEAST(
            36500,
            CEIL(v_interval_days * v_difficulty * 1.3)::INTEGER
          )
        END;
      v_memory_strength := LEAST(1.0, v_memory_strength + 0.3);
  END CASE;

  IF v_rating <> 'again' THEN
    v_state :=
      CASE
        WHEN v_interval_days >= 21 THEN 'mastered'
        ELSE 'review'
      END;
    v_next_review_at := NOW() + (v_interval_days * INTERVAL '1 day');
  END IF;

  UPDATE public.user_vocabulary_progress
  SET
    difficulty = v_difficulty,
    interval_days = v_interval_days,
    review_count = v_review_count,
    memory_strength = v_memory_strength,
    state = v_state,
    next_review_at = v_next_review_at,
    last_reviewed_at = NOW()
  WHERE id = p_progress_id;

  INSERT INTO public.vocabulary_review_submissions (
    id,
    user_id,
    progress_id,
    vocabulary_id,
    rating,
    next_review_at,
    difficulty,
    interval_days,
    review_count,
    memory_strength,
    state
  )
  VALUES (
    p_submission_id,
    v_user_id,
    p_progress_id,
    v_progress.vocabulary_id,
    v_rating,
    v_next_review_at,
    v_difficulty,
    v_interval_days,
    v_review_count,
    v_memory_strength,
    v_state
  )
  RETURNING *
  INTO v_existing;

  RETURN jsonb_build_object(
    'success', TRUE,
    'submission_id', v_existing.id,
    'progress_id', v_existing.progress_id,
    'vocabulary_id', v_existing.vocabulary_id,
    'rating', v_existing.rating,
    'next_review_at', v_existing.next_review_at,
    'difficulty', v_existing.difficulty,
    'interval_days', v_existing.interval_days,
    'review_count', v_existing.review_count,
    'memory_strength', v_existing.memory_strength,
    'state', v_existing.state,
    'already_processed', FALSE
  );
END;
$$;

CREATE OR REPLACE FUNCTION public.submit_mistake_review(
  p_submission_id UUID,
  p_mistake_id UUID,
  p_answer TEXT
)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = ''
AS $$
DECLARE
  v_user_id UUID := auth.uid();
  v_answer TEXT := LEFT(COALESCE(p_answer, ''), 2000);
  v_existing public.mistake_review_submissions%ROWTYPE;
  v_mistake public.mistakes%ROWTYPE;
  v_is_correct BOOLEAN;
BEGIN
  IF v_user_id IS NULL THEN
    RAISE EXCEPTION USING
      ERRCODE = '42501',
      MESSAGE = 'Authentication required';
  END IF;

  IF p_submission_id IS NULL OR p_mistake_id IS NULL THEN
    RAISE EXCEPTION USING
      ERRCODE = '22023',
      MESSAGE = 'Mistake submission and mistake identifiers are required';
  END IF;

  IF BTRIM(v_answer) = '' THEN
    RAISE EXCEPTION USING
      ERRCODE = '22023',
      MESSAGE = 'An answer is required';
  END IF;

  SELECT submission.*
  INTO v_existing
  FROM public.mistake_review_submissions AS submission
  WHERE submission.id = p_submission_id;

  IF FOUND THEN
    IF v_existing.user_id <> v_user_id
      OR v_existing.mistake_id <> p_mistake_id
      OR v_existing.submitted_answer <> v_answer
    THEN
      RAISE EXCEPTION USING
        ERRCODE = '22023',
        MESSAGE = 'Mistake submission identifier is already in use';
    END IF;

    RETURN jsonb_build_object(
      'success', TRUE,
      'submission_id', v_existing.id,
      'mistake_id', v_existing.mistake_id,
      'is_correct', v_existing.is_correct,
      'resolved', v_existing.is_correct,
      'already_processed', TRUE
    );
  END IF;

  PERFORM pg_catalog.pg_advisory_xact_lock(
    pg_catalog.hashtextextended(
      v_user_id::TEXT || ':mistake_review:' || p_mistake_id::TEXT,
      0
    )
  );

  SELECT submission.*
  INTO v_existing
  FROM public.mistake_review_submissions AS submission
  WHERE submission.id = p_submission_id;

  IF FOUND THEN
    IF v_existing.user_id <> v_user_id
      OR v_existing.mistake_id <> p_mistake_id
      OR v_existing.submitted_answer <> v_answer
    THEN
      RAISE EXCEPTION USING
        ERRCODE = '22023',
        MESSAGE = 'Mistake submission identifier is already in use';
    END IF;

    RETURN jsonb_build_object(
      'success', TRUE,
      'submission_id', v_existing.id,
      'mistake_id', v_existing.mistake_id,
      'is_correct', v_existing.is_correct,
      'resolved', v_existing.is_correct,
      'already_processed', TRUE
    );
  END IF;

  SELECT mistake.*
  INTO v_mistake
  FROM public.mistakes AS mistake
  WHERE mistake.id = p_mistake_id
    AND mistake.user_id = v_user_id
  FOR UPDATE;

  IF NOT FOUND THEN
    RAISE EXCEPTION USING
      ERRCODE = '22023',
      MESSAGE = 'Mistake is unavailable';
  END IF;

  v_is_correct :=
    public.normalize_review_answer(v_mistake.correct_answer)
    = public.normalize_review_answer(v_answer);

  INSERT INTO public.mistake_review_submissions (
    id,
    user_id,
    mistake_id,
    submitted_answer,
    is_correct
  )
  VALUES (
    p_submission_id,
    v_user_id,
    p_mistake_id,
    v_answer,
    v_is_correct
  )
  RETURNING *
  INTO v_existing;

  IF v_is_correct THEN
    UPDATE public.mistakes
    SET reviewed = TRUE
    WHERE id = p_mistake_id
      AND user_id = v_user_id;
  END IF;

  RETURN jsonb_build_object(
    'success', TRUE,
    'submission_id', v_existing.id,
    'mistake_id', v_existing.mistake_id,
    'is_correct', v_existing.is_correct,
    'resolved', v_existing.is_correct,
    'already_processed', FALSE
  );
END;
$$;

REVOKE ALL ON FUNCTION public.submit_vocabulary_review(UUID, UUID, TEXT)
  FROM PUBLIC, anon, authenticated;
GRANT EXECUTE ON FUNCTION public.submit_vocabulary_review(UUID, UUID, TEXT)
  TO authenticated;

REVOKE ALL ON FUNCTION public.submit_mistake_review(UUID, UUID, TEXT)
  FROM PUBLIC, anon, authenticated;
GRANT EXECUTE ON FUNCTION public.submit_mistake_review(UUID, UUID, TEXT)
  TO authenticated;

-- Review state can now be mutated only through the caller-owned RPC. Lesson
-- completion continues to seed rows through its SECURITY DEFINER function.
REVOKE INSERT, UPDATE, DELETE ON TABLE public.user_vocabulary_progress
  FROM PUBLIC, anon, authenticated;
GRANT SELECT ON TABLE public.user_vocabulary_progress TO authenticated;

COMMENT ON FUNCTION public.submit_vocabulary_review(UUID, UUID, TEXT)
IS 'Idempotently applies the existing SRS rating algorithm to one due caller-owned vocabulary card and persists interval/state.';

COMMENT ON FUNCTION public.submit_mistake_review(UUID, UUID, TEXT)
IS 'Idempotently checks a caller-owned mistake practice answer and resolves the mistake only when correct.';
