import { useMutation, useQueryClient } from '@tanstack/react-query';
import { supabase } from '@/lib/supabase';
import { useAuthStore } from '@/stores/auth-store';

interface AddXpParams {
  amount: number;
  reason: string;
  sourceType: string;
  sourceId?: string;
}

export function useAddXp() {
  const { user, fetchProfile } = useAuthStore();
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: async ({ amount, reason, sourceType, sourceId }: AddXpParams) => {
      if (!user) throw new Error('Not authenticated');

      const { data, error } = await supabase
        .from('xp_transactions')
        .insert({
          user_id: user.id,
          amount,
          reason,
          source_type: sourceType,
          source_id: sourceId ?? null,
        })
        .select()
        .single();

      if (error) throw error;
      return data;
    },
    onSuccess: () => {
      // Refresh profile to get updated XP total
      fetchProfile();
      queryClient.invalidateQueries({ queryKey: ['xp-transactions'] });
    },
  });
}

interface AddCoinsParams {
  amount: number;
  reason: string;
  sourceType: string;
  sourceId?: string;
}

export function useAddCoins() {
  const { user, fetchProfile } = useAuthStore();

  return useMutation({
    mutationFn: async ({ amount, reason, sourceType, sourceId }: AddCoinsParams) => {
      if (!user) throw new Error('Not authenticated');

      const { data, error } = await supabase
        .from('coin_transactions')
        .insert({
          user_id: user.id,
          amount,
          reason,
          source_type: sourceType,
          source_id: sourceId ?? null,
        })
        .select()
        .single();

      if (error) throw error;
      return data;
    },
    onSuccess: () => {
      fetchProfile();
    },
  });
}
