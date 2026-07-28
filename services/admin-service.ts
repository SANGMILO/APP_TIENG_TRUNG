/**
 * Admin Service - RBAC, content management, dashboard
 * All admin operations verify permissions server-side via RLS
 */

import { supabase } from '@/lib/supabase';
import { Profile } from '@/types';

// ============================================
// RBAC
// ============================================

export type AdminPermission =
  | 'view_admin'
  | 'create_content'
  | 'edit_content'
  | 'publish_content'
  | 'manage_users'
  | 'manage_roles'
  | 'manage_gamification'
  | 'manage_ai_config'
  | 'view_analytics'
  | 'manage_settings';

const ROLE_PERMISSIONS: Record<string, AdminPermission[]> = {
  student: [],
  teacher: ['view_admin'],
  editor: ['view_admin', 'create_content', 'edit_content', 'view_analytics'],
  admin: ['view_admin', 'create_content', 'edit_content', 'publish_content', 'manage_users', 'manage_gamification', 'manage_ai_config', 'view_analytics', 'manage_settings'],
  super_admin: ['view_admin', 'create_content', 'edit_content', 'publish_content', 'manage_users', 'manage_roles', 'manage_gamification', 'manage_ai_config', 'view_analytics', 'manage_settings'],
};

export function hasPermission(role: string, permission: AdminPermission): boolean {
  return (ROLE_PERMISSIONS[role] ?? []).includes(permission);
}

export function canAccessAdmin(role: string): boolean {
  return hasPermission(role, 'view_admin');
}

// ============================================
// DASHBOARD
// ============================================

export interface AdminDashboardStats {
  totalUsers: number;
  activeToday: number;
  publishedCourses: number;
  publishedLessons: number;
  publishedVocabulary: number;
  publishedVideos: number;
  contentInReview: number;
  todayXpTotal: number;
  todayLessonsCompleted: number;
  todayAiSessions: number;
}

export async function fetchAdminDashboard(): Promise<AdminDashboardStats> {
  const { data, error } = await supabase.rpc('get_admin_dashboard');
  if (error) throw error;
  return data as AdminDashboardStats;
}

// ============================================
// CONTENT CRUD (generic)
// ============================================

export async function fetchAdminList(table: string, filters?: { status?: string; search?: string }, page = 0, limit = 20) {
  let query = supabase.from(table).select('*', { count: 'exact' }).order('created_at', { ascending: false }).range(page * limit, (page + 1) * limit - 1);

  if (filters?.status) query = query.eq('status', filters.status);
  if (filters?.search) query = query.or(`title.ilike.%${filters.search}%,description.ilike.%${filters.search}%`);

  const { data, error, count } = await query;
  if (error) throw error;
  return { data: data ?? [], total: count ?? 0 };
}

export async function fetchAdminItem(table: string, id: string) {
  const { data, error } = await supabase.from(table).select('*').eq('id', id).single();
  if (error) throw error;
  return data;
}

export async function createAdminItem(table: string, item: Record<string, any>) {
  const { data, error } = await supabase.from(table).insert(item).select().single();
  if (error) throw error;
  await logAdminAction('CREATE', table, data.id, null, data);
  return data;
}

export async function updateAdminItem(table: string, id: string, updates: Record<string, any>) {
  const before = await fetchAdminItem(table, id);
  const { data, error } = await supabase.from(table).update({ ...updates, updated_at: new Date().toISOString() }).eq('id', id).select().single();
  if (error) throw error;
  await logAdminAction('UPDATE', table, id, before, data);
  return data;
}

export async function archiveAdminItem(table: string, id: string) {
  return updateAdminItem(table, id, { status: 'archived' });
}

// ============================================
// PUBLISH
// ============================================

export async function publishContent(entityType: string, entityId: string, changeSummary?: string): Promise<boolean> {
  const { data, error } = await supabase.rpc('publish_content', {
    p_entity_type: entityType,
    p_entity_id: entityId,
    p_change_summary: changeSummary || null,
  });
  if (error) throw error;
  return true;
}

// ============================================
// CONTENT VERSIONS
// ============================================

export async function fetchVersions(entityType: string, entityId: string) {
  const { data, error } = await supabase
    .from('content_versions')
    .select('*, profiles:created_by (display_name)')
    .eq('entity_type', entityType)
    .eq('entity_id', entityId)
    .order('version_number', { ascending: false });

  if (error) throw error;
  return data ?? [];
}

// ============================================
// USERS
// ============================================

export async function fetchUsers(page = 0, limit = 20, search?: string) {
  let query = supabase.from('profiles').select('*', { count: 'exact' }).order('created_at', { ascending: false }).range(page * limit, (page + 1) * limit - 1);

  if (search) query = query.or(`email.ilike.%${search}%,display_name.ilike.%${search}%,username.ilike.%${search}%`);

  const { data, error, count } = await query;
  if (error) throw error;
  return { data: data ?? [], total: count ?? 0 };
}

export async function updateUserRole(userId: string, newRole: string) {
  const { data, error } = await supabase.rpc('admin_update_user_role', {
    p_user_id: userId,
    p_new_role: newRole,
  });
  if (error) throw error;
  return data as Profile;
}

// ============================================
// AUDIT LOG
// ============================================

async function logAdminAction(action: string, resourceType: string, resourceId: string | null, beforeData: any, afterData: any) {
  const user = (await supabase.auth.getUser()).data.user;
  if (!user) return;

  await supabase.from('admin_activity_logs').insert({
    user_id: user.id,
    action,
    resource_type: resourceType,
    resource_id: resourceId,
    entity_type: resourceType,
    before_data: beforeData,
    after_data: afterData,
  });
}

export async function fetchAuditLogs(page = 0, limit = 30) {
  const { data, error } = await supabase
    .from('admin_activity_logs')
    .select('*, profiles:user_id (display_name, email)')
    .order('created_at', { ascending: false })
    .range(page * limit, (page + 1) * limit - 1);

  if (error) throw error;
  return data ?? [];
}

// ============================================
// VOCABULARY DUPLICATE CHECK
// ============================================

export async function checkVocabularyDuplicate(chinese: string): Promise<boolean> {
  const { count } = await supabase.from('vocabulary').select('*', { count: 'exact', head: true }).eq('chinese', chinese);
  return (count ?? 0) > 0;
}

// ============================================
// BULK IMPORT
// ============================================

export interface VocabImportRow {
  chinese: string;
  pinyin: string;
  meaning_vi: string;
  meaning_en?: string;
  hsk_level?: number;
  category?: string;
  example_sentence?: string;
  example_pinyin?: string;
  example_meaning?: string;
}

export interface ImportValidationResult {
  valid: VocabImportRow[];
  duplicates: VocabImportRow[];
  errors: { row: number; error: string }[];
}

export function validateVocabImport(rows: VocabImportRow[], existingChinese: Set<string>): ImportValidationResult {
  const valid: VocabImportRow[] = [];
  const duplicates: VocabImportRow[] = [];
  const errors: { row: number; error: string }[] = [];

  rows.forEach((row, i) => {
    if (!row.chinese?.trim()) { errors.push({ row: i + 1, error: 'Missing Chinese text' }); return; }
    if (!row.pinyin?.trim()) { errors.push({ row: i + 1, error: 'Missing Pinyin' }); return; }
    if (!row.meaning_vi?.trim()) { errors.push({ row: i + 1, error: 'Missing Vietnamese meaning' }); return; }

    if (existingChinese.has(row.chinese.trim())) {
      duplicates.push(row);
    } else {
      valid.push(row);
    }
  });

  return { valid, duplicates, errors };
}

export async function bulkImportVocabulary(rows: VocabImportRow[]): Promise<number> {
  const items = rows.map(r => ({
    chinese: r.chinese.trim(),
    pinyin: r.pinyin.trim(),
    meaning_vi: r.meaning_vi.trim(),
    meaning_en: r.meaning_en || null,
    hsk_level: r.hsk_level || null,
    category: r.category || null,
    example_sentence: r.example_sentence || null,
    example_pinyin: r.example_pinyin || null,
    example_meaning: r.example_meaning || null,
    status: 'draft',
  }));

  const { data, error } = await supabase.from('vocabulary').insert(items).select('id');
  if (error) throw error;
  return data?.length ?? 0;
}
