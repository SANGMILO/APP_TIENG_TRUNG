import React from 'react';
import { View, StyleSheet, ViewStyle, ImageBackground, ImageSourcePropType } from 'react-native';
import { LinearGradient } from 'expo-linear-gradient';
import { useSafeAreaInsets } from 'react-native-safe-area-context';
import { useThemeStore } from '@/stores/theme-store';

type BackgroundVariant = 'default' | 'warm' | 'hero' | 'dark' | 'lesson';

interface AppBackgroundProps {
  variant?: BackgroundVariant;
  children: React.ReactNode;
  imageSource?: ImageSourcePropType;
  overlay?: boolean;
  safeArea?: boolean;
  style?: ViewStyle;
}

/**
 * Premium app background — warm Chinese-inspired, no pure white.
 * Supports gradient overlay, optional background image (graceful fallback),
 * and multiple variants for different screen contexts.
 */
export function AppBackground({
  variant = 'default',
  children,
  imageSource,
  overlay = false,
  safeArea = false,
  style,
}: AppBackgroundProps) {
  const { colors, mode } = useThemeStore();
  const insets = useSafeAreaInsets();

  const getBackgroundColor = (): string => {
    switch (variant) {
      case 'default': return colors.background;
      case 'warm': return colors.background;
      case 'hero': return mode === 'dark' ? '#0C0A09' : '#FDF8F4';
      case 'dark': return mode === 'dark' ? '#0C0A09' : '#1C1917';
      case 'lesson': return colors.background;
      default: return colors.background;
    }
  };

  const getOverlayColors = (): [string, string] | null => {
    if (!overlay && variant === 'default') return null;
    switch (variant) {
      case 'hero':
        return mode === 'dark'
          ? ['rgba(12,10,9,0.3)', 'rgba(12,10,9,0)']
          : ['rgba(253,248,244,0.3)', 'rgba(253,248,244,0)'];
      case 'dark':
        return ['rgba(28,25,23,0.7)', 'rgba(28,25,23,0.4)'];
      case 'lesson':
        return mode === 'dark'
          ? ['rgba(12,10,9,0.2)', 'rgba(12,10,9,0)']
          : ['rgba(253,248,244,0.2)', 'rgba(253,248,244,0)'];
      default:
        return null;
    }
  };

  const containerStyle: ViewStyle[] = [
    styles.container,
    { backgroundColor: getBackgroundColor() },
    safeArea ? { paddingTop: insets.top, paddingBottom: insets.bottom } : undefined,
    style,
  ].filter(Boolean) as ViewStyle[];

  const overlayColors = getOverlayColors();

  // With background image
  if (imageSource) {
    return (
      <ImageBackground
        source={imageSource}
        style={containerStyle}
        imageStyle={styles.bgImage}
        resizeMode="cover"
      >
        {overlayColors && (
          <LinearGradient
            colors={overlayColors}
            style={StyleSheet.absoluteFill}
          />
        )}
        {children}
      </ImageBackground>
    );
  }

  // Without image — solid or gradient
  return (
    <View style={containerStyle}>
      {overlayColors && (
        <LinearGradient
          colors={overlayColors}
          style={StyleSheet.absoluteFill}
          pointerEvents="none"
        />
      )}
      {children}
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
  },
  bgImage: {
    opacity: 0.15,
  },
});
