import React from 'react';
import { View, Text, StyleSheet } from 'react-native';
import { useThemeStore } from '@/stores/theme-store';
import { FontSize, Spacing } from '@/constants/theme';

interface ChineseTextProps {
  characters: string;
  pinyin?: string;
  translation?: string;
  fontSize?: number;
  pinyinSize?: number;
  showPinyin?: boolean;
  showTranslation?: boolean;
  align?: 'left' | 'center' | 'right';
}

export function ChineseText({
  characters,
  pinyin,
  translation,
  fontSize = FontSize.chinese,
  pinyinSize = FontSize.pinyin,
  showPinyin = true,
  showTranslation = true,
  align = 'center',
}: ChineseTextProps) {
  const { colors } = useThemeStore();

  return (
    <View style={[styles.container, { alignItems: align === 'center' ? 'center' : align === 'right' ? 'flex-end' : 'flex-start' }]}>
      <Text style={[styles.characters, { color: colors.text, fontSize }]}>{characters}</Text>
      {showPinyin && pinyin ? (
        <Text style={[styles.pinyin, { color: colors.primary, fontSize: pinyinSize }]}>{pinyin}</Text>
      ) : null}
      {showTranslation && translation ? (
        <Text style={[styles.translation, { color: colors.textSecondary }]}>{translation}</Text>
      ) : null}
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    gap: Spacing.xs,
  },
  characters: {
    fontWeight: '600',
  },
  pinyin: {
    fontWeight: '400',
  },
  translation: {
    fontSize: FontSize.md,
  },
});
