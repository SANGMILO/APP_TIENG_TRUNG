import React, { useState, useRef } from 'react';
import {
  View,
  TextInput,
  Text,
  StyleSheet,
  TextInputProps,
  TouchableOpacity,
  Animated,
} from 'react-native';
import { useThemeStore } from '@/stores/theme-store';
import { BorderRadius, FontSize, Spacing, Shadow, FontWeight } from '@/constants/theme';

interface InputProps extends TextInputProps {
  label?: string;
  error?: string;
  helper?: string;
  leftIcon?: React.ReactNode;
  rightIcon?: React.ReactNode;
  isPassword?: boolean;
  size?: 'sm' | 'md' | 'lg';
}

export function Input({
  label,
  error,
  helper,
  leftIcon,
  rightIcon,
  isPassword,
  size = 'md',
  style,
  ...props
}: InputProps) {
  const { colors } = useThemeStore();
  const [isFocused, setIsFocused] = useState(false);
  const [showPassword, setShowPassword] = useState(false);
  const animatedBorder = useRef(new Animated.Value(0)).current;

  const handleFocus = () => {
    setIsFocused(true);
    Animated.timing(animatedBorder, {
      toValue: 1,
      duration: 200,
      useNativeDriver: false,
    }).start();
  };

  const handleBlur = () => {
    setIsFocused(false);
    Animated.timing(animatedBorder, {
      toValue: 0,
      duration: 200,
      useNativeDriver: false,
    }).start();
  };

  const borderColor = error
    ? colors.error
    : isFocused
      ? colors.primary
      : colors.border;

  const getMinHeight = (): number => {
    switch (size) {
      case 'sm': return 40;
      case 'md': return 50;
      case 'lg': return 56;
      default: return 50;
    }
  };

  const getInputFontSize = (): number => {
    switch (size) {
      case 'sm': return FontSize.md;
      case 'md': return FontSize.base;
      case 'lg': return FontSize.lg;
      default: return FontSize.base;
    }
  };

  return (
    <View style={styles.container}>
      {label && (
        <Text style={[styles.label, { color: isFocused ? colors.primary : colors.text }]}>
          {label}
        </Text>
      )}
      <View
        style={[
          styles.inputContainer,
          {
            borderColor,
            backgroundColor: isFocused ? colors.surface : colors.surfaceElevated,
            minHeight: getMinHeight(),
          },
          isFocused && Shadow.sm,
        ]}
      >
        {leftIcon && <View style={styles.iconLeft}>{leftIcon}</View>}
        <TextInput
          style={[
            styles.input,
            {
              color: colors.text,
              fontSize: getInputFontSize(),
              paddingLeft: leftIcon ? 0 : Spacing.lg,
              paddingRight: rightIcon || isPassword ? 0 : Spacing.lg,
            },
            style,
          ]}
          placeholderTextColor={colors.textTertiary}
          secureTextEntry={isPassword && !showPassword}
          onFocus={handleFocus}
          onBlur={handleBlur}
          {...props}
        />
        {isPassword && (
          <TouchableOpacity
            onPress={() => setShowPassword(!showPassword)}
            style={styles.iconRight}
            hitSlop={{ top: 10, bottom: 10, left: 10, right: 10 }}
          >
            <Text style={{ color: colors.primary, fontSize: FontSize.sm, fontWeight: FontWeight.medium }}>
              {showPassword ? 'Ẩn' : 'Hiện'}
            </Text>
          </TouchableOpacity>
        )}
        {rightIcon && <View style={styles.iconRight}>{rightIcon}</View>}
      </View>
      {error && (
        <View style={styles.errorRow}>
          <Text style={styles.errorIcon}>⚠️</Text>
          <Text style={[styles.error, { color: colors.error }]}>{error}</Text>
        </View>
      )}
      {helper && !error && (
        <Text style={[styles.helper, { color: colors.textTertiary }]}>
          {helper}
        </Text>
      )}
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    width: '100%',
    marginBottom: Spacing.xl,
  },
  label: {
    fontSize: FontSize.md,
    fontWeight: FontWeight.semibold,
    marginBottom: Spacing.sm,
    letterSpacing: 0.2,
  },
  inputContainer: {
    flexDirection: 'row',
    alignItems: 'center',
    borderWidth: 1.5,
    borderRadius: BorderRadius.lg,
  },
  input: {
    flex: 1,
    paddingVertical: Spacing.md,
  },
  iconLeft: {
    paddingLeft: Spacing.lg,
    paddingRight: Spacing.sm,
  },
  iconRight: {
    paddingRight: Spacing.lg,
    paddingLeft: Spacing.sm,
  },
  errorRow: {
    flexDirection: 'row',
    alignItems: 'center',
    marginTop: Spacing.xs + 2,
    gap: Spacing.xs,
  },
  errorIcon: {
    fontSize: 12,
  },
  error: {
    fontSize: FontSize.sm,
    fontWeight: FontWeight.medium,
  },
  helper: {
    fontSize: FontSize.sm,
    marginTop: Spacing.xs + 2,
  },
});
