import React from 'react';
import {
  TouchableOpacity,
  Text,
  StyleSheet,
  ActivityIndicator,
  ViewStyle,
  TextStyle,
  TouchableOpacityProps,
  View,
} from 'react-native';
import { LinearGradient } from 'expo-linear-gradient';
import { useThemeStore } from '@/stores/theme-store';
import { BorderRadius, FontSize, Spacing, Shadow, FontWeight } from '@/constants/theme';

type ButtonVariant = 'primary' | 'secondary' | 'outline' | 'ghost' | 'danger' | 'gradient' | 'soft';
type ButtonSize = 'xs' | 'sm' | 'md' | 'lg' | 'xl';

interface ButtonProps extends TouchableOpacityProps {
  title: string;
  variant?: ButtonVariant;
  size?: ButtonSize;
  loading?: boolean;
  icon?: React.ReactNode;
  iconRight?: React.ReactNode;
  fullWidth?: boolean;
  rounded?: boolean;
}

export function Button({
  title,
  variant = 'primary',
  size = 'md',
  loading = false,
  icon,
  iconRight,
  fullWidth = false,
  rounded = false,
  disabled,
  style,
  ...props
}: ButtonProps) {
  const { colors } = useThemeStore();

  const getBackgroundColor = (): string => {
    if (disabled) return colors.surfaceElevated;
    switch (variant) {
      case 'primary': return colors.primary;
      case 'secondary': return colors.secondary;
      case 'outline': return 'transparent';
      case 'ghost': return 'transparent';
      case 'danger': return colors.error;
      case 'soft': return colors.primaryLight + '15';
      case 'gradient': return 'transparent';
      default: return colors.primary;
    }
  };

  const getTextColor = (): string => {
    if (disabled) return colors.textTertiary;
    switch (variant) {
      case 'primary': return colors.textOnPrimary;
      case 'secondary': return colors.text;
      case 'outline': return colors.primary;
      case 'ghost': return colors.primary;
      case 'danger': return colors.textOnPrimary;
      case 'soft': return colors.primary;
      case 'gradient': return colors.textOnPrimary;
      default: return colors.textOnPrimary;
    }
  };

  const getBorderColor = (): string => {
    if (variant === 'outline') return disabled ? colors.border : colors.primary;
    return 'transparent';
  };

  const getSizeStyle = (): ViewStyle => {
    switch (size) {
      case 'xs': return { paddingVertical: Spacing.xs + 2, paddingHorizontal: Spacing.md };
      case 'sm': return { paddingVertical: Spacing.sm + 2, paddingHorizontal: Spacing.lg };
      case 'md': return { paddingVertical: Spacing.md + 2, paddingHorizontal: Spacing.xl };
      case 'lg': return { paddingVertical: Spacing.lg, paddingHorizontal: Spacing['2xl'] };
      case 'xl': return { paddingVertical: Spacing.xl, paddingHorizontal: Spacing['3xl'] };
      default: return { paddingVertical: Spacing.md + 2, paddingHorizontal: Spacing.xl };
    }
  };

  const getFontSize = (): number => {
    switch (size) {
      case 'xs': return FontSize.xs;
      case 'sm': return FontSize.sm;
      case 'md': return FontSize.base;
      case 'lg': return FontSize.lg;
      case 'xl': return FontSize.xl;
      default: return FontSize.base;
    }
  };

  const getMinHeight = (): number => {
    switch (size) {
      case 'xs': return 32;
      case 'sm': return 38;
      case 'md': return 46;
      case 'lg': return 52;
      case 'xl': return 58;
      default: return 46;
    }
  };

  const getShadow = () => {
    if (disabled || variant === 'outline' || variant === 'ghost') return {};
    if (variant === 'primary' || variant === 'gradient') {
      return Shadow.colored(colors.primary);
    }
    return Shadow.sm;
  };

  const borderRadiusValue = rounded ? BorderRadius.full : BorderRadius.lg;

  const buttonContent = (
    <>
      {loading ? (
        <ActivityIndicator color={getTextColor()} size="small" />
      ) : (
        <View style={styles.contentRow}>
          {icon && <View style={styles.iconLeft}>{icon}</View>}
          <Text
            style={[
              styles.text,
              {
                color: getTextColor(),
                fontSize: getFontSize(),
              },
            ]}
          >
            {title}
          </Text>
          {iconRight && <View style={styles.iconRight}>{iconRight}</View>}
        </View>
      )}
    </>
  );

  if (variant === 'gradient' && !disabled) {
    return (
      <TouchableOpacity
        activeOpacity={0.8}
        disabled={disabled || loading}
        style={[
          fullWidth && styles.fullWidth,
          getShadow() as ViewStyle,
          style as ViewStyle,
        ]}
        {...props}
      >
        <LinearGradient
          colors={colors.gradientPrimary as unknown as [string, string]}
          start={{ x: 0, y: 0 }}
          end={{ x: 1, y: 0 }}
          style={[
            styles.base,
            getSizeStyle(),
            { minHeight: getMinHeight(), borderRadius: borderRadiusValue },
            fullWidth && styles.fullWidth,
          ]}
        >
          {buttonContent}
        </LinearGradient>
      </TouchableOpacity>
    );
  }

  return (
    <TouchableOpacity
      activeOpacity={0.75}
      disabled={disabled || loading}
      style={[
        styles.base,
        getSizeStyle(),
        {
          backgroundColor: getBackgroundColor(),
          borderColor: getBorderColor(),
          borderWidth: variant === 'outline' ? 1.5 : 0,
          borderRadius: borderRadiusValue,
          minHeight: getMinHeight(),
        },
        getShadow() as ViewStyle,
        fullWidth && styles.fullWidth,
        style as ViewStyle,
      ]}
      {...props}
    >
      {buttonContent}
    </TouchableOpacity>
  );
}

const styles = StyleSheet.create({
  base: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'center',
    overflow: 'hidden',
  },
  fullWidth: {
    width: '100%',
  },
  contentRow: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'center',
  },
  text: {
    fontWeight: FontWeight.semibold,
    textAlign: 'center',
    letterSpacing: 0.3,
  },
  iconLeft: {
    marginRight: Spacing.sm,
  },
  iconRight: {
    marginLeft: Spacing.sm,
  },
});
