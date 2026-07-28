declare const require: (moduleName: string) => any;
declare const __dirname: string;

const fs = require('fs');
const path = require('path');
const migration = fs.readFileSync(path.join(
  __dirname,
  '..',
  'supabase',
  'migrations',
  '20260729040000_account_deletion_requests.sql',
), 'utf8');

describe('account deletion request migration contract', () => {
  it('persists an auditable queue without deleting users', () => {
    expect(migration).toContain('CREATE TABLE IF NOT EXISTS public.account_deletion_requests');
    expect(migration).toContain("status IN ('pending', 'processing', 'completed', 'cancelled', 'rejected')");
    expect(migration).not.toMatch(/DELETE\s+FROM\s+auth\.users/i);
    expect(migration).not.toMatch(/admin\.deleteUser/i);
  });

  it('derives the owner from auth.uid and requires explicit confirmation', () => {
    expect(migration).toContain('v_user_id UUID := auth.uid()');
    expect(migration).not.toContain('p_user_id');
    expect(migration).toContain("<> 'XÓA TÀI KHOẢN'");
  });

  it('is idempotent for an existing active request', () => {
    expect(migration).toContain('idx_account_deletion_one_active');
    expect(migration).toContain("'already_requested', TRUE");
    expect(migration).toContain('pg_advisory_xact_lock');
  });

  it('allows client SELECT and RPC execution but no direct mutation', () => {
    expect(migration).toMatch(
      /REVOKE ALL ON TABLE public\.account_deletion_requests\s+FROM PUBLIC, anon, authenticated;/,
    );
    expect(migration).toContain(
      'GRANT SELECT ON TABLE public.account_deletion_requests TO authenticated',
    );
    expect(migration).toMatch(
      /GRANT EXECUTE ON FUNCTION public\.request_account_deletion\(TEXT\)\s+TO authenticated;/,
    );
  });
});
