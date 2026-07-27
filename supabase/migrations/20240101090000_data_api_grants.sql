-- Migration 010: Data API Grants (Least Privilege)
-- Supabase project: Data API ON, Auto expose tables OFF, Auto RLS ON
-- Principle: REVOKE everything, then explicit GRANT only what's needed.

-- ============================================
-- 1. REVOKE ALL DEFAULTS (clean slate)
-- ============================================
REVOKE ALL ON ALL TABLES IN SCHEMA public FROM PUBLIC, anon, authenticated;
REVOKE ALL ON ALL SEQUENCES IN SCHEMA public FROM PUBLIC, anon, authenticated;
REVOKE ALL ON ALL FUNCTIONS IN SCHEMA public FROM PUBLIC, anon, authenticated;

-- Future-safe: new functions default to no public execute
ALTER DEFAULT PRIVILEGES IN SCHEMA public REVOKE EXECUTE ON FUNCTIONS FROM PUBLIC;

-- ============================================
-- 2. SCHEMA USAGE (required for any access)
-- ============================================
GRANT USAGE ON SCHEMA public TO anon, authenticated;

-- ============================================
-- 3. ANON GRANTS (pre-login, minimal)
-- ============================================
GRANT SELECT ON feature_flags TO anon;
GRANT SELECT ON app_config TO anon;

-- ============================================
-- 4. AUTHENTICATED: READ-ONLY CONTENT
-- ============================================
GRANT SELECT ON courses TO authenticated;
GRANT SELECT ON units TO authenticated;
GRANT SELECT ON chapters TO authenticated;
GRANT SELECT ON lessons TO authenticated;
GRANT SELECT ON exercises TO authenticated;
GRANT SELECT ON exercise_options TO authenticated;
GRANT SELECT ON exercise_types TO authenticated;
GRANT SELECT ON vocabulary TO authenticated;
GRANT SELECT ON lesson_vocabulary TO authenticated;
GRANT SELECT ON characters TO authenticated;
GRANT SELECT ON grammar_lessons TO authenticated;
GRANT SELECT ON videos TO authenticated;
GRANT SELECT ON video_subtitles TO authenticated;
GRANT SELECT ON video_questions TO authenticated;
GRANT SELECT ON video_question_options TO authenticated;
GRANT SELECT ON video_vocabulary TO authenticated;
GRANT SELECT ON tone_syllables TO authenticated;
GRANT SELECT ON level_thresholds TO authenticated;
GRANT SELECT ON achievements TO authenticated;
GRANT SELECT ON daily_quests TO authenticated;
GRANT SELECT ON weekly_quests TO authenticated;
GRANT SELECT ON shop_items TO authenticated;
GRANT SELECT ON league_definitions TO authenticated;
GRANT SELECT ON league_groups TO authenticated;
GRANT SELECT ON ai_scenarios TO authenticated;
GRANT SELECT ON feature_flags TO authenticated;
GRANT SELECT ON app_config TO authenticated;

-- ============================================
-- 5. AUTHENTICATED: USER PROFILE
-- ============================================
GRANT SELECT, UPDATE ON profiles TO authenticated;

-- ============================================
-- 6. AUTHENTICATED: USER PROGRESS (client writes)
-- ============================================
GRANT SELECT, INSERT, UPDATE ON user_course_progress TO authenticated;
GRANT SELECT, INSERT, UPDATE ON user_lesson_progress TO authenticated;
GRANT SELECT, INSERT ON user_exercise_attempts TO authenticated;
GRANT SELECT, INSERT, UPDATE ON user_vocabulary_progress TO authenticated;
GRANT SELECT, INSERT, UPDATE ON user_character_progress TO authenticated;
GRANT SELECT, INSERT, UPDATE ON user_video_progress TO authenticated;
GRANT SELECT, INSERT ON user_video_question_attempts TO authenticated;
GRANT SELECT ON streaks TO authenticated;
GRANT SELECT ON streak_history TO authenticated;

-- ============================================
-- 7. SERVER-AUTHORITATIVE LEDGER TABLES
-- Client: SELECT only. Writes via RPC/Edge Functions.
-- ============================================
GRANT SELECT ON xp_transactions TO authenticated;
GRANT SELECT ON coin_transactions TO authenticated;
GRANT SELECT ON gamification_events TO authenticated;
GRANT SELECT ON heart_transactions TO authenticated;
-- NO INSERT/UPDATE/DELETE for client on ledger tables

-- ============================================
-- 8. AUTHENTICATED: GAMIFICATION (read + limited writes)
-- ============================================
GRANT SELECT, INSERT ON user_achievements TO authenticated;
GRANT SELECT, INSERT, UPDATE ON user_daily_quests TO authenticated;
GRANT SELECT, INSERT, UPDATE ON user_weekly_quests TO authenticated;
GRANT SELECT, INSERT, UPDATE ON leaderboards TO authenticated;
GRANT SELECT ON active_boosts TO authenticated;
GRANT SELECT ON user_inventory TO authenticated;
GRANT SELECT ON shop_purchases TO authenticated;

-- ============================================
-- 9. AUTHENTICATED: USER CONTENT (save words, mistakes)
-- ============================================
GRANT SELECT, INSERT, DELETE ON saved_words TO authenticated;
GRANT SELECT, INSERT, UPDATE ON mistakes TO authenticated;
GRANT SELECT, INSERT, DELETE ON saved_videos TO authenticated;
GRANT SELECT, INSERT, UPDATE ON study_sessions TO authenticated;

-- ============================================
-- 10. PRONUNCIATION ATTEMPTS
-- Client saves assessment results after Edge Function returns score.
-- RLS ensures user_id = auth.uid(). Score comes from trusted server.
-- ============================================
GRANT SELECT, INSERT ON pronunciation_attempts TO authenticated;

-- ============================================
-- 11. AI TUTOR
-- Conversations created by client; messages written by Edge Function only.
-- ============================================
GRANT SELECT, INSERT, UPDATE ON ai_conversations TO authenticated;
GRANT SELECT ON ai_messages TO authenticated;
-- ai_messages INSERT: Edge Function only (service_role)
GRANT SELECT, INSERT ON ai_feedback TO authenticated;
GRANT SELECT, INSERT, UPDATE ON ai_user_settings TO authenticated;

-- ============================================
-- 12. VOICE
-- Sessions/turns created by client service (RLS user_id = auth.uid())
-- ============================================
GRANT SELECT, INSERT, UPDATE ON voice_sessions TO authenticated;
GRANT SELECT, INSERT ON voice_turns TO authenticated;

-- ============================================
-- 13. NOTIFICATIONS
-- ============================================
GRANT SELECT, UPDATE ON notifications TO authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON user_push_tokens TO authenticated;
GRANT SELECT, INSERT, UPDATE ON notification_preferences TO authenticated;

-- ============================================
-- 14. SERVER-ONLY USAGE/COST TABLES (Edge Function writes only)
-- ============================================
GRANT SELECT ON ai_usage TO authenticated;
GRANT SELECT ON voice_usage TO authenticated;
-- usage_tracking: no client grant at all (Edge Function service_role only)

-- ============================================
-- 15. ADMIN CONTENT MANAGEMENT
-- RLS is_editor_or_above() enforces role.
-- ============================================
GRANT INSERT, UPDATE ON courses TO authenticated;
GRANT INSERT, UPDATE ON units TO authenticated;
GRANT INSERT, UPDATE ON chapters TO authenticated;
GRANT INSERT, UPDATE ON lessons TO authenticated;
GRANT INSERT, UPDATE, DELETE ON exercises TO authenticated;
GRANT INSERT, UPDATE, DELETE ON exercise_options TO authenticated;
GRANT INSERT, UPDATE ON vocabulary TO authenticated;
GRANT INSERT, UPDATE ON characters TO authenticated;
GRANT INSERT, UPDATE ON grammar_lessons TO authenticated;
GRANT INSERT, UPDATE ON videos TO authenticated;
GRANT INSERT, UPDATE, DELETE ON video_subtitles TO authenticated;
GRANT INSERT, UPDATE, DELETE ON video_questions TO authenticated;
GRANT INSERT, UPDATE, DELETE ON video_question_options TO authenticated;
GRANT INSERT, UPDATE, DELETE ON video_vocabulary TO authenticated;
GRANT INSERT, UPDATE ON ai_scenarios TO authenticated;
GRANT INSERT, UPDATE ON daily_quests TO authenticated;
GRANT INSERT, UPDATE ON weekly_quests TO authenticated;
GRANT INSERT, UPDATE ON shop_items TO authenticated;
GRANT INSERT, UPDATE ON league_definitions TO authenticated;
GRANT SELECT, INSERT ON content_versions TO authenticated;
GRANT SELECT, INSERT ON content_reviews TO authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON media_assets TO authenticated;
GRANT SELECT, INSERT ON admin_activity_logs TO authenticated;

-- ============================================
-- 16. RPC FUNCTION GRANTS (authenticated only)
-- ============================================
GRANT EXECUTE ON FUNCTION reward_xp(UUID, INTEGER, TEXT, TEXT, UUID, TEXT) TO authenticated;
GRANT EXECUTE ON FUNCTION complete_lesson(UUID, REAL, INTEGER, INTEGER, INTEGER) TO authenticated;
GRANT EXECUTE ON FUNCTION complete_video(UUID, INTEGER, INTEGER, INTEGER) TO authenticated;
GRANT EXECUTE ON FUNCTION complete_voice_session(UUID, INTEGER, INTEGER, INTEGER, INTEGER) TO authenticated;
GRANT EXECUTE ON FUNCTION purchase_shop_item(UUID, TEXT) TO authenticated;
GRANT EXECUTE ON FUNCTION get_gamification_summary() TO authenticated;
GRANT EXECUTE ON FUNCTION publish_content(TEXT, UUID, TEXT) TO authenticated;
GRANT EXECUTE ON FUNCTION get_admin_dashboard() TO authenticated;
GRANT EXECUTE ON FUNCTION check_pronunciation_limit(UUID, INTEGER) TO authenticated;
GRANT EXECUTE ON FUNCTION check_voice_daily_limit(UUID, INTEGER) TO authenticated;
GRANT EXECUTE ON FUNCTION check_ai_daily_limit(UUID) TO authenticated;
GRANT EXECUTE ON FUNCTION reward_speaking_xp(UUID, UUID, REAL, REAL) TO authenticated;

-- RLS helper functions (needed by policy evaluation)
GRANT EXECUTE ON FUNCTION is_admin() TO authenticated;
GRANT EXECUTE ON FUNCTION is_editor_or_above() TO authenticated;

-- Trigger functions: invoked automatically, no explicit grant needed
-- handle_new_user(), update_total_xp(), update_total_coins()
