import React, { useState, useEffect } from 'react';
import { View, Text, StyleSheet, TouchableOpacity, SafeAreaView, ActivityIndicator } from 'react-native';
import { router } from 'expo-router';
import { useThemeStore } from '@/stores/theme-store';
import { useAuthStore } from '@/stores/auth-store';
import { supabase } from '@/lib/supabase';
import { Button, Card, ProgressBar } from '@/components/ui';
import { ChineseText } from '@/components/chinese';
import { AudioPlayer } from '@/components/media';
import { calculateNextReview, SRSRating, SRSCard } from '@/services/srs-engine';
import { FontSize, Spacing, BorderRadius } from '@/constants/theme';

interface ReviewWord {
  id: string;
  vocabulary_id: string;
  chinese: string;
  pinyin: string;
  meaning_vi: string;
  audio_url: string | null;
  example_sentence: string | null;
  example_pinyin: string | null;
  example_meaning: string | null;
  difficulty: number;
  review_count: number;
  memory_strength: number;
}

export default function ReviewSessionScreen() {
  const { colors } = useThemeStore();
  const { profile } = useAuthStore();
  const [words, setWords] = useState<ReviewWord[]>([]);
  const [currentIndex, setCurrentIndex] = useState(0);
  const [revealed, setRevealed] = useState(false);
  const [loading, setLoading] = useState(true);
  const [completed, setCompleted] = useState(false);
  const [results, setResults] = useState<{ correct: number; total: number }>({ correct: 0, total: 0 });

  useEffect(() => {
    loadDueWords();
  }, []);

  const loadDueWords = async () => {
    if (!profile) return;
    try {
      const now = new Date().toISOString();
      const { data, error } = await supabase
        .from('user_vocabulary_progress')
        .select(`
          id, vocabulary_id, difficulty, review_count, memory_strength,
          vocabulary:vocabulary_id (chinese, pinyin, meaning_vi, audio_url, example_sentence, example_pinyin, example_meaning)
        `)
        .eq('user_id', profile.id)
        .lte('next_review_at', now)
        .order('next_review_at')
        .limit(20);

      if (error) throw error;

      const mapped = (data ?? []).map((item: any) => ({
        id: item.id,
        vocabulary_id: item.vocabulary_id,
        chinese: item.vocabulary.chinese,
        pinyin: item.vocabulary.pinyin,
        meaning_vi: item.vocabulary.meaning_vi,
        audio_url: item.vocabulary.audio_url,
        example_sentence: item.vocabulary.example_sentence,
        example_pinyin: item.vocabulary.example_pinyin,
        example_meaning: item.vocabulary.example_meaning,
        difficulty: item.difficulty,
        review_count: item.review_count,
        memory_strength: item.memory_strength,
      }));

      setWords(mapped);
    } catch (err) {
      console.error('Failed to load review words:', err);
    } finally {
      setLoading(false);
    }
  };

  const handleRating = async (rating: SRSRating) => {
    const word = words[currentIndex];
    const card: SRSCard = {
      difficulty: word.difficulty,
      interval_days: 0,
      review_count: word.review_count,
      memory_strength: word.memory_strength,
      state: 'review',
    };

    const result = calculateNextReview(card, rating);
    const isCorrect = rating === 'good' || rating === 'easy';

    // Update SRS in database
    await supabase
      .from('user_vocabulary_progress')
      .update({
        difficulty: result.difficulty,
        review_count: result.review_count,
        memory_strength: result.memory_strength,
        next_review_at: result.next_review_at.toISOString(),
        last_reviewed_at: new Date().toISOString(),
      })
      .eq('id', word.id);

    setResults(prev => ({
      correct: prev.correct + (isCorrect ? 1 : 0),
      total: prev.total + 1,
    }));

    // Move to next
    if (currentIndex < words.length - 1) {
      setCurrentIndex(prev => prev + 1);
      setRevealed(false);
    } else {
      setCompleted(true);
    }
  };

  if (loading) {
    return (
      <SafeAreaView style={[styles.container, { backgroundColor: colors.background }]}>
        <View style={styles.center}>
          <ActivityIndicator size="large" color={colors.primary} />
        </View>
      </SafeAreaView>
    );
  }

  if (words.length === 0) {
    return (
      <SafeAreaView style={[styles.container, { backgroundColor: colors.background }]}>
        <View style={styles.center}>
          <Text style={styles.emptyEmoji}>🎉</Text>
          <Text style={[styles.emptyTitle, { color: colors.text }]}>Không có từ cần ôn!</Text>
          <Button title="Quay lại" variant="primary" size="lg" onPress={() => router.back()} />
        </View>
      </SafeAreaView>
    );
  }

  if (completed) {
    return (
      <SafeAreaView style={[styles.container, { backgroundColor: colors.background }]}>
        <View style={styles.center}>
          <Text style={styles.emptyEmoji}>✅</Text>
          <Text style={[styles.emptyTitle, { color: colors.text }]}>Ôn tập xong!</Text>
          <Text style={[styles.resultText, { color: colors.textSecondary }]}>
            {results.correct}/{results.total} từ nhớ tốt
          </Text>
          <Button title="Hoàn thành" variant="primary" size="lg" onPress={() => router.back()} style={{ marginTop: Spacing.xl }} />
        </View>
      </SafeAreaView>
    );
  }

  const word = words[currentIndex];
  const progress = ((currentIndex + 1) / words.length) * 100;

  return (
    <SafeAreaView style={[styles.container, { backgroundColor: colors.background }]}>
      <View style={styles.header}>
        <TouchableOpacity onPress={() => router.back()}>
          <Text style={[styles.closeBtn, { color: colors.textSecondary }]}>✕</Text>
        </TouchableOpacity>
        <View style={{ flex: 1 }}>
          <ProgressBar progress={progress} height={6} color={colors.primary} />
        </View>
        <Text style={[styles.counter, { color: colors.textSecondary }]}>
          {currentIndex + 1}/{words.length}
        </Text>
      </View>

      <View style={styles.cardArea}>
        <Card variant="elevated" padding="lg">
          {/* Front: Chinese character */}
          <View style={styles.cardContent}>
            <ChineseText characters={word.chinese} fontSize={56} showPinyin={revealed} pinyin={word.pinyin} showTranslation={false} />
            {word.audio_url && <AudioPlayer uri={word.audio_url} size="md" />}
          </View>

          {/* Back: revealed info */}
          {revealed && (
            <View style={[styles.revealedContent, { borderTopColor: colors.borderLight }]}>
              <Text style={[styles.meaning, { color: colors.text }]}>{word.meaning_vi}</Text>
              {word.example_sentence && (
                <View style={styles.example}>
                  <Text style={[styles.exampleChinese, { color: colors.text }]}>{word.example_sentence}</Text>
                  {word.example_pinyin && <Text style={[styles.examplePinyin, { color: colors.primary }]}>{word.example_pinyin}</Text>}
                  {word.example_meaning && <Text style={[styles.exampleMeaning, { color: colors.textSecondary }]}>{word.example_meaning}</Text>}
                </View>
              )}
            </View>
          )}
        </Card>

        {!revealed ? (
          <Button title="Hiện đáp án" variant="outline" size="lg" fullWidth onPress={() => setRevealed(true)} style={{ marginTop: Spacing.xl }} />
        ) : (
          <View style={styles.ratingRow}>
            <RatingButton label="Quên" emoji="😰" color={colors.error} onPress={() => handleRating('again')} />
            <RatingButton label="Khó" emoji="😐" color={colors.warning} onPress={() => handleRating('hard')} />
            <RatingButton label="Nhớ" emoji="😊" color={colors.success} onPress={() => handleRating('good')} />
            <RatingButton label="Dễ" emoji="😎" color={colors.info} onPress={() => handleRating('easy')} />
          </View>
        )}
      </View>
    </SafeAreaView>
  );
}

function RatingButton({ label, emoji, color, onPress }: { label: string; emoji: string; color: string; onPress: () => void }) {
  return (
    <TouchableOpacity style={[styles.ratingBtn, { borderColor: color }]} onPress={onPress} activeOpacity={0.7}>
      <Text style={styles.ratingEmoji}>{emoji}</Text>
      <Text style={[styles.ratingLabel, { color }]}>{label}</Text>
    </TouchableOpacity>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1 },
  center: { flex: 1, justifyContent: 'center', alignItems: 'center', paddingHorizontal: Spacing['2xl'] },
  emptyEmoji: { fontSize: 48, marginBottom: Spacing.lg },
  emptyTitle: { fontSize: FontSize.xl, fontWeight: 'bold', marginBottom: Spacing.md },
  resultText: { fontSize: FontSize.base },
  header: { flexDirection: 'row', alignItems: 'center', paddingHorizontal: Spacing.xl, paddingVertical: Spacing.md, gap: Spacing.md },
  closeBtn: { fontSize: 24, fontWeight: '300' },
  counter: { fontSize: FontSize.sm },
  cardArea: { flex: 1, paddingHorizontal: Spacing.xl, justifyContent: 'center' },
  cardContent: { alignItems: 'center', gap: Spacing.lg, paddingVertical: Spacing['2xl'] },
  revealedContent: { borderTopWidth: 1, marginTop: Spacing.lg, paddingTop: Spacing.lg, gap: Spacing.md },
  meaning: { fontSize: FontSize.xl, fontWeight: '600', textAlign: 'center' },
  example: { gap: Spacing.xs },
  exampleChinese: { fontSize: FontSize.base },
  examplePinyin: { fontSize: FontSize.sm },
  exampleMeaning: { fontSize: FontSize.sm },
  ratingRow: { flexDirection: 'row', gap: Spacing.sm, marginTop: Spacing.xl },
  ratingBtn: { flex: 1, alignItems: 'center', paddingVertical: Spacing.md, borderRadius: BorderRadius.lg, borderWidth: 1.5, gap: 2 },
  ratingEmoji: { fontSize: 20 },
  ratingLabel: { fontSize: FontSize.xs, fontWeight: '600' },
});
