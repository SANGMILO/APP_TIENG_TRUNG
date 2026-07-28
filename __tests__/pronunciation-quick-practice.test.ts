declare const require: (moduleName: string) => any;
declare const __dirname: string;

const fs = require('fs');
const path = require('path');

jest.mock('../lib/supabase', () => ({
  supabase: {
    functions: { invoke: jest.fn() },
  },
}));
jest.mock('../utils/audio-normalize', () => ({
  normalizeAudioForPronunciation: jest.fn(),
}));

import { supabase } from '../lib/supabase';
import {
  assessPronunciation,
  buildAssessmentFunctionBody,
} from '../services/pronunciation-service';

const UUIDS = {
  exercise: '27000000-0000-4000-8000-000000000001',
  lesson: '27000000-0000-4000-8000-000000000002',
  vocabulary: '27000000-0000-4000-8000-000000000003',
};

const result = {
  overallScore: 87,
  accuracyScore: 88,
  fluencyScore: 82,
  completenessScore: 91,
  recognizedText: '你好',
  expectedText: '你好',
  words: [{ word: '你好', accuracyScore: 88, errorType: 'None' }],
  provider: 'azure',
  durationMs: 1200,
  assessedAt: '2026-07-29T00:00:00Z',
};

describe('Pronunciation quick practice', () => {
  beforeEach(() => {
    jest.clearAllMocks();
  });

  it('sends a real vocabulary foreign key and omits nonexistent lesson fields', () => {
    const body = buildAssessmentFunctionBody({
      audio: new ArrayBuffer(1),
      referenceText: '你好',
      pinyin: 'nǐ hǎo',
      locale: 'zh-CN',
      vocabularyId: UUIDS.vocabulary,
      clientAttemptId: 'attempt-1',
    }, 'audio');

    expect(body).toMatchObject({
      vocabularyId: UUIDS.vocabulary,
      referenceText: '你好',
      pinyin: 'nǐ hǎo',
    });
    expect(body).not.toHaveProperty('exerciseId');
    expect(body).not.toHaveProperty('lessonId');
  });

  it('omits empty and non-UUID foreign keys', () => {
    const body = buildAssessmentFunctionBody({
      audio: new ArrayBuffer(1),
      referenceText: '你好',
      locale: 'zh-CN',
      exerciseId: 'practice_not_a_uuid',
      lessonId: '',
      clientAttemptId: 'attempt-1',
    }, 'audio');

    expect(body).not.toHaveProperty('exerciseId');
    expect(body).not.toHaveProperty('lessonId');
    expect(body).not.toHaveProperty('vocabularyId');
  });

  it('keeps real lesson and exercise IDs for lesson speaking practice', () => {
    const body = buildAssessmentFunctionBody({
      audio: new ArrayBuffer(1),
      referenceText: '你好',
      locale: 'zh-CN',
      exerciseId: UUIDS.exercise,
      lessonId: UUIDS.lesson,
      clientAttemptId: 'attempt-1',
    }, 'audio');

    expect(body).toMatchObject({
      exerciseId: UUIDS.exercise,
      lessonId: UUIDS.lesson,
    });
  });

  it('returns the persisted provider score to the caller', async () => {
    (supabase.functions.invoke as jest.Mock).mockResolvedValue({
      data: { result },
      error: null,
    });

    const response = await assessPronunciation({
      audio: new Uint8Array([1, 2, 3]).buffer,
      referenceText: '你好',
      locale: 'zh-CN',
      vocabularyId: UUIDS.vocabulary,
      clientAttemptId: 'attempt-1',
    });

    expect(response.success).toBe(true);
    expect(response.result?.overallScore).toBe(87);
  });

  it('rejects malformed score payloads instead of showing fake success', async () => {
    (supabase.functions.invoke as jest.Mock).mockResolvedValue({
      data: { result: { ...result, overallScore: 180 } },
      error: null,
    });

    const response = await assessPronunciation({
      audio: new Uint8Array([1, 2, 3]).buffer,
      referenceText: '你好',
      locale: 'zh-CN',
      vocabularyId: UUIDS.vocabulary,
      clientAttemptId: 'attempt-1',
    });

    expect(response).toMatchObject({ success: false, errorCode: 'SERVER_ERROR' });
  });

  it('keeps persistence failures visible and retryable', async () => {
    (supabase.functions.invoke as jest.Mock).mockResolvedValue({
      data: null,
      error: {
        context: new Response(JSON.stringify({ errorCode: 'PERSIST_FAILED' }), {
          status: 500,
          headers: { 'Content-Type': 'application/json' },
        }),
      },
    });

    const response = await assessPronunciation({
      audio: new Uint8Array([1, 2, 3]).buffer,
      referenceText: '你好',
      locale: 'zh-CN',
      vocabularyId: UUIDS.vocabulary,
      clientAttemptId: 'stable-attempt',
    });

    expect(response).toMatchObject({ success: false, errorCode: 'PERSIST_FAILED' });
    expect(supabase.functions.invoke).toHaveBeenCalledWith(
      'pronunciation-assess',
      expect.objectContaining({
        body: expect.objectContaining({ clientAttemptId: 'stable-attempt' }),
      }),
    );
  });

  it('removes the fake adapter and records each real callback score', () => {
    const practiceScreen = fs.readFileSync(
      path.join(__dirname, '..', 'app/pronunciation/practice.tsx'),
      'utf8',
    );
    const speakingExercise = fs.readFileSync(
      path.join(__dirname, '..', 'components/exercise/SpeakingExercise.tsx'),
      'utf8',
    );

    expect(practiceScreen).not.toContain('fakeExercise');
    expect(practiceScreen).not.toContain("lesson_id: ''");
    expect(practiceScreen).toContain('vocabularyId: word.id');
    expect(practiceScreen).toContain('[word.id]: result.overallScore');
    expect(practiceScreen).toContain('key={word.id}');
    expect(speakingExercise).toContain('clientAttemptIdRef.current');
    expect(speakingExercise).toContain('onAssessmentComplete?.(assessResult.result)');
  });

  it('checks persisted idempotency before invoking Azure and handles insert races', () => {
    const edgeFunction = fs.readFileSync(
      path.join(__dirname, '..', 'supabase/functions/pronunciation-assess/index.ts'),
      'utf8',
    );
    const retryLookup = edgeFunction.indexOf('findExistingAttempt');
    const providerCall = edgeFunction.indexOf('callAzurePronunciation(');

    expect(retryLookup).toBeGreaterThan(-1);
    expect(providerCall).toBeGreaterThan(retryLookup);
    expect(edgeFunction).toContain("attemptError.code === '23505'");
    expect(edgeFunction).toContain('validateAssessmentReference');
  });
});
