-- Phase 6: AI Voice Conversation
-- Voice sessions, turns, usage tracking

-- ============================================
-- VOICE SESSIONS
-- ============================================

CREATE TABLE IF NOT EXISTS voice_sessions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  conversation_id UUID REFERENCES ai_conversations(id) ON DELETE SET NULL,
  scenario_id UUID REFERENCES ai_scenarios(id),
  mode TEXT NOT NULL DEFAULT 'general',
  transport TEXT NOT NULL DEFAULT 'turn_based' CHECK (transport IN ('turn_based', 'realtime')),
  status TEXT NOT NULL DEFAULT 'active' CHECK (status IN ('active', 'paused', 'completed', 'ended', 'abandoned')),
  started_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  ended_at TIMESTAMPTZ,
  total_duration_ms INTEGER NOT NULL DEFAULT 0,
  user_speech_ms INTEGER NOT NULL DEFAULT 0,
  ai_speech_ms INTEGER NOT NULL DEFAULT 0,
  turn_count INTEGER NOT NULL DEFAULT 0,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_voice_sessions_user ON voice_sessions(user_id, created_at DESC);
CREATE INDEX idx_voice_sessions_active ON voice_sessions(user_id, status) WHERE status = 'active';

-- ============================================
-- VOICE TURNS
-- ============================================

CREATE TABLE IF NOT EXISTS voice_turns (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  session_id UUID NOT NULL REFERENCES voice_sessions(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  user_message_id UUID REFERENCES ai_messages(id),
  assistant_message_id UUID REFERENCES ai_messages(id),
  user_transcript TEXT,
  assistant_transcript TEXT,
  transcription_provider TEXT,
  transcription_model TEXT,
  tts_provider TEXT,
  tts_model TEXT,
  tts_voice TEXT,
  stt_latency_ms INTEGER,
  ai_latency_ms INTEGER,
  tts_latency_ms INTEGER,
  total_latency_ms INTEGER,
  user_audio_duration_ms INTEGER,
  assistant_audio_duration_ms INTEGER,
  status TEXT NOT NULL DEFAULT 'completed' CHECK (status IN ('recording', 'transcribing', 'thinking', 'speaking', 'completed', 'failed', 'cancelled')),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_voice_turns_session ON voice_turns(session_id, created_at);

-- ============================================
-- VOICE USAGE (cost tracking)
-- ============================================

CREATE TABLE IF NOT EXISTS voice_usage (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  session_id UUID REFERENCES voice_sessions(id),
  service TEXT NOT NULL, -- 'stt', 'tts', 'realtime'
  provider TEXT NOT NULL,
  model TEXT,
  input_duration_ms INTEGER NOT NULL DEFAULT 0,
  output_duration_ms INTEGER NOT NULL DEFAULT 0,
  characters_processed INTEGER NOT NULL DEFAULT 0,
  tokens_used INTEGER NOT NULL DEFAULT 0,
  status TEXT NOT NULL DEFAULT 'success',
  date DATE NOT NULL DEFAULT CURRENT_DATE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_voice_usage_user_date ON voice_usage(user_id, date);

-- ============================================
-- EXTEND AI_MESSAGES FOR VOICE
-- ============================================

ALTER TABLE ai_messages ADD COLUMN IF NOT EXISTS input_type TEXT NOT NULL DEFAULT 'text' CHECK (input_type IN ('text', 'voice'));
ALTER TABLE ai_messages ADD COLUMN IF NOT EXISTS audio_duration_ms INTEGER;
ALTER TABLE ai_messages ADD COLUMN IF NOT EXISTS voice_session_id UUID REFERENCES voice_sessions(id);

-- ============================================
-- DAILY VOICE LIMIT
-- ============================================

CREATE OR REPLACE FUNCTION check_voice_daily_limit(p_user_id UUID, p_daily_limit_ms INTEGER DEFAULT 300000)
RETURNS BOOLEAN AS $$
DECLARE
  v_used_ms INTEGER;
BEGIN
  SELECT COALESCE(SUM(user_speech_ms), 0) INTO v_used_ms
  FROM voice_sessions
  WHERE user_id = p_user_id
    AND created_at >= CURRENT_DATE::TIMESTAMPTZ;

  RETURN v_used_ms < p_daily_limit_ms;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

GRANT EXECUTE ON FUNCTION check_voice_daily_limit TO authenticated;

-- ============================================
-- VOICE SESSION COMPLETION + XP
-- ============================================

CREATE OR REPLACE FUNCTION complete_voice_session(
  p_session_id UUID,
  p_total_duration_ms INTEGER,
  p_user_speech_ms INTEGER,
  p_ai_speech_ms INTEGER,
  p_turn_count INTEGER
)
RETURNS BOOLEAN AS $$
DECLARE
  v_user_id UUID := auth.uid();
  v_idempotency_key TEXT;
  v_min_speech_ms INTEGER := 30000; -- min 30 sec user speech for XP
  v_min_turns INTEGER := 3;
BEGIN
  -- Update session
  UPDATE voice_sessions
  SET status = 'completed',
      ended_at = NOW(),
      total_duration_ms = p_total_duration_ms,
      user_speech_ms = p_user_speech_ms,
      ai_speech_ms = p_ai_speech_ms,
      turn_count = p_turn_count
  WHERE id = p_session_id AND user_id = v_user_id;

  -- Reward XP if meaningful session
  IF p_user_speech_ms >= v_min_speech_ms AND p_turn_count >= v_min_turns THEN
    v_idempotency_key := v_user_id || ':voice_session:' || p_session_id;
    PERFORM reward_xp(v_user_id, 10, 'voice_session', 'voice_session', p_session_id, v_idempotency_key);
  END IF;

  -- Update streak
  PERFORM update_user_streak(v_user_id);

  RETURN TRUE;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

GRANT EXECUTE ON FUNCTION complete_voice_session TO authenticated;

-- ============================================
-- RLS
-- ============================================

ALTER TABLE voice_sessions ENABLE ROW LEVEL SECURITY;
ALTER TABLE voice_turns ENABLE ROW LEVEL SECURITY;
ALTER TABLE voice_usage ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Own voice sessions" ON voice_sessions FOR ALL USING (user_id = auth.uid());
CREATE POLICY "Own voice turns" ON voice_turns FOR ALL USING (user_id = auth.uid());
CREATE POLICY "Own voice usage" ON voice_usage FOR SELECT USING (user_id = auth.uid());
CREATE POLICY "Admin voice usage" ON voice_usage FOR ALL USING (is_admin());
