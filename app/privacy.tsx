import React from 'react';
import { View, Text, StyleSheet, ScrollView, TouchableOpacity } from 'react-native';
import { router } from 'expo-router';
import { useThemeStore } from '@/stores/theme-store';
import { FontSize, Spacing } from '@/constants/theme';

export default function PrivacyPolicyScreen() {
  const { colors } = useThemeStore();

  return (
    <ScrollView style={[styles.container, { backgroundColor: colors.background }]} contentContainerStyle={styles.content}>
      <TouchableOpacity onPress={() => router.back()}>
        <Text style={[styles.backBtn, { color: colors.primary }]}>← Quay lại</Text>
      </TouchableOpacity>

      <Text style={[styles.title, { color: colors.text }]}>Chính sách Bảo mật</Text>
      <Text style={[styles.updated, { color: colors.textTertiary }]}>Cập nhật: Tháng 7, 2026</Text>

      <Section title="1. Thông tin thu thập" colors={colors}>
        Mandarin Master thu thập các thông tin sau khi bạn sử dụng ứng dụng:{'\n\n'}
        • Thông tin tài khoản: email, tên hiển thị{'\n'}
        • Tiến trình học tập: bài học hoàn thành, điểm số, streak{'\n'}
        • Từ vựng đã học và lưu{'\n'}
        • Dữ liệu phát âm: audio được xử lý tạm thời để đánh giá, KHÔNG lưu trữ vĩnh viễn theo mặc định{'\n'}
        • Hội thoại AI Tutor: nội dung chat text{'\n'}
        • Giọng nói (Voice Tutor): audio được xử lý tạm thời để nhận dạng, KHÔNG lưu trữ vĩnh viễn theo mặc định{'\n'}
        • Tiến trình video: video đã xem, vị trí xem{'\n'}
        • Token thiết bị cho thông báo push (nếu bạn cho phép)
      </Section>

      <Section title="2. Cách sử dụng thông tin" colors={colors}>
        Chúng tôi sử dụng thông tin để:{'\n\n'}
        • Cung cấp dịch vụ học tập cá nhân hóa{'\n'}
        • Đánh giá phát âm tiếng Trung{'\n'}
        • Cung cấp hội thoại AI phù hợp trình độ{'\n'}
        • Theo dõi tiến trình và gamification{'\n'}
        • Gửi nhắc nhở học tập (nếu bạn cho phép)
      </Section>

      <Section title="3. Bên thứ ba" colors={colors}>
        Dữ liệu có thể được xử lý bởi:{'\n\n'}
        • Supabase (database, authentication){'\n'}
        • Azure Speech Services (đánh giá phát âm){'\n'}
        • OpenAI (AI Tutor, nhận dạng giọng nói, text-to-speech){'\n\n'}
        Chúng tôi không bán dữ liệu cá nhân cho bên thứ ba.
      </Section>

      <Section title="4. Bảo mật" colors={colors}>
        • Dữ liệu được mã hóa trong quá trình truyền tải{'\n'}
        • Audio phát âm/giọng nói xử lý tạm thời và không lưu trữ vĩnh viễn{'\n'}
        • Mỗi người dùng chỉ truy cập được dữ liệu của chính mình
      </Section>

      <Section title="5. Quyền của bạn" colors={colors}>
        Bạn có quyền:{'\n\n'}
        • Xem dữ liệu học tập của mình{'\n'}
        • Gửi yêu cầu xóa tài khoản và dữ liệu liên quan{'\n'}
        • Tắt thông báo push{'\n'}
        • Từ chối quyền microphone
      </Section>

      <Section title="6. Xóa tài khoản" colors={colors}>
        Bạn có thể gửi yêu cầu từ một phiên đã xác thực. Yêu cầu được lưu lại
        để đội vận hành xác minh và xử lý theo chính sách lưu giữ dữ liệu; ứng
        dụng không tuyên bố tài khoản đã bị xóa trước khi quy trình hoàn tất.
      </Section>

      <TouchableOpacity
        style={[styles.deletionButton, { borderColor: colors.error }]}
        onPress={() => router.push('/delete-account')}
      >
        <Text style={[styles.deletionButtonText, { color: colors.error }]}>
          Yêu cầu xóa tài khoản
        </Text>
      </TouchableOpacity>

      <Text style={[styles.legal, { color: colors.textTertiary }]}>
        Chính sách này có thể được cập nhật. Vui lòng kiểm tra định kỳ.{'\n'}
        Liên hệ: support@mandarinmaster.app
      </Text>
    </ScrollView>
  );
}

function Section({ title, children, colors }: { title: string; children: React.ReactNode; colors: any }) {
  return (
    <View style={styles.section}>
      <Text style={[styles.sectionTitle, { color: colors.text }]}>{title}</Text>
      <Text style={[styles.sectionBody, { color: colors.textSecondary }]}>{children}</Text>
    </View>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1 },
  content: { paddingHorizontal: Spacing.xl, paddingTop: Spacing['5xl'], paddingBottom: Spacing['4xl'] },
  backBtn: { fontSize: FontSize.base, fontWeight: '500', marginBottom: Spacing.lg },
  title: { fontSize: FontSize['2xl'], fontWeight: 'bold', marginBottom: Spacing.xs },
  updated: { fontSize: FontSize.sm, marginBottom: Spacing['2xl'] },
  section: { marginBottom: Spacing['2xl'] },
  sectionTitle: { fontSize: FontSize.lg, fontWeight: '600', marginBottom: Spacing.sm },
  sectionBody: { fontSize: FontSize.md, lineHeight: 24 },
  legal: { fontSize: FontSize.sm, marginTop: Spacing.xl, lineHeight: 20 },
  deletionButton: {
    minHeight: 48,
    borderWidth: 1,
    borderRadius: 10,
    alignItems: 'center',
    justifyContent: 'center',
    marginBottom: Spacing.xl,
  },
  deletionButtonText: { fontSize: FontSize.md, fontWeight: '600' },
});
