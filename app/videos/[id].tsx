import React, { useState, useEffect, useRef, useCallback, useMemo } from 'react';
import { View, Text, StyleSheet, TouchableOpacity, ScrollView, SafeAreaView, ActivityIndicator, Modal } from 'react-native';
import { Ionicons } from '@expo/vector-icons';
import { useLocalSearchParams, router } from 'expo-router';
import { useQuery } from '@tanstack/react-query';
import { useThemeStore } from '@/stores/theme-store';
import { useAuthStore } from '@/stores/auth-store';
import { Button, Card } from '@/components/ui';
import { InteractiveSubtitle, VideoQuestionOverlay } from '@/components/video';
import { ChineseText } from '@/components/chinese';
import {
  fetchVideoById, fetchSubtitles, fetchVideoQuestions, fetchVideoProgress,
  saveVideoProgress, completeVideo, saveVideoAnswer,
  findCurrentCue, findPendingQuestion,
  SubtitleCue, VideoQuestion, VideoProgress,
} from '@/services/video-service';
import { supabase } from '@/lib/supabase';
import { FontSize, Spacing, BorderRadius } from '@/constants/theme';

export default function VideoDetailScreen() {
  const { id } = useLocalSearchParams<{ id: string }>();
  const { colors } = useThemeStore();
  const { profile } = useAuthStore();

  // Video data
  const { data: video, isLoading: loadingVideo } = useQuery({
    queryKey: ['video', id],
    queryFn: () => fetchVideoById(id!),
    enabled: !!id,
  });

  const { data: subtitles } = useQuery({
    queryKey: ['video-subtitles', id],
    queryFn: () => fetchSubtitles(id!),
    enabled: !!id,
  });

  const { data: questions } = useQuery({
    queryKey: ['video-questions', id],
    queryFn: () => fetchVideoQuestions(id!),
    enabled: !!id,
  });

  const { data: progress } = useQuery({
    queryKey: ['video-progress', id],
    queryFn: () => fetchVideoProgress(profile!.id, id!),
    enabled: !!id && !!profile,
  });

  // Vocabulary dictionary for tokenizer
  const { data: vocabDict } = useQuery({
    queryKey: ['vocab-dict'],
    queryFn: async () => {
      const { data } = await supabase.from('vocabulary').select('chinese').eq('status', 'published');
      return new Set((data ?? []).map((v: any) => v.chinese));
    },
  });

  // Player state
  const [currentTimeMs, setCurrentTimeMs] = useState(progress?.last_position_ms ?? 0);
  const [isPlaying, setIsPlaying] = useState(false);
  const [showChinese, setShowChinese] = useState(true);
  const [showPinyin, setShowPinyin] = useState(true);
  const [showVietnamese, setShowVietnamese] = useState(true);
  const [activeQuestion, setActiveQuestion] = useState<VideoQuestion | null>(null);
  const [answeredQuestions, setAnsweredQuestions] = useState<Set<string>>(new Set());
  const [wordModal, setWordModal] = useState<string | null>(null);
  const [watchTimeMs, setWatchTimeMs] = useState(0);

  // Progress save interval
  const saveIntervalRef = useRef<ReturnType<typeof setInterval> | null>(null);

  useEffect(() => {
    // Save progress every 15 seconds
    saveIntervalRef.current = setInterval(() => {
      if (profile && id && currentTimeMs > 0) {
        const durationMs = (video?.duration_seconds ?? 0) * 1000;
        saveVideoProgress(profile.id, id, currentTimeMs, watchTimeMs, durationMs);
      }
    }, 15000);

    return () => {
      if (saveIntervalRef.current) clearInterval(saveIntervalRef.current);
      // Final save on unmount
      if (profile && id && currentTimeMs > 0) {
        const durationMs = (video?.duration_seconds ?? 0) * 1000;
        saveVideoProgress(profile.id, id, currentTimeMs, watchTimeMs, durationMs);
      }
    };
  }, [profile, id, currentTimeMs, watchTimeMs, video]);

  // Current subtitle
  const currentCue = useMemo(() => {
    if (!subtitles) return null;
    return findCurrentCue(subtitles, currentTimeMs);
  }, [subtitles, currentTimeMs]);

  // Check for pending questions
  useEffect(() => {
    if (!questions || !isPlaying) return;
    const pending = findPendingQuestion(questions, currentTimeMs, answeredQuestions);
    if (pending) {
      setActiveQuestion(pending);
      setIsPlaying(false);
    }
  }, [currentTimeMs, questions, isPlaying, answeredQuestions]);

  // Simulate playback (in real app, expo-video provides this)
  useEffect(() => {
    let timer: ReturnType<typeof setInterval>;
    if (isPlaying && !activeQuestion) {
      timer = setInterval(() => {
        setCurrentTimeMs(prev => {
          const next = prev + 100;
          const max = (video?.duration_seconds ?? 0) * 1000;
          if (next >= max) {
            setIsPlaying(false);
            handleVideoComplete();
            return max;
          }
          return next;
        });
        setWatchTimeMs(prev => prev + 100);
      }, 100);
    }
    return () => clearInterval(timer);
  }, [isPlaying, activeQuestion, video]);

  const handleQuestionAnswer = (answer: string, isCorrect: boolean) => {
    if (!activeQuestion || !profile || !id) return;
    saveVideoAnswer(profile.id, id, activeQuestion.id, answer, isCorrect);
  };

  const handleQuestionContinue = () => {
    if (activeQuestion) {
      setAnsweredQuestions(prev => new Set([...prev, activeQuestion.id]));
    }
    setActiveQuestion(null);
    setIsPlaying(true);
  };

  const handleVideoComplete = async () => {
    if (!id) return;
    await completeVideo(id, watchTimeMs, answeredQuestions.size, answeredQuestions.size);
  };

  const handleWordPress = (word: string) => {
    setWordModal(word);
    setIsPlaying(false);
  };

  const handleSaveWord = async (word: string) => {
    if (!profile) return;
    // Find vocabulary entry
    const { data } = await supabase.from('vocabulary').select('id').eq('chinese', word).single();
    if (data) {
      await supabase.from('saved_words').upsert({ user_id: profile.id, vocabulary_id: data.id }, { onConflict: 'user_id,vocabulary_id' });
    }
    setWordModal(null);
  };

  if (loadingVideo) {
    return (
      <SafeAreaView style={[styles.container, { backgroundColor: colors.background }]}>
        <View style={styles.center}><ActivityIndicator size="large" color={colors.primary} /></View>
      </SafeAreaView>
    );
  }

  if (!video) {
    return (
      <SafeAreaView style={[styles.container, { backgroundColor: colors.background }]}>
        <View style={styles.center}>
          <Text style={[styles.errorText, { color: colors.text }]}>Video không tồn tại</Text>
          <Button title="Quay lại" variant="primary" onPress={() => router.back()} />
        </View>
      </SafeAreaView>
    );
  }

  const progressPercent = video.duration_seconds > 0 ? (currentTimeMs / (video.duration_seconds * 1000)) * 100 : 0;

  return (
    <SafeAreaView style={[styles.container, { backgroundColor: colors.background }]}>
      {/* Header */}
      <View style={styles.header}>
        <TouchableOpacity onPress={() => router.back()} style={[styles.backBtnWrap, { backgroundColor: colors.surfaceElevated }]}>
          <Ionicons name="chevron-back" size={20} color={colors.text} />
        </TouchableOpacity>
        <Text style={[styles.videoTitle, { color: colors.text }]} numberOfLines={1}>{video.title}</Text>
        <View style={{ width: 36 }} />
      </View>

      {/* Video Player Area */}
      <View style={[styles.playerArea, { backgroundColor: '#1C1917' }]}>
        <Ionicons name="play-circle-outline" size={48} color="rgba(255,255,255,0.4)" />

        {/* Playback controls */}
        <View style={styles.controls}>
          <TouchableOpacity onPress={() => setCurrentTimeMs(Math.max(0, currentTimeMs - 5000))} style={styles.controlBtn}>
            <Ionicons name="play-back" size={22} color="#fff" />
          </TouchableOpacity>
          <TouchableOpacity onPress={() => setIsPlaying(!isPlaying)} style={styles.controlBtnMain}>
            <Ionicons name={isPlaying ? 'pause' : 'play'} size={28} color="#fff" />
          </TouchableOpacity>
          <TouchableOpacity onPress={() => setCurrentTimeMs(Math.min((video.duration_seconds * 1000), currentTimeMs + 5000))} style={styles.controlBtn}>
            <Ionicons name="play-forward" size={22} color="#fff" />
          </TouchableOpacity>
        </View>

        {/* Progress bar */}
        <View style={[styles.progressTrack, { backgroundColor: colors.border }]}>
          <View style={[styles.progressFill, { width: `${Math.min(100, progressPercent)}%`, backgroundColor: colors.primary }]} />
        </View>
        <Text style={[styles.timeText, { color: colors.textTertiary }]}>
          {formatMs(currentTimeMs)} / {formatMs(video.duration_seconds * 1000)}
        </Text>

        {/* Question overlay */}
        {activeQuestion && (
          <VideoQuestionOverlay
            question={activeQuestion}
            onAnswer={handleQuestionAnswer}
            onContinue={handleQuestionContinue}
          />
        )}
      </View>

      {/* Subtitle Display */}
      <View style={[styles.subtitleArea, { backgroundColor: colors.surface }]}>
        <InteractiveSubtitle
          cue={currentCue}
          showChinese={showChinese}
          showPinyin={showPinyin}
          showVietnamese={showVietnamese}
          vocabulary={vocabDict ?? new Set()}
          onWordPress={handleWordPress}
        />

        {/* Subtitle toggles */}
        <View style={styles.toggleRow}>
          <ToggleChip label="中文" active={showChinese} onPress={() => setShowChinese(!showChinese)} colors={colors} />
          <ToggleChip label="Pinyin" active={showPinyin} onPress={() => setShowPinyin(!showPinyin)} colors={colors} />
          <ToggleChip label="Tiếng Việt" active={showVietnamese} onPress={() => setShowVietnamese(!showVietnamese)} colors={colors} />
        </View>
      </View>

      {/* Transcript (scrollable) */}
      <ScrollView style={styles.transcript} contentContainerStyle={styles.transcriptContent}>
        <Text style={[styles.sectionLabel, { color: colors.text }]}>Transcript</Text>
        {(subtitles ?? []).map((cue) => (
          <TouchableOpacity
            key={cue.id}
            style={[styles.transcriptCue, cue.id === currentCue?.id && { backgroundColor: colors.primary + '10' }]}
            onPress={() => { setCurrentTimeMs(cue.start_ms); setIsPlaying(true); }}
          >
            <Text style={[styles.cueTime, { color: colors.textTertiary }]}>{formatMs(cue.start_ms)}</Text>
            <View style={{ flex: 1 }}>
              {cue.chinese_text && <Text style={[styles.cueChinese, { color: colors.text }]}>{cue.chinese_text}</Text>}
              {showPinyin && cue.pinyin && <Text style={[styles.cuePinyin, { color: colors.primary }]}>{cue.pinyin}</Text>}
              {showVietnamese && cue.vietnamese_text && <Text style={[styles.cueVi, { color: colors.textSecondary }]}>{cue.vietnamese_text}</Text>}
            </View>
          </TouchableOpacity>
        ))}
      </ScrollView>

      {/* Word Detail Modal */}
      <Modal visible={!!wordModal} transparent animationType="slide">
        <View style={[styles.modalOverlay, { backgroundColor: colors.overlay }]}>
          <View style={[styles.modalContent, { backgroundColor: colors.surface }]}>
            <Text style={[styles.modalWord, { color: colors.text }]}>{wordModal}</Text>
            <View style={styles.modalActions}>
              <Button title="Lưu từ" variant="primary" size="sm" icon={<Ionicons name="bookmark" size={14} color="#fff" />} onPress={() => wordModal && handleSaveWord(wordModal)} />
              <Button title="Đóng" variant="ghost" size="sm" onPress={() => { setWordModal(null); setIsPlaying(true); }} />
            </View>
          </View>
        </View>
      </Modal>
    </SafeAreaView>
  );
}

function ToggleChip({ label, active, onPress, colors }: { label: string; active: boolean; onPress: () => void; colors: any }) {
  return (
    <TouchableOpacity
      style={[styles.toggle, { backgroundColor: active ? colors.primary + '20' : colors.surfaceElevated, borderColor: active ? colors.primary : colors.border }]}
      onPress={onPress}
    >
      <Text style={[styles.toggleText, { color: active ? colors.primary : colors.textSecondary }]}>{label}</Text>
    </TouchableOpacity>
  );
}

function formatMs(ms: number): string {
  const totalSec = Math.floor(ms / 1000);
  const m = Math.floor(totalSec / 60);
  const s = totalSec % 60;
  return `${m}:${s.toString().padStart(2, '0')}`;
}

const styles = StyleSheet.create({
  container: { flex: 1 },
  center: { flex: 1, justifyContent: 'center', alignItems: 'center', gap: Spacing.lg },
  errorText: { fontSize: FontSize.lg },
  header: { paddingHorizontal: Spacing.lg, paddingVertical: Spacing.sm, flexDirection: 'row', alignItems: 'center', gap: Spacing.md },
  backBtnWrap: { width: 36, height: 36, borderRadius: 18, justifyContent: 'center', alignItems: 'center' },
  videoTitle: { flex: 1, fontSize: FontSize.base, fontWeight: '600', textAlign: 'center' },
  playerArea: { aspectRatio: 16 / 9, maxHeight: 250, justifyContent: 'center', alignItems: 'center', position: 'relative', borderRadius: BorderRadius.lg, marginHorizontal: Spacing.lg, overflow: 'hidden' },
  controls: { position: 'absolute', bottom: 50, flexDirection: 'row', gap: Spacing.xl, alignItems: 'center' },
  controlBtn: { width: 40, height: 40, borderRadius: 20, backgroundColor: 'rgba(255,255,255,0.15)', justifyContent: 'center', alignItems: 'center' },
  controlBtnMain: { width: 52, height: 52, borderRadius: 26, backgroundColor: 'rgba(255,255,255,0.2)', justifyContent: 'center', alignItems: 'center' },
  progressTrack: { position: 'absolute', bottom: 20, left: Spacing.lg, right: Spacing.lg, height: 4, borderRadius: 2 },
  progressFill: { height: 4, borderRadius: 2 },
  timeText: { position: 'absolute', bottom: 4, right: Spacing.lg, fontSize: FontSize.xs },
  subtitleArea: { paddingVertical: Spacing.md, borderBottomWidth: 1, borderColor: 'transparent' },
  toggleRow: { flexDirection: 'row', justifyContent: 'center', gap: Spacing.sm, marginTop: Spacing.sm },
  toggle: { paddingHorizontal: Spacing.md, paddingVertical: Spacing.xs, borderRadius: BorderRadius.full, borderWidth: 1 },
  toggleText: { fontSize: FontSize.xs, fontWeight: '500' },
  transcript: { flex: 1 },
  transcriptContent: { paddingHorizontal: Spacing.xl, paddingVertical: Spacing.md },
  sectionLabel: { fontSize: FontSize.md, fontWeight: '600', marginBottom: Spacing.md },
  transcriptCue: { flexDirection: 'row', gap: Spacing.md, paddingVertical: Spacing.sm, paddingHorizontal: Spacing.sm, borderRadius: BorderRadius.sm },
  cueTime: { fontSize: FontSize.xs, width: 36, paddingTop: 2 },
  cueChinese: { fontSize: FontSize.base },
  cuePinyin: { fontSize: FontSize.sm },
  cueVi: { fontSize: FontSize.sm },
  modalOverlay: { flex: 1, justifyContent: 'flex-end' },
  modalContent: { padding: Spacing['2xl'], borderTopLeftRadius: BorderRadius['2xl'], borderTopRightRadius: BorderRadius['2xl'], gap: Spacing.lg, alignItems: 'center' },
  modalWord: { fontSize: 36, fontWeight: 'bold' },
  modalActions: { flexDirection: 'row', gap: Spacing.md },
});
