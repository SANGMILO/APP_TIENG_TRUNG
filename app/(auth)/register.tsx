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
import { FadeInView, AnimatedPressable, GoogleLogo, Button } from '@/components/ui';
import { Spacing, BorderRadius, Shadow, FontWeight, FontFamily } from '@/constants/theme';
import { registerWithPassword } from '@/services/auth-flow';
import { useGoogleOAuth } from '@/hooks/useGoogleOAuth';

const registerSchema = z.object({
  fullName: z.string().min(2, 'Tên ít nhất 2 ký tự'),
  email: z.string().email('Email không hợp lệ'),
  password: z.string().min(8, 'Mật khẩu ít nhất 8 ký tự'),
  confirmPassword: z.string(),
  agreeTerms: z.boolean(),
}).refine((data) => data.password === data.confirmPassword, {
  message: 'Mật khẩu không khớp',
  path: ['confirmPassword'],
}).refine((data) => data.agreeTerms === true, {
  message: 'Vui lòng đồng ý với điều khoản',
  path: ['agreeTerms'],
});

type RegisterForm = z.infer<typeof registerSchema>;

export default function RegisterScreen() {
  const { colors } = useThemeStore();
  const insets = useSafeAreaInsets();
  const [isLoading, setIsLoading] = useState(false);
  const [error, setError] = useState('');
  const [showPassword, setShowPassword] = useState(false);
  const [confirmationEmail, setConfirmationEmail] = useState('');
  const {
    setSession,
    fetchProfile,
    beginAuthTransition,
    endAuthTransition,
  } = useAuthStore();
  const {
    isGoogleLoading,
    startGoogleOAuth,
  } = useGoogleOAuth(setError);

  const { control, handleSubmit, watch, formState: { errors } } = useForm<RegisterForm>({
    resolver: zodResolver(registerSchema),
    defaultValues: { fullName: '', email: '', password: '', confirmPassword: '', agreeTerms: false },
  });

  const password = watch('password');
  const hasMinLength = password.length >= 8;
  const hasAlphaNumeric = /[a-zA-Z]/.test(password) && /\d/.test(password);

  const onSubmit = async (data: RegisterForm) => {
    if (isLoading || isGoogleLoading) return;

    setIsLoading(true);
    setError('');
    beginAuthTransition();

    try {
      const result = await registerWithPassword({
        signUp: (credentials) => supabase.auth.signUp(credentials),
        completeSession: async (session) => {
          setSession(session);
          return fetchProfile(session.user.id);
        },
      }, {
        email: data.email.trim(),
        password: data.password,
        displayName: data.fullName.trim(),
      });

      if (result.status === 'confirmation_required') {
        endAuthTransition();
        setConfirmationEmail(result.email);
        return;
      }

      router.replace(result.destination);
    } catch (err: unknown) {
      endAuthTransition();
      const message = err instanceof Error ? err.message : '';
      setError(
        message.includes('already registered')
          ? 'Email này đã được đăng ký'
          : message || 'Đã có lỗi xảy ra. Vui lòng thử lại.'
      );
    } finally {
      setIsLoading(false);
    }
  };

  if (confirmationEmail) {
    return (
      <View style={[styles.confirmationContainer, { backgroundColor: colors.background }]}>
        <View style={[styles.confirmationIcon, { backgroundColor: colors.primary + '12' }]}>
          <Ionicons name="mail-outline" size={36} color={colors.primary} />
        </View>
        <Text style={[styles.confirmationTitle, { color: colors.text }]}>
          Kiểm tra email của bạn
        </Text>
        <Text style={[styles.confirmationText, { color: colors.textSecondary }]}>
          Chúng tôi đã gửi liên kết xác nhận đến:
        </Text>
        <Text style={[styles.confirmationEmail, { color: colors.primary }]}>
          {confirmationEmail}
        </Text>
        <Text style={[styles.confirmationText, { color: colors.textSecondary }]}>
          Xác nhận email trước khi đăng nhập. Tài khoản chưa được đăng nhập trên thiết bị này.
        </Text>
        <Button
          title="Quay lại đăng nhập"
          variant="primary"
          size="lg"
          onPress={() => router.replace('/(auth)/login')}
          style={styles.confirmationButton}
        />
      </View>
    );
  }

  return (
    <KeyboardAvoidingView
      style={[styles.container, { backgroundColor: colors.background }]}
      behavior={Platform.OS === 'ios' ? 'padding' : 'height'}
    >
      {/* Header */}
      <View style={[styles.header, { paddingTop: insets.top + 16 }]}>
        <TouchableOpacity
          style={[styles.backButton, { backgroundColor: colors.surfaceMuted }]}
          onPress={() => router.back()}
          activeOpacity={0.6}
        >
          <Ionicons name="arrow-back" size={24} color={colors.text} />
        </TouchableOpacity>

        <View style={styles.headerBrand}>
          <View style={[styles.headerLogo, { backgroundColor: colors.primary }]}>
            <Text style={styles.headerLogoChar}>中</Text>
          </View>
          <Text style={[styles.headerTitle, { color: colors.text }]}>Mandarin Master</Text>
        </View>

        <View style={styles.headerSpacer} />
      </View>

      {/* Content */}
      <ScrollView
        contentContainerStyle={styles.scrollContent}
        keyboardShouldPersistTaps="handled"
        showsVerticalScrollIndicator={false}
      >
        {/* Title */}
        <FadeInView animation="slideUp" delay={50} duration={600}>
          <View style={styles.titleSection}>
            <Text style={[styles.title, { color: colors.primary }]}>Tạo tài khoản</Text>
            <Text style={[styles.titleDesc, { color: colors.textTertiary }]}>
              Bắt đầu hành trình học tiếng Trung cùng Mandarin Master.
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
            {/* Full Name */}
            <View style={styles.fieldGroup}>
              <Text style={[styles.label, { color: colors.text }]}>Họ và tên</Text>
              <Controller
                control={control}
                name="fullName"
                render={({ field: { onChange, onBlur, value } }) => (
                  <View style={[styles.inputRow, { borderColor: errors.fullName ? colors.error : colors.border + '80' }]}>
                    <Ionicons name="person-outline" size={20} color={colors.textTertiary} style={styles.inputIcon} />
                    <TextInput
                      style={[styles.input, { color: colors.text }]}
                      placeholder="Nhập tên của bạn"
                      placeholderTextColor={colors.textTertiary + '66'}
                      value={value}
                      onChangeText={onChange}
                      onBlur={onBlur}
                    />
                  </View>
                )}
              />
              {errors.fullName && <Text style={[styles.fieldError, { color: colors.error }]}>{errors.fullName.message}</Text>}
            </View>

            {/* Email */}
            <View style={styles.fieldGroup}>
              <Text style={[styles.label, { color: colors.text }]}>Email</Text>
              <Controller
                control={control}
                name="email"
                render={({ field: { onChange, onBlur, value } }) => (
                  <View style={[styles.inputRow, { borderColor: errors.email ? colors.error : colors.border + '80' }]}>
                    <Ionicons name="mail-outline" size={20} color={colors.textTertiary} style={styles.inputIcon} />
                    <TextInput
                      style={[styles.input, { color: colors.text }]}
                      placeholder="Nhập địa chỉ email"
                      placeholderTextColor={colors.textTertiary + '66'}
                      keyboardType="email-address"
                      autoCapitalize="none"
                      autoComplete="email"
                      value={value}
                      onChangeText={onChange}
                      onBlur={onBlur}
                    />
                  </View>
                )}
              />
              {errors.email && <Text style={[styles.fieldError, { color: colors.error }]}>{errors.email.message}</Text>}
            </View>

            {/* Password */}
            <View style={styles.fieldGroup}>
              <Text style={[styles.label, { color: colors.text }]}>Mật khẩu</Text>
              <Controller
                control={control}
                name="password"
                render={({ field: { onChange, onBlur, value } }) => (
                  <View style={[styles.inputRow, { borderColor: errors.password ? colors.error : colors.border + '80' }]}>
                    <Ionicons name="lock-closed-outline" size={20} color={colors.textTertiary} style={styles.inputIcon} />
                    <TextInput
                      style={[styles.input, { color: colors.text }]}
                      placeholder="Tạo mật khẩu"
                      placeholderTextColor={colors.textTertiary + '66'}
                      secureTextEntry={!showPassword}
                      value={value}
                      onChangeText={onChange}
                      onBlur={onBlur}
                    />
                    <TouchableOpacity
                      onPress={() => setShowPassword(!showPassword)}
                      style={styles.visibilityBtn}
                    >
                      <Ionicons
                        name={showPassword ? 'eye-outline' : 'eye-off-outline'}
                        size={20}
                        color={colors.textTertiary}
                      />
                    </TouchableOpacity>
                  </View>
                )}
              />
              {errors.password && <Text style={[styles.fieldError, { color: colors.error }]}>{errors.password.message}</Text>}

              {/* Password strength indicators */}
              <View style={styles.strengthRow}>
                <View style={styles.strengthItem}>
                  <Ionicons
                    name={hasMinLength ? 'checkmark-circle' : 'ellipse-outline'}
                    size={16}
                    color={hasMinLength ? colors.jade : colors.border}
                  />
                  <Text style={[styles.strengthText, { color: colors.textTertiary }]}>Ít nhất 8 ký tự</Text>
                </View>
                <View style={styles.strengthItem}>
                  <Ionicons
                    name={hasAlphaNumeric ? 'checkmark-circle' : 'ellipse-outline'}
                    size={16}
                    color={hasAlphaNumeric ? colors.jade : colors.border}
                  />
                  <Text style={[styles.strengthText, { color: colors.textTertiary }]}>Có chữ và số</Text>
                </View>
              </View>
            </View>

            {/* Confirm Password */}
            <View style={styles.fieldGroup}>
              <Text style={[styles.label, { color: colors.text }]}>Xác nhận mật khẩu</Text>
              <Controller
                control={control}
                name="confirmPassword"
                render={({ field: { onChange, onBlur, value } }) => (
                  <View style={[styles.inputRow, { borderColor: errors.confirmPassword ? colors.error : colors.border + '80' }]}>
                    <Ionicons name="lock-closed-outline" size={20} color={colors.textTertiary} style={styles.inputIcon} />
                    <TextInput
                      style={[styles.input, { color: colors.text }]}
                      placeholder="Nhập lại mật khẩu"
                      placeholderTextColor={colors.textTertiary + '66'}
                      secureTextEntry={true}
                      value={value}
                      onChangeText={onChange}
                      onBlur={onBlur}
                    />
                  </View>
                )}
              />
              {errors.confirmPassword && <Text style={[styles.fieldError, { color: colors.error }]}>{errors.confirmPassword.message}</Text>}
            </View>

            {/* Terms checkbox */}
            <Controller
              control={control}
              name="agreeTerms"
              render={({ field: { onChange, value } }) => (
                <View style={styles.termsRow}>
                  <TouchableOpacity
                    onPress={() => onChange(!value)}
                    activeOpacity={0.7}
                    accessibilityRole="checkbox"
                    accessibilityState={{ checked: value }}
                    accessibilityLabel="Đồng ý với điều khoản và chính sách quyền riêng tư"
                  >
                    <View style={[
                      styles.checkbox,
                      { borderColor: errors.agreeTerms ? colors.error : colors.border },
                      value && { backgroundColor: colors.primary, borderColor: colors.primary },
                    ]}>
                      {value && <Ionicons name="checkmark" size={14} color="#FFFFFF" />}
                    </View>
                  </TouchableOpacity>
                  <Text style={[styles.termsText, { color: colors.textTertiary }]}>
                    Tôi đồng ý với{' '}
                    <Text
                      style={{ color: colors.primary, fontWeight: FontWeight.medium }}
                      onPress={() => router.push('/terms')}
                    >
                      Điều khoản sử dụng
                    </Text>
                    {' '}và{' '}
                    <Text
                      style={{ color: colors.primary, fontWeight: FontWeight.medium }}
                      onPress={() => router.push('/privacy')}
                    >
                      Chính sách quyền riêng tư
                    </Text>
                  </Text>
                </View>
              )}
            />

            {/* Submit button */}
            <AnimatedPressable
              scaleValue={0.98}
              onPress={handleSubmit(onSubmit)}
              disabled={isLoading || isGoogleLoading}
              style={styles.submitWrap}
            >
              <View style={[styles.submitButton, { backgroundColor: colors.primary, opacity: isLoading || isGoogleLoading ? 0.7 : 1 }]}>
                <Text style={styles.submitText}>
                  {isLoading ? 'Đang tạo...' : 'Tạo tài khoản'}
                </Text>
                {!isLoading && <Ionicons name="arrow-forward" size={20} color="#FFFFFF" />}
              </View>
            </AnimatedPressable>
          </View>
        </FadeInView>

        {/* Social login */}
        <FadeInView animation="fadeIn" delay={350} duration={600}>
          <View style={styles.socialSection}>
            <View style={styles.dividerRow}>
              <View style={[styles.dividerLine, { backgroundColor: colors.border + '40' }]} />
              <Text style={[styles.dividerText, { color: colors.textTertiary + '66' }]}>HOẶC</Text>
              <View style={[styles.dividerLine, { backgroundColor: colors.border + '40' }]} />
            </View>

            <View style={styles.socialButtons}>
              <TouchableOpacity
                style={[
                  styles.socialBtn,
                  {
                    borderColor: colors.border + '50',
                    opacity: isGoogleLoading ? 0.65 : 1,
                  },
                ]}
                onPress={() => void startGoogleOAuth()}
                disabled={isLoading || isGoogleLoading}
                activeOpacity={0.7}
              >
                <GoogleLogo size={20} />
                <Text style={[styles.socialBtnText, { color: colors.text }]}>
                  {isGoogleLoading ? 'Đang kết nối...' : 'Đăng ký với Google'}
                </Text>
              </TouchableOpacity>
              <TouchableOpacity
                style={[styles.socialBtn, { borderColor: colors.border + '50', opacity: 0.55 }]}
                disabled
                accessibilityState={{ disabled: true }}
                accessibilityLabel="Đăng ký với Apple, sắp có"
              >
                <Ionicons name="logo-apple" size={20} color={colors.text} />
                <Text style={[styles.socialBtnText, { color: colors.text }]}>Đăng ký với Apple</Text>
                <View style={[styles.soonBadge, { backgroundColor: colors.surfaceElevated }]}>
                  <Text style={[styles.soonText, { color: colors.textSecondary }]}>Sắp có</Text>
                </View>
              </TouchableOpacity>
            </View>
          </View>

          {/* Footer */}
          <View style={styles.footer}>
            <Text style={[styles.footerText, { color: colors.textTertiary }]}>
              Đã có tài khoản?{' '}
            </Text>
            <TouchableOpacity onPress={() => router.replace('/(auth)/login')}>
              <Text style={[styles.footerLink, { color: colors.primary }]}>Đăng nhập</Text>
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
  },
  confirmationContainer: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
    paddingHorizontal: Spacing['2xl'],
  },
  confirmationIcon: {
    width: 72,
    height: 72,
    borderRadius: 36,
    alignItems: 'center',
    justifyContent: 'center',
    marginBottom: Spacing.xl,
  },
  confirmationTitle: {
    fontSize: 24,
    fontFamily: FontFamily.heading,
    fontWeight: FontWeight.bold,
    textAlign: 'center',
    marginBottom: Spacing.md,
  },
  confirmationText: {
    fontSize: 15,
    fontFamily: FontFamily.regular,
    lineHeight: 22,
    textAlign: 'center',
  },
  confirmationEmail: {
    fontSize: 16,
    fontFamily: FontFamily.semibold,
    fontWeight: FontWeight.semibold,
    marginVertical: Spacing.sm,
    textAlign: 'center',
  },
  confirmationButton: {
    marginTop: Spacing['2xl'],
    minWidth: 220,
  },

  // Header
  header: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    paddingHorizontal: 20,
    paddingBottom: 16,
    zIndex: 10,
  },
  backButton: {
    width: 40,
    height: 40,
    borderRadius: 20,
    justifyContent: 'center',
    alignItems: 'center',
  },
  headerBrand: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 8,
  },
  headerLogo: {
    width: 32, // Stitch w-8
    height: 32,
    borderRadius: 6,
    justifyContent: 'center',
    alignItems: 'center',
  },
  headerLogoChar: {
    color: '#FFFFFF',
    fontSize: 16,
    fontFamily: FontFamily.chinese,
  },
  headerTitle: {
    fontSize: 16,
    fontFamily: FontFamily.heading,
    fontWeight: FontWeight.bold,
  },
  headerSpacer: {
    width: 40,
  },

  // Scroll content
  scrollContent: {
    flexGrow: 1,
    paddingHorizontal: 20,
    paddingTop: 24,
    paddingBottom: 32,
    maxWidth: 430,
    alignSelf: 'center',
    width: '100%',
  },

  // Title
  titleSection: {
    marginBottom: 32,
  },
  title: {
    fontSize: 28,
    fontFamily: FontFamily.heading,
    fontWeight: FontWeight.bold,
    lineHeight: 34,
    marginBottom: 8,
  },
  titleDesc: {
    fontSize: 16,
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
    flex: 1,
  },

  // Form
  form: {
    gap: 16, // Stitch gap-md
  },
  fieldGroup: {
    gap: 4, // Stitch gap-base
  },
  label: {
    fontSize: 12,
    fontFamily: FontFamily.semibold,
    fontWeight: FontWeight.semibold,
    lineHeight: 16,
    marginBottom: 4,
  },
  inputRow: {
    flexDirection: 'row',
    alignItems: 'center',
    borderWidth: 1,
    borderRadius: 12, // Stitch rounded-xl
    height: 56, // Stitch h-14
    backgroundColor: '#FCF9F8', // Stitch bg-surface
  },
  inputIcon: {
    marginLeft: 16,
  },
  input: {
    flex: 1,
    height: '100%',
    paddingHorizontal: 12,
    fontSize: 16,
    fontFamily: FontFamily.regular,
  },
  visibilityBtn: {
    paddingHorizontal: 16,
    height: '100%',
    justifyContent: 'center',
  },
  fieldError: {
    fontSize: 11,
    fontFamily: FontFamily.medium,
    marginTop: 4,
    marginLeft: 16,
  },

  // Password strength
  strengthRow: {
    flexDirection: 'row',
    gap: 12,
    marginTop: 8,
  },
  strengthItem: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 4,
  },
  strengthText: {
    fontSize: 11,
    fontFamily: FontFamily.semibold,
  },

  // Terms
  termsRow: {
    flexDirection: 'row',
    alignItems: 'flex-start',
    gap: 12,
    marginTop: 16,
  },
  checkbox: {
    width: 20,
    height: 20,
    borderRadius: 4,
    borderWidth: 1.5,
    justifyContent: 'center',
    alignItems: 'center',
    marginTop: 2,
  },
  termsText: {
    flex: 1,
    fontSize: 14,
    fontFamily: FontFamily.regular,
    lineHeight: 20,
  },

  // Submit
  submitWrap: {
    marginTop: 24, // Stitch mt-lg
  },
  submitButton: {
    width: '100%',
    height: 56,
    borderRadius: 12,
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'center',
    gap: 8,
    shadowColor: '#AC001E',
    shadowOffset: { width: 0, height: 4 },
    shadowOpacity: 0.15,
    shadowRadius: 20,
    elevation: 6,
  },
  submitText: {
    fontSize: 16,
    fontFamily: FontFamily.semibold,
    fontWeight: FontWeight.semibold,
    color: '#FFFFFF',
    letterSpacing: 0.5,
  },

  // Social
  socialSection: {
    marginTop: 32,
  },
  dividerRow: {
    flexDirection: 'row',
    alignItems: 'center',
    marginBottom: 16,
    gap: 16,
  },
  dividerLine: {
    flex: 1,
    height: 1,
  },
  dividerText: {
    fontSize: 12,
    fontFamily: FontFamily.semibold,
    letterSpacing: 3,
  },
  socialButtons: {
    flexDirection: 'row',
    gap: 16, // Stitch gap-md
  },
  socialBtn: {
    flex: 1,
    height: 56,
    borderRadius: 12,
    borderWidth: 1,
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'center',
    gap: 8,
  },
  socialBtnText: {
    fontSize: 14,
    fontFamily: FontFamily.semibold,
    fontWeight: FontWeight.semibold,
  },
  soonBadge: {
    position: 'absolute',
    right: 6,
    top: 3,
    paddingHorizontal: 8,
    paddingVertical: 3,
    borderRadius: 999,
  },
  soonText: {
    fontSize: 9,
    fontFamily: FontFamily.semibold,
    fontWeight: FontWeight.semibold,
  },

  // Footer
  footer: {
    flexDirection: 'row',
    justifyContent: 'center',
    alignItems: 'center',
    marginTop: 32,
    paddingBottom: 32,
  },
  footerText: {
    fontSize: 16,
    fontFamily: FontFamily.regular,
    lineHeight: 24,
  },
  footerLink: {
    fontSize: 16,
    fontFamily: FontFamily.semibold,
    fontWeight: FontWeight.semibold,
  },
});
