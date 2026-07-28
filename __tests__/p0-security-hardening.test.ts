import { authorizeAiConversation } from '../supabase/functions/_shared/ai-conversation-authorization';

declare const require: (moduleName: string) => any;
declare const __dirname: string;

const fs = require('fs');
const path = require('path');

const migrationPath = path.join(
  __dirname,
  '..',
  'supabase',
  'migrations',
  '20260728000000_p0_security_hardening.sql',
);
const migration = fs.readFileSync(migrationPath, 'utf8');
const edgeFunction = fs.readFileSync(path.join(
  __dirname,
  '..',
  'supabase',
  'functions',
  'ai-tutor-chat',
  'index.ts',
), 'utf8');

describe('P0-A database security migration contract', () => {
  it('removes broad profile updates and grants only explicit editable columns', () => {
    expect(migration).toContain(
      'REVOKE UPDATE ON TABLE public.profiles FROM PUBLIC, anon, authenticated;',
    );

    const editableGrant = migration.match(
      /GRANT UPDATE \(([\s\S]*?)\) ON TABLE public\.profiles TO authenticated;/,
    );
    expect(editableGrant).not.toBeNull();

    const grantedColumns = editableGrant![1]
      .split(',')
      .map((column: string) => column.trim());

    expect(grantedColumns).toEqual(expect.arrayContaining([
      'display_name',
      'avatar_url',
      'timezone',
      'daily_goal_minutes',
      'onboarding_completed',
    ]));
    expect(grantedColumns).not.toEqual(expect.arrayContaining([
      'role',
      'total_xp',
      'total_coins',
      'current_level',
      'current_streak',
      'longest_streak',
      'hearts',
      'updated_at',
    ]));
  });

  it('prevents direct client ledger writes and arbitrary reward_xp execution', () => {
    expect(migration).toMatch(
      /REVOKE INSERT, UPDATE, DELETE ON TABLE public\.xp_transactions\s+FROM PUBLIC, anon, authenticated;/,
    );
    expect(migration).toMatch(
      /REVOKE ALL ON FUNCTION public\.reward_xp\(UUID, INTEGER, TEXT, TEXT, UUID, TEXT\)\s+FROM PUBLIC, anon, authenticated;/,
    );
    expect(migration).not.toMatch(
      /GRANT EXECUTE ON FUNCTION public\.reward_xp\(UUID, INTEGER, TEXT, TEXT, UUID, TEXT\)\s+TO authenticated;/,
    );
  });

  it('keeps complete_lesson callable while deriving its XP from lesson data', () => {
    expect(migration).toContain('GREATEST(l.xp_reward, 0)');
    expect(migration).toContain('v_xp_awarded');
    expect(migration).toMatch(
      /GRANT EXECUTE ON FUNCTION public\.complete_lesson\(UUID, REAL, INTEGER, INTEGER, INTEGER\)\s+TO authenticated;/,
    );
    expect(migration).not.toContain(
      "PERFORM public.reward_xp(v_user_id, p_xp_earned",
    );
  });
});

describe('AI Tutor conversation authorization', () => {
  const ownConversation = {
    id: 'conversation-a',
    user_id: 'user-a',
    mode: 'restaurant',
    status: 'active',
  };

  it('rejects another user with the same generic result as a missing conversation', () => {
    const foreign = authorizeAiConversation('user-b', 'restaurant', ownConversation);
    const missing = authorizeAiConversation('user-b', 'restaurant', null);

    expect(foreign).toEqual(missing);
    expect(foreign).toEqual(expect.objectContaining({
      authorized: false,
      status: 403,
      errorCode: 'CONVERSATION_FORBIDDEN',
    }));
  });

  it('rejects deleted conversations without disclosing ownership', () => {
    const result = authorizeAiConversation('user-a', 'restaurant', {
      ...ownConversation,
      status: 'deleted',
    });

    expect(result).toEqual(expect.objectContaining({
      authorized: false,
      status: 403,
      errorCode: 'CONVERSATION_FORBIDDEN',
    }));
  });

  it('rejects a requested mode that does not match the stored conversation', () => {
    const result = authorizeAiConversation('user-a', 'travel', ownConversation);

    expect(result).toEqual(expect.objectContaining({
      authorized: false,
      status: 400,
      errorCode: 'MODE_MISMATCH',
    }));
  });

  it('allows the owner to continue with the stored mode', () => {
    expect(authorizeAiConversation('user-a', 'restaurant', ownConversation)).toEqual({
      authorized: true,
      mode: 'restaurant',
    });
  });

  it('is enforced before reservation, history, and completion operations', () => {
    const authorizationIndex = edgeFunction.indexOf(
      'const authorization = authorizeAiConversation',
    );
    const protectedOperationMarkers = [
      "supabase.rpc('begin_ai_tutor_message'",
      'const context = await buildContext',
      "'complete_ai_tutor_message'",
    ];

    expect(authorizationIndex).toBeGreaterThan(-1);
    protectedOperationMarkers.forEach((marker) => {
      const operationIndex = edgeFunction.indexOf(marker);
      expect(operationIndex).toBeGreaterThan(-1);
      expect(authorizationIndex).toBeLessThan(operationIndex);
    });
    expect(edgeFunction).toContain(".eq('user_id', user.id)");
  });
});
