import React, { useMemo } from 'react';
import { View, Text, StyleSheet, TouchableOpacity } from 'react-native';
import { useThemeStore } from '@/stores/theme-store';
import { SubtitleCue } from '@/services/video-service';
import { tokenizeChinese, buildDictionary } from '@/utils/chinese-tokenizer';
import { FontSize, Spacing } from '@/constants/theme';

interface InteractiveSubtitleProps {
  cue: SubtitleCue | null;
  showChinese: boolean;
  showPinyin: boolean;
  showVietnamese: boolean;
  vocabulary: Set<string>;
  onWordPress?: (word: string) => void;
}

export function InteractiveSubtitle({
  cue,
  showChinese,
  showPinyin,
  showVietnamese,
  vocabulary,
  onWordPress,
}: InteractiveSubtitleProps) {
  const { colors } = useThemeStore();

  const tokens = useMemo(() => {
    if (!cue?.chinese_text || !showChinese) return [];
    return tokenizeChinese(cue.chinese_text, vocabulary);
  }, [cue?.chinese_text, vocabulary, showChinese]);

  if (!cue) return null;

  return (
    <View style={styles.container}>
      {/* Chinese text - tokenized and clickable */}
      {showChinese && cue.chinese_text && (
        <View style={styles.chineseRow}>
          {tokens.map((token, i) => (
            <TouchableOpacity
              key={i}
              disabled={token.isPunctuation || !onWordPress}
              onPress={() => !token.isPunctuation && onWordPress?.(token.text)}
              activeOpacity={0.6}
            >
              <Text
                style={[
                  styles.chineseChar,
                  {
                    color: colors.text,
                    textDecorationLine: token.isWord && !token.isPunctuation ? 'underline' : 'none',
                    textDecorationColor: colors.primary + '40',
                  },
                ]}
              >
                {token.text}
              </Text>
            </TouchableOpacity>
          ))}
        </View>
      )}

      {/* Pinyin */}
      {showPinyin && cue.pinyin && (
        <Text style={[styles.pinyin, { color: colors.primary }]}>{cue.pinyin}</Text>
      )}

      {/* Vietnamese */}
      {showVietnamese && cue.vietnamese_text && (
        <Text style={[styles.vietnamese, { color: colors.textSecondary }]}>{cue.vietnamese_text}</Text>
      )}
    </View>
  );
}

const styles = StyleSheet.create({
  container: { alignItems: 'center', paddingVertical: Spacing.sm, paddingHorizontal: Spacing.md, gap: 4 },
  chineseRow: { flexDirection: 'row', flexWrap: 'wrap', justifyContent: 'center' },
  chineseChar: { fontSize: FontSize.xl, fontWeight: '500' },
  pinyin: { fontSize: FontSize.md },
  vietnamese: { fontSize: FontSize.md },
});
