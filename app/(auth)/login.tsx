import React, { useState } from 'react';
import {
  View,
  Text,
  StyleSheet,
  TouchableOpacity,
  TextInput,
  KeyboardAvoidingView,
  Platform,
  ScrollView,
} from 'react-native';
import { Ionicons } from '@expo/vector-icons';
import { router } from 'expo-router';
import { useSafeAreaInsets } from 'react-native-safe-area-context';
import { useForm, Controller } from 'react-hook-form';
import { zodResolver } from '@hookform/resolvers/zod';
import { z } from 'zod';
import { useThemeStore } from '@/stores/theme-store';
import { useAuthStore } from '@/stores/auth-store';
import { supabase } from '@/lib/supabase';
import { FadeInView, AnimatedPressable, GoogleLogo } from '@/components/ui';
import { Spacing, BorderRadius, Shadow, FontWeight, FontFamily } from '@/constants/theme';
import { loginWithPassword } from '@/services/auth-flow';

const loginSchema = z.object({
  email: z.string().email('Email không hợp lệ'),
  password: z.string().min(6, 'Mật khẩu ít nhất 6 ký tự'),
});

type LoginForm = z.infer<typeof loginSchema>;

export default function LoginScreen() {
  const { colors } = useThemeStore();
  const insets = useSafeAreaInsets();
  const [isLoading, setIsLoading] = useState(false);
  const [error, setError] = useState('');
  const [showPassword, setShowPassword] = useState(false);
  const {
    setSession,
    fetchProfile,
    beginAuthTransition,
    endAuthTransition,
  } = useAuthStore();

  const { control, handleSubmit, formState: { errors } } = useForm<LoginForm>({
    resolver: zodResolver(loginSchema),
    defaultValues: { email: '', password: '' },
  });

  const onSubmit = async (data: LoginForm) => {
    if (isLoading) return;

    setIsLoading(true);
    setError('');
    beginAuthTransition();

    try {
      const result = await loginWithPassword({
        signInWithPassword: (credentials) => supabase.auth.signInWithPassword(credentials),
        completeSession: async (session) => {
          setSession(session);
          return fetchProfile(session.user.id);
        },
      }, {
        email: data.email.trim(),
        password: data.password,
      });

      router.replace(result.destination);
    } catch (err: unknown) {
      endAuthTransition();
      const message = err instanceof Error ? err.message : '';
      setError(
        message === 'Invalid login credentials'
          ? 'Email hoặc mật khẩu không đúng'
          : message || 'Đã có lỗi xảy ra. Vui lòng thử lại.'
      );
    } finally {
      setIsLoading(false);
    }
  };

  return (
    <KeyboardAvoidingView
      style={[styles.container, { backgroundColor: colors.background }]}
      behavior={Platform.OS === 'ios' ? 'padding' : 'height'}
    >
      {/* Decorative background character */}
      <Text style={styles.bgChar}>你好</Text>

      {/* Header */}
      <View style={[styles.header, { paddingTop: insets.top + 16 }]}>
        <TouchableOpacity
          style={[styles.backButton, { backgroundColor: 'transparent' }]}
          onPress={() => router.back()}
          activeOpacity={0.6}
        >
          <Ionicons name="arrow-back" size={24} color={colors.textSecondary} />
        </TouchableOpacity>

        <View style={styles.headerBrand}>
          <View style={[styles.headerLogo, { backgroundColor: colors.primary }]}>
            <Text style={styles.headerLogoText}>M</Text>
          </View>
          <Text style={[styles.headerTitle, { color: colors.text }]}>Mandarin Master</Text>
        </View>

        <View style={styles.headerSpacer} />
      </View>

      {/* Scrollable content */}
      <ScrollView
        contentContainerStyle={styles.scrollContent}
        keyboardShouldPersistTaps="handled"
        showsVerticalScrollIndicator={false}
      >
        {/* Heading */}
        <FadeInView animation="slideUp" delay={50} duration={600}>
          <View style={styles.headingSection}>
            <Text style={[styles.heading, { color: colors.primary }]}>
              Chào mừng trở lại
            </Text>
            <Text style={[styles.headingDesc, { color: colors.textTertiary }]}>
              Tiếp tục hành trình chinh phục tiếng Trung của bạn.
            </Text>
          </View>
        </FadeInView>

        {/* Error */}
        {error ? (
          <View style={[styles.errorBox, { backgroundColor: colors.errorLight, borderColor: colors.error + '30' }]}>
            <Ionicons name="alert-circle" size={16} color={colors.error} />
            <Text style={[styles.errorText, { color: colors.error }]}>{error}</Text>
          </View>
        ) : null}

        {/* Form */}
        <FadeInView animation="slideUp" delay={150} duration={600}>
          <View style={styles.form}>
            {/* Email */}
            <Controller
              control={control}
              name="email"
              render={({ field: { onChange, onBlur, value } }) => (
                <View style={styles.fieldWrap}>
                  <View style={[
                    styles.inputRow,
                    { backgroundColor: colors.surfaceElevated, borderColor: errors.email ? colors.error : colors.border },
                  ]}>
                    <Ionicons name="mail-outline" size={20} color={colors.textSecondary} style={styles.inputIcon} />
                    <TextInput
                      style={[styles.input, { color: colors.text }]}
                      placeholder="Nhập địa chỉ email"
                      placeholderTextColor={colors.textTertiary}
                      keyboardType="email-address"
                      autoCapitalize="none"
                      autoComplete="email"
                      value={value}
                      onChangeText={onChange}
                      onBlur={onBlur}
                    />
                  </View>
                  {errors.email && (
                    <Text style={[styles.fieldError, { color: colors.error }]}>{errors.email.message}</Text>
                  )}
                </View>
              )}
            />

            {/* Password */}
            <Controller
              control={control}
              name="password"
              render={({ field: { onChange, onBlur, value } }) => (
                <View style={styles.fieldWrap}>
                  <View style={[
                    styles.inputRow,
                    { backgroundColor: colors.surfaceElevated, borderColor: errors.password ? colors.error : colors.border },
                  ]}>
                    <Ionicons name="lock-closed-outline" size={20} color={colors.textSecondary} style={styles.inputIcon} />
                    <TextInput
                      style={[styles.input, { color: colors.text }]}
                      placeholder="Nhập mật khẩu"
                      placeholderTextColor={colors.textTertiary}
                      secureTextEntry={!showPassword}
                      value={value}
                      onChangeText={onChange}
                      onBlur={onBlur}
                    />
                    <TouchableOpacity
                      onPress={() => setShowPassword(!showPassword)}
                      style={styles.visibilityBtn}
                      hitSlop={{ top: 10, bottom: 10, left: 10, right: 10 }}
                    >
                      <Ionicons
                        name={showPassword ? 'eye-outline' : 'eye-off-outline'}
                        size={20}
                        color={colors.textSecondary}
                      />
                    </TouchableOpacity>
                  </View>
                  {errors.password && (
                    <Text style={[styles.fieldError, { color: colors.error }]}>{errors.password.message}</Text>
                  )}
                </View>
              )}
            />

            {/* Options row */}
            <View style={styles.optionsRow}>
              <View style={styles.rememberRow}>
                <View style={[styles.checkbox, { borderColor: colors.border }]} />
                <Text style={[styles.rememberText, { color: colors.textTertiary }]}>
                  Ghi nhớ đăng nhập
                </Text>
              </View>
              <TouchableOpacity onPress={() => router.push('/(auth)/forgot-password')}>
                <Text style={[styles.forgotText, { color: colors.primary }]}>
                  Quên mật khẩu?
                </Text>
              </TouchableOpacity>
            </View>

            {/* Primary CTA */}
            <AnimatedPressable
              scaleValue={0.98}
              onPress={handleSubmit(onSubmit)}
              disabled={isLoading}
              style={styles.ctaWrap}
            >
              <View style={[styles.ctaButton, { backgroundColor: colors.primary, opacity: isLoading ? 0.7 : 1 }]}>
                <Text style={styles.ctaText}>
                  {isLoading ? 'Đang đăng nhập...' : 'Đăng nhập'}
                </Text>
              </View>
            </AnimatedPressable>
          </View>
        </FadeInView>

        {/* Divider */}
        <FadeInView animation="fadeIn" delay={300} duration={600}>
          <View style={styles.dividerRow}>
            <View style={[styles.dividerLine, { backgroundColor: colors.border + '80' }]} />
            <Text style={[styles.dividerText, { color: colors.textTertiary }]}>HOẶC</Text>
            <View style={[styles.dividerLine, { backgroundColor: colors.border + '80' }]} />
          </View>

          {/* Social buttons */}
          <View style={styles.socialSection}>
            <TouchableOpacity
              style={[styles.socialButton, { backgroundColor: colors.card, borderColor: colors.border }]}
              activeOpacity={0.7}
            >
              <GoogleLogo size={20} />
              <Text style={[styles.socialText, { color: colors.text }]}>Tiếp tục với Google</Text>
            </TouchableOpacity>

            <TouchableOpacity
              style={[styles.socialButton, { backgroundColor: colors.card, borderColor: colors.border }]}
              activeOpacity={0.7}
            >
              <Ionicons name="logo-apple" size={20} color={colors.text} />
              <Text style={[styles.socialText, { color: colors.text }]}>Tiếp tục với Apple</Text>
            </TouchableOpacity>
          </View>

          {/* Footer */}
          <View style={styles.footer}>
            <Text style={[styles.footerText, { color: colors.textTertiary }]}>
              Chưa có tài khoản?{' '}
            </Text>
            <TouchableOpacity onPress={() => router.replace('/(auth)/register')}>
              <Text style={[styles.footerLink, { color: colors.primary }]}>Đăng ký</Text>
            </TouchableOpacity>
          </View>
        </FadeInView>
      </ScrollView>
    </KeyboardAvoidingView>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    position: 'relative',
    overflow: 'hidden',
  },
  bgChar: {
    position: 'absolute',
    top: '15%',
    right: -40,
    fontSize: 200,
    fontFamily: FontFamily.chinese,
    color: 'rgba(172, 0, 30, 0.03)',
    lineHeight: 240,
  },

  // Header
  header: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    paddingHorizontal: 20, // container-margin
    paddingBottom: 16,
    zIndex: 20,
  },
  backButton: {
    width: 40,
    height: 40,
    justifyContent: 'center',
    alignItems: 'center',
    borderRadius: 20,
  },
  headerBrand: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 8,
  },
  headerLogo: {
    width: 24,
    height: 24,
    borderRadius: 12,
    justifyContent: 'center',
    alignItems: 'center',
  },
  headerLogoText: {
    color: '#FFFFFF',
    fontSize: 10,
    fontFamily: FontFamily.bold,
    fontWeight: FontWeight.bold,
  },
  headerTitle: {
    fontSize: 16,
    fontFamily: FontFamily.heading,
    fontWeight: FontWeight.bold,
  },
  headerSpacer: {
    width: 40,
    height: 40,
  },

  // Scrollable content
  scrollContent: {
    flexGrow: 1,
    paddingHorizontal: 20,
    paddingTop: 32, // Stitch pt-xl
    paddingBottom: 32,
    maxWidth: 430,
    alignSelf: 'center',
    width: '100%',
  },

  // Heading
  headingSection: {
    marginBottom: 32, // Stitch mb-xl
  },
  heading: {
    fontSize: 28, // Stitch headline-lg-mobile
    fontFamily: FontFamily.heading,
    fontWeight: FontWeight.bold,
    lineHeight: 34,
    marginBottom: 12, // Stitch mb-sm
  },
  headingDesc: {
    fontSize: 16, // Stitch body-vn
    fontFamily: FontFamily.regular,
    lineHeight: 24,
  },

  // Error
  errorBox: {
    flexDirection: 'row',
    alignItems: 'center',
    padding: 16,
    borderRadius: 12,
    marginBottom: 24,
    borderWidth: 1,
    gap: 8,
  },
  errorText: {
    fontSize: 14,
    fontFamily: FontFamily.medium,
    fontWeight: FontWeight.medium,
    flex: 1,
  },

  // Form
  form: {
    marginBottom: 32, // Stitch mt-xl spacing
  },
  fieldWrap: {
    marginBottom: 24, // Stitch space-y-lg
  },
  inputRow: {
    flexDirection: 'row',
    alignItems: 'center',
    borderWidth: 1,
    borderRadius: 24, // Stitch rounded-2xl = 1.5rem = 24px
    height: 56,
    paddingHorizontal: 0,
  },
  inputIcon: {
    marginLeft: 16, // Stitch ml-md
  },
  input: {
    flex: 1,
    height: '100%',
    paddingHorizontal: 12, // Stitch px-sm
    fontSize: 16, // Stitch body-vn
    fontFamily: FontFamily.regular,
  },
  visibilityBtn: {
    paddingHorizontal: 16, // Stitch mr-md
    height: '100%',
    justifyContent: 'center',
  },
  fieldError: {
    fontSize: 12,
    fontFamily: FontFamily.medium,
    marginTop: 4,
    marginLeft: 16,
  },

  // Options row
  optionsRow: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginTop: 4, // Stitch mt-sm (small extra)
    marginBottom: 32, // Stitch mb-xl
  },
  rememberRow: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 8,
  },
  checkbox: {
    width: 20,
    height: 20,
    borderRadius: 4,
    borderWidth: 1.5,
  },
  rememberText: {
    fontSize: 12, // Stitch label-sm
    fontFamily: FontFamily.semibold,
    fontWeight: FontWeight.semibold,
    lineHeight: 16,
  },
  forgotText: {
    fontSize: 12,
    fontFamily: FontFamily.semibold,
    fontWeight: FontWeight.semibold,
    lineHeight: 16,
  },

  // CTA
  ctaWrap: {
    width: '100%',
  },
  ctaButton: {
    width: '100%',
    height: 56, // Stitch h-[56px]
    borderRadius: 24, // Stitch rounded-2xl
    justifyContent: 'center',
    alignItems: 'center',
    shadowColor: '#AC001E',
    shadowOffset: { width: 0, height: 4 },
    shadowOpacity: 0.2,
    shadowRadius: 20,
    elevation: 6,
  },
  ctaText: {
    fontSize: 12, // Stitch label-sm base
    fontFamily: FontFamily.semibold,
    fontWeight: FontWeight.semibold,
    lineHeight: 16,
    color: '#FFFFFF',
    letterSpacing: 0.5,
  },

  // Divider
  dividerRow: {
    flexDirection: 'row',
    alignItems: 'center',
    paddingVertical: 24, // Stitch py-lg
    marginBottom: 16,
  },
  dividerLine: {
    flex: 1,
    height: 1,
  },
  dividerText: {
    marginHorizontal: 16,
    fontSize: 12,
    fontFamily: FontFamily.semibold,
    fontWeight: FontWeight.semibold,
    letterSpacing: 2, // Stitch tracking-widest
  },

  // Social
  socialSection: {
    gap: 16, // Stitch space-y-md
    marginBottom: 32,
  },
  socialButton: {
    width: '100%',
    height: 56, // Stitch h-[56px]
    borderRadius: 24, // Stitch rounded-2xl
    borderWidth: 1,
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'center',
    gap: 12, // Stitch gap-sm
    ...Shadow.xs,
  },
  socialText: {
    fontSize: 12, // Stitch label-sm
    fontFamily: FontFamily.semibold,
    fontWeight: FontWeight.semibold,
    lineHeight: 16,
  },

  // Footer
  footer: {
    flexDirection: 'row',
    justifyContent: 'center',
    alignItems: 'center',
    paddingBottom: 32, // Stitch pb-xl
  },
  footerText: {
    fontSize: 16, // Stitch body-vn
    fontFamily: FontFamily.regular,
    lineHeight: 24,
  },
  footerLink: {
    fontSize: 16,
    fontFamily: FontFamily.semibold,
    fontWeight: FontWeight.semibold,
  },
});
