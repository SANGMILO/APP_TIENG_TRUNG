import {
  hasPermission,
  canAccessAdmin,
  updateUserRole,
  validateVocabImport,
  VocabImportRow,
} from '../services/admin-service';
import { supabase } from '../lib/supabase';

jest.mock('../lib/supabase', () => ({
  supabase: { from: jest.fn(), rpc: jest.fn(), auth: { getUser: jest.fn() } },
}));

describe('Admin Service', () => {
  beforeEach(() => {
    jest.clearAllMocks();
  });

  describe('RBAC - hasPermission', () => {
    it('student has no admin permissions', () => {
      expect(hasPermission('student', 'view_admin')).toBe(false);
      expect(hasPermission('student', 'create_content')).toBe(false);
      expect(hasPermission('student', 'manage_users')).toBe(false);
    });

    it('teacher can only view admin', () => {
      expect(hasPermission('teacher', 'view_admin')).toBe(true);
      expect(hasPermission('teacher', 'create_content')).toBe(false);
      expect(hasPermission('teacher', 'publish_content')).toBe(false);
    });

    it('editor can create and edit content', () => {
      expect(hasPermission('editor', 'view_admin')).toBe(true);
      expect(hasPermission('editor', 'create_content')).toBe(true);
      expect(hasPermission('editor', 'edit_content')).toBe(true);
      expect(hasPermission('editor', 'publish_content')).toBe(false);
      expect(hasPermission('editor', 'manage_users')).toBe(false);
    });

    it('admin can publish and manage users', () => {
      expect(hasPermission('admin', 'publish_content')).toBe(true);
      expect(hasPermission('admin', 'manage_users')).toBe(true);
      expect(hasPermission('admin', 'manage_roles')).toBe(false);
    });

    it('super_admin has all permissions', () => {
      expect(hasPermission('super_admin', 'view_admin')).toBe(true);
      expect(hasPermission('super_admin', 'publish_content')).toBe(true);
      expect(hasPermission('super_admin', 'manage_users')).toBe(true);
      expect(hasPermission('super_admin', 'manage_roles')).toBe(true);
      expect(hasPermission('super_admin', 'manage_settings')).toBe(true);
    });

    it('admin cannot manage roles (escalation prevention)', () => {
      expect(hasPermission('admin', 'manage_roles')).toBe(false);
    });
  });

  describe('canAccessAdmin', () => {
    it('student cannot access admin', () => {
      expect(canAccessAdmin('student')).toBe(false);
    });

    it('teacher can access admin', () => {
      expect(canAccessAdmin('teacher')).toBe(true);
    });

    it('editor can access admin', () => {
      expect(canAccessAdmin('editor')).toBe(true);
    });

    it('admin can access admin', () => {
      expect(canAccessAdmin('admin')).toBe(true);
    });
  });

  describe('role updates', () => {
    it('uses the database-authorized role RPC instead of a direct profile update', async () => {
      const updated = { id: 'user-1', role: 'editor' };
      (supabase.rpc as jest.Mock).mockResolvedValue({ data: updated, error: null });

      await expect(updateUserRole('user-1', 'editor')).resolves.toEqual(updated);
      expect(supabase.rpc).toHaveBeenCalledWith('admin_update_user_role', {
        p_user_id: 'user-1',
        p_new_role: 'editor',
      });
      expect(supabase.from).not.toHaveBeenCalled();
    });
  });

  describe('Vocabulary Import Validation', () => {
    const existingChinese = new Set(['你好', '谢谢']);

    it('validates valid rows', () => {
      const rows: VocabImportRow[] = [
        { chinese: '学生', pinyin: 'xuéshēng', meaning_vi: 'học sinh' },
        { chinese: '老师', pinyin: 'lǎoshī', meaning_vi: 'giáo viên' },
      ];
      const result = validateVocabImport(rows, existingChinese);
      expect(result.valid).toHaveLength(2);
      expect(result.duplicates).toHaveLength(0);
      expect(result.errors).toHaveLength(0);
    });

    it('detects duplicates', () => {
      const rows: VocabImportRow[] = [
        { chinese: '你好', pinyin: 'nǐ hǎo', meaning_vi: 'xin chào' },
        { chinese: '新词', pinyin: 'xīn cí', meaning_vi: 'từ mới' },
      ];
      const result = validateVocabImport(rows, existingChinese);
      expect(result.valid).toHaveLength(1);
      expect(result.duplicates).toHaveLength(1);
      expect(result.duplicates[0].chinese).toBe('你好');
    });

    it('reports missing Chinese text', () => {
      const rows: VocabImportRow[] = [
        { chinese: '', pinyin: 'test', meaning_vi: 'test' },
      ];
      const result = validateVocabImport(rows, existingChinese);
      expect(result.errors).toHaveLength(1);
      expect(result.errors[0].error).toContain('Chinese');
    });

    it('reports missing Pinyin', () => {
      const rows: VocabImportRow[] = [
        { chinese: '测试', pinyin: '', meaning_vi: 'test' },
      ];
      const result = validateVocabImport(rows, existingChinese);
      expect(result.errors).toHaveLength(1);
      expect(result.errors[0].error).toContain('Pinyin');
    });

    it('reports missing Vietnamese meaning', () => {
      const rows: VocabImportRow[] = [
        { chinese: '测试', pinyin: 'cèshì', meaning_vi: '' },
      ];
      const result = validateVocabImport(rows, existingChinese);
      expect(result.errors).toHaveLength(1);
      expect(result.errors[0].error).toContain('Vietnamese');
    });

    it('handles mixed valid/invalid/duplicate', () => {
      const rows: VocabImportRow[] = [
        { chinese: '学生', pinyin: 'xuéshēng', meaning_vi: 'học sinh' },
        { chinese: '', pinyin: 'test', meaning_vi: 'missing chinese' },
        { chinese: '你好', pinyin: 'nǐ hǎo', meaning_vi: 'xin chào' },
        { chinese: '老师', pinyin: 'lǎoshī', meaning_vi: 'giáo viên' },
      ];
      const result = validateVocabImport(rows, existingChinese);
      expect(result.valid).toHaveLength(2);
      expect(result.errors).toHaveLength(1);
      expect(result.duplicates).toHaveLength(1);
    });
  });
});
