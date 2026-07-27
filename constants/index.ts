export * from './theme';
export * from './assets';

export const APP_NAME = 'Mandarin Master';

export const XP_REWARDS = {
  LESSON_COMPLETE: 10,
  PERFECT_LESSON: 5,
  SPEAKING_EXERCISE: 5,
  DAILY_QUEST: 20,
  DAILY_GOAL: 5,
  STREAK_BONUS: 3,
  FIRST_LESSON_DAY: 2,
} as const;

export const COIN_REWARDS = {
  DAILY_GOAL: 5,
  PERFECT_LESSON: 10,
  ACHIEVEMENT: 20,
  LEVEL_UP: 50,
} as const;

export const HEARTS = {
  MAX: 5,
  REFILL_MINUTES: 30,
} as const;

export const STUDY_GOALS = [
  { minutes: 5, label: '5 phút', xpTarget: 10 },
  { minutes: 10, label: '10 phút', xpTarget: 20 },
  { minutes: 15, label: '15 phút', xpTarget: 30 },
  { minutes: 20, label: '20 phút', xpTarget: 50 },
  { minutes: 30, label: '30 phút', xpTarget: 80 },
] as const;

export const LEARNING_PURPOSES = [
  { id: 'communication', label: 'Giao tiếp', icon: '💬' },
  { id: 'travel', label: 'Du lịch', icon: '✈️' },
  { id: 'work', label: 'Công việc', icon: '💼' },
  { id: 'movies', label: 'Xem phim Trung Quốc', icon: '🎬' },
  { id: 'business', label: 'Kinh doanh', icon: '📈' },
  { id: 'hsk', label: 'Thi HSK', icon: '📝' },
  { id: 'scratch', label: 'Học từ đầu', icon: '🌱' },
  { id: 'other', label: 'Khác', icon: '✨' },
] as const;

export const EXPERIENCE_LEVELS = [
  { id: 'none', label: 'Chưa biết gì', description: 'Bắt đầu từ con số 0' },
  { id: 'little', label: 'Biết một chút', description: 'Biết vài từ cơ bản' },
  { id: 'learned', label: 'Đã học trước đây', description: 'Có nền tảng cơ bản' },
  { id: 'test', label: 'Kiểm tra trình độ', description: 'Làm bài test xếp lớp' },
] as const;
