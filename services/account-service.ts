import { supabase } from '@/lib/supabase';

export type AccountDeletionStatus =
  | 'pending'
  | 'processing'
  | 'completed'
  | 'cancelled'
  | 'rejected';

export interface AccountDeletionRequest {
  request_id: string;
  status: AccountDeletionStatus;
  requested_at: string;
  already_requested: boolean;
}

export async function requestAccountDeletion(
  confirmation: string,
): Promise<AccountDeletionRequest> {
  const { data, error } = await supabase.rpc('request_account_deletion', {
    p_confirmation: confirmation,
  });

  if (error) throw error;
  if (
    !data
    || data.success !== true
    || typeof data.request_id !== 'string'
    || !['pending', 'processing', 'completed', 'cancelled', 'rejected']
      .includes(String(data.status))
    || typeof data.requested_at !== 'string'
    || typeof data.already_requested !== 'boolean'
  ) {
    throw new Error('The account deletion request response was invalid.');
  }

  return data as AccountDeletionRequest;
}
