import React, { useState } from 'react';
import { View, Text, StyleSheet, SafeAreaView, TouchableOpacity, ActivityIndicator } from 'react-native';
import { Ionicons } from '@expo/vector-icons';
import { router } from 'expo-router';
import { useQuery } from '@tanstack/react-query';
import { useThemeStore } from '@/stores/theme-store';
import { useAuthStore } from '@/stores/auth-store';
import { supabase } from '@/lib/supabase';
import { Button, ProgressBar } from '@/components/ui';
import { SpeakingExercise } from '@/components/exercise';
import { FontSize, Spacing } from '@/constants/theme';
import { Vocabulary } from '@/types';

export default function PronunciationPracticeScreen() {
  const { colors } = useThemeStore();
  const { profile } = useAuthStore();
  const [currentIndex, setCurrentIndex] = useState(0);
  const [completed, setCompleted] = useState(false);
  const [scoresByWord, setScoresByWord] = useState<Record<string, number>>({});

  // Fetch vocabulary to practice pronunciation
  const {
    data: vocab,
    isLoading,
    isError,
    refetch,
  } = useQuery({
    queryKey: ['pronunciation-practice-words'],
    queryFn: async () => {
      if (!profile) return [];

      // Get published vocabulary, prioritize those with low pronunciation scores
      const { data, error } = await supabase
        .from('vocabulary')
        .select('*')
        .eq('status', 'published')
        .limit(50);

      if (error) throw error;
      const words = (data ?? []) as Vocabulary[];
      if (!words.length) return [];

      const { data: attempts, error: attemptsError } = await supabase
        .from('pronunciation_attempts')
        .select('vocabulary_id, overall_score, created_at')
        .eq('user_id', profile.id)
        .in('vocabulary_id', words.map(word => word.id))
        .order('created_at', { ascending: false });
      if (attemptsError) throw attemptsError;

      const latestScore = new Map<string, number>();
      for (const attempt of attempts ?? []) {
        if (
          typeof attempt.vocabulary_id === 'string'
          && !latestScore.has(attempt.vocabulary_id)
          && Number.isFinite(Number(attempt.overall_score))
        ) {
          latestScore.set(attempt.vocabulary_id, Number(attempt.overall_score));
        }
      }

      return [...words]
        .sort((a, b) => {
          const scoreA = latestScore.get(a.id) ?? -1;
          const scoreB = latestScore.get(b.id) ?? -1;
          return scoreA - scoreB;
        })
        .slice(0, 5);
    },
    enabled: !!profile,
  });

  if (isLoading) {
    return (
      <SafeAreaView style={[styles.container, { backgroundColor: colors.background }]}>
        <View style={styles.center}>
          <ActivityIndicator size="large" color={colors.primary} />
        </View>
      </SafeAreaView>
    );
  }

  if (isError) {
    return (
      <SafeAreaView style={[styles.container, { backgroundColor: colors.background }]}>
        <View style={styles.center}>
          <Ionicons name="cloud-offline-outline" size={32} color={colors.textTertiary} />
          <Text style={[styles.emptyText, { color: colors.textSecondary }]}>
            Không thể tải danh sách luyện phát âm.
          </Text>
          <Button title="Thử lại" variant="primary" size="lg" onPress={() => void refetch()} />
        </View>
      </SafeAreaView>
    );
  }

  if (!vocab?.length) {
    return (
      <SafeAreaView style={[styles.container, { backgroundColor: colors.background }]}>
        <View style={styles.center}>
          <Text style={[styles.emptyText, { color: colors.textSecondary }]}>Chưa có từ vựng để luyện</Text>
          <Button title="Quay lại" variant="primary" size="lg" onPress={() => router.back()} />
        </View>
      </SafeAreaView>
    );
  }

  if (completed) {
    const scores = Object.values(scoresByWord);
    const avgScore = scores.length > 0 ? Math.round(scores.reduce((s, v) => s + v, 0) / scores.length) : 0;
    const ratingText = avgScore >= 95 ? 'Tuyệt vời! Phát âm rất tự nhiên.' : avgScore >= 85 ? 'Rất tốt! Chỉ cần chỉnh nhẹ một chút.' : avgScore >= 70 ? 'Khá ổn! Hãy nghe mẫu và thử lại.' : 'Đừng lo, mình luyện lại từng âm nhé.';
    return (
      <SafeAreaView style={[styles.container, { backgroundColor: colors.background }]}>
        <View style={styles.center}>
          <View style={[styles.resultIconWrap, { backgroundColor: colors.successLight }]}>
            <Ionicons name="mic" size={28} color={colors.success} />
          </View>
          <Text style={[styles.resultTitle, { color: colors.text }]}>Phiên luyện hoàn thành</Text>
          <Text style={[styles.resultScore, { color: colors.primary }]}>{avgScore}/100</Text>
          <Text style={[styles.resultRating, { color: colors.textSecondary }]}>{ratingText}</Text>
          <Text style={[styles.resultCount, { color: colors.textTertiary }]}>{scores.length} từ đã luyện</Text>
          <Button title="Hoàn thành" variant="primary" size="lg" fullWidth rounded onPress={() => router.back()} style={{ marginTop: Spacing.xl }} />
        </View>
      </SafeAreaView>
    );
  }

  const word = vocab[currentIndex];
  const progress = ((currentIndex + 1) / vocab.length) * 100;

  const practiceTarget = {
      text: word.chinese,
      pinyin: word.pinyin,
      meaning: word.meaning_vi,
      audioUrl: word.audio_url,
      passingScore: 60,
      vocabularyId: word.id,
  };

  return (
    <SafeAreaView style={[styles.container, { backgroundColor: colors.background }]}>
      <View style={styles.header}>
        <TouchableOpacity onPress={() => router.back()} style={[styles.closeBtnWrap, { backgroundColor: colors.surfaceElevated }]}>
          <Ionicons name="close" size={20} color={colors.textSecondary} />
        </TouchableOpacity>
        <View style={{ flex: 1 }}>
          <ProgressBar progress={progress} height={6} color={colors.primary} />
        </View>
        <Text style={[styles.counter, { color: colors.textSecondary }]}>{currentIndex + 1}/{vocab.length}</Text>
      </View>

      <View style={styles.exerciseArea}>
        <SpeakingExercise
          key={word.id}
          practiceTarget={practiceTarget}
          colors={colors}
          onAssessmentComplete={(result) => {
            setScoresByWord(previous => ({
              ...previous,
              [word.id]: result.overallScore,
            }));
          }}
          onAnswer={() => {}}
          onNext={() => {
            if (currentIndex < vocab.length - 1) {
              setCurrentIndex(prev => prev + 1);
            } else {
              setCompleted(true);
            }
          }}
        />
      </View>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1 },
  center: { flex: 1, justifyContent: 'center', alignItems: 'center', paddingHorizontal: Spacing['2xl'] },
  emptyText: { fontSize: FontSize.base, marginBottom: Spacing.xl },
  resultIconWrap: { width: 64, height: 64, borderRadius: 32, justifyContent: 'center', alignItems: 'center', marginBottom: Spacing.lg },
  resultTitle: { fontSize: FontSize['2xl'], fontWeight: 'bold', marginBottom: Spacing.sm },
  resultScore: { fontSize: FontSize['3xl'], fontWeight: 'bold', marginBottom: Spacing.sm },
  resultRating: { fontSize: FontSize.md, textAlign: 'center', marginBottom: Spacing.xs },
  resultCount: { fontSize: FontSize.sm },
  header: { flexDirection: 'row', alignItems: 'center', paddingHorizontal: Spacing.xl, paddingVertical: Spacing.sm, gap: Spacing.md },
  closeBtnWrap: { width: 36, height: 36, borderRadius: 18, justifyContent: 'center', alignItems: 'center' },
  counter: { fontSize: FontSize.sm },
  exerciseArea: { flex: 1, paddingHorizontal: Spacing.xl },
});
