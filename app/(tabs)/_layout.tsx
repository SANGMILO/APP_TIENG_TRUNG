import { Tabs } from 'expo-router';
import { PremiumTabBar } from '@/components/navigation/PremiumTabBar';

export default function TabsLayout() {
  return (
    <Tabs
      tabBar={(props) => <PremiumTabBar {...props} />}
      screenOptions={{
        headerShown: false,
      }}
    >
      <Tabs.Screen
        name="learn"
        options={{
          title: 'Học',
        }}
      />
      <Tabs.Screen
        name="review"
        options={{
          title: 'Ôn tập',
        }}
      />
      <Tabs.Screen
        name="ai-tutor"
        options={{
          title: 'AI',
        }}
      />
      <Tabs.Screen
        name="videos"
        options={{
          title: 'Video',
        }}
      />
      <Tabs.Screen
        name="profile"
        options={{
          title: 'Tôi',
        }}
      />
    </Tabs>
  );
}
