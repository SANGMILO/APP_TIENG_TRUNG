export interface ConversationAuthorizationRecord {
  id: string;
  user_id: string;
  mode: string;
  status: string;
}

export type ConversationAuthorizationResult =
  | { authorized: true; mode: string }
  | {
      authorized: false;
      status: 400 | 403;
      error: string;
      errorCode: 'CONVERSATION_FORBIDDEN' | 'MODE_MISMATCH';
    };

/**
 * Authorize a service-role conversation operation against the authenticated
 * user before any messages or metadata are read or written.
 *
 * Missing, deleted, and foreign conversations intentionally return the same
 * result so the caller does not disclose whether another user's UUID exists.
 */
export function authorizeAiConversation(
  authenticatedUserId: string,
  requestedMode: string | undefined,
  conversation: ConversationAuthorizationRecord | null,
): ConversationAuthorizationResult {
  if (
    !conversation
    || conversation.user_id !== authenticatedUserId
    || conversation.status === 'deleted'
  ) {
    return {
      authorized: false,
      status: 403,
      error: 'Conversation unavailable',
      errorCode: 'CONVERSATION_FORBIDDEN',
    };
  }

  if (requestedMode && requestedMode !== conversation.mode) {
    return {
      authorized: false,
      status: 400,
      error: 'Conversation mode mismatch',
      errorCode: 'MODE_MISMATCH',
    };
  }

  return { authorized: true, mode: conversation.mode };
}
