// Mandarin Master Design System
// "Modern Chinese Immersive Learning" — premium, cultural, game-like
// Primary: Chinese Vermilion Red | Accent: Gold, Jade Green, Warm Orange
// Dark: Deep Navy / Charcoal | NO pure white backgrounds

export const Colors = {
  light: {
    // Brand — Stitch Material 3 tokens
    primary: '#AC001E',
    primaryLight: '#D90429',
    primaryDark: '#930018',
    secondary: '#D4AF37',
    secondaryLight: '#F5D042',
    secondaryDark: '#B8860B',
    jade: '#205E44',
    jadeLight: '#95D4B3',
    warmOrange: '#EA580C',

    // Surfaces — Stitch tokens
    background: '#FCF9F8',
    surface: '#FCF9F8',
    surfaceElevated: '#F6F3F2',
    surfaceMuted: '#F0EDED',

    // Text — Stitch tokens
    text: '#1B1B1B',
    textSecondary: '#5E5F5D',
    textTertiary: '#926E6C',
    textOnPrimary: '#FFFFFF',
    textOnDark: '#FAFAF9',

    // Borders — Stitch tokens
    border: '#E5E2E1',
    borderLight: '#EAE7E7',
    borderFocus: '#AC001E',

    // Semantic
    success: '#205E44',
    successLight: '#B1F0CE',
    warning: '#D97706',
    warningLight: '#FEF3C7',
    error: '#BA1A1A',
    errorLight: '#FFDAD6',
    info: '#2563EB',
    infoLight: '#DBEAFE',

    // Gamification
    xp: '#7C3AED',
    xpLight: '#EDE9FE',
    streak: '#AC001E',
    streakLight: '#FFDAD7',
    heart: '#AC001E',
    heartLight: '#FFDAD7',
    coin: '#D4AF37',
    coinLight: '#FEF9C3',
    level: '#0891B2',
    levelLight: '#CFFAFE',

    // UI — Stitch tokens
    skeleton: '#E5E2E1',
    overlay: 'rgba(27, 27, 27, 0.6)',
    card: '#FFFFFF',
    cardHover: '#F6F3F2',
    tabBar: '#FCF9F8',
    tabBarBorder: '#E7BCBA',
    glass: 'rgba(252, 249, 248, 0.85)',
    glassBorder: 'rgba(229, 226, 225, 0.4)',

    // Gradients — updated to Stitch primary
    gradientPrimary: ['#AC001E', '#D90429'],
    gradientGold: ['#D4AF37', '#F5D042'],
    gradientJade: ['#205E44', '#3B775B'],
    gradientPurple: ['#7C3AED', '#9333EA'],
    gradientBlue: ['#2563EB', '#3B82F6'],
    gradientWarm: ['#EA580C', '#F97316'],
    gradientSunset: ['#AC001E', '#D90429', '#D4AF37'],
    gradientNight: ['#1B1B1B', '#313030', '#44403C'],
    gradientHero: ['#AC001E', '#D90429', '#EA580C'],

    // Legacy compatibility — remove only after all screens migrated
    gradientSecondary: ['#D4AF37', '#F5D042'],
    gradientSuccess: ['#205E44', '#3B775B'],
  },
  dark: {
    primary: '#FFB3AF',
    primaryLight: '#FFDAD7',
    primaryDark: '#930018',
    secondary: '#F5D042',
    secondaryLight: '#FBBF24',
    secondaryDark: '#D4AF37',
    jade: '#95D4B3',
    jadeLight: '#B1F0CE',
    warmOrange: '#FB923C',

    background: '#1B1B1B',
    surface: '#1B1B1B',
    surfaceElevated: '#313030',
    surfaceMuted: '#44403C',

    text: '#F3F0EF',
    textSecondary: '#C7C6C4',
    textTertiary: '#926E6C',
    textOnPrimary: '#410005',
    textOnDark: '#F3F0EF',

    border: '#44403C',
    borderLight: '#313030',
    borderFocus: '#FFB3AF',

    success: '#95D4B3',
    successLight: '#0E5138',
    warning: '#FBBF24',
    warningLight: '#78350F',
    error: '#FFB4AB',
    errorLight: '#93000A',
    info: '#60A5FA',
    infoLight: '#1E3A5F',

    xp: '#A78BFA',
    xpLight: '#2E1065',
    streak: '#FFB3AF',
    streakLight: '#410005',
    heart: '#FFB3AF',
    heartLight: '#410005',
    coin: '#F5D042',
    coinLight: '#422006',
    level: '#22D3EE',
    levelLight: '#083344',

    skeleton: '#44403C',
    overlay: 'rgba(0, 0, 0, 0.8)',
    card: '#313030',
    cardHover: '#44403C',
    tabBar: '#1B1B1B',
    tabBarBorder: '#44403C',
    glass: 'rgba(27, 27, 27, 0.85)',
    glassBorder: 'rgba(68, 64, 60, 0.5)',

    gradientPrimary: ['#930018', '#AC001E'],
    gradientGold: ['#B8860B', '#D4AF37'],
    gradientJade: ['#0E5138', '#205E44'],
    gradientPurple: ['#6D28D9', '#7C3AED'],
    gradientBlue: ['#1D4ED8', '#2563EB'],
    gradientWarm: ['#C2410C', '#EA580C'],
    gradientSunset: ['#930018', '#AC001E', '#D4AF37'],
    gradientNight: ['#0C0A09', '#1B1B1B', '#313030'],
    gradientHero: ['#1B1B1B', '#313030', '#44403C'],

    // Legacy compatibility
    gradientSecondary: ['#B8860B', '#D4AF37'],
    gradientSuccess: ['#0E5138', '#205E44'],
  },
} as const;

export const Spacing = {
  xs: 4,
  sm: 8,
  md: 12,
  lg: 16,
  xl: 20,
  '2xl': 24,
  '3xl': 32,
  '4xl': 40,
  '5xl': 48,
  '6xl': 64,
  '7xl': 80,
  '8xl': 96,
} as const;

export const FontSize = {
  '2xs': 10,
  xs: 11,
  sm: 13,
  md: 14,
  base: 16,
  lg: 18,
  xl: 20,
  '2xl': 24,
  '3xl': 30,
  '4xl': 36,
  '5xl': 48,
  '6xl': 60,
  chinese: 32,
  chineseLarge: 48,
  chineseHero: 72,
  pinyin: 14,
} as const;

export const FontFamily = {
  regular: 'Inter_400Regular',
  medium: 'Inter_500Medium',
  semibold: 'Inter_600SemiBold',
  bold: 'Inter_700Bold',
  heading: 'Montserrat_700Bold',
  chinese: 'NotoSansSC_500Medium',
  // System fallbacks used before fonts load
  system: 'System',
} as const;

export const FontWeight = {
  regular: '400' as const,
  medium: '500' as const,
  semibold: '600' as const,
  bold: '700' as const,
  extrabold: '800' as const,
  black: '900' as const,
} as const;

export const BorderRadius = {
  xs: 4,
  sm: 6,
  md: 10,
  lg: 14,
  xl: 18,
  '2xl': 22,
  '3xl': 28,
  '4xl': 32,
  full: 9999,
} as const;

export const Shadow = {
  xs: {
    shadowColor: '#BF0022',
    shadowOffset: { width: 0, height: 1 },
    shadowOpacity: 0.04,
    shadowRadius: 4,
    elevation: 1,
  },
  sm: {
    shadowColor: '#BF0022',
    shadowOffset: { width: 0, height: 4 },
    shadowOpacity: 0.05,
    shadowRadius: 20,
    elevation: 2,
  },
  md: {
    shadowColor: '#BF0022',
    shadowOffset: { width: 0, height: 6 },
    shadowOpacity: 0.08,
    shadowRadius: 24,
    elevation: 4,
  },
  lg: {
    shadowColor: '#BF0022',
    shadowOffset: { width: 0, height: 8 },
    shadowOpacity: 0.12,
    shadowRadius: 32,
    elevation: 8,
  },
  xl: {
    shadowColor: '#BF0022',
    shadowOffset: { width: 0, height: 16 },
    shadowOpacity: 0.16,
    shadowRadius: 40,
    elevation: 12,
  },
  glow: (color: string) => ({
    shadowColor: color,
    shadowOffset: { width: 0, height: 4 },
    shadowOpacity: 0.35,
    shadowRadius: 12,
    elevation: 6,
  }),
  colored: (color: string) => ({
    shadowColor: color,
    shadowOffset: { width: 0, height: 4 },
    shadowOpacity: 0.3,
    shadowRadius: 10,
    elevation: 4,
  }),
} as const;

export const ZIndex = {
  base: 0,
  dropdown: 10,
  sticky: 20,
  overlay: 30,
  modal: 40,
  popover: 50,
  toast: 60,
} as const;

export const Animation = {
  instant: 100,
  fast: 150,
  normal: 250,
  slow: 400,
  slower: 600,
  spring: { damping: 15, stiffness: 150 },
  springBouncy: { damping: 8, stiffness: 200 },
  springGentle: { damping: 20, stiffness: 100 },
} as const;

export type ThemeMode = 'light' | 'dark';

export interface ColorScheme {
  // Brand
  primary: string;
  primaryLight: string;
  primaryDark: string;
  secondary: string;
  secondaryLight: string;
  secondaryDark: string;
  jade: string;
  jadeLight: string;
  warmOrange: string;

  // Surfaces
  background: string;
  surface: string;
  surfaceElevated: string;
  surfaceMuted: string;

  // Text
  text: string;
  textSecondary: string;
  textTertiary: string;
  textOnPrimary: string;
  textOnDark: string;

  // Borders
  border: string;
  borderLight: string;
  borderFocus: string;

  // Semantic
  success: string;
  successLight: string;
  warning: string;
  warningLight: string;
  error: string;
  errorLight: string;
  info: string;
  infoLight: string;

  // Gamification
  xp: string;
  xpLight: string;
  streak: string;
  streakLight: string;
  heart: string;
  heartLight: string;
  coin: string;
  coinLight: string;
  level: string;
  levelLight: string;

  // UI
  skeleton: string;
  overlay: string;
  card: string;
  cardHover: string;
  tabBar: string;
  tabBarBorder: string;
  glass: string;
  glassBorder: string;

  // Gradients — new premium
  gradientPrimary: readonly string[];
  gradientGold: readonly string[];
  gradientJade: readonly string[];
  gradientPurple: readonly string[];
  gradientBlue: readonly string[];
  gradientWarm: readonly string[];
  gradientSunset: readonly string[];
  gradientNight: readonly string[];
  gradientHero: readonly string[];

  // Legacy compatibility — remove only after all screens migrated
  gradientSecondary: readonly string[];
  gradientSuccess: readonly string[];
}
