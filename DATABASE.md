# Mandarin Master - Database Schema

## Overview
PostgreSQL database hosted on Supabase with Row Level Security (RLS).

## Core Tables

### User & Auth
- `profiles` - User profiles extending Supabase auth
- `user_settings` - User preferences and settings

### Course Structure
- `courses` - Top-level courses
- `units` - Units within courses
- `chapters` - Chapters within units
- `lessons` - Individual lessons
- `exercise_types` - Types of exercises (vocab, listening, speaking, etc.)
- `exercises` - Exercise instances within lessons
- `exercise_options` - Multiple choice options for exercises

### Content
- `vocabulary` - Chinese vocabulary entries
- `lesson_vocabulary` - M2M: vocabulary used in lessons
- `characters` - Chinese characters with stroke data
- `grammar_lessons` - Grammar explanations and rules
- `videos` - Video content
- `video_subtitles` - Subtitle tracks for videos
- `video_questions` - Interactive questions at timestamps

### User Progress
- `user_course_progress` - Course enrollment and progress
- `user_lesson_progress` - Per-lesson completion status
- `user_exercise_attempts` - Individual exercise attempts
- `user_vocabulary_progress` - SRS data per vocabulary item
- `user_character_progress` - Character writing progress
- `pronunciation_attempts` - Speech assessment history
- `study_sessions` - Study session tracking

### Gamification
- `xp_transactions` - XP ledger (immutable log)
- `coin_transactions` - Coin ledger (immutable log)
- `level_thresholds` - XP required for each level
- `achievements` - Achievement definitions
- `user_achievements` - Unlocked achievements
- `streaks` - User streak data
- `daily_quests` - Daily quest definitions
- `user_daily_quests` - User quest progress
- `leaderboards` - Weekly leaderboard snapshots

### System
- `saved_words` - User's personal dictionary
- `mistakes` - Mistake notebook entries
- `notifications` - User notifications
- `admin_activity_logs` - Admin audit trail
- `usage_tracking` - API usage for cost control
- `announcements` - System announcements

## Entity Relationship Diagram (Simplified)

```
profiles (1) ──── (N) user_course_progress
courses (1) ──── (N) units
units (1) ──── (N) chapters
chapters (1) ──── (N) lessons
lessons (1) ──── (N) exercises
exercises (1) ──── (N) exercise_options
exercises (N) ──── (1) exercise_types
vocabulary (N) ──── (N) lessons (via lesson_vocabulary)
profiles (1) ──── (N) xp_transactions
profiles (1) ──── (N) user_vocabulary_progress
profiles (1) ──── (N) pronunciation_attempts
```

## Key Design Patterns

### XP Ledger Pattern
```sql
-- Never directly update xp on profiles
-- Instead, insert into xp_transactions
-- Total XP = SUM(amount) FROM xp_transactions WHERE user_id = ?
-- Use materialized view or trigger for performance
```

### Spaced Repetition
```sql
-- user_vocabulary_progress stores:
-- next_review_at, review_count, difficulty, memory_strength
-- Algorithm: SM-2 variant
-- next_review = now + interval * ease_factor
```

### Content Status
```sql
-- All content tables have:
-- status: 'draft' | 'review' | 'published' | 'archived'
-- created_at, updated_at, published_at
-- created_by, updated_by (references profiles)
```

### RLS Policies
```sql
-- Students: Can only read published content
-- Students: Can only CRUD their own progress data
-- Editors: Can CRUD content in draft/review
-- Admins: Full access to all content and user management
```
