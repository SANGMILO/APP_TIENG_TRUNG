import { Tabs } from 'expo-router';
import { Platform, View, StyleSheet } from 'react-native';
import { Ionicons } from '@expo/vector-icons';
import { useSafeAreaInsets } from 'react-native-safe-area-context';
import { useThemeStore } from '@/stores/theme-store';
import { FontSize, Spacing, Shadow, BorderRadius, FontWeight } from '@/constants/theme';

type IoniconsName = keyof typeof Ionicons.glyphMap;

function TabIcon({ name, focused, color }: { name: IoniconsName; focused: boolean; color: string | undefined }) {
  return (
    <View style={[styles.tabIconWrap, focused && styles.tabIconActive]}>
      <Ionicons
        name={name}
        size={focused ? 22 : 20}
        color={color}
      />
    </View>
  );
}

export default function TabsLayout() {
  const { colors } = useThemeStore();
  const insets = useSafeAreaInsets();

  const bottomPadding = Platform.OS === 'ios' ? insets.bottom : 8;

  return (
    <Tabs
      screenOptions={{
        headerShown: false,
        tabBarActiveTintColor: colors.primary,
        tabBarInactiveTintColor: colors.textTertiary,
        tabBarStyle: {
          position: 'absolute',
          bottom: Platform.OS === 'web' ? 12 : Math.max(insets.bottom, 8),
          left: Spacing.lg,
          right: Spacing.lg,
          backgroundColor: colors.tabBar,
          borderTopWidth: 0,
          borderRadius: BorderRadius['2xl'],
          paddingTop: Spacing.sm,
          paddingBottom: Spacing.sm,
          height: 64,
          borderWidth: 1,
          borderColor: colors.glassBorder,
          ...Shadow.lg,
        },
        tabBarLabelStyle: {
          fontSize: FontSize['2xs'],
          fontWeight: FontWeight.semibold,
          marginTop: 2,
        },
        tabBarItemStyle: {
          paddingVertical: 4,
        },
      }}
    >
      <Tabs.Screen
        name="learn"
        options={{
          title: 'Học',
          tabBarIcon: ({ focused, color }) => (
            <TabIcon name={focused ? 'book' : 'book-outline'} focused={focused} color={color as string} />
          ),
        }}
      />
      <Tabs.Screen
        name="review"
        options={{
          title: 'Ôn tập',
          tabBarIcon: ({ focused, color }) => (
            <TabIcon name={focused ? 'refresh-circle' : 'refresh-circle-outline'} focused={focused} color={color as string} />
          ),
        }}
      />
      <Tabs.Screen
        name="ai-tutor"
        options={{
          title: 'AI',
          tabBarIcon: ({ focused, color }) => (
            <TabIcon name={focused ? 'chatbubble-ellipses' : 'chatbubble-ellipses-outline'} focused={focused} color={color as string} />
          ),
        }}
      />
      <Tabs.Screen
        name="videos"
        options={{
          title: 'Video',
          tabBarIcon: ({ focused, color }) => (
            <TabIcon name={focused ? 'play-circle' : 'play-circle-outline'} focused={focused} color={color as string} />
          ),
        }}
      />
      <Tabs.Screen
        name="profile"
        options={{
          title: 'Tôi',
          tabBarIcon: ({ focused, color }) => (
            <TabIcon name={focused ? 'person-circle' : 'person-circle-outline'} focused={focused} color={color as string} />
          ),
        }}
      />
    </Tabs>
  );
}

const styles = StyleSheet.create({
  tabIconWrap: {
    width: 36,
    height: 28,
    borderRadius: 14,
    alignItems: 'center',
    justifyContent: 'center',
  },
  tabIconActive: {
    backgroundColor: 'rgba(215, 38, 56, 0.08)',
  },
});
