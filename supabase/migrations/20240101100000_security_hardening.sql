-- Migration 011: Security Hardening
-- 1. Revoke pronunciation_attempts INSERT from authenticated
-- 2. Fix SECURITY DEFINER functions with SET search_path = ''
-- 3. Service role grants for server-managed tables
-- 4. Voice XP trust hardening

-- ============================================
-- 1. REVOKE PRONUNCIATION CLIENT INSERT
-- ============================================
REVOKE INSERT, UPDATE, DELETE ON public.pronunciation_attempts FROM authenticated;
-- authenticated retains SELECT only (via grants migration)

-- ============================================
-- 2. FIX ALL SECURITY DEFINER FUNCTIONS — SET search_path = ''
-- Recreate with explicit schema qualification + safe search_path
-- ============================================

-- handle_new_user
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.profiles (id, email)
  VALUES (NEW.id, NEW.email);
  INSERT INTO public.streaks (user_id)
  VALUES (NEW.id);
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = '';

-- update_total_xp
CREATE OR REPLACE FUNCTION public.update_total_xp()
RETURNS TRIGGER AS $$
BEGIN
  UPDATE public.profiles
  SET total_xp = total_xp + NEW.amount, updated_at = NOW()
  WHERE id = NEW.user_id;
  UPDATE public.profiles
  SET current_level = (
    SELECT MAX(level) FROM public.level_thresholds
    WHERE xp_required <= (SELECT total_xp FROM public.profiles WHERE id = NEW.user_id)
  )
  WHERE id = NEW.user_id;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = '';

-- update_total_coins
CREATE OR REPLACE FUNCTION public.update_total_coins()
RETURNS TRIGGER AS $$
BEGIN
  UPDATE public.profiles
  SET total_coins = total_coins + NEW.amount, updated_at = NOW()
  WHERE id = NEW.user_id;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = '';

-- reward_xp
CREATE OR REPLACE FUNCTION public.reward_xp(
  p_user_id UUID,
  p_amount INTEGER,
  p_reason TEXT,
  p_source_type TEXT,
  p_source_id UUID DEFAULT NULL,
  p_idempotency_key TEXT DEFAULT NULL
)
RETURNS BOOLEAN AS $$
DECLARE
  v_existing_id UUID;
BEGIN
  IF p_idempotency_key IS NOT NULL THEN
    SELECT id INTO v_existing_id FROM public.xp_transactions WHERE idempotency_key = p_idempotency_key;
    IF v_existing_id IS NOT NULL THEN RETURN FALSE; END IF;
  END IF;
  IF p_user_id != auth.uid() THEN RAISE EXCEPTION 'Cannot reward XP for another user'; END IF;
  INSERT INTO public.xp_transactions (user_id, amount, reason, source_type, source_id, idempotency_key)
  VALUES (p_user_id, p_amount, p_reason, p_source_type, p_source_id, p_idempotency_key);
  RETURN TRUE;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = '';

-- update_user_streak
CREATE OR REPLACE FUNCTION public.update_user_streak(p_user_id UUID)
RETURNS VOID AS $$
DECLARE
  v_timezone TEXT; v_today DATE; v_last_date DATE; v_current_streak INTEGER; v_longest_streak INTEGER;
BEGIN
  SELECT timezone INTO v_timezone FROM public.profiles WHERE id = p_user_id;
  IF v_timezone IS NULL THEN v_timezone := 'Asia/Ho_Chi_Minh'; END IF;
  v_today := (NOW() AT TIME ZONE v_timezone)::DATE;
  SELECT last_activity_date, current_streak, longest_streak INTO v_last_date, v_current_streak, v_longest_streak
  FROM public.streaks WHERE user_id = p_user_id;
  IF NOT FOUND THEN
    INSERT INTO public.streaks (user_id, current_streak, longest_streak, last_activity_date) VALUES (p_user_id, 1, 1, v_today);
    UPDATE public.profiles SET current_streak = 1, longest_streak = 1 WHERE id = p_user_id; RETURN;
  END IF;
  IF v_last_date = v_today THEN RETURN; END IF;
  IF v_last_date = v_today - 1 THEN
    v_current_streak := v_current_streak + 1; v_longest_streak := GREATEST(v_longest_streak, v_current_streak);
  ELSE v_current_streak := 1; END IF;
  UPDATE public.streaks SET current_streak = v_current_streak, longest_streak = v_longest_streak, last_activity_date = v_today WHERE user_id = p_user_id;
  UPDATE public.profiles SET current_streak = v_current_streak, longest_streak = GREATEST(longest_streak, v_longest_streak), updated_at = NOW() WHERE id = p_user_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = '';

-- complete_lesson
CREATE OR REPLACE FUNCTION public.complete_lesson(
  p_lesson_id UUID, p_score REAL, p_xp_earned INTEGER, p_exercises_correct INTEGER, p_exercises_total INTEGER
)
RETURNS JSONB AS $$
DECLARE
  v_user_id UUID := auth.uid(); v_idempotency_key TEXT;
BEGIN
  v_idempotency_key := v_user_id || ':lesson_complete:' || p_lesson_id || ':' || TO_CHAR(NOW() AT TIME ZONE 'Asia/Ho_Chi_Minh', 'YYYY-MM-DD');
  INSERT INTO public.user_lesson_progress (user_id, lesson_id, status, score, xp_earned, started_at, completed_at, attempts)
  VALUES (v_user_id, p_lesson_id, 'completed', p_score, p_xp_earned, NOW(), NOW(), 1)
  ON CONFLICT (user_id, lesson_id) DO UPDATE SET status = 'completed', score = GREATEST(public.user_lesson_progress.score, p_score), xp_earned = public.user_lesson_progress.xp_earned + p_xp_earned, completed_at = NOW(), attempts = public.user_lesson_progress.attempts + 1;
  PERFORM public.reward_xp(v_user_id, p_xp_earned, 'lesson_complete', 'lesson', p_lesson_id, v_idempotency_key);
  PERFORM public.update_user_streak(v_user_id);
  RETURN jsonb_build_object('success', TRUE, 'xp_earned', p_xp_earned, 'score', p_score);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = '';

-- complete_video
CREATE OR REPLACE FUNCTION public.complete_video(
  p_video_id UUID, p_watch_time_ms INTEGER, p_questions_answered INTEGER DEFAULT 0, p_questions_correct INTEGER DEFAULT 0
)
RETURNS BOOLEAN AS $$
DECLARE
  v_user_id UUID := auth.uid(); v_xp_reward INTEGER; v_idempotency_key TEXT;
BEGIN
  SELECT xp_reward INTO v_xp_reward FROM public.videos WHERE id = p_video_id;
  IF v_xp_reward IS NULL THEN RETURN FALSE; END IF;
  INSERT INTO public.user_video_progress (user_id, video_id, watch_time_ms, progress_percent, completed_at, questions_answered, questions_correct)
  VALUES (v_user_id, p_video_id, p_watch_time_ms, 100, NOW(), p_questions_answered, p_questions_correct)
  ON CONFLICT (user_id, video_id) DO UPDATE SET watch_time_ms = public.user_video_progress.watch_time_ms + p_watch_time_ms, progress_percent = 100, completed_at = NOW(), questions_answered = p_questions_answered, questions_correct = p_questions_correct, last_watched_at = NOW();
  v_idempotency_key := v_user_id || ':video_complete:' || p_video_id;
  PERFORM public.reward_xp(v_user_id, v_xp_reward, 'video_complete', 'video', p_video_id, v_idempotency_key);
  PERFORM public.update_user_streak(v_user_id);
  RETURN TRUE;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = '';

-- complete_voice_session (HARDENED: verify turn count from server data)
CREATE OR REPLACE FUNCTION public.complete_voice_session(
  p_session_id UUID, p_total_duration_ms INTEGER, p_user_speech_ms INTEGER, p_ai_speech_ms INTEGER, p_turn_count INTEGER
)
RETURNS BOOLEAN AS $$
DECLARE
  v_user_id UUID := auth.uid();
  v_idempotency_key TEXT;
  v_actual_turns INTEGER;
  v_min_speech_ms INTEGER := 30000;
  v_min_turns INTEGER := 3;
BEGIN
  -- Verify session belongs to user
  IF NOT EXISTS (SELECT 1 FROM public.voice_sessions WHERE id = p_session_id AND user_id = v_user_id) THEN
    RETURN FALSE;
  END IF;
  -- Count actual server-persisted turns (cannot be faked by client)
  SELECT COUNT(*) INTO v_actual_turns FROM public.voice_turns WHERE session_id = p_session_id AND user_id = v_user_id;
  -- Update session
  UPDATE public.voice_sessions SET status = 'completed', ended_at = NOW(), total_duration_ms = p_total_duration_ms, user_speech_ms = p_user_speech_ms, ai_speech_ms = p_ai_speech_ms, turn_count = v_actual_turns WHERE id = p_session_id AND user_id = v_user_id;
  -- XP only if server-verified turns meet threshold
  IF p_user_speech_ms >= v_min_speech_ms AND v_actual_turns >= v_min_turns THEN
    v_idempotency_key := v_user_id || ':voice_session:' || p_session_id;
    PERFORM public.reward_xp(v_user_id, 10, 'voice_session', 'voice_session', p_session_id, v_idempotency_key);
  END IF;
  PERFORM public.update_user_streak(v_user_id);
  RETURN TRUE;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = '';

-- purchase_shop_item
CREATE OR REPLACE FUNCTION public.purchase_shop_item(p_item_id UUID, p_idempotency_key TEXT)
RETURNS JSONB AS $$
DECLARE
  v_user_id UUID := auth.uid(); v_item RECORD; v_balance INTEGER;
BEGIN
  IF EXISTS (SELECT 1 FROM public.shop_purchases WHERE idempotency_key = p_idempotency_key) THEN
    RETURN jsonb_build_object('success', FALSE, 'error', 'already_purchased');
  END IF;
  SELECT * INTO v_item FROM public.shop_items WHERE id = p_item_id AND is_active;
  IF NOT FOUND THEN RETURN jsonb_build_object('success', FALSE, 'error', 'item_not_found'); END IF;
  v_balance := (SELECT total_coins FROM public.profiles WHERE id = v_user_id);
  IF v_balance < v_item.price_coins THEN RETURN jsonb_build_object('success', FALSE, 'error', 'insufficient_coins'); END IF;
  INSERT INTO public.coin_transactions (user_id, amount, reason, source_type, source_id, idempotency_key) VALUES (v_user_id, -v_item.price_coins, 'shop_purchase', 'shop_item', p_item_id, p_idempotency_key);
  INSERT INTO public.user_inventory (user_id, item_id, quantity) VALUES (v_user_id, p_item_id, 1) ON CONFLICT (user_id, item_id) DO UPDATE SET quantity = public.user_inventory.quantity + 1, updated_at = NOW();
  INSERT INTO public.shop_purchases (user_id, item_id, price_paid, idempotency_key) VALUES (v_user_id, p_item_id, v_item.price_coins, p_idempotency_key);
  RETURN jsonb_build_object('success', TRUE, 'item', v_item.code);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = '';

-- get_gamification_summary
CREATE OR REPLACE FUNCTION public.get_gamification_summary()
RETURNS JSONB AS $$
DECLARE
  v_user_id UUID := auth.uid(); v_profile RECORD; v_streak RECORD; v_today_xp INTEGER; v_boost_active BOOLEAN;
BEGIN
  SELECT total_xp, total_coins, current_level, hearts, daily_goal_xp INTO v_profile FROM public.profiles WHERE id = v_user_id;
  SELECT current_streak, longest_streak INTO v_streak FROM public.streaks WHERE user_id = v_user_id;
  SELECT COALESCE(SUM(amount), 0) INTO v_today_xp FROM public.xp_transactions WHERE user_id = v_user_id AND created_at >= CURRENT_DATE::TIMESTAMPTZ;
  v_boost_active := EXISTS (SELECT 1 FROM public.active_boosts WHERE user_id = v_user_id AND expires_at > NOW());
  RETURN jsonb_build_object('level', v_profile.current_level, 'totalXp', v_profile.total_xp, 'coins', v_profile.total_coins, 'hearts', v_profile.hearts, 'dailyGoalXp', v_profile.daily_goal_xp, 'todayXp', v_today_xp, 'streak', COALESCE(v_streak.current_streak, 0), 'longestStreak', COALESCE(v_streak.longest_streak, 0), 'boostActive', v_boost_active);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = '';

-- publish_content
CREATE OR REPLACE FUNCTION public.publish_content(p_entity_type TEXT, p_entity_id UUID, p_change_summary TEXT DEFAULT NULL)
RETURNS BOOLEAN AS $$
DECLARE
  v_user_id UUID := auth.uid(); v_snapshot JSONB; v_version INTEGER;
BEGIN
  IF NOT public.is_editor_or_above() THEN RAISE EXCEPTION 'Permission denied'; END IF;
  SELECT COALESCE(MAX(version_number), 0) + 1 INTO v_version FROM public.content_versions WHERE entity_type = p_entity_type AND entity_id = p_entity_id;
  CASE p_entity_type
    WHEN 'course' THEN SELECT to_jsonb(c.*) INTO v_snapshot FROM public.courses c WHERE c.id = p_entity_id; UPDATE public.courses SET status = 'published', updated_at = NOW() WHERE id = p_entity_id;
    WHEN 'lesson' THEN SELECT to_jsonb(l.*) INTO v_snapshot FROM public.lessons l WHERE l.id = p_entity_id; UPDATE public.lessons SET status = 'published', updated_at = NOW() WHERE id = p_entity_id;
    WHEN 'vocabulary' THEN SELECT to_jsonb(v.*) INTO v_snapshot FROM public.vocabulary v WHERE v.id = p_entity_id; UPDATE public.vocabulary SET status = 'published', updated_at = NOW() WHERE id = p_entity_id;
    WHEN 'video' THEN SELECT to_jsonb(v.*) INTO v_snapshot FROM public.videos v WHERE v.id = p_entity_id; UPDATE public.videos SET status = 'published', updated_at = NOW() WHERE id = p_entity_id;
    ELSE RAISE EXCEPTION 'Unknown entity type: %', p_entity_type;
  END CASE;
  INSERT INTO public.content_versions (entity_type, entity_id, version_number, snapshot, change_summary, created_by) VALUES (p_entity_type, p_entity_id, v_version, v_snapshot, p_change_summary, v_user_id);
  INSERT INTO public.admin_activity_logs (user_id, action, resource_type, resource_id, entity_type, details) VALUES (v_user_id, 'PUBLISH', p_entity_type, p_entity_id, p_entity_type, jsonb_build_object('version', v_version, 'summary', p_change_summary));
  RETURN TRUE;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = '';

-- get_admin_dashboard
CREATE OR REPLACE FUNCTION public.get_admin_dashboard()
RETURNS JSONB AS $$
BEGIN
  IF NOT public.is_admin() THEN RAISE EXCEPTION 'Permission denied'; END IF;
  RETURN jsonb_build_object(
    'totalUsers', (SELECT COUNT(*) FROM public.profiles),
    'activeToday', (SELECT COUNT(DISTINCT user_id) FROM public.study_sessions WHERE started_at >= CURRENT_DATE::TIMESTAMPTZ),
    'publishedCourses', (SELECT COUNT(*) FROM public.courses WHERE status = 'published'),
    'publishedLessons', (SELECT COUNT(*) FROM public.lessons WHERE status = 'published'),
    'publishedVocabulary', (SELECT COUNT(*) FROM public.vocabulary WHERE status = 'published'),
    'publishedVideos', (SELECT COUNT(*) FROM public.videos WHERE status = 'published'),
    'contentInReview', (SELECT COUNT(*) FROM public.courses WHERE status = 'review') + (SELECT COUNT(*) FROM public.lessons WHERE status = 'review') + (SELECT COUNT(*) FROM public.vocabulary WHERE status = 'review'),
    'todayXpTotal', (SELECT COALESCE(SUM(amount), 0) FROM public.xp_transactions WHERE created_at >= CURRENT_DATE::TIMESTAMPTZ),
    'todayLessonsCompleted', (SELECT COUNT(*) FROM public.user_lesson_progress WHERE completed_at >= CURRENT_DATE::TIMESTAMPTZ),
    'todayAiSessions', (SELECT COUNT(*) FROM public.ai_conversations WHERE created_at >= CURRENT_DATE::TIMESTAMPTZ)
  );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = '';

-- is_admin
CREATE OR REPLACE FUNCTION public.is_admin()
RETURNS BOOLEAN AS $$
BEGIN
  RETURN EXISTS (SELECT 1 FROM public.profiles WHERE id = auth.uid() AND role IN ('admin', 'super_admin'));
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = '';

-- is_editor_or_above
CREATE OR REPLACE FUNCTION public.is_editor_or_above()
RETURNS BOOLEAN AS $$
BEGIN
  RETURN EXISTS (SELECT 1 FROM public.profiles WHERE id = auth.uid() AND role IN ('editor', 'admin', 'super_admin'));
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = '';

-- check_pronunciation_limit
CREATE OR REPLACE FUNCTION public.check_pronunciation_limit(p_user_id UUID, p_daily_limit INTEGER DEFAULT 20)
RETURNS BOOLEAN AS $$
DECLARE v_count INTEGER;
BEGIN
  -- Server-internal: called by Edge Functions with service_role.
  -- If called by authenticated, enforce own user only.
  IF current_setting('request.jwt.claim.role', true) = 'authenticated' THEN
    IF p_user_id IS DISTINCT FROM auth.uid() THEN
      RAISE EXCEPTION 'Unauthorized: cannot check other user quota';
    END IF;
  END IF;
  SELECT COUNT(*) INTO v_count FROM public.pronunciation_attempts WHERE user_id = p_user_id AND created_at >= CURRENT_DATE::TIMESTAMPTZ;
  RETURN v_count < p_daily_limit;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = '';

-- check_voice_daily_limit
CREATE OR REPLACE FUNCTION public.check_voice_daily_limit(p_user_id UUID, p_daily_limit_ms INTEGER DEFAULT 300000)
RETURNS BOOLEAN AS $$
DECLARE v_used_ms INTEGER;
BEGIN
  -- Validate caller can only check own quota
  IF p_user_id IS DISTINCT FROM auth.uid() THEN
    RAISE EXCEPTION 'Unauthorized: cannot check other user quota';
  END IF;
  SELECT COALESCE(SUM(user_speech_ms), 0) INTO v_used_ms FROM public.voice_sessions WHERE user_id = p_user_id AND created_at >= CURRENT_DATE::TIMESTAMPTZ;
  RETURN v_used_ms < p_daily_limit_ms;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = '';

-- check_ai_daily_limit
CREATE OR REPLACE FUNCTION public.check_ai_daily_limit(p_user_id UUID)
RETURNS BOOLEAN AS $$
DECLARE v_limit INTEGER; v_count INTEGER;
BEGIN
  -- Server-internal: called by Edge Functions with service_role.
  -- If called by authenticated, enforce own user only.
  IF current_setting('request.jwt.claim.role', true) = 'authenticated' THEN
    IF p_user_id IS DISTINCT FROM auth.uid() THEN
      RAISE EXCEPTION 'Unauthorized: cannot check other user quota';
    END IF;
  END IF;
  SELECT COALESCE(daily_message_limit, 20) INTO v_limit FROM public.ai_user_settings WHERE user_id = p_user_id;
  IF v_limit IS NULL THEN v_limit := 20; END IF;
  SELECT COUNT(*) INTO v_count FROM public.ai_messages WHERE user_id = p_user_id AND role = 'user' AND created_at >= CURRENT_DATE::TIMESTAMPTZ;
  RETURN v_count < v_limit;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = '';

-- reward_speaking_xp
CREATE OR REPLACE FUNCTION public.reward_speaking_xp(p_user_id UUID, p_exercise_id UUID, p_score REAL, p_passing_score REAL DEFAULT 60.0)
RETURNS BOOLEAN AS $$
DECLARE v_idempotency_key TEXT; v_xp_amount INTEGER;
BEGIN
  IF p_score < p_passing_score THEN RETURN FALSE; END IF;
  v_idempotency_key := p_user_id || ':speaking:' || p_exercise_id || ':' || TO_CHAR(NOW() AT TIME ZONE 'Asia/Ho_Chi_Minh', 'YYYY-MM-DD');
  v_xp_amount := 5;
  IF p_score >= 90 THEN v_xp_amount := v_xp_amount + 3; END IF;
  RETURN public.reward_xp(p_user_id, v_xp_amount, 'speaking_exercise', 'exercise', p_exercise_id, v_idempotency_key);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = '';

-- ============================================
-- 3. SERVICE_ROLE GRANTS (for Edge Functions)
-- ============================================
-- Edge Functions use service_role key which bypasses RLS.
-- Explicit table grants for clarity and documentation:
GRANT SELECT, INSERT ON public.pronunciation_attempts TO service_role;
GRANT SELECT, INSERT, UPDATE ON public.ai_messages TO service_role;
GRANT SELECT, INSERT ON public.ai_usage TO service_role;
GRANT SELECT, INSERT ON public.voice_usage TO service_role;
GRANT SELECT, INSERT ON public.usage_tracking TO service_role;
GRANT SELECT, UPDATE ON public.ai_conversations TO service_role;
GRANT SELECT ON public.profiles TO service_role;
GRANT SELECT ON public.user_vocabulary_progress TO service_role;
GRANT SELECT ON public.mistakes TO service_role;
GRANT SELECT ON public.ai_user_settings TO service_role;

-- ============================================
-- 4. RE-GRANT FUNCTION EXECUTE (after full revoke in prev migration)
-- ============================================
GRANT EXECUTE ON FUNCTION public.reward_xp(UUID, INTEGER, TEXT, TEXT, UUID, TEXT) TO authenticated;
GRANT EXECUTE ON FUNCTION public.complete_lesson(UUID, REAL, INTEGER, INTEGER, INTEGER) TO authenticated;
GRANT EXECUTE ON FUNCTION public.complete_video(UUID, INTEGER, INTEGER, INTEGER) TO authenticated;
GRANT EXECUTE ON FUNCTION public.complete_voice_session(UUID, INTEGER, INTEGER, INTEGER, INTEGER) TO authenticated;
-- update_user_streak: INTERNAL ONLY — called by complete_lesson/video/voice, NOT by client
-- REVOKE from authenticated (no grant)
GRANT EXECUTE ON FUNCTION public.purchase_shop_item(UUID, TEXT) TO authenticated;
GRANT EXECUTE ON FUNCTION public.get_gamification_summary() TO authenticated;
GRANT EXECUTE ON FUNCTION public.publish_content(TEXT, UUID, TEXT) TO authenticated;
GRANT EXECUTE ON FUNCTION public.get_admin_dashboard() TO authenticated;
GRANT EXECUTE ON FUNCTION public.check_pronunciation_limit(UUID, INTEGER) TO authenticated;
GRANT EXECUTE ON FUNCTION public.check_voice_daily_limit(UUID, INTEGER) TO authenticated;
GRANT EXECUTE ON FUNCTION public.check_ai_daily_limit(UUID) TO authenticated;
GRANT EXECUTE ON FUNCTION public.reward_speaking_xp(UUID, UUID, REAL, REAL) TO authenticated;
GRANT EXECUTE ON FUNCTION public.is_admin() TO authenticated;
GRANT EXECUTE ON FUNCTION public.is_editor_or_above() TO authenticated;
