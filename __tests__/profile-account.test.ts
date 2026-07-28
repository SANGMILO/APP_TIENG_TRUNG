declare const require: (moduleName: string) => any;
declare const __dirname: string;

import { supabase } from '../lib/supabase';
import { requestAccountDeletion } from '../services/account-service';
import {
  calculateLevelProgress,
  type LevelThreshold,
} from '../services/gamification-service';

jest.mock('../lib/supabase', () => ({
  supabase: {
    from: jest.fn(),
    rpc: jest.fn(),
    auth: { getUser: jest.fn() },
  },
}));

const thresholds: LevelThreshold[] = [
  { level: 1, xp_required: 0, title: 'Người mới' },
  { level: 2, xp_required: 100, title: 'Sơ cấp' },
  { level: 3, xp_required: 250, title: 'Học viên' },
  { level: 4, xp_required: 450, title: 'Tiến bộ' },
];

describe('profile and account completion', () => {
  beforeEach(() => {
    jest.clearAllMocks();
  });

  it('calculates level progress from real threshold boundaries', () => {
    expect(calculateLevelProgress(300, thresholds)).toEqual({
      level: 3,
      title: 'Học viên',
      currentThresholdXp: 250,
      nextLevel: 4,
      nextThresholdXp: 450,
      xpIntoLevel: 50,
      xpForLevel: 200,
      xpRemaining: 150,
      progressPercent: 25,
      isMaxLevel: false,
    });
  });

  it('handles the highest configured level without modulo rollover', () => {
    expect(calculateLevelProgress(1000, thresholds)).toMatchObject({
      level: 4,
      nextLevel: null,
      progressPercent: 100,
      xpRemaining: 0,
      isMaxLevel: true,
    });
  });

  it('returns no fabricated level when thresholds are unavailable', () => {
    expect(calculateLevelProgress(100, [])).toBeNull();
  });

  it('submits deletion confirmation without a client-selected user ID', async () => {
    (supabase.rpc as jest.Mock).mockResolvedValue({
      data: {
        success: true,
        request_id: 'request-1',
        status: 'pending',
        requested_at: '2026-07-29T12:00:00.000Z',
        already_requested: false,
      },
      error: null,
    });

    await expect(
      requestAccountDeletion('XÓA TÀI KHOẢN'),
    ).resolves.toMatchObject({
      request_id: 'request-1',
      status: 'pending',
    });
    expect(supabase.rpc).toHaveBeenCalledWith('request_account_deletion', {
      p_confirmation: 'XÓA TÀI KHOẢN',
    });
  });

  it('rejects malformed deletion success responses', async () => {
    (supabase.rpc as jest.Mock).mockResolvedValue({
      data: { success: true, status: 'pending' },
      error: null,
    });

    await expect(
      requestAccountDeletion('XÓA TÀI KHOẢN'),
    ).rejects.toThrow('account deletion request response was invalid');
  });

  it('removes hardcoded achievements and wires real profile destinations', () => {
    const fs = require('fs');
    const path = require('path');
    const profile = fs.readFileSync(
      path.join(__dirname, '..', 'app', '(tabs)', 'profile.tsx'),
      'utf8',
    );

    expect(profile).not.toContain('Chuỗi 7 Ngày');
    expect(profile).not.toContain('Video Master');
    expect(profile).not.toContain('totalXp % xpForNextLevel');
    expect(profile).toContain('Quản lý gói Premium');
    expect(profile).toContain('disabledLabel="Sắp có"');
    expect(profile).toContain("router.push('/account')");
    expect(profile).toContain("router.push('/notification-settings')");
    expect(profile).toContain("router.push('/privacy')");
    expect(profile).toContain("router.push('/gamification/achievements')");
  });
});
