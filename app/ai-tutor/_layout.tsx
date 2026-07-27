import { Stack } from 'expo-router';
import { useThemeStore } from '@/stores/theme-store';

export default function AiTutorLayout() {
  const { colors } = useThemeStore();
  return (
    <Stack screenOptions={{ headerShown: false, contentStyle: { backgroundColor: colors.background } }}>
      <Stack.Screen name="voice" options={{ animation: 'slide_from_bottom', gestureEnabled: false }} />
    </Stack>
  );
}
