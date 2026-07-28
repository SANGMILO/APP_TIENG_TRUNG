import React, { useEffect, useRef, useState } from 'react';
import {
  ActivityIndicator,
  KeyboardAvoidingView,
  Platform,
  ScrollView,
  StyleSheet,
  Text,
  TextInput,
  TouchableOpacity,
  View,
} from 'react-native';
import { Ionicons } from '@expo/vector-icons';
import { router, useLocalSearchParams } from 'expo-router';
import { SafeAreaView } from 'react-native-safe-area-context';
import { AudioPlayer } from '@/components/media';
import { SpeakingExercise } from '@/components/exercise';
import { Button, FadeInView, ProgressBar } from '@/components/ui';
import {
  LessonActionBar,
  LessonFeedbackPanel,
  LessonOptionCard,
  LessonOptionState,
  LessonQuestionCard,
  LessonStatCard,
} from '@/components/lesson';
import {
  LessonExercise,
  calculateLessonResult,
  fetchLessonExercises,
  fetchLessonXpReward,
  submitLessonCompletion,
  validateAnswer,
} from '@/services/lesson-engine';
import { useAuthStore } from '@/stores/auth-store';
import { useThemeStore } from '@/stores/theme-store';
import { ExerciseResult, LessonResult } from '@/types';
import {
  BorderRadius,
  ColorScheme,
  FontFamily,
  FontSize,
  Shadow,
  Spacing,
} from '@/constants/theme';

const LESSON_XP_REWARD = 15;
const OPTION_LABELS = ['A', 'B', 'C', 'D', 'E', 'F'];

export default function LessonExperience() {
  const { id } = useLocalSearchParams<{ id: string }>();
  const { colors } = useThemeStore();
  const { profile, fetchProfile } = useAuthStore();
  const [exercises, setExercises] = useState<LessonExercise[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');
  const [currentIndex, setCurrentIndex] = useState(0);
  const [lessonResult, setLessonResult] = useState<LessonResult | null>(null);
  const [xpReward, setXpReward] = useState(LESSON_XP_REWARD);
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [syncWarning, setSyncWarning] = useState('');
  const resultsRef = useRef<ExerciseResult[]>([]);
  const exerciseStartTime = useRef(Date.now());

  useEffect(() => {
    if (!id) {
      setError('Không tìm thấy bài học.');
      setLoading(false);
      return;
    }

    let active = true;
    setLoading(true);
    setError('');
    Promise.all([
      fetchLessonExercises(id),
      fetchLessonXpReward(id).catch(() => LESSON_XP_REWARD),
    ])
      .then(([data, reward]) => {
        if (!active) return;
        if (!data.length) {
          setError('Bài học này chưa có bài tập.');
          return;
        }
        setExercises(data);
        setXpReward(reward);
        exerciseStartTime.current = Date.now();
      })
      .catch((reason: unknown) => {
        if (!active) return;
        setError(reason instanceof Error ? reason.message : 'Không thể tải bài học.');
      })
      .finally(() => {
        if (active) setLoading(false);
      });

    return () => {
      active = false;
    };
  }, [id]);

  const handleAnswer = (answer: string, correct: boolean) => {
    const exercise = exercises[currentIndex];
    if (!exercise) return;
    const item: ExerciseResult = {
      exercise_id: exercise.id,
      is_correct: correct,
      user_answer: answer,
      time_spent_seconds: Math.max(
        0,
        Math.round((Date.now() - exerciseStartTime.current) / 1000),
      ),
    };
    resultsRef.current = [...resultsRef.current, item];
  };

  const finishLesson = async () => {
    if (!id || isSubmitting) return;
    const result = calculateLessonResult(
      id,
      exercises,
      resultsRef.current,
      xpReward,
    );
    setLessonResult(result);
    setIsSubmitting(true);
    setSyncWarning('');
    try {
      const submitted = await submitLessonCompletion(result);
      if (!submitted) setSyncWarning('Kết quả chưa đồng bộ. Vui lòng thử lại sau.');
      await fetchProfile();
    } catch {
      setSyncWarning('Kết quả chưa đồng bộ. Vui lòng thử lại sau.');
    } finally {
      setIsSubmitting(false);
    }
  };

  const handleNext = () => {
    if (currentIndex < exercises.length - 1) {
      setCurrentIndex((value) => value + 1);
      exerciseStartTime.current = Date.now();
    } else {
      void finishLesson();
    }
  };

  if (loading) {
    return (
      <StateScreen colors={colors}>
        <ActivityIndicator size="large" color={colors.primary} />
        <Text style={[styles.stateTitle, { color: colors.text }]}>Đang tải bài học...</Text>
      </StateScreen>
    );
  }

  if (error || !exercises.length) {
    return (
      <StateScreen colors={colors}>
        <View style={[styles.stateIcon, { backgroundColor: colors.errorLight }]}>
          <Ionicons name="book-outline" size={32} color={colors.error} />
        </View>
        <Text style={[styles.stateTitle, { color: colors.text }]}>
          {error || 'Bài học này chưa có bài tập.'}
        </Text>
        <Button title="Quay lại" size="lg" onPress={() => router.back()} />
      </StateScreen>
    );
  }

  if (lessonResult) {
    return (
      <CompleteView
        result={lessonResult}
        streak={profile?.current_streak ?? 0}
        colors={colors}
        syncing={isSubmitting}
        warning={syncWarning}
      />
    );
  }

  const exercise = exercises[currentIndex];
  return (
    <SafeAreaView
      edges={['top', 'bottom']}
      style={[styles.safeArea, { backgroundColor: colors.background }]}
    >
      <LessonHeader
        current={currentIndex + 1}
        total={exercises.length}
        colors={colors}
      />
      <View style={styles.flex}>
        <ExerciseRenderer
          key={exercise.id}
          exercise={exercise}
          colors={colors}
          onAnswer={handleAnswer}
          onNext={handleNext}
        />
      </View>
    </SafeAreaView>
  );
}

function LessonHeader({
  current,
  total,
  colors,
}: {
  current: number;
  total: number;
  colors: ColorScheme;
}) {
  return (
    <View style={[styles.header, { backgroundColor: colors.surface, borderColor: colors.borderLight }]}>
      <View style={styles.headerRow}>
        <TouchableOpacity
          accessibilityLabel="Đóng bài học"
          onPress={() => router.back()}
          style={styles.headerButton}
        >
          <Ionicons name="close" size={25} color={colors.textSecondary} />
        </TouchableOpacity>
        <Text style={[styles.headerTitle, { color: colors.primary }]}>Bài học</Text>
        <View style={styles.headerButton}>
          <Ionicons name="ellipsis-horizontal" size={22} color={colors.textSecondary} />
        </View>
      </View>
      <View style={styles.progressRow}>
        <View style={styles.flex}>
          <ProgressBar
            progress={(current / total) * 100}
            height={8}
            color={colors.jade}
            animated
          />
        </View>
        <Text style={[styles.progressCount, { color: colors.jade }]}>
          {current}/{total}
        </Text>
      </View>
    </View>
  );
}

interface ExerciseProps {
  exercise: LessonExercise;
  colors: ColorScheme;
  onAnswer: (answer: string, correct: boolean) => void;
  onNext: () => void;
}

function ExerciseRenderer(props: ExerciseProps) {
  switch (props.exercise.exercise_type) {
    case 'multiple_choice':
      return <ChoiceExercise {...props} />;
    case 'listening':
      return <ListeningExercise {...props} />;
    case 'translation':
      return <TranslationExercise {...props} />;
    case 'sentence_builder':
      return <SentenceBuilderExercise {...props} />;
    case 'speaking':
      return <SpeakingExercise {...props} />;
    case 'vocabulary':
    case 'flashcard':
    default:
      return <VocabularyExercise {...props} />;
  }
}

function ChoiceExercise(props: ExerciseProps) {
  const { exercise, colors, onAnswer, onNext } = props;
  const [selected, setSelected] = useState<number | null>(null);
  const [answered, setAnswered] = useState(false);
  const [correct, setCorrect] = useState(false);
  const options = exercise.exercise_options ?? [];
  const display = getExerciseDisplay(exercise);

  const check = () => {
    if (selected === null || answered) return;
    const answer = options[selected]?.text ?? '';
    const isCorrect = validateAnswer(exercise, answer);
    setCorrect(isCorrect);
    setAnswered(true);
    onAnswer(answer, isCorrect);
  };

  return (
    <ExerciseLayout
      footer={
        answered ? (
          <LessonFeedbackPanel
            correct={correct}
            answer={exercise.correct_answer}
            explanation={exercise.explanation}
            points={exercise.points}
            onContinue={onNext}
            colors={colors}
          />
        ) : (
          <LessonActionBar title="Kiểm tra" disabled={selected === null} onPress={check} />
        )
      }
    >
      <Intro title="Chọn nghĩa đúng" subtitle={exercise.question} colors={colors} />
      <LessonQuestionCard {...display} colors={colors} />
      <OptionList
        exercise={exercise}
        selected={selected}
        answered={answered}
        onSelect={setSelected}
      />
    </ExerciseLayout>
  );
}

function ListeningExercise(props: ExerciseProps) {
  const { exercise, colors, onAnswer, onNext } = props;
  const [selected, setSelected] = useState<number | null>(null);
  const [answered, setAnswered] = useState(false);
  const [correct, setCorrect] = useState(false);
  const options = exercise.exercise_options ?? [];

  const check = () => {
    if (selected === null || answered) return;
    const answer = options[selected]?.text ?? '';
    const isCorrect = validateAnswer(exercise, answer);
    setCorrect(isCorrect);
    setAnswered(true);
    onAnswer(answer, isCorrect);
  };

  return (
    <ExerciseLayout
      footer={
        answered ? (
          <LessonFeedbackPanel
            correct={correct}
            answer={exercise.correct_answer}
            explanation={exercise.explanation}
            points={exercise.points}
            onContinue={onNext}
            colors={colors}
          />
        ) : (
          <LessonActionBar title="Kiểm tra" disabled={selected === null} onPress={check} />
        )
      }
    >
      <Intro title="Nghe và chọn đáp án đúng" subtitle={exercise.question} colors={colors} />
      <View style={[styles.audioCard, { backgroundColor: colors.card, borderColor: colors.border }]}>
        <AudioPlayer
          uri={exercise.question_audio_url}
          label="Nhấn để nghe"
          size="lg"
          showSpeed
          variant="lesson"
        />
      </View>
      <OptionList
        exercise={exercise}
        selected={selected}
        answered={answered}
        onSelect={setSelected}
      />
    </ExerciseLayout>
  );
}

function OptionList({
  exercise,
  selected,
  answered,
  onSelect,
}: {
  exercise: LessonExercise;
  selected: number | null;
  answered: boolean;
  onSelect: (index: number) => void;
}) {
  return (
    <View style={styles.options}>
      {(exercise.exercise_options ?? []).map((option, index) => (
        <LessonOptionCard
          key={option.id}
          label={OPTION_LABELS[index] ?? String(index + 1)}
          text={option.text}
          chinese={containsChinese(option.text)}
          state={optionState(index, selected, answered, option.is_correct)}
          disabled={answered}
          onPress={() => onSelect(index)}
        />
      ))}
    </View>
  );
}

function VocabularyExercise({ exercise, colors, onAnswer, onNext }: ExerciseProps) {
  const display = getExerciseDisplay(exercise);
  const proceed = () => {
    onAnswer('viewed', true);
    onNext();
  };
  return (
    <ExerciseLayout footer={<LessonActionBar title="Tiếp tục" onPress={proceed} />}>
      <Intro title="Từ mới" subtitle={exercise.question} colors={colors} />
      <LessonQuestionCard
        eyebrow="Ghi nhớ"
        chinese={display.chinese || exercise.correct_answer}
        pinyin={display.pinyin}
        meaning={display.meaning}
        colors={colors}
      />
      {exercise.explanation ? (
        <View style={[styles.note, { backgroundColor: colors.surfaceElevated, borderColor: colors.border }]}>
          <Ionicons name="bulb-outline" size={22} color={colors.primary} />
          <Text style={[styles.noteText, { color: colors.textSecondary }]}>
            {exercise.explanation}
          </Text>
        </View>
      ) : null}
    </ExerciseLayout>
  );
}

function TranslationExercise({ exercise, colors, onAnswer, onNext }: ExerciseProps) {
  const [input, setInput] = useState('');
  const [answered, setAnswered] = useState(false);
  const [correct, setCorrect] = useState(false);

  const check = () => {
    if (!input.trim() || answered) return;
    const isCorrect = validateAnswer(exercise, input);
    setCorrect(isCorrect);
    setAnswered(true);
    onAnswer(input, isCorrect);
  };

  return (
    <KeyboardAvoidingView behavior={Platform.OS === 'ios' ? 'padding' : undefined} style={styles.flex}>
      <ExerciseLayout
        keyboard
        footer={
          answered ? (
            <LessonFeedbackPanel
              correct={correct}
              answer={exercise.correct_answer}
              explanation={exercise.explanation}
              points={exercise.points}
              onContinue={onNext}
              colors={colors}
            />
          ) : (
            <LessonActionBar title="Kiểm tra" disabled={!input.trim()} onPress={check} />
          )
        }
      >
        <Intro title="Dịch câu" subtitle={exercise.question} colors={colors} />
        <View
          style={[
            styles.inputCard,
            {
              backgroundColor: colors.card,
              borderColor: answered ? (correct ? colors.success : colors.error) : colors.border,
            },
          ]}
        >
          <TextInput
            multiline
            autoCorrect={false}
            editable={!answered}
            placeholder="Nhập câu trả lời..."
            placeholderTextColor={colors.textTertiary}
            value={input}
            onChangeText={setInput}
            style={[styles.input, { color: colors.text }]}
          />
        </View>
      </ExerciseLayout>
    </KeyboardAvoidingView>
  );
}

function SentenceBuilderExercise({ exercise, colors, onAnswer, onNext }: ExerciseProps) {
  const data = exercise.data as Record<string, unknown>;
  const words = Array.isArray(data.words)
    ? data.words.filter((value): value is string => typeof value === 'string')
    : exercise.correct_answer.split('');
  const [selected, setSelected] = useState<number[]>([]);
  const [answered, setAnswered] = useState(false);
  const [correct, setCorrect] = useState(false);
  const answerWords = selected.map((index) => words[index]);
  const remaining = words.map((_, index) => index).filter((index) => !selected.includes(index));

  const check = () => {
    if (!selected.length || answered) return;
    const answer = answerWords.join('');
    const isCorrect = validateAnswer(exercise, answer);
    setCorrect(isCorrect);
    setAnswered(true);
    onAnswer(answer, isCorrect);
  };

  return (
    <ExerciseLayout
      footer={
        answered ? (
          <LessonFeedbackPanel
            correct={correct}
            answer={exercise.correct_answer}
            explanation={exercise.explanation}
            points={exercise.points}
            onContinue={onNext}
            colors={colors}
          />
        ) : (
          <LessonActionBar title="Kiểm tra" disabled={!selected.length} onPress={check} />
        )
      }
    >
      <Intro title="Sắp xếp câu" subtitle={exercise.question} colors={colors} />
      <View style={[styles.sentenceArea, { backgroundColor: colors.card, borderColor: colors.border }]}>
        {!answerWords.length ? (
          <Text style={{ color: colors.textTertiary }}>Nhấn vào từ để xếp câu</Text>
        ) : (
          <View style={styles.wordWrap}>
            {answerWords.map((word, index) => (
              <WordChip
                key={`${selected[index]}-${word}`}
                text={word}
                color={colors.primary}
                background={`${colors.primary}12`}
                disabled={answered}
                onPress={() => setSelected((items) => items.filter((_, i) => i !== index))}
              />
            ))}
          </View>
        )}
      </View>
      <View style={styles.wordWrap}>
        {remaining.map((index) => (
          <WordChip
            key={`${index}-${words[index]}`}
            text={words[index]}
            color={colors.text}
            background={colors.card}
            disabled={answered}
            onPress={() => setSelected((items) => [...items, index])}
          />
        ))}
      </View>
    </ExerciseLayout>
  );
}

function WordChip({
  text,
  color,
  background,
  disabled,
  onPress,
}: {
  text: string;
  color: string;
  background: string;
  disabled: boolean;
  onPress: () => void;
}) {
  return (
    <TouchableOpacity
      disabled={disabled}
      onPress={onPress}
      style={[styles.wordChip, { backgroundColor: background, borderColor: color }]}
    >
      <Text style={[styles.wordText, { color }]}>{text}</Text>
    </TouchableOpacity>
  );
}

function Intro({
  title,
  subtitle,
  colors,
}: {
  title: string;
  subtitle?: string;
  colors: ColorScheme;
}) {
  return (
    <View style={styles.intro}>
      <Text style={[styles.exerciseTitle, { color: colors.text }]}>{title}</Text>
      {subtitle ? (
        <Text style={[styles.exerciseSubtitle, { color: colors.textSecondary }]}>{subtitle}</Text>
      ) : null}
    </View>
  );
}

function ExerciseLayout({
  children,
  footer,
  keyboard = false,
}: {
  children: React.ReactNode;
  footer: React.ReactNode;
  keyboard?: boolean;
}) {
  return (
    <View style={styles.flex}>
      <ScrollView
        style={styles.flex}
        contentContainerStyle={styles.scrollContent}
        keyboardShouldPersistTaps={keyboard ? 'handled' : 'never'}
        showsVerticalScrollIndicator={false}
      >
        <FadeInView animation="slideUp" duration={350} style={styles.content}>
          {children}
        </FadeInView>
      </ScrollView>
      {footer}
    </View>
  );
}

function StateScreen({ children, colors }: { children: React.ReactNode; colors: ColorScheme }) {
  return (
    <SafeAreaView
      edges={['top', 'bottom']}
      style={[styles.stateScreen, { backgroundColor: colors.background }]}
    >
      {children}
    </SafeAreaView>
  );
}

function CompleteView({
  result,
  streak,
  colors,
  syncing,
  warning,
}: {
  result: LessonResult;
  streak: number;
  colors: ColorScheme;
  syncing: boolean;
  warning: string;
}) {
  return (
    <SafeAreaView
      edges={['top', 'bottom']}
      style={[styles.safeArea, { backgroundColor: colors.background }]}
    >
      <ScrollView contentContainerStyle={styles.completeScroll} showsVerticalScrollIndicator={false}>
        <FadeInView animation="slideUp" duration={520} style={styles.complete}>
          <View style={[styles.successMark, { backgroundColor: colors.card, borderColor: colors.border }]}>
            <Text style={[styles.successHanzi, { color: colors.primary }]}>成</Text>
          </View>
          <Text style={[styles.completeTitle, { color: colors.text }]}>
            {result.perfect ? 'Hoàn hảo!' : 'Hoàn thành bài học!'}
          </Text>
          {result.perfect ? (
            <View style={[styles.perfectBadge, { backgroundColor: colors.coinLight }]}>
              <Ionicons name="trophy" size={17} color={colors.coin} />
              <Text style={{ color: colors.secondaryDark, fontFamily: FontFamily.semibold }}>
                Thưởng bài học hoàn hảo
              </Text>
            </View>
          ) : null}
          <View style={styles.statsGrid}>
            <LessonStatCard
              label="Kinh nghiệm"
              value={`+${result.xp_earned}`}
              icon="star-outline"
              accent={colors.jade}
              colors={colors}
            />
            <LessonStatCard
              label="Độ chính xác"
              value={`${Math.round(result.accuracy)}%`}
              icon="checkmark-circle-outline"
              colors={colors}
            />
            <LessonStatCard
              label="Đúng"
              value={`${result.correct_answers} / ${result.total_exercises}`}
              colors={colors}
            />
            <LessonStatCard
              label="Thời gian"
              value={formatDuration(result.time_spent_seconds)}
              colors={colors}
            />
          </View>
          <View style={[styles.streakCard, { backgroundColor: colors.card, borderColor: colors.coinLight }]}>
            <View style={styles.streakRow}>
              <Ionicons name="flame" size={31} color={colors.streak} />
              <Text style={[styles.streakLabel, { color: colors.text }]}>Chuỗi học</Text>
            </View>
            <Text style={[styles.streakValue, { color: colors.streak }]}>
              {streak} <Text style={[styles.streakUnit, { color: colors.textSecondary }]}>ngày</Text>
            </Text>
          </View>
          {warning ? <Text style={[styles.warning, { color: colors.error }]}>{warning}</Text> : null}
          <View style={styles.completeActions}>
            <Button
              title={syncing ? 'Đang lưu kết quả...' : 'Tiếp tục'}
              size="lg"
              fullWidth
              loading={syncing}
              onPress={() => router.back()}
            />
            {result.correct_answers < result.total_exercises ? (
              <Button
                title="Xem lại lỗi sai"
                variant="outline"
                size="lg"
                fullWidth
                onPress={() => router.push('/review/mistakes' as never)}
              />
            ) : null}
          </View>
        </FadeInView>
      </ScrollView>
    </SafeAreaView>
  );
}

function optionState(
  index: number,
  selected: number | null,
  answered: boolean,
  correct: boolean,
): LessonOptionState {
  if (!answered) return selected === index ? 'selected' : 'idle';
  if (correct) return 'correct';
  if (selected === index) return 'incorrect';
  return 'muted';
}

function getExerciseDisplay(exercise: LessonExercise) {
  const data = exercise.data as Record<string, unknown>;
  const quoted = exercise.question.match(/["“”']([\u3400-\u9fff][^"“”']*)["“”']/)?.[1];
  const inQuestion = exercise.question.match(/[\u3400-\u9fff][\u3400-\u9fff，。！？、；：]*/)?.[0];
  return {
    chinese:
      firstString(data, ['chinese', 'text', 'audio_text', 'characters']) ??
      quoted ??
      inQuestion ??
      (containsChinese(exercise.correct_answer) ? exercise.correct_answer : undefined),
    pinyin: firstString(data, ['pinyin', 'audio_pinyin', 'romanization']),
    meaning: firstString(data, ['meaning', 'meaning_vi', 'translation', 'vietnamese']),
  };
}

function firstString(data: Record<string, unknown>, keys: string[]) {
  for (const key of keys) {
    const value = data[key];
    if (typeof value === 'string' && value.trim()) return value;
  }
  return undefined;
}

function containsChinese(value: string) {
  return /[\u3400-\u9fff]/.test(value);
}

function formatDuration(seconds: number) {
  const safe = Math.max(0, Math.round(seconds));
  return `${Math.floor(safe / 60)}:${String(safe % 60).padStart(2, '0')}`;
}

const styles = StyleSheet.create({
  flex: { flex: 1 },
  safeArea: { flex: 1 },
  header: { borderBottomWidth: StyleSheet.hairlineWidth, paddingBottom: Spacing.sm },
  headerRow: {
    width: '100%', maxWidth: 720, height: 56, alignSelf: 'center',
    flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between',
    paddingHorizontal: Spacing.md,
  },
  headerButton: { width: 44, height: 44, borderRadius: 22, alignItems: 'center', justifyContent: 'center' },
  headerTitle: { fontFamily: FontFamily.heading, fontSize: FontSize['2xl'], lineHeight: 32 },
  progressRow: {
    width: '100%', maxWidth: 720, alignSelf: 'center', flexDirection: 'row',
    alignItems: 'center', gap: Spacing.md, paddingHorizontal: Spacing.xl,
  },
  progressCount: { minWidth: 34, fontFamily: FontFamily.semibold, fontSize: FontSize.sm, textAlign: 'right' },
  scrollContent: { flexGrow: 1, paddingHorizontal: Spacing.xl, paddingVertical: Spacing.xl },
  content: { width: '100%', maxWidth: 680, alignSelf: 'center', gap: Spacing.xl },
  intro: { alignItems: 'center', gap: Spacing.xs },
  exerciseTitle: { fontFamily: FontFamily.heading, fontSize: FontSize['2xl'], lineHeight: 32, textAlign: 'center' },
  exerciseSubtitle: { maxWidth: 560, fontFamily: FontFamily.regular, fontSize: FontSize.base, lineHeight: 24, textAlign: 'center' },
  options: { width: '100%', gap: Spacing.md },
  audioCard: {
    width: '100%', minHeight: 248, borderRadius: BorderRadius.xl, borderWidth: 1,
    alignItems: 'center', justifyContent: 'center', padding: Spacing.xl, ...Shadow.md,
  },
  note: { flexDirection: 'row', gap: Spacing.md, borderWidth: 1, borderRadius: BorderRadius.xl, padding: Spacing.lg },
  noteText: { flex: 1, fontFamily: FontFamily.regular, fontSize: FontSize.base, lineHeight: 24 },
  inputCard: { minHeight: 150, borderWidth: 1.5, borderRadius: BorderRadius.xl, padding: Spacing.lg, ...Shadow.sm },
  input: { minHeight: 112, fontFamily: FontFamily.regular, fontSize: FontSize.lg, lineHeight: 27, textAlignVertical: 'top' },
  sentenceArea: {
    minHeight: 132, borderWidth: 1.5, borderRadius: BorderRadius.xl, padding: Spacing.lg,
    alignItems: 'center', justifyContent: 'center', ...Shadow.sm,
  },
  wordWrap: { flexDirection: 'row', flexWrap: 'wrap', alignItems: 'center', justifyContent: 'center', gap: Spacing.sm },
  wordChip: {
    minHeight: 48, borderWidth: 1.5, borderRadius: BorderRadius.lg,
    paddingHorizontal: Spacing.lg, paddingVertical: Spacing.sm,
    alignItems: 'center', justifyContent: 'center',
  },
  wordText: { fontFamily: FontFamily.medium, fontSize: FontSize.base, lineHeight: 24 },
  stateScreen: {
    flex: 1, alignItems: 'center', justifyContent: 'center',
    gap: Spacing.lg, paddingHorizontal: Spacing.xl,
  },
  stateIcon: { width: 68, height: 68, borderRadius: 34, alignItems: 'center', justifyContent: 'center' },
  stateTitle: { fontFamily: FontFamily.heading, fontSize: FontSize.xl, lineHeight: 28, textAlign: 'center' },
  completeScroll: { flexGrow: 1, paddingHorizontal: Spacing.xl, paddingVertical: Spacing['3xl'] },
  complete: { width: '100%', maxWidth: 620, alignSelf: 'center', alignItems: 'center', gap: Spacing.xl },
  successMark: {
    width: 184, height: 184, borderRadius: 92, borderWidth: 1,
    alignItems: 'center', justifyContent: 'center', ...Shadow.lg,
  },
  successHanzi: {
    fontFamily: FontFamily.chinese, fontSize: 76, lineHeight: 94,
    textShadowColor: 'rgba(172,0,30,0.14)', textShadowOffset: { width: 0, height: 4 }, textShadowRadius: 7,
  },
  completeTitle: { fontFamily: FontFamily.heading, fontSize: FontSize['3xl'], lineHeight: 38, textAlign: 'center' },
  perfectBadge: { flexDirection: 'row', alignItems: 'center', gap: Spacing.sm, borderRadius: 999, paddingHorizontal: Spacing.lg, paddingVertical: Spacing.sm },
  statsGrid: { width: '100%', flexDirection: 'row', flexWrap: 'wrap', justifyContent: 'space-between', gap: Spacing.md },
  streakCard: {
    width: '100%', minHeight: 82, borderWidth: 1, borderRadius: BorderRadius.xl,
    paddingHorizontal: Spacing.lg, paddingVertical: Spacing.md,
    flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between', ...Shadow.sm,
  },
  streakRow: { flexDirection: 'row', alignItems: 'center', gap: Spacing.sm },
  streakLabel: { fontFamily: FontFamily.semibold, fontSize: FontSize.lg },
  streakValue: { fontFamily: FontFamily.heading, fontSize: FontSize['2xl'] },
  streakUnit: { fontFamily: FontFamily.regular, fontSize: FontSize.base },
  warning: { fontFamily: FontFamily.medium, fontSize: FontSize.sm, textAlign: 'center' },
  completeActions: { width: '100%', gap: Spacing.md, marginTop: Spacing.md },
});
