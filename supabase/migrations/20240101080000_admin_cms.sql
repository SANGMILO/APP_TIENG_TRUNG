-- Phase 8: Admin CMS & Content Operations
-- Content versioning, review workflow, feature flags, media, analytics

-- ============================================
-- CONTENT VERSIONS
-- ============================================
CREATE TABLE IF NOT EXISTS content_versions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  entity_type TEXT NOT NULL, -- 'course', 'lesson', 'exercise', 'vocabulary', 'video'
  entity_id UUID NOT NULL,
  version_number INTEGER NOT NULL DEFAULT 1,
  snapshot JSONB NOT NULL,
  change_summary TEXT,
  created_by UUID NOT NULL REFERENCES profiles(id),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_content_versions_entity ON content_versions(entity_type, entity_id, version_number DESC);

-- ============================================
-- CONTENT REVIEW COMMENTS
-- ============================================
CREATE TABLE IF NOT EXISTS content_reviews (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  entity_type TEXT NOT NULL,
  entity_id UUID NOT NULL,
  reviewer_id UUID NOT NULL REFERENCES profiles(id),
  status TEXT NOT NULL CHECK (status IN ('pending', 'approved', 'changes_requested', 'rejected')),
  comment TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_content_reviews_entity ON content_reviews(entity_type, entity_id, created_at DESC);

-- ============================================
-- MEDIA ASSETS
-- ============================================
CREATE TABLE IF NOT EXISTS media_assets (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  filename TEXT NOT NULL,
  object_path TEXT NOT NULL,
  bucket TEXT NOT NULL,
  mime_type TEXT NOT NULL,
  size_bytes INTEGER NOT NULL DEFAULT 0,
  duration_ms INTEGER,
  uploaded_by UUID NOT NULL REFERENCES profiles(id),
  usage_count INTEGER NOT NULL DEFAULT 0,
  metadata JSONB,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_media_assets_type ON media_assets(mime_type, created_at DESC);

-- ============================================
-- FEATURE FLAGS
-- ============================================
CREATE TABLE IF NOT EXISTS feature_flags (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  code TEXT NOT NULL UNIQUE,
  name TEXT NOT NULL,
  description TEXT,
  enabled BOOLEAN NOT NULL DEFAULT TRUE,
  config JSONB,
  updated_by UUID REFERENCES profiles(id),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

INSERT INTO feature_flags (code, name, enabled) VALUES
  ('ai_tutor', 'AI Tutor', TRUE),
  ('voice_tutor', 'Voice Tutor', TRUE),
  ('video_learning', 'Video Learning', TRUE),
  ('pronunciation', 'Pronunciation Assessment', TRUE),
  ('hearts_system', 'Hearts/Energy System', TRUE),
  ('leaderboard', 'Leaderboard & Leagues', TRUE),
  ('shop', 'Coin Shop', TRUE)
ON CONFLICT (code) DO NOTHING;

-- ============================================
-- APP CONFIG (non-secret settings)
-- ============================================
CREATE TABLE IF NOT EXISTS app_config (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  key TEXT NOT NULL UNIQUE,
  value JSONB NOT NULL,
  description TEXT,
  updated_by UUID REFERENCES profiles(id),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

INSERT INTO app_config (key, value, description) VALUES
  ('daily_ai_limit', '20', 'Max AI tutor messages per day'),
  ('daily_voice_limit_ms', '300000', 'Max voice practice ms per day (5 min)'),
  ('daily_pronunciation_limit', '20', 'Max pronunciation assessments per day'),
  ('hearts_max', '5', 'Maximum hearts'),
  ('hearts_recovery_minutes', '30', 'Minutes per heart recovery'),
  ('xp_lesson_complete', '15', 'XP for lesson completion'),
  ('xp_speaking', '5', 'XP for speaking exercise'),
  ('xp_video_complete', '20', 'XP for video completion'),
  ('quest_daily_count', '3', 'Daily quests assigned per user'),
  ('league_group_size', '30', 'Leaderboard group size')
ON CONFLICT (key) DO NOTHING;

-- ============================================
-- EXTEND ADMIN ACTIVITY LOGS
-- ============================================
ALTER TABLE admin_activity_logs ADD COLUMN IF NOT EXISTS before_data JSONB;
ALTER TABLE admin_activity_logs ADD COLUMN IF NOT EXISTS after_data JSONB;
ALTER TABLE admin_activity_logs ADD COLUMN IF NOT EXISTS entity_type TEXT;

-- ============================================
-- RLS
-- ============================================
ALTER TABLE content_versions ENABLE ROW LEVEL SECURITY;
ALTER TABLE content_reviews ENABLE ROW LEVEL SECURITY;
ALTER TABLE media_assets ENABLE ROW LEVEL SECURITY;
ALTER TABLE feature_flags ENABLE ROW LEVEL SECURITY;
ALTER TABLE app_config ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Editors read versions" ON content_versions FOR SELECT USING (is_editor_or_above());
CREATE POLICY "Editors create versions" ON content_versions FOR INSERT WITH CHECK (is_editor_or_above());
CREATE POLICY "Editors read reviews" ON content_reviews FOR SELECT USING (is_editor_or_above());
CREATE POLICY "Editors create reviews" ON content_reviews FOR INSERT WITH CHECK (is_editor_or_above());
CREATE POLICY "Editors read media" ON media_assets FOR SELECT USING (is_editor_or_above());
CREATE POLICY "Editors manage media" ON media_assets FOR ALL USING (is_editor_or_above());
CREATE POLICY "Feature flags readable" ON feature_flags FOR SELECT USING (auth.uid() IS NOT NULL);
CREATE POLICY "Admin manage flags" ON feature_flags FOR ALL USING (is_admin());
CREATE POLICY "App config readable" ON app_config FOR SELECT USING (auth.uid() IS NOT NULL);
CREATE POLICY "Admin manage config" ON app_config FOR ALL USING (is_admin());

-- ============================================
-- ADMIN SERVER FUNCTIONS
-- ============================================

-- Publish content with versioning and audit
CREATE OR REPLACE FUNCTION publish_content(
  p_entity_type TEXT,
  p_entity_id UUID,
  p_change_summary TEXT DEFAULT NULL
)
RETURNS BOOLEAN AS $$
DECLARE
  v_user_id UUID := auth.uid();
  v_snapshot JSONB;
  v_version INTEGER;
BEGIN
  -- Verify admin/editor
  IF NOT is_editor_or_above() THEN
    RAISE EXCEPTION 'Permission denied';
  END IF;

  -- Get current version number
  SELECT COALESCE(MAX(version_number), 0) + 1 INTO v_version
  FROM content_versions WHERE entity_type = p_entity_type AND entity_id = p_entity_id;

  -- Get snapshot based on entity type
  CASE p_entity_type
    WHEN 'course' THEN
      SELECT to_jsonb(c.*) INTO v_snapshot FROM courses c WHERE c.id = p_entity_id;
      UPDATE courses SET status = 'published', published_at = NOW(), updated_at = NOW() WHERE id = p_entity_id;
    WHEN 'lesson' THEN
      SELECT to_jsonb(l.*) INTO v_snapshot FROM lessons l WHERE l.id = p_entity_id;
      UPDATE lessons SET status = 'published', updated_at = NOW() WHERE id = p_entity_id;
    WHEN 'vocabulary' THEN
      SELECT to_jsonb(v.*) INTO v_snapshot FROM vocabulary v WHERE v.id = p_entity_id;
      UPDATE vocabulary SET status = 'published', updated_at = NOW() WHERE id = p_entity_id;
    WHEN 'video' THEN
      SELECT to_jsonb(v.*) INTO v_snapshot FROM videos v WHERE v.id = p_entity_id;
      UPDATE videos SET status = 'published', published_at = NOW(), updated_at = NOW() WHERE id = p_entity_id;
    ELSE
      RAISE EXCEPTION 'Unknown entity type: %', p_entity_type;
  END CASE;

  -- Save version
  INSERT INTO content_versions (entity_type, entity_id, version_number, snapshot, change_summary, created_by)
  VALUES (p_entity_type, p_entity_id, v_version, v_snapshot, p_change_summary, v_user_id);

  -- Audit log
  INSERT INTO admin_activity_logs (user_id, action, resource_type, resource_id, entity_type, details)
  VALUES (v_user_id, 'PUBLISH', p_entity_type, p_entity_id, p_entity_type,
    jsonb_build_object('version', v_version, 'summary', p_change_summary));

  RETURN TRUE;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

GRANT EXECUTE ON FUNCTION publish_content TO authenticated;

-- Admin dashboard stats
CREATE OR REPLACE FUNCTION get_admin_dashboard()
RETURNS JSONB AS $$
DECLARE
  v_result JSONB;
BEGIN
  IF NOT is_admin() THEN
    RAISE EXCEPTION 'Permission denied';
  END IF;

  SELECT jsonb_build_object(
    'totalUsers', (SELECT COUNT(*) FROM profiles),
    'activeToday', (SELECT COUNT(DISTINCT user_id) FROM study_sessions WHERE started_at >= CURRENT_DATE::TIMESTAMPTZ),
    'publishedCourses', (SELECT COUNT(*) FROM courses WHERE status = 'published'),
    'publishedLessons', (SELECT COUNT(*) FROM lessons WHERE status = 'published'),
    'publishedVocabulary', (SELECT COUNT(*) FROM vocabulary WHERE status = 'published'),
    'publishedVideos', (SELECT COUNT(*) FROM videos WHERE status = 'published'),
    'contentInReview', (SELECT COUNT(*) FROM courses WHERE status = 'review') +
                       (SELECT COUNT(*) FROM lessons WHERE status = 'review') +
                       (SELECT COUNT(*) FROM vocabulary WHERE status = 'review'),
    'todayXpTotal', (SELECT COALESCE(SUM(amount), 0) FROM xp_transactions WHERE created_at >= CURRENT_DATE::TIMESTAMPTZ),
    'todayLessonsCompleted', (SELECT COUNT(*) FROM user_lesson_progress WHERE completed_at >= CURRENT_DATE::TIMESTAMPTZ),
    'todayAiSessions', (SELECT COUNT(*) FROM ai_conversations WHERE created_at >= CURRENT_DATE::TIMESTAMPTZ)
  ) INTO v_result;

  RETURN v_result;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

GRANT EXECUTE ON FUNCTION get_admin_dashboard TO authenticated;
