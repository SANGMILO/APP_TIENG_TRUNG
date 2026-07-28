import React, { useRef, useState } from 'react';
import { View, Text, StyleSheet, TouchableOpacity } from 'react-native';
import * as Crypto from 'expo-crypto';
import { useThemeStore } from '@/stores/theme-store';
import { Button } from '@/components/ui';
import { VideoAnswerResult, VideoQuestion } from '@/services/video-service';
import { FontSize, Spacing, BorderRadius } from '@/constants/theme';

interface VideoQuestionOverlayProps {
  question: VideoQuestion;
  onSubmit: (answer: string, attemptId: string) => Promise<VideoAnswerResult>;
  onContinue: () => void;
}

export function VideoQuestionOverlay({ question, onSubmit, onContinue }: VideoQuestionOverlayProps) {
  const { colors } = useThemeStore();
  const [selected, setSelected] = useState<number | null>(null);
  const [answered, setAnswered] = useState(false);
  const [isCorrect, setIsCorrect] = useState(false);
  const [saving, setSaving] = useState(false);
  const [error, setError] = useState('');
  const attemptIdRef = useRef(Crypto.randomUUID());

  const options = question.options || [];

  const persistAnswer = async (index: number) => {
    if (answered || saving) return;
    setSelected(index);
    setSaving(true);
    setError('');
    try {
      const result = await onSubmit(options[index], attemptIdRef.current);
      setIsCorrect(result.is_correct);
      setAnswered(true);
    } catch (reason: unknown) {
      setError(getErrorMessage(reason));
    } finally {
      setSaving(false);
    }
  };

  return (
    <View style={[styles.overlay, { backgroundColor: colors.background + 'F5' }]}>
      <View style={styles.content}>
        <Text style={[styles.label, { color: colors.primary }]}>❓ Câu hỏi</Text>
        <Text style={[styles.question, { color: colors.text }]}>{question.question}</Text>

        <View style={styles.options}>
          {options.map((opt: string, i: number) => {
            let bg = colors.surface;
            let border = colors.border;
            if (answered && i === selected && isCorrect) { bg = colors.successLight; border = colors.success; }
            else if (answered && i === selected) { bg = colors.errorLight; border = colors.error; }

            return (
              <TouchableOpacity
                key={i}
                style={[styles.option, { backgroundColor: bg, borderColor: border }]}
                onPress={() => { void persistAnswer(i); }}
                disabled={answered || saving || Boolean(error)}
              >
                <Text style={[styles.optionText, { color: colors.text }]}>{opt}</Text>
              </TouchableOpacity>
            );
          })}
        </View>

        {saving ? (
          <Text style={[styles.savingText, { color: colors.textSecondary }]}>
            Đang lưu câu trả lời...
          </Text>
        ) : null}

        {error && selected !== null ? (
          <View style={styles.feedback}>
            <Text style={[styles.explanation, { color: colors.error }]}>{error}</Text>
            <Button
              title="Thử lưu lại"
              variant="outline"
              size="md"
              onPress={() => { void persistAnswer(selected); }}
            />
          </View>
        ) : null}

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
  savingText: { fontSize: FontSize.sm, textAlign: 'center' },
  explanation: { fontSize: FontSize.md, textAlign: 'center' },
});

function getErrorMessage(reason: unknown) {
  if (
    typeof reason === 'object'
    && reason !== null
    && 'message' in reason
    && typeof reason.message === 'string'
  ) {
    return reason.message;
  }
  return 'Không thể lưu câu trả lời. Vui lòng thử lại.';
}
