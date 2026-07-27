import React, { useState, useEffect, useRef } from 'react';
import {
  View,
  Text,
  StyleSheet,
  TouchableOpacity,
  SafeAreaView,
  ActivityIndicator,
  TextInput,
} from 'react-native';
import { Ionicons } from '@expo/vector-icons';
import { useLocalSearchParams, router } from 'expo-router';
import { useThemeStore } from '@/stores/theme-store';
import { useAuthStore } from '@/stores/auth-store';
import { ProgressBar, Button, Card } from '@/components/ui';
import { ChineseText } from '@/components/chinese';
import { AudioPlayer } from '@/components/media';
import { FontSize, Spacing, BorderRadius } from '@/constants/theme';
import {
  LessonExercise,
  fetchLessonExercises,
  validateAnswer,
  calculateLessonResult,
  submitLessonCompletion,
} from '@/services/lesson-engine';
import { ExerciseResult, LessonResult } from '@/types';
import { SpeakingExercise } from '@/components/exercise';

export default function LessonScreen() {
  const { id } = useLocalSearchParams<{ id: string }>();
  const { colors } = useThemeStore();
  const { fetchProfile } = useAuthStore();
  const [exercises, setExercises] = useState<LessonExercise[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');
  const [currentIndex, setCurrentIndex] = useState(0);
  const [results, setResults] = useState<ExerciseResult[]>([]);
  const [lessonResult, setLessonResult] = useState<LessonResult | null>(null);
  const startTime = useRef(Date.now());
  const exerciseStartTime = useRef(Date.now());

  useEffect(() => {
    if (!id) return;
    loadExercises();
  }, [id]);

  const loadExercises = async () => {
    try {
      const data = await fetchLessonExercises(id!);
      if (data.length === 0) {
        setError('Bài học này chưa có bài tập');
        return;
      }
      setExercises(data);
      exerciseStartTime.current = Date.now();
    } catch (err: any) {
      setError(err.message || 'Không thể tải bài học');
    } finally {
      setLoading(false);
    }
  };

  const handleAnswer = (userAnswer: string, isCorrect: boolean) => {
    const timeSpent = Math.round((Date.now() - exerciseStartTime.current) / 1000);
    const result: ExerciseResult = {
      exercise_id: exercises[currentIndex].id,
      is_correct: isCorrect,
      user_answer: userAnswer,
      time_spent_seconds: timeSpent,
    };

    setResults(prev => [...prev, result]);
  };

  const handleNext = () => {
    if (currentIndex < exercises.length - 1) {
      setCurrentIndex(prev => prev + 1);
      exerciseStartTime.current = Date.now();
    } else {
      finishLesson();
    }
  };

  const finishLesson = async () => {
    const xpReward = 15; // Default, should come from lesson data
    const result = calculateLessonResult(id!, exercises, results, xpReward);
    setLessonResult(result);

    // Submit to server
    await submitLessonCompletion(result);
    await fetchProfile(); // Refresh XP/level
  };

  if (loading) {
    return (
      <SafeAreaView style={[styles.container, { backgroundColor: colors.background }]}>
        <View style={styles.center}>
          <ActivityIndicator size="large" color={colors.primary} />
          <Text style={[styles.loadingText, { color: colors.textSecondary }]}>
            Đang tải bài học...
          </Text>
        </View>
      </SafeAreaView>
    );
  }

  if (error) {
    return (
      <SafeAreaView style={[styles.container, { backgroundColor: colors.background }]}>
        <View style={styles.center}>
          <View style={[styles.errorIconWrap, { backgroundColor: colors.errorLight }]}>
            <Ionicons name="alert-circle" size={32} color={colors.error} />
          </View>
          <Text style={[styles.errorText, { color: colors.text }]}>{error}</Text>
          <Button title="Quay lại" variant="primary" size="lg" onPress={() => router.back()} />
        </View>
      </SafeAreaView>
    );
  }

  if (lessonResult) {
    return (
      <SafeAreaView style={[styles.container, { backgroundColor: colors.background }]}>
        <View style={styles.resultContainer}>
          <View style={[styles.resultBadge, { backgroundColor: lessonResult.perfect ? colors.secondary + '15' : colors.successLight }]}>
            <Text style={styles.resultBadgeIcon}>
              {lessonResult.perfect ? '🏆' : lessonResult.accuracy >= 80 ? '🎉' : '👍'}
            </Text>
          </View>
          <Text style={[styles.resultTitle, { color: colors.text }]}>
            {lessonResult.perfect ? 'Hoàn hảo!' : 'Bài học hoàn thành!'}
          </Text>
          <Text style={[styles.resultScore, { color: colors.text }]}>
            {lessonResult.correct_answers}/{lessonResult.total_exercises} câu đúng
          </Text>
          <View style={[styles.resultStats, { backgroundColor: colors.surfaceElevated }]}>
            <View style={styles.resultStatItem}>
              <Text style={[styles.resultStatValue, { color: colors.primary }]}>{Math.round(lessonResult.accuracy)}%</Text>
              <Text style={[styles.resultStatLabel, { color: colors.textSecondary }]}>Độ chính xác</Text>
            </View>
            <View style={[styles.resultStatDivider, { backgroundColor: colors.border }]} />
            <View style={styles.resultStatItem}>
              <Text style={[styles.resultStatValue, { color: colors.xp }]}>+{lessonResult.xp_earned}</Text>
              <Text style={[styles.resultStatLabel, { color: colors.textSecondary }]}>XP earned</Text>
            </View>
          </View>
          {lessonResult.perfect && (
            <Text style={[styles.perfectBonus, { color: colors.secondary }]}>
              Perfect Lesson Bonus!
            </Text>
          )}
          <Button
            title="Tiếp tục"
            variant="primary"
            size="lg"
            fullWidth
            rounded
            onPress={() => router.back()}
            style={{ marginTop: Spacing['2xl'] }}
          />
        </View>
      </SafeAreaView>
    );
  }

  const exercise = exercises[currentIndex];
  const progress = ((currentIndex + 1) / exercises.length) * 100;
  const correctCount = results.filter(r => r.is_correct).length;

  return (
    <SafeAreaView style={[styles.container, { backgroundColor: colors.background }]}>
      {/* Header */}
      <View style={styles.header}>
        <TouchableOpacity onPress={() => router.back()} style={[styles.closeBtn, { backgroundColor: colors.surfaceElevated }]}>
          <Ionicons name="close" size={20} color={colors.textSecondary} />
        </TouchableOpacity>
        <View style={styles.progressWrapper}>
          <ProgressBar progress={progress} height={6} color={colors.primary} animated />
        </View>
        <View style={[styles.scorePill, { backgroundColor: colors.xpLight }]}>
          <Ionicons name="flash" size={14} color={colors.xp} />
          <Text style={[styles.scoreText, { color: colors.xp }]}>
            {correctCount}
          </Text>
        </View>
      </View>

      {/* Exercise Content - render based on type */}
      <View style={styles.exerciseArea}>
        <ExerciseRenderer
          exercise={exercise}
          colors={colors}
          onAnswer={handleAnswer}
          onNext={handleNext}
        />
      </View>
    </SafeAreaView>
  );
}

/**
 * Exercise Renderer - dispatches to appropriate component based on type
 * This architecture allows adding new exercise types as plugins
 */
function ExerciseRenderer({
  exercise,
  colors,
  onAnswer,
  onNext,
}: {
  exercise: LessonExercise;
  colors: any;
  onAnswer: (answer: string, isCorrect: boolean) => void;
  onNext: () => void;
}) {
  switch (exercise.exercise_type) {
    case 'vocabulary':
      return <VocabularyExercise exercise={exercise} colors={colors} onNext={() => { onAnswer('viewed', true); onNext(); }} />;
    case 'multiple_choice':
      return <MultipleChoiceExercise exercise={exercise} colors={colors} onAnswer={onAnswer} onNext={onNext} />;
    case 'listening':
      return <ListeningExercise exercise={exercise} colors={colors} onAnswer={onAnswer} onNext={onNext} />;
    case 'translation':
      return <TranslationExercise exercise={exercise} colors={colors} onAnswer={onAnswer} onNext={onNext} />;
    case 'sentence_builder':
      return <SentenceBuilderExercise exercise={exercise} colors={colors} onAnswer={onAnswer} onNext={onNext} />;
    case 'speaking':
      return <SpeakingExercise exercise={exercise} colors={colors} onAnswer={onAnswer} onNext={onNext} />;
    default:
      return <VocabularyExercise exercise={exercise} colors={colors} onNext={() => { onAnswer('viewed', true); onNext(); }} />;
  }
}

function VocabularyExercise({ exercise, colors, onNext }: { exercise: LessonExercise; colors: any; onNext: () => void }) {
  const data = exercise.data as any;
  return (
    <View style={styles.vocabContainer}>
      <ChineseText
        characters={data?.chinese || exercise.correct_answer}
        pinyin={data?.pinyin}
        translation={data?.meaning}
        fontSize={56}
      />
      {exercise.explanation && (
        <Text style={[styles.explanation, { color: colors.textSecondary }]}>
          {exercise.explanation}
        </Text>
      )}
      <Button
        title="Tiếp tục"
        variant="primary"
        size="lg"
        fullWidth
        onPress={onNext}
        style={{ marginTop: Spacing['3xl'] }}
      />
    </View>
  );
}

function MultipleChoiceExercise({ exercise, colors, onAnswer, onNext }: { exercise: LessonExercise; colors: any; onAnswer: (a: string, c: boolean) => void; onNext: () => void }) {
  const [selected, setSelected] = useState<number | null>(null);
  const [answered, setAnswered] = useState(false);
  const options = exercise.exercise_options ?? [];

  const handleSelect = (index: number) => {
    if (answered) return;
    setSelected(index);
    setAnswered(true);

    const selectedText = options[index]?.text ?? '';
    const isCorrect = validateAnswer(exercise, selectedText);
    onAnswer(selectedText, isCorrect);
  };

  return (
    <View style={styles.mcContainer}>
      <Text style={[styles.mcQuestion, { color: colors.text }]}>
        {exercise.question}
      </Text>
      <View style={styles.mcOptions}>
        {options.map((opt, i) => {
          let bgColor = colors.surface;
          let borderColor = colors.border;
          if (answered && opt.is_correct) {
            bgColor = colors.successLight;
            borderColor = colors.success;
          } else if (answered && i === selected && !opt.is_correct) {
            bgColor = colors.errorLight;
            borderColor = colors.error;
          }
          return (
            <TouchableOpacity
              key={opt.id}
              style={[styles.mcOption, { backgroundColor: bgColor, borderColor }]}
              onPress={() => handleSelect(i)}
              disabled={answered}
            >
              <Text style={[styles.mcOptionText, { color: colors.text }]}>{opt.text}</Text>
            </TouchableOpacity>
          );
        })}
      </View>
      {answered && (
        <View style={[styles.feedbackArea, { backgroundColor: options[selected!]?.is_correct ? colors.successLight : colors.errorLight }]}>
          <Text style={[styles.feedbackText, { color: options[selected!]?.is_correct ? colors.success : colors.error }]}>
            {options[selected!]?.is_correct ? 'Chính xác!' : 'Chưa đúng'}
          </Text>
          {exercise.explanation && !options[selected!]?.is_correct && (
            <Text style={[styles.explanation, { color: colors.textSecondary }]}>{exercise.explanation}</Text>
          )}
          <Button title="Tiếp tục" variant="primary" size="lg" fullWidth onPress={onNext} style={{ marginTop: Spacing.md }} />
        </View>
      )}
    </View>
  );
}

function ListeningExercise({ exercise, colors, onAnswer, onNext }: { exercise: LessonExercise; colors: any; onAnswer: (a: string, c: boolean) => void; onNext: () => void }) {
  const [selected, setSelected] = useState<number | null>(null);
  const [answered, setAnswered] = useState(false);
  const options = exercise.exercise_options ?? [];
  const data = exercise.data as any;

  const handleSelect = (index: number) => {
    if (answered) return;
    setSelected(index);
    setAnswered(true);
    const selectedText = options[index]?.text ?? '';
    const isCorrect = validateAnswer(exercise, selectedText);
    onAnswer(selectedText, isCorrect);
  };

  return (
    <View style={styles.mcContainer}>
      <Text style={[styles.mcQuestion, { color: colors.text }]}>{exercise.question}</Text>
      <View style={{ alignItems: 'center', marginBottom: Spacing.xl }}>
        <AudioPlayer uri={exercise.question_audio_url} size="lg" showSpeed label="Nghe" />
      </View>
      <View style={styles.mcOptions}>
        {options.map((opt, i) => {
          let bgColor = colors.surface;
          let borderColor = colors.border;
          if (answered && opt.is_correct) { bgColor = colors.successLight; borderColor = colors.success; }
          else if (answered && i === selected && !opt.is_correct) { bgColor = colors.errorLight; borderColor = colors.error; }
          return (
            <TouchableOpacity key={opt.id} style={[styles.mcOption, { backgroundColor: bgColor, borderColor }]} onPress={() => handleSelect(i)} disabled={answered}>
              <Text style={[styles.mcOptionText, { color: colors.text }]}>{opt.text}</Text>
            </TouchableOpacity>
          );
        })}
      </View>
      {answered && (
        <View style={styles.feedbackArea}>
          <Button title="Tiếp tục" variant="primary" size="md" fullWidth onPress={onNext} />
        </View>
      )}
    </View>
  );
}

function TranslationExercise({ exercise, colors, onAnswer, onNext }: { exercise: LessonExercise; colors: any; onAnswer: (a: string, c: boolean) => void; onNext: () => void }) {
  const [input, setInput] = useState('');
  const [answered, setAnswered] = useState(false);
  const [isCorrect, setIsCorrect] = useState(false);

  const handleSubmit = () => {
    if (!input.trim() || answered) return;
    setAnswered(true);
    const correct = validateAnswer(exercise, input);
    setIsCorrect(correct);
    onAnswer(input, correct);
  };

  return (
    <View style={styles.transContainer}>
      <Text style={[styles.mcQuestion, { color: colors.text }]}>{exercise.question}</Text>
      <TextInput
        style={[styles.textInput, { color: colors.text, borderColor: answered ? (isCorrect ? colors.success : colors.error) : colors.border, backgroundColor: colors.surface }]}
        placeholder="Nhập câu trả lời..."
        placeholderTextColor={colors.textTertiary}
        value={input}
        onChangeText={setInput}
        editable={!answered}
        autoCorrect={false}
      />
      {answered && (
        <View style={[styles.feedbackArea, { backgroundColor: isCorrect ? colors.successLight : colors.errorLight }]}>
          <Text style={[styles.feedbackText, { color: isCorrect ? colors.success : colors.error }]}>
            {isCorrect ? 'Chính xác!' : 'Chưa đúng'}
          </Text>
          {!isCorrect && (
            <Text style={[styles.correctAnswer, { color: colors.text }]}>
              Đáp án: {exercise.correct_answer}
            </Text>
          )}
          <Button title="Tiếp tục" variant="primary" size="lg" fullWidth onPress={onNext} style={{ marginTop: Spacing.md }} />
        </View>
      )}
      {!answered && (
        <Button title="Kiểm tra" variant="primary" size="lg" fullWidth disabled={!input.trim()} onPress={handleSubmit} style={{ marginTop: Spacing.lg }} />
      )}
    </View>
  );
}

function SentenceBuilderExercise({ exercise, colors, onAnswer, onNext }: { exercise: LessonExercise; colors: any; onAnswer: (a: string, c: boolean) => void; onNext: () => void }) {
  const data = exercise.data as any;
  const words: string[] = data?.words ?? exercise.correct_answer.split('');
  const [selected, setSelected] = useState<number[]>([]);
  const [answered, setAnswered] = useState(false);
  const [isCorrect, setIsCorrect] = useState(false);

  const selectedWords = selected.map(i => words[i]);
  const remainingIndices = words.map((_, i) => i).filter(i => !selected.includes(i));

  const handleTapWord = (index: number) => {
    if (answered) return;
    setSelected([...selected, index]);
  };

  const handleRemoveWord = (position: number) => {
    if (answered) return;
    setSelected(selected.filter((_, i) => i !== position));
  };

  const handleCheck = () => {
    const answer = selectedWords.join('');
    const correct = validateAnswer(exercise, answer);
    setIsCorrect(correct);
    setAnswered(true);
    onAnswer(answer, correct);
  };

  return (
    <View style={styles.transContainer}>
      <Text style={[styles.mcQuestion, { color: colors.text }]}>{exercise.question}</Text>

      {/* Answer area */}
      <View style={[styles.sentenceArea, { borderColor: colors.border, backgroundColor: colors.surface }]}>
        {selectedWords.length === 0 ? (
          <Text style={[styles.placeholder, { color: colors.textTertiary }]}>Nhấn vào từ để xếp câu</Text>
        ) : (
          <View style={styles.wordRow}>
            {selectedWords.map((w, i) => (
              <TouchableOpacity key={i} onPress={() => handleRemoveWord(i)} style={[styles.wordChip, { backgroundColor: colors.primary + '20', borderColor: colors.primary }]}>
                <Text style={[styles.wordText, { color: colors.primary }]}>{w}</Text>
              </TouchableOpacity>
            ))}
          </View>
        )}
      </View>

      {/* Available words */}
      <View style={styles.wordRow}>
        {remainingIndices.map(i => (
          <TouchableOpacity key={i} onPress={() => handleTapWord(i)} style={[styles.wordChip, { backgroundColor: colors.surfaceElevated, borderColor: colors.border }]} disabled={answered}>
            <Text style={[styles.wordText, { color: colors.text }]}>{words[i]}</Text>
          </TouchableOpacity>
        ))}
      </View>

      {answered ? (
        <View style={[styles.feedbackArea, { backgroundColor: isCorrect ? colors.successLight : colors.errorLight }]}>
          <Text style={[styles.feedbackText, { color: isCorrect ? colors.success : colors.error }]}>
            {isCorrect ? 'Chính xác!' : 'Chưa đúng'}
          </Text>
          {!isCorrect && <Text style={[styles.correctAnswer, { color: colors.text }]}>Đáp án: {exercise.correct_answer}</Text>}
          <Button title="Tiếp tục" variant="primary" size="lg" fullWidth onPress={onNext} style={{ marginTop: Spacing.md }} />
        </View>
      ) : (
        <Button title="Kiểm tra" variant="primary" size="lg" fullWidth disabled={selected.length === 0} onPress={handleCheck} style={{ marginTop: Spacing.lg }} />
      )}
    </View>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1 },
  center: { flex: 1, justifyContent: 'center', alignItems: 'center', paddingHorizontal: Spacing['2xl'] },
  loadingText: { marginTop: Spacing.lg, fontSize: FontSize.base },
  errorIconWrap: { width: 64, height: 64, borderRadius: 32, justifyContent: 'center', alignItems: 'center', marginBottom: Spacing.lg },
  errorText: { fontSize: FontSize.lg, marginBottom: Spacing.xl, textAlign: 'center' },
  header: { flexDirection: 'row', alignItems: 'center', paddingHorizontal: Spacing.xl, paddingVertical: Spacing.sm, gap: Spacing.md },
  closeBtn: { width: 36, height: 36, borderRadius: 18, justifyContent: 'center', alignItems: 'center' },
  progressWrapper: { flex: 1 },
  scorePill: { flexDirection: 'row', alignItems: 'center', gap: 3, paddingHorizontal: Spacing.sm + 2, paddingVertical: Spacing.xs, borderRadius: BorderRadius.full },
  scoreText: { fontSize: FontSize.sm, fontWeight: '700' },
  exerciseArea: { flex: 1, paddingHorizontal: Spacing.xl, justifyContent: 'center' },
  vocabContainer: { alignItems: 'center' },
  explanation: { fontSize: FontSize.md, textAlign: 'center', marginTop: Spacing.md },
  mcContainer: { flex: 1, justifyContent: 'center' },
  mcQuestion: { fontSize: FontSize.xl, fontWeight: '600', textAlign: 'center', marginBottom: Spacing['2xl'], lineHeight: 28 },
  mcOptions: { gap: Spacing.md },
  mcOption: { paddingVertical: Spacing.lg, paddingHorizontal: Spacing.xl, borderRadius: BorderRadius.lg, borderWidth: 1.5 },
  mcOptionText: { fontSize: FontSize.base, fontWeight: '500', textAlign: 'center' },
  feedbackArea: { marginTop: Spacing.xl, padding: Spacing.lg, borderRadius: BorderRadius.xl, alignItems: 'center' },
  feedbackText: { fontSize: FontSize.base, fontWeight: '700', marginBottom: Spacing.xs },
  correctAnswer: { fontSize: FontSize.base, marginTop: Spacing.sm },
  transContainer: { flex: 1, justifyContent: 'center' },
  textInput: { borderWidth: 1.5, borderRadius: BorderRadius.lg, paddingHorizontal: Spacing.lg, paddingVertical: Spacing.md, fontSize: FontSize.lg, minHeight: 50 },
  sentenceArea: { borderWidth: 1.5, borderRadius: BorderRadius.lg, padding: Spacing.lg, minHeight: 60, marginBottom: Spacing.xl, justifyContent: 'center' },
  placeholder: { fontSize: FontSize.md, textAlign: 'center' },
  wordRow: { flexDirection: 'row', flexWrap: 'wrap', gap: Spacing.sm, justifyContent: 'center' },
  wordChip: { paddingHorizontal: Spacing.md, paddingVertical: Spacing.sm, borderRadius: BorderRadius.md, borderWidth: 1 },
  wordText: { fontSize: FontSize.base, fontWeight: '500' },
  resultContainer: { flex: 1, justifyContent: 'center', alignItems: 'center', paddingHorizontal: Spacing['2xl'] },
  resultBadge: { width: 80, height: 80, borderRadius: 40, justifyContent: 'center', alignItems: 'center', marginBottom: Spacing.xl },
  resultBadgeIcon: { fontSize: 40 },
  resultTitle: { fontSize: FontSize['2xl'], fontWeight: 'bold', marginBottom: Spacing.sm },
  resultScore: { fontSize: FontSize.lg, fontWeight: '600', marginBottom: Spacing.xl },
  resultStats: { flexDirection: 'row', borderRadius: BorderRadius.xl, paddingVertical: Spacing.lg, paddingHorizontal: Spacing.xl, gap: Spacing.xl, marginBottom: Spacing.lg },
  resultStatItem: { flex: 1, alignItems: 'center', gap: 4 },
  resultStatValue: { fontSize: FontSize.xl, fontWeight: 'bold' },
  resultStatLabel: { fontSize: FontSize.xs },
  resultStatDivider: { width: 1 },
  resultAccuracy: { fontSize: FontSize.base, marginBottom: Spacing.sm },
  resultXp: { fontSize: FontSize.lg, fontWeight: '700' },
  perfectBonus: { fontSize: FontSize.md, fontWeight: '600', marginTop: Spacing.sm },
});
