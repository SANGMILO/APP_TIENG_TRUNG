/**
 * AI Tutor Service - Client-side orchestrator
 * Manages conversations, sends messages via Edge Function
 * NEVER touches AI API keys directly
 */

import { supabase } from '@/lib/supabase';
import { Conversation, Message, ConversationMode, TutorResponse } from '@/lib/ai';

// ============================================
// CONVERSATION MANAGEMENT
// ============================================

export async function createConversation(mode: ConversationMode, difficulty: string = 'beginner'): Promise<Conversation> {
  const user = (await supabase.auth.getUser()).data.user;
  if (!user) throw new Error('Not authenticated');

  const { data, error } = await supabase
    .from('ai_conversations')
    .insert({
      user_id: user.id,
      mode,
      difficulty,
      title: getDefaultTitle(mode),
    })
    .select()
    .single();

  if (error) throw error;
  return data as Conversation;
}

export async function fetchConversations(): Promise<Conversation[]> {
  const { data, error } = await supabase
    .from('ai_conversations')
    .select('*')
    .neq('status', 'deleted')
    .order('last_message_at', { ascending: false, nullsFirst: false })
    .limit(20);

  if (error) throw error;
  return (data ?? []) as Conversation[];
}

export async function fetchMessages(conversationId: string, limit = 30, offset = 0): Promise<Message[]> {
  const { data, error } = await supabase
    .from('ai_messages')
    .select('*')
    .eq('conversation_id', conversationId)
    .eq('status', 'completed')
    .order('created_at', { ascending: true })
    .range(offset, offset + limit - 1);

  if (error) throw error;
  return (data ?? []) as Message[];
}

export async function deleteConversation(conversationId: string): Promise<void> {
  const { error } = await supabase
    .from('ai_conversations')
    .update({ status: 'deleted', updated_at: new Date().toISOString() })
    .eq('id', conversationId);

  if (error) throw error;
}

// ============================================
// SEND MESSAGE (via Edge Function)
// ============================================

export interface SendMessageParams {
  conversationId: string;
  message: string;
  mode: ConversationMode;
  clientMessageId: string;
}

export interface SendMessageResult {
  success: boolean;
  assistantMessage?: Message;
  error?: string;
  errorCode?: 'NOT_CONFIGURED' | 'RATE_LIMITED' | 'DAILY_LIMIT' | 'MESSAGE_TOO_LONG' | 'NETWORK_ERROR' | 'SERVER_ERROR';
}

export async function sendTutorMessage(params: SendMessageParams): Promise<SendMessageResult> {
  const { conversationId, message, mode, clientMessageId } = params;

  // Client validation
  if (!message.trim()) {
    return { success: false, error: 'Tin nhắn không được trống.', errorCode: 'MESSAGE_TOO_LONG' };
  }
  if (message.length > 3000) {
    return { success: false, error: 'Tin nhắn quá dài. Tối đa 3000 ký tự.', errorCode: 'MESSAGE_TOO_LONG' };
  }

  try {
    const { data, error } = await supabase.functions.invoke('ai-tutor-chat', {
      body: {
        conversationId,
        message: message.trim(),
        mode,
        clientMessageId,
      },
    });

    if (error) {
      if (error.message?.includes('rate limit') || error.message?.includes('429')) {
        return { success: false, error: 'Bạn đã gửi quá nhanh. Hãy thử lại sau một chút.', errorCode: 'RATE_LIMITED' };
      }
      if (error.message?.includes('daily limit')) {
        return { success: false, error: 'Bạn đã hết lượt chat hôm nay. Hãy quay lại ngày mai.', errorCode: 'DAILY_LIMIT' };
      }
      if (error.message?.includes('not configured') || error.message?.includes('503')) {
        return { success: false, error: 'AI Tutor chưa được cấu hình.', errorCode: 'NOT_CONFIGURED' };
      }
      return { success: false, error: 'Lỗi kết nối. Vui lòng thử lại.', errorCode: 'NETWORK_ERROR' };
    }

    if (!data?.assistantMessage) {
      return { success: false, error: 'Không nhận được phản hồi từ AI.', errorCode: 'SERVER_ERROR' };
    }

    return { success: true, assistantMessage: data.assistantMessage as Message };
  } catch (err: any) {
    return { success: false, error: 'Lỗi kết nối. Vui lòng kiểm tra mạng.', errorCode: 'NETWORK_ERROR' };
  }
}

// ============================================
// AI FEEDBACK
// ============================================

export async function submitFeedback(messageId: string, rating: 'helpful' | 'not_helpful' | 'report', comment?: string): Promise<void> {
  const user = (await supabase.auth.getUser()).data.user;
  if (!user) return;

  await supabase.from('ai_feedback').insert({
    user_id: user.id,
    message_id: messageId,
    rating,
    comment,
  });
}

// ============================================
// HELPERS
// ============================================

function getDefaultTitle(mode: ConversationMode): string {
  const titles: Record<string, string> = {
    general: 'Trò chuyện',
    beginner: 'Bài học cơ bản',
    conversation: 'Hội thoại',
    travel: 'Du lịch',
    restaurant: 'Nhà hàng',
    shopping: 'Mua sắm',
    work: 'Công việc',
    business: 'Kinh doanh',
    interview: 'Phỏng vấn',
    hsk: 'Luyện HSK',
    free_talk: 'Nói tự do',
    grammar: 'Ngữ pháp',
  };
  return titles[mode] || 'Trò chuyện';
}

/**
 * Check if AI daily limit is reached (client-side check, server enforces too)
 */
export async function checkDailyLimit(): Promise<{ allowed: boolean; used: number; limit: number }> {
  const user = (await supabase.auth.getUser()).data.user;
  if (!user) return { allowed: false, used: 0, limit: 0 };

  const today = new Date();
  today.setHours(0, 0, 0, 0);

  const { count } = await supabase
    .from('ai_messages')
    .select('*', { count: 'exact', head: true })
    .eq('user_id', user.id)
    .eq('role', 'user')
    .gte('created_at', today.toISOString());

  const limit = 20; // Default, could fetch from ai_user_settings
  return { allowed: (count ?? 0) < limit, used: count ?? 0, limit };
}
