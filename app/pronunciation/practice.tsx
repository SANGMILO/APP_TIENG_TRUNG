import React, { useState } from 'react';
import { View, Text, StyleSheet, SafeAreaView, TouchableOpacity, ActivityIndicator } from 'react-native';
import { Ionicons } from '@expo/vector-icons';
import { router } from 'expo-router';
import { useQuery } from '@tanstack/react-query';
import { useThemeStore } from '@/stores/theme-store';
import { useAuthStore } from '@/stores/auth-store';
import { supabase } from '@/lib/supabase';
import { Button, ProgressBar } from '@/components/ui';
import { ChineseText } from '@/components/chinese';
import { AudioPlayer } from '@/components/media';
import { SpeakingExercise } from '@/components/exercise';
import { LessonExercise } from '@/services/lesson-engine';
import { FontSize, Spacing } from '@/constants/theme';
import { Vocabulary } from '@/types';

export default function PronunciationPracticeScreen() {
  const { colors } = useThemeStore();
  const { profile } = useAuthStore();
  const [currentIndex, setCurrentIndex] = useState(0);
  const [completed, setCompleted] = useState(false);
  const [scores, setScores] = useState<number[]>([]);

  // Fetch vocabulary to practice pronunciation
  const { data: vocab, isLoading } = useQuery({
    queryKey: ['pronunciation-practice-words'],
    queryFn: async () => {
      if (!profile) return [];

      // Get published vocabulary, prioritize those with low pronunciation scores
      const { data, error } = await supabase
        .from('vocabulary')
        .select('*')
        .eq('status', 'published')
        .limit(5);

      if (error) throw error;
      return (data ?? []) as Vocabulary[];
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
          <Text style={[styles.resultCount, { color: colors.textTertiary }]}>{vocab.length} từ đã luyện</Text>
          <Button title="Hoàn thành" variant="primary" size="lg" fullWidth rounded onPress={() => router.back()} style={{ marginTop: Spacing.xl }} />
        </View>
      </SafeAreaView>
    );
  }

  const word = vocab[currentIndex];
  const progress = ((currentIndex + 1) / vocab.length) * 100;

  // Create a fake exercise object for the SpeakingExercise component
  const fakeExercise: LessonExercise = {
    id: `practice_${word.id}`,
    lesson_id: '',
    exercise_type: 'speaking',
    order_index: currentIndex,
    question: `Phát âm: ${word.chinese}`,
    correct_answer: word.chinese,
    question_audio_url: word.audio_url,
    explanation: null,
    hint: null,
    points: 1,
    data: {
      text: word.chinese,
      pinyin: word.pinyin,
      meaning: word.meaning_vi,
      audio_url: word.audio_url,
      passing_score: 60,
    },
    created_at: '',
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
          exercise={fakeExercise}
          colors={colors}
          onAnswer={(answer, isCorrect) => {
            // Could capture score here
          }}
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
