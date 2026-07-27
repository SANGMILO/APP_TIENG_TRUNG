import { Stack } from 'expo-router';
import { useThemeStore } from '@/stores/theme-store';

export default function PronunciationLayout() {
  const { colors } = useThemeStore();
  return (
    <Stack screenOptions={{ headerShown: false, contentStyle: { backgroundColor: colors.background } }}>
      <Stack.Screen name="index" />
      <Stack.Screen name="practice" options={{ animation: 'slide_from_bottom' }} />
      <Stack.Screen name="tone-training" />
      <Stack.Screen name="history" />
    </Stack>
  );
}
