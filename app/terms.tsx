import React from 'react';
import { ScrollView, StyleSheet, Text, TouchableOpacity, View } from 'react-native';
import { router } from 'expo-router';
import { useThemeStore } from '@/stores/theme-store';
import { FontSize, Spacing } from '@/constants/theme';

export default function TermsOfUseScreen() {
  const { colors } = useThemeStore();

  return (
    <ScrollView
      style={[styles.container, { backgroundColor: colors.background }]}
      contentContainerStyle={styles.content}
    >
      <TouchableOpacity onPress={() => router.back()}>
        <Text style={[styles.backButton, { color: colors.primary }]}>← Quay lại</Text>
      </TouchableOpacity>

      <Text style={[styles.title, { color: colors.text }]}>Điều khoản sử dụng</Text>
      <Text style={[styles.updated, { color: colors.textTertiary }]}>
        Cập nhật: Tháng 7, 2026
      </Text>

      <Section title="1. Chấp nhận điều khoản" colors={colors}>
        Khi tạo tài khoản hoặc sử dụng Mandarin Master, bạn xác nhận đã đọc và
        đồng ý với các điều khoản này cùng Chính sách quyền riêng tư.
      </Section>

      <Section title="2. Tài khoản" colors={colors}>
        Bạn chịu trách nhiệm giữ an toàn thông tin đăng nhập và cung cấp thông
        tin tài khoản chính xác. Không được sử dụng tài khoản của người khác,
        chia sẻ quyền truy cập trái phép hoặc can thiệp vào hoạt động của dịch vụ.
      </Section>

      <Section title="3. Mục đích học tập" colors={colors}>
        Nội dung bài học, đánh giá phát âm và phản hồi từ AI được cung cấp cho
        mục đích giáo dục. Kết quả tự động có thể không hoàn toàn chính xác và
        không thay thế tư vấn chuyên môn hay chứng nhận ngôn ngữ chính thức.
      </Section>

      <Section title="4. Sử dụng phù hợp" colors={colors}>
        Bạn không được khai thác lỗ hổng, tự động hóa truy cập gây quá tải, tải
        lên nội dung trái pháp luật, xâm phạm quyền của người khác hoặc cố gắng
        truy cập dữ liệu không thuộc tài khoản của mình.
      </Section>

      <Section title="5. Nội dung và quyền sở hữu" colors={colors}>
        Ứng dụng, thiết kế, bài học và tài liệu do Mandarin Master cung cấp được
        bảo vệ theo quyền sở hữu tương ứng. Bạn được sử dụng nội dung trong phạm
        vi cá nhân, phi thương mại để học tập, trừ khi có thỏa thuận khác.
      </Section>

      <Section title="6. Tính sẵn sàng và thay đổi" colors={colors}>
        Một số tính năng phụ thuộc vào kết nối mạng hoặc nhà cung cấp bên thứ ba.
        Chúng tôi có thể sửa lỗi, cập nhật hoặc ngừng một tính năng khi cần thiết
        để đảm bảo an toàn và chất lượng dịch vụ.
      </Section>

      <Section title="7. Chấm dứt và yêu cầu xóa tài khoản" colors={colors}>
        Bạn có thể ngừng sử dụng dịch vụ bất kỳ lúc nào. Yêu cầu xóa tài khoản
        phải được gửi từ phiên đã xác thực và sẽ được xử lý theo quy trình hiển
        thị trong ứng dụng cùng Chính sách quyền riêng tư.
      </Section>

      <Section title="8. Cập nhật điều khoản" colors={colors}>
        Điều khoản có thể được cập nhật khi sản phẩm hoặc yêu cầu pháp lý thay
        đổi. Ngày cập nhật gần nhất được hiển thị ở đầu trang này.
      </Section>

      <Text style={[styles.legal, { color: colors.textTertiary }]}>
        Liên hệ: support@mandarinmaster.app
      </Text>
    </ScrollView>
  );
}

function Section({
  title,
  children,
  colors,
}: {
  title: string;
  children: React.ReactNode;
  colors: any;
}) {
  return (
    <View style={styles.section}>
      <Text style={[styles.sectionTitle, { color: colors.text }]}>{title}</Text>
      <Text style={[styles.sectionBody, { color: colors.textSecondary }]}>
        {children}
      </Text>
    </View>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1 },
  content: {
    paddingHorizontal: Spacing.xl,
    paddingTop: Spacing['5xl'],
    paddingBottom: Spacing['4xl'],
  },
  backButton: {
    fontSize: FontSize.base,
    fontWeight: '500',
    marginBottom: Spacing.lg,
  },
  title: {
    fontSize: FontSize['2xl'],
    fontWeight: 'bold',
    marginBottom: Spacing.xs,
  },
  updated: { fontSize: FontSize.sm, marginBottom: Spacing['2xl'] },
  section: { marginBottom: Spacing['2xl'] },
  sectionTitle: {
    fontSize: FontSize.lg,
    fontWeight: '600',
    marginBottom: Spacing.sm,
  },
  sectionBody: { fontSize: FontSize.md, lineHeight: 24 },
  legal: { fontSize: FontSize.sm, marginTop: Spacing.xl, lineHeight: 20 },
});
