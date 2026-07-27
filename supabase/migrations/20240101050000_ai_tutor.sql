-- Phase 5: AI Chinese Tutor
-- Conversation storage, usage tracking, AI settings

-- ============================================
-- AI CONVERSATIONS
-- ============================================

CREATE TABLE IF NOT EXISTS ai_conversations (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  title TEXT,
  mode TEXT NOT NULL DEFAULT 'general',
  difficulty TEXT NOT NULL DEFAULT 'beginner',
  status TEXT NOT NULL DEFAULT 'active' CHECK (status IN ('active', 'archived', 'deleted')),
  message_count INTEGER NOT NULL DEFAULT 0,
  last_message_at TIMESTAMPTZ,
  summary TEXT,
  summary_until_message_id UUID,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_ai_conversations_user ON ai_conversations(user_id, last_message_at DESC);
CREATE INDEX idx_ai_conversations_status ON ai_conversations(user_id, status);

-- ============================================
-- AI MESSAGES
-- ============================================

CREATE TABLE IF NOT EXISTS ai_messages (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  conversation_id UUID NOT NULL REFERENCES ai_conversations(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  role TEXT NOT NULL CHECK (role IN ('user', 'assistant')),
  content TEXT NOT NULL,
  structured_data JSONB,
  provider TEXT,
  model TEXT,
  input_tokens INTEGER,
  output_tokens INTEGER,
  latency_ms INTEGER,
  client_message_id TEXT,
  status TEXT NOT NULL DEFAULT 'completed' CHECK (status IN ('sending', 'streaming', 'completed', 'failed', 'cancelled')),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_ai_messages_conversation ON ai_messages(conversation_id, created_at);
CREATE UNIQUE INDEX idx_ai_messages_client_id ON ai_messages(conversation_id, client_message_id) WHERE client_message_id IS NOT NULL;

-- ============================================
-- AI USAGE TRACKING
-- ============================================

CREATE TABLE IF NOT EXISTS ai_usage (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  conversation_id UUID REFERENCES ai_conversations(id),
  provider TEXT NOT NULL,
  model TEXT NOT NULL,
  input_tokens INTEGER NOT NULL DEFAULT 0,
  output_tokens INTEGER NOT NULL DEFAULT 0,
  total_tokens INTEGER NOT NULL DEFAULT 0,
  latency_ms INTEGER,
  status TEXT NOT NULL DEFAULT 'success',
  prompt_version TEXT,
  date DATE NOT NULL DEFAULT CURRENT_DATE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_ai_usage_user_date ON ai_usage(user_id, date);
CREATE INDEX idx_ai_usage_cost ON ai_usage(date, provider, model);

-- ============================================
-- AI USER SETTINGS
-- ============================================

CREATE TABLE IF NOT EXISTS ai_user_settings (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE UNIQUE,
  show_pinyin TEXT NOT NULL DEFAULT 'always' CHECK (show_pinyin IN ('always', 'beginner_only', 'never')),
  show_vietnamese TEXT NOT NULL DEFAULT 'always' CHECK (show_vietnamese IN ('always', 'on_tap', 'never')),
  correction_style TEXT NOT NULL DEFAULT 'normal' CHECK (correction_style IN ('gentle', 'normal', 'detailed')),
  daily_message_limit INTEGER NOT NULL DEFAULT 20,
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ============================================
-- AI FEEDBACK
-- ============================================

CREATE TABLE IF NOT EXISTS ai_feedback (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  message_id UUID NOT NULL REFERENCES ai_messages(id) ON DELETE CASCADE,
  rating TEXT NOT NULL CHECK (rating IN ('helpful', 'not_helpful', 'report')),
  comment TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_ai_feedback_user ON ai_feedback(user_id, created_at);

-- ============================================
-- AI SCENARIOS
-- ============================================

CREATE TABLE IF NOT EXISTS ai_scenarios (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  mode TEXT NOT NULL,
  title TEXT NOT NULL,
  description TEXT,
  ai_role TEXT,
  user_role TEXT,
  difficulty TEXT NOT NULL DEFAULT 'beginner',
  learning_objectives TEXT[],
  target_vocabulary TEXT[],
  status TEXT NOT NULL DEFAULT 'published' CHECK (status IN ('draft', 'published', 'archived')),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ============================================
-- RLS POLICIES
-- ============================================

ALTER TABLE ai_conversations ENABLE ROW LEVEL SECURITY;
ALTER TABLE ai_messages ENABLE ROW LEVEL SECURITY;
ALTER TABLE ai_usage ENABLE ROW LEVEL SECURITY;
ALTER TABLE ai_user_settings ENABLE ROW LEVEL SECURITY;
ALTER TABLE ai_feedback ENABLE ROW LEVEL SECURITY;
ALTER TABLE ai_scenarios ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Own conversations" ON ai_conversations FOR ALL USING (user_id = auth.uid());
CREATE POLICY "Own messages" ON ai_messages FOR ALL USING (user_id = auth.uid());
CREATE POLICY "Own AI usage" ON ai_usage FOR SELECT USING (user_id = auth.uid());
CREATE POLICY "Own AI settings" ON ai_user_settings FOR ALL USING (user_id = auth.uid());
CREATE POLICY "Own AI feedback" ON ai_feedback FOR ALL USING (user_id = auth.uid());
CREATE POLICY "Published scenarios" ON ai_scenarios FOR SELECT USING (status = 'published' AND auth.uid() IS NOT NULL);
CREATE POLICY "Admin manage scenarios" ON ai_scenarios FOR ALL USING (is_editor_or_above());
CREATE POLICY "Admin view AI usage" ON ai_usage FOR SELECT USING (is_admin());

-- ============================================
-- DAILY LIMIT CHECK FUNCTION
-- ============================================

CREATE OR REPLACE FUNCTION check_ai_daily_limit(p_user_id UUID)
RETURNS BOOLEAN AS $$
DECLARE
  v_limit INTEGER;
  v_count INTEGER;
BEGIN
  SELECT COALESCE(daily_message_limit, 20) INTO v_limit
  FROM ai_user_settings WHERE user_id = p_user_id;
  
  IF v_limit IS NULL THEN v_limit := 20; END IF;

  SELECT COUNT(*) INTO v_count
  FROM ai_messages
  WHERE user_id = p_user_id
    AND role = 'user'
    AND created_at >= CURRENT_DATE::TIMESTAMPTZ;

  RETURN v_count < v_limit;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

GRANT EXECUTE ON FUNCTION check_ai_daily_limit TO authenticated;

-- ============================================
-- SEED SCENARIOS
-- ============================================

INSERT INTO ai_scenarios (mode, title, description, ai_role, user_role, difficulty, learning_objectives) VALUES
  ('general', 'Trò chuyện tự do', 'Chat tự do với AI bằng tiếng Trung', 'Giáo viên tiếng Trung thân thiện', 'Người học', 'beginner', ARRAY['practice_conversation', 'learn_vocabulary']),
  ('travel', 'Du lịch Trung Quốc', 'Luyện hội thoại khi du lịch', 'Hướng dẫn viên du lịch', 'Du khách', 'beginner', ARRAY['directions', 'transportation', 'hotel']),
  ('restaurant', 'Ở nhà hàng', 'Gọi món và thanh toán bằng tiếng Trung', 'Phục vụ nhà hàng', 'Khách hàng', 'beginner', ARRAY['ordering_food', 'payment', 'preferences']),
  ('work', 'Môi trường làm việc', 'Giao tiếp công việc bằng tiếng Trung', 'Đồng nghiệp', 'Nhân viên', 'intermediate', ARRAY['meetings', 'email', 'presentations']),
  ('grammar', 'Luyện ngữ pháp', 'AI sửa lỗi và giải thích ngữ pháp', 'Giáo viên ngữ pháp', 'Người học', 'beginner', ARRAY['sentence_structure', 'particles', 'word_order']),
  ('hsk', 'Luyện thi HSK', 'Ôn tập và luyện đề HSK', 'Giáo viên HSK', 'Thí sinh', 'intermediate', ARRAY['vocabulary', 'grammar', 'reading', 'listening'])
ON CONFLICT DO NOTHING;
