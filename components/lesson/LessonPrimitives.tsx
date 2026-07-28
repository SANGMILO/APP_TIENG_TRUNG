import React from 'react';
import { StyleSheet, Text, View, ViewStyle } from 'react-native';
import { Ionicons } from '@expo/vector-icons';
import Svg, { Circle } from 'react-native-svg';
import { AnimatedPressable, Button, FadeInView } from '@/components/ui';
import {
  BorderRadius,
  ColorScheme,
  FontFamily,
  FontSize,
  FontWeight,
  Shadow,
  Spacing,
} from '@/constants/theme';

export type LessonOptionState =
  | 'idle'
  | 'selected'
  | 'correct'
  | 'incorrect'
  | 'muted';

interface LessonOptionCardProps {
  label: string;
  text: string;
  state?: LessonOptionState;
  chinese?: boolean;
  disabled?: boolean;
  onPress?: () => void;
}

export function LessonOptionCard({
  label,
  text,
  state = 'idle',
  chinese = false,
  disabled = false,
  onPress,
}: LessonOptionCardProps) {
  const isSelected = state === 'selected';
  const isCorrect = state === 'correct';
  const isIncorrect = state === 'incorrect';

  const palette = {
    backgroundColor: isCorrect
      ? '#E2F3E9'
      : isIncorrect
        ? '#FFDAD6'
        : isSelected
          ? '#FFFAFA'
          : '#FFFFFF',
    borderColor: isCorrect
      ? '#205E44'
      : isIncorrect
        ? '#BA1A1A'
        : isSelected
          ? '#AC001E'
          : '#E5E2E1',
    textColor: isCorrect
      ? '#0E5138'
      : isIncorrect
        ? '#93000A'
        : '#1B1B1B',
    markerBackground: isCorrect
      ? '#205E44'
      : isIncorrect
        ? '#BA1A1A'
        : isSelected
          ? '#AC001E'
          : '#FFFFFF',
    markerBorder: isCorrect
      ? '#205E44'
      : isIncorrect
        ? '#BA1A1A'
        : isSelected
          ? '#AC001E'
          : '#DCD9D9',
    markerColor:
      isCorrect || isIncorrect || isSelected ? '#FFFFFF' : '#5D3F3D',
  };

  return (
    <AnimatedPressable
      accessibilityRole="button"
      accessibilityState={{ selected: isSelected, disabled }}
      disabled={disabled}
      onPress={onPress}
      style={[
        styles.option,
        {
          backgroundColor: palette.backgroundColor,
          borderColor: palette.borderColor,
          opacity: state === 'muted' ? 0.52 : 1,
        },
      ]}
    >
      <View
        style={[
          styles.optionMarker,
          {
            backgroundColor: palette.markerBackground,
            borderColor: palette.markerBorder,
          },
        ]}
      >
        {isCorrect || isIncorrect ? (
          <Ionicons
            name={isCorrect ? 'checkmark' : 'close'}
            size={18}
            color={palette.markerColor}
          />
        ) : (
          <Text style={[styles.optionLabel, { color: palette.markerColor }]}>
            {label}
          </Text>
        )}
      </View>
      <Text
        style={[
          styles.optionText,
          chinese && styles.optionChinese,
          {
            color: palette.textColor,
            fontFamily: chinese ? FontFamily.chinese : FontFamily.regular,
          },
        ]}
      >
        {text}
      </Text>
    </AnimatedPressable>
  );
}

interface LessonQuestionCardProps {
  chinese?: string;
  pinyin?: string;
  meaning?: string;
  eyebrow?: string;
  colors: ColorScheme;
}

export function LessonQuestionCard({
  chinese,
  pinyin,
  meaning,
  eyebrow,
  colors,
}: LessonQuestionCardProps) {
  if (!chinese && !pinyin && !meaning) return null;

  return (
    <View
      style={[
        styles.questionCard,
        {
          backgroundColor: colors.card,
          borderColor: colors.border,
        },
      ]}
    >
      {eyebrow ? (
        <Text style={[styles.eyebrow, { color: colors.primary }]}>{eyebrow}</Text>
      ) : null}
      {pinyin ? (
        <Text style={[styles.pinyin, { color: colors.textSecondary }]}>
          {pinyin}
        </Text>
      ) : null}
      {chinese ? (
        <Text
          adjustsFontSizeToFit
          minimumFontScale={0.58}
          numberOfLines={3}
          style={[styles.hanzi, { color: colors.text }]}
        >
          {chinese}
        </Text>
      ) : null}
      {meaning ? (
        <Text style={[styles.meaning, { color: colors.textSecondary }]}>
          {meaning}
        </Text>
      ) : null}
    </View>
  );
}

interface LessonFeedbackPanelProps {
  correct: boolean;
  answer: string;
  explanation?: string | null;
  points?: number;
  onContinue: () => void;
  colors: ColorScheme;
}

export function LessonFeedbackPanel({
  correct,
  answer,
  explanation,
  points,
  onContinue,
  colors,
}: LessonFeedbackPanelProps) {
  const accent = correct ? colors.success : colors.error;
  const background = correct ? colors.successLight : colors.errorLight;

  return (
    <FadeInView animation="slideUp" duration={280} style={styles.feedbackMotion}>
      <View style={[styles.feedbackPanel, { backgroundColor: background, borderColor: accent }]}>
        <View style={styles.feedbackHeader}>
          <View style={[styles.feedbackIcon, { backgroundColor: correct ? accent : colors.card }]}>
            <Ionicons
              name={correct ? 'checkmark' : 'sad-outline'}
              size={24}
              color={correct ? '#FFFFFF' : accent}
            />
          </View>
          <View style={styles.feedbackCopy}>
            <Text style={[styles.feedbackTitle, { color: accent }]}>
              {correct ? 'Tuyệt vời!' : 'Chưa chính xác.'}
            </Text>
            <Text style={[styles.feedbackAnswer, { color: colors.text }]}>
              {correct ? answer : `Đáp án đúng: ${answer}`}
            </Text>
            {correct && points && points > 0 ? (
              <View style={styles.pointsRow}>
                <Ionicons name="sparkles-outline" size={15} color={accent} />
                <Text style={[styles.pointsText, { color: accent }]}>
                  +{points} điểm
                </Text>
              </View>
            ) : null}
          </View>
        </View>
        {explanation ? (
          <View
            style={[
              styles.explanationBox,
              {
                backgroundColor: colors.card,
                borderColor: `${accent}44`,
              },
            ]}
          >
            <Text style={[styles.explanationText, { color: colors.text }]}>
              <Text style={{ color: accent, fontFamily: FontFamily.semibold }}>
                Giải thích:{' '}
              </Text>
              {explanation}
            </Text>
          </View>
        ) : null}
        <Button
          title="Tiếp tục"
          variant="primary"
          size="lg"
          fullWidth
          onPress={onContinue}
          style={styles.feedbackButton}
        />
      </View>
    </FadeInView>
  );
}

interface LessonActionBarProps {
  title: string;
  disabled?: boolean;
  onPress: () => void;
  secondaryTitle?: string;
  onSecondaryPress?: () => void;
}

export function LessonActionBar({
  title,
  disabled,
  onPress,
  secondaryTitle,
  onSecondaryPress,
}: LessonActionBarProps) {
  return (
    <View style={styles.actionBar}>
      {secondaryTitle && onSecondaryPress ? (
        <Button
          title={secondaryTitle}
          variant="outline"
          size="lg"
          fullWidth
          onPress={onSecondaryPress}
        />
      ) : null}
      <Button
        title={title}
        variant="primary"
        size="lg"
        fullWidth
        disabled={disabled}
        onPress={onPress}
      />
    </View>
  );
}

interface LessonStatCardProps {
  label: string;
  value: string;
  icon?: keyof typeof Ionicons.glyphMap;
  accent?: string;
  colors: ColorScheme;
  style?: ViewStyle;
}

export function LessonStatCard({
  label,
  value,
  icon,
  accent,
  colors,
  style,
}: LessonStatCardProps) {
  const valueColor = accent ?? colors.text;
  return (
    <View
      style={[
        styles.statCard,
        {
          backgroundColor: colors.card,
          borderColor: colors.border,
        },
        style,
      ]}
    >
      <Text style={[styles.statLabel, { color: colors.textSecondary }]}>{label}</Text>
      <View style={styles.statValueRow}>
        {icon ? <Ionicons name={icon} size={28} color={valueColor} /> : null}
        <Text style={[styles.statValue, { color: valueColor }]}>{value}</Text>
      </View>
    </View>
  );
}

interface ScoreRingProps {
  value: number;
  label: string;
  color: string;
  trackColor: string;
}

export function ScoreRing({ value, label, color, trackColor }: ScoreRingProps) {
  const clamped = Math.max(0, Math.min(100, Math.round(value)));
  const radius = 25;
  const circumference = 2 * Math.PI * radius;
  const dashOffset = circumference - (clamped / 100) * circumference;

  return (
    <View style={styles.scoreTile}>
      <View style={styles.scoreRing}>
        <Svg width={64} height={64} viewBox="0 0 64 64">
          <Circle
            cx="32"
            cy="32"
            r={radius}
            fill="none"
            stroke={trackColor}
            strokeWidth="4"
          />
          <Circle
            cx="32"
            cy="32"
            r={radius}
            fill="none"
            stroke={color}
            strokeWidth="4"
            strokeLinecap="round"
            strokeDasharray={`${circumference} ${circumference}`}
            strokeDashoffset={dashOffset}
            transform="rotate(-90 32 32)"
          />
        </Svg>
        <Text style={[styles.scoreValue, { color }]}>{clamped}%</Text>
      </View>
      <Text style={styles.scoreLabel}>{label}</Text>
    </View>
  );
}

const styles = StyleSheet.create({
  option: {
    minHeight: 68,
    width: '100%',
    flexDirection: 'row',
    alignItems: 'center',
    gap: Spacing.md,
    paddingHorizontal: Spacing.lg,
    paddingVertical: Spacing.md,
    borderRadius: BorderRadius.xl,
    borderWidth: 1.5,
    ...Shadow.sm,
  },
  optionMarker: {
    width: 34,
    height: 34,
    borderRadius: BorderRadius.full,
    borderWidth: 1.5,
    alignItems: 'center',
    justifyContent: 'center',
    flexShrink: 0,
  },
  optionLabel: {
    fontFamily: FontFamily.medium,
    fontSize: FontSize.base,
  },
  optionText: {
    flex: 1,
    fontSize: FontSize.base,
    lineHeight: 24,
  },
  optionChinese: {
    fontSize: 27,
    lineHeight: 38,
  },
  questionCard: {
    width: '100%',
    minHeight: 172,
    borderRadius: BorderRadius.xl,
    borderWidth: 1,
    padding: Spacing.xl,
    alignItems: 'center',
    justifyContent: 'center',
    gap: Spacing.xs,
    ...Shadow.sm,
  },
  eyebrow: {
    fontFamily: FontFamily.semibold,
    fontSize: FontSize.xs,
    textTransform: 'uppercase',
    letterSpacing: 1,
  },
  pinyin: {
    fontFamily: FontFamily.medium,
    fontSize: FontSize.lg,
    lineHeight: 24,
    letterSpacing: 1.1,
    textAlign: 'center',
  },
  hanzi: {
    fontFamily: FontFamily.chinese,
    fontSize: 58,
    lineHeight: 76,
    textAlign: 'center',
  },
  meaning: {
    fontFamily: FontFamily.regular,
    fontSize: FontSize.base,
    lineHeight: 24,
    textAlign: 'center',
  },
  feedbackMotion: {
    width: '100%',
  },
  feedbackPanel: {
    width: '100%',
    borderTopWidth: 2,
    paddingHorizontal: Spacing.xl,
    paddingTop: Spacing.lg,
    paddingBottom: Spacing.lg,
    gap: Spacing.md,
  },
  feedbackHeader: {
    flexDirection: 'row',
    alignItems: 'flex-start',
    gap: Spacing.md,
  },
  feedbackIcon: {
    width: 48,
    height: 48,
    borderRadius: BorderRadius.full,
    alignItems: 'center',
    justifyContent: 'center',
    ...Shadow.sm,
  },
  feedbackCopy: {
    flex: 1,
    gap: 2,
  },
  feedbackTitle: {
    fontFamily: FontFamily.heading,
    fontSize: FontSize.xl,
    lineHeight: 28,
  },
  feedbackAnswer: {
    fontFamily: FontFamily.regular,
    fontSize: FontSize.base,
    lineHeight: 23,
  },
  pointsRow: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: Spacing.xs,
    marginTop: Spacing.xs,
  },
  pointsText: {
    fontFamily: FontFamily.semibold,
    fontSize: FontSize.md,
  },
  explanationBox: {
    borderWidth: 1,
    borderRadius: BorderRadius.lg,
    padding: Spacing.md,
  },
  explanationText: {
    fontFamily: FontFamily.regular,
    fontSize: FontSize.md,
    lineHeight: 21,
  },
  feedbackButton: {
    borderRadius: BorderRadius.lg,
  },
  actionBar: {
    width: '100%',
    maxWidth: 680,
    alignSelf: 'center',
    paddingHorizontal: Spacing.xl,
    paddingVertical: Spacing.lg,
    gap: Spacing.sm,
  },
  statCard: {
    width: '48%',
    minHeight: 112,
    borderRadius: BorderRadius.xl,
    borderWidth: 1,
    padding: Spacing.md,
    alignItems: 'center',
    justifyContent: 'center',
    gap: Spacing.sm,
    ...Shadow.sm,
  },
  statLabel: {
    fontFamily: FontFamily.semibold,
    fontSize: FontSize.sm,
    textTransform: 'uppercase',
    letterSpacing: 0.7,
    textAlign: 'center',
  },
  statValueRow: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: Spacing.xs,
  },
  statValue: {
    fontFamily: FontFamily.heading,
    fontSize: FontSize['3xl'],
  },
  scoreTile: {
    flex: 1,
    minWidth: 92,
    borderRadius: BorderRadius.lg,
    borderWidth: 1,
    borderColor: '#E8E6DF',
    backgroundColor: '#FFFFFF',
    padding: Spacing.md,
    alignItems: 'center',
    justifyContent: 'center',
    gap: Spacing.xs,
    ...Shadow.sm,
  },
  scoreRing: {
    width: 64,
    height: 64,
    alignItems: 'center',
    justifyContent: 'center',
  },
  scoreValue: {
    position: 'absolute',
    fontFamily: FontFamily.semibold,
    fontSize: FontSize.sm,
  },
  scoreLabel: {
    color: '#5D3F3D',
    fontFamily: FontFamily.medium,
    fontSize: FontSize.xs,
    textAlign: 'center',
  },
});
