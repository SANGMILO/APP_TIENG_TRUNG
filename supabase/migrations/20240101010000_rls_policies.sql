-- Mandarin Master RLS Policies
-- Migration 002: Row Level Security

-- Enable RLS on all tables
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE courses ENABLE ROW LEVEL SECURITY;
ALTER TABLE units ENABLE ROW LEVEL SECURITY;
ALTER TABLE chapters ENABLE ROW LEVEL SECURITY;
ALTER TABLE lessons ENABLE ROW LEVEL SECURITY;
ALTER TABLE exercises ENABLE ROW LEVEL SECURITY;
ALTER TABLE exercise_options ENABLE ROW LEVEL SECURITY;
ALTER TABLE vocabulary ENABLE ROW LEVEL SECURITY;
ALTER TABLE lesson_vocabulary ENABLE ROW LEVEL SECURITY;
ALTER TABLE characters ENABLE ROW LEVEL SECURITY;
ALTER TABLE grammar_lessons ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_course_progress ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_lesson_progress ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_exercise_attempts ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_vocabulary_progress ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_character_progress ENABLE ROW LEVEL SECURITY;
ALTER TABLE xp_transactions ENABLE ROW LEVEL SECURITY;
ALTER TABLE coin_transactions ENABLE ROW LEVEL SECURITY;
ALTER TABLE streaks ENABLE ROW LEVEL SECURITY;
ALTER TABLE achievements ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_achievements ENABLE ROW LEVEL SECURITY;
ALTER TABLE daily_quests ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_daily_quests ENABLE ROW LEVEL SECURITY;
ALTER TABLE leaderboards ENABLE ROW LEVEL SECURITY;
ALTER TABLE pronunciation_attempts ENABLE ROW LEVEL SECURITY;
ALTER TABLE study_sessions ENABLE ROW LEVEL SECURITY;
ALTER TABLE saved_words ENABLE ROW LEVEL SECURITY;
ALTER TABLE mistakes ENABLE ROW LEVEL SECURITY;
ALTER TABLE notifications ENABLE ROW LEVEL SECURITY;
ALTER TABLE admin_activity_logs ENABLE ROW LEVEL SECURITY;
ALTER TABLE usage_tracking ENABLE ROW LEVEL SECURITY;
ALTER TABLE videos ENABLE ROW LEVEL SECURITY;
ALTER TABLE video_subtitles ENABLE ROW LEVEL SECURITY;
ALTER TABLE video_questions ENABLE ROW LEVEL SECURITY;

-- Helper function to check admin role
CREATE OR REPLACE FUNCTION is_admin()
RETURNS BOOLEAN AS $$
BEGIN
  RETURN EXISTS (
    SELECT 1 FROM profiles
    WHERE id = auth.uid()
    AND role IN ('admin', 'super_admin')
  );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Helper function to check editor role
CREATE OR REPLACE FUNCTION is_editor_or_above()
RETURNS BOOLEAN AS $$
BEGIN
  RETURN EXISTS (
    SELECT 1 FROM profiles
    WHERE id = auth.uid()
    AND role IN ('editor', 'admin', 'super_admin')
  );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ============================================
-- PROFILES
-- ============================================
CREATE POLICY "Users can read own profile"
  ON profiles FOR SELECT USING (id = auth.uid());

CREATE POLICY "Users can update own profile"
  ON profiles FOR UPDATE USING (id = auth.uid());

CREATE POLICY "Admins can read all profiles"
  ON profiles FOR SELECT USING (is_admin());

CREATE POLICY "Admins can update all profiles"
  ON profiles FOR UPDATE USING (is_admin());

-- ============================================
-- CONTENT (courses, units, chapters, lessons, exercises)
-- Published content readable by all authenticated users
-- ============================================

-- Courses
CREATE POLICY "Published courses readable by all"
  ON courses FOR SELECT USING (status = 'published' AND auth.uid() IS NOT NULL);

CREATE POLICY "Editors can read all courses"
  ON courses FOR SELECT USING (is_editor_or_above());

CREATE POLICY "Editors can manage courses"
  ON courses FOR ALL USING (is_editor_or_above());

-- Units
CREATE POLICY "Published units readable by all"
  ON units FOR SELECT USING (
    status = 'published' AND auth.uid() IS NOT NULL
  );

CREATE POLICY "Editors can manage units"
  ON units FOR ALL USING (is_editor_or_above());

-- Chapters
CREATE POLICY "Published chapters readable by all"
  ON chapters FOR SELECT USING (
    status = 'published' AND auth.uid() IS NOT NULL
  );

CREATE POLICY "Editors can manage chapters"
  ON chapters FOR ALL USING (is_editor_or_above());

-- Lessons
CREATE POLICY "Published lessons readable by all"
  ON lessons FOR SELECT USING (
    status = 'published' AND auth.uid() IS NOT NULL
  );

CREATE POLICY "Editors can manage lessons"
  ON lessons FOR ALL USING (is_editor_or_above());

-- Exercises
CREATE POLICY "Exercises in published lessons readable"
  ON exercises FOR SELECT USING (
    auth.uid() IS NOT NULL AND
    EXISTS (SELECT 1 FROM lessons WHERE lessons.id = exercises.lesson_id AND lessons.status = 'published')
  );

CREATE POLICY "Editors can manage exercises"
  ON exercises FOR ALL USING (is_editor_or_above());

-- Exercise Options
CREATE POLICY "Options readable with exercises"
  ON exercise_options FOR SELECT USING (
    auth.uid() IS NOT NULL
  );

CREATE POLICY "Editors can manage options"
  ON exercise_options FOR ALL USING (is_editor_or_above());

-- Vocabulary
CREATE POLICY "Published vocabulary readable by all"
  ON vocabulary FOR SELECT USING (status = 'published' AND auth.uid() IS NOT NULL);

CREATE POLICY "Editors can manage vocabulary"
  ON vocabulary FOR ALL USING (is_editor_or_above());

-- Lesson Vocabulary
CREATE POLICY "Lesson vocabulary readable"
  ON lesson_vocabulary FOR SELECT USING (auth.uid() IS NOT NULL);

CREATE POLICY "Editors can manage lesson vocabulary"
  ON lesson_vocabulary FOR ALL USING (is_editor_or_above());

-- Characters
CREATE POLICY "Published characters readable"
  ON characters FOR SELECT USING (status = 'published' AND auth.uid() IS NOT NULL);

CREATE POLICY "Editors can manage characters"
  ON characters FOR ALL USING (is_editor_or_above());

-- Grammar
CREATE POLICY "Published grammar readable"
  ON grammar_lessons FOR SELECT USING (status = 'published' AND auth.uid() IS NOT NULL);

CREATE POLICY "Editors can manage grammar"
  ON grammar_lessons FOR ALL USING (is_editor_or_above());

-- ============================================
-- USER PROGRESS (user can only access own data)
-- ============================================

CREATE POLICY "Own course progress"
  ON user_course_progress FOR ALL USING (user_id = auth.uid());

CREATE POLICY "Own lesson progress"
  ON user_lesson_progress FOR ALL USING (user_id = auth.uid());

CREATE POLICY "Own exercise attempts"
  ON user_exercise_attempts FOR ALL USING (user_id = auth.uid());

CREATE POLICY "Own vocabulary progress"
  ON user_vocabulary_progress FOR ALL USING (user_id = auth.uid());

CREATE POLICY "Own character progress"
  ON user_character_progress FOR ALL USING (user_id = auth.uid());

-- ============================================
-- GAMIFICATION
-- ============================================

CREATE POLICY "Own XP transactions"
  ON xp_transactions FOR SELECT USING (user_id = auth.uid());

CREATE POLICY "Insert own XP"
  ON xp_transactions FOR INSERT WITH CHECK (user_id = auth.uid());

CREATE POLICY "Own coin transactions"
  ON coin_transactions FOR SELECT USING (user_id = auth.uid());

CREATE POLICY "Insert own coins"
  ON coin_transactions FOR INSERT WITH CHECK (user_id = auth.uid());

CREATE POLICY "Own streak"
  ON streaks FOR ALL USING (user_id = auth.uid());

CREATE POLICY "Achievements readable by all"
  ON achievements FOR SELECT USING (auth.uid() IS NOT NULL);

CREATE POLICY "Editors can manage achievements"
  ON achievements FOR ALL USING (is_editor_or_above());

CREATE POLICY "Own user achievements"
  ON user_achievements FOR ALL USING (user_id = auth.uid());

CREATE POLICY "Active quests readable"
  ON daily_quests FOR SELECT USING (is_active = TRUE AND auth.uid() IS NOT NULL);

CREATE POLICY "Own daily quests"
  ON user_daily_quests FOR ALL USING (user_id = auth.uid());

CREATE POLICY "Leaderboard readable"
  ON leaderboards FOR SELECT USING (auth.uid() IS NOT NULL);

CREATE POLICY "Own leaderboard entry"
  ON leaderboards FOR INSERT WITH CHECK (user_id = auth.uid());

CREATE POLICY "Update own leaderboard"
  ON leaderboards FOR UPDATE USING (user_id = auth.uid());

-- ============================================
-- PRONUNCIATION & SESSIONS
-- ============================================

CREATE POLICY "Own pronunciation attempts"
  ON pronunciation_attempts FOR ALL USING (user_id = auth.uid());

CREATE POLICY "Own study sessions"
  ON study_sessions FOR ALL USING (user_id = auth.uid());

-- ============================================
-- SAVED WORDS & MISTAKES
-- ============================================

CREATE POLICY "Own saved words"
  ON saved_words FOR ALL USING (user_id = auth.uid());

CREATE POLICY "Own mistakes"
  ON mistakes FOR ALL USING (user_id = auth.uid());

-- ============================================
-- NOTIFICATIONS
-- ============================================

CREATE POLICY "Own notifications"
  ON notifications FOR ALL USING (user_id = auth.uid());

-- ============================================
-- ADMIN
-- ============================================

CREATE POLICY "Admin activity logs"
  ON admin_activity_logs FOR SELECT USING (is_admin());

CREATE POLICY "Insert admin logs"
  ON admin_activity_logs FOR INSERT WITH CHECK (is_admin());

CREATE POLICY "Own usage tracking"
  ON usage_tracking FOR SELECT USING (user_id = auth.uid());

CREATE POLICY "Admin usage tracking"
  ON usage_tracking FOR ALL USING (is_admin());

-- ============================================
-- VIDEOS
-- ============================================

CREATE POLICY "Published videos readable"
  ON videos FOR SELECT USING (status = 'published' AND auth.uid() IS NOT NULL);

CREATE POLICY "Editors can manage videos"
  ON videos FOR ALL USING (is_editor_or_above());

CREATE POLICY "Video subtitles readable"
  ON video_subtitles FOR SELECT USING (auth.uid() IS NOT NULL);

CREATE POLICY "Editors can manage subtitles"
  ON video_subtitles FOR ALL USING (is_editor_or_above());

CREATE POLICY "Video questions readable"
  ON video_questions FOR SELECT USING (auth.uid() IS NOT NULL);

CREATE POLICY "Editors can manage video questions"
  ON video_questions FOR ALL USING (is_editor_or_above());
