import React, { useEffect } from 'react';
import { ViewStyle } from 'react-native';
import Animated, {
  useSharedValue,
  useAnimatedStyle,
  withTiming,
  withDelay,
  withSpring,
  Easing,
} from 'react-native-reanimated';

type AnimationType = 'fadeIn' | 'slideUp' | 'slideDown' | 'slideLeft' | 'slideRight' | 'scaleIn' | 'bounceIn';

interface FadeInViewProps {
  children: React.ReactNode;
  delay?: number;
  duration?: number;
  animation?: AnimationType;
  style?: ViewStyle;
}

/**
 * Wraps children in an entrance animation.
 * Perfect for staggered list animations and page transitions.
 */
export function FadeInView({
  children,
  delay = 0,
  duration = 500,
  animation = 'fadeIn',
  style,
}: FadeInViewProps) {
  const opacity = useSharedValue(0);
  const translateY = useSharedValue(animation === 'slideUp' ? 30 : animation === 'slideDown' ? -30 : 0);
  const translateX = useSharedValue(animation === 'slideLeft' ? 30 : animation === 'slideRight' ? -30 : 0);
  const scale = useSharedValue(animation === 'scaleIn' || animation === 'bounceIn' ? 0.8 : 1);

  useEffect(() => {
    opacity.value = withDelay(delay, withTiming(1, { duration, easing: Easing.out(Easing.cubic) }));

    if (animation === 'slideUp' || animation === 'slideDown') {
      translateY.value = withDelay(delay, withTiming(0, { duration, easing: Easing.out(Easing.cubic) }));
    }
    if (animation === 'slideLeft' || animation === 'slideRight') {
      translateX.value = withDelay(delay, withTiming(0, { duration, easing: Easing.out(Easing.cubic) }));
    }
    if (animation === 'scaleIn') {
      scale.value = withDelay(delay, withTiming(1, { duration, easing: Easing.out(Easing.cubic) }));
    }
    if (animation === 'bounceIn') {
      scale.value = withDelay(delay, withSpring(1, { damping: 8, stiffness: 150 }));
    }
  }, []);

  const animatedStyle = useAnimatedStyle(() => ({
    opacity: opacity.value,
    transform: [
      { translateY: translateY.value },
      { translateX: translateX.value },
      { scale: scale.value },
    ],
  }));

  return (
    <Animated.View style={[animatedStyle, style]}>
      {children}
    </Animated.View>
  );
}
