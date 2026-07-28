-- Align content publication with the client RBAC contract and make version
-- creation safe under concurrent publish requests.

CREATE OR REPLACE FUNCTION public.publish_content(
  p_entity_type TEXT,
  p_entity_id UUID,
  p_change_summary TEXT DEFAULT NULL
)
RETURNS BOOLEAN
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = ''
AS $$
DECLARE
  v_user_id UUID := auth.uid();
  v_snapshot JSONB;
  v_status TEXT;
  v_version INTEGER;
BEGIN
  IF v_user_id IS NULL THEN
    RAISE EXCEPTION USING
      ERRCODE = '42501',
      MESSAGE = 'Authentication required';
  END IF;

  -- Editors may prepare and review content. Publication is deliberately
  -- reserved for admins and super-admins.
  IF NOT public.is_admin() THEN
    RAISE EXCEPTION USING
      ERRCODE = '42501',
      MESSAGE = 'Permission denied';
  END IF;

  IF p_entity_id IS NULL THEN
    RAISE EXCEPTION USING
      ERRCODE = '22023',
      MESSAGE = 'Content identifier is required';
  END IF;

  IF LENGTH(COALESCE(p_change_summary, '')) > 1000 THEN
    RAISE EXCEPTION USING
      ERRCODE = '22023',
      MESSAGE = 'Change summary is too long';
  END IF;

  -- Lock the entity before deriving the next version number. This serializes
  -- concurrent publication attempts for the same entity without a global lock.
  CASE p_entity_type
    WHEN 'course' THEN
      SELECT to_jsonb(c.*), c.status
      INTO v_snapshot, v_status
      FROM public.courses AS c
      WHERE c.id = p_entity_id
      FOR UPDATE;
    WHEN 'lesson' THEN
      SELECT to_jsonb(l.*), l.status
      INTO v_snapshot, v_status
      FROM public.lessons AS l
      WHERE l.id = p_entity_id
      FOR UPDATE;
    WHEN 'vocabulary' THEN
      SELECT to_jsonb(v.*), v.status
      INTO v_snapshot, v_status
      FROM public.vocabulary AS v
      WHERE v.id = p_entity_id
      FOR UPDATE;
    WHEN 'video' THEN
      SELECT to_jsonb(v.*), v.status
      INTO v_snapshot, v_status
      FROM public.videos AS v
      WHERE v.id = p_entity_id
      FOR UPDATE;
    ELSE
      RAISE EXCEPTION USING
        ERRCODE = '22023',
        MESSAGE = 'Unknown entity type: ' || COALESCE(p_entity_type, '<null>');
  END CASE;

  IF v_snapshot IS NULL THEN
    RAISE EXCEPTION USING
      ERRCODE = 'P0002',
      MESSAGE = 'Content not found';
  END IF;

  IF v_status = 'archived' THEN
    RAISE EXCEPTION USING
      ERRCODE = '22023',
      MESSAGE = 'Archived content cannot be published';
  END IF;

  SELECT COALESCE(MAX(cv.version_number), 0) + 1
  INTO v_version
  FROM public.content_versions AS cv
  WHERE cv.entity_type = p_entity_type
    AND cv.entity_id = p_entity_id;

  CASE p_entity_type
    WHEN 'course' THEN
      UPDATE public.courses
      SET status = 'published', updated_at = NOW()
      WHERE id = p_entity_id;
    WHEN 'lesson' THEN
      UPDATE public.lessons
      SET status = 'published', updated_at = NOW()
      WHERE id = p_entity_id;
    WHEN 'vocabulary' THEN
      UPDATE public.vocabulary
      SET status = 'published', updated_at = NOW()
      WHERE id = p_entity_id;
    WHEN 'video' THEN
      UPDATE public.videos
      SET status = 'published', updated_at = NOW()
      WHERE id = p_entity_id;
  END CASE;

  INSERT INTO public.content_versions (
    entity_type,
    entity_id,
    version_number,
    snapshot,
    change_summary,
    created_by
  )
  VALUES (
    p_entity_type,
    p_entity_id,
    v_version,
    v_snapshot,
    NULLIF(BTRIM(p_change_summary), ''),
    v_user_id
  );

  INSERT INTO public.admin_activity_logs (
    user_id,
    action,
    resource_type,
    resource_id,
    entity_type,
    details
  )
  VALUES (
    v_user_id,
    'PUBLISH',
    p_entity_type,
    p_entity_id,
    p_entity_type,
    jsonb_build_object(
      'version',
      v_version,
      'summary',
      NULLIF(BTRIM(p_change_summary), '')
    )
  );

  RETURN TRUE;
END;
$$;

REVOKE ALL ON FUNCTION public.publish_content(TEXT, UUID, TEXT)
  FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.publish_content(TEXT, UUID, TEXT)
  TO authenticated;

-- Trigger helpers are invoked by PostgreSQL, never by the Data API. Remove the
-- default PUBLIC execute privilege so they do not appear as callable RPCs.
REVOKE ALL ON FUNCTION public.emit_lesson_gamification_event()
  FROM PUBLIC, anon, authenticated;
REVOKE ALL ON FUNCTION public.emit_pronunciation_gamification_event()
  FROM PUBLIC, anon, authenticated;
REVOKE ALL ON FUNCTION public.emit_review_gamification_event()
  FROM PUBLIC, anon, authenticated;
REVOKE ALL ON FUNCTION public.emit_streak_achievement_check()
  FROM PUBLIC, anon, authenticated;
REVOKE ALL ON FUNCTION public.emit_video_gamification_event()
  FROM PUBLIC, anon, authenticated;
REVOKE ALL ON FUNCTION public.emit_voice_gamification_event()
  FROM PUBLIC, anon, authenticated;
REVOKE ALL ON FUNCTION public.emit_xp_gamification_event()
  FROM PUBLIC, anon, authenticated;
REVOKE ALL ON FUNCTION public.update_total_coins()
  FROM PUBLIC, anon, authenticated;
REVOKE ALL ON FUNCTION public.update_total_xp()
  FROM PUBLIC, anon, authenticated;
