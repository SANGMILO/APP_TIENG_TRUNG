import { IAnalyticsProvider, AnalyticsEvent, AnalyticsProperties } from './types';

export type { IAnalyticsProvider, AnalyticsEvent, AnalyticsProperties };

/**
 * Console-based analytics for development.
 * Replace with actual provider (Mixpanel, Amplitude, etc.) for production.
 */
class DevAnalyticsProvider implements IAnalyticsProvider {
  track(event: AnalyticsEvent, properties?: AnalyticsProperties): void {
    if (__DEV__) {
      console.log(`[Analytics] ${event}`, properties);
    }
  }

  identify(userId: string, traits?: AnalyticsProperties): void {
    if (__DEV__) {
      console.log(`[Analytics] Identify: ${userId}`, traits);
    }
  }

  reset(): void {
    if (__DEV__) {
      console.log('[Analytics] Reset');
    }
  }
}

// Singleton analytics instance
export const analytics: IAnalyticsProvider = new DevAnalyticsProvider();
