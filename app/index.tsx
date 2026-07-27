import { useEffect } from 'react';
import { router } from 'expo-router';
import { View, ActivityIndicator, StyleSheet } from 'react-native';
import { useAuthStore } from '@/stores/auth-store';
import { useThemeStore } from '@/stores/theme-store';

export default function Index() {
  const { session, profile, isLoading } = useAuthStore();
  const { colors } = useThemeStore();

  useEffect(() => {
    if (isLoading) return;

    if (!session) {
      router.replace('/(auth)/welcome');
      return;
    }

    if (profile && !profile.onboarding_completed) {
      router.replace('/onboarding');
      return;
    }

    router.replace('/(tabs)/learn');
  }, [session, profile, isLoading]);

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
