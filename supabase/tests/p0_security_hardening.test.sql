BEGIN;

SELECT plan(26);

-- Server-owned profile fields are not directly writable by authenticated users.
SELECT ok(NOT has_column_privilege('authenticated', 'public.profiles', 'role', 'UPDATE'), 'role is server-controlled');
SELECT ok(NOT has_column_privilege('authenticated', 'public.profiles', 'total_xp', 'UPDATE'), 'total_xp is server-controlled');
SELECT ok(NOT has_column_privilege('authenticated', 'public.profiles', 'total_coins', 'UPDATE'), 'total_coins is server-controlled');
SELECT ok(NOT has_column_privilege('authenticated', 'public.profiles', 'current_level', 'UPDATE'), 'current_level is server-controlled');
SELECT ok(NOT has_column_privilege('authenticated', 'public.profiles', 'current_streak', 'UPDATE'), 'current_streak is server-controlled');
SELECT ok(NOT has_column_privilege('authenticated', 'public.profiles', 'longest_streak', 'UPDATE'), 'longest_streak is server-controlled');
SELECT ok(NOT has_column_privilege('authenticated', 'public.profiles', 'hearts', 'UPDATE'), 'hearts is server-controlled');
SELECT ok(NOT has_column_privilege('authenticated', 'public.profiles', 'updated_at', 'UPDATE'), 'updated_at is database-controlled');

-- Existing user-editable profile and onboarding fields remain writable.
SELECT ok(has_column_privilege('authenticated', 'public.profiles', 'username', 'UPDATE'), 'username remains editable');
SELECT ok(has_column_privilege('authenticated', 'public.profiles', 'display_name', 'UPDATE'), 'display_name remains editable');
SELECT ok(has_column_privilege('authenticated', 'public.profiles', 'avatar_url', 'UPDATE'), 'avatar_url remains editable');
SELECT ok(has_column_privilege('authenticated', 'public.profiles', 'native_language', 'UPDATE'), 'native_language remains editable');
SELECT ok(has_column_privilege('authenticated', 'public.profiles', 'timezone', 'UPDATE'), 'timezone remains editable');
SELECT ok(has_column_privilege('authenticated', 'public.profiles', 'chinese_level', 'UPDATE'), 'chinese_level remains editable');
SELECT ok(has_column_privilege('authenticated', 'public.profiles', 'daily_goal_minutes', 'UPDATE'), 'daily_goal_minutes remains editable');
SELECT ok(has_column_privilege('authenticated', 'public.profiles', 'daily_goal_xp', 'UPDATE'), 'daily_goal_xp remains editable');
SELECT ok(has_column_privilege('authenticated', 'public.profiles', 'learning_purpose', 'UPDATE'), 'learning_purpose remains editable');
SELECT ok(has_column_privilege('authenticated', 'public.profiles', 'onboarding_completed', 'UPDATE'), 'onboarding completion remains editable');

-- Direct economy manipulation is denied while safe server entry points remain.
SELECT ok(NOT has_table_privilege('authenticated', 'public.xp_transactions', 'INSERT'), 'authenticated cannot insert XP ledger rows');
SELECT ok(NOT has_table_privilege('authenticated', 'public.coin_transactions', 'INSERT'), 'authenticated cannot insert coin ledger rows');
SELECT ok(NOT has_function_privilege('authenticated', 'public.reward_xp(uuid,integer,text,text,uuid,text)', 'EXECUTE'), 'authenticated cannot call reward_xp');
SELECT ok(NOT has_function_privilege('anon', 'public.reward_xp(uuid,integer,text,text,uuid,text)', 'EXECUTE'), 'anon cannot call reward_xp');
SELECT ok(
  has_function_privilege(
    'authenticated',
    'public.complete_lesson_transactional(uuid,uuid,jsonb)',
    'EXECUTE'
  )
  AND NOT has_function_privilege(
    'authenticated',
    'public.complete_lesson(uuid,real,integer,integer,integer)',
    'EXECUTE'
  ),
  'authenticated can complete lessons only through the transactional RPC'
);
SELECT ok(has_function_privilege('authenticated', 'public.admin_update_user_role(uuid,text)', 'EXECUTE'), 'authenticated can reach the role RPC, which enforces super-admin in its body');
SELECT ok(has_table_privilege('authenticated', 'public.xp_transactions', 'SELECT'), 'users retain read access to their XP ledger');
SELECT ok(has_table_privilege('authenticated', 'public.profiles', 'SELECT'), 'users retain profile read access');

SELECT * FROM finish();

ROLLBACK;
