-- Phase 7: Gamification & Retention
-- Extends existing gamification tables, adds shop, inventory, hearts, leagues, notifications

-- ============================================
-- EXTEND ACHIEVEMENTS
-- ============================================
ALTER TABLE achievements ADD COLUMN IF NOT EXISTS rarity TEXT NOT NULL DEFAULT 'common' CHECK (rarity IN ('common', 'rare', 'epic', 'legendary'));
ALTER TABLE achievements ADD COLUMN IF NOT EXISTS is_hidden BOOLEAN NOT NULL DEFAULT FALSE;
ALTER TABLE achievements ADD COLUMN IF NOT EXISTS condition_type TEXT; -- same as requirement_type, kept for backward compat

-- ============================================
-- EXTEND DAILY QUESTS
-- ============================================
ALTER TABLE daily_quests ADD COLUMN IF NOT EXISTS difficulty TEXT NOT NULL DEFAULT 'easy';
ALTER TABLE daily_quests ADD COLUMN IF NOT EXISTS min_level INTEGER NOT NULL DEFAULT 1;
ALTER TABLE daily_quests ADD COLUMN IF NOT EXISTS icon TEXT;

-- ============================================
-- WEEKLY QUESTS
-- ============================================
CREATE TABLE IF NOT EXISTS weekly_quests (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  title TEXT NOT NULL,
  description TEXT NOT NULL,
  quest_type TEXT NOT NULL,
  requirement_value INTEGER NOT NULL,
  xp_reward INTEGER NOT NULL DEFAULT 50,
  coin_reward INTEGER NOT NULL DEFAULT 15,
  is_active BOOLEAN NOT NULL DEFAULT TRUE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS user_weekly_quests (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  quest_id UUID NOT NULL REFERENCES weekly_quests(id) ON DELETE CASCADE,
  progress INTEGER NOT NULL DEFAULT 0,
  completed BOOLEAN NOT NULL DEFAULT FALSE,
  week_start DATE NOT NULL,
  completed_at TIMESTAMPTZ,
  claimed BOOLEAN NOT NULL DEFAULT FALSE,
  claimed_at TIMESTAMPTZ,
  UNIQUE(user_id, quest_id, week_start)
);

-- ============================================
-- HEARTS / ENERGY
-- ============================================
CREATE TABLE IF NOT EXISTS heart_transactions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  amount INTEGER NOT NULL, -- negative = lost, positive = recovered
  reason TEXT NOT NULL,
  source_id UUID,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_heart_transactions_user ON heart_transactions(user_id, created_at DESC);

-- ============================================
-- SHOP & INVENTORY
-- ============================================
CREATE TABLE IF NOT EXISTS shop_items (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  code TEXT NOT NULL UNIQUE,
  name TEXT NOT NULL,
  description TEXT,
  price_coins INTEGER NOT NULL,
  item_type TEXT NOT NULL, -- 'streak_freeze', 'xp_boost', 'cosmetic'
  value JSONB, -- e.g. {"duration_minutes": 15, "multiplier": 2}
  purchase_limit INTEGER, -- null = unlimited
  is_active BOOLEAN NOT NULL DEFAULT TRUE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS user_inventory (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  item_id UUID NOT NULL REFERENCES shop_items(id),
  quantity INTEGER NOT NULL DEFAULT 1,
  expires_at TIMESTAMPTZ,
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE(user_id, item_id)
);

CREATE TABLE IF NOT EXISTS shop_purchases (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  item_id UUID NOT NULL REFERENCES shop_items(id),
  price_paid INTEGER NOT NULL,
  quantity INTEGER NOT NULL DEFAULT 1,
  idempotency_key TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE UNIQUE INDEX IF NOT EXISTS idx_shop_purchase_idempotency ON shop_purchases(idempotency_key) WHERE idempotency_key IS NOT NULL;

-- ============================================
-- XP BOOST TRACKING
-- ============================================
CREATE TABLE IF NOT EXISTS active_boosts (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  boost_type TEXT NOT NULL, -- 'xp_2x'
  multiplier REAL NOT NULL DEFAULT 2.0,
  started_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  expires_at TIMESTAMPTZ NOT NULL,
  UNIQUE(user_id, boost_type) -- one active boost per type
);

-- ============================================
-- LEAGUES
-- ============================================
CREATE TABLE IF NOT EXISTS league_definitions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  code TEXT NOT NULL UNIQUE,
  name TEXT NOT NULL,
  rank_order INTEGER NOT NULL, -- 1=lowest
  promote_count INTEGER NOT NULL DEFAULT 5,
  demote_count INTEGER NOT NULL DEFAULT 5,
  icon TEXT,
  color TEXT
);

INSERT INTO league_definitions (code, name, rank_order, promote_count, demote_count, icon, color) VALUES
  ('jade', 'Ngọc Bích', 1, 5, 0, '🟢', '#10B981'),
  ('bamboo', 'Trúc Xanh', 2, 5, 5, '🎋', '#22C55E'),
  ('crane', 'Bạch Hạc', 3, 5, 5, '🦢', '#3B82F6'),
  ('tiger', 'Mãnh Hổ', 4, 5, 5, '🐅', '#F59E0B'),
  ('dragon', 'Rồng Vàng', 5, 0, 5, '🐉', '#EF4444')
ON CONFLICT (code) DO NOTHING;

-- Extend leaderboards for league system
ALTER TABLE leaderboards DROP CONSTRAINT IF EXISTS leaderboards_league_check;
ALTER TABLE leaderboards ADD CONSTRAINT leaderboards_league_check CHECK (league IN ('jade', 'bamboo', 'crane', 'tiger', 'dragon'));
ALTER TABLE leaderboards ADD COLUMN IF NOT EXISTS group_id UUID;
ALTER TABLE leaderboards ADD COLUMN IF NOT EXISTS promoted BOOLEAN;
ALTER TABLE leaderboards ADD COLUMN IF NOT EXISTS demoted BOOLEAN;

CREATE TABLE IF NOT EXISTS league_groups (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  week_start DATE NOT NULL,
  league TEXT NOT NULL,
  member_count INTEGER NOT NULL DEFAULT 0,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_league_groups_week ON league_groups(week_start, league);

-- ============================================
-- STREAK HISTORY
-- ============================================
CREATE TABLE IF NOT EXISTS streak_history (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  date DATE NOT NULL,
  status TEXT NOT NULL CHECK (status IN ('active', 'freeze_used', 'missed')),
  activity_xp INTEGER NOT NULL DEFAULT 0,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE(user_id, date)
);

-- ============================================
-- NOTIFICATIONS
-- ============================================
-- notifications table already exists from 001, extend if needed
ALTER TABLE notifications ADD COLUMN IF NOT EXISTS expires_at TIMESTAMPTZ;
ALTER TABLE notifications ADD COLUMN IF NOT EXISTS action_url TEXT;

CREATE TABLE IF NOT EXISTS user_push_tokens (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  token TEXT NOT NULL UNIQUE,
  platform TEXT NOT NULL CHECK (platform IN ('ios', 'android', 'web')),
  is_active BOOLEAN NOT NULL DEFAULT TRUE,
  last_seen_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS notification_preferences (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE UNIQUE,
  study_reminder BOOLEAN NOT NULL DEFAULT TRUE,
  reminder_time TIME NOT NULL DEFAULT '20:00',
  streak_warning BOOLEAN NOT NULL DEFAULT TRUE,
  review_reminder BOOLEAN NOT NULL DEFAULT TRUE,
  league_results BOOLEAN NOT NULL DEFAULT TRUE,
  achievements BOOLEAN NOT NULL DEFAULT TRUE,
  quiet_start TIME DEFAULT '22:00',
  quiet_end TIME DEFAULT '08:00',
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ============================================
-- GAMIFICATION EVENT LOG
-- ============================================
CREATE TABLE IF NOT EXISTS gamification_events (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  event_type TEXT NOT NULL,
  source_type TEXT,
  source_id UUID,
  value INTEGER NOT NULL DEFAULT 1,
  idempotency_key TEXT,
  processed BOOLEAN NOT NULL DEFAULT FALSE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE UNIQUE INDEX IF NOT EXISTS idx_gamification_event_idempotency ON gamification_events(idempotency_key) WHERE idempotency_key IS NOT NULL;
CREATE INDEX IF NOT EXISTS idx_gamification_events_user ON gamification_events(user_id, created_at DESC);

-- ============================================
-- RLS
-- ============================================
ALTER TABLE weekly_quests ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_weekly_quests ENABLE ROW LEVEL SECURITY;
ALTER TABLE heart_transactions ENABLE ROW LEVEL SECURITY;
ALTER TABLE shop_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_inventory ENABLE ROW LEVEL SECURITY;
ALTER TABLE shop_purchases ENABLE ROW LEVEL SECURITY;
ALTER TABLE active_boosts ENABLE ROW LEVEL SECURITY;
ALTER TABLE league_definitions ENABLE ROW LEVEL SECURITY;
ALTER TABLE league_groups ENABLE ROW LEVEL SECURITY;
ALTER TABLE streak_history ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_push_tokens ENABLE ROW LEVEL SECURITY;
ALTER TABLE notification_preferences ENABLE ROW LEVEL SECURITY;
ALTER TABLE gamification_events ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Active weekly quests readable" ON weekly_quests FOR SELECT USING (is_active AND auth.uid() IS NOT NULL);
CREATE POLICY "Own weekly quests" ON user_weekly_quests FOR ALL USING (user_id = auth.uid());
CREATE POLICY "Own heart transactions" ON heart_transactions FOR SELECT USING (user_id = auth.uid());
CREATE POLICY "Shop items readable" ON shop_items FOR SELECT USING (is_active AND auth.uid() IS NOT NULL);
CREATE POLICY "Own inventory" ON user_inventory FOR ALL USING (user_id = auth.uid());
CREATE POLICY "Own purchases" ON shop_purchases FOR SELECT USING (user_id = auth.uid());
CREATE POLICY "Own boosts" ON active_boosts FOR SELECT USING (user_id = auth.uid());
CREATE POLICY "Leagues readable" ON league_definitions FOR SELECT USING (auth.uid() IS NOT NULL);
CREATE POLICY "League groups readable" ON league_groups FOR SELECT USING (auth.uid() IS NOT NULL);
CREATE POLICY "Own streak history" ON streak_history FOR SELECT USING (user_id = auth.uid());
CREATE POLICY "Own push tokens" ON user_push_tokens FOR ALL USING (user_id = auth.uid());
CREATE POLICY "Own notification prefs" ON notification_preferences FOR ALL USING (user_id = auth.uid());
CREATE POLICY "Own gamification events" ON gamification_events FOR SELECT USING (user_id = auth.uid());
CREATE POLICY "Admin manage shop" ON shop_items FOR ALL USING (is_admin());
CREATE POLICY "Admin manage quests" ON weekly_quests FOR ALL USING (is_admin());

-- ============================================
-- SERVER FUNCTIONS
-- ============================================

-- Purchase shop item (atomic: check balance + deduct + grant)
CREATE OR REPLACE FUNCTION purchase_shop_item(
  p_item_id UUID,
  p_idempotency_key TEXT
)
RETURNS JSONB AS $$
DECLARE
  v_user_id UUID := auth.uid();
  v_item RECORD;
  v_balance INTEGER;
BEGIN
  -- Check idempotency
  IF EXISTS (SELECT 1 FROM shop_purchases WHERE idempotency_key = p_idempotency_key) THEN
    RETURN jsonb_build_object('success', FALSE, 'error', 'already_purchased');
  END IF;

  -- Get item
  SELECT * INTO v_item FROM shop_items WHERE id = p_item_id AND is_active;
  IF NOT FOUND THEN
    RETURN jsonb_build_object('success', FALSE, 'error', 'item_not_found');
  END IF;

  -- Check balance
  v_balance := (SELECT total_coins FROM profiles WHERE id = v_user_id);
  IF v_balance < v_item.price_coins THEN
    RETURN jsonb_build_object('success', FALSE, 'error', 'insufficient_coins');
  END IF;

  -- Deduct coins
  INSERT INTO coin_transactions (user_id, amount, reason, source_type, source_id, idempotency_key)
  VALUES (v_user_id, -v_item.price_coins, 'shop_purchase', 'shop_item', p_item_id, p_idempotency_key);

  -- Grant item to inventory
  INSERT INTO user_inventory (user_id, item_id, quantity)
  VALUES (v_user_id, p_item_id, 1)
  ON CONFLICT (user_id, item_id)
  DO UPDATE SET quantity = user_inventory.quantity + 1, updated_at = NOW();

  -- Record purchase
  INSERT INTO shop_purchases (user_id, item_id, price_paid, idempotency_key)
  VALUES (v_user_id, p_item_id, v_item.price_coins, p_idempotency_key);

  RETURN jsonb_build_object('success', TRUE, 'item', v_item.code);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

GRANT EXECUTE ON FUNCTION purchase_shop_item TO authenticated;

-- Get gamification summary (efficient single call)
CREATE OR REPLACE FUNCTION get_gamification_summary()
RETURNS JSONB AS $$
DECLARE
  v_user_id UUID := auth.uid();
  v_profile RECORD;
  v_streak RECORD;
  v_today_xp INTEGER;
  v_boost_active BOOLEAN;
BEGIN
  SELECT total_xp, total_coins, current_level, hearts, daily_goal_xp INTO v_profile
  FROM profiles WHERE id = v_user_id;

  SELECT current_streak, longest_streak INTO v_streak
  FROM streaks WHERE user_id = v_user_id;

  SELECT COALESCE(SUM(amount), 0) INTO v_today_xp
  FROM xp_transactions WHERE user_id = v_user_id AND created_at >= CURRENT_DATE::TIMESTAMPTZ;

  v_boost_active := EXISTS (SELECT 1 FROM active_boosts WHERE user_id = v_user_id AND expires_at > NOW());

  RETURN jsonb_build_object(
    'level', v_profile.current_level,
    'totalXp', v_profile.total_xp,
    'coins', v_profile.total_coins,
    'hearts', v_profile.hearts,
    'dailyGoalXp', v_profile.daily_goal_xp,
    'todayXp', v_today_xp,
    'streak', COALESCE(v_streak.current_streak, 0),
    'longestStreak', COALESCE(v_streak.longest_streak, 0),
    'boostActive', v_boost_active
  );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

GRANT EXECUTE ON FUNCTION get_gamification_summary TO authenticated;

-- ============================================
-- SEED SHOP ITEMS
-- ============================================
INSERT INTO shop_items (code, name, description, price_coins, item_type, value) VALUES
  ('streak_freeze', 'Streak Freeze', 'Bảo vệ chuỗi ngày học khi bạn nghỉ 1 ngày', 50, 'streak_freeze', '{"days": 1}'::jsonb),
  ('xp_boost_15', 'XP Boost 15 phút', 'Nhận 2x XP trong 15 phút', 80, 'xp_boost', '{"duration_minutes": 15, "multiplier": 2}'::jsonb),
  ('xp_boost_30', 'XP Boost 30 phút', 'Nhận 2x XP trong 30 phút', 140, 'xp_boost', '{"duration_minutes": 30, "multiplier": 2}'::jsonb)
ON CONFLICT (code) DO NOTHING;

-- SEED WEEKLY QUESTS
INSERT INTO weekly_quests (title, description, quest_type, requirement_value, xp_reward, coin_reward) VALUES
  ('Học 5 ngày', 'Hoàn thành bài học 5 ngày trong tuần', 'study_days', 5, 50, 15),
  ('Đạt 200 XP', 'Thu thập 200 XP trong tuần', 'weekly_xp', 200, 30, 10),
  ('Ôn 50 từ', 'Ôn tập 50 từ vựng trong tuần', 'words_reviewed', 50, 40, 12)
ON CONFLICT DO NOTHING;

-- SEED MORE ACHIEVEMENTS
INSERT INTO achievements (key, title, description, icon, category, requirement_type, requirement_value, xp_reward, coin_reward, rarity) VALUES
  ('streak_100', '100 ngày liên tục', 'Học 100 ngày không nghỉ', '🏆', 'streak', 'streak_days', 100, 200, 100, 'epic'),
  ('xp_10000', '10,000 XP', 'Đạt mốc 10,000 điểm kinh nghiệm', '🌟', 'xp', 'total_xp', 10000, 100, 50, 'legendary'),
  ('video_10', 'Cinephile', 'Xem hoàn thành 10 video', '🎬', 'video', 'videos_completed', 10, 30, 15, 'rare'),
  ('ai_50', 'AI Friend', 'Hoàn thành 50 phiên AI Tutor', '🤖', 'ai', 'ai_sessions', 50, 40, 20, 'rare'),
  ('voice_10', 'Voice Hero', 'Hoàn thành 10 phiên luyện nói', '🎤', 'speaking', 'voice_sessions', 10, 30, 15, 'rare')
ON CONFLICT (key) DO NOTHING;
