import React from 'react';
import { TouchableOpacity, TouchableOpacityProps, ViewStyle } from 'react-native';
import Animated, {
  useSharedValue,
  useAnimatedStyle,
  withSpring,
  withTiming,
} from 'react-native-reanimated';

const AnimatedTouchable = Animated.createAnimatedComponent(TouchableOpacity);

interface AnimatedPressableProps extends TouchableOpacityProps {
  scaleValue?: number;
  children: React.ReactNode;
}

/**
 * A touchable component with a satisfying scale-down animation on press.
 * Makes interactions feel more alive and tactile.
 */
export function AnimatedPressable({
  scaleValue = 0.95,
  children,
  style,
  onPressIn,
  onPressOut,
  ...props
}: AnimatedPressableProps) {
  const scale = useSharedValue(1);

  const animatedStyle = useAnimatedStyle(() => ({
    transform: [{ scale: scale.value }],
  }));

  return (
    <AnimatedTouchable
      activeOpacity={0.9}
      onPressIn={(e) => {
        scale.value = withSpring(scaleValue, { damping: 15, stiffness: 200 });
        onPressIn?.(e);
      }}
      onPressOut={(e) => {
        scale.value = withSpring(1, { damping: 12, stiffness: 180 });
        onPressOut?.(e);
      }}
      style={[animatedStyle, style as ViewStyle]}
      {...props}
    >
      {children}
    </AnimatedTouchable>
  );
}
