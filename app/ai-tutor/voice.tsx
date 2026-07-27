import React, { useState, useRef, useCallback, useEffect } from 'react';
import { View, Text, StyleSheet, TouchableOpacity, SafeAreaView, ScrollView, ActivityIndicator } from 'react-native';
import { Ionicons } from '@expo/vector-icons';
import { useLocalSearchParams, router } from 'expo-router';
import { useThemeStore } from '@/stores/theme-store';
import { useAuthStore } from '@/stores/auth-store';
import { useAudioRecorder } from '@/hooks/useAudioRecorder';
import { AudioPlayer } from '@/components/media';
import { Button, ProgressBar } from '@/components/ui';
import { createConversation } from '@/services/ai-tutor-service';
import { createVoiceSession, endVoiceSession, executeVoiceTurn, VoiceTurnResult } from '@/services/voice-conversation-service';
import { VoiceState, VoiceTurn, VoiceSessionSummary } from '@/lib/voice';
import { TutorResponse, ConversationMode } from '@/lib/ai';
import { FontSize, Spacing, BorderRadius, Shadow, FontWeight } from '@/constants/theme';

const MODE_LABELS: Record<string, string> = {
  general: 'Trò chuyện',
  travel: 'Du lịch',
  restaurant: 'Nhà hàng',
  work: 'Công việc',
  grammar: 'Ngữ pháp',
  hsk: 'Luyện HSK',
};

export default function VoiceTutorScreen() {
  const params = useLocalSearchParams<{ mode?: string }>();
  const { colors } = useThemeStore();
  const { profile } = useAuthStore();
  const mode = (params.mode as ConversationMode) || 'general';

  const [voiceState, setVoiceState] = useState<VoiceState>('idle');
  const [conversationId, setConversationId] = useState<string | null>(null);
  const [sessionId, setSessionId] = useState<string | null>(null);
  const [turns, setTurns] = useState<VoiceTurn[]>([]);
  const [currentTranscript, setCurrentTranscript] = useState<string | null>(null);
  const [currentResponse, setCurrentResponse] = useState<TutorResponse | null>(null);
  const [ttsAudioUri, setTtsAudioUri] = useState<string | null>(null);
  const [error, setError] = useState<string | null>(null);
  const [sessionSummary, setSessionSummary] = useState<VoiceSessionSummary | null>(null);
  const [totalUserSpeechMs, setTotalUserSpeechMs] = useState(0);
  const [totalAiSpeechMs, setTotalAiSpeechMs] = useState(0);
  const sessionStartRef = useRef(Date.now());

  const recorder = useAudioRecorder({
    maxDurationMs: profile?.chinese_level === 'advanced' ? 45000 : 20000,
  });

  useEffect(() => {
    initSession();
  }, []);

  const initSession = async () => {
    setVoiceState('connecting');
    try {
      const conv = await createConversation(mode, profile?.chinese_level || 'beginner');
      setConversationId(conv.id);
      const sid = await createVoiceSession({
        mode,
        conversationId: conv.id,
        difficulty: profile?.chinese_level || 'beginner',
        transport: 'turn_based',
        maxTurnDurationMs: 20000,
        language: 'zh-CN',
      });
      setSessionId(sid);
      setVoiceState('ready');
      sessionStartRef.current = Date.now();
    } catch (err: any) {
      setError(err.message || 'Không thể khởi tạo phiên.');
      setVoiceState('error');
    }
  };

  const handleStartRecording = async () => {
    setError(null);
    setCurrentTranscript(null);
    setCurrentResponse(null);
    setTtsAudioUri(null);
    setVoiceState('recording');
    await recorder.startRecording();
  };

  const handleStopRecording = async () => {
    const result = await recorder.stopRecording();
    if (!result || !conversationId || !sessionId) {
      setVoiceState('ready');
      return;
    }

    setTotalUserSpeechMs(prev => prev + result.durationMs);
    setVoiceState('transcribing');

    const turnId = `${Date.now()}_${Math.random().toString(36).slice(2)}`;
    const turnResult = await executeVoiceTurn(result.uri, conversationId, sessionId, mode, turnId);

    if (!turnResult.success) {
      setError(turnResult.error || 'Đã có lỗi xảy ra.');
      setVoiceState('ready');
      return;
    }

    setCurrentTranscript(turnResult.transcript || '');
    setVoiceState('thinking');

    if (turnResult.aiResponse) {
      setCurrentResponse(turnResult.aiResponse);
    }

    if (turnResult.ttsAudioUri) {
      setTtsAudioUri(turnResult.ttsAudioUri);
      setVoiceState('speaking');
    } else {
      setVoiceState('ready');
    }

    setTurns(prev => [...prev, {
      id: turnId,
      userTranscript: turnResult.transcript || '',
      assistantTranscript: turnResult.aiResponse?.reply?.chinese || turnResult.aiText || '',
      assistantChinese: turnResult.aiResponse?.reply?.chinese,
      assistantPinyin: turnResult.aiResponse?.reply?.pinyin,
      assistantVietnamese: turnResult.aiResponse?.reply?.translationVi,
      sttLatencyMs: turnResult.latency.sttMs,
      aiLatencyMs: turnResult.latency.aiMs,
      ttsLatencyMs: turnResult.latency.ttsMs,
      totalLatencyMs: turnResult.latency.totalMs,
      userAudioDurationMs: result.durationMs,
      assistantAudioDurationMs: null,
    }]);

    recorder.reset();
  };

  const handleEndSession = async () => {
    if (!sessionId) { router.back(); return; }
    const totalDuration = Date.now() - sessionStartRef.current;
    const summary = await endVoiceSession(sessionId, totalDuration, totalUserSpeechMs, totalAiSpeechMs, turns.length);
    setSessionSummary(summary);
    setVoiceState('ended');
  };

  const handleTtsEnd = () => {
    setVoiceState('ready');
  };

  // ─── Session Summary ───
  if (sessionSummary) {
    return (
      <SafeAreaView style={[styles.container, { backgroundColor: colors.background }]}>
        <View style={styles.summaryCenter}>
          <View style={[styles.summaryIcon, { backgroundColor: colors.successLight }]}>
            <Ionicons name="checkmark-circle" size={36} color={colors.jade} />
          </View>
          <Text style={[styles.summaryTitle, { color: colors.text }]}>Phiên luyện hoàn thành</Text>
          <View style={[styles.summaryCard, { backgroundColor: colors.card }]}>
            <SummaryStat icon="time-outline" label="Thời gian" value={formatDuration(sessionSummary.totalDurationMs)} colors={colors} />
            <View style={[styles.summaryDivider, { backgroundColor: colors.borderLight }]} />
            <SummaryStat icon="chatbubbles-outline" label="Lượt nói" value={`${sessionSummary.turnCount}`} colors={colors} />
            <View style={[styles.summaryDivider, { backgroundColor: colors.borderLight }]} />
            <SummaryStat icon="flash-outline" label="XP" value={sessionSummary.xpEarned > 0 ? `+${sessionSummary.xpEarned}` : '—'} colors={colors} />
          </View>
          <Text style={[styles.aiDisclosure, { color: colors.textTertiary }]}>
            Giọng nói được tạo bởi AI
          </Text>
          <View style={styles.summaryActions}>
            <Button title="Hoàn thành" variant="primary" size="lg" fullWidth rounded onPress={() => router.back()} />
          </View>
        </View>
      </SafeAreaView>
    );
  }

  // ─── Main Voice UI ───
  return (
    <SafeAreaView style={[styles.container, { backgroundColor: colors.background }]}>
      {/* Header */}
      <View style={styles.header}>
        <TouchableOpacity onPress={handleEndSession} style={[styles.endBtn, { backgroundColor: colors.errorLight }]}>
          <Ionicons name="stop" size={14} color={colors.error} />
          <Text style={[styles.endBtnText, { color: colors.error }]}>Kết thúc</Text>
        </TouchableOpacity>
        <View style={styles.headerCenter}>
          <Text style={[styles.modeLabel, { color: colors.text }]}>{MODE_LABELS[mode] || mode}</Text>
          <Text style={[styles.turnCount, { color: colors.textTertiary }]}>{turns.length} lượt</Text>
        </View>
        <View style={[styles.timerBadge, { backgroundColor: colors.surfaceElevated }]}>
          <Ionicons name="time-outline" size={12} color={colors.textSecondary} />
          <Text style={[styles.timerText, { color: colors.textSecondary }]}>
            {formatDuration(Date.now() - sessionStartRef.current)}
          </Text>
        </View>
      </View>

      {/* Transcript */}
      <ScrollView style={styles.transcriptArea} contentContainerStyle={styles.transcriptContent}>
        {turns.map((turn) => (
          <View key={turn.id} style={styles.turnBlock}>
            <View style={[styles.userBubble, { backgroundColor: colors.primary }]}>
              <Text style={styles.userText}>{turn.userTranscript}</Text>
            </View>
            <View style={[styles.aiBubble, { backgroundColor: colors.card }]}>
              {turn.assistantChinese && <Text style={[styles.aiChinese, { color: colors.text }]}>{turn.assistantChinese}</Text>}
              {turn.assistantPinyin && <Text style={[styles.aiPinyin, { color: colors.primary }]}>{turn.assistantPinyin}</Text>}
              {turn.assistantVietnamese && <Text style={[styles.aiVi, { color: colors.textSecondary }]}>{turn.assistantVietnamese}</Text>}
            </View>
          </View>
        ))}

        {currentTranscript && voiceState !== 'ready' && (
          <View style={[styles.userBubble, { backgroundColor: colors.primary }]}>
            <Text style={styles.userText}>{currentTranscript}</Text>
          </View>
        )}

        {(voiceState === 'transcribing' || voiceState === 'thinking') && (
          <View style={styles.thinkingRow}>
            <ActivityIndicator size="small" color={colors.textTertiary} />
            <Text style={[styles.stateText, { color: colors.textTertiary }]}>
              {voiceState === 'transcribing' ? 'Đang nhận dạng...' : 'AI đang suy nghĩ...'}
            </Text>
          </View>
        )}
      </ScrollView>

      {/* Current response */}
      {currentResponse && voiceState === 'ready' && (
        <View style={[styles.responseCard, { backgroundColor: colors.card, ...Shadow.sm }]}>
          <Text style={[styles.responseChinese, { color: colors.text }]}>{currentResponse.reply.chinese}</Text>
          {currentResponse.reply.pinyin && <Text style={[styles.responsePinyin, { color: colors.primary }]}>{currentResponse.reply.pinyin}</Text>}
          {currentResponse.correction && (
            <View style={styles.correctionRow}>
              <Ionicons name="create-outline" size={12} color={colors.warning} />
              <Text style={[styles.correctionNote, { color: colors.warning }]}>
                {currentResponse.correction.explanationVi}
              </Text>
            </View>
          )}
        </View>
      )}

      {/* Error */}
      {error && (
        <View style={[styles.errorBar, { backgroundColor: colors.errorLight }]}>
          <Ionicons name="alert-circle" size={14} color={colors.error} />
          <Text style={[styles.errorText, { color: colors.error }]}>{error}</Text>
        </View>
      )}

      {/* TTS */}
      {ttsAudioUri && voiceState === 'speaking' && (
        <View style={styles.ttsArea}>
          <AudioPlayer uri={ttsAudioUri} autoPlay onPlayEnd={handleTtsEnd} size="sm" label="AI đang nói..." />
        </View>
      )}

      {/* Controls */}
      <View style={styles.controls}>
        {voiceState === 'idle' || voiceState === 'connecting' ? (
          <View style={styles.controlCenter}>
            <ActivityIndicator size="large" color={colors.primary} />
            <Text style={[styles.controlHint, { color: colors.textTertiary }]}>Đang kết nối...</Text>
          </View>
        ) : voiceState === 'recording' ? (
          <View style={styles.controlCenter}>
            <TouchableOpacity
              style={[styles.recordBtn, { backgroundColor: colors.error, ...Shadow.glow(colors.error) }]}
              onPress={handleStopRecording}
            >
              <Ionicons name="stop" size={28} color="#fff" />
            </TouchableOpacity>
            <Text style={[styles.controlHint, { color: colors.error }]}>
              Đang nghe... {Math.floor(recorder.durationMs / 1000)}s
            </Text>
          </View>
        ) : voiceState === 'ready' ? (
          <View style={styles.controlCenter}>
            <TouchableOpacity
              style={[styles.recordBtn, { backgroundColor: colors.primary, ...Shadow.glow(colors.primary) }]}
              onPress={handleStartRecording}
            >
              <Ionicons name="mic" size={28} color="#fff" />
            </TouchableOpacity>
            <Text style={[styles.controlHint, { color: colors.textSecondary }]}>Nhấn để nói</Text>
          </View>
        ) : (
          <View style={styles.controlCenter}>
            <View style={[styles.recordBtn, { backgroundColor: colors.surfaceElevated }]}>
              <ActivityIndicator size="small" color={colors.primary} />
            </View>
            <Text style={[styles.controlHint, { color: colors.textTertiary }]}>Đang xử lý...</Text>
          </View>
        )}

        <Text style={[styles.aiDisclosure, { color: colors.textTertiary }]}>
          Giọng nói được tạo bởi AI
        </Text>
      </View>
    </SafeAreaView>
  );
}

function SummaryStat({ icon, label, value, colors }: { icon: string; label: string; value: string; colors: any }) {
  return (
    <View style={styles.statItem}>
      <Ionicons name={icon as any} size={18} color={colors.textSecondary} />
      <Text style={[styles.statValue, { color: colors.text }]}>{value}</Text>
      <Text style={[styles.statLabel, { color: colors.textTertiary }]}>{label}</Text>
    </View>
  );
}

function formatDuration(ms: number): string {
  const sec = Math.floor(ms / 1000);
  const m = Math.floor(sec / 60);
  const s = sec % 60;
  return `${m}:${s.toString().padStart(2, '0')}`;
}

const styles = StyleSheet.create({
  container: { flex: 1 },

  // Header
  header: { flexDirection: 'row', justifyContent: 'space-between', alignItems: 'center', paddingHorizontal: Spacing.lg, paddingVertical: Spacing.sm },
  endBtn: { flexDirection: 'row', alignItems: 'center', gap: 4, paddingHorizontal: Spacing.md, paddingVertical: Spacing.sm, borderRadius: BorderRadius.full },
  endBtnText: { fontSize: FontSize.xs, fontWeight: FontWeight.bold },
  headerCenter: { alignItems: 'center' },
  modeLabel: { fontSize: FontSize.md, fontWeight: FontWeight.semibold },
  turnCount: { fontSize: FontSize.xs, marginTop: 1 },
  timerBadge: { flexDirection: 'row', alignItems: 'center', gap: 3, paddingHorizontal: Spacing.sm + 2, paddingVertical: Spacing.xs, borderRadius: BorderRadius.full },
  timerText: { fontSize: FontSize.xs, fontWeight: FontWeight.medium },

  // Transcript
  transcriptArea: { flex: 1 },
  transcriptContent: { paddingHorizontal: Spacing.xl, paddingVertical: Spacing.md, gap: Spacing.lg },
  turnBlock: { gap: Spacing.sm },
  userBubble: { alignSelf: 'flex-end', maxWidth: '80%', paddingHorizontal: Spacing.lg, paddingVertical: Spacing.md, borderRadius: BorderRadius.xl },
  userText: { color: '#fff', fontSize: FontSize.base, lineHeight: 22 },
  aiBubble: { alignSelf: 'flex-start', maxWidth: '85%', paddingHorizontal: Spacing.lg, paddingVertical: Spacing.md, borderRadius: BorderRadius.xl, gap: 3, ...Shadow.xs },
  aiChinese: { fontSize: FontSize.lg, fontWeight: FontWeight.medium, lineHeight: 24 },
  aiPinyin: { fontSize: FontSize.sm },
  aiVi: { fontSize: FontSize.sm, fontStyle: 'italic' },
  thinkingRow: { flexDirection: 'row', alignItems: 'center', gap: Spacing.sm, alignSelf: 'flex-start' },
  stateText: { fontSize: FontSize.sm },

  // Response card
  responseCard: { marginHorizontal: Spacing.xl, padding: Spacing.lg, borderRadius: BorderRadius.xl, gap: Spacing.xs },
  responseChinese: { fontSize: FontSize.lg, fontWeight: FontWeight.medium },
  responsePinyin: { fontSize: FontSize.sm },
  correctionRow: { flexDirection: 'row', alignItems: 'center', gap: 4, marginTop: Spacing.xs },
  correctionNote: { fontSize: FontSize.sm, flex: 1 },

  // Error
  errorBar: { flexDirection: 'row', alignItems: 'center', gap: Spacing.sm, marginHorizontal: Spacing.xl, paddingHorizontal: Spacing.md, paddingVertical: Spacing.sm, borderRadius: BorderRadius.lg },
  errorText: { fontSize: FontSize.sm, flex: 1 },

  // TTS
  ttsArea: { paddingHorizontal: Spacing.xl, paddingVertical: Spacing.sm },

  // Controls
  controls: { alignItems: 'center', paddingVertical: Spacing.xl, paddingBottom: Spacing['2xl'] },
  controlCenter: { alignItems: 'center', gap: Spacing.md },
  recordBtn: { width: 72, height: 72, borderRadius: 36, justifyContent: 'center', alignItems: 'center' },
  controlHint: { fontSize: FontSize.sm, fontWeight: FontWeight.medium },
  aiDisclosure: { fontSize: FontSize['2xs'], textAlign: 'center', marginTop: Spacing.md },

  // Summary
  summaryCenter: { flex: 1, justifyContent: 'center', alignItems: 'center', paddingHorizontal: Spacing['2xl'] },
  summaryIcon: { width: 72, height: 72, borderRadius: 36, justifyContent: 'center', alignItems: 'center', marginBottom: Spacing.xl },
  summaryTitle: { fontSize: FontSize['2xl'], fontWeight: FontWeight.bold, marginBottom: Spacing.xl },
  summaryCard: { flexDirection: 'row', borderRadius: BorderRadius.xl, paddingVertical: Spacing.lg, paddingHorizontal: Spacing.md, ...Shadow.sm, marginBottom: Spacing.xl },
  summaryDivider: { width: 1 },
  statItem: { flex: 1, alignItems: 'center', gap: 4 },
  statValue: { fontSize: FontSize.lg, fontWeight: FontWeight.bold },
  statLabel: { fontSize: FontSize.xs },
  summaryActions: { width: '100%', marginTop: Spacing.lg },
});
