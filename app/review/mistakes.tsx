import React, { useRef, useState } from 'react';
import { View, Text, StyleSheet, FlatList, TouchableOpacity, ActivityIndicator, TextInput } from 'react-native';
import * as Crypto from 'expo-crypto';
import { router } from 'expo-router';
import { useQuery, useQueryClient } from '@tanstack/react-query';
import { useThemeStore } from '@/stores/theme-store';
import { useAuthStore } from '@/stores/auth-store';
import { supabase } from '@/lib/supabase';
import { Button, EmptyState } from '@/components/ui';
import { submitMistakeReview } from '@/services/review-service';
import { FontSize, Spacing, BorderRadius } from '@/constants/theme';

type CategoryFilter = 'all' | 'vocabulary' | 'grammar' | 'listening' | 'writing';

export default function MistakesScreen() {
  const { colors } = useThemeStore();
  const { profile } = useAuthStore();
  const queryClient = useQueryClient();
  const [category, setCategory] = useState<CategoryFilter>('all');

  const { data: mistakes, isLoading, isError, refetch } = useQuery({
    queryKey: ['mistakes', profile?.id, category],
    queryFn: async () => {
      if (!profile) return [];

      let query = supabase
        .from('mistakes')
        .select('*')
        .eq('user_id', profile.id)
        .eq('reviewed', false)
        .order('created_at', { ascending: false })
        .limit(50);

      if (category !== 'all') {
        query = query.eq('category', category);
      }

      const { data, error } = await query;
      if (error) throw error;
      return data ?? [];
    },
    enabled: !!profile,
  });

  const categories: { key: CategoryFilter; label: string }[] = [
    { key: 'all', label: 'Tất cả' },
    { key: 'vocabulary', label: 'Từ vựng' },
    { key: 'grammar', label: 'Ngữ pháp' },
    { key: 'listening', label: 'Nghe' },
    { key: 'writing', label: 'Viết' },
  ];

  return (
    <View style={[styles.container, { backgroundColor: colors.background }]}>
      <View style={styles.header}>
        <TouchableOpacity onPress={() => router.back()}>
          <Text style={[styles.backBtn, { color: colors.primary }]}>← Quay lại</Text>
        </TouchableOpacity>
        <Text style={[styles.title, { color: colors.text }]}>Sổ lỗi sai</Text>
      </View>

      {/* Category filters */}
      <View style={styles.filterRow}>
        {categories.map(cat => (
          <TouchableOpacity
            key={cat.key}
            style={[styles.filterChip, { backgroundColor: category === cat.key ? colors.primary + '20' : colors.surface, borderColor: category === cat.key ? colors.primary : colors.border }]}
            onPress={() => setCategory(cat.key)}
          >
            <Text style={[styles.filterLabel, { color: category === cat.key ? colors.primary : colors.textSecondary }]}>
              {cat.label}
            </Text>
          </TouchableOpacity>
        ))}
      </View>

      {isLoading ? (
        <ActivityIndicator size="small" color={colors.primary} style={{ marginTop: Spacing['2xl'] }} />
      ) : isError ? (
        <EmptyState
          iconName="cloud-offline-outline"
          title="Không thể tải sổ lỗi sai"
          description="Kiểm tra kết nối rồi thử lại."
          actionLabel="Thử lại"
          onAction={() => { void refetch(); }}
        />
      ) : (
        <FlatList
          data={mistakes}
          keyExtractor={(item: any) => item.id}
          contentContainerStyle={styles.list}
          renderItem={({ item }: { item: any }) => (
            <MistakePracticeCard
              item={item}
              colors={colors}
              onResolved={async () => {
                await Promise.all([
                  queryClient.invalidateQueries({ queryKey: ['mistakes'] }),
                  queryClient.invalidateQueries({ queryKey: ['review-stats'] }),
                ]);
              }}
            />
          )}
          ListEmptyComponent={
            <View style={styles.empty}>
              <Text style={styles.emptyEmoji}>🎉</Text>
              <Text style={[styles.emptyText, { color: colors.textSecondary }]}>
                Không có lỗi sai nào!
              </Text>
            </View>
          }
        />
      )}
    </View>
  );
}

function MistakePracticeCard({
  item,
  colors,
  onResolved,
}: {
  item: any;
  colors: any;
  onResolved: () => Promise<void>;
}) {
  const [answer, setAnswer] = useState('');
  const [saving, setSaving] = useState(false);
  const [error, setError] = useState('');
  const [incorrect, setIncorrect] = useState(false);
  const pendingRef = useRef<{ id: string; answer: string } | null>(null);

  const submit = async () => {
    const submittedAnswer = answer.trim();
    if (!submittedAnswer || saving) return;

    const pending = pendingRef.current?.answer === submittedAnswer
      ? pendingRef.current
      : { id: Crypto.randomUUID(), answer: submittedAnswer };
    pendingRef.current = pending;
    setSaving(true);
    setError('');

    try {
      const result = await submitMistakeReview(
        pending.id,
        item.id,
        submittedAnswer,
      );
      pendingRef.current = null;
      if (result.resolved) {
        await onResolved();
      } else {
        setIncorrect(true);
      }
    } catch (reason: unknown) {
      setError(getErrorMessage(
        reason,
        'Không thể lưu lần luyện tập. Vui lòng thử lại.',
      ));
    } finally {
      setSaving(false);
    }
  };

  return (
    <View style={[styles.mistakeCard, { backgroundColor: colors.surface, borderColor: colors.border }]}>
      <Text style={[styles.mistakeQuestion, { color: colors.text }]}>{item.question}</Text>
      <View style={styles.previousAnswer}>
        <Text style={[styles.answerLabel, { color: colors.textTertiary }]}>
          Lần trả lời sai gần nhất
        </Text>
        <Text style={[styles.answerText, { color: colors.error }]}>{item.user_answer}</Text>
      </View>
      <TextInput
        style={[
          styles.practiceInput,
          {
            color: colors.text,
            borderColor: error ? colors.error : colors.border,
            backgroundColor: colors.background,
          },
        ]}
        value={answer}
        onChangeText={(value) => {
          setAnswer(value);
          setIncorrect(false);
          if (!pendingRef.current) setError('');
        }}
        placeholder="Nhập lại đáp án đúng"
        placeholderTextColor={colors.textTertiary}
        editable={!saving && !error}
        onSubmitEditing={() => { void submit(); }}
      />
      {incorrect ? (
        <View style={styles.feedback}>
          <Text style={[styles.feedbackText, { color: colors.error }]}>
            Chưa đúng. Đáp án: {item.correct_answer}
          </Text>
          <Text style={[styles.feedbackHint, { color: colors.textSecondary }]}>
            Sửa câu trả lời rồi thử lại để đánh dấu lỗi này đã ôn.
          </Text>
        </View>
      ) : null}
      {error ? (
        <Text style={[styles.feedbackText, { color: colors.error }]}>{error}</Text>
      ) : null}
      <Button
        title={error ? 'Thử lưu lại' : 'Kiểm tra đáp án'}
        variant="primary"
        size="sm"
        loading={saving}
        disabled={!answer.trim()}
        onPress={() => { void submit(); }}
      />
      <Text style={[styles.mistakeCategory, { color: colors.textTertiary }]}>
        {item.category} • {item.times_wrong}x sai
      </Text>
    </View>
  );
}

function getErrorMessage(reason: unknown, fallback: string) {
  if (
    typeof reason === 'object'
    && reason !== null
    && 'message' in reason
    && typeof reason.message === 'string'
    && reason.message.trim()
  ) {
    return reason.message;
  }
  return fallback;
}

const styles = StyleSheet.create({
  container: { flex: 1 },
  header: { paddingHorizontal: Spacing.xl, paddingTop: Spacing['5xl'], gap: Spacing.sm },
  backBtn: { fontSize: FontSize.base, fontWeight: '500' },
  title: { fontSize: FontSize['2xl'], fontWeight: 'bold' },
  filterRow: { flexDirection: 'row', gap: Spacing.sm, paddingHorizontal: Spacing.xl, paddingTop: Spacing.lg, flexWrap: 'wrap' },
  filterChip: { paddingHorizontal: Spacing.md, paddingVertical: Spacing.sm, borderRadius: BorderRadius.full, borderWidth: 1 },
  filterLabel: { fontSize: FontSize.sm, fontWeight: '500' },
  list: { paddingHorizontal: Spacing.xl, paddingTop: Spacing.lg, gap: Spacing.md },
  mistakeCard: { borderRadius: BorderRadius.xl, borderWidth: 1, padding: Spacing.lg, gap: Spacing.md },
  mistakeQuestion: { fontSize: FontSize.base, fontWeight: '500' },
  previousAnswer: { gap: 2 },
  answerLabel: { fontSize: FontSize.xs, fontWeight: '500' },
  answerText: { fontSize: FontSize.md, fontWeight: '600' },
  practiceInput: { borderWidth: 1, borderRadius: BorderRadius.lg, paddingHorizontal: Spacing.lg, paddingVertical: Spacing.md, fontSize: FontSize.base },
  feedback: { gap: Spacing.xs },
  feedbackText: { fontSize: FontSize.sm, fontWeight: '500' },
  feedbackHint: { fontSize: FontSize.xs },
  mistakeCategory: { fontSize: FontSize.xs },
  empty: { alignItems: 'center', paddingTop: Spacing['3xl'] },
  emptyEmoji: { fontSize: 40, marginBottom: Spacing.md },
  emptyText: { fontSize: FontSize.md },
});
