import { Stack, Redirect } from 'expo-router';
import { useThemeStore } from '@/stores/theme-store';
import { useAuthStore } from '@/stores/auth-store';
import { canAccessAdmin } from '@/services/admin-service';

export default function AdminLayout() {
  const { colors } = useThemeStore();
  const { profile } = useAuthStore();

  // Route protection: only admin roles can access
  if (!profile || !canAccessAdmin(profile.role)) {
    return <Redirect href="/(tabs)/learn" />;
  }

  return (
    <Stack screenOptions={{ headerShown: false, contentStyle: { backgroundColor: colors.background } }}>
      <Stack.Screen name="index" />
      <Stack.Screen name="courses" />
      <Stack.Screen name="vocabulary" />
      <Stack.Screen name="users" />
      <Stack.Screen name="analytics" />
      <Stack.Screen name="audit" />
    </Stack>
  );
}
