import React, { useState, useCallback } from 'react';
import { View, Text, StyleSheet, TouchableOpacity } from 'react-native';
import { Ionicons } from '@expo/vector-icons';
import { useThemeStore } from '@/stores/theme-store';
import { Button } from '@/components/ui';
import { ChineseText } from '@/components/chinese';
import { AudioPlayer } from '@/components/media';
import { useAudioRecorder } from '@/hooks/useAudioRecorder';
import { assessPronunciation, savePronunciationAttempt } from '@/services/pronunciation-service';
import { generateFeedback } from '@/services/pronunciation-feedback';
import { PronunciationAssessmentResult, getScoreLevel, getScoreLevelLabel, getScoreLevelColor } from '@/lib/speech';
import { LessonExercise } from '@/services/lesson-engine';
import { FontSize, Spacing, BorderRadius, Shadow, FontWeight } from '@/constants/theme';

interface SpeakingExerciseProps {
  exercise: LessonExercise;
  colors: any;
  onAnswer: (answer: string, isCorrect: boolean) => void;
  onNext: () => void;
}

const MAX_RETRIES = 3;

export function SpeakingExercise({ exercise, colors, onAnswer, onNext }: SpeakingExerciseProps) {
  const data = exercise.data as any;
  const referenceText = data?.text || exercise.correct_answer;
  const pinyin = data?.pinyin || '';
  const meaning = data?.meaning || '';
  const passingScore = data?.passing_score || 60;

  const [result, setResult] = useState<PronunciationAssessmentResult | null>(null);
  const [isAssessing, setIsAssessing] = useState(false);
  const [assessError, setAssessError] = useState<string | null>(null);
  const [attempts, setAttempts] = useState(0);
  const [answered, setAnswered] = useState(false);

  const recorder = useAudioRecorder({
    maxDurationMs: referenceText.length > 4 ? 15000 : 8000,
  });

  const handleAssess = useCallback(async () => {
    if (!recorder.recordingUri) return;

    setIsAssessing(true);
    setAssessError(null);

    try {
      // Fetch audio file as blob
      const response = await fetch(recorder.recordingUri);
      const audioBlob = await response.blob();

      const clientAttemptId = `${exercise.id}_${Date.now()}_${attempts}`;

      const assessResult = await assessPronunciation({
        audio: audioBlob,
        audioUri: recorder.recordingUri,
        referenceText,
        locale: 'zh-CN',
        exerciseId: exercise.id,
        lessonId: exercise.lesson_id,
        clientAttemptId,
      });

      if (assessResult.success && assessResult.result) {
        setResult(assessResult.result);
        setAttempts(prev => prev + 1);

        // Save to database
        await savePronunciationAttempt(assessResult.result, {
          audio: audioBlob,
          referenceText,
          locale: 'zh-CN',
          exerciseId: exercise.id,
          lessonId: exercise.lesson_id,
          clientAttemptId,
        });
      } else {
        setAssessError(assessResult.error || 'Không thể chấm phát âm.');
      }
    } catch (err: any) {
      setAssessError('Lỗi kết nối. Vui lòng thử lại.');
    } finally {
      setIsAssessing(false);
    }
  }, [recorder.recordingUri, exercise, referenceText, attempts]);

  const handleContinue = () => {
    const passed = result ? result.overallScore >= passingScore : false;
    if (!answered) {
      setAnswered(true);
      onAnswer(
        result?.recognizedText || '',
        passed || attempts >= MAX_RETRIES
      );
    }
    onNext();
  };

  const handleRetry = () => {
    setResult(null);
    setAssessError(null);
    recorder.reset();
  };

  // Show result
  if (result) {
    const level = getScoreLevel(result.overallScore);
    const feedback = generateFeedback(result);
    const passed = result.overallScore >= passingScore;

    return (
      <View style={styles.container}>
        {/* Score */}
        <View style={styles.scoreSection}>
          <Text style={[styles.scoreNumber, { color: getScoreLevelColor(level, colors) }]}>
            {result.overallScore}
          </Text>
          <Text style={[styles.scoreMax, { color: colors.textTertiary }]}>/100</Text>
        </View>
        <Text style={[styles.scoreLabel, { color: getScoreLevelColor(level, colors) }]}>
          {getScoreLevelLabel(level)}
        </Text>

        {/* Word-level scores */}
        <View style={styles.wordsRow}>
          {result.words.map((w, i) => (
            <View key={i} style={styles.wordScore}>
              <Text style={[styles.wordChar, { color: w.accuracyScore >= 80 ? colors.success : w.accuracyScore >= 60 ? colors.warning : colors.error }]}>
                {w.word}
              </Text>
              <Text style={[styles.wordScoreNum, { color: colors.textSecondary }]}>
                {w.accuracyScore}
              </Text>
            </View>
          ))}
        </View>

        {/* Feedback */}
        {feedback.suggestions.length > 0 && (
          <View style={[styles.feedbackBox, { backgroundColor: colors.surfaceElevated }]}>
            {feedback.suggestions.map((s, i) => (
              <Text key={i} style={[styles.suggestion, { color: colors.textSecondary }]}>
                • {s}
              </Text>
            ))}
          </View>
        )}

        {/* Actions */}
        <View style={styles.actions}>
          <AudioPlayer uri={data?.audio_url} label="Nghe mẫu" size="sm" />
          <TouchableOpacity onPress={recorder.playRecording} style={styles.actionBtn}>
            <Ionicons name="play-circle-outline" size={18} color={colors.primary} />
            <Text style={[styles.actionText, { color: colors.primary }]}>Giọng của tôi</Text>
          </TouchableOpacity>
        </View>

        <View style={styles.buttonsRow}>
          {!passed && attempts < MAX_RETRIES && (
            <Button title="Thử lại" variant="outline" size="md" onPress={handleRetry} />
          )}
          <Button
            title={passed ? 'Tiếp tục' : attempts >= MAX_RETRIES ? 'Tiếp tục' : 'Bỏ qua'}
            variant="primary"
            size="lg"
            onPress={handleContinue}
            style={{ flex: 1 }}
          />
        </View>
      </View>
    );
  }

  // Recording interface
  return (
    <View style={styles.container}>
      <ChineseText characters={referenceText} pinyin={pinyin} translation={meaning} fontSize={40} />

      {data?.audio_url && (
        <View style={styles.listenSection}>
          <AudioPlayer uri={data.audio_url} label="Nghe mẫu" size="md" showSpeed />
        </View>
      )}

      {/* Recording area */}
      <View style={styles.recordArea}>
        {recorder.state === 'idle' || recorder.state === 'ready' ? (
          <TouchableOpacity
            style={[styles.recordBtn, { backgroundColor: colors.primary }]}
            onPress={recorder.startRecording}
            activeOpacity={0.7}
          >
            <Ionicons name="mic" size={28} color="#fff" />
            <Text style={styles.recordLabel}>Nhấn để đọc</Text>
          </TouchableOpacity>
        ) : recorder.state === 'recording' ? (
          <TouchableOpacity
            style={[styles.recordBtn, styles.recordingActive, { backgroundColor: colors.error }]}
            onPress={recorder.stopRecording}
            activeOpacity={0.7}
          >
            <Ionicons name="stop" size={28} color="#fff" />
            <Text style={styles.recordLabel}>
              Đang nghe... {Math.floor(recorder.durationMs / 1000)}s
            </Text>
          </TouchableOpacity>
        ) : recorder.state === 'recorded' ? (
          <View style={styles.recordedActions}>
            <TouchableOpacity
              style={[styles.smallBtn, { borderColor: colors.primary }]}
              onPress={recorder.playRecording}
            >
              <Ionicons name="play" size={16} color={colors.primary} />
              <Text style={[styles.smallBtnText, { color: colors.primary }]}>Nghe lại</Text>
            </TouchableOpacity>
            <TouchableOpacity
              style={[styles.smallBtn, { borderColor: colors.textSecondary }]}
              onPress={handleRetry}
            >
              <Ionicons name="refresh" size={16} color={colors.textSecondary} />
              <Text style={[styles.smallBtnText, { color: colors.textSecondary }]}>Thu lại</Text>
            </TouchableOpacity>
          </View>
        ) : null}

        {recorder.state === 'requesting_permission' && (
          <Text style={[styles.stateText, { color: colors.textSecondary }]}>Đang yêu cầu quyền micro...</Text>
        )}
      </View>

      {/* Assess button */}
      {recorder.state === 'recorded' && (
        <Button
          title={isAssessing ? 'Đang chấm...' : 'Chấm phát âm'}
          variant="primary"
          size="lg"
          fullWidth
          loading={isAssessing}
          onPress={handleAssess}
        />
      )}

      {/* Error */}
      {(recorder.error || assessError) && (
        <Text style={[styles.errorText, { color: colors.error }]}>
          {recorder.error || assessError}
        </Text>
      )}

      {/* Permission denied guidance */}
      {recorder.permissionDenied && (
        <Text style={[styles.permHint, { color: colors.textSecondary }]}>
          Vào Cài đặt → Mandarin Master → Bật Microphone
        </Text>
      )}
    </View>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, justifyContent: 'center', alignItems: 'center', gap: Spacing.xl },
  listenSection: { marginTop: Spacing.lg },
  recordArea: { alignItems: 'center', gap: Spacing.md },
  recordBtn: { width: 88, height: 88, borderRadius: 44, justifyContent: 'center', alignItems: 'center', gap: Spacing.xs, ...Shadow.md },
  recordingActive: { transform: [{ scale: 1.05 }] },
  recordIcon: { fontSize: 28 },
  recordLabel: { color: '#fff', fontSize: FontSize.xs, fontWeight: FontWeight.semibold },
  recordedActions: { flexDirection: 'row', gap: Spacing.md },
  smallBtn: { flexDirection: 'row', alignItems: 'center', gap: Spacing.xs, paddingHorizontal: Spacing.lg, paddingVertical: Spacing.sm + 2, borderRadius: BorderRadius.lg, borderWidth: 1.5 },
  smallBtnText: { fontSize: FontSize.sm, fontWeight: FontWeight.semibold },
  stateText: { fontSize: FontSize.md },
  errorText: { fontSize: FontSize.sm, textAlign: 'center', paddingHorizontal: Spacing.xl },
  permHint: { fontSize: FontSize.sm, textAlign: 'center' },
  scoreSection: { flexDirection: 'row', alignItems: 'baseline' },
  scoreNumber: { fontSize: 56, fontWeight: 'bold' },
  scoreMax: { fontSize: FontSize.xl },
  scoreLabel: { fontSize: FontSize.lg, fontWeight: '600' },
  wordsRow: { flexDirection: 'row', flexWrap: 'wrap', gap: Spacing.lg, justifyContent: 'center' },
  wordScore: { alignItems: 'center', gap: 2 },
  wordChar: { fontSize: FontSize['2xl'], fontWeight: '600' },
  wordScoreNum: { fontSize: FontSize.xs },
  feedbackBox: { borderRadius: BorderRadius.lg, padding: Spacing.lg, width: '100%', gap: Spacing.xs },
  suggestion: { fontSize: FontSize.sm },
  actions: { flexDirection: 'row', gap: Spacing.xl, alignItems: 'center' },
  actionBtn: { flexDirection: 'row', alignItems: 'center', gap: Spacing.xs },
  actionText: { fontSize: FontSize.sm, fontWeight: FontWeight.medium },
  buttonsRow: { flexDirection: 'row', gap: Spacing.md, width: '100%' },
});
