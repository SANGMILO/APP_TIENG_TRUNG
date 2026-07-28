declare const require: (moduleName: string) => any;
declare const __dirname: string;

import { isProtectedRoute } from '../services/auth-navigation';

const fs = require('fs');
const path = require('path');

function read(relativePath: string): string {
  return fs.readFileSync(path.join(__dirname, '..', relativePath), 'utf8');
}

describe('auth finishing contracts', () => {
  const login = read('app/(auth)/login.tsx');
  const register = read('app/(auth)/register.tsx');
  const authStore = read('stores/auth-store.ts');
  const supabaseClient = read('lib/supabase/client.ts');
  const onboarding = read('app/onboarding/index.tsx');

  it('uses real persistent session storage without a dead Remember Me control', () => {
    expect(supabaseClient).toContain('persistSession: true');
    expect(supabaseClient).toContain('expo-secure-store');
    expect(login).not.toContain('Ghi nhớ đăng nhập');
  });

  it('does not expose Apple sign-in without provider configuration', () => {
    expect(login).not.toContain('Tiếp tục với Apple');
    expect(register).not.toContain('Đăng ký với Apple');
  });

  it('keeps consent separate from independent legal destinations', () => {
    expect(register).toContain("router.push('/terms')");
    expect(register).toContain("router.push('/privacy')");
    expect(register).toContain('accessibilityRole="checkbox"');
    expect(read('app/terms.tsx')).toContain('Điều khoản sử dụng');
    expect(isProtectedRoute(['terms'])).toBe(false);
    expect(isProtectedRoute(['privacy'])).toBe(false);
  });

  it('coalesces concurrent auth initialization and replaces listeners', () => {
    expect(authStore).toContain('let initializationPromise: Promise<void> | null');
    expect(authStore).toContain('if (initializationPromise)');
    expect(authStore).toContain('authSubscription?.unsubscribe()');
    expect(authStore).toContain('initializationPromise = null');
  });

  it('shows retryable onboarding persistence failures instead of logging only', () => {
    expect(onboarding).toContain('Không thể lưu thiết lập học tập');
    expect(onboarding).toContain('{error ? (');
    expect(onboarding).not.toContain("console.error('Onboarding error:'");
  });
});
