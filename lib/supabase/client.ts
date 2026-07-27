import { createClient } from '@supabase/supabase-js';
import { Platform } from 'react-native';

// Environment validation
const supabaseUrl = process.env.EXPO_PUBLIC_SUPABASE_URL;
const supabaseKey = process.env.EXPO_PUBLIC_SUPABASE_PUBLISHABLE_KEY
  ?? process.env.EXPO_PUBLIC_SUPABASE_ANON_KEY;

if (!supabaseUrl) {
  throw new Error(
    '[Mandarin Master] Thiếu EXPO_PUBLIC_SUPABASE_URL. Vui lòng kiểm tra file .env.'
  );
}

if (!supabaseKey) {
  throw new Error(
    '[Mandarin Master] Thiếu EXPO_PUBLIC_SUPABASE_PUBLISHABLE_KEY. Vui lòng kiểm tra file .env.'
  );
}

// Custom storage adapter that handles SSR (no localStorage in Node)
const createStorageAdapter = () => {
  const isServer = typeof window === 'undefined';

  return {
    getItem: async (key: string): Promise<string | null> => {
      if (isServer) return null;
      if (Platform.OS === 'web') {
        return localStorage.getItem(key);
      }
      const SecureStore = await import('expo-secure-store');
      return SecureStore.getItemAsync(key);
    },
    setItem: async (key: string, value: string): Promise<void> => {
      if (isServer) return;
      if (Platform.OS === 'web') {
        localStorage.setItem(key, value);
        return;
      }
      const SecureStore = await import('expo-secure-store');
      await SecureStore.setItemAsync(key, value);
    },
    removeItem: async (key: string): Promise<void> => {
      if (isServer) return;
      if (Platform.OS === 'web') {
        localStorage.removeItem(key);
        return;
      }
      const SecureStore = await import('expo-secure-store');
      await SecureStore.deleteItemAsync(key);
    },
  };
};

export const supabase = createClient(supabaseUrl, supabaseKey, {
  auth: {
    storage: createStorageAdapter(),
    autoRefreshToken: true,
    persistSession: true,
    detectSessionInUrl: Platform.OS === 'web',
  },
});
