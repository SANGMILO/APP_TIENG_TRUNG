import { useEffect } from 'react';
import { Stack } from 'expo-router';
import { StatusBar } from 'expo-status-bar';
import { QueryClient, QueryClientProvider } from '@tanstack/react-query';
import { useThemeStore } from '@/stores/theme-store';
import { useAuthStore } from '@/stores/auth-store';
import { useAppFonts } from '@/hooks/useFonts';

const queryClient = new QueryClient({
  defaultOptions: {
    queries: {
      staleTime: 1000 * 60 * 5, // 5 minutes
      retry: 2,
    },
  },
});

export default function RootLayout() {
  const { mode, colors } = useThemeStore();
  const { initialize, isInitialized } = useAuthStore();
  const [fontsLoaded] = useAppFonts();

  useEffect(() => {
    initialize();
  }, []);

  if (!isInitialized || !fontsLoaded) {
    return null; // Show splash screen while fonts + auth load
  }

  return (
    <QueryClientProvider client={queryClient}>
      <StatusBar style={mode === 'dark' ? 'light' : 'dark'} />
      <Stack
        screenOptions={{
          headerShown: false,
          contentStyle: { backgroundColor: colors.background },
          animation: 'slide_from_right',
        }}
      >
        <Stack.Screen name="index" />
        <Stack.Screen name="(auth)" options={{ animation: 'fade' }} />
        <Stack.Screen name="onboarding" options={{ animation: 'fade' }} />
        <Stack.Screen name="(tabs)" options={{ animation: 'fade' }} />
        <Stack.Screen
          name="lesson/[id]"
          options={{ animation: 'slide_from_bottom', gestureEnabled: false }}
        />
        <Stack.Screen name="review" options={{ headerShown: false }} />
        <Stack.Screen name="pronunciation" options={{ headerShown: false }} />
        <Stack.Screen name="videos" options={{ headerShown: false }} />
        <Stack.Screen name="ai-chat" options={{ animation: 'slide_from_right' }} />
        <Stack.Screen name="ai-tutor" options={{ headerShown: false }} />
        <Stack.Screen name="gamification" options={{ headerShown: false }} />
        <Stack.Screen name="admin" options={{ headerShown: false }} />
        <Stack.Screen name="privacy" />
        <Stack.Screen name="delete-account" />
      </Stack>
    </QueryClientProvider>
  );
}
