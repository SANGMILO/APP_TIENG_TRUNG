-- Phase 8: populate visible gamification from authoritative learning evidence.
--
-- Client applications may read their own progress, but cannot manufacture
-- quests, achievements, leaderboard XP, inventory, or streak activity.

ALTER TABLE public.daily_quests
  ADD COLUMN IF NOT EXISTS code TEXT;
CREATE UNIQUE INDEX IF NOT EXISTS idx_daily_quests_code
  ON public.daily_quests(code)
  WHERE code IS NOT NULL;

ALTER TABLE public.gamification_events
  ADD COLUMN IF NOT EXISTS processed_at TIMESTAMPTZ,
  ADD COLUMN IF NOT EXISTS processing_error TEXT;

REVOKE INSERT, UPDATE, DELETE ON TABLE public.user_achievements
  FROM PUBLIC, anon, authenticated;
REVOKE INSERT, UPDATE, DELETE ON TABLE public.user_daily_quests
  FROM PUBLIC, anon, authenticated;
REVOKE INSERT, UPDATE, DELETE ON TABLE public.user_weekly_quests
  FROM PUBLIC, anon, authenticated;
REVOKE INSERT, UPDATE, DELETE ON TABLE public.leaderboards
  FROM PUBLIC, anon, authenticated;
REVOKE INSERT, UPDATE, DELETE ON TABLE public.user_inventory
  FROM PUBLIC, anon, authenticated;
REVOKE INSERT, UPDATE, DELETE ON TABLE public.gamification_events
  FROM PUBLIC, anon, authenticated;

-- No authoritative consumption rules exist for XP boosts yet. Keep the defined,
-- immediately usable streak freeze available and hide unsupported items.
UPDATE public.shop_items
SET is_active = FALSE
WHERE item_type <> 'streak_freeze';

-- The AI schema has conversations/messages, not a completed-session event.
UPDATE public.achievements
SET is_hidden = TRUE
WHERE requirement_type = 'ai_sessions'
   OR key IN (
     'first_lesson',
     'words_100',
     'words_500',
     'perfect_lesson',
     'pronunciation_master',
     'listening_master'
   );

INSERT INTO public.daily_quests (
  code,
  title,
  description,
  quest_type,
  requirement_value,
  xp_reward,
  coin_reward,
  is_active,
  difficulty,
  min_level,
  icon
)
VALUES
  ('daily_lesson_1', 'Hoàn thành 1 bài học', 'Hoàn thành một bài học hôm nay', 'lesson_completed', 1, 10, 3, TRUE, 'easy', 1, 'book'),
  ('daily_review_5', 'Ôn 5 từ', 'Hoàn thành năm lượt ôn tập hôm nay', 'review_completed', 5, 10, 3, TRUE, 'easy', 1, 'refresh'),
  ('daily_pronunciation_1', 'Luyện phát âm', 'Hoàn thành một lượt chấm phát âm', 'pronunciation_completed', 1, 5, 2, TRUE, 'easy', 1, 'mic'),
  ('daily_xp_30', 'Nhận 30 XP', 'Nhận 30 XP từ hoạt động học tập hôm nay', 'xp_awarded', 30, 10, 3, TRUE, 'easy', 1, 'flash')
ON CONFLICT (code) WHERE code IS NOT NULL
DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  quest_type = EXCLUDED.quest_type,
  requirement_value = EXCLUDED.requirement_value,
  xp_reward = EXCLUDED.xp_reward,
  coin_reward = EXCLUDED.coin_reward,
  is_active = EXCLUDED.is_active,
  difficulty = EXCLUDED.difficulty,
  min_level = EXCLUDED.min_level,
  icon = EXCLUDED.icon;

-- Older quest definitions use event names that no authoritative producer emits.
-- Preserve the records for history while removing them from user-facing reads.
UPDATE public.daily_quests
SET is_active = FALSE
WHERE code IS NULL;

INSERT INTO public.achievements (
  key,
  title,
  description,
  icon,
  category,
  requirement_type,
  requirement_value,
  xp_reward,
  coin_reward,
  rarity,
  is_hidden
)
VALUES
  ('lesson_1', 'Bước đầu tiên', 'Hoàn thành bài học đầu tiên', '🌱', 'learning', 'lessons_completed', 1, 10, 5, 'common', FALSE),
  ('lesson_10', 'Chăm chỉ', 'Hoàn thành 10 bài học', '📚', 'learning', 'lessons_completed', 10, 30, 15, 'rare', FALSE),
  ('review_10', 'Ôn luyện đều đặn', 'Hoàn thành 10 lượt ôn từ', '🔁', 'review', 'reviews_completed', 10, 20, 10, 'common', FALSE),
  ('pronunciation_5', 'Giọng nói tự tin', 'Hoàn thành 5 lượt chấm phát âm', '🎙️', 'speaking', 'pronunciation_attempts', 5, 25, 10, 'rare', FALSE)
ON CONFLICT (key)
DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  icon = EXCLUDED.icon,
  category = EXCLUDED.category,
  requirement_type = EXCLUDED.requirement_type,
  requirement_value = EXCLUDED.requirement_value,
  xp_reward = EXCLUDED.xp_reward,
  coin_reward = EXCLUDED.coin_reward,
  rarity = EXCLUDED.rarity,
  is_hidden = EXCLUDED.is_hidden;

CREATE OR REPLACE FUNCTION public.gamification_timezone(p_user_id UUID)
RETURNS TEXT
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = ''
AS $$
  SELECT COALESCE(
    (
      SELECT timezone.name
      FROM public.profiles AS profile
      JOIN pg_catalog.pg_timezone_names AS timezone
        ON timezone.name = profile.timezone
      WHERE profile.id = p_user_id
      LIMIT 1
    ),
    'Asia/Ho_Chi_Minh'
  );
$$;

CREATE OR REPLACE FUNCTION public.gamification_local_date(
  p_user_id UUID,
  p_at TIMESTAMPTZ DEFAULT NOW()
)
RETURNS DATE
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = ''
AS $$
  SELECT (p_at AT TIME ZONE public.gamification_timezone(p_user_id))::DATE;
$$;

CREATE OR REPLACE FUNCTION public.evaluate_user_achievements(p_user_id UUID)
RETURNS INTEGER
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = ''
AS $$
DECLARE
  v_achievement public.achievements%ROWTYPE;
  v_measure BIGINT;
  v_unlock_id UUID;
  v_unlocked INTEGER := 0;
BEGIN
  IF p_user_id IS NULL THEN RETURN 0; END IF;

  FOR v_achievement IN
    SELECT achievement.*
    FROM public.achievements AS achievement
    WHERE NOT achievement.is_hidden
    ORDER BY achievement.requirement_value, achievement.id
  LOOP
    v_measure := CASE v_achievement.requirement_type
      WHEN 'total_xp' THEN (
        SELECT COALESCE(SUM(transaction.amount), 0)
        FROM public.xp_transactions AS transaction
        WHERE transaction.user_id = p_user_id
      )
      WHEN 'streak_days' THEN (
        SELECT COALESCE(streak.current_streak, 0)
        FROM public.streaks AS streak
        WHERE streak.user_id = p_user_id
      )
      WHEN 'lessons_completed' THEN (
        SELECT COUNT(DISTINCT submission.lesson_id)
        FROM public.lesson_completion_submissions AS submission
        WHERE submission.user_id = p_user_id
      )
      WHEN 'reviews_completed' THEN (
        SELECT COUNT(*)
        FROM public.vocabulary_review_submissions AS submission
        WHERE submission.user_id = p_user_id
      )
      WHEN 'pronunciation_attempts' THEN (
        SELECT COUNT(*)
        FROM public.pronunciation_attempts AS attempt
        WHERE attempt.user_id = p_user_id
      )
      WHEN 'videos_completed' THEN (
        SELECT COUNT(*)
        FROM public.user_video_progress AS progress
        WHERE progress.user_id = p_user_id
          AND progress.completed_at IS NOT NULL
      )
      WHEN 'voice_sessions' THEN (
        SELECT COUNT(*)
        FROM public.voice_sessions AS session
        WHERE session.user_id = p_user_id
          AND session.status = 'completed'
      )
      ELSE 0
    END;

    IF COALESCE(v_measure, 0) >= v_achievement.requirement_value THEN
      v_unlock_id := NULL;
      INSERT INTO public.user_achievements (
        user_id,
        achievement_id,
        unlocked_at
      )
      VALUES (
        p_user_id,
        v_achievement.id,
        NOW()
      )
      ON CONFLICT (user_id, achievement_id) DO NOTHING
      RETURNING id INTO v_unlock_id;

      IF v_unlock_id IS NOT NULL THEN
        v_unlocked := v_unlocked + 1;

        IF v_achievement.xp_reward > 0 THEN
          INSERT INTO public.xp_transactions (
            user_id,
            amount,
            reason,
            source_type,
            source_id,
            idempotency_key
          )
          VALUES (
            p_user_id,
            v_achievement.xp_reward,
            'achievement_unlocked',
            'achievement',
            v_achievement.id,
            p_user_id || ':achievement:' || v_achievement.id || ':xp'
          )
          ON CONFLICT (idempotency_key)
            WHERE idempotency_key IS NOT NULL
          DO NOTHING;
        END IF;

        IF v_achievement.coin_reward > 0 THEN
          INSERT INTO public.coin_transactions (
            user_id,
            amount,
            reason,
            source_type,
            source_id,
            idempotency_key
          )
          VALUES (
            p_user_id,
            v_achievement.coin_reward,
            'achievement_unlocked',
            'achievement',
            v_achievement.id,
            p_user_id || ':achievement:' || v_achievement.id || ':coins'
          )
          ON CONFLICT (idempotency_key)
            WHERE idempotency_key IS NOT NULL
          DO NOTHING;
        END IF;
      END IF;
    END IF;
  END LOOP;

  RETURN v_unlocked;
END;
$$;

CREATE OR REPLACE FUNCTION public.apply_daily_quest_event(
  p_user_id UUID,
  p_event_type TEXT,
  p_value INTEGER,
  p_local_date DATE
)
RETURNS INTEGER
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = ''
AS $$
DECLARE
  v_quest RECORD;
  v_completed INTEGER := 0;
BEGIN
  INSERT INTO public.user_daily_quests (
    user_id,
    quest_id,
    progress,
    completed,
    assigned_date
  )
  SELECT
    p_user_id,
    quest.id,
    0,
    FALSE,
    p_local_date
  FROM public.daily_quests AS quest
  JOIN public.profiles AS profile ON profile.id = p_user_id
  WHERE quest.is_active
    AND quest.code IS NOT NULL
    AND quest.min_level <= profile.current_level
  ON CONFLICT (user_id, quest_id, assigned_date) DO NOTHING;

  FOR v_quest IN
    UPDATE public.user_daily_quests AS user_quest
       SET progress = LEAST(
             quest.requirement_value,
             user_quest.progress + GREATEST(COALESCE(p_value, 0), 0)
           ),
           completed = (
             user_quest.progress + GREATEST(COALESCE(p_value, 0), 0)
             >= quest.requirement_value
           ),
           completed_at = CASE
             WHEN user_quest.progress + GREATEST(COALESCE(p_value, 0), 0)
               >= quest.requirement_value
             THEN COALESCE(user_quest.completed_at, NOW())
             ELSE user_quest.completed_at
           END
      FROM public.daily_quests AS quest
     WHERE user_quest.quest_id = quest.id
       AND user_quest.user_id = p_user_id
       AND user_quest.assigned_date = p_local_date
       AND NOT user_quest.completed
       AND quest.quest_type = p_event_type
    RETURNING
      user_quest.id,
      user_quest.quest_id,
      user_quest.completed,
      quest.xp_reward,
      quest.coin_reward
  LOOP
    IF v_quest.completed THEN
      v_completed := v_completed + 1;

      IF v_quest.xp_reward > 0 THEN
        INSERT INTO public.xp_transactions (
          user_id,
          amount,
          reason,
          source_type,
          source_id,
          idempotency_key
        )
        VALUES (
          p_user_id,
          v_quest.xp_reward,
          'daily_quest_completed',
          'daily_quest',
          v_quest.quest_id,
          p_user_id || ':daily_quest:' || v_quest.id || ':xp'
        )
        ON CONFLICT (idempotency_key)
          WHERE idempotency_key IS NOT NULL
        DO NOTHING;
      END IF;

      IF v_quest.coin_reward > 0 THEN
        INSERT INTO public.coin_transactions (
          user_id,
          amount,
          reason,
          source_type,
          source_id,
          idempotency_key
        )
        VALUES (
          p_user_id,
          v_quest.coin_reward,
          'daily_quest_completed',
          'daily_quest',
          v_quest.quest_id,
          p_user_id || ':daily_quest:' || v_quest.id || ':coins'
        )
        ON CONFLICT (idempotency_key)
          WHERE idempotency_key IS NOT NULL
        DO NOTHING;
      END IF;
    END IF;
  END LOOP;

  RETURN v_completed;
END;
$$;

CREATE OR REPLACE FUNCTION public.record_gamification_event(
  p_user_id UUID,
  p_event_type TEXT,
  p_source_type TEXT,
  p_source_id UUID,
  p_value INTEGER,
  p_idempotency_key TEXT
)
RETURNS BOOLEAN
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = ''
AS $$
DECLARE
  v_event_id UUID;
  v_existing_processed BOOLEAN;
  v_local_date DATE;
  v_week_date DATE;
BEGIN
  IF p_user_id IS NULL
     OR NULLIF(BTRIM(p_event_type), '') IS NULL
     OR NULLIF(BTRIM(p_idempotency_key), '') IS NULL THEN
    RETURN FALSE;
  END IF;

  INSERT INTO public.gamification_events (
    user_id,
    event_type,
    source_type,
    source_id,
    value,
    idempotency_key,
    processed
  )
  VALUES (
    p_user_id,
    p_event_type,
    p_source_type,
    p_source_id,
    GREATEST(COALESCE(p_value, 0), 0),
    p_idempotency_key,
    FALSE
  )
  ON CONFLICT (idempotency_key)
    WHERE idempotency_key IS NOT NULL
  DO NOTHING
  RETURNING id INTO v_event_id;

  IF v_event_id IS NULL THEN
    SELECT event.id, event.processed
      INTO v_event_id, v_existing_processed
      FROM public.gamification_events AS event
     WHERE event.idempotency_key = p_idempotency_key
     FOR UPDATE;

    IF v_event_id IS NULL OR v_existing_processed THEN
      RETURN FALSE;
    END IF;
  END IF;

  BEGIN
    v_local_date := public.gamification_local_date(p_user_id, NOW());

    PERFORM public.apply_daily_quest_event(
      p_user_id,
      p_event_type,
      GREATEST(COALESCE(p_value, 0), 0),
      v_local_date
    );

    IF p_event_type = 'xp_awarded' AND p_value > 0 THEN
      v_week_date := (
        (NOW() AT TIME ZONE 'Asia/Ho_Chi_Minh')::DATE
        - (EXTRACT(ISODOW FROM NOW() AT TIME ZONE 'Asia/Ho_Chi_Minh')::INTEGER - 1)
      );

      INSERT INTO public.leaderboards (
        user_id,
        week_start,
        xp_earned,
        league
      )
      VALUES (
        p_user_id,
        v_week_date,
        p_value,
        'jade'
      )
      ON CONFLICT (user_id, week_start)
      DO UPDATE SET
        xp_earned = public.leaderboards.xp_earned + EXCLUDED.xp_earned;

      WITH ranked AS (
        SELECT
          board.id,
          ROW_NUMBER() OVER (
            PARTITION BY board.week_start, board.league
            ORDER BY board.xp_earned DESC, board.user_id
          )::INTEGER AS new_rank
        FROM public.leaderboards AS board
        WHERE board.week_start = v_week_date
      )
      UPDATE public.leaderboards AS board
         SET rank = ranked.new_rank
        FROM ranked
       WHERE board.id = ranked.id;

      INSERT INTO public.streak_history (
        user_id,
        date,
        status,
        activity_xp
      )
      VALUES (
        p_user_id,
        v_local_date,
        'active',
        p_value
      )
      ON CONFLICT (user_id, date)
      DO UPDATE SET
        activity_xp = public.streak_history.activity_xp + EXCLUDED.activity_xp,
        status = CASE
          WHEN public.streak_history.status = 'freeze_used'
            THEN public.streak_history.status
          ELSE 'active'
        END;
    END IF;

    PERFORM public.evaluate_user_achievements(p_user_id);

    UPDATE public.gamification_events
       SET processed = TRUE,
           processed_at = NOW(),
           processing_error = NULL
     WHERE id = v_event_id;

    RETURN TRUE;
  EXCEPTION WHEN OTHERS THEN
    UPDATE public.gamification_events
       SET processed = FALSE,
           processed_at = NULL,
           processing_error = SQLSTATE || ': ' || SQLERRM
     WHERE id = v_event_id;
    RETURN FALSE;
  END;
END;
$$;

REVOKE ALL ON FUNCTION public.gamification_timezone(UUID)
  FROM PUBLIC, anon, authenticated;
REVOKE ALL ON FUNCTION public.gamification_local_date(UUID, TIMESTAMPTZ)
  FROM PUBLIC, anon, authenticated;
REVOKE ALL ON FUNCTION public.evaluate_user_achievements(UUID)
  FROM PUBLIC, anon, authenticated;
REVOKE ALL ON FUNCTION public.apply_daily_quest_event(UUID, TEXT, INTEGER, DATE)
  FROM PUBLIC, anon, authenticated;
REVOKE ALL ON FUNCTION public.record_gamification_event(UUID, TEXT, TEXT, UUID, INTEGER, TEXT)
  FROM PUBLIC, anon, authenticated;
GRANT EXECUTE ON FUNCTION public.record_gamification_event(UUID, TEXT, TEXT, UUID, INTEGER, TEXT)
  TO service_role;

CREATE OR REPLACE FUNCTION public.emit_xp_gamification_event()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = ''
AS $$
BEGIN
  IF NEW.amount > 0 THEN
    BEGIN
      PERFORM public.record_gamification_event(
        NEW.user_id,
        'xp_awarded',
        NEW.source_type,
        NEW.id,
        NEW.amount,
        NEW.user_id || ':xp_transaction:' || NEW.id
      );
    EXCEPTION WHEN OTHERS THEN
      RAISE WARNING 'gamification event failed [%]', SQLSTATE;
    END;
  END IF;
  RETURN NEW;
END;
$$;

CREATE OR REPLACE FUNCTION public.emit_lesson_gamification_event()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = ''
AS $$
BEGIN
  BEGIN
    PERFORM public.record_gamification_event(
      NEW.user_id,
      'lesson_completed',
      'lesson',
      NEW.id,
      1,
      NEW.user_id || ':lesson_submission:' || NEW.id
    );
  EXCEPTION WHEN OTHERS THEN
    RAISE WARNING 'gamification event failed [%]', SQLSTATE;
  END;
  RETURN NEW;
END;
$$;

CREATE OR REPLACE FUNCTION public.emit_review_gamification_event()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = ''
AS $$
BEGIN
  BEGIN
    PERFORM public.record_gamification_event(
      NEW.user_id,
      'review_completed',
      'vocabulary_review',
      NEW.id,
      1,
      NEW.user_id || ':review_submission:' || NEW.id
    );
  EXCEPTION WHEN OTHERS THEN
    RAISE WARNING 'gamification event failed [%]', SQLSTATE;
  END;
  RETURN NEW;
END;
$$;

CREATE OR REPLACE FUNCTION public.emit_pronunciation_gamification_event()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = ''
AS $$
BEGIN
  BEGIN
    PERFORM public.record_gamification_event(
      NEW.user_id,
      'pronunciation_completed',
      'pronunciation_attempt',
      NEW.id,
      1,
      NEW.user_id || ':pronunciation_attempt:' || NEW.id
    );
  EXCEPTION WHEN OTHERS THEN
    RAISE WARNING 'gamification event failed [%]', SQLSTATE;
  END;
  RETURN NEW;
END;
$$;

CREATE OR REPLACE FUNCTION public.emit_video_gamification_event()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = ''
AS $$
BEGIN
  IF NEW.completed_at IS NOT NULL
     AND (TG_OP = 'INSERT' OR OLD.completed_at IS NULL) THEN
    BEGIN
      PERFORM public.record_gamification_event(
        NEW.user_id,
        'video_completed',
        'video',
        NEW.video_id,
        1,
        NEW.user_id || ':video_completed:' || NEW.video_id
      );
    EXCEPTION WHEN OTHERS THEN
      RAISE WARNING 'gamification event failed [%]', SQLSTATE;
    END;
  END IF;
  RETURN NEW;
END;
$$;

CREATE OR REPLACE FUNCTION public.emit_voice_gamification_event()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = ''
AS $$
BEGIN
  IF NEW.status = 'completed'
     AND (TG_OP = 'INSERT' OR OLD.status <> 'completed') THEN
    BEGIN
      PERFORM public.record_gamification_event(
        NEW.user_id,
        'voice_completed',
        'voice_session',
        NEW.id,
        1,
        NEW.user_id || ':voice_completed:' || NEW.id
      );
    EXCEPTION WHEN OTHERS THEN
      RAISE WARNING 'gamification event failed [%]', SQLSTATE;
    END;
  END IF;
  RETURN NEW;
END;
$$;

CREATE OR REPLACE FUNCTION public.emit_streak_achievement_check()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = ''
AS $$
BEGIN
  BEGIN
    PERFORM public.evaluate_user_achievements(NEW.user_id);
  EXCEPTION WHEN OTHERS THEN
    RAISE WARNING 'achievement evaluation failed [%]', SQLSTATE;
  END;
  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS on_xp_gamification_event ON public.xp_transactions;
CREATE TRIGGER on_xp_gamification_event
AFTER INSERT ON public.xp_transactions
FOR EACH ROW EXECUTE FUNCTION public.emit_xp_gamification_event();

DROP TRIGGER IF EXISTS on_lesson_gamification_event
  ON public.lesson_completion_submissions;
CREATE TRIGGER on_lesson_gamification_event
AFTER INSERT ON public.lesson_completion_submissions
FOR EACH ROW EXECUTE FUNCTION public.emit_lesson_gamification_event();

DROP TRIGGER IF EXISTS on_review_gamification_event
  ON public.vocabulary_review_submissions;
CREATE TRIGGER on_review_gamification_event
AFTER INSERT ON public.vocabulary_review_submissions
FOR EACH ROW EXECUTE FUNCTION public.emit_review_gamification_event();

DROP TRIGGER IF EXISTS on_pronunciation_gamification_event
  ON public.pronunciation_attempts;
CREATE TRIGGER on_pronunciation_gamification_event
AFTER INSERT ON public.pronunciation_attempts
FOR EACH ROW EXECUTE FUNCTION public.emit_pronunciation_gamification_event();

DROP TRIGGER IF EXISTS on_video_gamification_event
  ON public.user_video_progress;
CREATE TRIGGER on_video_gamification_event
AFTER INSERT OR UPDATE OF completed_at ON public.user_video_progress
FOR EACH ROW EXECUTE FUNCTION public.emit_video_gamification_event();

DROP TRIGGER IF EXISTS on_voice_gamification_event
  ON public.voice_sessions;
CREATE TRIGGER on_voice_gamification_event
AFTER INSERT OR UPDATE OF status ON public.voice_sessions
FOR EACH ROW EXECUTE FUNCTION public.emit_voice_gamification_event();

DROP TRIGGER IF EXISTS on_streak_achievement_check ON public.streaks;
CREATE TRIGGER on_streak_achievement_check
AFTER INSERT OR UPDATE OF current_streak ON public.streaks
FOR EACH ROW EXECUTE FUNCTION public.emit_streak_achievement_check();

-- Streaks are activity evidence owned by trusted completion functions.
CREATE OR REPLACE FUNCTION public.update_user_streak(p_user_id UUID)
RETURNS VOID
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = ''
AS $$
DECLARE
  v_today DATE := public.gamification_local_date(p_user_id, NOW());
  v_streak public.streaks%ROWTYPE;
  v_new_current INTEGER;
  v_new_longest INTEGER;
BEGIN
  SELECT *
    INTO v_streak
    FROM public.streaks AS streak
   WHERE streak.user_id = p_user_id
   FOR UPDATE;

  IF NOT FOUND THEN
    INSERT INTO public.streaks (
      user_id,
      current_streak,
      longest_streak,
      last_activity_date
    )
    VALUES (p_user_id, 1, 1, v_today);
    v_new_current := 1;
    v_new_longest := 1;
  ELSIF v_streak.last_activity_date = v_today THEN
    v_new_current := v_streak.current_streak;
    v_new_longest := v_streak.longest_streak;
  ELSIF v_streak.last_activity_date = v_today - 1 THEN
    v_new_current := v_streak.current_streak + 1;
    v_new_longest := GREATEST(v_streak.longest_streak, v_new_current);
    UPDATE public.streaks
       SET current_streak = v_new_current,
           longest_streak = v_new_longest,
           last_activity_date = v_today
     WHERE user_id = p_user_id;
  ELSIF v_streak.last_activity_date = v_today - 2
     AND v_streak.streak_freeze_available THEN
    v_new_current := v_streak.current_streak + 1;
    v_new_longest := GREATEST(v_streak.longest_streak, v_new_current);
    UPDATE public.streaks
       SET current_streak = v_new_current,
           longest_streak = v_new_longest,
           last_activity_date = v_today,
           streak_freeze_available = FALSE,
           streak_freeze_used_at = NOW()
     WHERE user_id = p_user_id;
    INSERT INTO public.streak_history (user_id, date, status, activity_xp)
    VALUES (p_user_id, v_today - 1, 'freeze_used', 0)
    ON CONFLICT (user_id, date)
    DO UPDATE SET status = 'freeze_used';
  ELSE
    v_new_current := 1;
    v_new_longest := GREATEST(v_streak.longest_streak, 1);
    UPDATE public.streaks
       SET current_streak = 1,
           longest_streak = v_new_longest,
           last_activity_date = v_today
     WHERE user_id = p_user_id;
  END IF;

  UPDATE public.profiles
     SET current_streak = v_new_current,
         longest_streak = v_new_longest,
         updated_at = NOW()
   WHERE id = p_user_id;

  INSERT INTO public.streak_history (user_id, date, status, activity_xp)
  VALUES (p_user_id, v_today, 'active', 0)
  ON CONFLICT (user_id, date) DO NOTHING;
END;
$$;

REVOKE ALL ON FUNCTION public.update_user_streak(UUID)
  FROM PUBLIC, anon, authenticated;
GRANT EXECUTE ON FUNCTION public.update_user_streak(UUID) TO service_role;
REVOKE ALL ON FUNCTION public.reward_speaking_xp(UUID, UUID, REAL, REAL)
  FROM PUBLIC, anon, authenticated;
GRANT EXECUTE ON FUNCTION public.reward_speaking_xp(UUID, UUID, REAL, REAL)
  TO service_role;

-- Atomic purchase with a defined, immediate effect. Unsupported boost items are
-- inactive and cannot be purchased.
CREATE OR REPLACE FUNCTION public.purchase_shop_item(
  p_item_id UUID,
  p_idempotency_key TEXT
)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = ''
AS $$
DECLARE
  v_user_id UUID := auth.uid();
  v_item public.shop_items%ROWTYPE;
  v_existing public.shop_purchases%ROWTYPE;
  v_balance INTEGER;
  v_available BOOLEAN;
BEGIN
  IF v_user_id IS NULL THEN
    RAISE EXCEPTION 'authentication_required' USING ERRCODE = '42501';
  END IF;
  IF p_item_id IS NULL
     OR NULLIF(BTRIM(p_idempotency_key), '') IS NULL
     OR LENGTH(p_idempotency_key) > 200 THEN
    RAISE EXCEPTION 'invalid_purchase_request' USING ERRCODE = '22023';
  END IF;

  SELECT *
    INTO v_existing
    FROM public.shop_purchases AS purchase
   WHERE purchase.idempotency_key = p_idempotency_key;
  IF FOUND THEN
    IF v_existing.user_id <> v_user_id OR v_existing.item_id <> p_item_id THEN
      RAISE EXCEPTION 'purchase_idempotency_conflict' USING ERRCODE = '22023';
    END IF;
    RETURN jsonb_build_object(
      'success', TRUE,
      'already_processed', TRUE,
      'item_id', v_existing.item_id,
      'price_paid', v_existing.price_paid
    );
  END IF;

  SELECT *
    INTO v_item
    FROM public.shop_items AS item
   WHERE item.id = p_item_id
     AND item.is_active
   FOR SHARE;
  IF NOT FOUND OR v_item.item_type <> 'streak_freeze' THEN
    RETURN jsonb_build_object('success', FALSE, 'error', 'item_unavailable');
  END IF;

  SELECT profile.total_coins
    INTO v_balance
    FROM public.profiles AS profile
   WHERE profile.id = v_user_id
   FOR UPDATE;
  IF COALESCE(v_balance, 0) < v_item.price_coins THEN
    RETURN jsonb_build_object('success', FALSE, 'error', 'insufficient_coins');
  END IF;

  SELECT streak.streak_freeze_available
    INTO v_available
    FROM public.streaks AS streak
   WHERE streak.user_id = v_user_id
   FOR UPDATE;
  IF COALESCE(v_available, FALSE) THEN
    RETURN jsonb_build_object('success', FALSE, 'error', 'streak_freeze_already_active');
  END IF;

  INSERT INTO public.coin_transactions (
    user_id,
    amount,
    reason,
    source_type,
    source_id,
    idempotency_key
  )
  VALUES (
    v_user_id,
    -v_item.price_coins,
    'shop_purchase',
    'shop_item',
    p_item_id,
    v_user_id || ':shop_purchase:' || p_idempotency_key
  );

  UPDATE public.streaks
     SET streak_freeze_available = TRUE
   WHERE user_id = v_user_id;

  INSERT INTO public.shop_purchases (
    user_id,
    item_id,
    price_paid,
    quantity,
    idempotency_key
  )
  VALUES (
    v_user_id,
    p_item_id,
    v_item.price_coins,
    1,
    p_idempotency_key
  );

  RETURN jsonb_build_object(
    'success', TRUE,
    'already_processed', FALSE,
    'item_id', p_item_id,
    'price_paid', v_item.price_coins
  );
END;
$$;

REVOKE ALL ON FUNCTION public.purchase_shop_item(UUID, TEXT)
  FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.purchase_shop_item(UUID, TEXT)
  TO authenticated;

CREATE OR REPLACE FUNCTION public.get_weekly_leaderboard()
RETURNS JSONB
LANGUAGE plpgsql
STABLE
SECURITY DEFINER
SET search_path = ''
AS $$
DECLARE
  v_user_id UUID := auth.uid();
  v_week_start DATE := (
    (NOW() AT TIME ZONE 'Asia/Ho_Chi_Minh')::DATE
    - (EXTRACT(ISODOW FROM NOW() AT TIME ZONE 'Asia/Ho_Chi_Minh')::INTEGER - 1)
  );
BEGIN
  IF v_user_id IS NULL THEN
    RAISE EXCEPTION 'authentication_required' USING ERRCODE = '42501';
  END IF;

  RETURN COALESCE(
    (
      SELECT jsonb_agg(
        jsonb_build_object(
          'user_id', ranked.user_id,
          'display_name', CASE
            WHEN ranked.user_id = v_user_id
              THEN COALESCE(ranked.display_name, 'Bạn')
            ELSE 'Người học'
          END,
          'avatar_url', CASE
            WHEN ranked.user_id = v_user_id THEN ranked.avatar_url
            ELSE NULL
          END,
          'xp_earned', ranked.xp_earned,
          'rank', ranked.rank,
          'league', ranked.league,
          'week_start', v_week_start
        )
        ORDER BY ranked.rank
      )
      FROM (
        SELECT
          board.user_id,
          profile.display_name,
          profile.avatar_url,
          board.xp_earned,
          ROW_NUMBER() OVER (
            ORDER BY board.xp_earned DESC, board.user_id
          )::INTEGER AS rank,
          board.league
        FROM public.leaderboards AS board
        JOIN public.profiles AS profile ON profile.id = board.user_id
        WHERE board.week_start = v_week_start
        ORDER BY board.xp_earned DESC, board.user_id
        LIMIT 30
      ) AS ranked
    ),
    '[]'::JSONB
  );
END;
$$;

REVOKE ALL ON FUNCTION public.get_weekly_leaderboard()
  FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.get_weekly_leaderboard()
  TO authenticated;

CREATE OR REPLACE FUNCTION public.get_daily_quests()
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = ''
AS $$
DECLARE
  v_user_id UUID := auth.uid();
  v_local_date DATE;
BEGIN
  IF v_user_id IS NULL THEN
    RAISE EXCEPTION 'authentication_required' USING ERRCODE = '42501';
  END IF;

  v_local_date := public.gamification_local_date(v_user_id, NOW());

  INSERT INTO public.user_daily_quests (
    user_id,
    quest_id,
    progress,
    completed,
    assigned_date
  )
  SELECT
    v_user_id,
    quest.id,
    0,
    FALSE,
    v_local_date
  FROM public.daily_quests AS quest
  JOIN public.profiles AS profile ON profile.id = v_user_id
  WHERE quest.is_active
    AND quest.code IS NOT NULL
    AND quest.min_level <= profile.current_level
  ON CONFLICT (user_id, quest_id, assigned_date) DO NOTHING;

  RETURN COALESCE(
    (
      SELECT jsonb_agg(
        jsonb_build_object(
          'id', user_quest.id,
          'quest_id', quest.id,
          'title', quest.title,
          'description', quest.description,
          'quest_type', quest.quest_type,
          'requirement_value', quest.requirement_value,
          'progress', user_quest.progress,
          'completed', user_quest.completed,
          'xp_reward', quest.xp_reward,
          'coin_reward', quest.coin_reward,
          'assigned_date', user_quest.assigned_date
        )
        ORDER BY quest.requirement_value, quest.code
      )
      FROM public.user_daily_quests AS user_quest
      JOIN public.daily_quests AS quest ON quest.id = user_quest.quest_id
      WHERE user_quest.user_id = v_user_id
        AND user_quest.assigned_date = v_local_date
        AND quest.is_active
        AND quest.code IS NOT NULL
    ),
    '[]'::JSONB
  );
END;
$$;

REVOKE ALL ON FUNCTION public.get_daily_quests()
  FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.get_daily_quests()
  TO authenticated;

CREATE OR REPLACE FUNCTION public.get_gamification_summary()
RETURNS JSONB
LANGUAGE plpgsql
STABLE
SECURITY DEFINER
SET search_path = ''
AS $$
DECLARE
  v_user_id UUID := auth.uid();
  v_profile public.profiles%ROWTYPE;
  v_streak public.streaks%ROWTYPE;
  v_timezone TEXT;
  v_local_date DATE;
  v_day_start TIMESTAMPTZ;
  v_today_xp INTEGER;
  v_boost_active BOOLEAN;
BEGIN
  IF v_user_id IS NULL THEN
    RAISE EXCEPTION 'authentication_required' USING ERRCODE = '42501';
  END IF;

  SELECT * INTO v_profile
  FROM public.profiles
  WHERE id = v_user_id;
  SELECT * INTO v_streak
  FROM public.streaks
  WHERE user_id = v_user_id;

  v_timezone := public.gamification_timezone(v_user_id);
  v_local_date := public.gamification_local_date(v_user_id, NOW());
  v_day_start := v_local_date::TIMESTAMP AT TIME ZONE v_timezone;

  SELECT COALESCE(SUM(transaction.amount), 0)::INTEGER
    INTO v_today_xp
    FROM public.xp_transactions AS transaction
   WHERE transaction.user_id = v_user_id
     AND transaction.created_at >= v_day_start;

  v_boost_active := EXISTS (
    SELECT 1
      FROM public.active_boosts AS boost
     WHERE boost.user_id = v_user_id
       AND boost.expires_at > NOW()
  );

  RETURN jsonb_build_object(
    'level', v_profile.current_level,
    'totalXp', v_profile.total_xp,
    'coins', v_profile.total_coins,
    'hearts', v_profile.hearts,
    'dailyGoalXp', v_profile.daily_goal_xp,
    'todayXp', v_today_xp,
    'streak', COALESCE(v_streak.current_streak, 0),
    'longestStreak', COALESCE(v_streak.longest_streak, 0),
    'streakFreezeAvailable', COALESCE(v_streak.streak_freeze_available, FALSE),
    'boostActive', v_boost_active
  );
END;
$$;

REVOKE ALL ON FUNCTION public.get_gamification_summary()
  FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.get_gamification_summary()
  TO authenticated;
