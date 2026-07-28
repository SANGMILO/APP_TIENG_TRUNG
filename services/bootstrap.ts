interface BootstrapState {
  isAuthInitialized: boolean;
  fontsLoaded: boolean;
  fontError: Error | null;
  fontTimedOut: boolean;
}

export function isBootstrapReady(state: BootstrapState): boolean {
  const fontsReady = state.fontsLoaded || Boolean(state.fontError) || state.fontTimedOut;
  return state.isAuthInitialized && fontsReady;
}
