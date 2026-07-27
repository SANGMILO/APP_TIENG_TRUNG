import React, { useState, useEffect, useRef } from 'react';
import { View, Text, StyleSheet, FlatList, TextInput, TouchableOpacity, SafeAreaView, KeyboardAvoidingView, Platform, ActivityIndicator, ScrollView } from 'react-native';
import { Ionicons } from '@expo/vector-icons';
import { useLocalSearchParams, router } from 'expo-router';
import { useThemeStore } from '@/stores/theme-store';
import { useAuthStore } from '@/stores/auth-store';
import { createConversation, fetchMessages, sendTutorMessage } from '@/services/ai-tutor-service';
import { parseStructuredResponse } from '@/services/ai-context-builder';
import { Message, TutorResponse, ConversationMode } from '@/lib/ai';
import { FontSize, Spacing, BorderRadius, Shadow, FontWeight } from '@/constants/theme';

const MODE_LABELS: Record<string, string> = {
  general: 'Trò chuyện',
  travel: 'Du lịch',
  restaurant: 'Nhà hàng',
  work: 'Công việc',
  grammar: 'Ngữ pháp',
  hsk: 'Luyện HSK',
};

export default function AiChatScreen() {
  const params = useLocalSearchParams<{ mode?: string; conversationId?: string }>();
  const { colors } = useThemeStore();
  const { profile } = useAuthStore();

  const [conversationId, setConversationId] = useState<string | null>(params.conversationId ?? null);
  const [messages, setMessages] = useState<Message[]>([]);
  const [input, setInput] = useState('');
  const [isLoading, setIsLoading] = useState(false);
  const [isSending, setIsSending] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const flatListRef = useRef<FlatList>(null);
  const mode = (params.mode as ConversationMode) || 'general';

  useEffect(() => {
    initConversation();
  }, []);

  const initConversation = async () => {
    setIsLoading(true);
    try {
      if (params.conversationId) {
        const msgs = await fetchMessages(params.conversationId);
        setMessages(msgs);
        setConversationId(params.conversationId);
      } else {
        const conv = await createConversation(mode, profile?.chinese_level || 'beginner');
        setConversationId(conv.id);
      }
    } catch (err) {
      setError('Không thể tải cuộc trò chuyện.');
    } finally {
      setIsLoading(false);
    }
  };

  const handleSend = async () => {
    if (!input.trim() || !conversationId || isSending) return;

    const userMessage = input.trim();
    setInput('');
    setIsSending(true);
    setError(null);

    const clientMessageId = `${Date.now()}_${Math.random().toString(36).slice(2)}`;
    const userMsg: Message = {
      id: clientMessageId,
      conversation_id: conversationId,
      role: 'user',
      content: userMessage,
      structured_data: null,
      status: 'completed',
      created_at: new Date().toISOString(),
    };
    setMessages(prev => [...prev, userMsg]);

    try {
      const result = await sendTutorMessage({
        conversationId,
        message: userMessage,
        mode,
        clientMessageId,
      });

      if (result.success && result.assistantMessage) {
        setMessages(prev => [...prev, result.assistantMessage!]);
      } else {
        setError(result.error || 'Không nhận được phản hồi.');
      }
    } catch {
      setError('Lỗi kết nối. Kiểm tra mạng và thử lại.');
    } finally {
      setIsSending(false);
    }
  };

  const handleSuggestedReply = (reply: string) => {
    setInput(reply);
  };

  if (isLoading) {
    return (
      <SafeAreaView style={[styles.container, { backgroundColor: colors.background }]}>
        <View style={styles.center}><ActivityIndicator size="large" color={colors.primary} /></View>
      </SafeAreaView>
    );
  }

  return (
    <SafeAreaView style={[styles.container, { backgroundColor: colors.background }]}>
      {/* Header */}
      <View style={[styles.header, { backgroundColor: colors.surface }]}>
        <TouchableOpacity onPress={() => router.back()} style={[styles.headerBtn, { backgroundColor: colors.surfaceElevated }]}>
          <Ionicons name="chevron-back" size={20} color={colors.text} />
        </TouchableOpacity>
        <View style={styles.headerCenter}>
          <Text style={[styles.headerTitle, { color: colors.text }]}>{MODE_LABELS[mode] || 'AI Tutor'}</Text>
          <View style={styles.headerStatus}>
            <View style={[styles.statusDot, { backgroundColor: colors.jade }]} />
            <Text style={[styles.statusText, { color: colors.textTertiary }]}>Online</Text>
          </View>
        </View>
        <View style={{ width: 36 }} />
      </View>

      {/* Messages */}
      <KeyboardAvoidingView style={{ flex: 1 }} behavior={Platform.OS === 'ios' ? 'padding' : undefined} keyboardVerticalOffset={0}>
        <FlatList
          ref={flatListRef}
          data={messages}
          keyExtractor={(item) => item.id}
          contentContainerStyle={styles.messageList}
          onContentSizeChange={() => flatListRef.current?.scrollToEnd({ animated: true })}
          renderItem={({ item }) => (
            <MessageBubble message={item} colors={colors} onSuggestedReply={handleSuggestedReply} />
          )}
          ListEmptyComponent={
            <View style={styles.emptyChat}>
              <View style={[styles.emptyIconWrap, { backgroundColor: colors.surfaceElevated }]}>
                <Ionicons name="chatbubbles-outline" size={32} color={colors.textTertiary} />
              </View>
              <Text style={[styles.emptyChatTitle, { color: colors.text }]}>Bắt đầu trò chuyện</Text>
              <Text style={[styles.emptyChatText, { color: colors.textSecondary }]}>
                Gửi tin nhắn bằng tiếng Trung hoặc tiếng Việt
              </Text>
            </View>
          }
        />

        {/* Error */}
        {error && (
          <View style={[styles.errorBar, { backgroundColor: colors.errorLight }]}>
            <Ionicons name="alert-circle" size={16} color={colors.error} />
            <Text style={[styles.errorText, { color: colors.error }]}>{error}</Text>
            <TouchableOpacity onPress={() => setError(null)}>
              <Ionicons name="close" size={16} color={colors.error} />
            </TouchableOpacity>
          </View>
        )}

        {/* Typing indicator */}
        {isSending && (
          <View style={styles.typingWrap}>
            <View style={[styles.typingBubble, { backgroundColor: colors.surfaceElevated }]}>
              <View style={[styles.typingDot, { backgroundColor: colors.textTertiary }]} />
              <View style={[styles.typingDot, styles.typingDot2, { backgroundColor: colors.textTertiary }]} />
              <View style={[styles.typingDot, styles.typingDot3, { backgroundColor: colors.textTertiary }]} />
            </View>
          </View>
        )}

        {/* Input */}
        <View style={[styles.inputBar, { backgroundColor: colors.surface }]}>
          <View style={[styles.inputWrap, { backgroundColor: colors.surfaceElevated }]}>
            <TextInput
              style={[styles.textInput, { color: colors.text }]}
              placeholder="Nhập tin nhắn..."
              placeholderTextColor={colors.textTertiary}
              value={input}
              onChangeText={setInput}
              multiline
              maxLength={3000}
            />
          </View>
          <TouchableOpacity
            style={[styles.sendBtn, { backgroundColor: input.trim() ? colors.primary : colors.surfaceMuted }]}
            onPress={handleSend}
            disabled={!input.trim() || isSending}
          >
            <Ionicons name="send" size={18} color={input.trim() ? '#fff' : colors.textTertiary} />
          </TouchableOpacity>
        </View>
      </KeyboardAvoidingView>
    </SafeAreaView>
  );
}

function MessageBubble({ message, colors, onSuggestedReply }: { message: Message; colors: any; onSuggestedReply: (r: string) => void }) {
  const isUser = message.role === 'user';
  const structured = message.structured_data as TutorResponse | null;

  return (
    <View style={[styles.bubbleContainer, isUser ? styles.bubbleRight : styles.bubbleLeft]}>
      <View style={[
        styles.bubble,
        isUser
          ? { backgroundColor: colors.primary }
          : { backgroundColor: colors.card, ...Shadow.xs },
      ]}>
        {isUser ? (
          <Text style={[styles.bubbleText, { color: '#fff' }]}>{message.content}</Text>
        ) : structured ? (
          <StructuredMessage structured={structured} colors={colors} onSuggestedReply={onSuggestedReply} />
        ) : (
          <Text style={[styles.bubbleText, { color: colors.text }]}>{message.content}</Text>
        )}
      </View>
    </View>
  );
}

function StructuredMessage({ structured, colors, onSuggestedReply }: { structured: TutorResponse; colors: any; onSuggestedReply: (r: string) => void }) {
  return (
    <View style={styles.structuredMsg}>
      {/* Main reply */}
      <Text style={[styles.chineseReply, { color: colors.text }]}>{structured.reply.chinese}</Text>
      {structured.reply.pinyin && (
        <Text style={[styles.pinyinReply, { color: colors.primary }]}>{structured.reply.pinyin}</Text>
      )}
      {structured.reply.translationVi && (
        <Text style={[styles.viReply, { color: colors.textSecondary }]}>{structured.reply.translationVi}</Text>
      )}

      {/* Correction */}
      {structured.correction && (
        <View style={[styles.correctionBox, { backgroundColor: colors.warningLight }]}>
          <View style={styles.correctionHeader}>
            <Ionicons name="create-outline" size={14} color={colors.warning} />
            <Text style={[styles.correctionLabel, { color: colors.warning }]}>Sửa lỗi</Text>
          </View>
          <Text style={[styles.correctionOriginal, { color: colors.error }]}>{structured.correction.original}</Text>
          <Text style={[styles.correctionFixed, { color: colors.jade }]}>{structured.correction.corrected}</Text>
          <Text style={[styles.correctionExplanation, { color: colors.text }]}>{structured.correction.explanationVi}</Text>
        </View>
      )}

      {/* New vocabulary */}
      {structured.newVocabulary.length > 0 && (
        <View style={styles.vocabSection}>
          <View style={styles.vocabHeader}>
            <Ionicons name="book-outline" size={12} color={colors.textTertiary} />
            <Text style={[styles.vocabLabel, { color: colors.textTertiary }]}>Từ mới</Text>
          </View>
          {structured.newVocabulary.map((v, i) => (
            <Text key={i} style={[styles.vocabItem, { color: colors.text }]}>
              <Text style={{ fontWeight: FontWeight.semibold }}>{v.chinese}</Text> ({v.pinyin}) — {v.meaningVi}
            </Text>
          ))}
        </View>
      )}

      {/* Learning tip */}
      {structured.learningTip && (
        <View style={styles.tipRow}>
          <Ionicons name="bulb-outline" size={14} color={colors.info} />
          <Text style={[styles.tip, { color: colors.info }]}>{structured.learningTip}</Text>
        </View>
      )}

      {/* Suggested replies */}
      {structured.suggestedReplies.length > 0 && (
        <ScrollView horizontal showsHorizontalScrollIndicator={false} style={styles.suggestedScroll}>
          <View style={styles.suggestedRow}>
            {structured.suggestedReplies.map((r, i) => (
              <TouchableOpacity key={i} style={[styles.suggestedChip, { backgroundColor: colors.primary + '0A', borderColor: colors.primary + '30' }]} onPress={() => onSuggestedReply(r)}>
                <Text style={[styles.suggestedText, { color: colors.primary }]}>{r}</Text>
              </TouchableOpacity>
            ))}
          </View>
        </ScrollView>
      )}
    </View>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1 },
  center: { flex: 1, justifyContent: 'center', alignItems: 'center' },

  // Header
  header: { flexDirection: 'row', alignItems: 'center', paddingHorizontal: Spacing.lg, paddingVertical: Spacing.sm, gap: Spacing.md, ...Shadow.xs },
  headerBtn: { width: 36, height: 36, borderRadius: 18, justifyContent: 'center', alignItems: 'center' },
  headerCenter: { flex: 1, alignItems: 'center' },
  headerTitle: { fontSize: FontSize.base, fontWeight: FontWeight.semibold },
  headerStatus: { flexDirection: 'row', alignItems: 'center', gap: 4, marginTop: 1 },
  statusDot: { width: 6, height: 6, borderRadius: 3 },
  statusText: { fontSize: FontSize['2xs'] },

  // Messages
  messageList: { paddingHorizontal: Spacing.lg, paddingVertical: Spacing.lg, paddingBottom: Spacing.md },
  emptyChat: { alignItems: 'center', paddingTop: Spacing['5xl'] },
  emptyIconWrap: { width: 64, height: 64, borderRadius: 32, justifyContent: 'center', alignItems: 'center', marginBottom: Spacing.lg },
  emptyChatTitle: { fontSize: FontSize.lg, fontWeight: FontWeight.semibold, marginBottom: Spacing.xs },
  emptyChatText: { fontSize: FontSize.md, textAlign: 'center' },

  // Bubbles
  bubbleContainer: { marginBottom: Spacing.md },
  bubbleRight: { alignItems: 'flex-end' },
  bubbleLeft: { alignItems: 'flex-start' },
  bubble: { maxWidth: '82%', padding: Spacing.md, borderRadius: BorderRadius.xl },
  bubbleText: { fontSize: FontSize.base, lineHeight: 22 },

  // Structured
  structuredMsg: { gap: Spacing.sm },
  chineseReply: { fontSize: FontSize.lg, fontWeight: FontWeight.medium, lineHeight: 26 },
  pinyinReply: { fontSize: FontSize.sm },
  viReply: { fontSize: FontSize.sm, fontStyle: 'italic' },

  // Correction
  correctionBox: { padding: Spacing.md, borderRadius: BorderRadius.lg, gap: 4, marginTop: Spacing.xs },
  correctionHeader: { flexDirection: 'row', alignItems: 'center', gap: 4, marginBottom: 2 },
  correctionLabel: { fontSize: FontSize.xs, fontWeight: FontWeight.bold },
  correctionOriginal: { fontSize: FontSize.md, textDecorationLine: 'line-through' },
  correctionFixed: { fontSize: FontSize.md, fontWeight: FontWeight.medium },
  correctionExplanation: { fontSize: FontSize.sm, marginTop: 2 },

  // Vocab
  vocabSection: { marginTop: Spacing.xs, gap: 3 },
  vocabHeader: { flexDirection: 'row', alignItems: 'center', gap: 4 },
  vocabLabel: { fontSize: FontSize.xs, fontWeight: FontWeight.semibold },
  vocabItem: { fontSize: FontSize.sm, lineHeight: 18 },

  // Tip
  tipRow: { flexDirection: 'row', alignItems: 'flex-start', gap: 4, marginTop: Spacing.xs },
  tip: { fontSize: FontSize.sm, flex: 1 },

  // Suggested
  suggestedScroll: { marginTop: Spacing.sm },
  suggestedRow: { flexDirection: 'row', gap: Spacing.sm },
  suggestedChip: { paddingHorizontal: Spacing.md, paddingVertical: Spacing.sm, borderRadius: BorderRadius.full, borderWidth: 1 },
  suggestedText: { fontSize: FontSize.sm, fontWeight: FontWeight.medium },

  // Error
  errorBar: { flexDirection: 'row', alignItems: 'center', gap: Spacing.sm, marginHorizontal: Spacing.lg, marginBottom: Spacing.sm, paddingHorizontal: Spacing.md, paddingVertical: Spacing.sm, borderRadius: BorderRadius.lg },
  errorText: { fontSize: FontSize.sm, flex: 1 },

  // Typing
  typingWrap: { paddingHorizontal: Spacing.lg, paddingBottom: Spacing.sm },
  typingBubble: { flexDirection: 'row', gap: 4, alignSelf: 'flex-start', paddingHorizontal: Spacing.lg, paddingVertical: Spacing.md, borderRadius: BorderRadius.xl },
  typingDot: { width: 7, height: 7, borderRadius: 4, opacity: 0.6 },
  typingDot2: { opacity: 0.4 },
  typingDot3: { opacity: 0.2 },

  // Input
  inputBar: { flexDirection: 'row', alignItems: 'flex-end', paddingHorizontal: Spacing.md, paddingVertical: Spacing.sm, gap: Spacing.sm, ...Shadow.xs },
  inputWrap: { flex: 1, borderRadius: BorderRadius.xl, paddingHorizontal: Spacing.lg, minHeight: 44, justifyContent: 'center' },
  textInput: { fontSize: FontSize.base, maxHeight: 100, paddingVertical: Spacing.sm },
  sendBtn: { width: 44, height: 44, borderRadius: 22, justifyContent: 'center', alignItems: 'center' },
});
