import { IAnalyticsProvider, AnalyticsEvent, AnalyticsProperties } from './types';

export type { IAnalyticsProvider, AnalyticsEvent, AnalyticsProperties };

class NoopAnalyticsProvider implements IAnalyticsProvider {
  track(_event: AnalyticsEvent, _properties?: AnalyticsProperties): void {}
  identify(_userId: string, _traits?: AnalyticsProperties): void {}
  reset(): void {}
}

const noopProvider = new NoopAnalyticsProvider();
let configuredProvider: IAnalyticsProvider = noopProvider;

/**
 * Installs an owner-approved analytics provider. Until then, analytics is
 * intentionally silent and never writes identity, learning content, or traits
 * to the console.
 */
export function configureAnalyticsProvider(provider?: IAnalyticsProvider): void {
  configuredProvider = provider ?? noopProvider;
}

export const analytics: IAnalyticsProvider = {
  track(event, properties) {
    configuredProvider.track(event, properties);
  },
  identify(userId, traits) {
    configuredProvider.identify(userId, traits);
  },
  reset() {
    configuredProvider.reset();
  },
};
