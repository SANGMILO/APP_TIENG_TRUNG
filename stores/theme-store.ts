import { create } from 'zustand';
import { Appearance, ColorSchemeName } from 'react-native';
import { ThemeMode, Colors, ColorScheme } from '@/constants/theme';

interface ThemeState {
  mode: ThemeMode;
  colors: ColorScheme;
  systemTheme: ColorSchemeName;

  setMode: (mode: ThemeMode) => void;
  toggleMode: () => void;
  followSystem: () => void;
}

const getColors = (mode: ThemeMode): ColorScheme => {
  return mode === 'dark' ? Colors.dark : Colors.light;
};

export const useThemeStore = create<ThemeState>((set) => {
  const systemTheme = Appearance.getColorScheme() ?? 'light';
  const initialMode: ThemeMode = systemTheme === 'dark' ? 'dark' : 'light';

  return {
    mode: initialMode,
    colors: getColors(initialMode),
    systemTheme,

    setMode: (mode) => {
      set({ mode, colors: getColors(mode) });
    },

    toggleMode: () => {
      set((state) => {
        const newMode = state.mode === 'light' ? 'dark' : 'light';
        return { mode: newMode, colors: getColors(newMode) };
      });
    },

    followSystem: () => {
      const system = Appearance.getColorScheme() ?? 'light';
      const mode: ThemeMode = system === 'dark' ? 'dark' : 'light';
      set({ mode, colors: getColors(mode), systemTheme: system });
    },
  };
});
