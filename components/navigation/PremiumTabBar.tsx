import React, { useEffect } from 'react';
import { Platform, StyleSheet, Text, View } from 'react-native';
import { Ionicons } from '@expo/vector-icons';
import { Tabs } from 'expo-router';
import Animated, {
  useAnimatedStyle,
  useSharedValue,
  withTiming,
} from 'react-native-reanimated';
import { useSafeAreaInsets } from 'react-native-safe-area-context';
import { AnimatedPressable } from '@/components/ui';
import {
  Animation,
  BorderRadius,
  FontFamily,
  FontSize,
  FontWeight,
  Shadow,
  Spacing,
} from '@/constants/theme';
import { useThemeStore } from '@/stores/theme-store';

type IoniconsName = keyof typeof Ionicons.glyphMap;
type TabsProps = React.ComponentProps<typeof Tabs>;
type PremiumTabBarProps = Parameters<NonNullable<TabsProps['tabBar']>>[0];

const TAB_BAR_HEIGHT = 68;
const TAB_BAR_EDGE_INSET = Spacing.lg;
const TAB_BAR_MIN_BOTTOM_INSET = 12;
const CONTENT_CLEARANCE = Spacing['2xl'];

const TAB_ICONS: Record<string, { active: IoniconsName; inactive: IoniconsName }> = {
  learn: { active: 'school', inactive: 'school-outline' },
  review: { active: 'refresh-circle', inactive: 'refresh-circle-outline' },
  'ai-tutor': { active: 'chatbubble-ellipses', inactive: 'chatbubble-ellipses-outline' },
  videos: { active: 'play-circle', inactive: 'play-circle-outline' },
  profile: { active: 'person-circle', inactive: 'person-circle-outline' },
};

export function getPremiumTabContentInset(safeAreaBottom: number): number {
  return TAB_BAR_HEIGHT + Math.max(safeAreaBottom, TAB_BAR_MIN_BOTTOM_INSET) + CONTENT_CLEARANCE;
}

export function PremiumTabBar({ state, descriptors, navigation }: PremiumTabBarProps) {
  const { colors } = useThemeStore();
  const insets = useSafeAreaInsets();
  const bottomInset = Platform.OS === 'web'
    ? TAB_BAR_MIN_BOTTOM_INSET
    : Math.max(insets.bottom, TAB_BAR_MIN_BOTTOM_INSET);

  return (
    <View
      pointerEvents="box-none"
      style={[styles.positioner, { bottom: bottomInset }]}
    >
      <View
        style={[
          styles.bar,
          {
            backgroundColor: colors.tabBar,
            borderColor: colors.tabBarBorder,
            shadowColor: colors.primaryDark,
          },
        ]}
      >
        {state.routes.map((route, index) => {
          const focused = state.index === index;
          const options = descriptors[route.key].options;
          const label = typeof options.tabBarLabel === 'string'
            ? options.tabBarLabel
            : options.title ?? route.name;

          const onPress = () => {
            const event = navigation.emit({
              type: 'tabPress',
              target: route.key,
              canPreventDefault: true,
            });

            if (!focused && !event.defaultPrevented) {
              navigation.navigate(route.name, route.params);
            }
          };

          const onLongPress = () => {
            navigation.emit({
              type: 'tabLongPress',
              target: route.key,
            });
          };

          return (
            <PremiumTabItem
              key={route.key}
              routeName={route.name}
              label={label}
              focused={focused}
              activeColor={colors.primary}
              inactiveColor={colors.textTertiary}
              activeBackground={colors.primary + '12'}
              onPress={onPress}
              onLongPress={onLongPress}
              testID={options.tabBarButtonTestID}
            />
          );
        })}
      </View>
    </View>
  );
}

interface PremiumTabItemProps {
  routeName: string;
  label: string;
  focused: boolean;
  activeColor: string;
  inactiveColor: string;
  activeBackground: string;
  onPress: () => void;
  onLongPress: () => void;
  testID?: string;
}

function PremiumTabItem({
  routeName,
  label,
  focused,
  activeColor,
  inactiveColor,
  activeBackground,
  onPress,
  onLongPress,
  testID,
}: PremiumTabItemProps) {
  const activeProgress = useSharedValue(focused ? 1 : 0);
  const icons = TAB_ICONS[routeName] ?? {
    active: 'ellipse' as IoniconsName,
    inactive: 'ellipse-outline' as IoniconsName,
  };

  useEffect(() => {
    activeProgress.value = withTiming(focused ? 1 : 0, {
      duration: Animation.normal,
    });
  }, [activeProgress, focused]);

  const activeStyle = useAnimatedStyle(() => ({
    opacity: activeProgress.value,
    transform: [{ scale: 0.92 + activeProgress.value * 0.08 }],
  }));

  return (
    <AnimatedPressable
      accessibilityRole="tab"
      accessibilityState={focused ? { selected: true } : {}}
      accessibilityLabel={label}
      testID={testID}
      onPress={onPress}
      onLongPress={onLongPress}
      scaleValue={0.94}
      style={styles.item}
    >
      <Animated.View
        pointerEvents="none"
        style={[
          styles.activeBackground,
          { backgroundColor: activeBackground },
          activeStyle,
        ]}
      />
      <Ionicons
        name={focused ? icons.active : icons.inactive}
        size={22}
        color={focused ? activeColor : inactiveColor}
      />
      <Text
        numberOfLines={1}
        style={[
          styles.label,
          {
            color: focused ? activeColor : inactiveColor,
            fontFamily: focused ? FontFamily.semibold : FontFamily.medium,
            fontWeight: focused ? FontWeight.semibold : FontWeight.medium,
          },
        ]}
      >
        {label}
      </Text>
    </AnimatedPressable>
  );
}

const styles = StyleSheet.create({
  positioner: {
    position: 'absolute',
    left: TAB_BAR_EDGE_INSET,
    right: TAB_BAR_EDGE_INSET,
    zIndex: 50,
    alignItems: 'center',
  },
  bar: {
    width: '100%',
    maxWidth: 512,
    height: TAB_BAR_HEIGHT,
    flexDirection: 'row',
    alignItems: 'center',
    paddingHorizontal: Spacing.xs,
    paddingVertical: Spacing.sm,
    borderRadius: BorderRadius['2xl'],
    borderWidth: StyleSheet.hairlineWidth,
    ...Shadow.md,
  },
  item: {
    flex: 1,
    height: 52,
    minWidth: 0,
    borderRadius: BorderRadius.lg,
    alignItems: 'center',
    justifyContent: 'center',
    gap: 2,
    overflow: 'hidden',
  },
  activeBackground: {
    position: 'absolute',
    top: 0,
    right: 0,
    bottom: 0,
    left: 0,
    borderRadius: BorderRadius.lg,
  },
  label: {
    fontSize: FontSize['2xs'],
    lineHeight: 13,
  },
});
