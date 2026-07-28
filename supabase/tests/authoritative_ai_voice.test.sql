BEGIN;

SELECT plan(30);

SELECT ok(
  has_function_privilege('authenticated', 'public.get_ai_daily_usage()', 'EXECUTE'),
  'authenticated users can read their authoritative AI usage'
);

SELECT ok(
  NOT has_function_privilege('anon', 'public.get_ai_daily_usage()', 'EXECUTE'),
  'anonymous users cannot read AI usage'
);

SELECT ok(
  has_function_privilege(
    'service_role',
    'public.begin_ai_tutor_message(uuid,uuid,text,text)',
    'EXECUTE'
  )
  AND NOT has_function_privilege(
    'authenticated',
    'public.begin_ai_tutor_message(uuid,uuid,text,text)',
    'EXECUTE'
  ),
  'only the server can reserve AI messages'
);

SELECT ok(
  NOT has_table_privilege('authenticated', 'public.voice_turns', 'INSERT')
  AND NOT has_table_privilege('authenticated', 'public.voice_turns', 'UPDATE')
  AND NOT has_table_privilege('authenticated', 'public.voice_turns', 'DELETE'),
  'clients cannot forge voice turn evidence'
);

SELECT ok(
  has_function_privilege(
    'authenticated',
    'public.check_voice_daily_limit(uuid,integer)',
    'EXECUTE'
  )
  AND has_function_privilege(
    'service_role',
    'public.check_voice_daily_limit(uuid,integer)',
    'EXECUTE'
  )
  AND NOT has_function_privilege(
    'anon',
    'public.check_voice_daily_limit(uuid,integer)',
    'EXECUTE'
  ),
  'voice quota checks are limited to the user and trusted server'
);

SELECT ok(
  has_function_privilege(
    'authenticated',
    'public.complete_voice_session_authoritative(uuid)',
    'EXECUTE'
  )
  AND NOT has_function_privilege(
    'authenticated',
    'public.complete_voice_session(uuid,integer,integer,integer,integer)',
    'EXECUTE'
  ),
  'voice sessions can only be completed from server-derived turn evidence'
);

SELECT throws_ok(
  $$ SELECT public.get_ai_daily_usage() $$,
  '42501',
  'authentication_required',
  'AI usage requires authentication'
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
  '26000000-0000-0000-0000-000000000001',
  'authenticated',
  'authenticated',
  'ai-voice-test@example.invalid',
  '{"provider":"email","providers":["email"]}'::JSONB,
  '{"display_name":"AI Voice Test"}'::JSONB,
  NOW(),
  NOW()
);

SET LOCAL "request.jwt.claim.sub" = '26000000-0000-0000-0000-000000000001';
SET LOCAL "request.jwt.claim.role" = 'authenticated';

INSERT INTO public.ai_conversations (id, user_id, mode, status)
VALUES (
  '26000000-0000-0000-0000-000000000010',
  '26000000-0000-0000-0000-000000000001',
  'general',
  'active'
);

SELECT is(
  public.get_ai_daily_usage() ->> 'limit',
  '20',
  'AI usage reads the configured default limit'
);

SELECT is(
  public.begin_ai_tutor_message(
    '26000000-0000-0000-0000-000000000001',
    '26000000-0000-0000-0000-000000000010',
    'client-message-1',
    '你好'
  ) ->> 'state',
  'process',
  'a new AI message is reserved for processing'
);

SELECT is(
  (
    SELECT status
      FROM public.ai_messages
     WHERE client_message_id = 'client-message-1'
  ),
  'sending',
  'a reserved message remains pending until its reply is stored'
);

SELECT is(
  (
    SELECT COUNT(*)::INTEGER
      FROM public.ai_messages
     WHERE client_message_id = 'client-message-1'
  ),
  1,
  'reserving the same client message does not duplicate it'
)
FROM public.begin_ai_tutor_message(
  '26000000-0000-0000-0000-000000000001',
  '26000000-0000-0000-0000-000000000010',
  'client-message-1',
  '你好'
);

SELECT is(
  public.begin_ai_tutor_message(
    '26000000-0000-0000-0000-000000000001',
    '26000000-0000-0000-0000-000000000010',
    'client-message-1',
    '不同内容'
  ) ->> 'state',
  'idempotency_conflict',
  'a retry key cannot be reused for different content'
);

SELECT is(
  public.complete_ai_tutor_message(
    '26000000-0000-0000-0000-000000000001',
    (
      SELECT id
        FROM public.ai_messages
       WHERE client_message_id = 'client-message-1'
    ),
    '{"reply":{"chinese":"你好！"}}',
    '{
      "reply":{"chinese":"你好！","pinyin":"nǐ hǎo","translationVi":"Xin chào"},
      "correction":{"original":"你号","corrected":"你好","explanationVi":"Sửa chữ","errorType":"word_choice","severity":"minor"},
      "newVocabulary":[{"chinese":"你好","pinyin":"nǐ hǎo","meaningVi":"xin chào"}],
      "suggestedReplies":[],
      "learningTip":null,
      "practiceExercise":null
    }'::JSONB,
    'test',
    'test-model',
    10,
    5,
    25,
    'test-v1'
  ) ->> 'role',
  'assistant',
  'AI completion atomically returns the persisted assistant reply'
);

SELECT ok(
  EXISTS (
    SELECT 1
      FROM public.ai_messages AS assistant
      JOIN public.ai_messages AS user_message
        ON user_message.id = assistant.reply_to_message_id
     WHERE user_message.client_message_id = 'client-message-1'
       AND assistant.role = 'assistant'
  ),
  'the assistant reply is linked to the exact user message'
);

SELECT is(
  (
    SELECT status
      FROM public.ai_messages
     WHERE client_message_id = 'client-message-1'
  ),
  'completed',
  'the user message becomes completed only with its reply'
);

SELECT is(
  (SELECT COUNT(*)::INTEGER FROM public.ai_usage),
  1,
  'successful AI usage is recorded once'
);

SELECT is(
  public.begin_ai_tutor_message(
    '26000000-0000-0000-0000-000000000001',
    '26000000-0000-0000-0000-000000000010',
    'client-message-1',
    '你好'
  ) ->> 'state',
  'completed',
  'a completed retry returns the linked existing result'
);

SELECT lives_ok(
  $$
    SELECT public.complete_ai_tutor_message(
      '26000000-0000-0000-0000-000000000001',
      (SELECT id FROM public.ai_messages WHERE client_message_id = 'client-message-1'),
      '{}',
      '{}'::JSONB,
      'test',
      'test-model',
      1,
      1,
      1,
      'test-v1'
    )
  $$,
  'completion is safe to retry'
);

SELECT is(
  (
    SELECT COUNT(*)::INTEGER
      FROM public.ai_messages
     WHERE role = 'assistant'
       AND reply_to_message_id IS NOT NULL
  ),
  1,
  'completion retries do not duplicate assistant replies'
);

SELECT is(
  (public.get_ai_daily_usage() ->> 'used')::INTEGER,
  1,
  'usage display counts completed user messages'
);

INSERT INTO public.ai_user_settings (user_id, daily_message_limit)
VALUES ('26000000-0000-0000-0000-000000000001', 1);

SELECT is(
  public.begin_ai_tutor_message(
    '26000000-0000-0000-0000-000000000001',
    '26000000-0000-0000-0000-000000000010',
    'client-message-2',
    '再见'
  ) ->> 'state',
  'daily_limit',
  'the same database setting enforces the AI daily limit'
);

INSERT INTO public.voice_sessions (
  id,
  user_id,
  conversation_id,
  mode,
  status,
  started_at
)
VALUES (
  '26000000-0000-0000-0000-000000000020',
  '26000000-0000-0000-0000-000000000001',
  '26000000-0000-0000-0000-000000000010',
  'general',
  'active',
  NOW() - INTERVAL '1 minute'
);

INSERT INTO public.voice_turns (
  id,
  session_id,
  user_id,
  assistant_message_id,
  client_turn_id,
  user_audio_duration_ms,
  assistant_audio_duration_ms,
  status
)
VALUES
  (
    '26000000-0000-0000-0000-000000000031',
    '26000000-0000-0000-0000-000000000020',
    '26000000-0000-0000-0000-000000000001',
    (SELECT id FROM public.ai_messages WHERE role = 'assistant' LIMIT 1),
    'turn-1',
    11000,
    2000,
    'completed'
  ),
  (
    '26000000-0000-0000-0000-000000000032',
    '26000000-0000-0000-0000-000000000020',
    '26000000-0000-0000-0000-000000000001',
    NULL,
    'turn-2',
    11000,
    2000,
    'completed'
  ),
  (
    '26000000-0000-0000-0000-000000000033',
    '26000000-0000-0000-0000-000000000020',
    '26000000-0000-0000-0000-000000000001',
    NULL,
    'turn-3',
    11000,
    2000,
    'completed'
  );

SELECT is(
  (
    public.complete_voice_session_authoritative(
      '26000000-0000-0000-0000-000000000020'
    ) ->> 'userSpeechMs'
  )::INTEGER,
  33000,
  'voice summary derives user speech from persisted turns'
);

SELECT is(
  (
    SELECT turn_count
      FROM public.voice_sessions
     WHERE id = '26000000-0000-0000-0000-000000000020'
  ),
  3,
  'voice completion stores the server-counted turns'
);

SELECT is(
  (
    public.complete_voice_session_authoritative(
      '26000000-0000-0000-0000-000000000020'
    ) ->> 'aiSpeechMs'
  )::INTEGER,
  6000,
  'voice summary accumulates persisted AI speech duration'
);

SELECT is(
  (
    SELECT ROW(
      (summary ->> 'newWordsCount')::INTEGER,
      (summary ->> 'correctionsCount')::INTEGER
    )
    FROM (
      SELECT public.complete_voice_session_authoritative(
        '26000000-0000-0000-0000-000000000020'
      ) AS summary
    ) AS result
  ),
  ROW(1, 1),
  'voice summary derives vocabulary and corrections from linked tutor replies'
);

SELECT is(
  (
    SELECT COALESCE(SUM(amount), 0)::INTEGER
      FROM public.xp_transactions
     WHERE source_type = 'voice_session'
       AND source_id = '26000000-0000-0000-0000-000000000020'
  ),
  10,
  'meaningful server-verified voice practice awards XP'
);

SELECT lives_ok(
  $$
    SELECT public.complete_voice_session_authoritative(
      '26000000-0000-0000-0000-000000000020'
    )
  $$,
  'voice completion is safe to retry'
);

SELECT is(
  (
    SELECT COUNT(*)::INTEGER
      FROM public.xp_transactions
     WHERE source_type = 'voice_session'
       AND source_id = '26000000-0000-0000-0000-000000000020'
  ),
  1,
  'voice completion retries never duplicate XP'
);

SELECT is(
  (
    SELECT ROW(user_speech_ms, ai_speech_ms, turn_count, status)
      FROM public.voice_sessions
     WHERE id = '26000000-0000-0000-0000-000000000020'
  ),
  ROW(33000, 6000, 3, 'completed'::TEXT),
  'the stored session state matches its authoritative summary'
);

SELECT ok(
  public.check_voice_daily_limit(
    '26000000-0000-0000-0000-000000000001',
    34000
  ),
  'voice quota uses persisted turn duration'
);

SELECT * FROM finish();

ROLLBACK;
