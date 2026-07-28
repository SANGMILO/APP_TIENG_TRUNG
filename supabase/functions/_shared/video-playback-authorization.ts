export interface PlaybackVideoRecord {
  id: string;
  status: string;
  processing_status: string;
  is_premium: boolean;
  video_path: string | null;
  playback_type: string | null;
}

export type VideoPlaybackAuthorization =
  | {
      authorized: true;
      objectPath: string;
      playbackType: 'progressive' | 'hls';
    }
  | {
      authorized: false;
      status: number;
      error: string;
      errorCode: string;
    };

export function authorizePrivateVideoPlayback(
  video: PlaybackVideoRecord | null,
): VideoPlaybackAuthorization {
  if (!video || video.status !== 'published') {
    return {
      authorized: false,
      status: 404,
      error: 'Video unavailable',
      errorCode: 'VIDEO_UNAVAILABLE',
    };
  }

  if (video.processing_status !== 'ready') {
    return {
      authorized: false,
      status: 409,
      error: 'Video is not ready for playback',
      errorCode: 'VIDEO_NOT_READY',
    };
  }

  // No subscription/entitlement table exists in the current product model.
  // Blocking is safer than trusting a client premium flag.
  if (video.is_premium) {
    return {
      authorized: false,
      status: 403,
      error: 'Premium video entitlement is unavailable',
      errorCode: 'PREMIUM_ENTITLEMENT_UNAVAILABLE',
    };
  }

  const rawPath = video.video_path?.trim().replace(/^video-content\//, '');
  if (
    !rawPath
    || rawPath.startsWith('/')
    || rawPath.includes('\\')
    || rawPath.split('/').some((segment) => !segment || segment === '.' || segment === '..')
  ) {
    return {
      authorized: false,
      status: 400,
      error: 'Video path is invalid',
      errorCode: 'INVALID_VIDEO_PATH',
    };
  }

  return {
    authorized: true,
    objectPath: rawPath,
    playbackType: video.playback_type === 'hls' ? 'hls' : 'progressive',
  };
}
