import { useThemeStore } from '@/stores/theme-store';

export function useColors() {
  return useThemeStore((state) => state.colors);
}

export function useThemeMode() {
  return useThemeStore((state) => state.mode);
}
