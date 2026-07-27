import { Stack } from 'expo-router';
import { useThemeStore } from '@/stores/theme-store';

export default function VideosLayout() {
  const { colors } = useThemeStore();
  return (
    <Stack screenOptions={{ headerShown: false, contentStyle: { backgroundColor: colors.background } }}>
      <Stack.Screen name="[id]" />
    </Stack>
  );
}
