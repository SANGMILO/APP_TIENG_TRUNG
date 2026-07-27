import React, { useEffect } from 'react';
import { View, StyleSheet } from 'react-native';
import Animated, {
  useSharedValue,
  useAnimatedStyle,
  withRepeat,
  withTiming,
  withDelay,
  Easing,
} from 'react-native-reanimated';

interface Particle {
  size: number;
  leftPercent: number;
  topPercent: number;
  delay: number;
  duration: number;
  opacity: number;
}

interface FloatingParticlesProps {
  count?: number;
  color?: string;
  maxSize?: number;
}

/**
 * Decorative floating particles/bubbles that add visual depth.
 * Uses percentage-based positioning for proper responsive behavior.
 */
export function FloatingParticles({
  count = 6,
  color = 'rgba(255,255,255,0.1)',
  maxSize = 80,
}: FloatingParticlesProps) {
  const particles: Particle[] = React.useMemo(() => {
    return Array.from({ length: count }, (_, i) => ({
      size: 20 + Math.random() * maxSize,
      leftPercent: Math.random() * 80, // 0-80% from left
      topPercent: Math.random() * 70,  // 0-70% from top
      delay: i * 400,
      duration: 3000 + Math.random() * 4000,
      opacity: 0.05 + Math.random() * 0.12,
    }));
  }, [count, maxSize]);

  return (
    <View style={StyleSheet.absoluteFill} pointerEvents="none">
      {particles.map((particle, index) => (
        <FloatingBubble key={index} particle={particle} color={color} />
      ))}
    </View>
  );
}

function FloatingBubble({ particle, color }: { particle: Particle; color: string }) {
  const translateY = useSharedValue(0);
  const scale = useSharedValue(1);

  useEffect(() => {
    translateY.value = withDelay(
      particle.delay,
      withRepeat(
        withTiming(-20, { duration: particle.duration, easing: Easing.inOut(Easing.sin) }),
        -1,
        true
      )
    );
    scale.value = withDelay(
      particle.delay,
      withRepeat(
        withTiming(1.1, { duration: particle.duration * 0.8, easing: Easing.inOut(Easing.sin) }),
        -1,
        true
      )
    );
  }, []);

  const animatedStyle = useAnimatedStyle(() => ({
    transform: [
      { translateY: translateY.value },
      { scale: scale.value },
    ],
  }));

  return (
    <Animated.View
      style={[
        {
          position: 'absolute',
          width: particle.size,
          height: particle.size,
          borderRadius: particle.size / 2,
          backgroundColor: color,
          opacity: particle.opacity,
          left: `${particle.leftPercent}%`,
          top: `${particle.topPercent}%`,
        },
        animatedStyle,
      ]}
    />
  );
}
