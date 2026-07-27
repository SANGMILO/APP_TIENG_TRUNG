/**
 * Font loading hook for Stitch design system fonts.
 * Loads Montserrat (headings), Inter (body/UI), and Noto Sans SC (Chinese characters).
 * Provides graceful fallback to system fonts while loading.
 */

import { useFonts as useExpoFonts } from 'expo-font';
import {
  Inter_400Regular,
  Inter_500Medium,
  Inter_600SemiBold,
  Inter_700Bold,
} from '@expo-google-fonts/inter';
import {
  Montserrat_700Bold,
} from '@expo-google-fonts/montserrat';
import {
  NotoSansSC_500Medium,
} from '@expo-google-fonts/noto-sans-sc';

export function useAppFonts(): [boolean, Error | null] {
  const [fontsLoaded, fontError] = useExpoFonts({
    Inter_400Regular,
    Inter_500Medium,
    Inter_600SemiBold,
    Inter_700Bold,
    Montserrat_700Bold,
    NotoSansSC_500Medium,
  });

  return [fontsLoaded, fontError];
}
