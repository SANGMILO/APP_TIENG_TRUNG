declare const require: (moduleName: string) => any;
declare const __dirname: string;

const fs = require('fs');
const path = require('path');

const migration = fs.readFileSync(
  path.join(
    __dirname,
    '..',
    'supabase',
    'migrations',
    '20260729030000_authoritative_review_srs.sql',
  ),
  'utf8',
);

describe('authoritative review SRS migration contract', () => {
  it('persists interval and state with bounded constraints', () => {
    expect(migration).toContain('ADD COLUMN IF NOT EXISTS interval_days');
    expect(migration).toContain('ADD COLUMN IF NOT EXISTS state');
    expect(migration).toContain(
      "CHECK (state IN ('new', 'learning', 'review', 'mastered'))",
    );
    expect(migration).toContain(
      'CHECK (interval_days >= 0 AND interval_days <= 36500)',
    );
  });

  it('uses caller ownership, due validation, and idempotent submissions', () => {
    expect(migration).toContain('v_user_id UUID := auth.uid()');
    expect(migration).toContain('v_progress.next_review_at > NOW()');
    expect(migration).toContain('vocabulary_review_submissions');
    expect(migration).toContain("'already_processed', TRUE");
    expect(migration).toContain('pg_advisory_xact_lock');
  });

  it('keeps the existing SRS ratings and ten-minute again step', () => {
    for (const rating of ['again', 'hard', 'good', 'easy']) {
      expect(migration).toContain(`WHEN '${rating}'`);
    }
    expect(migration).toContain("INTERVAL '10 minutes'");
    expect(migration).toContain("WHEN v_interval_days = 0 THEN 4");
  });

  it('resolves mistakes only after a server-side answer check', () => {
    expect(migration).toContain('CREATE OR REPLACE FUNCTION public.submit_mistake_review');
    expect(migration).toContain('public.normalize_review_answer(v_mistake.correct_answer)');
    expect(migration).toMatch(
      /IF v_is_correct THEN\s+UPDATE public\.mistakes\s+SET reviewed = TRUE/,
    );
  });

  it('revokes direct progress mutation and grants only safe RPCs', () => {
    expect(migration).toMatch(
      /REVOKE INSERT, UPDATE, DELETE ON TABLE public\.user_vocabulary_progress\s+FROM PUBLIC, anon, authenticated;/,
    );
    expect(migration).toMatch(
      /GRANT EXECUTE ON FUNCTION public\.submit_vocabulary_review\(UUID, UUID, TEXT\)\s+TO authenticated;/,
    );
    expect(migration).toMatch(
      /GRANT EXECUTE ON FUNCTION public\.submit_mistake_review\(UUID, UUID, TEXT\)\s+TO authenticated;/,
    );
  });
});
