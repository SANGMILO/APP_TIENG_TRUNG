import React, { useState } from 'react';
import { View, Text, StyleSheet, TouchableOpacity } from 'react-native';
import { useThemeStore } from '@/stores/theme-store';
import { Button } from '@/components/ui';
import { VideoQuestion } from '@/services/video-service';
import { FontSize, Spacing, BorderRadius } from '@/constants/theme';

interface VideoQuestionOverlayProps {
  question: VideoQuestion;
  onAnswer: (answer: string, isCorrect: boolean) => void;
  onContinue: () => void;
}

export function VideoQuestionOverlay({ question, onAnswer, onContinue }: VideoQuestionOverlayProps) {
  const { colors } = useThemeStore();
  const [selected, setSelected] = useState<number | null>(null);
  const [answered, setAnswered] = useState(false);

  const options = question.options || [];
  const correctIndex = options.indexOf(question.correct_answer);

  const handleSelect = (index: number) => {
    if (answered) return;
    setSelected(index);
    setAnswered(true);
    const isCorrect = options[index] === question.correct_answer;
    onAnswer(options[index], isCorrect);
  };

  const isCorrect = selected !== null && options[selected] === question.correct_answer;

  return (
    <View style={[styles.overlay, { backgroundColor: colors.background + 'F5' }]}>
      <View style={styles.content}>
        <Text style={[styles.label, { color: colors.primary }]}>❓ Câu hỏi</Text>
        <Text style={[styles.question, { color: colors.text }]}>{question.question}</Text>

        <View style={styles.options}>
          {options.map((opt: string, i: number) => {
            let bg = colors.surface;
            let border = colors.border;
            if (answered && i === correctIndex) { bg = colors.successLight; border = colors.success; }
            else if (answered && i === selected && !isCorrect) { bg = colors.errorLight; border = colors.error; }

            return (
              <TouchableOpacity
                key={i}
                style={[styles.option, { backgroundColor: bg, borderColor: border }]}
                onPress={() => handleSelect(i)}
                disabled={answered}
              >
                <Text style={[styles.optionText, { color: colors.text }]}>{opt}</Text>
              </TouchableOpacity>
            );
          })}
        </View>

        {answered && (
          <View style={styles.feedback}>
            <Text style={[styles.feedbackText, { color: isCorrect ? colors.success : colors.error }]}>
              {isCorrect ? '✅ Chính xác!' : '❌ Sai rồi'}
            </Text>
            {question.explanation && (
              <Text style={[styles.explanation, { color: colors.textSecondary }]}>{question.explanation}</Text>
            )}
            <Button title="Tiếp tục xem" variant="primary" size="md" onPress={onContinue} style={{ marginTop: Spacing.md }} />
          </View>
        )}
      </View>
    </View>
  );
}

const styles = StyleSheet.create({
  overlay: { position: 'absolute', top: 0, left: 0, right: 0, bottom: 0, justifyContent: 'center', paddingHorizontal: Spacing.xl },
  content: { gap: Spacing.lg },
  label: { fontSize: FontSize.sm, fontWeight: '600' },
  question: { fontSize: FontSize.lg, fontWeight: '600' },
  options: { gap: Spacing.sm },
  option: { paddingVertical: Spacing.lg, paddingHorizontal: Spacing.xl, borderRadius: BorderRadius.lg, borderWidth: 1.5 },
  optionText: { fontSize: FontSize.base, fontWeight: '500' },
  feedback: { alignItems: 'center', gap: Spacing.sm },
  feedbackText: { fontSize: FontSize.lg, fontWeight: '600' },
  explanation: { fontSize: FontSize.md, textAlign: 'center' },
});
