import React, { useState, useCallback, useEffect, useRef } from 'react';
import { Animated, ScrollView, View, Text, StyleSheet, TouchableOpacity } from 'react-native';
import { Ionicons } from '@expo/vector-icons';
import { useThemeStore } from '@/stores/theme-store';
import { Button } from '@/components/ui';
import { ChineseText } from '@/components/chinese';
import { AudioPlayer } from '@/components/media';
import { ScoreRing } from '@/components/lesson';
import { useAudioRecorder } from '@/hooks/useAudioRecorder';
import { assessPronunciation } from '@/services/pronunciation-service';
import { generateFeedback } from '@/services/pronunciation-feedback';
import { PronunciationAssessmentResult, getScoreLevel, getScoreLevelLabel, getScoreLevelColor } from '@/lib/speech';
import { LessonExercise } from '@/services/lesson-engine';
import { FontFamily, FontSize, Spacing, BorderRadius, Shadow, FontWeight } from '@/constants/theme';
import * as Crypto from 'expo-crypto';

export interface SpeakingPracticeTarget {
  text: string;
  pinyin?: string;
  meaning?: string;
  audioUrl?: string | null;
  passingScore?: number;
  vocabularyId: string;
}

interface SpeakingExerciseProps {
  exercise?: LessonExercise;
  practiceTarget?: SpeakingPracticeTarget;
  colors: any;
  onAnswer: (answer: string, isCorrect: boolean) => void;
  onAssessmentComplete?: (result: PronunciationAssessmentResult) => void;
  onNext: () => void;
}

const MAX_RETRIES = 3;

export function SpeakingExercise({
  exercise,
  practiceTarget,
  colors,
  onAnswer,
  onAssessmentComplete,
  onNext,
}: SpeakingExerciseProps) {
  if (!exercise && !practiceTarget) {
    throw new Error('SpeakingExercise requires an exercise or practice target.');
  }

  const data = exercise?.data as any;
  const referenceText = practiceTarget?.text || data?.text || exercise?.correct_answer || '';
  const pinyin = practiceTarget?.pinyin || data?.pinyin || '';
  const meaning = practiceTarget?.meaning || data?.meaning || '';
  const audioUrl = practiceTarget?.audioUrl ?? data?.audio_url ?? exercise?.question_audio_url ?? null;
  const passingScore = practiceTarget?.passingScore || data?.passing_score || 60;
  const assessmentIds = practiceTarget
    ? { vocabularyId: practiceTarget.vocabularyId }
    : { exerciseId: exercise?.id, lessonId: exercise?.lesson_id };

  const [result, setResult] = useState<PronunciationAssessmentResult | null>(null);
  const [isAssessing, setIsAssessing] = useState(false);
  const [assessError, setAssessError] = useState<string | null>(null);
  const [attempts, setAttempts] = useState(0);
  const [answered, setAnswered] = useState(false);

  const recorder = useAudioRecorder({
    maxDurationMs: referenceText.length > 4 ? 15000 : 8000,
  });
  const clientAttemptIdRef = useRef(Crypto.randomUUID());
  const pulse = useRef(new Animated.Value(0)).current;

  useEffect(() => {
    if (recorder.state !== 'recording') {
      pulse.stopAnimation();
      pulse.setValue(0);
      return;
    }

    const animation = Animated.loop(
      Animated.sequence([
        Animated.timing(pulse, {
          toValue: 1,
          duration: 900,
          useNativeDriver: true,
        }),
        Animated.timing(pulse, {
          toValue: 0,
          duration: 900,
          useNativeDriver: true,
        }),
      ]),
    );
    animation.start();
    return () => animation.stop();
  }, [pulse, recorder.state]);

  const handleAssess = useCallback(async () => {
    if (!recorder.recordingUri) return;

    setIsAssessing(true);
    setAssessError(null);

    try {
      // Fetch audio file as blob
      const response = await fetch(recorder.recordingUri);
      const audioBlob = await response.blob();

      const assessResult = await assessPronunciation({
        audio: audioBlob,
        audioUri: recorder.recordingUri,
        referenceText,
        pinyin,
        locale: 'zh-CN',
        ...assessmentIds,
        clientAttemptId: clientAttemptIdRef.current,
      });

      if (assessResult.success && assessResult.result) {
        setResult(assessResult.result);
        setAttempts(prev => prev + 1);
        onAssessmentComplete?.(assessResult.result);
      } else {
        setAssessError(assessResult.error || 'Không thể chấm phát âm.');
      }
    } catch (err: any) {
      setAssessError('Lỗi kết nối. Vui lòng thử lại.');
    } finally {
      setIsAssessing(false);
    }
  }, [
    recorder.recordingUri,
    referenceText,
    pinyin,
    assessmentIds.exerciseId,
    assessmentIds.lessonId,
    assessmentIds.vocabularyId,
    onAssessmentComplete,
  ]);

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
    clientAttemptIdRef.current = Crypto.randomUUID();
    recorder.reset();
  };

  // Show result
  if (result) {
    const level = getScoreLevel(result.overallScore);
    const feedback = generateFeedback(result);
    const passed = result.overallScore >= passingScore;

    return (
      <ScrollView contentContainerStyle={styles.scrollContent} showsVerticalScrollIndicator={false}>
      <View style={styles.container}>
        <View style={[styles.typePill, { backgroundColor: colors.surfaceElevated, borderColor: colors.border }]}>
          <Ionicons name="mic" size={18} color={colors.primary} />
          <Text style={[styles.typeLabel, { color: colors.textSecondary }]}>Kết quả phát âm</Text>
        </View>
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
        <View style={styles.scoreGrid}>
          <ScoreRing value={result.accuracyScore} label="Phát âm" color={colors.jade} trackColor={colors.border} />
          <ScoreRing value={result.completenessScore ?? result.overallScore} label="Hoàn chỉnh" color={colors.primary} trackColor={colors.border} />
          <ScoreRing value={result.fluencyScore} label="Độ trôi chảy" color={colors.jade} trackColor={colors.border} />
        </View>

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
          {audioUrl ? <AudioPlayer uri={audioUrl} label="Nghe mẫu" size="sm" /> : null}
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
      </ScrollView>
    );
  }

  // Recording interface
  return (
    <ScrollView contentContainerStyle={styles.scrollContent} showsVerticalScrollIndicator={false}>
    <View style={styles.container}>
      <View style={[styles.typePill, { backgroundColor: colors.surfaceElevated, borderColor: colors.border }]}>
        <Ionicons name="people" size={18} color={colors.primary} />
        <Text style={[styles.typeLabel, { color: colors.textSecondary }]}>Luyện phát âm</Text>
      </View>
      <View style={[styles.targetCard, { backgroundColor: colors.card, borderColor: colors.border }]}>
        <View style={[styles.targetAccent, { backgroundColor: colors.primary }]} />
        <ChineseText characters={referenceText} pinyin={pinyin} translation={meaning} fontSize={56} />
        {audioUrl && (
          <View style={styles.listenSection}>
            <AudioPlayer uri={audioUrl} label="Nghe mẫu" size="md" showSpeed />
          </View>
        )}
      </View>

      {/* Recording area */}
      <View style={styles.recordArea}>
        <View style={[styles.recordRing, { borderColor: recorder.state === 'recording' ? colors.primaryLight : `${colors.primary}33` }]}>
        {recorder.state === 'recording' ? (
          <Animated.View
            pointerEvents="none"
            style={[
              styles.pulseHalo,
              {
                borderColor: colors.primary,
                opacity: pulse.interpolate({ inputRange: [0, 1], outputRange: [0.5, 0] }),
                transform: [
                  {
                    scale: pulse.interpolate({ inputRange: [0, 1], outputRange: [0.78, 1.2] }),
                  },
                ],
              },
            ]}
          />
        ) : null}
        {recorder.state === 'idle' || recorder.state === 'ready' ? (
          <TouchableOpacity
            style={[styles.recordBtn, { backgroundColor: colors.primary }]}
            onPress={recorder.startRecording}
            activeOpacity={0.7}
          >
            <Ionicons name="mic" size={44} color="#fff" />
          </TouchableOpacity>
        ) : recorder.state === 'recording' ? (
          <TouchableOpacity
            style={[styles.recordBtn, styles.recordingActive, { backgroundColor: colors.primary }]}
            onPress={recorder.stopRecording}
            activeOpacity={0.7}
          >
            <Ionicons name="stop" size={42} color="#fff" />
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
        </View>

        {recorder.state === 'requesting_permission' && (
          <Text style={[styles.stateText, { color: colors.textSecondary }]}>Đang yêu cầu quyền micro...</Text>
        )}
        <Text style={[styles.recordState, { color: colors.primary }]}>
          {recorder.state === 'recording'
            ? `Đang nghe... ${Math.floor(recorder.durationMs / 1000)}s`
            : recorder.state === 'recorded'
              ? 'Bản thu đã sẵn sàng'
              : 'Nhấn để đọc'}
        </Text>
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
    </ScrollView>
  );
}

const styles = StyleSheet.create({
  scrollContent: { flexGrow: 1, paddingHorizontal: Spacing.xl, paddingVertical: Spacing.xl },
  container: { width: '100%', maxWidth: 680, alignSelf: 'center', alignItems: 'center', gap: Spacing.xl },
  typePill: { flexDirection: 'row', alignItems: 'center', gap: Spacing.sm, paddingHorizontal: Spacing.lg, paddingVertical: Spacing.sm, borderRadius: BorderRadius.full, borderWidth: 1, ...Shadow.sm },
  typeLabel: { fontFamily: FontFamily.semibold, fontSize: FontSize.sm },
  targetCard: { width: '100%', borderWidth: 1, borderRadius: BorderRadius.xl, padding: Spacing.xl, alignItems: 'center', overflow: 'hidden', ...Shadow.md },
  targetAccent: { position: 'absolute', top: 0, left: 0, right: 0, height: 4 },
  listenSection: { marginTop: Spacing.lg },
  recordArea: { alignItems: 'center', gap: Spacing.md },
  recordRing: { width: 176, height: 176, borderRadius: 88, borderWidth: 4, alignItems: 'center', justifyContent: 'center' },
  pulseHalo: { position: 'absolute', width: 176, height: 176, borderRadius: 88, borderWidth: 4 },
  recordBtn: { width: 112, height: 112, borderRadius: 56, justifyContent: 'center', alignItems: 'center', ...Shadow.lg },
  recordingActive: { transform: [{ scale: 1.06 }] },
  recordState: { fontFamily: FontFamily.semibold, fontSize: FontSize.sm, textTransform: 'uppercase', letterSpacing: 0.8 },
  recordedActions: { flexDirection: 'column', gap: Spacing.sm },
  smallBtn: { flexDirection: 'row', alignItems: 'center', gap: Spacing.xs, paddingHorizontal: Spacing.lg, paddingVertical: Spacing.sm + 2, borderRadius: BorderRadius.lg, borderWidth: 1.5 },
  smallBtnText: { fontSize: FontSize.sm, fontWeight: FontWeight.semibold },
  stateText: { fontSize: FontSize.md },
  errorText: { fontSize: FontSize.sm, textAlign: 'center', paddingHorizontal: Spacing.xl },
  permHint: { fontSize: FontSize.sm, textAlign: 'center' },
  scoreSection: { flexDirection: 'row', alignItems: 'baseline' },
  scoreNumber: { fontSize: 56, fontWeight: 'bold' },
  scoreMax: { fontSize: FontSize.xl },
  scoreLabel: { fontSize: FontSize.lg, fontWeight: '600' },
  scoreGrid: { width: '100%', flexDirection: 'row', gap: Spacing.md },
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
