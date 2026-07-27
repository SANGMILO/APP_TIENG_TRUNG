import { Stack } from 'expo-router';
import { useThemeStore } from '@/stores/theme-store';

export default function ReviewLayout() {
  const { colors } = useThemeStore();
  return (
    <Stack screenOptions={{ headerShown: false, contentStyle: { backgroundColor: colors.background } }}>
      <Stack.Screen name="session" options={{ animation: 'slide_from_bottom', gestureEnabled: false }} />
      <Stack.Screen name="my-words" />
      <Stack.Screen name="mistakes" />
    </Stack>
  );
}
