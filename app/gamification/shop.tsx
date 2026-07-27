import React from 'react';
import { View, Text, StyleSheet, FlatList, TouchableOpacity, ActivityIndicator, Alert } from 'react-native';
import { Ionicons } from '@expo/vector-icons';
import { router } from 'expo-router';
import { useSafeAreaInsets } from 'react-native-safe-area-context';
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { useThemeStore } from '@/stores/theme-store';
import { useAuthStore } from '@/stores/auth-store';
import { fetchShopItems, purchaseItem } from '@/services/gamification-service';
import { EmptyState } from '@/components/ui';
import { FontSize, Spacing, BorderRadius, Shadow, FontWeight } from '@/constants/theme';

export default function ShopScreen() {
  const { colors } = useThemeStore();
  const { profile, fetchProfile } = useAuthStore();
  const insets = useSafeAreaInsets();
  const queryClient = useQueryClient();

  const { data: items, isLoading } = useQuery({
    queryKey: ['shop-items'],
    queryFn: fetchShopItems,
  });

  const purchaseMutation = useMutation({
    mutationFn: (itemId: string) => purchaseItem(itemId),
    onSuccess: (result) => {
      if (result.success) {
        fetchProfile();
        queryClient.invalidateQueries({ queryKey: ['gamification-summary'] });
        queryClient.invalidateQueries({ queryKey: ['inventory'] });
      }
    },
  });

  const handlePurchase = (item: any) => {
    if ((profile?.total_coins ?? 0) < item.price_coins) {
      Alert.alert('Không đủ Coins', 'Bạn cần thêm coins để mua vật phẩm này.');
      return;
    }
    purchaseMutation.mutate(item.id);
  };

  return (
    <View style={[styles.screen, { backgroundColor: colors.background }]}>
      {/* Header */}
      <View style={[styles.header, { paddingTop: insets.top + Spacing.md }]}>
        <TouchableOpacity onPress={() => router.back()} style={[styles.backBtn, { backgroundColor: colors.surfaceElevated }]}>
          <Ionicons name="chevron-back" size={20} color={colors.text} />
        </TouchableOpacity>
        <Text style={[styles.screenTitle, { color: colors.text }]}>Cửa hàng</Text>
        <View style={[styles.coinBadge, { backgroundColor: colors.coinLight }]}>
          <Ionicons name="wallet" size={14} color={colors.coin} />
          <Text style={[styles.coinValue, { color: colors.coin }]}>{profile?.total_coins ?? 0}</Text>
        </View>
      </View>

      {isLoading ? (
        <View style={styles.center}><ActivityIndicator size="large" color={colors.primary} /></View>
      ) : (
        <FlatList
          data={items}
          keyExtractor={(item) => item.id}
          contentContainerStyle={styles.list}
          renderItem={({ item }) => {
            const canAfford = (profile?.total_coins ?? 0) >= item.price_coins;
            return (
              <View style={[styles.itemCard, { backgroundColor: colors.card }]}>
                <View style={[styles.itemIconWrap, { backgroundColor: colors.surfaceElevated }]}>
                  <Ionicons name="gift-outline" size={22} color={colors.text} />
                </View>
                <View style={styles.itemInfo}>
                  <Text style={[styles.itemName, { color: colors.text }]}>{item.name}</Text>
                  {item.description && <Text style={[styles.itemDesc, { color: colors.textSecondary }]}>{item.description}</Text>}
                </View>
                <TouchableOpacity
                  style={[styles.buyBtn, { backgroundColor: canAfford ? colors.primary : colors.surfaceMuted }]}
                  onPress={() => handlePurchase(item)}
                  disabled={!canAfford || purchaseMutation.isPending}
                >
                  <Ionicons name="wallet" size={12} color={canAfford ? '#fff' : colors.textTertiary} />
                  <Text style={[styles.buyText, { color: canAfford ? '#fff' : colors.textTertiary }]}>{item.price_coins}</Text>
                </TouchableOpacity>
              </View>
            );
          }}
          ListEmptyComponent={<EmptyState iconName="storefront-outline" title="Cửa hàng trống" description="Chưa có vật phẩm nào" />}
        />
      )}
    </View>
  );
}

const styles = StyleSheet.create({
  screen: { flex: 1 },
  header: { paddingHorizontal: Spacing.xl, flexDirection: 'row', alignItems: 'center', gap: Spacing.md, marginBottom: Spacing.lg },
  backBtn: { width: 36, height: 36, borderRadius: 18, justifyContent: 'center', alignItems: 'center' },
  screenTitle: { flex: 1, fontSize: FontSize.xl, fontWeight: FontWeight.bold },
  coinBadge: { flexDirection: 'row', alignItems: 'center', gap: 4, paddingHorizontal: Spacing.md, paddingVertical: Spacing.sm, borderRadius: BorderRadius.full },
  coinValue: { fontSize: FontSize.md, fontWeight: FontWeight.bold },
  center: { flex: 1, justifyContent: 'center', alignItems: 'center' },
  list: { paddingHorizontal: Spacing.xl, paddingBottom: Spacing['4xl'], gap: Spacing.md, maxWidth: 500, alignSelf: 'center', width: '100%' },
  itemCard: { flexDirection: 'row', alignItems: 'center', padding: Spacing.lg, borderRadius: BorderRadius.xl, gap: Spacing.md, ...Shadow.sm },
  itemIconWrap: { width: 44, height: 44, borderRadius: BorderRadius.lg, justifyContent: 'center', alignItems: 'center' },
  itemInfo: { flex: 1, gap: 2 },
  itemName: { fontSize: FontSize.base, fontWeight: FontWeight.semibold },
  itemDesc: { fontSize: FontSize.sm },
  buyBtn: { flexDirection: 'row', alignItems: 'center', gap: 4, paddingHorizontal: Spacing.md, paddingVertical: Spacing.sm, borderRadius: BorderRadius.lg },
  buyText: { fontSize: FontSize.sm, fontWeight: FontWeight.bold },
});
