import React, { useEffect, useRef, useState } from 'react';
import { View, Text, StyleSheet, TouchableOpacity, SafeAreaView, ActivityIndicator } from 'react-native';
import * as Crypto from 'expo-crypto';
import { router } from 'expo-router';
import { useQueryClient } from '@tanstack/react-query';
import { useThemeStore } from '@/stores/theme-store';
import { useAuthStore } from '@/stores/auth-store';
import { Button, Card, ProgressBar } from '@/components/ui';
import { ChineseText } from '@/components/chinese';
import { AudioPlayer } from '@/components/media';
import type { SRSRating } from '@/services/srs-engine';
import {
  fetchDueReviewWords,
  ReviewWord,
  submitVocabularyReview,
} from '@/services/review-service';
import { FontSize, Spacing, BorderRadius } from '@/constants/theme';

export default function ReviewSessionScreen() {
  const { colors } = useThemeStore();
  const { profile } = useAuthStore();
  const queryClient = useQueryClient();
  const [words, setWords] = useState<ReviewWord[]>([]);
  const [currentIndex, setCurrentIndex] = useState(0);
  const [revealed, setRevealed] = useState(false);
  const [loading, setLoading] = useState(true);
  const [loadError, setLoadError] = useState('');
  const [saving, setSaving] = useState(false);
  const [ratingError, setRatingError] = useState('');
  const [completed, setCompleted] = useState(false);
  const [results, setResults] = useState<{ correct: number; total: number }>({ correct: 0, total: 0 });
  const pendingSubmissionRef = useRef<{
    wordId: string;
    rating: SRSRating;
    submissionId: string;
  } | null>(null);

  useEffect(() => {
    void loadDueWords();
  }, [profile?.id]);

  const loadDueWords = async () => {
    if (!profile) {
      setLoading(false);
      return;
    }
    setLoading(true);
    setLoadError('');
    try {
      setWords(await fetchDueReviewWords(profile.id));
      setCurrentIndex(0);
      setCompleted(false);
      setResults({ correct: 0, total: 0 });
    } catch (reason: unknown) {
      setLoadError(getErrorMessage(
        reason,
        'Không thể tải các từ đến hạn. Vui lòng thử lại.',
      ));
    } finally {
      setLoading(false);
    }
  };

  const handleRating = async (rating: SRSRating) => {
    if (saving) return;
    const word = words[currentIndex];
    if (!word) return;

    const pending = pendingSubmissionRef.current;
    const submission = pending
      && pending.wordId === word.id
      && pending.rating === rating
      ? pending
      : {
          wordId: word.id,
          rating,
          submissionId: Crypto.randomUUID(),
        };
    pendingSubmissionRef.current = submission;
    const isCorrect = rating === 'good' || rating === 'easy';

    setSaving(true);
    setRatingError('');
    try {
      await submitVocabularyReview(
        submission.submissionId,
        word.id,
        rating,
      );
      pendingSubmissionRef.current = null;
      setResults(prev => ({
        correct: prev.correct + (isCorrect ? 1 : 0),
        total: prev.total + 1,
      }));
      await queryClient.invalidateQueries({ queryKey: ['review-stats'] });

      if (currentIndex < words.length - 1) {
        setCurrentIndex(prev => prev + 1);
        setRevealed(false);
      } else {
        setCompleted(true);
      }
    } catch (reason: unknown) {
      setRatingError(getErrorMessage(
        reason,
        'Không thể lưu kết quả ôn tập. Vui lòng thử lại.',
      ));
    } finally {
      setSaving(false);
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

  if (loadError) {
    return (
      <SafeAreaView style={[styles.container, { backgroundColor: colors.background }]}>
        <View style={styles.center}>
          <Text style={styles.emptyEmoji}>⚠️</Text>
          <Text style={[styles.emptyTitle, { color: colors.text }]}>
            Không thể tải phiên ôn tập
          </Text>
          <Text style={[styles.resultText, { color: colors.error }]}>
            {loadError}
          </Text>
          <Button
            title="Thử lại"
            variant="primary"
            size="lg"
            onPress={() => { void loadDueWords(); }}
          />
          <Button title="Quay lại" variant="outline" onPress={() => router.back()} />
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
        ) : ratingError && pendingSubmissionRef.current ? (
          <View style={styles.ratingError}>
            <Text style={[styles.ratingErrorText, { color: colors.error }]}>
              {ratingError}
            </Text>
            <Button
              title="Thử lưu lại"
              variant="primary"
              size="lg"
              fullWidth
              loading={saving}
              onPress={() => {
                const pending = pendingSubmissionRef.current;
                if (pending) void handleRating(pending.rating);
              }}
            />
          </View>
        ) : (
          <View style={styles.ratingRow}>
            <RatingButton label="Quên" emoji="😰" color={colors.error} disabled={saving} onPress={() => { void handleRating('again'); }} />
            <RatingButton label="Khó" emoji="😐" color={colors.warning} disabled={saving} onPress={() => { void handleRating('hard'); }} />
            <RatingButton label="Nhớ" emoji="😊" color={colors.success} disabled={saving} onPress={() => { void handleRating('good'); }} />
            <RatingButton label="Dễ" emoji="😎" color={colors.info} disabled={saving} onPress={() => { void handleRating('easy'); }} />
          </View>
        )}
      </View>
    </SafeAreaView>
  );
}

function RatingButton({ label, emoji, color, disabled, onPress }: { label: string; emoji: string; color: string; disabled: boolean; onPress: () => void }) {
  return (
    <TouchableOpacity
      style={[styles.ratingBtn, { borderColor: color, opacity: disabled ? 0.5 : 1 }]}
      onPress={onPress}
      disabled={disabled}
      activeOpacity={0.7}
    >
      <Text style={styles.ratingEmoji}>{emoji}</Text>
      <Text style={[styles.ratingLabel, { color }]}>{label}</Text>
    </TouchableOpacity>
  );
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
  ratingError: { marginTop: Spacing.xl, gap: Spacing.md },
  ratingErrorText: { fontSize: FontSize.sm, textAlign: 'center' },
});
