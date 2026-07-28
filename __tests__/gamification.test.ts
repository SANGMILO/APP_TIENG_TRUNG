declare const require: (moduleName: string) => any;
declare const __dirname: string;

import { supabase } from '../lib/supabase';
import {
  fetchDailyQuests,
  fetchLeaderboard,
  getGamificationSummary,
  purchaseItem,
} from '../services/gamification-service';

const fs = require('fs');
const path = require('path');

jest.mock('../lib/supabase', () => ({
  supabase: {
    from: jest.fn(),
    rpc: jest.fn(),
    auth: { getUser: jest.fn() },
  },
}));

const migration = fs.readFileSync(
  path.join(
    __dirname,
    '..',
    'supabase',
    'migrations',
    '20260729060000_authoritative_gamification.sql',
  ),
  'utf8',
);
const backfillMigration = fs.readFileSync(
  path.join(
    __dirname,
    '..',
    'supabase',
    'migrations',
    '20260729070000_gamification_existing_data_backfill.sql',
  ),
  'utf8',
);

describe('authoritative gamification service', () => {
  beforeEach(() => {
    jest.clearAllMocks();
  });

  it('loads and normalizes the server-owned summary', async () => {
    (supabase.rpc as jest.Mock).mockResolvedValue({
      data: {
        level: 2,
        totalXp: 115,
        coins: 24,
        hearts: 5,
        dailyGoalXp: 30,
        todayXp: 17,
        streak: 4,
        longestStreak: 8,
        streakFreezeAvailable: true,
        boostActive: false,
      },
      error: null,
    });

    await expect(getGamificationSummary()).resolves.toEqual({
      level: 2,
      totalXp: 115,
      coins: 24,
      hearts: 5,
      dailyGoalXp: 30,
      todayXp: 17,
      streak: 4,
      longestStreak: 8,
      streakFreezeAvailable: true,
      boostActive: false,
    });
    expect(supabase.rpc).toHaveBeenCalledWith('get_gamification_summary');
  });

  it('rejects malformed summary data instead of displaying invented values', async () => {
    (supabase.rpc as jest.Mock).mockResolvedValue({
      data: { level: 'not-a-level' },
      error: null,
    });

    await expect(getGamificationSummary()).rejects.toThrow(
      'Invalid gamification summary',
    );
  });

  it('loads daily quests through the timezone-aware server RPC', async () => {
    (supabase.rpc as jest.Mock).mockResolvedValue({
      data: [{
        id: 'assignment-1',
        quest_id: 'quest-1',
        title: 'Ôn 5 từ',
        description: 'Ôn tập hôm nay',
        quest_type: 'review_completed',
        requirement_value: 5,
        progress: 2,
        completed: false,
        xp_reward: 10,
        coin_reward: 3,
      }],
      error: null,
    });

    await expect(fetchDailyQuests()).resolves.toEqual([{
      id: 'assignment-1',
      quest_id: 'quest-1',
      title: 'Ôn 5 từ',
      description: 'Ôn tập hôm nay',
      quest_type: 'review_completed',
      requirement_value: 5,
      progress: 2,
      completed: false,
      xp_reward: 10,
      coin_reward: 3,
    }]);
    expect(supabase.rpc).toHaveBeenCalledWith('get_daily_quests');
  });

  it('loads privacy-filtered leaderboard rows from the server', async () => {
    (supabase.rpc as jest.Mock).mockResolvedValue({
      data: [{
        user_id: 'user-2',
        display_name: 'Người học',
        avatar_url: null,
        xp_earned: 48,
        rank: 1,
        league: 'jade',
      }],
      error: null,
    });

    await expect(fetchLeaderboard()).resolves.toEqual([{
      user_id: 'user-2',
      display_name: 'Người học',
      avatar_url: null,
      xp_earned: 48,
      rank: 1,
      league: 'jade',
    }]);
    expect(supabase.rpc).toHaveBeenCalledWith('get_weekly_leaderboard');
  });

  it('uses a caller-stable purchase key and exposes confirmed retries', async () => {
    (supabase.rpc as jest.Mock).mockResolvedValue({
      data: { success: true, already_processed: true },
      error: null,
    });

    await expect(
      purchaseItem('streak-freeze-id', 'stable-attempt-id'),
    ).resolves.toEqual({
      success: true,
      alreadyProcessed: true,
    });
    expect(supabase.rpc).toHaveBeenCalledWith('purchase_shop_item', {
      p_item_id: 'streak-freeze-id',
      p_idempotency_key: 'stable-attempt-id',
    });
  });

  it('does not convert transport failures into a confirmed purchase result', async () => {
    (supabase.rpc as jest.Mock).mockResolvedValue({
      data: null,
      error: new Error('network unavailable'),
    });

    await expect(
      purchaseItem('streak-freeze-id', 'stable-attempt-id'),
    ).rejects.toThrow('network unavailable');
  });
});

describe('authoritative gamification migration', () => {
  it('revokes direct client mutation of reward state', () => {
    expect(migration).toMatch(
      /REVOKE INSERT, UPDATE, DELETE ON TABLE public\.user_achievements/,
    );
    expect(migration).toMatch(
      /REVOKE INSERT, UPDATE, DELETE ON TABLE public\.leaderboards/,
    );
    expect(migration).toMatch(
      /REVOKE ALL ON FUNCTION public\.record_gamification_event/,
    );
  });

  it('derives visible progress from trusted learning evidence', () => {
    expect(migration).toContain('CREATE TRIGGER on_lesson_gamification_event');
    expect(migration).toContain('CREATE TRIGGER on_review_gamification_event');
    expect(migration).toContain('CREATE TRIGGER on_pronunciation_gamification_event');
    expect(migration).toContain('CREATE TRIGGER on_video_gamification_event');
    expect(migration).toContain('CREATE TRIGGER on_voice_gamification_event');
  });

  it('makes event and purchase retries idempotent', () => {
    expect(migration).toMatch(
      /ON CONFLICT \(idempotency_key\)[\s\S]*?DO NOTHING/,
    );
    expect(migration).toContain('FOR UPDATE');
    expect(migration).toContain('processing_error = SQLSTATE');
    expect(migration).toContain('already_processed');
    expect(migration).toContain('purchase_shop_item');
  });

  it('uses a validated profile timezone with a safe application fallback', () => {
    expect(migration).toContain('pg_catalog.pg_timezone_names');
    expect(migration).toContain("'Asia/Ho_Chi_Minh'");
    expect(migration).toContain('gamification_local_date');
  });

  it('hides configurations without authoritative product rules', () => {
    expect(migration).toContain("WHERE item_type <> 'streak_freeze'");
    expect(migration).toContain("'first_lesson'");
    expect(migration).toContain("'pronunciation_master'");
    expect(migration).toContain("requirement_type = 'ai_sessions'");
  });

  it('rebuilds existing visible state only from authoritative ledgers', () => {
    expect(backfillMigration).toContain('evaluate_user_achievements');
    expect(backfillMigration).toContain('FROM public.xp_transactions');
    expect(backfillMigration).toContain('ON CONFLICT (user_id, week_start)');
    expect(backfillMigration).not.toContain('INSERT INTO public.xp_transactions');
  });
});
