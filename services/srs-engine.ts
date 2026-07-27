/**
 * Spaced Repetition System (SM-2 inspired)
 * Pure functions for calculating review intervals
 */

export type SRSRating = 'again' | 'hard' | 'good' | 'easy';

export type SRSState = 'new' | 'learning' | 'review' | 'mastered';

export interface SRSCard {
  difficulty: number;       // Ease factor (1.3 - 3.0, starts at 2.5)
  interval_days: number;    // Current interval in days
  review_count: number;     // Total reviews done
  memory_strength: number;  // 0-1 scale
  state: SRSState;
}

export interface SRSResult {
  next_review_at: Date;
  difficulty: number;
  interval_days: number;
  review_count: number;
  memory_strength: number;
  state: SRSState;
}

const MIN_EASE = 1.3;
const MAX_EASE = 3.0;
const GRADUATING_INTERVAL = 1;   // 1 day
const EASY_INTERVAL = 4;          // 4 days
const MASTERED_THRESHOLD = 21;    // 21 days = mastered

/**
 * Calculate next review based on rating
 */
export function calculateNextReview(card: SRSCard, rating: SRSRating, now: Date = new Date()): SRSResult {
  let { difficulty, interval_days, review_count, memory_strength } = card;
  review_count += 1;

  switch (rating) {
    case 'again': {
      // Reset to learning state
      interval_days = 0; // Review again soon (minutes)
      difficulty = Math.max(MIN_EASE, difficulty - 0.2);
      memory_strength = Math.max(0, memory_strength - 0.3);
      const next = new Date(now.getTime() + 10 * 60 * 1000); // 10 minutes
      return {
        next_review_at: next,
        difficulty,
        interval_days,
        review_count,
        memory_strength,
        state: 'learning',
      };
    }

    case 'hard': {
      difficulty = Math.max(MIN_EASE, difficulty - 0.15);
      if (interval_days === 0) {
        interval_days = GRADUATING_INTERVAL;
      } else {
        interval_days = Math.ceil(interval_days * 1.2);
      }
      memory_strength = Math.min(1, memory_strength + 0.1);
      break;
    }

    case 'good': {
      if (interval_days === 0) {
        interval_days = GRADUATING_INTERVAL;
      } else {
        interval_days = Math.ceil(interval_days * difficulty);
      }
      memory_strength = Math.min(1, memory_strength + 0.2);
      break;
    }

    case 'easy': {
      difficulty = Math.min(MAX_EASE, difficulty + 0.15);
      if (interval_days === 0) {
        interval_days = EASY_INTERVAL;
      } else {
        interval_days = Math.ceil(interval_days * difficulty * 1.3);
      }
      memory_strength = Math.min(1, memory_strength + 0.3);
      break;
    }
  }

  // Determine state
  let state: SRSState;
  if (interval_days >= MASTERED_THRESHOLD) {
    state = 'mastered';
  } else if (interval_days > 0) {
    state = 'review';
  } else {
    state = 'learning';
  }

  // Calculate next review date
  const next = new Date(now.getTime() + interval_days * 24 * 60 * 60 * 1000);

  return {
    next_review_at: next,
    difficulty,
    interval_days,
    review_count,
    memory_strength,
    state,
  };
}

/**
 * Create a new card with default values
 */
export function createNewCard(): SRSCard {
  return {
    difficulty: 2.5,
    interval_days: 0,
    review_count: 0,
    memory_strength: 0,
    state: 'new',
  };
}

/**
 * Determine the state from difficulty/interval
 */
export function getCardState(interval_days: number, review_count: number): SRSState {
  if (review_count === 0) return 'new';
  if (interval_days >= MASTERED_THRESHOLD) return 'mastered';
  if (interval_days > 0) return 'review';
  return 'learning';
}

/**
 * Check if a card is due for review
 */
export function isDue(next_review_at: Date, now: Date = new Date()): boolean {
  return now >= next_review_at;
}
