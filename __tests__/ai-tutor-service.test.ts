jest.mock('../lib/supabase', () => ({
  supabase: {
    auth: { getUser: jest.fn() },
    rpc: jest.fn(),
    functions: { invoke: jest.fn() },
  },
}));

import { supabase } from '../lib/supabase';
import { checkDailyLimit, fetchAiCapabilities, sendTutorMessage } from '../services/ai-tutor-service';

const validStructured = {
  reply: { chinese: '你好', pinyin: 'nǐ hǎo', translationVi: 'Xin chào' },
  correction: null,
  newVocabulary: [],
  suggestedReplies: ['你好'],
  learningTip: null,
  practiceExercise: null,
};

describe('AI tutor service contracts', () => {
  beforeEach(() => {
    jest.clearAllMocks();
  });

  it('accepts and sanitizes a valid server reply', async () => {
    (supabase.functions.invoke as jest.Mock).mockResolvedValue({
      data: {
        assistantMessage: {
          id: 'assistant-1',
          conversation_id: 'conversation-1',
          role: 'assistant',
          content: '{}',
          structured_data: validStructured,
          status: 'completed',
          created_at: '2026-07-29T00:00:00Z',
        },
        usage: { used: 2, limit: 20 },
      },
      error: null,
    });

    const result = await sendTutorMessage({
      conversationId: 'conversation-1',
      message: '你好',
      mode: 'general',
      clientMessageId: 'client-1',
    });

    expect(result.success).toBe(true);
    expect(result.assistantMessage?.structured_data?.reply.chinese).toBe('你好');
    expect(result.usage).toEqual({ used: 2, limit: 20 });
  });

  it('reads provider capability without inventing availability', async () => {
    (supabase.functions.invoke as jest.Mock).mockResolvedValue({
      data: { textChatConfigured: false, voiceConfigured: false },
      error: null,
    });

    await expect(fetchAiCapabilities()).resolves.toEqual({
      textChatConfigured: false,
      voiceConfigured: false,
    });
    expect(supabase.functions.invoke).toHaveBeenCalledWith(
      'ai-tutor-chat',
      { body: { action: 'capabilities' } },
    );
  });

  it('fails safely when a reply has a malformed render schema', async () => {
    (supabase.functions.invoke as jest.Mock).mockResolvedValue({
      data: {
        assistantMessage: {
          id: 'assistant-1',
          role: 'assistant',
          content: '{}',
          structured_data: { reply: { chinese: { unsafe: true } } },
        },
      },
      error: null,
    });

    const result = await sendTutorMessage({
      conversationId: 'conversation-1',
      message: '你好',
      mode: 'general',
      clientMessageId: 'client-1',
    });

    expect(result).toMatchObject({ success: false, errorCode: 'MALFORMED_RESPONSE' });
  });

  it('uses the authoritative usage RPC without a client fallback', async () => {
    (supabase.auth.getUser as jest.Mock).mockResolvedValue({
      data: { user: { id: 'user-1' } },
    });
    (supabase.rpc as jest.Mock).mockResolvedValue({
      data: { allowed: true, used: 4, limit: 7 },
      error: null,
    });

    await expect(checkDailyLimit()).resolves.toEqual({ allowed: true, used: 4, limit: 7 });
    expect(supabase.rpc).toHaveBeenCalledWith('get_ai_daily_usage');
  });

  it('surfaces usage RPC failures instead of displaying invented values', async () => {
    (supabase.auth.getUser as jest.Mock).mockResolvedValue({
      data: { user: { id: 'user-1' } },
    });
    (supabase.rpc as jest.Mock).mockResolvedValue({
      data: null,
      error: new Error('database unavailable'),
    });

    await expect(checkDailyLimit()).rejects.toThrow('database unavailable');
  });
});
