-- Bring existing users forward from authoritative evidence. Achievement rewards
-- are idempotent, and the current board is rebuilt from the XP ledger so prior
-- client-written totals cannot survive as visible weekly XP.

DO $gamification_backfill$
DECLARE
  v_user_id UUID;
  v_week_start DATE := (
    (NOW() AT TIME ZONE 'Asia/Ho_Chi_Minh')::DATE
    - (
      EXTRACT(ISODOW FROM NOW() AT TIME ZONE 'Asia/Ho_Chi_Minh')::INTEGER
      - 1
    )
  );
BEGIN
  FOR v_user_id IN
    SELECT profile.id
    FROM public.profiles AS profile
  LOOP
    PERFORM public.evaluate_user_achievements(v_user_id);
  END LOOP;

  UPDATE public.leaderboards AS board
     SET xp_earned = COALESCE(
           (
             SELECT SUM(transaction.amount)::INTEGER
             FROM public.xp_transactions AS transaction
             WHERE transaction.user_id = board.user_id
               AND (
                 transaction.created_at AT TIME ZONE 'Asia/Ho_Chi_Minh'
               )::DATE >= v_week_start
               AND (
                 transaction.created_at AT TIME ZONE 'Asia/Ho_Chi_Minh'
               )::DATE < v_week_start + 7
           ),
           0
         ),
         league = 'jade'
   WHERE board.week_start = v_week_start;

  INSERT INTO public.leaderboards (
    user_id,
    week_start,
    xp_earned,
    league
  )
  SELECT
    transaction.user_id,
    v_week_start,
    SUM(transaction.amount)::INTEGER,
    'jade'
  FROM public.xp_transactions AS transaction
  WHERE (
          transaction.created_at AT TIME ZONE 'Asia/Ho_Chi_Minh'
        )::DATE >= v_week_start
    AND (
          transaction.created_at AT TIME ZONE 'Asia/Ho_Chi_Minh'
        )::DATE < v_week_start + 7
  GROUP BY transaction.user_id
  ON CONFLICT (user_id, week_start)
  DO UPDATE SET
    xp_earned = EXCLUDED.xp_earned,
    league = EXCLUDED.league;

  WITH ranked AS (
    SELECT
      board.id,
      ROW_NUMBER() OVER (
        PARTITION BY board.week_start, board.league
        ORDER BY board.xp_earned DESC, board.user_id
      )::INTEGER AS new_rank
    FROM public.leaderboards AS board
    WHERE board.week_start = v_week_start
  )
  UPDATE public.leaderboards AS board
     SET rank = ranked.new_rank
    FROM ranked
   WHERE board.id = ranked.id;
END;
$gamification_backfill$;
