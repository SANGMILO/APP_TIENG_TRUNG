import { calculateNextReview, createNewCard, isDue, SRSCard } from '../services/srs-engine';

describe('SRS Engine', () => {
  const now = new Date('2024-06-01T10:00:00Z');

  describe('createNewCard', () => {
    it('creates a card with default values', () => {
      const card = createNewCard();
      expect(card.difficulty).toBe(2.5);
      expect(card.interval_days).toBe(0);
      expect(card.review_count).toBe(0);
      expect(card.memory_strength).toBe(0);
      expect(card.state).toBe('new');
    });
  });

  describe('calculateNextReview', () => {
    it('again rating: reviews in 10 minutes', () => {
      const card = createNewCard();
      const result = calculateNextReview(card, 'again', now);

      expect(result.state).toBe('learning');
      expect(result.difficulty).toBeLessThan(2.5);
      expect(result.interval_days).toBe(0);
      // Should be ~10 min from now
      const diffMs = result.next_review_at.getTime() - now.getTime();
      expect(diffMs).toBe(10 * 60 * 1000);
    });

    it('hard rating: graduates to 1 day', () => {
      const card = createNewCard();
      const result = calculateNextReview(card, 'hard', now);

      expect(result.interval_days).toBe(1);
      expect(result.difficulty).toBeLessThan(2.5);
      expect(result.review_count).toBe(1);
    });

    it('good rating: graduates to 1 day', () => {
      const card = createNewCard();
      const result = calculateNextReview(card, 'good', now);

      expect(result.interval_days).toBe(1);
      expect(result.review_count).toBe(1);
    });

    it('easy rating: jumps to 4 days', () => {
      const card = createNewCard();
      const result = calculateNextReview(card, 'easy', now);

      expect(result.interval_days).toBe(4);
      expect(result.difficulty).toBeGreaterThan(2.5);
    });

    it('good on existing card: multiplies interval by ease', () => {
      const card: SRSCard = {
        difficulty: 2.5,
        interval_days: 3,
        review_count: 2,
        memory_strength: 0.4,
        state: 'review',
      };
      const result = calculateNextReview(card, 'good', now);

      // 3 * 2.5 = 7.5, ceil = 8
      expect(result.interval_days).toBe(8);
      expect(result.memory_strength).toBeGreaterThan(0.4);
    });

    it('easy on existing card: grows interval faster', () => {
      const card: SRSCard = {
        difficulty: 2.5,
        interval_days: 3,
        review_count: 2,
        memory_strength: 0.4,
        state: 'review',
      };
      const result = calculateNextReview(card, 'easy', now);

      // 3 * 2.65 * 1.3 = 10.33, ceil = 11
      expect(result.interval_days).toBeGreaterThan(8);
    });

    it('again on reviewed card: resets to learning', () => {
      const card: SRSCard = {
        difficulty: 2.5,
        interval_days: 10,
        review_count: 5,
        memory_strength: 0.7,
        state: 'review',
      };
      const result = calculateNextReview(card, 'again', now);

      expect(result.state).toBe('learning');
      expect(result.interval_days).toBe(0);
      expect(result.memory_strength).toBeLessThan(0.7);
    });

    it('mastered state when interval >= 21 days', () => {
      const card: SRSCard = {
        difficulty: 2.5,
        interval_days: 10,
        review_count: 5,
        memory_strength: 0.8,
        state: 'review',
      };
      const result = calculateNextReview(card, 'good', now);

      // 10 * 2.5 = 25 days
      expect(result.interval_days).toBeGreaterThanOrEqual(21);
      expect(result.state).toBe('mastered');
    });

    it('difficulty never drops below 1.3', () => {
      let card = createNewCard();
      // Rate "again" many times
      for (let i = 0; i < 20; i++) {
        const result = calculateNextReview(card, 'again', now);
        card = { ...card, difficulty: result.difficulty, interval_days: result.interval_days, review_count: result.review_count, memory_strength: result.memory_strength, state: result.state };
      }
      expect(card.difficulty).toBeGreaterThanOrEqual(1.3);
    });

    it('difficulty never exceeds 3.0', () => {
      let card = createNewCard();
      for (let i = 0; i < 20; i++) {
        const result = calculateNextReview(card, 'easy', now);
        card = { ...card, difficulty: result.difficulty, interval_days: result.interval_days, review_count: result.review_count, memory_strength: result.memory_strength, state: result.state };
      }
      expect(card.difficulty).toBeLessThanOrEqual(3.0);
    });

    it('keeps very mature review intervals within the persisted bound', () => {
      const result = calculateNextReview({
        difficulty: 3,
        interval_days: 30000,
        review_count: 100,
        memory_strength: 1,
        state: 'mastered',
      }, 'easy', now);

      expect(result.interval_days).toBe(36500);
      expect(result.state).toBe('mastered');
    });
  });

  describe('isDue', () => {
    it('returns true when review time has passed', () => {
      const past = new Date('2024-05-30T10:00:00Z');
      expect(isDue(past, now)).toBe(true);
    });

    it('returns false when review time is in the future', () => {
      const future = new Date('2024-06-05T10:00:00Z');
      expect(isDue(future, now)).toBe(false);
    });

    it('returns true when review time equals now', () => {
      expect(isDue(now, now)).toBe(true);
    });
  });
});
