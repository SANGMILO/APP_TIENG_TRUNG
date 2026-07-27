/**
 * Mandarin Master — Typed Asset Mapping
 *
 * Visual direction: Modern Chinese Luxury
 * - Refined, spacious, editorial
 * - East Asian contemporary design
 * - Warm Ivory, Vermilion, Deep Jade, Champagne Gold, Deep Charcoal
 *
 * RULES:
 * - Never bake text into image assets
 * - All text rendered by React Native for localization/accessibility
 * - Support graceful fallback when asset doesn't exist
 * - Use expo-image with caching where appropriate
 * - Mobile-optimized sizes (max ~1200px wide)
 */

import { ImageSourcePropType } from 'react-native';

// ─── Brand ───

export interface BrandAssets {
  /** Abstract single-line dragon emblem. Minimal premium mark. */
  dragonMark?: ImageSourcePropType;
  /** App logo wordmark */
  wordmark?: ImageSourcePropType;
  /** Monochrome icon for splash/loading */
  monoIcon?: ImageSourcePropType;
}

export const brandAssets: BrandAssets = {
  // Assets to be provided — fallback to Chinese character "中" rendered in code
};

// ─── Backgrounds ───

export type BackgroundKey =
  | 'welcomeHero'
  | 'authGradient'
  | 'learnAmbient'
  | 'lessonSurface'
  | 'profileHeader'
  | 'chinesePattern';

export const backgroundAssets: Partial<Record<BackgroundKey, ImageSourcePropType>> = {
  // Assets to be provided — screens use gradient fallback when undefined
};

// ─── Course Worlds ───

export interface CourseWorldAsset {
  /** Background illustration for the unit/chapter. No text. */
  background?: ImageSourcePropType;
  /** Gradient fallback colors when image unavailable */
  fallbackGradient: [string, string];
  /** Optional ambient overlay color */
  overlayColor?: string;
}

export type CourseWorldKey =
  | 'modern-suzhou'
  | 'shanghai-night'
  | 'food-street'
  | 'travel-china'
  | 'campus';

export const courseWorldAssets: Record<CourseWorldKey, CourseWorldAsset> = {
  'modern-suzhou': { fallbackGradient: ['#1C1917', '#44403C'] },
  'shanghai-night': { fallbackGradient: ['#0C0A09', '#1C1917'] },
  'food-street': { fallbackGradient: ['#7C2D12', '#EA580C'] },
  'travel-china': { fallbackGradient: ['#164E63', '#0891B2'] },
  'campus': { fallbackGradient: ['#1E3A5F', '#2563EB'] },
};

// ─── AI Tutor Scenarios ───

export interface ScenarioAsset {
  /** Premium image for scenario card. No text. */
  image?: ImageSourcePropType;
  /** Gradient fallback */
  fallbackGradient: [string, string];
}

export type ScenarioKey = 'restaurant' | 'travel' | 'general' | 'work' | 'hsk' | 'grammar';

export const scenarioAssets: Record<ScenarioKey, ScenarioAsset> = {
  restaurant: { fallbackGradient: ['#D72638', '#EF4444'] },
  travel: { fallbackGradient: ['#2563EB', '#3B82F6'] },
  general: { fallbackGradient: ['#059669', '#2D8B6F'] },
  work: { fallbackGradient: ['#D4A017', '#F5D042'] },
  hsk: { fallbackGradient: ['#7C3AED', '#9333EA'] },
  grammar: { fallbackGradient: ['#EA580C', '#F97316'] },
};

// ─── Video Thumbnails ───

export interface VideoThumbnailFallback {
  /** Gradient colors for premium placeholder when no thumbnail */
  gradient: [string, string];
}

export const videoThumbnailFallback: VideoThumbnailFallback = {
  gradient: ['#1C1917', '#44403C'],
};

// ─── Achievements ───

export interface AchievementAsset {
  /** Premium badge image. If undefined, fall back to DB emoji in styled container. */
  image?: ImageSourcePropType;
}

// Achievement assets keyed by achievement slug/id from DB
export const achievementAssets: Record<string, AchievementAsset> = {
  // Will be populated as custom badge assets are created
};

// ─── Onboarding ───

export interface OnboardingSlideAsset {
  /** Illustration for onboarding step. No text baked in. */
  image?: ImageSourcePropType;
  fallbackGradient: [string, string];
}

export const onboardingAssets: OnboardingSlideAsset[] = [
  { fallbackGradient: ['#D72638', '#EF4444'] }, // Purpose
  { fallbackGradient: ['#059669', '#2D8B6F'] }, // Duration
  { fallbackGradient: ['#D4A017', '#F5D042'] }, // Level
];

// ─── Decorative Patterns ───

export interface PatternAsset {
  /** Low-opacity decorative overlay. Chinese cloud/wave/seal motif. */
  source?: ImageSourcePropType;
  /** Opacity to apply (0.02–0.08 range) */
  opacity: number;
}

export const patternAssets: Record<string, PatternAsset> = {
  clouds: { opacity: 0.03 },
  waves: { opacity: 0.04 },
  seal: { opacity: 0.02 },
  silk: { opacity: 0.03 },
};

// ─── Helper ───

/**
 * Safely get an image source or return undefined for fallback rendering.
 * Use this to avoid crashing on missing assets.
 */
export function getAssetOrNull(asset: ImageSourcePropType | undefined): ImageSourcePropType | null {
  return asset ?? null;
}
