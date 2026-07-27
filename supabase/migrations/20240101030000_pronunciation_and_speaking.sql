-- Phase 3: Pronunciation & Speaking Migration
-- Enhances pronunciation_attempts table
-- Adds tone training support
-- Adds usage tracking for speech API

-- ============================================
-- ENHANCE PRONUNCIATION ATTEMPTS
-- ============================================

-- Rename 'pronunciation_score' to 'overall_score' for consistency with app layer
DO $$
BEGIN
  IF EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_schema = 'public'
      AND table_name = 'pronunciation_attempts'
      AND column_name = 'pronunciation_score'
  ) AND NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_schema = 'public'
      AND table_name = 'pronunciation_attempts'
      AND column_name = 'overall_score'
  ) THEN
    ALTER TABLE pronunciation_attempts RENAME COLUMN pronunciation_score TO overall_score;
  END IF;
END $$;

-- Add missing columns to pronunciation_attempts
ALTER TABLE pronunciation_attempts ADD COLUMN IF NOT EXISTS exercise_id UUID REFERENCES exercises(id);
ALTER TABLE pronunciation_attempts ADD COLUMN IF NOT EXISTS lesson_id UUID REFERENCES lessons(id);
ALTER TABLE pronunciation_attempts ADD COLUMN IF NOT EXISTS vocabulary_id UUID REFERENCES vocabulary(id);
ALTER TABLE pronunciation_attempts ADD COLUMN IF NOT EXISTS recognized_text TEXT;
ALTER TABLE pronunciation_attempts ADD COLUMN IF NOT EXISTS locale TEXT NOT NULL DEFAULT 'zh-CN';
ALTER TABLE pronunciation_attempts ADD COLUMN IF NOT EXISTS provider TEXT NOT NULL DEFAULT 'azure';
ALTER TABLE pronunciation_attempts ADD COLUMN IF NOT EXISTS duration_ms INTEGER NOT NULL DEFAULT 0;
ALTER TABLE pronunciation_attempts ADD COLUMN IF NOT EXISTS attempt_number INTEGER NOT NULL DEFAULT 1;
ALTER TABLE pronunciation_attempts ADD COLUMN IF NOT EXISTS client_attempt_id TEXT;

-- Rename 'text' to 'reference_text' if it exists
DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'pronunciation_attempts' AND column_name = 'text') THEN
    ALTER TABLE pronunciation_attempts RENAME COLUMN text TO reference_text;
  END IF;
END $$;

-- Idempotency: prevent duplicate assessment for same client attempt
CREATE UNIQUE INDEX IF NOT EXISTS idx_pronunciation_client_attempt
  ON pronunciation_attempts(client_attempt_id)
  WHERE client_attempt_id IS NOT NULL;

-- Performance index
CREATE INDEX IF NOT EXISTS idx_pronunciation_user_vocab
  ON pronunciation_attempts(user_id, vocabulary_id, created_at DESC);

CREATE INDEX IF NOT EXISTS idx_pronunciation_user_score
  ON pronunciation_attempts(user_id, overall_score);

-- ============================================
-- TONE TRAINING DATA
-- ============================================

-- Tone exercises can reuse the exercise/lesson structure
-- Add tone-specific seed via exercise_type = 'tone_practice'
-- This just adds some helper views/data

CREATE TABLE IF NOT EXISTS tone_syllables (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  syllable TEXT NOT NULL,       -- base syllable without tone: "ma"
  tone INTEGER NOT NULL CHECK (tone BETWEEN 1 AND 5),
  pinyin TEXT NOT NULL,          -- full pinyin: "mā"
  hanzi TEXT,                    -- example character: "妈"
  meaning_vi TEXT,               -- "mẹ"
  audio_url TEXT,
  difficulty INTEGER NOT NULL DEFAULT 1, -- 1-5
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_tone_syllables_difficulty ON tone_syllables(difficulty, tone);

-- ============================================
-- PRONUNCIATION DAILY LIMITS
-- ============================================

-- Server function to check daily pronunciation limit
CREATE OR REPLACE FUNCTION check_pronunciation_limit(p_user_id UUID, p_daily_limit INTEGER DEFAULT 20)
RETURNS BOOLEAN AS $$
DECLARE
  v_count INTEGER;
BEGIN
  SELECT COUNT(*) INTO v_count
  FROM pronunciation_attempts
  WHERE user_id = p_user_id
    AND created_at >= CURRENT_DATE::TIMESTAMPTZ;

  RETURN v_count < p_daily_limit;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

GRANT EXECUTE ON FUNCTION check_pronunciation_limit TO authenticated;

-- ============================================
-- SPEAKING EXERCISE XP REWARD
-- ============================================

-- Function to reward XP for speaking exercise (idempotent)
CREATE OR REPLACE FUNCTION reward_speaking_xp(
  p_user_id UUID,
  p_exercise_id UUID,
  p_score REAL,
  p_passing_score REAL DEFAULT 60.0
)
RETURNS BOOLEAN AS $$
DECLARE
  v_idempotency_key TEXT;
  v_xp_amount INTEGER;
BEGIN
  -- Only reward if score passes threshold
  IF p_score < p_passing_score THEN
    RETURN FALSE;
  END IF;

  -- Idempotency: one XP reward per exercise per day
  v_idempotency_key := p_user_id || ':speaking:' || p_exercise_id || ':' ||
    TO_CHAR(NOW() AT TIME ZONE 'Asia/Ho_Chi_Minh', 'YYYY-MM-DD');

  -- Base 5 XP for speaking
  v_xp_amount := 5;

  -- Bonus for high score
  IF p_score >= 90 THEN
    v_xp_amount := v_xp_amount + 3;
  END IF;

  -- Use existing reward_xp function
  RETURN reward_xp(p_user_id, v_xp_amount, 'speaking_exercise', 'exercise', p_exercise_id, v_idempotency_key);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

GRANT EXECUTE ON FUNCTION reward_speaking_xp TO authenticated;

-- ============================================
-- SEED TONE DATA
-- ============================================

INSERT INTO tone_syllables (syllable, tone, pinyin, hanzi, meaning_vi, difficulty) VALUES
  ('ma', 1, 'mā', '妈', 'mẹ', 1),
  ('ma', 2, 'má', '麻', 'tê, gai', 1),
  ('ma', 3, 'mǎ', '马', 'ngựa', 1),
  ('ma', 4, 'mà', '骂', 'mắng', 1),
  ('ma', 5, 'ma', '吗', 'trợ từ nghi vấn', 1),
  ('ba', 1, 'bā', '八', 'tám', 1),
  ('ba', 2, 'bá', '拔', 'nhổ', 2),
  ('ba', 3, 'bǎ', '把', 'cầm', 1),
  ('ba', 4, 'bà', '爸', 'bố', 1),
  ('shi', 1, 'shī', '师', 'thầy', 2),
  ('shi', 2, 'shí', '十', 'mười', 1),
  ('shi', 3, 'shǐ', '使', 'khiến', 3),
  ('shi', 4, 'shì', '是', 'là', 1),
  ('tang', 1, 'tāng', '汤', 'canh', 2),
  ('tang', 2, 'táng', '糖', 'đường', 2),
  ('tang', 3, 'tǎng', '躺', 'nằm', 3),
  ('tang', 4, 'tàng', '烫', 'nóng, phỏng', 3),
  ('niu', 2, 'niú', '牛', 'bò', 2),
  ('nü', 3, 'nǚ', '女', 'nữ', 2),
  ('lü', 4, 'lǜ', '绿', 'xanh lá', 3)
ON CONFLICT DO NOTHING;

-- ============================================
-- SEED SPEAKING EXERCISES
-- ============================================

-- NOTE: Speaking exercises are seeded via supabase/seed/ files
-- because they reference lesson IDs created by course seed data.
-- Migrations must not reference seed-dependent IDs.
