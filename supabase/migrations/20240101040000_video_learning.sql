-- Phase 4: Video Learning Platform
-- Extends existing videos, video_subtitles, video_questions tables
-- Adds user progress, saved videos, video vocabulary

-- ============================================
-- EXTEND VIDEOS TABLE
-- ============================================

ALTER TABLE videos ADD COLUMN IF NOT EXISTS slug TEXT;
ALTER TABLE videos ADD COLUMN IF NOT EXISTS video_path TEXT; -- storage object path
ALTER TABLE videos ADD COLUMN IF NOT EXISTS thumbnail_path TEXT; -- storage object path
ALTER TABLE videos ADD COLUMN IF NOT EXISTS external_url TEXT;
ALTER TABLE videos ADD COLUMN IF NOT EXISTS source_type TEXT NOT NULL DEFAULT 'uploaded' CHECK (source_type IN ('uploaded', 'external_embed'));
ALTER TABLE videos ADD COLUMN IF NOT EXISTS playback_type TEXT NOT NULL DEFAULT 'progressive' CHECK (playback_type IN ('progressive', 'hls', 'external'));
ALTER TABLE videos ADD COLUMN IF NOT EXISTS is_premium BOOLEAN NOT NULL DEFAULT FALSE;
ALTER TABLE videos ADD COLUMN IF NOT EXISTS xp_reward INTEGER NOT NULL DEFAULT 20;
ALTER TABLE videos ADD COLUMN IF NOT EXISTS difficulty INTEGER NOT NULL DEFAULT 1;
ALTER TABLE videos ADD COLUMN IF NOT EXISTS processing_status TEXT NOT NULL DEFAULT 'ready' CHECK (processing_status IN ('pending', 'processing', 'ready', 'failed'));
ALTER TABLE videos ADD COLUMN IF NOT EXISTS processing_error TEXT;
ALTER TABLE videos ADD COLUMN IF NOT EXISTS published_at TIMESTAMPTZ;
ALTER TABLE videos ADD COLUMN IF NOT EXISTS updated_by UUID REFERENCES profiles(id);
ALTER TABLE videos ADD COLUMN IF NOT EXISTS subtitle_count INTEGER NOT NULL DEFAULT 0;
ALTER TABLE videos ADD COLUMN IF NOT EXISTS question_count INTEGER NOT NULL DEFAULT 0;

-- ============================================
-- EXTEND VIDEO_SUBTITLES
-- ============================================

-- Rename columns for consistency (start_time/end_time → start_ms/end_ms)
-- Keep existing columns and add new ones for backward compatibility
ALTER TABLE video_subtitles ADD COLUMN IF NOT EXISTS start_ms INTEGER;
ALTER TABLE video_subtitles ADD COLUMN IF NOT EXISTS end_ms INTEGER;
ALTER TABLE video_subtitles ADD COLUMN IF NOT EXISTS sequence INTEGER NOT NULL DEFAULT 0;
ALTER TABLE video_subtitles ADD COLUMN IF NOT EXISTS metadata JSONB;

-- Populate ms columns from existing float seconds
UPDATE video_subtitles SET start_ms = ROUND(start_time * 1000)::INTEGER WHERE start_ms IS NULL;
UPDATE video_subtitles SET end_ms = ROUND(end_time * 1000)::INTEGER WHERE end_ms IS NULL;

-- Index for efficient subtitle lookup by time
CREATE INDEX IF NOT EXISTS idx_video_subtitles_time ON video_subtitles(video_id, start_ms);

-- ============================================
-- EXTEND VIDEO_QUESTIONS
-- ============================================

ALTER TABLE video_questions ADD COLUMN IF NOT EXISTS timestamp_ms INTEGER;
ALTER TABLE video_questions ADD COLUMN IF NOT EXISTS question_type TEXT NOT NULL DEFAULT 'multiple_choice';
ALTER TABLE video_questions ADD COLUMN IF NOT EXISTS xp_reward INTEGER NOT NULL DEFAULT 5;
ALTER TABLE video_questions ADD COLUMN IF NOT EXISTS is_required BOOLEAN NOT NULL DEFAULT FALSE;
ALTER TABLE video_questions ADD COLUMN IF NOT EXISTS sequence INTEGER NOT NULL DEFAULT 0;

UPDATE video_questions SET timestamp_ms = ROUND(timestamp_seconds * 1000)::INTEGER WHERE timestamp_ms IS NULL;

CREATE INDEX IF NOT EXISTS idx_video_questions_time ON video_questions(video_id, timestamp_ms);

-- ============================================
-- VIDEO QUESTION OPTIONS (separate table for proper normalization)
-- ============================================

CREATE TABLE IF NOT EXISTS video_question_options (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  question_id UUID NOT NULL REFERENCES video_questions(id) ON DELETE CASCADE,
  text TEXT NOT NULL,
  is_correct BOOLEAN NOT NULL DEFAULT FALSE,
  sequence INTEGER NOT NULL DEFAULT 0
);

CREATE INDEX IF NOT EXISTS idx_vq_options ON video_question_options(question_id, sequence);

-- ============================================
-- USER VIDEO PROGRESS
-- ============================================

CREATE TABLE IF NOT EXISTS user_video_progress (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  video_id UUID NOT NULL REFERENCES videos(id) ON DELETE CASCADE,
  last_position_ms INTEGER NOT NULL DEFAULT 0,
  furthest_position_ms INTEGER NOT NULL DEFAULT 0,
  watch_time_ms INTEGER NOT NULL DEFAULT 0,
  progress_percent REAL NOT NULL DEFAULT 0,
  started_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  last_watched_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  completed_at TIMESTAMPTZ,
  questions_answered INTEGER NOT NULL DEFAULT 0,
  questions_correct INTEGER NOT NULL DEFAULT 0,
  UNIQUE(user_id, video_id)
);

CREATE INDEX IF NOT EXISTS idx_user_video_progress_recent ON user_video_progress(user_id, last_watched_at DESC);

-- ============================================
-- USER VIDEO QUESTION ATTEMPTS
-- ============================================

CREATE TABLE IF NOT EXISTS user_video_question_attempts (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  video_id UUID NOT NULL REFERENCES videos(id) ON DELETE CASCADE,
  question_id UUID NOT NULL REFERENCES video_questions(id) ON DELETE CASCADE,
  selected_answer TEXT NOT NULL,
  is_correct BOOLEAN NOT NULL,
  attempt_number INTEGER NOT NULL DEFAULT 1,
  answered_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_user_vq_attempts ON user_video_question_attempts(user_id, video_id, question_id);

-- ============================================
-- SAVED VIDEOS
-- ============================================

CREATE TABLE IF NOT EXISTS saved_videos (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  video_id UUID NOT NULL REFERENCES videos(id) ON DELETE CASCADE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE(user_id, video_id)
);

-- ============================================
-- VIDEO VOCABULARY (key words in videos)
-- ============================================

CREATE TABLE IF NOT EXISTS video_vocabulary (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  video_id UUID NOT NULL REFERENCES videos(id) ON DELETE CASCADE,
  vocabulary_id UUID NOT NULL REFERENCES vocabulary(id) ON DELETE CASCADE,
  first_timestamp_ms INTEGER,
  importance INTEGER NOT NULL DEFAULT 1,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE(video_id, vocabulary_id)
);

-- ============================================
-- RLS POLICIES
-- ============================================

ALTER TABLE video_question_options ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_video_progress ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_video_question_attempts ENABLE ROW LEVEL SECURITY;
ALTER TABLE saved_videos ENABLE ROW LEVEL SECURITY;
ALTER TABLE video_vocabulary ENABLE ROW LEVEL SECURITY;

-- Video question options: readable by authenticated
CREATE POLICY "VQ options readable" ON video_question_options FOR SELECT USING (auth.uid() IS NOT NULL);
CREATE POLICY "Editors manage VQ options" ON video_question_options FOR ALL USING (is_editor_or_above());

-- User video progress: own data only
CREATE POLICY "Own video progress" ON user_video_progress FOR ALL USING (user_id = auth.uid());

-- User video question attempts: own data only
CREATE POLICY "Own VQ attempts" ON user_video_question_attempts FOR ALL USING (user_id = auth.uid());

-- Saved videos: own data only
CREATE POLICY "Own saved videos" ON saved_videos FOR ALL USING (user_id = auth.uid());

-- Video vocabulary: readable by authenticated
CREATE POLICY "Video vocab readable" ON video_vocabulary FOR SELECT USING (auth.uid() IS NOT NULL);
CREATE POLICY "Editors manage video vocab" ON video_vocabulary FOR ALL USING (is_editor_or_above());

-- ============================================
-- VIDEO COMPLETION FUNCTION
-- ============================================

CREATE OR REPLACE FUNCTION complete_video(
  p_video_id UUID,
  p_watch_time_ms INTEGER,
  p_questions_answered INTEGER DEFAULT 0,
  p_questions_correct INTEGER DEFAULT 0
)
RETURNS BOOLEAN AS $$
DECLARE
  v_user_id UUID := auth.uid();
  v_xp_reward INTEGER;
  v_idempotency_key TEXT;
BEGIN
  -- Get video XP reward
  SELECT xp_reward INTO v_xp_reward FROM videos WHERE id = p_video_id;
  IF v_xp_reward IS NULL THEN
    RETURN FALSE;
  END IF;

  -- Update progress to completed
  INSERT INTO user_video_progress (user_id, video_id, watch_time_ms, progress_percent, completed_at, questions_answered, questions_correct)
  VALUES (v_user_id, p_video_id, p_watch_time_ms, 100, NOW(), p_questions_answered, p_questions_correct)
  ON CONFLICT (user_id, video_id)
  DO UPDATE SET
    watch_time_ms = user_video_progress.watch_time_ms + p_watch_time_ms,
    progress_percent = 100,
    completed_at = NOW(),
    questions_answered = p_questions_answered,
    questions_correct = p_questions_correct,
    last_watched_at = NOW();

  -- Reward XP (idempotent per video)
  v_idempotency_key := v_user_id || ':video_complete:' || p_video_id;
  PERFORM reward_xp(v_user_id, v_xp_reward, 'video_complete', 'video', p_video_id, v_idempotency_key);

  -- Update streak
  PERFORM update_user_streak(v_user_id);

  RETURN TRUE;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

GRANT EXECUTE ON FUNCTION complete_video TO authenticated;

-- ============================================
-- SEED VIDEO DATA
-- ============================================

INSERT INTO videos (id, title, description, video_url, level, category, duration_seconds, status, xp_reward, source_type) VALUES
  ('a1d00000-0000-0000-0000-000000000001', '你好！第一次见面', '学习基本的中文打招呼方式。Học cách chào hỏi cơ bản trong tiếng Trung.', '', 'starter', 'greetings', 180, 'published', 15, 'uploaded'),
  ('a1d00000-0000-0000-0000-000000000002', '在咖啡店点饮料', '学会在咖啡店用中文点饮料。Học cách gọi đồ uống ở quán cà phê bằng tiếng Trung.', '', 'beginner', 'daily_life', 240, 'published', 20, 'uploaded'),
  ('a1d00000-0000-0000-0000-000000000003', '我的一天', '描述你的日常生活。Mô tả cuộc sống hàng ngày của bạn.', '', 'elementary', 'daily_life', 300, 'published', 25, 'uploaded')
ON CONFLICT (id) DO NOTHING;

-- Seed subtitles for Video 1
INSERT INTO video_subtitles (video_id, start_time, end_time, start_ms, end_ms, chinese_text, pinyin, vietnamese_text, sequence) VALUES
  ('a1d00000-0000-0000-0000-000000000001', 0, 3, 0, 3000, '你好！', 'nǐ hǎo!', 'Xin chào!', 1),
  ('a1d00000-0000-0000-0000-000000000001', 3, 6, 3000, 6000, '我叫小明。', 'wǒ jiào xiǎo míng.', 'Tôi tên là Tiểu Minh.', 2),
  ('a1d00000-0000-0000-0000-000000000001', 6, 9, 6000, 9000, '你叫什么名字？', 'nǐ jiào shénme míngzì?', 'Bạn tên gì?', 3),
  ('a1d00000-0000-0000-0000-000000000001', 9, 12, 9000, 12000, '很高兴认识你。', 'hěn gāoxìng rènshí nǐ.', 'Rất vui được biết bạn.', 4),
  ('a1d00000-0000-0000-0000-000000000001', 12, 15, 12000, 15000, '你好，再见！', 'nǐ hǎo, zàijiàn!', 'Xin chào, tạm biệt!', 5)
ON CONFLICT DO NOTHING;

-- Seed questions for Video 1
INSERT INTO video_questions (id, video_id, timestamp_seconds, timestamp_ms, question, correct_answer, question_type, options, is_required, sequence) VALUES
  ('b2000000-0000-0000-0000-000000000001', 'a1d00000-0000-0000-0000-000000000001', 6, 6000, '"我叫小明" nghĩa là gì?', 'Tôi tên là Tiểu Minh', 'multiple_choice', '["Tôi tên là Tiểu Minh", "Tôi thích Tiểu Minh", "Tôi gọi Tiểu Minh", "Tôi là giáo viên"]'::jsonb, true, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO video_question_options (question_id, text, is_correct, sequence) VALUES
  ('b2000000-0000-0000-0000-000000000001', 'Tôi tên là Tiểu Minh', TRUE, 1),
  ('b2000000-0000-0000-0000-000000000001', 'Tôi thích Tiểu Minh', FALSE, 2),
  ('b2000000-0000-0000-0000-000000000001', 'Tôi gọi Tiểu Minh', FALSE, 3),
  ('b2000000-0000-0000-0000-000000000001', 'Tôi là giáo viên', FALSE, 4)
ON CONFLICT DO NOTHING;
