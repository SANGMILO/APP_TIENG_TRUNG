import { supabase } from '../lib/supabase';
import {
  fetchDueReviewWords,
  submitMistakeReview,
  submitVocabularyReview,
} from '../services/review-service';

jest.mock('../lib/supabase', () => ({
  supabase: {
    from: jest.fn(),
    rpc: jest.fn(),
  },
}));

describe('Review service', () => {
  beforeEach(() => {
    jest.clearAllMocks();
  });

  it('loads persisted interval and state for due cards', async () => {
    const limit = jest.fn().mockResolvedValue({
      data: [{
        id: 'progress-1',
        vocabulary_id: 'word-1',
        difficulty: 2.35,
        interval_days: 8,
        review_count: 3,
        memory_strength: 0.6,
        state: 'review',
        vocabulary: {
          chinese: '你好',
          pinyin: 'nǐ hǎo',
          meaning_vi: 'Xin chào',
          audio_url: null,
          example_sentence: null,
          example_pinyin: null,
          example_meaning: null,
        },
      }],
      error: null,
    });
    const chain: any = {
      select: jest.fn(),
      eq: jest.fn(),
      lte: jest.fn(),
      order: jest.fn(),
      limit,
    };
    chain.select.mockReturnValue(chain);
    chain.eq.mockReturnValue(chain);
    chain.lte.mockReturnValue(chain);
    chain.order.mockReturnValue(chain);
    (supabase.from as jest.Mock).mockReturnValue(chain);

    const cards = await fetchDueReviewWords('user-1');

    expect(cards).toHaveLength(1);
    expect(cards[0]).toMatchObject({
      id: 'progress-1',
      interval_days: 8,
      review_count: 3,
      state: 'review',
    });
  });

  it('submits a stable vocabulary review to the authoritative RPC', async () => {
    (supabase.rpc as jest.Mock).mockResolvedValue({
      data: {
        success: true,
        submission_id: 'submission-1',
        progress_id: 'progress-1',
        vocabulary_id: 'word-1',
        rating: 'good',
        next_review_at: '2026-08-06T00:00:00.000Z',
        difficulty: 2.5,
        interval_days: 8,
        review_count: 4,
        memory_strength: 0.8,
        state: 'review',
        already_processed: false,
      },
      error: null,
    });

    const result = await submitVocabularyReview(
      'submission-1',
      'progress-1',
      'good',
    );

    expect(supabase.rpc).toHaveBeenCalledWith('submit_vocabulary_review', {
      p_submission_id: 'submission-1',
      p_progress_id: 'progress-1',
      p_rating: 'good',
    });
    expect(result.interval_days).toBe(8);
    expect(result.already_processed).toBe(false);
  });

  it('rejects malformed vocabulary review responses', async () => {
    (supabase.rpc as jest.Mock).mockResolvedValue({
      data: { success: true, interval_days: 8 },
      error: null,
    });

    await expect(
      submitVocabularyReview('submission-1', 'progress-1', 'good'),
    ).rejects.toThrow('vocabulary review response was invalid');
  });

  it('returns authoritative mistake correctness and retry state', async () => {
    (supabase.rpc as jest.Mock).mockResolvedValue({
      data: {
        success: true,
        submission_id: 'submission-2',
        mistake_id: 'mistake-1',
        is_correct: true,
        resolved: true,
        already_processed: true,
      },
      error: null,
    });

    const result = await submitMistakeReview(
      'submission-2',
      'mistake-1',
      '你好',
    );

    expect(supabase.rpc).toHaveBeenCalledWith('submit_mistake_review', {
      p_submission_id: 'submission-2',
      p_mistake_id: 'mistake-1',
      p_answer: '你好',
    });
    expect(result).toMatchObject({
      is_correct: true,
      resolved: true,
      already_processed: true,
    });
  });
});
