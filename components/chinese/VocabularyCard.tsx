import React from 'react';
import { View, Text, StyleSheet, TouchableOpacity } from 'react-native';
import { useThemeStore } from '@/stores/theme-store';
import { Card } from '@/components/ui';
import { AudioPlayer } from '@/components/media';
import { ChineseText } from './ChineseText';
import { FontSize, Spacing, BorderRadius } from '@/constants/theme';
import { Vocabulary } from '@/types';

interface VocabularyCardProps {
  vocabulary: Vocabulary;
  showExample?: boolean;
  onSave?: () => void;
  onUnsave?: () => void;
  isSaved?: boolean;
}

export function VocabularyCard({
  vocabulary,
  showExample = true,
  onSave,
  onUnsave,
  isSaved = false,
}: VocabularyCardProps) {
  const { colors } = useThemeStore();

  return (
    <Card variant="elevated" padding="lg">
      <View style={styles.header}>
        <ChineseText
          characters={vocabulary.chinese}
          pinyin={vocabulary.pinyin}
          translation={vocabulary.meaning_vi}
          fontSize={40}
        />
        <View style={styles.actions}>
          {vocabulary.audio_url && (
            <AudioPlayer uri={vocabulary.audio_url} size="md" />
          )}
          <TouchableOpacity
            onPress={isSaved ? onUnsave : onSave}
            style={[styles.saveBtn, { backgroundColor: isSaved ? colors.secondary + '20' : colors.surfaceElevated }]}
          >
            <Text style={styles.saveIcon}>{isSaved ? '⭐' : '☆'}</Text>
          </TouchableOpacity>
        </View>
      </View>

      {showExample && vocabulary.example_sentence && (
        <View style={[styles.example, { borderTopColor: colors.borderLight }]}>
          <Text style={[styles.exampleLabel, { color: colors.textTertiary }]}>Ví dụ:</Text>
          <Text style={[styles.exampleChinese, { color: colors.text }]}>
            {vocabulary.example_sentence}
          </Text>
          {vocabulary.example_pinyin && (
            <Text style={[styles.examplePinyin, { color: colors.primary }]}>
              {vocabulary.example_pinyin}
            </Text>
          )}
          {vocabulary.example_meaning && (
            <Text style={[styles.exampleMeaning, { color: colors.textSecondary }]}>
              {vocabulary.example_meaning}
            </Text>
          )}
        </View>
      )}
    </Card>
  );
}

const styles = StyleSheet.create({
  header: {
    alignItems: 'center',
    gap: Spacing.lg,
  },
  actions: {
    flexDirection: 'row',
    gap: Spacing.md,
    alignItems: 'center',
  },
  saveBtn: {
    width: 40,
    height: 40,
    borderRadius: 20,
    justifyContent: 'center',
    alignItems: 'center',
  },
  saveIcon: {
    fontSize: 20,
  },
  example: {
    marginTop: Spacing.lg,
    paddingTop: Spacing.lg,
    borderTopWidth: 1,
    gap: Spacing.xs,
  },
  exampleLabel: {
    fontSize: FontSize.xs,
    fontWeight: '500',
    textTransform: 'uppercase',
  },
  exampleChinese: {
    fontSize: FontSize.lg,
  },
  examplePinyin: {
    fontSize: FontSize.md,
  },
  exampleMeaning: {
    fontSize: FontSize.md,
  },
});
