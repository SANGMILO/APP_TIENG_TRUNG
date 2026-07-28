-- Auditable, caller-owned account deletion requests.
--
-- This intentionally queues a request instead of deleting auth users. Actual
-- service-role deletion requires owner-approved retention and operations rules.

CREATE TABLE IF NOT EXISTS public.account_deletion_requests (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  status TEXT NOT NULL DEFAULT 'pending' CHECK (
    status IN ('pending', 'processing', 'completed', 'cancelled', 'rejected')
  ),
  requested_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  processed_at TIMESTAMPTZ,
  processor_note TEXT
);

CREATE UNIQUE INDEX IF NOT EXISTS idx_account_deletion_one_active
  ON public.account_deletion_requests(user_id)
  WHERE status IN ('pending', 'processing');

CREATE INDEX IF NOT EXISTS idx_account_deletion_status_requested
  ON public.account_deletion_requests(status, requested_at);

ALTER TABLE public.account_deletion_requests ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Own account deletion requests"
  ON public.account_deletion_requests;
CREATE POLICY "Own account deletion requests"
  ON public.account_deletion_requests
  FOR SELECT
  USING (user_id = auth.uid());

REVOKE ALL ON TABLE public.account_deletion_requests
  FROM PUBLIC, anon, authenticated;
GRANT SELECT ON TABLE public.account_deletion_requests TO authenticated;
GRANT ALL ON TABLE public.account_deletion_requests TO service_role;

CREATE OR REPLACE FUNCTION public.request_account_deletion(
  p_confirmation TEXT
)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = ''
AS $$
DECLARE
  v_user_id UUID := auth.uid();
  v_request public.account_deletion_requests%ROWTYPE;
BEGIN
  IF v_user_id IS NULL THEN
    RAISE EXCEPTION USING
      ERRCODE = '42501',
      MESSAGE = 'Authentication required';
  END IF;

  IF COALESCE(p_confirmation, '') <> 'XÓA TÀI KHOẢN' THEN
    RAISE EXCEPTION USING
      ERRCODE = '22023',
      MESSAGE = 'Account deletion confirmation is invalid';
  END IF;

  PERFORM pg_catalog.pg_advisory_xact_lock(
    pg_catalog.hashtextextended(
      v_user_id::TEXT || ':account_deletion_request',
      0
    )
  );

  SELECT request.*
  INTO v_request
  FROM public.account_deletion_requests AS request
  WHERE request.user_id = v_user_id
    AND request.status IN ('pending', 'processing')
  ORDER BY request.requested_at DESC
  LIMIT 1;

  IF FOUND THEN
    RETURN jsonb_build_object(
      'success', TRUE,
      'request_id', v_request.id,
      'status', v_request.status,
      'requested_at', v_request.requested_at,
      'already_requested', TRUE
    );
  END IF;

  INSERT INTO public.account_deletion_requests (
    user_id,
    status
  )
  VALUES (
    v_user_id,
    'pending'
  )
  RETURNING *
  INTO v_request;

  RETURN jsonb_build_object(
    'success', TRUE,
    'request_id', v_request.id,
    'status', v_request.status,
    'requested_at', v_request.requested_at,
    'already_requested', FALSE
  );
END;
$$;

REVOKE ALL ON FUNCTION public.request_account_deletion(TEXT)
  FROM PUBLIC, anon, authenticated;
GRANT EXECUTE ON FUNCTION public.request_account_deletion(TEXT)
  TO authenticated;

COMMENT ON TABLE public.account_deletion_requests
IS 'Auditable owner-requested account deletion queue. Processing requires a separate privileged operational workflow.';

COMMENT ON FUNCTION public.request_account_deletion(TEXT)
IS 'Creates or returns the one active deletion request for auth.uid() after explicit confirmation.';
