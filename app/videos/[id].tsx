import React, {
  useCallback,
  useEffect,
  useMemo,
  useRef,
  useState,
} from 'react';
import {
  ActivityIndicator,
  Modal,
  SafeAreaView,
  ScrollView,
  StyleSheet,
  Text,
  TouchableOpacity,
  View,
} from 'react-native';
import { Ionicons } from '@expo/vector-icons';
import * as Crypto from 'expo-crypto';
import { useEventListener } from 'expo';
import {
  VideoSource,
  VideoView,
  useVideoPlayer,
} from 'expo-video';
import { router, useLocalSearchParams } from 'expo-router';
import { useQuery, useQueryClient } from '@tanstack/react-query';
import { useThemeStore } from '@/stores/theme-store';
import { useAuthStore } from '@/stores/auth-store';
import { Button } from '@/components/ui';
import { InteractiveSubtitle, VideoQuestionOverlay } from '@/components/video';
import {
  VideoAnswerResult,
  VideoProgress,
  VideoQuestion,
  completeVideo,
  fetchAnsweredVideoQuestions,
  fetchSubtitles,
  fetchVideoById,
  fetchVideoProgress,
  fetchVideoQuestions,
  findCurrentCue,
  findPendingQuestion,
  resolveVideoSource,
  saveVideoAnswer,
  saveVideoProgress,
} from '@/services/video-service';
import {
  useSavedVideos,
  useSaveVideo,
  useUnsaveVideo,
} from '@/hooks/useVideos';
import { supabase } from '@/lib/supabase';
import { BorderRadius, FontSize, Spacing } from '@/constants/theme';

const PROGRESS_FLUSH_INTERVAL_MS = 10_000;
const MAX_WALL_CLOCK_DELTA_MS = 2_000;

export default function VideoDetailScreen() {
  const { id } = useLocalSearchParams<{ id: string }>();
  const { colors } = useThemeStore();
  const { profile } = useAuthStore();
  const queryClient = useQueryClient();

  const {
    data: video,
    isLoading: loadingVideo,
    isError: videoLoadFailed,
    refetch: refetchVideo,
  } = useQuery({
    queryKey: ['video', id],
    queryFn: () => fetchVideoById(id!),
    enabled: Boolean(id),
  });

  const { data: subtitles } = useQuery({
    queryKey: ['video-subtitles', id],
    queryFn: () => fetchSubtitles(id!),
    enabled: Boolean(id),
  });

  const { data: questions } = useQuery({
    queryKey: ['video-questions', id],
    queryFn: () => fetchVideoQuestions(id!),
    enabled: Boolean(id),
  });

  const {
    data: progress,
    isLoading: loadingProgress,
  } = useQuery({
    queryKey: ['video-progress', id],
    queryFn: () => fetchVideoProgress(profile!.id, id!),
    enabled: Boolean(id && profile),
  });

  const { data: questionState } = useQuery({
    queryKey: ['video-question-state', id],
    queryFn: () => fetchAnsweredVideoQuestions(profile!.id, id!),
    enabled: Boolean(id && profile),
  });

  const { data: vocabDict } = useQuery({
    queryKey: ['vocab-dict'],
    queryFn: async () => {
      const { data, error } = await supabase
        .from('vocabulary')
        .select('chinese')
        .eq('status', 'published');
      if (error) throw error;
      return new Set((data ?? []).map((item) => item.chinese));
    },
  });

  const { data: savedVideos } = useSavedVideos();
  const saveVideoMutation = useSaveVideo();
  const unsaveVideoMutation = useUnsaveVideo();
  const isSaved = (savedVideos ?? []).some((item: any) => item.video_id === id);

  const player = useVideoPlayer(null, (instance) => {
    instance.loop = false;
    instance.timeUpdateEventInterval = 1;
  });

  const [sourceLoading, setSourceLoading] = useState(false);
  const [sourceReady, setSourceReady] = useState(false);
  const [sourceError, setSourceError] = useState('');
  const [currentTimeMs, setCurrentTimeMs] = useState(0);
  const [durationMs, setDurationMs] = useState(0);
  const [isPlaying, setIsPlaying] = useState(false);
  const [showChinese, setShowChinese] = useState(true);
  const [showPinyin, setShowPinyin] = useState(true);
  const [showVietnamese, setShowVietnamese] = useState(true);
  const [activeQuestion, setActiveQuestion] = useState<VideoQuestion | null>(null);
  const [answeredQuestions, setAnsweredQuestions] = useState<Set<string>>(new Set());
  const [questionCounts, setQuestionCounts] = useState({
    answered: 0,
    correct: 0,
  });
  const [wordModal, setWordModal] = useState<string | null>(null);
  const [progressError, setProgressError] = useState('');
  const [completionMessage, setCompletionMessage] = useState('');
  const [completionSaving, setCompletionSaving] = useState(false);
  const [saveActionError, setSaveActionError] = useState('');

  const latestPositionRef = useRef(0);
  const durationRef = useRef(0);
  const pendingWatchMsRef = useRef(0);
  const lastWallClockRef = useRef<number | null>(null);
  const flushPromiseRef = useRef<Promise<VideoProgress> | null>(null);
  const restoredProgressRef = useRef(false);
  const completionInFlightRef = useRef(false);
  const resumeAfterOverlayRef = useRef(false);

  const flushProgress = useCallback(async () => {
    if (!profile || !id || !sourceReady) return null;

    if (flushPromiseRef.current) {
      try {
        await flushPromiseRef.current;
      } catch {
        // The failed delta was restored by the owning call below.
      }
    }

    const positionMs = latestPositionRef.current;
    const playedDeltaMs = Math.min(30000, pendingWatchMsRef.current);
    if (positionMs <= 0 && playedDeltaMs <= 0) return null;

    pendingWatchMsRef.current = Math.max(
      0,
      pendingWatchMsRef.current - playedDeltaMs,
    );
    const eventId = Crypto.randomUUID();
    const request = saveVideoProgress(
      eventId,
      id,
      positionMs,
      playedDeltaMs,
      durationRef.current,
    );
    flushPromiseRef.current = request;

    try {
      const saved = await request;
      setProgressError('');
      queryClient.setQueryData(['video-progress', id], saved);
      return saved;
    } catch (reason: unknown) {
      pendingWatchMsRef.current += playedDeltaMs;
      setProgressError(getErrorMessage(
        reason,
        'Không thể lưu tiến độ xem. Vui lòng thử lại.',
      ));
      throw reason;
    } finally {
      if (flushPromiseRef.current === request) {
        flushPromiseRef.current = null;
      }
    }
  }, [id, profile, queryClient, sourceReady]);

  const handleVideoComplete = useCallback(async () => {
    if (!id || completionInFlightRef.current) return;
    completionInFlightRef.current = true;
    setCompletionSaving(true);
    setCompletionMessage('');

    try {
      await flushProgress();
      const completed = await completeVideo(id);
      setCompletionMessage(
        completed.already_completed
          ? 'Video này đã được hoàn thành trước đó.'
          : `Đã hoàn thành video${completed.xp_earned > 0 ? ` · +${completed.xp_earned} XP` : ''}`,
      );
      await Promise.all([
        queryClient.invalidateQueries({ queryKey: ['video-progress', id] }),
        queryClient.invalidateQueries({ queryKey: ['continue-watching'] }),
      ]);
    } catch (reason: unknown) {
      setProgressError(getErrorMessage(
        reason,
        'Chưa thể xác nhận hoàn thành video.',
      ));
    } finally {
      completionInFlightRef.current = false;
      setCompletionSaving(false);
    }
  }, [flushProgress, id, queryClient]);

  useEventListener(player, 'sourceLoad', ({ duration }) => {
    const loadedDurationMs = Math.max(0, Math.round(duration * 1000));
    durationRef.current = loadedDurationMs;
    setDurationMs(loadedDurationMs);
    setSourceReady(loadedDurationMs > 0);
    setSourceLoading(false);
  });

  useEventListener(player, 'statusChange', ({ status, error }) => {
    if (status === 'error') {
      setSourceLoading(false);
      setSourceReady(false);
      setSourceError(error?.message || 'Không thể phát nguồn video này.');
    }
  });

  useEventListener(player, 'playingChange', ({ isPlaying: playing }) => {
    setIsPlaying(playing);
    if (playing) {
      lastWallClockRef.current = Date.now();
    } else {
      lastWallClockRef.current = null;
      void flushProgress().catch(() => undefined);
    }
  });

  useEventListener(player, 'timeUpdate', ({ currentTime }) => {
    const nextPositionMs = Math.max(0, Math.round(currentTime * 1000));
    latestPositionRef.current = nextPositionMs;
    setCurrentTimeMs(nextPositionMs);

    if (player.playing) {
      const now = Date.now();
      if (lastWallClockRef.current !== null) {
        pendingWatchMsRef.current += Math.min(
          MAX_WALL_CLOCK_DELTA_MS,
          Math.max(0, now - lastWallClockRef.current),
        );
      }
      lastWallClockRef.current = now;
    }
  });

  useEventListener(player, 'playToEnd', () => {
    latestPositionRef.current = durationRef.current;
    setCurrentTimeMs(durationRef.current);
    void handleVideoComplete();
  });

  useEffect(() => {
    if (!video) return;
    let active = true;
    restoredProgressRef.current = false;
    setSourceLoading(true);
    setSourceReady(false);
    setSourceError('');
    setCompletionMessage('');

    resolveVideoSource(video)
      .then(async (source) => {
        if (!active) return;
        await player.replaceAsync(source as VideoSource);
      })
      .catch((reason: unknown) => {
        if (!active) return;
        setSourceLoading(false);
        setSourceReady(false);
        setSourceError(getErrorMessage(
          reason,
          'Video này chưa có nguồn media có thể phát.',
        ));
      });

    return () => {
      active = false;
      player.pause();
    };
  }, [player, video]);

  useEffect(() => {
    if (
      !sourceReady
      || loadingProgress
      || restoredProgressRef.current
    ) {
      return;
    }

    const resumeMs = Math.max(
      0,
      Math.min(progress?.last_position_ms ?? 0, durationRef.current),
    );
    player.currentTime = resumeMs / 1000;
    latestPositionRef.current = resumeMs;
    setCurrentTimeMs(resumeMs);
    restoredProgressRef.current = true;
  }, [loadingProgress, player, progress?.last_position_ms, sourceReady]);

  useEffect(() => {
    if (!questionState) return;
    setAnsweredQuestions(new Set(questionState.answeredIds));
    setQuestionCounts({
      answered: questionState.questionsAnswered,
      correct: questionState.questionsCorrect,
    });
  }, [questionState]);

  useEffect(() => {
    if (!questions || !isPlaying || activeQuestion) return;
    const pending = findPendingQuestion(
      questions,
      currentTimeMs,
      answeredQuestions,
    );
    if (pending) {
      resumeAfterOverlayRef.current = true;
      player.pause();
      setActiveQuestion(pending);
    }
  }, [
    activeQuestion,
    answeredQuestions,
    currentTimeMs,
    isPlaying,
    player,
    questions,
  ]);

  useEffect(() => {
    if (!sourceReady) return;
    const timer = setInterval(() => {
      void flushProgress().catch(() => undefined);
    }, PROGRESS_FLUSH_INTERVAL_MS);
    return () => clearInterval(timer);
  }, [flushProgress, sourceReady]);

  useEffect(() => () => {
    void flushProgress().catch(() => undefined);
  }, [flushProgress]);

  const currentCue = useMemo(
    () => findCurrentCue(subtitles ?? [], currentTimeMs),
    [currentTimeMs, subtitles],
  );

  const handleQuestionSubmit = async (
    answer: string,
    attemptId: string,
  ): Promise<VideoAnswerResult> => {
    if (!activeQuestion) {
      throw new Error('Câu hỏi không còn hoạt động.');
    }
    const result = await saveVideoAnswer(
      attemptId,
      activeQuestion.id,
      answer,
    );
    setAnsweredQuestions((current) => new Set([
      ...current,
      activeQuestion.id,
    ]));
    setQuestionCounts({
      answered: result.questions_answered,
      correct: result.questions_correct,
    });
    queryClient.setQueryData(['video-question-state', id], {
      answeredIds: new Set([...answeredQuestions, activeQuestion.id]),
      questionsAnswered: result.questions_answered,
      questionsCorrect: result.questions_correct,
    });
    return result;
  };

  const handleQuestionContinue = () => {
    setActiveQuestion(null);
    if (resumeAfterOverlayRef.current) player.play();
    resumeAfterOverlayRef.current = false;
  };

  const handleWordPress = (word: string) => {
    resumeAfterOverlayRef.current = player.playing;
    player.pause();
    setWordModal(word);
  };

  const handleSaveWord = async (word: string) => {
    if (!profile) return;
    const { data, error } = await supabase
      .from('vocabulary')
      .select('id')
      .eq('chinese', word)
      .maybeSingle();
    if (error) {
      setProgressError(error.message);
      return;
    }
    if (data) {
      const { error: saveError } = await supabase
        .from('saved_words')
        .upsert(
          { user_id: profile.id, vocabulary_id: data.id },
          { onConflict: 'user_id,vocabulary_id' },
        );
      if (saveError) {
        setProgressError(saveError.message);
        return;
      }
    }
    setWordModal(null);
    if (resumeAfterOverlayRef.current) player.play();
    resumeAfterOverlayRef.current = false;
  };

  const handleToggleSaved = async () => {
    if (!id) return;
    setSaveActionError('');
    try {
      if (isSaved) {
        await unsaveVideoMutation.mutateAsync(id);
      } else {
        await saveVideoMutation.mutateAsync(id);
      }
    } catch (reason: unknown) {
      setSaveActionError(getErrorMessage(
        reason,
        'Không thể cập nhật video đã lưu.',
      ));
    }
  };

  const seekTo = (milliseconds: number) => {
    if (!sourceReady) return;
    const clamped = Math.max(
      0,
      Math.min(milliseconds, durationRef.current),
    );
    player.currentTime = clamped / 1000;
    latestPositionRef.current = clamped;
    setCurrentTimeMs(clamped);
  };

  if (loadingVideo) {
    return (
      <SafeAreaView style={[styles.container, { backgroundColor: colors.background }]}>
        <View style={styles.center}>
          <ActivityIndicator size="large" color={colors.primary} />
        </View>
      </SafeAreaView>
    );
  }

  if (videoLoadFailed || !video) {
    return (
      <SafeAreaView style={[styles.container, { backgroundColor: colors.background }]}>
        <View style={styles.center}>
          <Ionicons name="cloud-offline-outline" size={42} color={colors.textTertiary} />
          <Text style={[styles.errorText, { color: colors.text }]}>
            Không thể tải video
          </Text>
          <Button
            title="Thử lại"
            variant="primary"
            onPress={() => { void refetchVideo(); }}
          />
          <Button title="Quay lại" variant="outline" onPress={() => router.back()} />
        </View>
      </SafeAreaView>
    );
  }

  const displayDurationMs = durationMs || video.duration_seconds * 1000;
  const progressPercent = displayDurationMs > 0
    ? Math.max(0, Math.min(100, (currentTimeMs / displayDurationMs) * 100))
    : 0;
  const saveActionPending =
    saveVideoMutation.isPending || unsaveVideoMutation.isPending;

  return (
    <SafeAreaView style={[styles.container, { backgroundColor: colors.background }]}>
      <View style={styles.header}>
        <TouchableOpacity
          onPress={() => router.back()}
          style={[styles.headerButton, { backgroundColor: colors.surfaceElevated }]}
        >
          <Ionicons name="chevron-back" size={20} color={colors.text} />
        </TouchableOpacity>
        <Text style={[styles.videoTitle, { color: colors.text }]} numberOfLines={1}>
          {video.title}
        </Text>
        <TouchableOpacity
          onPress={() => { void handleToggleSaved(); }}
          disabled={saveActionPending}
          style={[styles.headerButton, { backgroundColor: colors.surfaceElevated }]}
          accessibilityLabel={isSaved ? 'Bỏ lưu video' : 'Lưu video'}
        >
          {saveActionPending ? (
            <ActivityIndicator size="small" color={colors.primary} />
          ) : (
            <Ionicons
              name={isSaved ? 'bookmark' : 'bookmark-outline'}
              size={20}
              color={isSaved ? colors.primary : colors.text}
            />
          )}
        </TouchableOpacity>
      </View>

      <View style={[styles.playerArea, { backgroundColor: '#1C1917' }]}>
        {sourceReady ? (
          <VideoView
            player={player}
            style={styles.videoView}
            nativeControls={false}
            contentFit="contain"
            playsInline
            fullscreenOptions={{ enable: true }}
          />
        ) : (
          <View style={styles.playerState}>
            {sourceLoading ? (
              <>
                <ActivityIndicator size="large" color="#FFFFFF" />
                <Text style={styles.playerStateText}>Đang chuẩn bị video...</Text>
              </>
            ) : (
              <>
                <Ionicons name="videocam-off-outline" size={42} color="rgba(255,255,255,0.65)" />
                <Text style={styles.playerStateText}>
                  {sourceError || 'Video này chưa có nguồn media có thể phát.'}
                </Text>
              </>
            )}
          </View>
        )}

        {sourceReady && !activeQuestion ? (
          <View style={styles.controls}>
            <TouchableOpacity
              onPress={() => seekTo(currentTimeMs - 5000)}
              style={styles.controlButton}
            >
              <Ionicons name="play-back" size={22} color="#fff" />
            </TouchableOpacity>
            <TouchableOpacity
              onPress={() => {
                if (player.playing) player.pause();
                else player.play();
              }}
              style={styles.controlButtonMain}
            >
              <Ionicons name={isPlaying ? 'pause' : 'play'} size={28} color="#fff" />
            </TouchableOpacity>
            <TouchableOpacity
              onPress={() => seekTo(currentTimeMs + 5000)}
              style={styles.controlButton}
            >
              <Ionicons name="play-forward" size={22} color="#fff" />
            </TouchableOpacity>
          </View>
        ) : null}

        <View style={styles.progressTrack}>
          <View
            style={[
              styles.progressFill,
              { width: `${progressPercent}%`, backgroundColor: colors.primary },
            ]}
          />
        </View>
        <Text style={styles.timeText}>
          {formatMs(currentTimeMs)} / {formatMs(displayDurationMs)}
        </Text>

        {activeQuestion ? (
          <VideoQuestionOverlay
            key={activeQuestion.id}
            question={activeQuestion}
            onSubmit={handleQuestionSubmit}
            onContinue={handleQuestionContinue}
          />
        ) : null}
      </View>

      {progressError || saveActionError || completionMessage ? (
        <View style={styles.statusRow}>
          {completionSaving ? (
            <ActivityIndicator size="small" color={colors.primary} />
          ) : null}
          <Text
            style={[
              styles.statusText,
              {
                color: progressError || saveActionError
                  ? colors.error
                  : colors.success,
              },
            ]}
          >
            {progressError || saveActionError || completionMessage}
          </Text>
          {progressError ? (
            <TouchableOpacity
              onPress={() => { void flushProgress().catch(() => undefined); }}
            >
              <Text style={[styles.retryText, { color: colors.primary }]}>Thử lại</Text>
            </TouchableOpacity>
          ) : null}
        </View>
      ) : null}

      <View style={[styles.subtitleArea, { backgroundColor: colors.surface }]}>
        <InteractiveSubtitle
          cue={currentCue}
          showChinese={showChinese}
          showPinyin={showPinyin}
          showVietnamese={showVietnamese}
          vocabulary={vocabDict ?? new Set()}
          onWordPress={handleWordPress}
        />

        <View style={styles.toggleRow}>
          <ToggleChip label="中文" active={showChinese} onPress={() => setShowChinese(!showChinese)} colors={colors} />
          <ToggleChip label="Pinyin" active={showPinyin} onPress={() => setShowPinyin(!showPinyin)} colors={colors} />
          <ToggleChip label="Tiếng Việt" active={showVietnamese} onPress={() => setShowVietnamese(!showVietnamese)} colors={colors} />
        </View>
        {questionCounts.answered > 0 ? (
          <Text style={[styles.questionSummary, { color: colors.textSecondary }]}>
            Câu hỏi: {questionCounts.correct}/{questionCounts.answered} đúng
          </Text>
        ) : null}
      </View>

      <ScrollView style={styles.transcript} contentContainerStyle={styles.transcriptContent}>
        <Text style={[styles.sectionLabel, { color: colors.text }]}>Transcript</Text>
        {(subtitles ?? []).map((cue) => (
          <TouchableOpacity
            key={cue.id}
            style={[
              styles.transcriptCue,
              cue.id === currentCue?.id && { backgroundColor: `${colors.primary}10` },
            ]}
            onPress={() => {
              seekTo(cue.start_ms);
              player.play();
            }}
          >
            <Text style={[styles.cueTime, { color: colors.textTertiary }]}>
              {formatMs(cue.start_ms)}
            </Text>
            <View style={styles.cueBody}>
              {cue.chinese_text ? (
                <Text style={[styles.cueChinese, { color: colors.text }]}>
                  {cue.chinese_text}
                </Text>
              ) : null}
              {showPinyin && cue.pinyin ? (
                <Text style={[styles.cuePinyin, { color: colors.primary }]}>
                  {cue.pinyin}
                </Text>
              ) : null}
              {showVietnamese && cue.vietnamese_text ? (
                <Text style={[styles.cueVietnamese, { color: colors.textSecondary }]}>
                  {cue.vietnamese_text}
                </Text>
              ) : null}
            </View>
          </TouchableOpacity>
        ))}
      </ScrollView>

      <Modal visible={Boolean(wordModal)} transparent animationType="slide">
        <View style={[styles.modalOverlay, { backgroundColor: colors.overlay }]}>
          <View style={[styles.modalContent, { backgroundColor: colors.surface }]}>
            <Text style={[styles.modalWord, { color: colors.text }]}>{wordModal}</Text>
            <View style={styles.modalActions}>
              <Button
                title="Lưu từ"
                variant="primary"
                size="sm"
                icon={<Ionicons name="bookmark" size={14} color="#fff" />}
                onPress={() => {
                  if (wordModal) void handleSaveWord(wordModal);
                }}
              />
              <Button
                title="Đóng"
                variant="ghost"
                size="sm"
                onPress={() => {
                  setWordModal(null);
                  if (resumeAfterOverlayRef.current) player.play();
                  resumeAfterOverlayRef.current = false;
                }}
              />
            </View>
          </View>
        </View>
      </Modal>
    </SafeAreaView>
  );
}

function ToggleChip({
  label,
  active,
  onPress,
  colors,
}: {
  label: string;
  active: boolean;
  onPress: () => void;
  colors: any;
}) {
  return (
    <TouchableOpacity
      style={[
        styles.toggle,
        {
          backgroundColor: active
            ? `${colors.primary}20`
            : colors.surfaceElevated,
          borderColor: active ? colors.primary : colors.border,
        },
      ]}
      onPress={onPress}
    >
      <Text style={[styles.toggleText, { color: active ? colors.primary : colors.textSecondary }]}>
        {label}
      </Text>
    </TouchableOpacity>
  );
}

function formatMs(milliseconds: number): string {
  const totalSeconds = Math.floor(Math.max(0, milliseconds) / 1000);
  const minutes = Math.floor(totalSeconds / 60);
  const seconds = totalSeconds % 60;
  return `${minutes}:${seconds.toString().padStart(2, '0')}`;
}

function getErrorMessage(reason: unknown, fallback: string) {
  if (
    typeof reason === 'object'
    && reason !== null
    && 'message' in reason
    && typeof reason.message === 'string'
    && reason.message.trim()
  ) {
    return reason.message;
  }
  return fallback;
}

const styles = StyleSheet.create({
  container: { flex: 1 },
  center: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    gap: Spacing.lg,
    paddingHorizontal: Spacing.xl,
  },
  errorText: { fontSize: FontSize.lg, textAlign: 'center' },
  header: {
    paddingHorizontal: Spacing.lg,
    paddingVertical: Spacing.sm,
    flexDirection: 'row',
    alignItems: 'center',
    gap: Spacing.md,
  },
  headerButton: {
    width: 36,
    height: 36,
    borderRadius: 18,
    justifyContent: 'center',
    alignItems: 'center',
  },
  videoTitle: {
    flex: 1,
    fontSize: FontSize.base,
    fontWeight: '600',
    textAlign: 'center',
  },
  playerArea: {
    aspectRatio: 16 / 9,
    maxHeight: 250,
    justifyContent: 'center',
    alignItems: 'center',
    position: 'relative',
    borderRadius: BorderRadius.lg,
    marginHorizontal: Spacing.lg,
    overflow: 'hidden',
  },
  videoView: {
    ...StyleSheet.absoluteFill,
  },
  playerState: {
    alignItems: 'center',
    justifyContent: 'center',
    gap: Spacing.md,
    paddingHorizontal: Spacing.xl,
  },
  playerStateText: {
    color: 'rgba(255,255,255,0.85)',
    fontSize: FontSize.sm,
    textAlign: 'center',
  },
  controls: {
    position: 'absolute',
    bottom: 50,
    flexDirection: 'row',
    gap: Spacing.xl,
    alignItems: 'center',
  },
  controlButton: {
    width: 40,
    height: 40,
    borderRadius: 20,
    backgroundColor: 'rgba(0,0,0,0.45)',
    justifyContent: 'center',
    alignItems: 'center',
  },
  controlButtonMain: {
    width: 52,
    height: 52,
    borderRadius: 26,
    backgroundColor: 'rgba(0,0,0,0.6)',
    justifyContent: 'center',
    alignItems: 'center',
  },
  progressTrack: {
    position: 'absolute',
    bottom: 20,
    left: Spacing.lg,
    right: Spacing.lg,
    height: 4,
    borderRadius: 2,
    backgroundColor: 'rgba(255,255,255,0.3)',
  },
  progressFill: { height: 4, borderRadius: 2 },
  timeText: {
    position: 'absolute',
    bottom: 4,
    right: Spacing.lg,
    color: 'rgba(255,255,255,0.8)',
    fontSize: FontSize.xs,
  },
  statusRow: {
    minHeight: 32,
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'center',
    gap: Spacing.sm,
    paddingHorizontal: Spacing.xl,
    paddingTop: Spacing.sm,
  },
  statusText: { flexShrink: 1, fontSize: FontSize.xs, textAlign: 'center' },
  retryText: { fontSize: FontSize.xs, fontWeight: '600' },
  subtitleArea: {
    paddingVertical: Spacing.md,
    borderBottomWidth: 1,
    borderColor: 'transparent',
  },
  toggleRow: {
    flexDirection: 'row',
    justifyContent: 'center',
    gap: Spacing.sm,
    marginTop: Spacing.sm,
  },
  toggle: {
    paddingHorizontal: Spacing.md,
    paddingVertical: Spacing.xs,
    borderRadius: BorderRadius.full,
    borderWidth: 1,
  },
  toggleText: { fontSize: FontSize.xs, fontWeight: '500' },
  questionSummary: {
    marginTop: Spacing.sm,
    fontSize: FontSize.xs,
    textAlign: 'center',
  },
  transcript: { flex: 1 },
  transcriptContent: {
    paddingHorizontal: Spacing.xl,
    paddingVertical: Spacing.md,
  },
  sectionLabel: {
    fontSize: FontSize.md,
    fontWeight: '600',
    marginBottom: Spacing.md,
  },
  transcriptCue: {
    flexDirection: 'row',
    gap: Spacing.md,
    paddingVertical: Spacing.sm,
    paddingHorizontal: Spacing.sm,
    borderRadius: BorderRadius.sm,
  },
  cueTime: { fontSize: FontSize.xs, width: 36, paddingTop: 2 },
  cueBody: { flex: 1 },
  cueChinese: { fontSize: FontSize.base },
  cuePinyin: { fontSize: FontSize.sm },
  cueVietnamese: { fontSize: FontSize.sm },
  modalOverlay: { flex: 1, justifyContent: 'flex-end' },
  modalContent: {
    padding: Spacing['2xl'],
    borderTopLeftRadius: BorderRadius['2xl'],
    borderTopRightRadius: BorderRadius['2xl'],
    gap: Spacing.lg,
    alignItems: 'center',
  },
  modalWord: { fontSize: 36, fontWeight: 'bold' },
  modalActions: { flexDirection: 'row', gap: Spacing.md },
});
