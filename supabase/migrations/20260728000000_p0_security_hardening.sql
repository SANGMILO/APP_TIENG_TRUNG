-- P0-A: Server-side authorization and XP integrity hardening.
-- Additive migration: all earlier migrations are already applied to the hosted project.

-- ============================================
-- 1. PROFILE UPDATE LEAST PRIVILEGE
-- ============================================

-- Remove the table-wide UPDATE grant that allowed authenticated users to
-- modify server-owned identity, authorization, progression, and economy data.
REVOKE UPDATE ON TABLE public.profiles FROM PUBLIC, anon, authenticated;

-- Users may update only profile/preferences fields used by the existing app.
GRANT UPDATE (
  username,
  display_name,
  avatar_url,
  native_language,
  chinese_level,
  daily_goal_minutes,
  daily_goal_xp,
  learning_purpose,
  onboarding_completed,
  timezone
) ON TABLE public.profiles TO authenticated;

-- updated_at is maintained by the database, not accepted from clients.
CREATE OR REPLACE FUNCTION public.set_profile_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at := NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SET search_path = '';

DROP TRIGGER IF EXISTS set_profile_updated_at ON public.profiles;
CREATE TRIGGER set_profile_updated_at
  BEFORE UPDATE ON public.profiles
  FOR EACH ROW
  EXECUTE FUNCTION public.set_profile_updated_at();

REVOKE ALL ON FUNCTION public.set_profile_updated_at() FROM PUBLIC, anon, authenticated;

-- Role changes remain possible only through a database-authorized,
-- super-admin-only operation. Column grants prevent direct role updates.
CREATE OR REPLACE FUNCTION public.admin_update_user_role(
  p_user_id UUID,
  p_new_role TEXT
)
RETURNS public.profiles AS $$
DECLARE
  v_caller_role TEXT;
  v_before public.profiles%ROWTYPE;
  v_after public.profiles%ROWTYPE;
BEGIN
  IF auth.uid() IS NULL THEN
    RAISE EXCEPTION USING
      ERRCODE = '42501',
      MESSAGE = 'Permission denied';
  END IF;

  SELECT role
  INTO v_caller_role
  FROM public.profiles
  WHERE id = auth.uid();

  IF v_caller_role IS DISTINCT FROM 'super_admin' THEN
    RAISE EXCEPTION USING
      ERRCODE = '42501',
      MESSAGE = 'Permission denied';
  END IF;

  IF p_new_role IS NULL
    OR p_new_role NOT IN ('student', 'teacher', 'editor', 'admin', 'super_admin')
  THEN
    RAISE EXCEPTION USING
      ERRCODE = '22023',
      MESSAGE = 'Invalid role';
  END IF;

  SELECT *
  INTO v_before
  FROM public.profiles
  WHERE id = p_user_id;

  IF NOT FOUND THEN
    RAISE EXCEPTION USING
      ERRCODE = 'P0002',
      MESSAGE = 'User not found';
  END IF;

  UPDATE public.profiles
  SET role = p_new_role
  WHERE id = p_user_id
  RETURNING * INTO v_after;

  INSERT INTO public.admin_activity_logs (
    user_id,
    action,
    resource_type,
    resource_id,
    entity_type,
    details,
    before_data,
    after_data
  )
  VALUES (
    auth.uid(),
    'ROLE_CHANGE',
    'profiles',
    p_user_id,
    'profiles',
    jsonb_build_object('old_role', v_before.role, 'new_role', v_after.role),
    to_jsonb(v_before),
    to_jsonb(v_after)
  );

  RETURN v_after;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = '';

REVOKE ALL ON FUNCTION public.admin_update_user_role(UUID, TEXT)
  FROM PUBLIC, anon, authenticated;
GRANT EXECUTE ON FUNCTION public.admin_update_user_role(UUID, TEXT)
  TO authenticated;

-- ============================================
-- 2. XP LEDGER AND REWARD FUNCTION INTEGRITY
-- ============================================

-- Ledger writes remain server-authoritative even if grants drift later.
REVOKE INSERT, UPDATE, DELETE ON TABLE public.xp_transactions
  FROM PUBLIC, anon, authenticated;
REVOKE INSERT, UPDATE, DELETE ON TABLE public.coin_transactions
  FROM PUBLIC, anon, authenticated;

-- The browser/mobile client must never call arbitrary reward_xp directly.
REVOKE ALL ON FUNCTION public.reward_xp(UUID, INTEGER, TEXT, TEXT, UUID, TEXT)
  FROM PUBLIC, anon, authenticated;
GRANT EXECUTE ON FUNCTION public.reward_xp(UUID, INTEGER, TEXT, TEXT, UUID, TEXT)
  TO service_role;

-- Preserve the existing client RPC signature, but ignore the client-provided
-- XP amount. Base XP and the bounded perfect bonus are derived server-side.
CREATE OR REPLACE FUNCTION public.complete_lesson(
  p_lesson_id UUID,
  p_score REAL,
  p_xp_earned INTEGER,
  p_exercises_correct INTEGER,
  p_exercises_total INTEGER
)
RETURNS JSONB AS $$
DECLARE
  v_user_id UUID := auth.uid();
  v_idempotency_key TEXT;
  v_base_xp INTEGER;
  v_exercise_count INTEGER;
  v_score REAL;
  v_xp_awarded INTEGER;
BEGIN
  IF v_user_id IS NULL THEN
    RAISE EXCEPTION USING
      ERRCODE = '42501',
      MESSAGE = 'Authentication required';
  END IF;

  SELECT
    GREATEST(l.xp_reward, 0),
    COUNT(e.id)::INTEGER
  INTO v_base_xp, v_exercise_count
  FROM public.lessons l
  LEFT JOIN public.exercises e ON e.lesson_id = l.id
  WHERE l.id = p_lesson_id
    AND l.status = 'published'
  GROUP BY l.id, l.xp_reward;

  IF NOT FOUND THEN
    RAISE EXCEPTION USING
      ERRCODE = '22023',
      MESSAGE = 'Lesson is unavailable';
  END IF;

  v_score := LEAST(100, GREATEST(0, COALESCE(p_score, 0)));
  v_xp_awarded := v_base_xp
    + CASE
        WHEN v_exercise_count > 0
          AND p_exercises_total = v_exercise_count
          AND p_exercises_correct = v_exercise_count
          AND v_score = 100
        THEN 5
        ELSE 0
      END;

  v_idempotency_key := v_user_id
    || ':lesson_complete:'
    || p_lesson_id
    || ':'
    || TO_CHAR(NOW() AT TIME ZONE 'Asia/Ho_Chi_Minh', 'YYYY-MM-DD');

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
    score = GREATEST(public.user_lesson_progress.score, EXCLUDED.score),
    xp_earned = public.user_lesson_progress.xp_earned + EXCLUDED.xp_earned,
    completed_at = NOW(),
    attempts = public.user_lesson_progress.attempts + 1;

  PERFORM public.reward_xp(
    v_user_id,
    v_xp_awarded,
    'lesson_complete',
    'lesson',
    p_lesson_id,
    v_idempotency_key
  );
  PERFORM public.update_user_streak(v_user_id);

  RETURN jsonb_build_object(
    'success', TRUE,
    'xp_earned', v_xp_awarded,
    'score', v_score
  );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = '';

REVOKE ALL ON FUNCTION public.complete_lesson(UUID, REAL, INTEGER, INTEGER, INTEGER)
  FROM PUBLIC, anon, authenticated;
GRANT EXECUTE ON FUNCTION public.complete_lesson(UUID, REAL, INTEGER, INTEGER, INTEGER)
  TO authenticated;
