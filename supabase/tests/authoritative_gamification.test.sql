BEGIN;

SELECT plan(41);

SELECT ok(
  has_function_privilege('authenticated', 'public.get_daily_quests()', 'EXECUTE')
  AND has_function_privilege('authenticated', 'public.get_weekly_leaderboard()', 'EXECUTE')
  AND has_function_privilege('authenticated', 'public.get_gamification_summary()', 'EXECUTE'),
  'authenticated users can read server-owned gamification state'
);

SELECT ok(
  NOT has_function_privilege(
    'authenticated',
    'public.record_gamification_event(uuid,text,text,uuid,integer,text)',
    'EXECUTE'
  ),
  'clients cannot manufacture gamification events'
);

SELECT ok(
  NOT has_function_privilege('authenticated', 'public.update_user_streak(uuid)', 'EXECUTE')
  AND NOT has_function_privilege(
    'authenticated',
    'public.reward_speaking_xp(uuid,uuid,real,real)',
    'EXECUTE'
  ),
  'clients cannot manufacture streak activity or speaking rewards'
);

SELECT ok(
  NOT has_table_privilege('authenticated', 'public.user_achievements', 'INSERT')
  AND NOT has_table_privilege('authenticated', 'public.user_daily_quests', 'INSERT')
  AND NOT has_table_privilege('authenticated', 'public.user_daily_quests', 'UPDATE'),
  'achievement and daily quest progress are server-owned'
);

SELECT ok(
  NOT has_table_privilege('authenticated', 'public.leaderboards', 'INSERT')
  AND NOT has_table_privilege('authenticated', 'public.leaderboards', 'UPDATE'),
  'clients cannot set leaderboard XP or rank'
);

SELECT ok(
  NOT has_table_privilege('authenticated', 'public.user_inventory', 'INSERT')
  AND NOT has_table_privilege('authenticated', 'public.gamification_events', 'INSERT'),
  'clients cannot grant inventory or raw events'
);

SELECT throws_ok(
  $$ SELECT public.get_daily_quests() $$,
  '42501',
  'authentication_required',
  'daily quests require authentication'
);

SELECT throws_ok(
  $$ SELECT public.get_weekly_leaderboard() $$,
  '42501',
  'authentication_required',
  'leaderboard requires authentication'
);

INSERT INTO auth.users (
  id,
  aud,
  role,
  email,
  raw_app_meta_data,
  raw_user_meta_data,
  created_at,
  updated_at
)
VALUES (
  '28000000-0000-4000-8000-000000000001',
  'authenticated',
  'authenticated',
  'gamification-test@example.invalid',
  '{"provider":"email","providers":["email"]}'::JSONB,
  '{"full_name":"Gamification Test"}'::JSONB,
  NOW(),
  NOW()
);

SET LOCAL "request.jwt.claim.sub" = '28000000-0000-4000-8000-000000000001';
SET LOCAL "request.jwt.claim.role" = 'authenticated';

SELECT is(
  jsonb_array_length(public.get_daily_quests()),
  4,
  'the server assigns only quests backed by defined event rules'
);

SELECT is(
  (
    SELECT COUNT(*)::INTEGER
    FROM public.user_daily_quests
    WHERE user_id = '28000000-0000-4000-8000-000000000001'
      AND assigned_date = public.gamification_local_date(
        '28000000-0000-4000-8000-000000000001',
        NOW()
      )
  ),
  4,
  'daily assignment is idempotently stored for the user local date'
);

INSERT INTO public.lesson_completion_submissions (
  id,
  user_id,
  lesson_id,
  result
)
SELECT
  '28000000-0000-4000-8000-000000000010',
  '28000000-0000-4000-8000-000000000001',
  lesson.id,
  '{"success":true}'::JSONB
FROM public.lessons AS lesson
WHERE lesson.status = 'published'
ORDER BY lesson.created_at
LIMIT 1;

SELECT is(
  (
    SELECT ROW(progress, completed)
    FROM public.user_daily_quests AS user_quest
    JOIN public.daily_quests AS quest ON quest.id = user_quest.quest_id
    WHERE user_quest.user_id = '28000000-0000-4000-8000-000000000001'
      AND quest.code = 'daily_lesson_1'
      AND user_quest.assigned_date = public.gamification_local_date(
        '28000000-0000-4000-8000-000000000001',
        NOW()
      )
  ),
  ROW(1, TRUE),
  'a trusted lesson submission completes the lesson quest'
);

SELECT ok(
  EXISTS (
    SELECT 1
    FROM public.user_achievements AS unlock
    JOIN public.achievements AS achievement
      ON achievement.id = unlock.achievement_id
    WHERE unlock.user_id = '28000000-0000-4000-8000-000000000001'
      AND achievement.key = 'lesson_1'
  ),
  'the first trusted lesson unlocks its defined achievement'
);

SELECT is(
  (
    SELECT COUNT(*)::INTEGER
    FROM public.gamification_events
    WHERE idempotency_key =
      '28000000-0000-4000-8000-000000000001:lesson_submission:28000000-0000-4000-8000-000000000010'
  ),
  1,
  'lesson evidence produces one idempotent event'
);

SELECT ok(
  (
    SELECT processed
    FROM public.gamification_events
    WHERE idempotency_key =
      '28000000-0000-4000-8000-000000000001:lesson_submission:28000000-0000-4000-8000-000000000010'
  ),
  'trusted events are marked processed'
);

SELECT is(
  (
    SELECT COUNT(*)::INTEGER
    FROM public.xp_transactions
    WHERE user_id = '28000000-0000-4000-8000-000000000001'
      AND source_type IN ('daily_quest', 'achievement')
  ),
  2,
  'quest and achievement XP each award once'
);

SELECT is(
  (
    SELECT COUNT(*)::INTEGER
    FROM public.coin_transactions
    WHERE user_id = '28000000-0000-4000-8000-000000000001'
      AND source_type IN ('daily_quest', 'achievement')
  ),
  2,
  'quest and achievement coins each award once'
);

INSERT INTO public.xp_transactions (
  user_id,
  amount,
  reason,
  source_type,
  source_id,
  idempotency_key
)
VALUES (
  '28000000-0000-4000-8000-000000000001',
  15,
  'test_learning_xp',
  'lesson',
  '28000000-0000-4000-8000-000000000010',
  'gamification-test-base-xp'
);

SELECT is(
  (
    SELECT ROW(progress, completed)
    FROM public.user_daily_quests AS user_quest
    JOIN public.daily_quests AS quest ON quest.id = user_quest.quest_id
    WHERE user_quest.user_id = '28000000-0000-4000-8000-000000000001'
      AND quest.code = 'daily_xp_30'
      AND user_quest.assigned_date = public.gamification_local_date(
        '28000000-0000-4000-8000-000000000001',
        NOW()
      )
  ),
  ROW(30, TRUE),
  'XP quest progress is capped and completed from ledger evidence'
);

SELECT is(
  (
    SELECT total_xp
    FROM public.profiles
    WHERE id = '28000000-0000-4000-8000-000000000001'
  ),
  45,
  'profile XP includes base, quest, and achievement ledgers exactly once'
);

SELECT is(
  (
    SELECT xp_earned
    FROM public.leaderboards
    WHERE user_id = '28000000-0000-4000-8000-000000000001'
      AND week_start = (
        (NOW() AT TIME ZONE 'Asia/Ho_Chi_Minh')::DATE
        - (EXTRACT(ISODOW FROM NOW() AT TIME ZONE 'Asia/Ho_Chi_Minh')::INTEGER - 1)
      )
  ),
  45,
  'weekly leaderboard XP is derived from the same XP ledger'
);

SELECT is(
  (
    SELECT rank
    FROM public.leaderboards
    WHERE user_id = '28000000-0000-4000-8000-000000000001'
  ),
  1,
  'leaderboard rank is server-calculated'
);

SELECT is(
  public.record_gamification_event(
    '28000000-0000-4000-8000-000000000001',
    'lesson_completed',
    'lesson',
    '28000000-0000-4000-8000-000000000010',
    1,
    '28000000-0000-4000-8000-000000000001:lesson_submission:28000000-0000-4000-8000-000000000010'
  ),
  FALSE,
  'replaying an event idempotency key performs no work'
);

SELECT is(
  (
    SELECT COUNT(*)::INTEGER
    FROM public.user_achievements AS unlock
    JOIN public.achievements AS achievement
      ON achievement.id = unlock.achievement_id
    WHERE unlock.user_id = '28000000-0000-4000-8000-000000000001'
      AND achievement.key = 'lesson_1'
  ),
  1,
  'achievement unlocks cannot duplicate'
);

INSERT INTO public.pronunciation_attempts (
  id,
  user_id,
  reference_text,
  pinyin,
  overall_score,
  accuracy_score,
  fluency_score,
  completeness_score,
  recognized_text,
  provider,
  duration_ms,
  client_attempt_id
)
SELECT
  ('28000000-0000-4000-8000-' || LPAD(number::TEXT, 12, '0'))::UUID,
  '28000000-0000-4000-8000-000000000001',
  '你好',
  'nǐ hǎo',
  80,
  80,
  80,
  80,
  '你好',
  'azure',
  1000,
  'gamification-pronunciation-' || number
FROM generate_series(21, 25) AS number;

SELECT is(
  (
    SELECT ROW(progress, completed)
    FROM public.user_daily_quests AS user_quest
    JOIN public.daily_quests AS quest ON quest.id = user_quest.quest_id
    WHERE user_quest.user_id = '28000000-0000-4000-8000-000000000001'
      AND quest.code = 'daily_pronunciation_1'
      AND user_quest.assigned_date = public.gamification_local_date(
        '28000000-0000-4000-8000-000000000001',
        NOW()
      )
  ),
  ROW(1, TRUE),
  'pronunciation quest is populated from persisted assessments'
);

SELECT ok(
  EXISTS (
    SELECT 1
    FROM public.user_achievements AS unlock
    JOIN public.achievements AS achievement
      ON achievement.id = unlock.achievement_id
    WHERE unlock.user_id = '28000000-0000-4000-8000-000000000001'
      AND achievement.key = 'pronunciation_5'
  ),
  'five persisted assessments unlock the pronunciation achievement'
);

SELECT is(
  (
    SELECT COUNT(*)::INTEGER
    FROM public.xp_transactions
    WHERE user_id = '28000000-0000-4000-8000-000000000001'
      AND reason = 'achievement_unlocked'
      AND source_id = (
        SELECT id FROM public.achievements WHERE key = 'pronunciation_5'
      )
  ),
  1,
  'pronunciation achievement XP is not duplicated'
);

SELECT is(
  public.gamification_local_date(
    '28000000-0000-4000-8000-000000000001',
    '2026-07-29 02:00:00+00'::TIMESTAMPTZ
  ),
  '2026-07-29'::DATE,
  'default timezone converts event dates deterministically'
);

UPDATE public.profiles
SET timezone = 'America/Los_Angeles'
WHERE id = '28000000-0000-4000-8000-000000000001';

SELECT is(
  public.gamification_local_date(
    '28000000-0000-4000-8000-000000000001',
    '2026-07-29 02:00:00+00'::TIMESTAMPTZ
  ),
  '2026-07-28'::DATE,
  'user timezone controls daily boundaries'
);

UPDATE public.profiles
SET timezone = 'Invalid/Timezone'
WHERE id = '28000000-0000-4000-8000-000000000001';

SELECT is(
  public.gamification_timezone(
    '28000000-0000-4000-8000-000000000001'
  ),
  'Asia/Ho_Chi_Minh',
  'invalid user timezones fall back without blocking learning'
);

UPDATE public.profiles
SET timezone = 'Asia/Ho_Chi_Minh'
WHERE id = '28000000-0000-4000-8000-000000000001';

INSERT INTO auth.users (
  id,
  aud,
  role,
  email,
  raw_app_meta_data,
  raw_user_meta_data,
  created_at,
  updated_at
)
VALUES (
  '28000000-0000-4000-8000-000000000002',
  'authenticated',
  'authenticated',
  'gamification-other@example.invalid',
  '{"provider":"email","providers":["email"]}'::JSONB,
  '{"display_name":"Private Name"}'::JSONB,
  NOW(),
  NOW()
);

INSERT INTO public.xp_transactions (
  user_id,
  amount,
  reason,
  source_type,
  idempotency_key
)
VALUES (
  '28000000-0000-4000-8000-000000000002',
  5,
  'test_learning_xp',
  'lesson',
  'gamification-other-xp'
);

SELECT is(
  (
    SELECT entry ->> 'display_name'
    FROM jsonb_array_elements(public.get_weekly_leaderboard()) AS entry
    WHERE entry ->> 'user_id' = '28000000-0000-4000-8000-000000000002'
  ),
  'Người học',
  'leaderboard hides other users profile names'
);

SELECT is(
  (
    SELECT entry ->> 'display_name'
    FROM jsonb_array_elements(public.get_weekly_leaderboard()) AS entry
    WHERE entry ->> 'user_id' = '28000000-0000-4000-8000-000000000001'
  ),
  'Gamification Test',
  'leaderboard identifies only the current user'
);

SELECT is(
  (
    SELECT entry ->> 'rank'
    FROM jsonb_array_elements(public.get_weekly_leaderboard()) AS entry
    WHERE entry ->> 'user_id' = '28000000-0000-4000-8000-000000000001'
  ),
  '1',
  'leaderboard RPC returns server rank order'
);

INSERT INTO public.coin_transactions (
  user_id,
  amount,
  reason,
  source_type,
  idempotency_key
)
VALUES (
  '28000000-0000-4000-8000-000000000001',
  100,
  'test_coin_grant',
  'test',
  'gamification-test-coins'
);

SELECT is(
  (
    public.purchase_shop_item(
      (SELECT id FROM public.shop_items WHERE code = 'streak_freeze'),
      'purchase-attempt-1'
    ) ->> 'success'
  )::BOOLEAN,
  TRUE,
  'streak freeze purchase succeeds atomically'
);

SELECT ok(
  (
    SELECT streak_freeze_available
    FROM public.streaks
    WHERE user_id = '28000000-0000-4000-8000-000000000001'
  ),
  'purchased streak freeze has an immediate real effect'
);

SELECT is(
  (
    public.purchase_shop_item(
      (SELECT id FROM public.shop_items WHERE code = 'streak_freeze'),
      'purchase-attempt-1'
    ) ->> 'already_processed'
  )::BOOLEAN,
  TRUE,
  'purchase retry returns the existing confirmed transaction'
);

SELECT is(
  (
    SELECT COUNT(*)::INTEGER
    FROM public.shop_purchases
    WHERE user_id = '28000000-0000-4000-8000-000000000001'
      AND idempotency_key = 'purchase-attempt-1'
  ),
  1,
  'purchase retries do not duplicate charges'
);

SELECT is(
  (
    SELECT COUNT(*)::INTEGER
    FROM public.shop_items
    WHERE is_active
      AND item_type <> 'streak_freeze'
  ),
  0,
  'shop hides items without implemented consumption rules'
);

UPDATE public.streaks
SET current_streak = 5,
    longest_streak = 5,
    last_activity_date = public.gamification_local_date(
      '28000000-0000-4000-8000-000000000001',
      NOW()
    ) - 2
WHERE user_id = '28000000-0000-4000-8000-000000000001';

SELECT lives_ok(
  $$ SELECT public.update_user_streak('28000000-0000-4000-8000-000000000001') $$,
  'trusted activity can consume the streak freeze'
);

SELECT is(
  (
    SELECT ROW(current_streak, streak_freeze_available)
    FROM public.streaks
    WHERE user_id = '28000000-0000-4000-8000-000000000001'
  ),
  ROW(6, FALSE),
  'a one-day gap is preserved once and consumes the freeze'
);

SELECT ok(
  EXISTS (
    SELECT 1
    FROM public.streak_history
    WHERE user_id = '28000000-0000-4000-8000-000000000001'
      AND status = 'freeze_used'
  ),
  'freeze consumption is auditable in streak history'
);

SELECT ok(
  (public.get_gamification_summary() ->> 'todayXp')::INTEGER >= 0
  AND (public.get_gamification_summary() ->> 'streakFreezeAvailable')::BOOLEAN = FALSE,
  'gamification summary uses server-local day and real freeze state'
);

SELECT ok(
  (SELECT is_hidden FROM public.achievements WHERE key = 'ai_50'),
  'achievement with no authoritative completion event is hidden'
);

SELECT * FROM finish();

ROLLBACK;
