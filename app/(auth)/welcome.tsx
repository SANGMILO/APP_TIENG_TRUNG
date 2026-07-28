import React from 'react';
import { View, Text, StyleSheet, TouchableOpacity } from 'react-native';
import { Ionicons } from '@expo/vector-icons';
import { LinearGradient } from 'expo-linear-gradient';
import { router } from 'expo-router';
import { useSafeAreaInsets } from 'react-native-safe-area-context';
import { useThemeStore } from '@/stores/theme-store';
import { FadeInView, AnimatedPressable } from '@/components/ui';
import { Spacing, BorderRadius, Shadow, FontWeight, FontFamily } from '@/constants/theme';

const FEATURES = [
  {
    ionIcon: 'school-outline' as const,
    title: 'Cá nhân hoá',
    description: 'Lộ trình học AI tinh chỉnh theo bạn.',
    iconColor: '#AC001E',
    bgColor: '#F0EDED',
  },
  {
    ionIcon: 'create-outline' as const,
    title: 'Thực hành viết',
    description: 'Nhận diện chữ Hán thông minh.',
    iconColor: '#205E44',
    bgColor: '#B1F0CE',
  },
  {
    ionIcon: 'bulb-outline' as const,
    title: 'Ghi nhớ sâu',
    description: 'Khoa học lặp lại ngắt quãng (SRS).',
    iconColor: '#5D3F3D',
    bgColor: '#EAE7E7',
  },
];

export default function WelcomeScreen() {
  const { colors } = useThemeStore();
  const insets = useSafeAreaInsets();

  return (
    <View style={[styles.container, { backgroundColor: colors.background }]}>
      {/* Background gradient overlay */}
      <LinearGradient
        colors={['#FCF9F8', 'rgba(255, 218, 215, 0.4)']}
        start={{ x: 0.5, y: 0 }}
        end={{ x: 0.5, y: 1 }}
        style={StyleSheet.absoluteFill}
      />

      {/* Decorative Chinese characters */}
      <Text style={styles.bgChar1}>学</Text>
      <Text style={styles.bgChar2}>习</Text>

      {/* Content */}
      <View
        style={[
          styles.content,
          {
            paddingTop: insets.top + 32,
            paddingBottom: insets.bottom + 24,
          },
        ]}
      >
        {/* === TOP: Logo + Branding === */}
        <FadeInView animation="slideDown" duration={800}>
          <View style={styles.topSection}>
            <View style={styles.logoShadow}>
              <LinearGradient
                colors={[colors.primary, colors.primaryLight]}
                start={{ x: 0, y: 0 }}
                end={{ x: 1, y: 1 }}
                style={styles.logoGradient}
              >
                <Ionicons name="sparkles" size={40} color="#FFFFFF" />
              </LinearGradient>
            </View>

            <Text style={[styles.title, { color: colors.text }]}>
              Mandarin Master
            </Text>

            <Text style={[styles.subtitle, { color: colors.textSecondary }]}>
              Nắm vững tiếng Trung với phương pháp hiện đại
            </Text>
          </View>
        </FadeInView>

        {/* === MIDDLE: Feature Badges === */}
        <View style={styles.featuresSection}>
          {FEATURES.map((feature, index) => (
            <FadeInView
              key={feature.title}
              animation="slideUp"
              delay={200 + index * 200}
              duration={800}
            >
              <View>
                <View style={[styles.featureCard, { backgroundColor: colors.card }]}>
                  <View style={[styles.featureIconCircle, { backgroundColor: feature.bgColor }]}>
                    <Ionicons name={feature.ionIcon} size={24} color={feature.iconColor} />
                  </View>
                  <View style={styles.featureText}>
                    <Text style={[styles.featureTitle, { color: colors.text }]}>
                      {feature.title}
                    </Text>
                    <Text style={[styles.featureDesc, { color: colors.textSecondary }]}>
                      {feature.description}
                    </Text>
                  </View>
                </View>
              </View>
            </FadeInView>
          ))}
        </View>

        {/* === BOTTOM: CTAs === */}
        <FadeInView animation="fadeIn" delay={800} duration={1000}>
          <View style={styles.ctaSection}>
            <AnimatedPressable
              scaleValue={0.98}
              onPress={() => router.push('/(auth)/register')}
              style={styles.primaryButtonWrap}
            >
              <View style={[styles.primaryButton, { backgroundColor: colors.primary }]}>
                <Text style={styles.primaryButtonText}>Bắt đầu học</Text>
                <Ionicons name="arrow-forward" size={20} color="#FFFFFF" />
              </View>
            </AnimatedPressable>

            <TouchableOpacity
              style={styles.secondaryLink}
              onPress={() => router.push('/(auth)/login')}
              activeOpacity={0.7}
            >
              <Text style={[styles.secondaryText, { color: colors.textSecondary }]}>
                Đã có tài khoản?{' '}
                <Text style={[styles.secondaryBold, { color: colors.text }]}>
                  Đăng nhập
                </Text>
              </Text>
            </TouchableOpacity>
          </View>
        </FadeInView>
      </View>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    position: 'relative',
    overflow: 'hidden',
  },
  bgChar1: {
    position: 'absolute',
    top: 60,
    right: -30,
    fontSize: 200,
    fontFamily: FontFamily.chinese,
    color: '#AC001E',
    opacity: 0.05,
  },
  bgChar2: {
    position: 'absolute',
    bottom: 80,
    left: -20,
    fontSize: 180,
    fontFamily: FontFamily.chinese,
    color: '#AC001E',
    opacity: 0.03,
  },
  content: {
    flex: 1,
    justifyContent: 'space-between',
    paddingHorizontal: 20, // Stitch container-margin
    maxWidth: 430,
    width: '100%',
    alignSelf: 'center',
  },

  // Top section
  topSection: {
    alignItems: 'center',
    paddingTop: 24,
  },
  logoShadow: {
    width: 96, // Stitch w-24
    height: 96, // Stitch h-24
    borderRadius: 24, // Stitch rounded-3xl
    overflow: 'hidden',
    marginBottom: 24,
    ...Shadow.md,
  },
  logoGradient: {
    width: '100%',
    height: '100%',
    justifyContent: 'center',
    alignItems: 'center',
  },
  title: {
    fontSize: 28, // Stitch headline-lg-mobile
    fontFamily: FontFamily.heading,
    fontWeight: FontWeight.bold,
    lineHeight: 34,
    letterSpacing: -0.5,
    marginBottom: 8,
    textAlign: 'center',
  },
  subtitle: {
    fontSize: 18, // Stitch pinyin-md
    fontFamily: FontFamily.medium,
    fontWeight: FontWeight.medium,
    lineHeight: 24,
    letterSpacing: 0.9, // 0.05em * 18px
    textAlign: 'center',
    maxWidth: 280,
  },

  // Features section
  featuresSection: {
    gap: 12, // Stitch gap-sm
    paddingVertical: 32, // Stitch py-xl
  },
  featureCard: {
    flexDirection: 'row',
    alignItems: 'center',
    padding: 16, // Stitch p-md
    borderRadius: 12, // Stitch rounded-xl
    gap: 16, // Stitch gap-md
    ...Shadow.xs,
  },
  featureIconCircle: {
    width: 48, // Stitch w-12
    height: 48,
    borderRadius: 24,
    justifyContent: 'center',
    alignItems: 'center',
  },
  featureText: {
    flex: 1,
  },
  featureTitle: {
    fontSize: 12, // Stitch label-sm
    fontFamily: FontFamily.semibold,
    fontWeight: FontWeight.semibold,
    lineHeight: 16,
    marginBottom: 4, // Stitch mb-1
  },
  featureDesc: {
    fontSize: 14, // Stitch text-sm
    fontFamily: FontFamily.regular,
    lineHeight: 20,
  },

  // CTA section
  ctaSection: {
    gap: 24, // Stitch gap-lg
    alignItems: 'center',
    paddingBottom: 24, // Stitch pb-lg
  },
  primaryButtonWrap: {
    width: '100%',
  },
  primaryButton: {
    width: '100%',
    height: 56, // Stitch h-[56px]
    borderRadius: 12, // Stitch rounded-xl
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'center',
    gap: 8,
    shadowColor: '#AC001E',
    shadowOffset: { width: 0, height: 4 },
    shadowOpacity: 0.25,
    shadowRadius: 20,
    elevation: 6,
  },
  primaryButtonText: {
    fontSize: 16, // Stitch text-[16px]
    fontFamily: FontFamily.semibold,
    fontWeight: FontWeight.semibold,
    color: '#FFFFFF',
    letterSpacing: 0.5, // Stitch tracking-wide
  },
  secondaryLink: {
    paddingVertical: 8,
  },
  secondaryText: {
    fontSize: 14, // Stitch text-[14px]
    fontFamily: FontFamily.regular,
  },
  secondaryBold: {
    fontFamily: FontFamily.semibold,
    fontWeight: FontWeight.semibold,
  },
});
