import React, { useState } from 'react';
import {
  View,
  Text,
  StyleSheet,
  TouchableOpacity,
  ScrollView,
} from 'react-native';
import { Ionicons } from '@expo/vector-icons';
import { LinearGradient } from 'expo-linear-gradient';
import { router } from 'expo-router';
import { useSafeAreaInsets } from 'react-native-safe-area-context';
import { useThemeStore } from '@/stores/theme-store';
import { useAuthStore } from '@/stores/auth-store';
import { Button, ProgressBar, FadeInView, AnimatedPressable } from '@/components/ui';
import { FontSize, Spacing, BorderRadius, Shadow, FontWeight } from '@/constants/theme';
import { LEARNING_PURPOSES, STUDY_GOALS, EXPERIENCE_LEVELS } from '@/constants';

type Step = 'purpose' | 'duration' | 'level';

const STEP_CONFIG = {
  purpose: { index: 0, title: 'Bạn muốn học tiếng Trung\nđể làm gì?', sub: 'Chọn mục tiêu chính của bạn' },
  duration: { index: 1, title: 'Mỗi ngày bạn muốn\nhọc bao lâu?', sub: 'Chọn thời gian phù hợp với bạn' },
  level: { index: 2, title: 'Trình độ hiện tại\ncủa bạn?', sub: 'Chúng tôi sẽ điều chỉnh bài học phù hợp' },
};

export default function OnboardingScreen() {
  const { colors } = useThemeStore();
  const { updateProfile } = useAuthStore();
  const insets = useSafeAreaInsets();
  const [step, setStep] = useState<Step>('purpose');
  const [purpose, setPurpose] = useState('');
  const [duration, setDuration] = useState(15);
  const [level, setLevel] = useState('');
  const [isLoading, setIsLoading] = useState(false);

  const config = STEP_CONFIG[step];
  const progress = ((config.index + 1) / 3) * 100;

  const handleNext = () => {
    if (step === 'purpose') setStep('duration');
    else if (step === 'duration') setStep('level');
  };

  const handleBack = () => {
    if (step === 'duration') setStep('purpose');
    else if (step === 'level') setStep('duration');
  };

  const handleComplete = async () => {
    setIsLoading(true);
    try {
      const goalXp = STUDY_GOALS.find(g => g.minutes === duration)?.xpTarget ?? 20;
      await updateProfile({
        learning_purpose: purpose,
        daily_goal_minutes: duration,
        daily_goal_xp: goalXp,
        chinese_level: level === 'none' ? 'starter' : level === 'little' ? 'beginner' : 'elementary',
        onboarding_completed: true,
      });
      router.replace('/(tabs)/learn');
    } catch (error) {
      console.error('Onboarding error:', error);
    } finally {
      setIsLoading(false);
    }
  };

  const canProceed = step === 'purpose' ? !!purpose : step === 'duration' ? !!duration : !!level;

  return (
    <View style={[styles.container, { backgroundColor: colors.background }]}>
      {/* Header */}
      <View style={[styles.header, { paddingTop: insets.top + Spacing.md }]}>
        {step !== 'purpose' ? (
          <TouchableOpacity onPress={handleBack} style={[styles.backBtn, { backgroundColor: colors.surfaceElevated }]}>
            <Ionicons name="chevron-back" size={20} color={colors.text} />
          </TouchableOpacity>
        ) : (
          <View style={{ width: 36 }} />
        )}
        <View style={styles.progressWrap}>
          <ProgressBar progress={progress} height={4} color={colors.primary} animated />
        </View>
        <Text style={[styles.stepLabel, { color: colors.textTertiary }]}>{config.index + 1}/3</Text>
      </View>

      {/* Content */}
      <ScrollView contentContainerStyle={styles.content} showsVerticalScrollIndicator={false}>
        <FadeInView animation="slideUp" delay={50} key={step}>
          <Text style={[styles.question, { color: colors.text }]}>{config.title}</Text>
          <Text style={[styles.questionSub, { color: colors.textSecondary }]}>{config.sub}</Text>
        </FadeInView>

        {step === 'purpose' && <StepPurpose selected={purpose} onSelect={setPurpose} colors={colors} />}
        {step === 'duration' && <StepDuration selected={duration} onSelect={setDuration} colors={colors} />}
        {step === 'level' && <StepLevel selected={level} onSelect={setLevel} colors={colors} />}
      </ScrollView>

      {/* Footer */}
      <View style={[styles.footer, { paddingBottom: insets.bottom + Spacing.md }]}>
        {step === 'level' ? (
          <Button title="Bắt đầu học" variant="gradient" size="xl" fullWidth rounded loading={isLoading} disabled={!canProceed} onPress={handleComplete} />
        ) : (
          <Button title="Tiếp tục" variant="primary" size="xl" fullWidth rounded disabled={!canProceed} onPress={handleNext} />
        )}
      </View>
    </View>
  );
}

function StepPurpose({ selected, onSelect, colors }: { selected: string; onSelect: (v: string) => void; colors: any }) {
  return (
    <View style={styles.optionsGrid}>
      {LEARNING_PURPOSES.map((item) => (
        <AnimatedPressable key={item.id} scaleValue={0.97} onPress={() => onSelect(item.id)} style={styles.optionWrapper}>
          <View style={[
            styles.optionCard,
            { backgroundColor: selected === item.id ? colors.primary + '0C' : colors.card },
            selected === item.id ? { borderColor: colors.primary, borderWidth: 1.5 } : Shadow.xs,
          ]}>
            <Text style={styles.optionIcon}>{item.icon}</Text>
            <Text style={[styles.optionLabel, { color: colors.text }]}>{item.label}</Text>
            {selected === item.id && (
              <View style={[styles.checkMark, { backgroundColor: colors.primary }]}>
                <Ionicons name="checkmark" size={12} color="#fff" />
              </View>
            )}
          </View>
        </AnimatedPressable>
      ))}
    </View>
  );
}

function StepDuration({ selected, onSelect, colors }: { selected: number; onSelect: (v: number) => void; colors: any }) {
  return (
    <View style={styles.list}>
      {STUDY_GOALS.map((item) => (
        <AnimatedPressable key={item.minutes} scaleValue={0.98} onPress={() => onSelect(item.minutes)}>
          <View style={[
            styles.listItem,
            { backgroundColor: selected === item.minutes ? colors.primary + '0C' : colors.card },
            selected === item.minutes ? { borderColor: colors.primary, borderWidth: 1.5 } : Shadow.xs,
          ]}>
            <View>
              <Text style={[styles.listLabel, { color: colors.text }]}>{item.label}</Text>
              <Text style={[styles.listSub, { color: colors.textTertiary }]}>~{item.xpTarget} XP / ngày</Text>
            </View>
            {selected === item.minutes && <Ionicons name="checkmark-circle" size={22} color={colors.primary} />}
          </View>
        </AnimatedPressable>
      ))}
    </View>
  );
}

function StepLevel({ selected, onSelect, colors }: { selected: string; onSelect: (v: string) => void; colors: any }) {
  return (
    <View style={styles.list}>
      {EXPERIENCE_LEVELS.map((item) => (
        <AnimatedPressable key={item.id} scaleValue={0.98} onPress={() => onSelect(item.id)}>
          <View style={[
            styles.listItem,
            { backgroundColor: selected === item.id ? colors.primary + '0C' : colors.card },
            selected === item.id ? { borderColor: colors.primary, borderWidth: 1.5 } : Shadow.xs,
          ]}>
            <View>
              <Text style={[styles.listLabel, { color: colors.text }]}>{item.label}</Text>
              <Text style={[styles.listSub, { color: colors.textTertiary }]}>{item.description}</Text>
            </View>
            {selected === item.id && <Ionicons name="checkmark-circle" size={22} color={colors.primary} />}
          </View>
        </AnimatedPressable>
      ))}
    </View>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1 },
  header: { flexDirection: 'row', alignItems: 'center', paddingHorizontal: Spacing.xl, gap: Spacing.md, marginBottom: Spacing.md },
  backBtn: { width: 36, height: 36, borderRadius: 18, justifyContent: 'center', alignItems: 'center' },
  progressWrap: { flex: 1 },
  stepLabel: { fontSize: FontSize.sm, fontWeight: FontWeight.medium },
  content: { paddingHorizontal: Spacing.xl, paddingTop: Spacing.xl, paddingBottom: Spacing.xl, maxWidth: 500, alignSelf: 'center', width: '100%' },
  question: { fontSize: FontSize['2xl'], fontWeight: FontWeight.bold, lineHeight: 34, marginBottom: Spacing.sm, letterSpacing: -0.3 },
  questionSub: { fontSize: FontSize.md, marginBottom: Spacing['2xl'] },
  optionsGrid: { flexDirection: 'row', flexWrap: 'wrap', gap: Spacing.md },
  optionWrapper: { width: '47%' },
  optionCard: { paddingVertical: Spacing.xl, paddingHorizontal: Spacing.md, borderRadius: BorderRadius.xl, alignItems: 'center', gap: Spacing.sm, position: 'relative' },
  optionIcon: { fontSize: 28 },
  optionLabel: { fontSize: FontSize.md, fontWeight: FontWeight.medium, textAlign: 'center' },
  checkMark: { position: 'absolute', top: Spacing.sm, right: Spacing.sm, width: 20, height: 20, borderRadius: 10, justifyContent: 'center', alignItems: 'center' },
  list: { gap: Spacing.md },
  listItem: { flexDirection: 'row', justifyContent: 'space-between', alignItems: 'center', paddingVertical: Spacing.xl, paddingHorizontal: Spacing.xl, borderRadius: BorderRadius.xl },
  listLabel: { fontSize: FontSize.lg, fontWeight: FontWeight.medium },
  listSub: { fontSize: FontSize.sm, marginTop: 2 },
  footer: { paddingHorizontal: Spacing.xl, paddingTop: Spacing.md },
});
