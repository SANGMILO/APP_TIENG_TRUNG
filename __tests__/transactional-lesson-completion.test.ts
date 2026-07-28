declare const require: (moduleName: string) => any;
declare const __dirname: string;

const fs = require('fs');
const path = require('path');

const migration = fs.readFileSync(path.join(
  __dirname,
  '..',
  'supabase',
  'migrations',
  '20260729010000_transactional_lesson_completion.sql',
), 'utf8');

describe('transactional lesson completion migration contract', () => {
  it('uses a caller-only SECURITY DEFINER RPC with an empty search path', () => {
    expect(migration).toMatch(
      /CREATE OR REPLACE FUNCTION public\.complete_lesson_transactional\(\s*p_completion_id UUID,\s*p_lesson_id UUID,\s*p_attempts JSONB\s*\)/,
    );
    expect(migration).toMatch(
      /SECURITY DEFINER\s+SET search_path = ''/,
    );
    expect(migration).toContain('v_user_id UUID := auth.uid()');
    expect(migration).not.toMatch(/p_user_id UUID/);
  });

  it('allows authenticated callers only and revokes the legacy bypass', () => {
    expect(migration).toMatch(
      /GRANT EXECUTE ON FUNCTION public\.complete_lesson_transactional\(UUID, UUID, JSONB\)\s+TO authenticated;/,
    );
    expect(migration).toMatch(
      /REVOKE ALL ON FUNCTION public\.complete_lesson\(UUID, REAL, INTEGER, INTEGER, INTEGER\)\s+FROM PUBLIC, anon, authenticated;/,
    );
  });

  it('validates the published hierarchy and locked lesson state', () => {
    expect(migration).toContain("lesson.status = 'published'");
    expect(migration).toContain("chapter.status = 'published'");
    expect(migration).toContain("unit.status = 'published'");
    expect(migration).toContain("course.status = 'published'");
    expect(migration).toContain("MESSAGE = 'Lesson is locked'");
  });

  it('computes correctness and XP without client score or XP parameters', () => {
    expect(migration).not.toMatch(/p_score REAL/);
    expect(migration).not.toMatch(/p_xp_earned INTEGER/);
    expect(migration).toContain('v_score := (v_correct_count::REAL / v_exercise_count::REAL) * 100');
    expect(migration).toContain('v_requested_xp := v_base_xp + v_perfect_bonus');
    expect(migration).toContain("WHEN v_correct_count = v_exercise_count THEN 5");
  });

  it('serializes retries and records an idempotent submission result', () => {
    expect(migration).toContain('pg_catalog.pg_advisory_xact_lock');
    expect(migration).toContain('lesson_completion_submissions');
    expect(migration).toContain("'already_processed', TRUE");
    expect(migration).toContain(
      "v_user_id::TEXT || ':lesson_complete:' || p_lesson_id::TEXT",
    );
  });

  it('persists one server-validated attempt per lesson exercise', () => {
    expect(migration).toContain(
      "MESSAGE = 'Exactly one attempt is required for every lesson exercise'",
    );
    expect(migration).toContain('INSERT INTO public.user_exercise_attempts');
    expect(migration).toContain('idx_exercise_attempt_completion');
    expect(migration).toContain('v_is_correct');
  });

  it('aggregates mistakes with valid lesson and exercise references', () => {
    expect(migration).toContain(
      'ADD COLUMN IF NOT EXISTS lesson_id UUID REFERENCES public.lessons(id)',
    );
    expect(migration).toContain('INSERT INTO public.mistakes');
    expect(migration).toContain('ON CONFLICT (user_id, mistake_key)');
    expect(migration).toContain('times_wrong = public.mistakes.times_wrong + 1');
  });

  it('seeds review vocabulary without overwriting existing progress', () => {
    expect(migration).toContain('INSERT INTO public.user_vocabulary_progress');
    expect(migration).toContain('FROM public.lesson_vocabulary AS link');
    expect(migration).toContain(
      'ON CONFLICT (user_id, vocabulary_id) DO NOTHING',
    );
  });

  it('unlocks only the immediately following ordered lesson', () => {
    expect(migration).toContain(
      'ordered.lesson_ordinal = v_current_ordinal + 1',
    );
    expect(migration).toContain("VALUES (\n      v_user_id,\n      v_next_lesson_id,\n      'available'");
    expect(migration).not.toContain("SET status = 'available' WHERE");
  });

  it('keeps direct lesson completion writes server-authoritative', () => {
    expect(migration).toMatch(
      /REVOKE INSERT, UPDATE, DELETE ON TABLE public\.user_lesson_progress\s+FROM PUBLIC, anon, authenticated;/,
    );
    expect(migration).toMatch(
      /REVOKE INSERT, UPDATE, DELETE ON TABLE public\.user_exercise_attempts\s+FROM PUBLIC, anon, authenticated;/,
    );
    expect(migration).toMatch(
      /REVOKE INSERT, UPDATE, DELETE ON TABLE public\.mistakes\s+FROM PUBLIC, anon, authenticated;/,
    );
  });
});
