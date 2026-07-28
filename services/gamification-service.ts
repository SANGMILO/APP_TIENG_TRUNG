/**
 * Gamification Service
 * Central event handler for quests, achievements, streaks, hearts
 * All rewards go through server-side functions for security
 */

import { supabase } from '@/lib/supabase';

// ============================================
// GAMIFICATION SUMMARY
// ============================================

export interface GamificationSummary {
  level: number;
  totalXp: number;
  coins: number;
  hearts: number;
  dailyGoalXp: number;
  todayXp: number;
  streak: number;
  longestStreak: number;
  boostActive: boolean;
}

export async function getGamificationSummary(): Promise<GamificationSummary> {
  const { data, error } = await supabase.rpc('get_gamification_summary');
  if (error) throw error;
  return data as GamificationSummary;
}

// ============================================
// DAILY QUESTS
// ============================================

export interface DailyQuestItem {
  id: string;
  quest_id: string;
  title: string;
  description: string;
  quest_type: string;
  requirement_value: number;
  progress: number;
  completed: boolean;
  xp_reward: number;
  coin_reward: number;
}

export async function fetchDailyQuests(): Promise<DailyQuestItem[]> {
  const user = (await supabase.auth.getUser()).data.user;
  if (!user) return [];

  const today = new Date().toISOString().split('T')[0];

  const { data, error } = await supabase
    .from('user_daily_quests')
    .select(`
      id, quest_id, progress, completed, assigned_date,
      daily_quests:quest_id (title, description, quest_type, requirement_value, xp_reward, coin_reward)
    `)
    .eq('user_id', user.id)
    .eq('assigned_date', today);

  if (error) throw error;

  return (data ?? []).map((item: any) => ({
    id: item.id,
    quest_id: item.quest_id,
    title: item.daily_quests?.title || '',
    description: item.daily_quests?.description || '',
    quest_type: item.daily_quests?.quest_type || '',
    requirement_value: item.daily_quests?.requirement_value || 0,
    progress: item.progress,
    completed: item.completed,
    xp_reward: item.daily_quests?.xp_reward || 0,
    coin_reward: item.daily_quests?.coin_reward || 0,
  }));
}

// ============================================
// ACHIEVEMENTS
// ============================================

export interface AchievementItem {
  id: string;
  key: string;
  title: string;
  description: string;
  icon: string;
  category: string;
  rarity: string;
  is_hidden: boolean;
  requirement_type: string;
  requirement_value: number;
  xp_reward: number;
  coin_reward: number;
  unlocked: boolean;
  unlocked_at: string | null;
}

export async function fetchAchievements(): Promise<AchievementItem[]> {
  const { data: userData, error: userError } = await supabase.auth.getUser();
  if (userError) throw userError;
  const user = userData.user;
  if (!user) return [];

  const { data: achievements, error: achievementsError } = await supabase
    .from('achievements')
    .select('*')
    .order('requirement_value');
  if (achievementsError) throw achievementsError;

  const { data: unlocked, error: unlockedError } = await supabase
    .from('user_achievements')
    .select('achievement_id, unlocked_at')
    .eq('user_id', user.id);
  if (unlockedError) throw unlockedError;

  const unlockedMap = new Map((unlocked ?? []).map((u: any) => [u.achievement_id, u.unlocked_at]));

  return (achievements ?? []).map((a: any) => ({
    ...a,
    unlocked: unlockedMap.has(a.id),
    unlocked_at: unlockedMap.get(a.id) || null,
  }));
}

export interface LevelThreshold {
  level: number;
  xp_required: number;
  title: string | null;
}

export interface LevelProgress {
  level: number;
  title: string | null;
  currentThresholdXp: number;
  nextLevel: number | null;
  nextThresholdXp: number | null;
  xpIntoLevel: number;
  xpForLevel: number;
  xpRemaining: number;
  progressPercent: number;
  isMaxLevel: boolean;
}

export async function fetchLevelThresholds(): Promise<LevelThreshold[]> {
  const { data, error } = await supabase
    .from('level_thresholds')
    .select('level, xp_required, title')
    .order('level');
  if (error) throw error;
  return (data ?? []) as LevelThreshold[];
}

export function calculateLevelProgress(
  totalXp: number,
  thresholds: LevelThreshold[],
): LevelProgress | null {
  if (thresholds.length === 0) return null;

  const xp = Math.max(0, Math.round(totalXp));
  const ordered = [...thresholds].sort(
    (left, right) => left.xp_required - right.xp_required,
  );
  const current = ordered.reduce(
    (match, threshold) => (
      threshold.xp_required <= xp ? threshold : match
    ),
    ordered[0],
  );
  const next = ordered.find(
    (threshold) => threshold.xp_required > current.xp_required,
  ) ?? null;

  if (!next) {
    return {
      level: current.level,
      title: current.title,
      currentThresholdXp: current.xp_required,
      nextLevel: null,
      nextThresholdXp: null,
      xpIntoLevel: Math.max(0, xp - current.xp_required),
      xpForLevel: 0,
      xpRemaining: 0,
      progressPercent: 100,
      isMaxLevel: true,
    };
  }

  const xpForLevel = Math.max(1, next.xp_required - current.xp_required);
  const xpIntoLevel = Math.max(
    0,
    Math.min(xpForLevel, xp - current.xp_required),
  );

  return {
    level: current.level,
    title: current.title,
    currentThresholdXp: current.xp_required,
    nextLevel: next.level,
    nextThresholdXp: next.xp_required,
    xpIntoLevel,
    xpForLevel,
    xpRemaining: Math.max(0, next.xp_required - xp),
    progressPercent: Math.max(
      0,
      Math.min(100, (xpIntoLevel / xpForLevel) * 100),
    ),
    isMaxLevel: false,
  };
}

// ============================================
// LEADERBOARD
// ============================================

export interface LeaderboardEntry {
  user_id: string;
  display_name: string | null;
  avatar_url: string | null;
  xp_earned: number;
  rank: number;
  league: string;
}

export async function fetchLeaderboard(): Promise<LeaderboardEntry[]> {
  const thisWeekStart = getWeekStart();

  const { data, error } = await supabase
    .from('leaderboards')
    .select('user_id, xp_earned, rank, league, profiles:user_id (display_name, avatar_url)')
    .eq('week_start', thisWeekStart)
    .order('xp_earned', { ascending: false })
    .limit(30);

  if (error) throw error;

  return (data ?? []).map((item: any, i: number) => ({
    user_id: item.user_id,
    display_name: item.profiles?.display_name,
    avatar_url: item.profiles?.avatar_url,
    xp_earned: item.xp_earned,
    rank: item.rank || i + 1,
    league: item.league,
  }));
}

// ============================================
// SHOP
// ============================================

export interface ShopItem {
  id: string;
  code: string;
  name: string;
  description: string | null;
  price_coins: number;
  item_type: string;
  value: Record<string, any>;
}

export async function fetchShopItems(): Promise<ShopItem[]> {
  const { data, error } = await supabase.from('shop_items').select('*').eq('is_active', true);
  if (error) throw error;
  return (data ?? []) as ShopItem[];
}

export async function purchaseItem(itemId: string): Promise<{ success: boolean; error?: string }> {
  const idempotencyKey = `${(await supabase.auth.getUser()).data.user?.id}:shop:${itemId}:${Date.now()}`;

  const { data, error } = await supabase.rpc('purchase_shop_item', {
    p_item_id: itemId,
    p_idempotency_key: idempotencyKey,
  });

  if (error) return { success: false, error: error.message };
  if (!data?.success) return { success: false, error: data?.error || 'Purchase failed' };
  return { success: true };
}

// ============================================
// INVENTORY
// ============================================

export interface InventoryItem {
  item_id: string;
  code: string;
  name: string;
  quantity: number;
  item_type: string;
}

export async function fetchInventory(): Promise<InventoryItem[]> {
  const { data, error } = await supabase
    .from('user_inventory')
    .select('item_id, quantity, shop_items:item_id (code, name, item_type)')
    .gt('quantity', 0);

  if (error) throw error;
  return (data ?? []).map((item: any) => ({
    item_id: item.item_id,
    code: item.shop_items?.code || '',
    name: item.shop_items?.name || '',
    quantity: item.quantity,
    item_type: item.shop_items?.item_type || '',
  }));
}

// ============================================
// HELPERS
// ============================================

function getWeekStart(): string {
  const now = new Date();
  const day = now.getDay(); // 0=Sun
  const diff = now.getDate() - day + (day === 0 ? -6 : 1); // Monday
  const monday = new Date(now.setDate(diff));
  return monday.toISOString().split('T')[0];
}
