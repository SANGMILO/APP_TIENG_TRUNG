-- Phase 6: authoritative AI usage, retry-safe messages, and voice summaries.

ALTER TABLE public.ai_messages
  ADD COLUMN IF NOT EXISTS reply_to_message_id UUID REFERENCES public.ai_messages(id) ON DELETE CASCADE;

CREATE UNIQUE INDEX IF NOT EXISTS idx_ai_messages_one_reply
  ON public.ai_messages(reply_to_message_id)
  WHERE reply_to_message_id IS NOT NULL;

ALTER TABLE public.ai_usage
  ADD COLUMN IF NOT EXISTS user_message_id UUID REFERENCES public.ai_messages(id) ON DELETE SET NULL;

CREATE UNIQUE INDEX IF NOT EXISTS idx_ai_usage_user_message
  ON public.ai_usage(user_message_id)
  WHERE user_message_id IS NOT NULL;

CREATE OR REPLACE FUNCTION public.get_ai_daily_usage()
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = ''
AS $$
DECLARE
  v_user_id UUID := auth.uid();
  v_limit INTEGER;
  v_used INTEGER;
BEGIN
  IF v_user_id IS NULL THEN
    RAISE EXCEPTION 'authentication_required' USING ERRCODE = '42501';
  END IF;

  SELECT COALESCE(s.daily_message_limit, 20)
    INTO v_limit
    FROM public.ai_user_settings AS s
   WHERE s.user_id = v_user_id;
  v_limit := COALESCE(v_limit, 20);

  SELECT COUNT(*)::INTEGER
    INTO v_used
    FROM public.ai_messages AS m
   WHERE m.user_id = v_user_id
     AND m.role = 'user'
     AND m.status = 'completed'
     AND m.created_at >= CURRENT_DATE::TIMESTAMPTZ;

  RETURN jsonb_build_object(
    'allowed', v_used < v_limit,
    'used', v_used,
    'limit', v_limit,
    'remaining', GREATEST(v_limit - v_used, 0)
  );
END;
$$;

REVOKE ALL ON FUNCTION public.get_ai_daily_usage() FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.get_ai_daily_usage() TO authenticated;

CREATE OR REPLACE FUNCTION public.begin_ai_tutor_message(
  p_user_id UUID,
  p_conversation_id UUID,
  p_client_message_id TEXT,
  p_content TEXT
)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = ''
AS $$
DECLARE
  v_message public.ai_messages%ROWTYPE;
  v_assistant public.ai_messages%ROWTYPE;
  v_limit INTEGER;
  v_used INTEGER;
BEGIN
  IF p_user_id IS NULL
     OR p_conversation_id IS NULL
     OR NULLIF(BTRIM(p_client_message_id), '') IS NULL
     OR NULLIF(BTRIM(p_content), '') IS NULL
     OR LENGTH(p_client_message_id) > 200
     OR LENGTH(p_content) > 3000 THEN
    RETURN jsonb_build_object('state', 'invalid_request');
  END IF;

  IF NOT EXISTS (
    SELECT 1
      FROM public.ai_conversations AS c
     WHERE c.id = p_conversation_id
       AND c.user_id = p_user_id
       AND c.status <> 'deleted'
  ) THEN
    RETURN jsonb_build_object('state', 'forbidden');
  END IF;

  PERFORM pg_advisory_xact_lock(
    hashtextextended('ai-daily:' || p_user_id::TEXT || ':' || CURRENT_DATE::TEXT, 0)
  );

  SELECT *
    INTO v_message
    FROM public.ai_messages AS m
   WHERE m.conversation_id = p_conversation_id
     AND m.user_id = p_user_id
     AND m.role = 'user'
     AND m.client_message_id = p_client_message_id
   FOR UPDATE;

  IF FOUND THEN
    IF v_message.content <> BTRIM(p_content) THEN
      RETURN jsonb_build_object('state', 'idempotency_conflict');
    END IF;

    SELECT *
      INTO v_assistant
      FROM public.ai_messages AS m
     WHERE m.reply_to_message_id = v_message.id
       AND m.user_id = p_user_id
     LIMIT 1;

    IF FOUND THEN
      RETURN jsonb_build_object(
        'state', 'completed',
        'userMessageId', v_message.id,
        'assistantMessage', to_jsonb(v_assistant)
      );
    END IF;

    IF v_message.status = 'sending'
       AND v_message.created_at > NOW() - INTERVAL '2 minutes' THEN
      RETURN jsonb_build_object('state', 'in_progress', 'userMessageId', v_message.id);
    END IF;

    UPDATE public.ai_messages
       SET status = 'sending'
     WHERE id = v_message.id;

    RETURN jsonb_build_object('state', 'process', 'userMessageId', v_message.id);
  END IF;

  SELECT COALESCE(s.daily_message_limit, 20)
    INTO v_limit
    FROM public.ai_user_settings AS s
   WHERE s.user_id = p_user_id;
  v_limit := COALESCE(v_limit, 20);

  SELECT COUNT(*)::INTEGER
    INTO v_used
    FROM public.ai_messages AS m
   WHERE m.user_id = p_user_id
     AND m.role = 'user'
     AND m.status IN ('sending', 'completed')
     AND m.created_at >= CURRENT_DATE::TIMESTAMPTZ;

  IF v_used >= v_limit THEN
    RETURN jsonb_build_object('state', 'daily_limit', 'used', v_used, 'limit', v_limit);
  END IF;

  INSERT INTO public.ai_messages (
    conversation_id,
    user_id,
    role,
    content,
    client_message_id,
    status
  )
  VALUES (
    p_conversation_id,
    p_user_id,
    'user',
    BTRIM(p_content),
    p_client_message_id,
    'sending'
  )
  RETURNING * INTO v_message;

  RETURN jsonb_build_object('state', 'process', 'userMessageId', v_message.id);
END;
$$;

CREATE OR REPLACE FUNCTION public.complete_ai_tutor_message(
  p_user_id UUID,
  p_user_message_id UUID,
  p_content TEXT,
  p_structured_data JSONB,
  p_provider TEXT,
  p_model TEXT,
  p_input_tokens INTEGER,
  p_output_tokens INTEGER,
  p_latency_ms INTEGER,
  p_prompt_version TEXT
)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = ''
AS $$
DECLARE
  v_user_message public.ai_messages%ROWTYPE;
  v_assistant public.ai_messages%ROWTYPE;
BEGIN
  SELECT *
    INTO v_user_message
    FROM public.ai_messages AS m
   WHERE m.id = p_user_message_id
     AND m.user_id = p_user_id
     AND m.role = 'user'
   FOR UPDATE;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'user_message_not_found' USING ERRCODE = 'P0002';
  END IF;

  SELECT *
    INTO v_assistant
    FROM public.ai_messages AS m
   WHERE m.reply_to_message_id = v_user_message.id
   LIMIT 1;

  IF NOT FOUND THEN
    INSERT INTO public.ai_messages (
      conversation_id,
      user_id,
      role,
      content,
      structured_data,
      provider,
      model,
      input_tokens,
      output_tokens,
      latency_ms,
      reply_to_message_id,
      status
    )
    VALUES (
      v_user_message.conversation_id,
      p_user_id,
      'assistant',
      p_content,
      p_structured_data,
      p_provider,
      p_model,
      GREATEST(COALESCE(p_input_tokens, 0), 0),
      GREATEST(COALESCE(p_output_tokens, 0), 0),
      GREATEST(COALESCE(p_latency_ms, 0), 0),
      v_user_message.id,
      'completed'
    )
    RETURNING * INTO v_assistant;
  END IF;

  UPDATE public.ai_messages
     SET status = 'completed'
   WHERE id = v_user_message.id;

  UPDATE public.ai_conversations AS c
     SET message_count = (
           SELECT COUNT(*)::INTEGER
             FROM public.ai_messages AS m
            WHERE m.conversation_id = c.id
              AND m.status = 'completed'
         ),
         last_message_at = v_assistant.created_at,
         updated_at = NOW()
   WHERE c.id = v_user_message.conversation_id
     AND c.user_id = p_user_id;

  INSERT INTO public.ai_usage (
    user_id,
    conversation_id,
    user_message_id,
    provider,
    model,
    input_tokens,
    output_tokens,
    total_tokens,
    latency_ms,
    status,
    prompt_version
  )
  VALUES (
    p_user_id,
    v_user_message.conversation_id,
    v_user_message.id,
    p_provider,
    p_model,
    GREATEST(COALESCE(p_input_tokens, 0), 0),
    GREATEST(COALESCE(p_output_tokens, 0), 0),
    GREATEST(COALESCE(p_input_tokens, 0), 0) + GREATEST(COALESCE(p_output_tokens, 0), 0),
    GREATEST(COALESCE(p_latency_ms, 0), 0),
    'success',
    p_prompt_version
  )
  ON CONFLICT (user_message_id) WHERE user_message_id IS NOT NULL DO NOTHING;

  RETURN to_jsonb(v_assistant);
END;
$$;

CREATE OR REPLACE FUNCTION public.fail_ai_tutor_message(
  p_user_id UUID,
  p_user_message_id UUID
)
RETURNS VOID
LANGUAGE sql
SECURITY DEFINER
SET search_path = ''
AS $$
  UPDATE public.ai_messages AS m
     SET status = 'failed'
   WHERE m.id = p_user_message_id
     AND m.user_id = p_user_id
     AND m.role = 'user'
     AND NOT EXISTS (
       SELECT 1
         FROM public.ai_messages AS reply
        WHERE reply.reply_to_message_id = m.id
     );
$$;

REVOKE ALL ON FUNCTION public.begin_ai_tutor_message(UUID, UUID, TEXT, TEXT) FROM PUBLIC, anon, authenticated;
REVOKE ALL ON FUNCTION public.complete_ai_tutor_message(UUID, UUID, TEXT, JSONB, TEXT, TEXT, INTEGER, INTEGER, INTEGER, TEXT) FROM PUBLIC, anon, authenticated;
REVOKE ALL ON FUNCTION public.fail_ai_tutor_message(UUID, UUID) FROM PUBLIC, anon, authenticated;
GRANT EXECUTE ON FUNCTION public.begin_ai_tutor_message(UUID, UUID, TEXT, TEXT) TO service_role;
GRANT EXECUTE ON FUNCTION public.complete_ai_tutor_message(UUID, UUID, TEXT, JSONB, TEXT, TEXT, INTEGER, INTEGER, INTEGER, TEXT) TO service_role;
GRANT EXECUTE ON FUNCTION public.fail_ai_tutor_message(UUID, UUID) TO service_role;

ALTER TABLE public.voice_turns
  ADD COLUMN IF NOT EXISTS client_turn_id TEXT;

CREATE UNIQUE INDEX IF NOT EXISTS idx_voice_turns_client_id
  ON public.voice_turns(session_id, client_turn_id)
  ;

REVOKE INSERT, UPDATE, DELETE ON public.voice_turns FROM authenticated;

CREATE OR REPLACE FUNCTION public.check_voice_daily_limit(
  p_user_id UUID,
  p_daily_limit_ms INTEGER DEFAULT 300000
)
RETURNS BOOLEAN
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = ''
AS $$
DECLARE
  v_used_ms BIGINT;
BEGIN
  IF current_setting('request.jwt.claim.role', true) IS DISTINCT FROM 'service_role'
     AND (auth.uid() IS NULL OR p_user_id IS DISTINCT FROM auth.uid()) THEN
    RAISE EXCEPTION 'unauthorized_voice_quota_check' USING ERRCODE = '42501';
  END IF;

  SELECT COALESCE(SUM(GREATEST(COALESCE(t.user_audio_duration_ms, 0), 0)), 0)
    INTO v_used_ms
    FROM public.voice_turns AS t
   WHERE t.user_id = p_user_id
     AND t.status NOT IN ('failed', 'cancelled')
     AND t.created_at >= CURRENT_DATE::TIMESTAMPTZ;

  RETURN v_used_ms < GREATEST(COALESCE(p_daily_limit_ms, 300000), 0);
END;
$$;

REVOKE ALL ON FUNCTION public.check_voice_daily_limit(UUID, INTEGER) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.check_voice_daily_limit(UUID, INTEGER) TO authenticated, service_role;

CREATE OR REPLACE FUNCTION public.complete_voice_session_authoritative(p_session_id UUID)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = ''
AS $$
DECLARE
  v_user_id UUID := auth.uid();
  v_session public.voice_sessions%ROWTYPE;
  v_total_duration_ms INTEGER;
  v_user_speech_ms INTEGER;
  v_ai_speech_ms INTEGER;
  v_turn_count INTEGER;
  v_new_words_count INTEGER;
  v_corrections_count INTEGER;
  v_xp_before INTEGER;
  v_xp_after INTEGER;
  v_idempotency_key TEXT;
BEGIN
  IF v_user_id IS NULL THEN
    RAISE EXCEPTION 'authentication_required' USING ERRCODE = '42501';
  END IF;

  SELECT *
    INTO v_session
    FROM public.voice_sessions AS s
   WHERE s.id = p_session_id
     AND s.user_id = v_user_id
   FOR UPDATE;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'voice_session_not_found' USING ERRCODE = 'P0002';
  END IF;

  SELECT
    COUNT(*)::INTEGER,
    COALESCE(SUM(GREATEST(COALESCE(t.user_audio_duration_ms, 0), 0)), 0)::INTEGER,
    COALESCE(SUM(GREATEST(COALESCE(t.assistant_audio_duration_ms, 0), 0)), 0)::INTEGER,
    COALESCE(SUM(
      CASE
        WHEN jsonb_typeof(m.structured_data -> 'newVocabulary') = 'array'
          THEN jsonb_array_length(m.structured_data -> 'newVocabulary')
        ELSE 0
      END
    ), 0)::INTEGER,
    COUNT(*) FILTER (
      WHERE m.structured_data -> 'correction' IS NOT NULL
        AND m.structured_data -> 'correction' <> 'null'::JSONB
    )::INTEGER
    INTO
      v_turn_count,
      v_user_speech_ms,
      v_ai_speech_ms,
      v_new_words_count,
      v_corrections_count
    FROM public.voice_turns AS t
    LEFT JOIN public.ai_messages AS m ON m.id = t.assistant_message_id
   WHERE t.session_id = p_session_id
     AND t.user_id = v_user_id
     AND t.status = 'completed';

  v_total_duration_ms := GREATEST(
    0,
    FLOOR(EXTRACT(EPOCH FROM (COALESCE(v_session.ended_at, NOW()) - v_session.started_at)) * 1000)::INTEGER
  );

  SELECT COALESCE(SUM(x.amount), 0)::INTEGER
    INTO v_xp_before
    FROM public.xp_transactions AS x
   WHERE x.user_id = v_user_id
     AND x.source_type = 'voice_session'
     AND x.source_id = p_session_id;

  IF v_user_speech_ms >= 30000 AND v_turn_count >= 3 THEN
    v_idempotency_key := v_user_id || ':voice_session:' || p_session_id;
    PERFORM public.reward_xp(
      v_user_id,
      10,
      'voice_session',
      'voice_session',
      p_session_id,
      v_idempotency_key
    );
  END IF;

  UPDATE public.voice_sessions
     SET status = 'completed',
         ended_at = COALESCE(ended_at, NOW()),
         total_duration_ms = v_total_duration_ms,
         user_speech_ms = v_user_speech_ms,
         ai_speech_ms = v_ai_speech_ms,
         turn_count = v_turn_count
   WHERE id = p_session_id;

  PERFORM public.update_user_streak(v_user_id);

  SELECT COALESCE(SUM(x.amount), 0)::INTEGER
    INTO v_xp_after
    FROM public.xp_transactions AS x
   WHERE x.user_id = v_user_id
     AND x.source_type = 'voice_session'
     AND x.source_id = p_session_id;

  RETURN jsonb_build_object(
    'sessionId', p_session_id,
    'totalDurationMs', v_total_duration_ms,
    'userSpeechMs', v_user_speech_ms,
    'aiSpeechMs', v_ai_speech_ms,
    'turnCount', v_turn_count,
    'newWordsCount', v_new_words_count,
    'correctionsCount', v_corrections_count,
    'xpEarned', GREATEST(v_xp_after, v_xp_before)
  );
END;
$$;

REVOKE ALL ON FUNCTION public.complete_voice_session(UUID, INTEGER, INTEGER, INTEGER, INTEGER)
  FROM PUBLIC, anon, authenticated;
REVOKE ALL ON FUNCTION public.complete_voice_session_authoritative(UUID) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.complete_voice_session_authoritative(UUID) TO authenticated;
