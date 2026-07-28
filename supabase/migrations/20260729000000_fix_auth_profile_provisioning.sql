-- Repair provider-agnostic profile provisioning and recover orphaned auth users.
-- Additive migration: do not weaken P0-A profile column restrictions.

-- ============================================
-- 1. PRIMARY AUTH.USERS PROVISIONING TRIGGER
-- ============================================

CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
DECLARE
  v_email TEXT;
  v_display_name TEXT;
  v_avatar_url TEXT;
BEGIN
  v_email := COALESCE(
    NULLIF(BTRIM(NEW.email), ''),
    NULLIF(BTRIM(NEW.raw_user_meta_data ->> 'email'), ''),
    NEW.id::TEXT || '@profile.invalid'
  );
  v_display_name := NULLIF(BTRIM(COALESCE(
    NEW.raw_user_meta_data ->> 'full_name',
    NEW.raw_user_meta_data ->> 'name'
  )), '');
  v_avatar_url := NULLIF(BTRIM(COALESCE(
    NEW.raw_user_meta_data ->> 'avatar_url',
    NEW.raw_user_meta_data ->> 'picture'
  )), '');

  INSERT INTO public.profiles (
    id,
    email,
    display_name,
    avatar_url
  )
  VALUES (
    NEW.id,
    v_email,
    v_display_name,
    v_avatar_url
  )
  ON CONFLICT (id) DO NOTHING;

  INSERT INTO public.streaks (user_id)
  VALUES (NEW.id)
  ON CONFLICT (user_id) DO NOTHING;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = '';

REVOKE ALL ON FUNCTION public.handle_new_user()
  FROM PUBLIC, anon, authenticated;

DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW
  EXECUTE FUNCTION public.handle_new_user();

-- ============================================
-- 2. BACKFILL EXISTING ORPHANED AUTH USERS
-- ============================================

INSERT INTO public.profiles (
  id,
  email,
  display_name,
  avatar_url
)
SELECT
  u.id,
  COALESCE(
    NULLIF(BTRIM(u.email), ''),
    NULLIF(BTRIM(u.raw_user_meta_data ->> 'email'), ''),
    u.id::TEXT || '@profile.invalid'
  ),
  NULLIF(BTRIM(COALESCE(
    u.raw_user_meta_data ->> 'full_name',
    u.raw_user_meta_data ->> 'name'
  )), ''),
  NULLIF(BTRIM(COALESCE(
    u.raw_user_meta_data ->> 'avatar_url',
    u.raw_user_meta_data ->> 'picture'
  )), '')
FROM auth.users AS u
WHERE NOT EXISTS (
  SELECT 1
  FROM public.profiles AS p
  WHERE p.id = u.id
)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.streaks (user_id)
SELECT p.id
FROM public.profiles AS p
WHERE NOT EXISTS (
  SELECT 1
  FROM public.streaks AS s
  WHERE s.user_id = p.id
)
ON CONFLICT (user_id) DO NOTHING;

-- ============================================
-- 3. CALLER-ONLY ORPHAN RECOVERY RPC
-- ============================================

CREATE OR REPLACE FUNCTION public.ensure_current_user_profile()
RETURNS public.profiles AS $$
DECLARE
  v_user_id UUID := auth.uid();
  v_auth_user auth.users%ROWTYPE;
  v_profile public.profiles%ROWTYPE;
  v_email TEXT;
  v_display_name TEXT;
  v_avatar_url TEXT;
BEGIN
  IF v_user_id IS NULL THEN
    RAISE EXCEPTION USING
      ERRCODE = '42501',
      MESSAGE = 'Authentication required';
  END IF;

  SELECT *
  INTO v_auth_user
  FROM auth.users
  WHERE id = v_user_id;

  IF NOT FOUND THEN
    RAISE EXCEPTION USING
      ERRCODE = 'P0002',
      MESSAGE = 'Authenticated user not found';
  END IF;

  v_email := COALESCE(
    NULLIF(BTRIM(v_auth_user.email), ''),
    NULLIF(BTRIM(v_auth_user.raw_user_meta_data ->> 'email'), ''),
    v_auth_user.id::TEXT || '@profile.invalid'
  );
  v_display_name := NULLIF(BTRIM(COALESCE(
    v_auth_user.raw_user_meta_data ->> 'full_name',
    v_auth_user.raw_user_meta_data ->> 'name'
  )), '');
  v_avatar_url := NULLIF(BTRIM(COALESCE(
    v_auth_user.raw_user_meta_data ->> 'avatar_url',
    v_auth_user.raw_user_meta_data ->> 'picture'
  )), '');

  INSERT INTO public.profiles (
    id,
    email,
    display_name,
    avatar_url
  )
  VALUES (
    v_auth_user.id,
    v_email,
    v_display_name,
    v_avatar_url
  )
  ON CONFLICT (id) DO NOTHING;

  INSERT INTO public.streaks (user_id)
  VALUES (v_auth_user.id)
  ON CONFLICT (user_id) DO NOTHING;

  SELECT *
  INTO v_profile
  FROM public.profiles
  WHERE id = v_user_id;

  IF NOT FOUND THEN
    RAISE EXCEPTION USING
      ERRCODE = 'P0002',
      MESSAGE = 'Profile could not be provisioned';
  END IF;

  RETURN v_profile;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = '';

REVOKE ALL ON FUNCTION public.ensure_current_user_profile()
  FROM PUBLIC, anon, authenticated;
GRANT EXECUTE ON FUNCTION public.ensure_current_user_profile()
  TO authenticated;
