// Core type definitions for Mandarin Master

export type UserRole = 'student' | 'teacher' | 'editor' | 'admin' | 'super_admin';

export type ContentStatus = 'draft' | 'review' | 'published' | 'archived';

export type ExerciseType =
  | 'vocabulary'
  | 'multiple_choice'
  | 'listening'
  | 'speaking'
  | 'translation'
  | 'sentence_builder'
  | 'flashcard'
  | 'character_writing'
  | 'grammar'
  | 'tone_practice';

export type LessonStatus = 'locked' | 'available' | 'in_progress' | 'completed';

export type VocabularyDifficulty = 'easy' | 'medium' | 'hard' | 'master';

// Database row types
export interface Profile {
  id: string;
  email: string;
  username: string | null;
  display_name: string | null;
  avatar_url: string | null;
  role: UserRole;
  native_language: string;
  chinese_level: string;
  daily_goal_minutes: number;
  daily_goal_xp: number;
  learning_purpose: string | null;
  onboarding_completed: boolean;
  total_xp: number;
  total_coins: number;
  current_level: number;
  current_streak: number;
  longest_streak: number;
  hearts: number;
  hearts_updated_at: string;
  created_at: string;
  updated_at: string;
}

export interface Course {
  id: string;
  title: string;
  description: string | null;
  thumbnail_url: string | null;
  level: string;
  status: ContentStatus;
  order_index: number;
  created_by: string;
  created_at: string;
  updated_at: string;
}

export interface Unit {
  id: string;
  course_id: string;
  title: string;
  description: string | null;
  order_index: number;
  status: ContentStatus;
  created_at: string;
}

export interface Chapter {
  id: string;
  unit_id: string;
  title: string;
  description: string | null;
  order_index: number;
  status: ContentStatus;
  created_at: string;
}

export interface Lesson {
  id: string;
  chapter_id: string;
  title: string;
  description: string | null;
  order_index: number;
  xp_reward: number;
  status: ContentStatus;
  lesson_type: string;
  estimated_minutes: number;
  created_at: string;
}

export interface Exercise {
  id: string;
  lesson_id: string;
  exercise_type: ExerciseType;
  order_index: number;
  question: string;
  question_audio_url: string | null;
  correct_answer: string;
  explanation: string | null;
  hint: string | null;
  points: number;
  data: Record<string, unknown>; // Flexible JSON for type-specific data
  created_at: string;
}

export interface ExerciseOption {
  id: string;
  exercise_id: string;
  text: string;
  is_correct: boolean;
  order_index: number;
}

export interface Vocabulary {
  id: string;
  chinese: string;
  pinyin: string;
  meaning_vi: string;
  meaning_en: string | null;
  audio_url: string | null;
  level: string;
  category: string | null;
  example_sentence: string | null;
  example_pinyin: string | null;
  example_meaning: string | null;
  hsk_level: number | null;
  status: ContentStatus;
  created_at: string;
}

export interface Character {
  id: string;
  character: string;
  pinyin: string;
  meaning_vi: string;
  radical: string | null;
  stroke_count: number;
  stroke_order: string | null; // JSON array of stroke paths
  level: string;
  status: ContentStatus;
  created_at: string;
}

export interface UserCourseProgress {
  id: string;
  user_id: string;
  course_id: string;
  current_unit_id: string | null;
  current_chapter_id: string | null;
  current_lesson_id: string | null;
  percent_complete: number;
  started_at: string;
  completed_at: string | null;
}

export interface UserLessonProgress {
  id: string;
  user_id: string;
  lesson_id: string;
  status: LessonStatus;
  score: number | null;
  xp_earned: number;
  started_at: string | null;
  completed_at: string | null;
  attempts: number;
}

export interface UserVocabularyProgress {
  id: string;
  user_id: string;
  vocabulary_id: string;
  next_review_at: string;
  review_count: number;
  difficulty: number; // SM-2 ease factor
  memory_strength: number;
  last_reviewed_at: string | null;
}

export interface XpTransaction {
  id: string;
  user_id: string;
  amount: number;
  reason: string;
  source_type: string;
  source_id: string | null;
  created_at: string;
}

export interface CoinTransaction {
  id: string;
  user_id: string;
  amount: number;
  reason: string;
  source_type: string;
  source_id: string | null;
  created_at: string;
}

export interface Achievement {
  id: string;
  key: string;
  title: string;
  description: string;
  icon: string;
  category: string;
  requirement_type: string;
  requirement_value: number;
  xp_reward: number;
  coin_reward: number;
  created_at: string;
}

export interface UserAchievement {
  id: string;
  user_id: string;
  achievement_id: string;
  unlocked_at: string;
}

export interface Streak {
  id: string;
  user_id: string;
  current_streak: number;
  longest_streak: number;
  last_activity_date: string;
  streak_freeze_available: boolean;
  streak_freeze_used_at: string | null;
}

export interface LevelThreshold {
  level: number;
  xp_required: number;
  title: string | null;
}

export interface PronunciationAttempt {
  id: string;
  user_id: string;
  reference_text: string;
  pinyin: string;
  audio_url: string | null;
  overall_score: number;
  accuracy_score: number;
  fluency_score: number;
  completeness_score: number;
  feedback: Record<string, unknown> | null;
  created_at: string;
}

export interface StudySession {
  id: string;
  user_id: string;
  started_at: string;
  ended_at: string | null;
  duration_seconds: number;
  xp_earned: number;
  lessons_completed: number;
  exercises_completed: number;
}

// UI Types
export interface LessonNode {
  lesson: Lesson;
  status: LessonStatus;
  progress?: UserLessonProgress;
}

export interface ExerciseResult {
  exercise_id: string;
  is_correct: boolean;
  user_answer: string;
  time_spent_seconds: number;
  pronunciation_score?: number;
}

export interface LessonResult {
  lesson_id: string;
  total_exercises: number;
  correct_answers: number;
  xp_earned: number;
  accuracy: number;
  speaking_score?: number;
  perfect: boolean;
  time_spent_seconds: number;
}
