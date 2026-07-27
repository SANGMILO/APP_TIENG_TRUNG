import React, { useState } from 'react';
import { View, Text, StyleSheet, TouchableOpacity, SafeAreaView, ActivityIndicator } from 'react-native';
import { Ionicons } from '@expo/vector-icons';
import { router } from 'expo-router';
import { useQuery } from '@tanstack/react-query';
import { useThemeStore } from '@/stores/theme-store';
import { supabase } from '@/lib/supabase';
import { Button, ProgressBar } from '@/components/ui';
import { AudioPlayer } from '@/components/media';
import { FontSize, Spacing, BorderRadius, Shadow, FontWeight } from '@/constants/theme';

interface ToneSyllable {
  id: string;
  syllable: string;
  tone: number;
  pinyin: string;
  hanzi: string | null;
  meaning_vi: string | null;
  audio_url: string | null;
}

export default function ToneTrainingScreen() {
  const { colors } = useThemeStore();
  const [currentIndex, setCurrentIndex] = useState(0);
  const [selectedTone, setSelectedTone] = useState<number | null>(null);
  const [answered, setAnswered] = useState(false);
  const [correct, setCorrect] = useState(0);
  const [total, setTotal] = useState(0);
  const [completed, setCompleted] = useState(false);

  const { data: syllables, isLoading } = useQuery({
    queryKey: ['tone-syllables'],
    queryFn: async () => {
      const { data, error } = await supabase.from('tone_syllables').select('*').order('difficulty').limit(10);
      if (error) throw error;
      return (data ?? []) as ToneSyllable[];
    },
  });

  const currentSyllable = syllables?.[currentIndex];
  const progress = syllables ? ((currentIndex + 1) / syllables.length) * 100 : 0;

  const handleSelect = (tone: number) => {
    if (answered) return;
    setSelectedTone(tone);
    setAnswered(true);
    setTotal(prev => prev + 1);
    if (tone === currentSyllable?.tone) setCorrect(prev => prev + 1);
  };

  const handleNext = () => {
    if (!syllables) return;
    if (currentIndex < syllables.length - 1) {
      setCurrentIndex(prev => prev + 1);
      setSelectedTone(null);
      setAnswered(false);
    } else {
      setCompleted(true);
    }
  };

  if (isLoading) {
    return (
      <SafeAreaView style={[styles.container, { backgroundColor: colors.background }]}>
        <View style={styles.center}><ActivityIndicator size="large" color={colors.primary} /></View>
      </SafeAreaView>
    );
  }

  if (!syllables?.length) {
    return (
      <SafeAreaView style={[styles.container, { backgroundColor: colors.background }]}>
        <View style={styles.center}>
          <Ionicons name="musical-notes-outline" size={40} color={colors.textTertiary} />
          <Text style={[styles.emptyTitle, { color: colors.text }]}>Chưa có dữ liệu</Text>
          <Button title="Quay lại" variant="primary" size="lg" onPress={() => router.back()} />
        </View>
      </SafeAreaView>
    );
  }

  if (completed) {
    const rate = total > 0 ? Math.round((correct / total) * 100) : 0;
    return (
      <SafeAreaView style={[styles.container, { backgroundColor: colors.background }]}>
        <View style={styles.center}>
          <View style={[styles.resultIcon, { backgroundColor: rate >= 80 ? colors.jade + '15' : colors.coin + '15' }]}>
            <Ionicons name={rate >= 80 ? 'checkmark-circle' : 'refresh-circle'} size={36} color={rate >= 80 ? colors.jade : colors.coin} />
          </View>
          <Text style={[styles.resultTitle, { color: colors.text }]}>Hoàn thành!</Text>
          <Text style={[styles.resultScore, { color: colors.primary }]}>{correct}/{total} đúng ({rate}%)</Text>
          <Button title="Quay lại" variant="primary" size="lg" rounded onPress={() => router.back()} style={{ marginTop: Spacing.xl }} />
        </View>
      </SafeAreaView>
    );
  }

  const isCorrect = selectedTone === currentSyllable?.tone;

  return (
    <SafeAreaView style={[styles.container, { backgroundColor: colors.background }]}>
      {/* Header */}
      <View style={styles.header}>
        <TouchableOpacity onPress={() => router.back()} style={[styles.closeBtn, { backgroundColor: colors.surfaceElevated }]}>
          <Ionicons name="close" size={20} color={colors.textSecondary} />
        </TouchableOpacity>
        <View style={{ flex: 1 }}>
          <ProgressBar progress={progress} height={6} color={colors.primary} animated />
        </View>
        <View style={[styles.scoreBadge, { backgroundColor: colors.jade + '15' }]}>
          <Ionicons name="checkmark" size={14} color={colors.jade} />
          <Text style={[styles.scoreNum, { color: colors.jade }]}>{correct}</Text>
        </View>
      </View>

      {/* Content */}
      <View style={styles.questionArea}>
        <Text style={[styles.instruction, { color: colors.textSecondary }]}>Nghe và chọn thanh điệu đúng</Text>

        {/* Syllable display */}
        <View style={[styles.syllableCard, { backgroundColor: colors.card }]}>
          {currentSyllable?.audio_url ? (
            <AudioPlayer uri={currentSyllable.audio_url} size="lg" label="Nghe" autoPlay />
          ) : (
            <>
              {currentSyllable?.hanzi && <Text style={[styles.hanziText, { color: colors.text }]}>{currentSyllable.hanzi}</Text>}
              <Text style={[styles.syllableText, { color: colors.primary }]}>{currentSyllable?.pinyin}</Text>
            </>
          )}
        </View>

        {/* Tone options */}
        <View style={styles.toneGrid}>
          {[1, 2, 3, 4, 5].map(tone => {
            let bg = colors.card;
            let borderColor = 'transparent';
            if (answered && tone === currentSyllable?.tone) { bg = colors.successLight; borderColor = colors.jade; }
            else if (answered && tone === selectedTone && !isCorrect) { bg = colors.errorLight; borderColor = colors.error; }
            return (
              <TouchableOpacity
                key={tone}
                style={[styles.toneBtn, { backgroundColor: bg, borderColor }, borderColor !== 'transparent' && { borderWidth: 1.5 }]}
                onPress={() => handleSelect(tone)}
                disabled={answered}
                activeOpacity={0.7}
              >
                <Text style={[styles.toneLabel, { color: colors.text }]}>Thanh {tone === 5 ? 'nhẹ' : tone}</Text>
                <Text style={[styles.toneDesc, { color: colors.textTertiary }]}>{getToneDesc(tone)}</Text>
              </TouchableOpacity>
            );
          })}
        </View>

        {/* Feedback */}
        {answered && (
          <View style={[styles.feedbackPanel, { backgroundColor: isCorrect ? colors.successLight : colors.errorLight }]}>
            <Ionicons name={isCorrect ? 'checkmark-circle' : 'close-circle'} size={20} color={isCorrect ? colors.jade : colors.error} />
            <View style={{ flex: 1 }}>
              <Text style={[styles.feedbackText, { color: isCorrect ? colors.jade : colors.error }]}>
                {isCorrect ? 'Đúng rồi!' : `Đáp án: Thanh ${currentSyllable?.tone === 5 ? 'nhẹ' : currentSyllable?.tone}`}
              </Text>
              {currentSyllable?.meaning_vi && (
                <Text style={[styles.feedbackMeaning, { color: colors.textSecondary }]}>
                  {currentSyllable.hanzi} ({currentSyllable.pinyin}) = {currentSyllable.meaning_vi}
                </Text>
              )}
            </View>
          </View>
        )}

        {answered && (
          <Button title="Tiếp tục" variant="primary" size="lg" fullWidth rounded onPress={handleNext} style={{ marginTop: Spacing.lg }} />
        )}
      </View>
    </SafeAreaView>
  );
}

function getToneDesc(tone: number): string {
  switch (tone) {
    case 1: return 'Cao, bằng ─';
    case 2: return 'Lên ╱';
    case 3: return 'Xuống lên ╲╱';
    case 4: return 'Xuống ╲';
    case 5: return 'Nhẹ, ngắn';
    default: return '';
  }
}

const styles = StyleSheet.create({
  container: { flex: 1 },
  center: { flex: 1, justifyContent: 'center', alignItems: 'center', paddingHorizontal: Spacing['2xl'], gap: Spacing.lg },
  emptyTitle: { fontSize: FontSize.lg, fontWeight: FontWeight.semibold },
  resultIcon: { width: 72, height: 72, borderRadius: 36, justifyContent: 'center', alignItems: 'center' },
  resultTitle: { fontSize: FontSize['2xl'], fontWeight: FontWeight.bold },
  resultScore: { fontSize: FontSize.lg, fontWeight: FontWeight.semibold },
  header: { flexDirection: 'row', alignItems: 'center', paddingHorizontal: Spacing.xl, paddingVertical: Spacing.sm, gap: Spacing.md },
  closeBtn: { width: 36, height: 36, borderRadius: 18, justifyContent: 'center', alignItems: 'center' },
  scoreBadge: { flexDirection: 'row', alignItems: 'center', gap: 3, paddingHorizontal: Spacing.sm + 2, paddingVertical: Spacing.xs, borderRadius: BorderRadius.full },
  scoreNum: { fontSize: FontSize.sm, fontWeight: FontWeight.bold },
  questionArea: { flex: 1, paddingHorizontal: Spacing.xl, paddingTop: Spacing.xl },
  instruction: { fontSize: FontSize.base, textAlign: 'center', marginBottom: Spacing.xl },
  syllableCard: { alignItems: 'center', paddingVertical: Spacing['2xl'], borderRadius: BorderRadius.xl, marginBottom: Spacing.xl, ...Shadow.sm },
  hanziText: { fontSize: FontSize.chineseLarge, fontWeight: FontWeight.bold },
  syllableText: { fontSize: FontSize['2xl'], fontWeight: FontWeight.semibold, marginTop: Spacing.sm },
  toneGrid: { gap: Spacing.sm },
  toneBtn: { flexDirection: 'row', justifyContent: 'space-between', alignItems: 'center', paddingVertical: Spacing.lg, paddingHorizontal: Spacing.xl, borderRadius: BorderRadius.lg, ...Shadow.xs },
  toneLabel: { fontSize: FontSize.base, fontWeight: FontWeight.semibold },
  toneDesc: { fontSize: FontSize.sm },
  feedbackPanel: { flexDirection: 'row', alignItems: 'center', gap: Spacing.md, padding: Spacing.lg, borderRadius: BorderRadius.xl, marginTop: Spacing.xl },
  feedbackText: { fontSize: FontSize.base, fontWeight: FontWeight.bold },
  feedbackMeaning: { fontSize: FontSize.sm, marginTop: 2 },
});
