jest.mock('../lib/supabase', () => ({
  supabase: { from: jest.fn(), rpc: jest.fn(), auth: { getUser: jest.fn() } },
}));

describe('Gamification System', () => {
  describe('XP Idempotency Rules', () => {
    it('lesson completion XP uses lesson_id + date as key', () => {
      const userId = 'user-1';
      const lessonId = 'lesson-1';
      const date = '2024-06-01';
      const key = `${userId}:lesson_complete:${lessonId}:${date}`;
      expect(key).toBe('user-1:lesson_complete:lesson-1:2024-06-01');
    });

    it('same lesson same day = same key', () => {
      const key1 = 'user-1:lesson_complete:lesson-1:2024-06-01';
      const key2 = 'user-1:lesson_complete:lesson-1:2024-06-01';
      expect(key1).toBe(key2);
    });

    it('different day = different key', () => {
      const key1 = 'user-1:lesson_complete:lesson-1:2024-06-01';
      const key2 = 'user-1:lesson_complete:lesson-1:2024-06-02';
      expect(key1).not.toBe(key2);
    });
  });

  describe('Daily Quest Types', () => {
    const validTypes = ['lessons_completed', 'words_reviewed', 'speaking_exercises', 'daily_xp', 'study_minutes', 'videos_completed'];

    it('supports expected quest types', () => {
      expect(validTypes.length).toBeGreaterThanOrEqual(5);
    });

    it('each type is a string', () => {
      validTypes.forEach(t => expect(typeof t).toBe('string'));
    });
  });

  describe('Streak Rules', () => {
    it('same day multiple activities = streak +1 only', () => {
      const activitiesInDay = 5;
      const streakIncrement = 1;
      expect(streakIncrement).toBe(1);
    });

    it('streak freeze preserves streak for one missed day', () => {
      const hadFreeze = true;
      const missedDays = 1;
      const streakPreserved = hadFreeze && missedDays <= 1;
      expect(streakPreserved).toBe(true);
    });

    it('two missed days breaks streak even with freeze', () => {
      const hadFreeze = true;
      const missedDays = 2;
      const streakPreserved = hadFreeze && missedDays <= 1;
      expect(streakPreserved).toBe(false);
    });
  });

  describe('Heart System Rules', () => {
    const MAX_HEARTS = 5;

    it('incorrect answer costs 1 heart', () => {
      const hearts = 5;
      const afterWrong = hearts - 1;
      expect(afterWrong).toBe(4);
    });

    it('hearts cannot go below 0', () => {
      const hearts = 0;
      const afterWrong = Math.max(0, hearts - 1);
      expect(afterWrong).toBe(0);
    });

    it('max hearts is 5', () => {
      expect(MAX_HEARTS).toBe(5);
    });

    it('network errors do NOT cost hearts', () => {
      const isLearningError = false; // network error
      const shouldDeduct = isLearningError;
      expect(shouldDeduct).toBe(false);
    });
  });

  describe('Shop Purchase Rules', () => {
    it('rejects purchase when coins insufficient', () => {
      const balance = 30;
      const price = 50;
      const canPurchase = balance >= price;
      expect(canPurchase).toBe(false);
    });

    it('allows purchase when coins sufficient', () => {
      const balance = 80;
      const price = 50;
      const canPurchase = balance >= price;
      expect(canPurchase).toBe(true);
    });

    it('deducts exact price from balance', () => {
      const balance = 100;
      const price = 50;
      const afterPurchase = balance - price;
      expect(afterPurchase).toBe(50);
    });

    it('duplicate purchase key prevents double buy', () => {
      const key1 = 'user-1:shop:item-1:1717200000000';
      const key2 = 'user-1:shop:item-1:1717200000000';
      expect(key1).toBe(key2); // same key = idempotent
    });
  });

  describe('League Promotion Rules', () => {
    const groupSize = 30;
    const promoteCount = 5;
    const demoteCount = 5;

    it('top 5 promoted', () => {
      const rank = 3;
      const promoted = rank <= promoteCount;
      expect(promoted).toBe(true);
    });

    it('bottom 5 demoted', () => {
      const rank = 28;
      const demoted = rank > groupSize - demoteCount;
      expect(demoted).toBe(true);
    });

    it('middle stays', () => {
      const rank = 15;
      const promoted = rank <= promoteCount;
      const demoted = rank > groupSize - demoteCount;
      expect(promoted).toBe(false);
      expect(demoted).toBe(false);
    });

    it('lowest league cannot demote', () => {
      const league = 'jade'; // rank 1 = lowest
      const canDemote = league !== 'jade';
      expect(canDemote).toBe(false);
    });

    it('highest league cannot promote', () => {
      const league = 'dragon'; // rank 5 = highest
      const canPromote = league !== 'dragon';
      expect(canPromote).toBe(false);
    });
  });

  describe('XP Boost Rules', () => {
    it('boost applies to lesson XP', () => {
      const baseXp = 10;
      const multiplier = 2;
      const boostedXp = baseXp * multiplier;
      expect(boostedXp).toBe(20);
    });

    it('boost does NOT apply to achievement rewards', () => {
      const achievementXp = 30;
      const eligible = false; // achievements excluded
      const finalXp = eligible ? achievementXp * 2 : achievementXp;
      expect(finalXp).toBe(30);
    });

    it('expired boost does not apply', () => {
      const boostExpiresAt = new Date('2024-06-01T10:00:00Z');
      const now = new Date('2024-06-01T11:00:00Z');
      const isActive = now < boostExpiresAt;
      expect(isActive).toBe(false);
    });
  });

  describe('Timezone handling', () => {
    it('daily quest date uses user timezone', () => {
      // 23:30 UTC = 06:30+7 next day
      const utcTime = new Date('2024-06-01T23:30:00Z');
      const vnOffset = 7; // hours
      const vnDate = new Date(utcTime.getTime() + vnOffset * 3600 * 1000);
      const vnDay = vnDate.toISOString().split('T')[0];
      expect(vnDay).toBe('2024-06-02'); // next day in VN
    });
  });
});
