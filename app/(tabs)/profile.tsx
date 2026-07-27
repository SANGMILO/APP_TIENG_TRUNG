import React from 'react';
import {
  View,
  Text,
  StyleSheet,
  ScrollView,
  TouchableOpacity,
} from 'react-native';
import { LinearGradient } from 'expo-linear-gradient';
import { Ionicons } from '@expo/vector-icons';
import { useSafeAreaInsets } from 'react-native-safe-area-context';
import { useThemeStore } from '@/stores/theme-store';
import { useAuthStore } from '@/stores/auth-store';
import { FadeInView, AnimatedPressable, Avatar, ProgressBar } from '@/components/ui';
import { FontSize, Spacing, BorderRadius, Shadow, FontWeight, FontFamily } from '@/constants/theme';

// ─── Types ──────────────────────────────────────────────────────────────────────

interface StatCardProps {
  icon: string;
  value: number | string;
  label: string;
  iconColor: string;
  iconBgColor: string;
  colors: any;
}

interface AchievementBadgeProps {
  icon: string;
  title: string;
  status: string;
  unlocked: boolean;
  iconColor: string;
  iconBgColor: string;
  colors: any;
}

interface SettingRowProps {
  iconName: string;
  title: string;
  onPress?: () => void;
  colors: any;
  isLast?: boolean;
}

// ─── Main Component ─────────────────────────────────────────────────────────────

export default function ProfileScreen() {
  const { colors, mode, toggleMode } = useThemeStore();
  const { profile, signOut } = useAuthStore();
  const insets = useSafeAreaInsets();

  const currentLevel = profile?.current_level ?? 1;
  const totalXp = profile?.total_xp ?? 0;
  const xpForNextLevel = currentLevel * 100;
  const xpInCurrentLevel = totalXp % xpForNextLevel;
  const xpProgress = xpForNextLevel > 0 ? (xpInCurrentLevel / xpForNextLevel) * 100 : 0;

  const memberSinceDate = profile?.created_at
    ? new Date(profile.created_at).toLocaleDateString('vi-VN', { month: 'long', year: 'numeric' })
    : '';

  // Hearts display: show "∞" for unlimited (premium), otherwise the number
  const heartsDisplay = (profile?.hearts ?? 5) >= 99 ? '∞' : (profile?.hearts ?? 5);

  return (
    <View style={[styles.screen, { backgroundColor: colors.background }]}>
      <ScrollView
        contentContainerStyle={[styles.content, { paddingTop: insets.top + Spacing.lg, paddingBottom: 100 }]}
        showsVerticalScrollIndicator={false}
      >
        {/* ─── 1. User Profile Card ─────────────────────────────────────── */}
        <FadeInView delay={50} animation="slideUp">
          <View style={[styles.card, { backgroundColor: colors.card, borderColor: colors.border }]}>
            {/* Premium gradient accent at top */}
            <LinearGradient
              colors={[colors.primary + '20', 'transparent']}
              start={{ x: 0, y: 0 }}
              end={{ x: 1, y: 1 }}
              style={styles.cardAccent}
            />

            <View style={styles.profileSection}>
              {/* Avatar with gold border and star badge */}
              <View style={styles.avatarContainer}>
                <View style={[styles.avatarBorder, { borderColor: colors.secondary }]}>
                  <Avatar
                    name={profile?.display_name || profile?.email || undefined}
                    size="2xl"
                  />
                </View>
                {/* Gold star badge */}
                <View style={[styles.starBadge, { backgroundColor: colors.secondary, borderColor: colors.card }]}>
                  <Ionicons name="star" size={14} color="#FFFFFF" />
                </View>
              </View>

              {/* Name */}
              <Text style={[styles.profileName, { color: colors.text }]}>
                {profile?.display_name || profile?.username || 'Người học'}
              </Text>

              {/* Subtitle: Premium + member since */}
              <View style={styles.subtitleRow}>
                <Text style={[styles.premiumLabel, { color: colors.secondary }]}>
                  Hanzi Premium
                </Text>
                {memberSinceDate ? (
                  <>
                    <View style={[styles.dotSeparator, { backgroundColor: colors.border }]} />
                    <Text style={[styles.memberSince, { color: colors.textSecondary }]}>
                      Thành viên từ {memberSinceDate}
                    </Text>
                  </>
                ) : null}
              </View>

              {/* Edit Profile Button */}
              <TouchableOpacity
                style={[styles.editButton, { backgroundColor: colors.primary }]}
                activeOpacity={0.8}
              >
                <Ionicons name="pencil" size={16} color={colors.textOnPrimary} />
                <Text style={[styles.editButtonText, { color: colors.textOnPrimary }]}>
                  CHỈNH SỬA HỒ SƠ
                </Text>
              </TouchableOpacity>
            </View>
          </View>
        </FadeInView>

        {/* ─── 2. Stats Grid (2x2) ─────────────────────────────────────── */}
        <FadeInView delay={150} animation="slideUp">
          <View style={styles.statsGrid}>
            <StatCard
              icon="flame"
              value={profile?.current_streak ?? 0}
              label="Ngày liên tiếp"
              iconColor={colors.primary}
              iconBgColor={colors.primary + '12'}
              colors={colors}
            />
            <StatCard
              icon="flash"
              value={totalXp}
              label="Tổng XP"
              iconColor={colors.secondary}
              iconBgColor={colors.secondary + '12'}
              colors={colors}
            />
            <StatCard
              icon="heart"
              value={heartsDisplay}
              label="Mạng"
              iconColor={colors.primary}
              iconBgColor={colors.primary + '12'}
              colors={colors}
            />
            <StatCard
              icon="wallet"
              value={profile?.total_coins ?? 0}
              label="Đồng Vàng"
              iconColor={colors.secondary}
              iconBgColor={colors.secondary + '12'}
              colors={colors}
            />
          </View>
        </FadeInView>

        {/* ─── 3. Level Progress Card ───────────────────────────────────── */}
        <FadeInView delay={250} animation="slideUp">
          <View style={[styles.card, { backgroundColor: colors.card, borderColor: colors.border }]}>
            <View style={styles.levelHeader}>
              <View style={{ flex: 1 }}>
                <Text style={[styles.levelTitle, { color: colors.text }]}>
                  Level {currentLevel}
                </Text>
                <Text style={[styles.levelSubtitle, { color: colors.textSecondary }]}>
                  Thiếu {xpForNextLevel - xpInCurrentLevel} XP để lên Level {currentLevel + 1}
                </Text>
              </View>
              <Text style={[styles.nextLevelNumber, { color: colors.secondary }]}>
                {currentLevel + 1}
              </Text>
            </View>

            <View style={styles.progressBarContainer}>
              <ProgressBar
                progress={xpProgress}
                height={16}
                gradientColors={[colors.primary, colors.secondary]}
                animated
              />
            </View>

            <View style={styles.progressFooter}>
              <Text style={[styles.progressLabel, { color: colors.textSecondary }]}>
                {xpInCurrentLevel} XP
              </Text>
              <Text style={[styles.progressLabel, { color: colors.textSecondary }]}>
                {xpForNextLevel} XP
              </Text>
            </View>
          </View>
        </FadeInView>

        {/* ─── 4. Achievements Section ──────────────────────────────────── */}
        <FadeInView delay={350} animation="slideUp">
          <View style={[styles.card, { backgroundColor: colors.card, borderColor: colors.border }]}>
            <View style={styles.sectionHeader}>
              <Text style={[styles.sectionTitle, { color: colors.text }]}>Thành Tích</Text>
              <TouchableOpacity activeOpacity={0.7}>
                <Text style={[styles.seeAllLink, { color: colors.primary }]}>XEM TẤT CẢ</Text>
              </TouchableOpacity>
            </View>

            <View style={styles.achievementsGrid}>
              <AchievementBadge
                icon="trophy"
                title="Chuỗi 7 Ngày"
                status="Đã mở khóa"
                unlocked={true}
                iconColor={colors.secondary}
                iconBgColor={colors.secondary + '20'}
                colors={colors}
              />
              <AchievementBadge
                icon="language"
                title="100 Từ Vựng"
                status="Đã mở khóa"
                unlocked={true}
                iconColor={colors.primary}
                iconBgColor={colors.primary + '12'}
                colors={colors}
              />
              <AchievementBadge
                icon="play-circle"
                title="Video Master"
                status="Đã mở khóa"
                unlocked={true}
                iconColor={colors.jade}
                iconBgColor={colors.jade + '15'}
                colors={colors}
              />
              <AchievementBadge
                icon="lock-closed"
                title="Thánh Ngữ Pháp"
                status="Còn 5 bài"
                unlocked={false}
                iconColor={colors.textTertiary}
                iconBgColor={colors.surfaceElevated}
                colors={colors}
              />
            </View>
          </View>
        </FadeInView>

        {/* ─── 5. Settings Section ──────────────────────────────────────── */}
        <FadeInView delay={450} animation="slideUp">
          <View style={[styles.card, { backgroundColor: colors.card, borderColor: colors.border }]}>
            <Text style={[styles.settingsTitle, { color: colors.text }]}>Cài Đặt</Text>

            <SettingRow
              iconName="person-outline"
              title="Tài khoản & Hồ sơ"
              colors={colors}
            />
            <SettingRow
              iconName="notifications-outline"
              title="Thông báo"
              colors={colors}
            />
            <SettingRow
              iconName="shield-outline"
              title="Quyền riêng tư"
              colors={colors}
            />
            <SettingRow
              iconName={mode === 'dark' ? 'moon' : 'moon-outline'}
              title={mode === 'dark' ? 'Chế độ tối' : 'Chế độ sáng'}
              onPress={toggleMode}
              colors={colors}
            />
            <SettingRow
              iconName="diamond-outline"
              title="Quản lý gói Premium"
              colors={colors}
              isLast
            />

            {/* Sign Out Button */}
            <TouchableOpacity
              style={[styles.signOutButton, { backgroundColor: colors.surfaceElevated }]}
              onPress={signOut}
              activeOpacity={0.7}
            >
              <Ionicons name="log-out-outline" size={18} color={colors.error} />
              <Text style={[styles.signOutText, { color: colors.error }]}>
                ĐĂNG XUẤT
              </Text>
            </TouchableOpacity>
          </View>
        </FadeInView>
      </ScrollView>
    </View>
  );
}

// ─── Sub Components ─────────────────────────────────────────────────────────────

function StatCard({ icon, value, label, iconColor, iconBgColor, colors }: StatCardProps) {
  return (
    <AnimatedPressable
      scaleValue={0.97}
      style={[styles.statCard, { backgroundColor: colors.card, borderColor: colors.border }]}
    >
      <View style={[styles.statIconCircle, { backgroundColor: iconBgColor }]}>
        <Ionicons name={icon as any} size={24} color={iconColor} />
      </View>
      <View style={styles.statTextWrap}>
        <Text style={[styles.statValue, { color: colors.text }]}>
          {typeof value === 'number' ? value.toLocaleString() : value}
        </Text>
        <Text style={[styles.statLabel, { color: colors.textSecondary }]}>{label}</Text>
      </View>
    </AnimatedPressable>
  );
}

function AchievementBadge({ icon, title, status, unlocked, iconColor, iconBgColor, colors }: AchievementBadgeProps) {
  return (
    <AnimatedPressable
      scaleValue={0.95}
      disabled={!unlocked}
      style={[styles.achievementBadge, !unlocked && styles.achievementLocked]}
    >
      <View style={[styles.achievementIcon, { backgroundColor: iconBgColor }]}>
        <Ionicons name={icon as any} size={28} color={iconColor} />
      </View>
      <Text style={[styles.achievementTitle, { color: colors.text }]} numberOfLines={1}>
        {title}
      </Text>
      <Text style={[styles.achievementStatus, { color: colors.textSecondary }]}>
        {status}
      </Text>
    </AnimatedPressable>
  );
}

function SettingRow({ iconName, title, onPress, colors, isLast = false }: SettingRowProps) {
  return (
    <>
      <TouchableOpacity
        style={styles.settingRow}
        onPress={onPress}
        activeOpacity={0.6}
      >
        <View style={[styles.settingIconCircle, { backgroundColor: colors.surfaceElevated }]}>
          <Ionicons name={iconName as any} size={20} color={colors.textSecondary} />
        </View>
        <Text style={[styles.settingText, { color: colors.text }]}>{title}</Text>
        <Ionicons name="chevron-forward" size={18} color={colors.textTertiary} />
      </TouchableOpacity>
      {!isLast && (
        <View style={[styles.settingDivider, { backgroundColor: colors.borderLight }]} />
      )}
    </>
  );
}

// ─── Styles ─────────────────────────────────────────────────────────────────────

const styles = StyleSheet.create({
  screen: {
    flex: 1,
  },
  content: {
    paddingHorizontal: 20, // Stitch container-margin: 20px
    maxWidth: 500,
    alignSelf: 'center',
    width: '100%',
  },

  // ── Card base — Stitch: rounded-xl p-lg border border-surface-variant shadow-ambient ──
  card: {
    borderRadius: 12, // Stitch rounded-xl = 0.75rem = 12px
    borderWidth: 1,
    marginBottom: 24, // Stitch gap-lg = 24px
    overflow: 'hidden',
    ...Shadow.sm,
  },
  cardAccent: {
    position: 'absolute',
    top: 0,
    left: 0,
    right: 0,
    height: 96, // Stitch h-24
  },

  // ── Profile Section ──
  profileSection: {
    alignItems: 'center',
    paddingTop: 48, // enough clearance for gradient accent
    paddingBottom: 24, // Stitch p-lg
    paddingHorizontal: 24,
  },
  avatarContainer: {
    position: 'relative',
    marginBottom: 16, // Stitch mb-4
  },
  avatarBorder: {
    borderWidth: 4, // Stitch border-4
    borderRadius: 9999,
    padding: 4, // Stitch p-1
  },
  starBadge: {
    position: 'absolute',
    bottom: -8, // Stitch -bottom-2
    right: -8, // Stitch -right-2
    width: 32, // Stitch w-8
    height: 32, // Stitch h-8
    borderRadius: 16,
    justifyContent: 'center',
    alignItems: 'center',
    borderWidth: 2,
    ...Shadow.sm,
  },
  profileName: {
    fontSize: 28, // Stitch headline-lg-mobile: 28px
    fontFamily: FontFamily.heading,
    fontWeight: FontWeight.bold,
    lineHeight: 34, // Stitch lineHeight: 34px
    letterSpacing: -0.3,
    marginBottom: 4, // Stitch mb-1
    textAlign: 'center',
  },
  subtitleRow: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 8, // Stitch gap-2
    marginBottom: 16, // Stitch mb-4
  },
  premiumLabel: {
    fontSize: 16, // Stitch body-vn: 16px
    fontFamily: FontFamily.semibold,
    fontWeight: FontWeight.semibold,
  },
  dotSeparator: {
    width: 4, // Stitch w-1
    height: 4, // Stitch h-1
    borderRadius: 2,
  },
  memberSince: {
    fontSize: 16, // Stitch body-vn: 16px
    fontFamily: FontFamily.regular,
  },
  editButton: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'center',
    width: '100%',
    height: 56, // Stitch h-14
    borderRadius: 8, // Stitch rounded-lg = 0.5rem = 8px
    gap: 8,
    ...Shadow.sm,
  },
  editButtonText: {
    fontSize: 12, // Stitch label-sm: 12px
    fontFamily: FontFamily.semibold,
    fontWeight: FontWeight.semibold,
    lineHeight: 16,
    letterSpacing: 1.5, // Stitch tracking-wider
  },

  // ── Stats Grid — Stitch: grid grid-cols-2 gap-md ──
  statsGrid: {
    flexDirection: 'row',
    flexWrap: 'wrap',
    gap: 16, // Stitch gap-md = 16px
    marginBottom: 24,
  },
  statCard: {
    width: '47%',
    flexGrow: 1,
    borderRadius: 12, // Stitch rounded-xl
    padding: 16, // Stitch p-md
    borderWidth: 1,
    alignItems: 'center',
    justifyContent: 'center',
    gap: 8, // Stitch gap-2
    ...Shadow.sm,
  },
  statIconCircle: {
    width: 48, // Stitch w-12
    height: 48, // Stitch h-12
    borderRadius: 24,
    justifyContent: 'center',
    alignItems: 'center',
  },
  statTextWrap: {
    alignItems: 'center',
  },
  statValue: {
    fontSize: 28, // Stitch headline-lg-mobile: 28px
    fontFamily: FontFamily.heading,
    fontWeight: FontWeight.bold,
    lineHeight: 34,
  },
  statLabel: {
    fontSize: 12, // Stitch label-sm: 12px
    fontFamily: FontFamily.semibold,
    fontWeight: FontWeight.semibold,
    lineHeight: 16,
    letterSpacing: 0.8, // Stitch tracking-wide
    textTransform: 'uppercase',
    marginTop: 2,
  },

  // ── Level Progress — Stitch: p-lg ──
  levelHeader: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'flex-end',
    paddingHorizontal: 24, // Stitch p-lg horizontal
    paddingTop: 24,
    marginBottom: 16, // Stitch mb-4
  },
  levelTitle: {
    fontSize: 28, // Stitch headline-lg-mobile
    fontFamily: FontFamily.heading,
    fontWeight: FontWeight.bold,
    lineHeight: 34,
    marginBottom: 4,
  },
  levelSubtitle: {
    fontSize: 16, // Stitch body-vn
    fontFamily: FontFamily.regular,
    lineHeight: 24,
  },
  nextLevelNumber: {
    fontSize: 28, // Stitch headline-lg-mobile
    fontFamily: FontFamily.heading,
    fontWeight: FontWeight.bold,
    lineHeight: 34,
  },
  progressBarContainer: {
    paddingHorizontal: 24,
    marginBottom: 16, // Stitch mt-4
  },
  progressFooter: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    paddingHorizontal: 24,
    paddingBottom: 24,
  },
  progressLabel: {
    fontSize: 12, // Stitch label-sm in footer
    fontFamily: FontFamily.semibold,
    fontWeight: FontWeight.semibold,
    lineHeight: 16,
  },

  // ── Achievements — Stitch: p-lg ──
  sectionHeader: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    paddingHorizontal: 24,
    paddingTop: 24,
    marginBottom: 24, // Stitch mb-6
  },
  sectionTitle: {
    fontSize: 28, // Stitch headline-lg-mobile
    fontFamily: FontFamily.heading,
    fontWeight: FontWeight.bold,
    lineHeight: 34,
  },
  seeAllLink: {
    fontSize: 12, // Stitch label-sm
    fontFamily: FontFamily.semibold,
    fontWeight: FontWeight.semibold,
    lineHeight: 16,
    letterSpacing: 0.8, // Stitch tracking-wide
  },
  achievementsGrid: {
    flexDirection: 'row',
    flexWrap: 'wrap',
    paddingHorizontal: 16, // Stitch gap-md
    paddingBottom: 24,
  },
  achievementBadge: {
    width: '50%',
    alignItems: 'center',
    paddingVertical: 16, // Stitch p-md
    paddingHorizontal: 16,
  },
  achievementLocked: {
    opacity: 0.5, // Stitch opacity-50
  },
  achievementIcon: {
    width: 64, // Stitch w-16
    height: 64, // Stitch h-16
    borderRadius: 32,
    justifyContent: 'center',
    alignItems: 'center',
    marginBottom: 12, // Stitch mb-3
  },
  achievementTitle: {
    fontSize: 12, // Stitch label-sm
    fontFamily: FontFamily.semibold,
    fontWeight: FontWeight.semibold,
    lineHeight: 16,
    textAlign: 'center',
    marginBottom: 4, // Stitch mb-1
  },
  achievementStatus: {
    fontSize: 11, // Stitch text-xs (close to 12 but smaller)
    fontFamily: FontFamily.regular,
    textAlign: 'center',
  },

  // ── Settings — Stitch: p-lg ──
  settingsTitle: {
    fontSize: 28, // Stitch headline-lg-mobile
    fontFamily: FontFamily.heading,
    fontWeight: FontWeight.bold,
    lineHeight: 34,
    paddingHorizontal: 24,
    paddingTop: 24,
    marginBottom: 24, // Stitch mb-6
  },
  settingRow: {
    flexDirection: 'row',
    alignItems: 'center',
    paddingHorizontal: 24,
    paddingVertical: 16, // Stitch p-md
    gap: 16, // Stitch gap-4
  },
  settingIconCircle: {
    width: 40, // Stitch w-10
    height: 40, // Stitch h-10
    borderRadius: 20,
    justifyContent: 'center',
    alignItems: 'center',
  },
  settingText: {
    flex: 1,
    fontSize: 16, // Stitch body-vn: 16px
    fontFamily: FontFamily.medium,
    fontWeight: FontWeight.medium,
    lineHeight: 24,
  },
  settingDivider: {
    height: 1, // Stitch h-[1px]
    marginHorizontal: 24,
    marginVertical: 4, // Stitch my-1
  },
  signOutButton: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'center',
    marginHorizontal: 24,
    marginTop: 32, // Stitch mt-8
    marginBottom: 24,
    height: 56, // Stitch h-14
    borderRadius: 8, // Stitch rounded-lg
    gap: 8,
  },
  signOutText: {
    fontSize: 12, // Stitch label-sm
    fontFamily: FontFamily.semibold,
    fontWeight: FontWeight.semibold,
    lineHeight: 16,
    letterSpacing: 1.5, // Stitch tracking-wider
  },
});
