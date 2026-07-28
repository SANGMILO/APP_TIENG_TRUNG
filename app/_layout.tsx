import { useEffect, useState } from 'react';
import { Stack } from 'expo-router';
import { StatusBar } from 'expo-status-bar';
import * as SplashScreen from 'expo-splash-screen';
import * as WebBrowser from 'expo-web-browser';
import { ActivityIndicator, StyleSheet, Text, View } from 'react-native';
import { QueryClient, QueryClientProvider } from '@tanstack/react-query';
import { useThemeStore } from '@/stores/theme-store';
import { useAuthStore } from '@/stores/auth-store';
import { useAppFonts } from '@/hooks/useFonts';
import { AuthGuard } from '@/components/auth/AuthGuard';
import { Button } from '@/components/ui';
import { FontFamily, FontSize, Spacing } from '@/constants/theme';
import { isBootstrapReady } from '@/services/bootstrap';

void SplashScreen.preventAutoHideAsync().catch(() => {
  // The web runtime may not expose a native splash screen.
});
WebBrowser.maybeCompleteAuthSession();

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
  const {
    initialize,
    isInitialized,
    isLoading,
    initializationError,
  } = useAuthStore();
  const [fontsLoaded, fontError] = useAppFonts();
  const [fontTimedOut, setFontTimedOut] = useState(false);

  useEffect(() => {
    void initialize();
  }, [initialize]);

  useEffect(() => {
    if (fontsLoaded || fontError) {
      return;
    }

    const timeout = setTimeout(() => setFontTimedOut(true), 8000);
    return () => clearTimeout(timeout);
  }, [fontError, fontsLoaded]);

  const bootstrapReady = isBootstrapReady({
    isAuthInitialized: isInitialized,
    fontsLoaded,
    fontError,
    fontTimedOut,
  });

  useEffect(() => {
    if (bootstrapReady) {
      void SplashScreen.hideAsync().catch(() => {
        // Nothing else is required when the native splash is already hidden.
      });
    }
  }, [bootstrapReady]);

  if (!bootstrapReady) {
    return null;
  }

  if (initializationError) {
    return (
      <View style={[styles.bootstrapContainer, { backgroundColor: colors.background }]}>
        <Text style={[styles.bootstrapTitle, { color: colors.text }]}>
          Không thể khởi tạo ứng dụng
        </Text>
        <Text style={[styles.bootstrapMessage, { color: colors.textSecondary }]}>
          {initializationError}
        </Text>
        <Button
          title="Thử lại"
          variant="primary"
          size="lg"
          loading={isLoading}
          onPress={() => void initialize()}
        />
      </View>
    );
  }

  return (
    <QueryClientProvider client={queryClient}>
      <StatusBar style={mode === 'dark' ? 'light' : 'dark'} />
      <AuthGuard />
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
        <Stack.Screen name="terms" />
        <Stack.Screen name="delete-account" />
      </Stack>
    </QueryClientProvider>
  );
}

const styles = StyleSheet.create({
  bootstrapContainer: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
    paddingHorizontal: Spacing['2xl'],
  },
  bootstrapTitle: {
    fontFamily: FontFamily.heading,
    fontSize: FontSize['2xl'],
    textAlign: 'center',
    marginBottom: Spacing.md,
  },
  bootstrapMessage: {
    fontFamily: FontFamily.regular,
    fontSize: FontSize.base,
    lineHeight: 24,
    textAlign: 'center',
    marginBottom: Spacing['2xl'],
  },
});
