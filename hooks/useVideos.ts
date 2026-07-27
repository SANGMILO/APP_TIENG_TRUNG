import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { supabase } from '@/lib/supabase';
import { useAuthStore } from '@/stores/auth-store';
import { fetchVideos, fetchVideoById, fetchSubtitles, fetchVideoQuestions, fetchVideoProgress } from '@/services/video-service';

export function useVideos(level?: string, category?: string) {
  return useQuery({
    queryKey: ['videos', level, category],
    queryFn: () => fetchVideos(level, category),
  });
}

export function useVideo(videoId: string) {
  return useQuery({
    queryKey: ['video', videoId],
    queryFn: () => fetchVideoById(videoId),
    enabled: !!videoId,
  });
}

export function useVideoSubtitles(videoId: string) {
  return useQuery({
    queryKey: ['video-subtitles', videoId],
    queryFn: () => fetchSubtitles(videoId),
    enabled: !!videoId,
  });
}

export function useVideoQuestions(videoId: string) {
  return useQuery({
    queryKey: ['video-questions', videoId],
    queryFn: () => fetchVideoQuestions(videoId),
    enabled: !!videoId,
  });
}

export function useVideoProgress(videoId: string) {
  const { profile } = useAuthStore();
  return useQuery({
    queryKey: ['video-progress', videoId],
    queryFn: () => fetchVideoProgress(profile!.id, videoId),
    enabled: !!videoId && !!profile,
  });
}

export function useSavedVideos() {
  const { profile } = useAuthStore();
  return useQuery({
    queryKey: ['saved-videos'],
    queryFn: async () => {
      if (!profile) return [];
      const { data, error } = await supabase
        .from('saved_videos')
        .select('video_id, created_at, videos:video_id (id, title, level, category, duration_seconds)')
        .eq('user_id', profile.id)
        .order('created_at', { ascending: false });
      if (error) throw error;
      return data ?? [];
    },
    enabled: !!profile,
  });
}

export function useSaveVideo() {
  const { profile } = useAuthStore();
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: async (videoId: string) => {
      if (!profile) throw new Error('Not authenticated');
      const { error } = await supabase
        .from('saved_videos')
        .upsert({ user_id: profile.id, video_id: videoId }, { onConflict: 'user_id,video_id' });
      if (error) throw error;
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['saved-videos'] });
    },
  });
}

export function useUnsaveVideo() {
  const { profile } = useAuthStore();
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: async (videoId: string) => {
      if (!profile) throw new Error('Not authenticated');
      const { error } = await supabase
        .from('saved_videos')
        .delete()
        .eq('user_id', profile.id)
        .eq('video_id', videoId);
      if (error) throw error;
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['saved-videos'] });
    },
  });
}
