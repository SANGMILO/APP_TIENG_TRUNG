import { Stack } from 'expo-router';
import { useThemeStore } from '@/stores/theme-store';

export default function GamificationLayout() {
  const { colors } = useThemeStore();
  return (
    <Stack screenOptions={{ headerShown: false, contentStyle: { backgroundColor: colors.background } }}>
      <Stack.Screen name="leaderboard" />
      <Stack.Screen name="achievements" />
      <Stack.Screen name="shop" />
    </Stack>
  );
}
