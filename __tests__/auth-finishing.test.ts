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

  it('uses real persistent session storage with an informational Remember Me state', () => {
    expect(supabaseClient).toContain('persistSession: true');
    expect(supabaseClient).toContain('expo-secure-store');
    expect(login).toContain('Ghi nhớ đăng nhập');
    expect(login).toContain('styles.rememberRow');
  });

  it('keeps Apple sign-in visible but honestly disabled without provider configuration', () => {
    expect(login).toContain('Tiếp tục với Apple');
    expect(register).toContain('Đăng ký với Apple');
    expect(login).toContain('accessibilityLabel="Tiếp tục với Apple, sắp có"');
    expect(register).toContain('accessibilityLabel="Đăng ký với Apple, sắp có"');
    expect(login).toMatch(/Tiếp tục với Apple[\s\S]*?Sắp có/);
    expect(register).toMatch(/Đăng ký với Apple[\s\S]*?Sắp có/);
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
