import React, { useEffect } from 'react';
import { ViewStyle } from 'react-native';
import Animated, {
  useSharedValue,
  useAnimatedStyle,
  withRepeat,
  withTiming,
  Easing,
} from 'react-native-reanimated';

interface PulsingDotProps {
  size?: number;
  color?: string;
  style?: ViewStyle;
}

/**
 * An animated pulsing dot indicator.
 * Great for showing "live" status, active items, or current lesson.
 */
export function PulsingDot({ size = 12, color = '#10B981', style }: PulsingDotProps) {
  const scale = useSharedValue(1);
  const opacity = useSharedValue(1);

  useEffect(() => {
    scale.value = withRepeat(
      withTiming(1.6, { duration: 1200, easing: Easing.out(Easing.cubic) }),
      -1,
      true
    );
    opacity.value = withRepeat(
      withTiming(0.3, { duration: 1200, easing: Easing.out(Easing.cubic) }),
      -1,
      true
    );
  }, []);

  const pulseStyle = useAnimatedStyle(() => ({
    transform: [{ scale: scale.value }],
    opacity: opacity.value,
  }));

  return (
    <Animated.View style={[{ position: 'relative', width: size, height: size }, style]}>
      {/* Pulse ring */}
      <Animated.View
        style={[
          {
            position: 'absolute',
            width: size,
            height: size,
            borderRadius: size / 2,
            backgroundColor: color,
          },
          pulseStyle,
        ]}
      />
      {/* Solid dot */}
      <Animated.View
        style={{
          width: size,
          height: size,
          borderRadius: size / 2,
          backgroundColor: color,
        }}
      />
    </Animated.View>
  );
}
