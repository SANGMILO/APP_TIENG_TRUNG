import React from 'react';
import { View, Text, StyleSheet, Image, ImageSourcePropType } from 'react-native';
import { LinearGradient } from 'expo-linear-gradient';
import { useThemeStore } from '@/stores/theme-store';
import { FontSize, FontWeight, Shadow } from '@/constants/theme';

type AvatarSize = 'xs' | 'sm' | 'md' | 'lg' | 'xl' | '2xl';

interface AvatarProps {
  name?: string;
  source?: ImageSourcePropType | null;
  size?: AvatarSize;
  showBorder?: boolean;
  badge?: React.ReactNode;
}

export function Avatar({
  name,
  source,
  size = 'md',
  showBorder = false,
  badge,
}: AvatarProps) {
  const { colors } = useThemeStore();

  const getDimension = (): number => {
    switch (size) {
      case 'xs': return 28;
      case 'sm': return 36;
      case 'md': return 48;
      case 'lg': return 64;
      case 'xl': return 80;
      case '2xl': return 100;
      default: return 48;
    }
  };

  const getFontSize = (): number => {
    switch (size) {
      case 'xs': return FontSize.xs;
      case 'sm': return FontSize.sm;
      case 'md': return FontSize.lg;
      case 'lg': return FontSize['2xl'];
      case 'xl': return FontSize['3xl'];
      case '2xl': return FontSize['4xl'];
      default: return FontSize.lg;
    }
  };

  const dimension = getDimension();
  const initials = name
    ? name.split(' ').map(n => n[0]).join('').toUpperCase().slice(0, 2)
    : '?';

  return (
    <View style={[styles.wrapper, { width: dimension, height: dimension }]}>
      {source ? (
        <Image
          source={source}
          style={[
            styles.image,
            {
              width: dimension,
              height: dimension,
              borderRadius: dimension / 2,
            },
            showBorder && { borderWidth: 3, borderColor: colors.surface },
          ]}
        />
      ) : (
        <LinearGradient
          colors={colors.gradientPrimary as unknown as [string, string]}
          start={{ x: 0, y: 0 }}
          end={{ x: 1, y: 1 }}
          style={[
            styles.fallback,
            {
              width: dimension,
              height: dimension,
              borderRadius: dimension / 2,
            },
            showBorder && { borderWidth: 3, borderColor: colors.surface },
            Shadow.md,
          ]}
        >
          <Text style={[styles.initials, { fontSize: getFontSize() }]}>
            {initials}
          </Text>
        </LinearGradient>
      )}
      {badge && (
        <View style={[styles.badge, { borderColor: colors.surface }]}>
          {badge}
        </View>
      )}
    </View>
  );
}

const styles = StyleSheet.create({
  wrapper: {
    position: 'relative',
  },
  image: {
    resizeMode: 'cover',
  },
  fallback: {
    justifyContent: 'center',
    alignItems: 'center',
  },
  initials: {
    color: '#FFFFFF',
    fontWeight: FontWeight.bold,
    letterSpacing: 0.5,
  },
  badge: {
    position: 'absolute',
    bottom: -2,
    right: -2,
    borderWidth: 2,
    borderRadius: 999,
  },
});
