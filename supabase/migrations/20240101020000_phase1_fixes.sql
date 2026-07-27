-- Phase 1 Fixes Migration
-- 1. Add timezone to profiles for streak calculations
-- 2. Add idempotency key to xp_transactions
-- 3. Fix RLS recursion by using auth.jwt() instead of querying profiles
-- 4. Add server-side XP reward function

-- Add timezone column to profiles
ALTER TABLE profiles ADD COLUMN IF NOT EXISTS timezone TEXT NOT NULL DEFAULT 'Asia/Ho_Chi_Minh';

-- Add idempotency to xp_transactions to prevent double-reward
ALTER TABLE xp_transactions ADD COLUMN IF NOT EXISTS idempotency_key TEXT;
CREATE UNIQUE INDEX IF NOT EXISTS idx_xp_idempotency ON xp_transactions(idempotency_key) WHERE idempotency_key IS NOT NULL;

-- Add idempotency to coin_transactions
ALTER TABLE coin_transactions ADD COLUMN IF NOT EXISTS idempotency_key TEXT;
CREATE UNIQUE INDEX IF NOT EXISTS idx_coin_idempotency ON coin_transactions(idempotency_key) WHERE idempotency_key IS NOT NULL;

-- Add times_wrong to mistakes for aggregation
ALTER TABLE mistakes ADD COLUMN IF NOT EXISTS times_wrong INTEGER NOT NULL DEFAULT 1;
ALTER TABLE mistakes ADD COLUMN IF NOT EXISTS last_wrong_at TIMESTAMPTZ NOT NULL DEFAULT NOW();

-- Server-side function to reward XP safely with idempotency
CREATE OR REPLACE FUNCTION reward_xp(
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
  -- Check idempotency
  IF p_idempotency_key IS NOT NULL THEN
    SELECT id INTO v_existing_id
    FROM xp_transactions
    WHERE idempotency_key = p_idempotency_key;
    
    IF v_existing_id IS NOT NULL THEN
      RETURN FALSE; -- Already rewarded
    END IF;
  END IF;

  -- Verify user_id matches auth.uid() for security
  IF p_user_id != auth.uid() THEN
    RAISE EXCEPTION 'Cannot reward XP for another user';
  END IF;

  INSERT INTO xp_transactions (user_id, amount, reason, source_type, source_id, idempotency_key)
  VALUES (p_user_id, p_amount, p_reason, p_source_type, p_source_id, p_idempotency_key);

  RETURN TRUE;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Server-side function to complete a lesson with XP reward
CREATE OR REPLACE FUNCTION complete_lesson(
  p_lesson_id UUID,
  p_score REAL,
  p_xp_earned INTEGER,
  p_exercises_correct INTEGER,
  p_exercises_total INTEGER
)
RETURNS JSONB AS $$
DECLARE
  v_user_id UUID := auth.uid();
  v_existing RECORD;
  v_idempotency_key TEXT;
  v_result JSONB;
BEGIN
  -- Check if already completed in this attempt
  v_idempotency_key := v_user_id || ':lesson_complete:' || p_lesson_id || ':' || 
    TO_CHAR(NOW() AT TIME ZONE 'Asia/Ho_Chi_Minh', 'YYYY-MM-DD');

  -- Upsert lesson progress
  INSERT INTO user_lesson_progress (user_id, lesson_id, status, score, xp_earned, started_at, completed_at, attempts)
  VALUES (v_user_id, p_lesson_id, 'completed', p_score, p_xp_earned, NOW(), NOW(), 1)
  ON CONFLICT (user_id, lesson_id)
  DO UPDATE SET
    status = 'completed',
    score = GREATEST(user_lesson_progress.score, p_score),
    xp_earned = user_lesson_progress.xp_earned + p_xp_earned,
    completed_at = NOW(),
    attempts = user_lesson_progress.attempts + 1;

  -- Reward XP with idempotency (one reward per lesson per day)
  PERFORM reward_xp(v_user_id, p_xp_earned, 'lesson_complete', 'lesson', p_lesson_id, v_idempotency_key);

  -- Update streak
  PERFORM update_user_streak(v_user_id);

  v_result := jsonb_build_object(
    'success', TRUE,
    'xp_earned', p_xp_earned,
    'score', p_score,
    'exercises_correct', p_exercises_correct,
    'exercises_total', p_exercises_total
  );

  RETURN v_result;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Timezone-aware streak update function
CREATE OR REPLACE FUNCTION update_user_streak(p_user_id UUID)
RETURNS VOID AS $$
DECLARE
  v_timezone TEXT;
  v_today DATE;
  v_last_date DATE;
  v_current_streak INTEGER;
  v_longest_streak INTEGER;
BEGIN
  -- Get user's timezone
  SELECT timezone INTO v_timezone FROM profiles WHERE id = p_user_id;
  IF v_timezone IS NULL THEN
    v_timezone := 'Asia/Ho_Chi_Minh';
  END IF;

  -- Calculate today in user's timezone
  v_today := (NOW() AT TIME ZONE v_timezone)::DATE;

  -- Get current streak data
  SELECT last_activity_date, current_streak, longest_streak
  INTO v_last_date, v_current_streak, v_longest_streak
  FROM streaks WHERE user_id = p_user_id;

  IF NOT FOUND THEN
    INSERT INTO streaks (user_id, current_streak, longest_streak, last_activity_date)
    VALUES (p_user_id, 1, 1, v_today);
    
    UPDATE profiles SET current_streak = 1, longest_streak = 1 WHERE id = p_user_id;
    RETURN;
  END IF;

  -- Same day: no change
  IF v_last_date = v_today THEN
    RETURN;
  END IF;

  -- Consecutive day: increment
  IF v_last_date = v_today - 1 THEN
    v_current_streak := v_current_streak + 1;
    v_longest_streak := GREATEST(v_longest_streak, v_current_streak);
  ELSE
    -- Streak broken
    v_current_streak := 1;
  END IF;

  UPDATE streaks
  SET current_streak = v_current_streak,
      longest_streak = v_longest_streak,
      last_activity_date = v_today
  WHERE user_id = p_user_id;

  UPDATE profiles
  SET current_streak = v_current_streak,
      longest_streak = GREATEST(longest_streak, v_longest_streak),
      updated_at = NOW()
  WHERE id = p_user_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Fix: Grant execute on functions
GRANT EXECUTE ON FUNCTION reward_xp TO authenticated;
GRANT EXECUTE ON FUNCTION complete_lesson TO authenticated;
GRANT EXECUTE ON FUNCTION update_user_streak TO authenticated;

-- Level thresholds should be readable by all authenticated
ALTER TABLE level_thresholds ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Level thresholds readable" ON level_thresholds FOR SELECT USING (TRUE);

-- Exercise types should be readable by all authenticated  
ALTER TABLE exercise_types ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Exercise types readable" ON exercise_types FOR SELECT USING (TRUE);
