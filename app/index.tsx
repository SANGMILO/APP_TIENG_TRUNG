import { useEffect } from 'react';
import { router } from 'expo-router';
import { View, ActivityIndicator, StyleSheet } from 'react-native';
import { useAuthStore } from '@/stores/auth-store';
import { useThemeStore } from '@/stores/theme-store';
import { AUTH_ROUTES, getPostAuthDestination } from '@/services/auth-navigation';

export default function Index() {
  const { session, profile, profileStatus, isLoading, isInitialized } = useAuthStore();
  const { colors } = useThemeStore();

  useEffect(() => {
    if (isLoading || !isInitialized) return;

    if (!session) {
      router.replace(AUTH_ROUTES.welcome);
      return;
    }

    if (profileStatus !== 'ready' || !profile) {
      return;
    }

    router.replace(getPostAuthDestination(profile));
  }, [session, profile, profileStatus, isLoading, isInitialized]);

  return (
    <View style={[styles.container, { backgroundColor: colors.background }]}>
      <ActivityIndicator size="large" color={colors.primary} />
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
  },
});
