declare const require: (moduleName: string) => any;
declare const __dirname: string;

const fs = require('fs');
const path = require('path');

const migration = fs.readFileSync(path.join(
  __dirname,
  '..',
  'supabase',
  'migrations',
  '20260729020000_authoritative_video_progress.sql',
), 'utf8');
const playbackFunction = fs.readFileSync(path.join(
  __dirname,
  '..',
  'supabase',
  'functions',
  'video-playback-url',
  'index.ts',
), 'utf8');

describe('authoritative video progress migration contract', () => {
  it('uses caller-only SECURITY DEFINER entry points', () => {
    expect(migration).toContain('v_user_id UUID := auth.uid()');
    expect(migration).not.toMatch(/p_user_id UUID/);
    expect(migration.match(/SECURITY DEFINER\s+SET search_path = ''/g)).toHaveLength(3);
  });

  it('deduplicates progress events before accumulating watch time', () => {
    expect(migration).toContain('CREATE TABLE IF NOT EXISTS public.video_progress_events');
    expect(migration).toContain('WHERE event.id = p_event_id');
    expect(migration).toContain('pg_catalog.pg_advisory_xact_lock');
    expect(migration).toContain(
      'public.user_video_progress.watch_time_ms + v_played_delta_ms',
    );
  });

  it('never regresses furthest position or progress percentage', () => {
    expect(migration).toContain(
      'GREATEST(\n      public.user_video_progress.furthest_position_ms,\n      v_position_ms',
    );
    expect(migration).toMatch(
      /progress_percent = LEAST\(\s*100,\s*\(\s*GREATEST\(/,
    );
  });

  it('scores question answers and counts correctness on the server', () => {
    expect(migration).toContain('public.normalize_video_answer(option.text)');
    expect(migration).toContain('option.is_correct');
    expect(migration).toContain('COUNT(DISTINCT attempt.question_id)');
    expect(migration).toContain('FILTER (WHERE attempt.is_correct)');
  });

  it('prevents duplicate question submissions', () => {
    expect(migration).toContain('client_attempt_id UUID');
    expect(migration).toContain('idx_video_question_client_attempt');
    expect(migration).toContain('WHERE attempt.user_id = v_user_id');
    expect(migration).toContain('AND attempt.question_id = p_question_id');
  });

  it('requires real persisted progress and required questions before completion', () => {
    expect(migration).toContain('v_progress.furthest_position_ms < (v_duration_ms * 0.9)');
    expect(migration).toContain('v_progress.watch_time_ms < GREATEST');
    expect(migration).toContain("MESSAGE = 'Required video questions are incomplete'");
  });

  it('blocks premium content without an authoritative entitlement source', () => {
    expect(migration.match(/IF v_video\.is_premium THEN/g)).toHaveLength(3);
    expect(migration).toContain(
      "MESSAGE = 'Premium video entitlement is unavailable'",
    );
  });

  it('revokes the legacy completion and direct progress writes', () => {
    expect(migration).toMatch(
      /REVOKE ALL ON FUNCTION public\.complete_video\(UUID, INTEGER, INTEGER, INTEGER\)\s+FROM PUBLIC, anon, authenticated;/,
    );
    expect(migration).toMatch(
      /REVOKE INSERT, UPDATE, DELETE ON TABLE public\.user_video_progress\s+FROM PUBLIC, anon, authenticated;/,
    );
    expect(migration).toMatch(
      /REVOKE INSERT, UPDATE, DELETE ON TABLE public\.user_video_question_attempts\s+FROM PUBLIC, anon, authenticated;/,
    );
  });
});

describe('private playback URL function contract', () => {
  it('authenticates the bearer token before reading video metadata', () => {
    const authIndex = playbackFunction.indexOf('supabase.auth.getUser(token)');
    const queryIndex = playbackFunction.indexOf(".from('videos')");
    expect(authIndex).toBeGreaterThan(-1);
    expect(queryIndex).toBeGreaterThan(authIndex);
  });

  it('uses a server-side signed URL and does not expose the service key', () => {
    expect(playbackFunction).toContain("Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')");
    expect(playbackFunction).toContain(".from('video-content')");
    expect(playbackFunction).toContain('.createSignedUrl(');
    expect(playbackFunction).not.toMatch(/console\.(log|error)/);
  });
});
