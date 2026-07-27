-- Mandarin Master Database Schema
-- Migration 001: Initial Schema


-- ============================================
-- PROFILES & AUTH
-- ============================================

CREATE TABLE profiles (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  email TEXT NOT NULL,
  username TEXT UNIQUE,
  display_name TEXT,
  avatar_url TEXT,
  role TEXT NOT NULL DEFAULT 'student' CHECK (role IN ('student', 'teacher', 'editor', 'admin', 'super_admin')),
  native_language TEXT NOT NULL DEFAULT 'vi',
  chinese_level TEXT NOT NULL DEFAULT 'starter',
  daily_goal_minutes INTEGER NOT NULL DEFAULT 15,
  daily_goal_xp INTEGER NOT NULL DEFAULT 30,
  learning_purpose TEXT,
  onboarding_completed BOOLEAN NOT NULL DEFAULT FALSE,
  total_xp INTEGER NOT NULL DEFAULT 0,
  total_coins INTEGER NOT NULL DEFAULT 0,
  current_level INTEGER NOT NULL DEFAULT 1,
  current_streak INTEGER NOT NULL DEFAULT 0,
  longest_streak INTEGER NOT NULL DEFAULT 0,
  hearts INTEGER NOT NULL DEFAULT 5,
  hearts_updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ============================================
-- COURSE STRUCTURE
-- ============================================

CREATE TABLE courses (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  title TEXT NOT NULL,
  description TEXT,
  thumbnail_url TEXT,
  level TEXT NOT NULL DEFAULT 'starter',
  status TEXT NOT NULL DEFAULT 'draft' CHECK (status IN ('draft', 'review', 'published', 'archived')),
  order_index INTEGER NOT NULL DEFAULT 0,
  created_by UUID REFERENCES profiles(id),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE units (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  course_id UUID NOT NULL REFERENCES courses(id) ON DELETE CASCADE,
  title TEXT NOT NULL,
  description TEXT,
  order_index INTEGER NOT NULL DEFAULT 0,
  status TEXT NOT NULL DEFAULT 'draft' CHECK (status IN ('draft', 'review', 'published', 'archived')),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE chapters (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  unit_id UUID NOT NULL REFERENCES units(id) ON DELETE CASCADE,
  title TEXT NOT NULL,
  description TEXT,
  order_index INTEGER NOT NULL DEFAULT 0,
  status TEXT NOT NULL DEFAULT 'draft' CHECK (status IN ('draft', 'review', 'published', 'archived')),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE lessons (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  chapter_id UUID NOT NULL REFERENCES chapters(id) ON DELETE CASCADE,
  title TEXT NOT NULL,
  description TEXT,
  order_index INTEGER NOT NULL DEFAULT 0,
  xp_reward INTEGER NOT NULL DEFAULT 10,
  status TEXT NOT NULL DEFAULT 'draft' CHECK (status IN ('draft', 'review', 'published', 'archived')),
  lesson_type TEXT NOT NULL DEFAULT 'standard',
  estimated_minutes INTEGER NOT NULL DEFAULT 5,
  created_by UUID REFERENCES profiles(id),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ============================================
-- EXERCISES
-- ============================================

CREATE TABLE exercise_types (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  description TEXT,
  icon TEXT
);

INSERT INTO exercise_types (id, name, description, icon) VALUES
  ('vocabulary', 'Từ vựng', 'Học từ mới', '📝'),
  ('multiple_choice', 'Trắc nghiệm', 'Chọn đáp án đúng', '✅'),
  ('listening', 'Nghe', 'Nghe và trả lời', '👂'),
  ('speaking', 'Nói', 'Phát âm và kiểm tra', '🎤'),
  ('translation', 'Dịch', 'Dịch câu', '🔄'),
  ('sentence_builder', 'Xếp câu', 'Sắp xếp từ thành câu', '🧩'),
  ('flashcard', 'Flashcard', 'Ôn tập nhanh', '🃏'),
  ('character_writing', 'Viết chữ', 'Luyện viết chữ Hán', '✍️'),
  ('grammar', 'Ngữ pháp', 'Học cấu trúc ngữ pháp', '📖'),
  ('tone_practice', 'Thanh điệu', 'Luyện thanh điệu', '🎵');

CREATE TABLE exercises (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  lesson_id UUID NOT NULL REFERENCES lessons(id) ON DELETE CASCADE,
  exercise_type TEXT NOT NULL REFERENCES exercise_types(id),
  order_index INTEGER NOT NULL DEFAULT 0,
  question TEXT NOT NULL,
  question_audio_url TEXT,
  correct_answer TEXT NOT NULL,
  explanation TEXT,
  hint TEXT,
  points INTEGER NOT NULL DEFAULT 1,
  data JSONB NOT NULL DEFAULT '{}',
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE exercise_options (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  exercise_id UUID NOT NULL REFERENCES exercises(id) ON DELETE CASCADE,
  text TEXT NOT NULL,
  is_correct BOOLEAN NOT NULL DEFAULT FALSE,
  order_index INTEGER NOT NULL DEFAULT 0
);

-- ============================================
-- VOCABULARY & CHARACTERS
-- ============================================

CREATE TABLE vocabulary (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  chinese TEXT NOT NULL,
  pinyin TEXT NOT NULL,
  meaning_vi TEXT NOT NULL,
  meaning_en TEXT,
  audio_url TEXT,
  level TEXT NOT NULL DEFAULT 'starter',
  category TEXT,
  example_sentence TEXT,
  example_pinyin TEXT,
  example_meaning TEXT,
  hsk_level INTEGER,
  status TEXT NOT NULL DEFAULT 'draft' CHECK (status IN ('draft', 'review', 'published', 'archived')),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE lesson_vocabulary (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  lesson_id UUID NOT NULL REFERENCES lessons(id) ON DELETE CASCADE,
  vocabulary_id UUID NOT NULL REFERENCES vocabulary(id) ON DELETE CASCADE,
  order_index INTEGER NOT NULL DEFAULT 0,
  UNIQUE(lesson_id, vocabulary_id)
);

CREATE TABLE characters (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  character TEXT NOT NULL UNIQUE,
  pinyin TEXT NOT NULL,
  meaning_vi TEXT NOT NULL,
  radical TEXT,
  stroke_count INTEGER NOT NULL DEFAULT 1,
  stroke_order JSONB,
  level TEXT NOT NULL DEFAULT 'starter',
  status TEXT NOT NULL DEFAULT 'draft' CHECK (status IN ('draft', 'review', 'published', 'archived')),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE grammar_lessons (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  title TEXT NOT NULL,
  pattern TEXT NOT NULL,
  explanation TEXT NOT NULL,
  example_chinese TEXT,
  example_pinyin TEXT,
  example_meaning TEXT,
  level TEXT NOT NULL DEFAULT 'starter',
  status TEXT NOT NULL DEFAULT 'draft' CHECK (status IN ('draft', 'review', 'published', 'archived')),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ============================================
-- USER PROGRESS
-- ============================================

CREATE TABLE user_course_progress (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  course_id UUID NOT NULL REFERENCES courses(id) ON DELETE CASCADE,
  current_unit_id UUID REFERENCES units(id),
  current_chapter_id UUID REFERENCES chapters(id),
  current_lesson_id UUID REFERENCES lessons(id),
  percent_complete REAL NOT NULL DEFAULT 0,
  started_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  completed_at TIMESTAMPTZ,
  UNIQUE(user_id, course_id)
);

CREATE TABLE user_lesson_progress (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  lesson_id UUID NOT NULL REFERENCES lessons(id) ON DELETE CASCADE,
  status TEXT NOT NULL DEFAULT 'locked' CHECK (status IN ('locked', 'available', 'in_progress', 'completed')),
  score REAL,
  xp_earned INTEGER NOT NULL DEFAULT 0,
  started_at TIMESTAMPTZ,
  completed_at TIMESTAMPTZ,
  attempts INTEGER NOT NULL DEFAULT 0,
  UNIQUE(user_id, lesson_id)
);

CREATE TABLE user_exercise_attempts (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  exercise_id UUID NOT NULL REFERENCES exercises(id) ON DELETE CASCADE,
  lesson_id UUID NOT NULL REFERENCES lessons(id) ON DELETE CASCADE,
  user_answer TEXT NOT NULL,
  is_correct BOOLEAN NOT NULL,
  time_spent_seconds INTEGER NOT NULL DEFAULT 0,
  pronunciation_score REAL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE user_vocabulary_progress (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  vocabulary_id UUID NOT NULL REFERENCES vocabulary(id) ON DELETE CASCADE,
  next_review_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  review_count INTEGER NOT NULL DEFAULT 0,
  difficulty REAL NOT NULL DEFAULT 2.5, -- SM-2 ease factor
  memory_strength REAL NOT NULL DEFAULT 0,
  last_reviewed_at TIMESTAMPTZ,
  UNIQUE(user_id, vocabulary_id)
);

CREATE TABLE user_character_progress (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  character_id UUID NOT NULL REFERENCES characters(id) ON DELETE CASCADE,
  practice_count INTEGER NOT NULL DEFAULT 0,
  best_score REAL,
  last_practiced_at TIMESTAMPTZ,
  UNIQUE(user_id, character_id)
);

-- ============================================
-- GAMIFICATION
-- ============================================

CREATE TABLE xp_transactions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  amount INTEGER NOT NULL,
  reason TEXT NOT NULL,
  source_type TEXT NOT NULL,
  source_id UUID,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE coin_transactions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  amount INTEGER NOT NULL,
  reason TEXT NOT NULL,
  source_type TEXT NOT NULL,
  source_id UUID,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE level_thresholds (
  level INTEGER PRIMARY KEY,
  xp_required INTEGER NOT NULL,
  title TEXT
);

INSERT INTO level_thresholds (level, xp_required, title) VALUES
  (1, 0, 'Người mới'),
  (2, 100, 'Sơ cấp'),
  (3, 250, 'Học viên'),
  (4, 450, 'Tiến bộ'),
  (5, 700, 'Trung cấp'),
  (6, 1000, 'Khá'),
  (7, 1400, 'Giỏi'),
  (8, 1900, 'Xuất sắc'),
  (9, 2500, 'Thành thạo'),
  (10, 3200, 'Cao thủ'),
  (11, 4000, 'Chuyên gia'),
  (12, 5000, 'Bậc thầy'),
  (13, 6500, 'Huyền thoại'),
  (14, 8000, 'Vô địch'),
  (15, 10000, 'Đại sư');

CREATE TABLE streaks (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE UNIQUE,
  current_streak INTEGER NOT NULL DEFAULT 0,
  longest_streak INTEGER NOT NULL DEFAULT 0,
  last_activity_date DATE,
  streak_freeze_available BOOLEAN NOT NULL DEFAULT FALSE,
  streak_freeze_used_at TIMESTAMPTZ
);

CREATE TABLE achievements (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  key TEXT NOT NULL UNIQUE,
  title TEXT NOT NULL,
  description TEXT NOT NULL,
  icon TEXT NOT NULL,
  category TEXT NOT NULL,
  requirement_type TEXT NOT NULL,
  requirement_value INTEGER NOT NULL,
  xp_reward INTEGER NOT NULL DEFAULT 0,
  coin_reward INTEGER NOT NULL DEFAULT 0,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE user_achievements (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  achievement_id UUID NOT NULL REFERENCES achievements(id) ON DELETE CASCADE,
  unlocked_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE(user_id, achievement_id)
);

CREATE TABLE daily_quests (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  title TEXT NOT NULL,
  description TEXT NOT NULL,
  quest_type TEXT NOT NULL,
  requirement_value INTEGER NOT NULL,
  xp_reward INTEGER NOT NULL DEFAULT 20,
  coin_reward INTEGER NOT NULL DEFAULT 5,
  is_active BOOLEAN NOT NULL DEFAULT TRUE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE user_daily_quests (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  quest_id UUID NOT NULL REFERENCES daily_quests(id) ON DELETE CASCADE,
  progress INTEGER NOT NULL DEFAULT 0,
  completed BOOLEAN NOT NULL DEFAULT FALSE,
  assigned_date DATE NOT NULL DEFAULT CURRENT_DATE,
  completed_at TIMESTAMPTZ,
  UNIQUE(user_id, quest_id, assigned_date)
);

CREATE TABLE leaderboards (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  week_start DATE NOT NULL,
  xp_earned INTEGER NOT NULL DEFAULT 0,
  rank INTEGER,
  league TEXT NOT NULL DEFAULT 'bronze' CHECK (league IN ('bronze', 'silver', 'gold', 'diamond')),
  UNIQUE(user_id, week_start)
);

-- ============================================
-- SPEAKING & PRONUNCIATION
-- ============================================

CREATE TABLE pronunciation_attempts (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  text TEXT NOT NULL,
  pinyin TEXT NOT NULL,
  audio_url TEXT,
  pronunciation_score REAL NOT NULL DEFAULT 0,
  accuracy_score REAL NOT NULL DEFAULT 0,
  fluency_score REAL NOT NULL DEFAULT 0,
  completeness_score REAL NOT NULL DEFAULT 0,
  feedback JSONB,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ============================================
-- STUDY SESSIONS
-- ============================================

CREATE TABLE study_sessions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  started_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  ended_at TIMESTAMPTZ,
  duration_seconds INTEGER NOT NULL DEFAULT 0,
  xp_earned INTEGER NOT NULL DEFAULT 0,
  lessons_completed INTEGER NOT NULL DEFAULT 0,
  exercises_completed INTEGER NOT NULL DEFAULT 0
);

-- ============================================
-- SAVED WORDS & MISTAKES
-- ============================================

CREATE TABLE saved_words (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  vocabulary_id UUID NOT NULL REFERENCES vocabulary(id) ON DELETE CASCADE,
  notes TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE(user_id, vocabulary_id)
);

CREATE TABLE mistakes (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  exercise_id UUID REFERENCES exercises(id),
  category TEXT NOT NULL CHECK (category IN ('vocabulary', 'grammar', 'listening', 'speaking', 'writing')),
  question TEXT NOT NULL,
  user_answer TEXT NOT NULL,
  correct_answer TEXT NOT NULL,
  reviewed BOOLEAN NOT NULL DEFAULT FALSE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ============================================
-- NOTIFICATIONS & ADMIN
-- ============================================

CREATE TABLE notifications (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  title TEXT NOT NULL,
  body TEXT NOT NULL,
  type TEXT NOT NULL,
  data JSONB,
  read BOOLEAN NOT NULL DEFAULT FALSE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE admin_activity_logs (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  action TEXT NOT NULL,
  resource_type TEXT NOT NULL,
  resource_id UUID,
  details JSONB,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE usage_tracking (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  service TEXT NOT NULL,
  usage_type TEXT NOT NULL,
  amount REAL NOT NULL DEFAULT 0,
  date DATE NOT NULL DEFAULT CURRENT_DATE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ============================================
-- VIDEOS
-- ============================================

CREATE TABLE videos (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  title TEXT NOT NULL,
  description TEXT,
  video_url TEXT NOT NULL,
  thumbnail_url TEXT,
  level TEXT NOT NULL DEFAULT 'starter',
  category TEXT,
  duration_seconds INTEGER NOT NULL DEFAULT 0,
  status TEXT NOT NULL DEFAULT 'draft' CHECK (status IN ('draft', 'review', 'published', 'archived')),
  created_by UUID REFERENCES profiles(id),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE video_subtitles (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  video_id UUID NOT NULL REFERENCES videos(id) ON DELETE CASCADE,
  start_time REAL NOT NULL,
  end_time REAL NOT NULL,
  chinese_text TEXT,
  pinyin TEXT,
  vietnamese_text TEXT,
  order_index INTEGER NOT NULL DEFAULT 0
);

CREATE TABLE video_questions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  video_id UUID NOT NULL REFERENCES videos(id) ON DELETE CASCADE,
  timestamp_seconds REAL NOT NULL,
  question TEXT NOT NULL,
  correct_answer TEXT NOT NULL,
  options JSONB,
  explanation TEXT,
  order_index INTEGER NOT NULL DEFAULT 0
);

-- ============================================
-- INDEXES
-- ============================================

CREATE INDEX idx_units_course ON units(course_id, order_index);
CREATE INDEX idx_chapters_unit ON chapters(unit_id, order_index);
CREATE INDEX idx_lessons_chapter ON lessons(chapter_id, order_index);
CREATE INDEX idx_exercises_lesson ON exercises(lesson_id, order_index);
CREATE INDEX idx_exercise_options_exercise ON exercise_options(exercise_id);
CREATE INDEX idx_vocabulary_level ON vocabulary(level, status);
CREATE INDEX idx_lesson_vocabulary ON lesson_vocabulary(lesson_id);

CREATE INDEX idx_user_course_progress ON user_course_progress(user_id);
CREATE INDEX idx_user_lesson_progress ON user_lesson_progress(user_id, lesson_id);
CREATE INDEX idx_user_exercise_attempts ON user_exercise_attempts(user_id, created_at);
CREATE INDEX idx_user_vocab_progress ON user_vocabulary_progress(user_id, next_review_at);

CREATE INDEX idx_xp_transactions_user ON xp_transactions(user_id, created_at);
CREATE INDEX idx_coin_transactions_user ON coin_transactions(user_id, created_at);
CREATE INDEX idx_pronunciation_user ON pronunciation_attempts(user_id, created_at);
CREATE INDEX idx_study_sessions_user ON study_sessions(user_id, started_at);
CREATE INDEX idx_leaderboards_week ON leaderboards(week_start, xp_earned DESC);
CREATE INDEX idx_mistakes_user ON mistakes(user_id, category);
CREATE INDEX idx_saved_words_user ON saved_words(user_id);

-- ============================================
-- FUNCTIONS & TRIGGERS
-- ============================================

-- Auto-create profile on signup
CREATE OR REPLACE FUNCTION handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO profiles (id, email)
  VALUES (NEW.id, NEW.email);
  
  INSERT INTO streaks (user_id)
  VALUES (NEW.id);
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION handle_new_user();

-- Update total_xp on xp_transaction insert
CREATE OR REPLACE FUNCTION update_total_xp()
RETURNS TRIGGER AS $$
BEGIN
  UPDATE profiles
  SET total_xp = total_xp + NEW.amount,
      updated_at = NOW()
  WHERE id = NEW.user_id;
  
  -- Check level up
  UPDATE profiles
  SET current_level = (
    SELECT MAX(level) FROM level_thresholds
    WHERE xp_required <= (SELECT total_xp FROM profiles WHERE id = NEW.user_id)
  )
  WHERE id = NEW.user_id;
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER on_xp_transaction
  AFTER INSERT ON xp_transactions
  FOR EACH ROW EXECUTE FUNCTION update_total_xp();

-- Update total_coins on coin_transaction insert
CREATE OR REPLACE FUNCTION update_total_coins()
RETURNS TRIGGER AS $$
BEGIN
  UPDATE profiles
  SET total_coins = total_coins + NEW.amount,
      updated_at = NOW()
  WHERE id = NEW.user_id;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER on_coin_transaction
  AFTER INSERT ON coin_transactions
  FOR EACH ROW EXECUTE FUNCTION update_total_coins();
