import { serve } from 'https://deno.land/std@0.168.0/http/server.ts';
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2.49.4';
import { authorizePrivateVideoPlayback } from '../_shared/video-playback-authorization.ts';

const SIGNED_URL_TTL_SECONDS = 60 * 60;
const UUID_PATTERN =
  /^[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/i;

serve(async (request) => {
  if (request.method === 'OPTIONS') {
    return jsonResponse(null, 204);
  }

  if (request.method !== 'POST') {
    return jsonResponse({
      error: 'Method not allowed',
      errorCode: 'METHOD_NOT_ALLOWED',
    }, 405);
  }

  try {
    const authHeader = request.headers.get('Authorization');
    if (!authHeader?.startsWith('Bearer ')) {
      return jsonResponse({
        error: 'Unauthorized',
        errorCode: 'UNAUTHORIZED',
      }, 401);
    }

    const supabaseUrl = Deno.env.get('SUPABASE_URL');
    const serviceRoleKey = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY');
    if (!supabaseUrl || !serviceRoleKey) {
      return jsonResponse({
        error: 'Playback service is not configured',
        errorCode: 'NOT_CONFIGURED',
      }, 503);
    }

    const supabase = createClient(supabaseUrl, serviceRoleKey);
    const token = authHeader.slice('Bearer '.length);
    const { data: { user }, error: authError } = await supabase.auth.getUser(token);
    if (authError || !user) {
      return jsonResponse({
        error: 'Unauthorized',
        errorCode: 'UNAUTHORIZED',
      }, 401);
    }

    let body: { videoId?: unknown };
    try {
      body = await request.json();
    } catch {
      return jsonResponse({
        error: 'Invalid request body',
        errorCode: 'INVALID_REQUEST',
      }, 400);
    }

    if (typeof body.videoId !== 'string' || !UUID_PATTERN.test(body.videoId)) {
      return jsonResponse({
        error: 'A valid video identifier is required',
        errorCode: 'INVALID_VIDEO_ID',
      }, 400);
    }

    const { data: video, error: videoError } = await supabase
      .from('videos')
      .select('id, status, processing_status, is_premium, video_path, playback_type')
      .eq('id', body.videoId)
      .maybeSingle();

    if (videoError) {
      return jsonResponse({
        error: 'Video unavailable',
        errorCode: 'VIDEO_UNAVAILABLE',
      }, 404);
    }

    const authorization = authorizePrivateVideoPlayback(video);
    if (!authorization.authorized) {
      return jsonResponse({
        error: authorization.error,
        errorCode: authorization.errorCode,
      }, authorization.status);
    }

    const { data: signed, error: signedError } = await supabase.storage
      .from('video-content')
      .createSignedUrl(authorization.objectPath, SIGNED_URL_TTL_SECONDS);

    if (signedError || !signed?.signedUrl) {
      return jsonResponse({
        error: 'Video media is unavailable',
        errorCode: 'MEDIA_UNAVAILABLE',
      }, 404);
    }

    return jsonResponse({
      url: signed.signedUrl,
      expiresAt: new Date(
        Date.now() + SIGNED_URL_TTL_SECONDS * 1000,
      ).toISOString(),
      playbackType: authorization.playbackType,
    });
  } catch {
    return jsonResponse({
      error: 'Playback service failed',
      errorCode: 'SERVER_ERROR',
    }, 500);
  }
});

function jsonResponse(body: unknown, status = 200) {
  return new Response(body === null ? null : JSON.stringify(body), {
    status,
    headers: {
      'Content-Type': 'application/json',
      'Access-Control-Allow-Origin': '*',
      'Access-Control-Allow-Methods': 'POST, OPTIONS',
      'Access-Control-Allow-Headers':
        'authorization, content-type, x-client-info, apikey',
    },
  });
}
