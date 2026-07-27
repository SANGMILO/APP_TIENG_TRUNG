# Mandarin Master - Architecture

## Overview
Mandarin Master is a comprehensive Chinese language learning platform for Vietnamese speakers.
Built with a single codebase targeting Web, Android, and iOS.

## Tech Stack

### Frontend
- **Framework**: React Native with Expo SDK 51+
- **Router**: Expo Router (file-based routing)
- **Web**: React Native Web (shared codebase)
- **Language**: TypeScript (strict mode)
- **State Management**: Zustand
- **Data Fetching**: TanStack Query v5
- **Forms**: React Hook Form + Zod validation
- **UI**: Custom design system (no external UI library)

### Backend
- **Platform**: Supabase
- **Database**: PostgreSQL
- **Auth**: Supabase Auth (Email, Google, Apple)
- **Storage**: Supabase Storage (audio, video, images)
- **Realtime**: Supabase Realtime (leaderboard, notifications)
- **Edge Functions**: Deno-based serverless functions

### AI & Speech
- **Speech**: Azure Speech SDK (Pronunciation Assessment zh-CN)
- **AI**: Configurable provider (OpenAI/Gemini/Claude)
- **TTS**: Azure Cognitive Services / configurable

## Project Structure

```
mandarin-master/
├── app/                    # Expo Router pages
│   ├── (auth)/            # Auth screens
│   ├── (tabs)/            # Main tab navigation
│   │   ├── learn/         # Learning path
│   │   ├── review/        # Daily review
│   │   ├── ai-tutor/     # AI conversation
│   │   ├── videos/       # Video learning
│   │   └── profile/      # User profile
│   ├── admin/             # Admin dashboard
│   ├── lesson/            # Lesson engine
│   └── onboarding/        # Onboarding flow
├── components/            # Shared components
│   ├── ui/               # Design system primitives
│   ├── chinese/          # Chinese-specific components
│   ├── exercise/         # Exercise type components
│   ├── gamification/     # XP, streak, badges
│   └── media/            # Audio, video players
├── lib/                   # Core libraries
│   ├── supabase/         # Supabase client & types
│   ├── ai/              # AI provider abstraction
│   ├── speech/          # Speech service abstraction
│   ├── analytics/       # Analytics service
│   └── storage/         # Local storage utilities
├── stores/               # Zustand stores
├── hooks/                # Custom React hooks
├── services/             # Business logic services
├── types/                # TypeScript type definitions
├── constants/            # App constants & config
├── utils/                # Utility functions
├── assets/               # Static assets
├── supabase/             # Supabase project files
│   ├── migrations/       # Database migrations
│   ├── functions/        # Edge Functions
│   └── seed/            # Seed data
└── __tests__/            # Test files
```

## Architecture Principles

1. **Separation of Concerns**: UI, business logic, and data access are cleanly separated
2. **Provider Pattern**: AI, Speech, Analytics use abstract interfaces for swappability
3. **Offline-Ready Architecture**: Data layer supports future offline/sync
4. **Security First**: All secrets handled server-side via Edge Functions
5. **Modular Content**: Course content is 100% database-driven, no hardcoded lessons
6. **Scalable Gamification**: XP/Coins use ledger pattern (transaction log)
7. **Role-Based Access**: RLS + server-side role checks for admin operations

## Key Design Decisions

### Navigation
- Bottom tabs for mobile (Learn, Review, AI Tutor, Videos, Profile)
- Left sidebar for web (responsive breakpoint at 768px)
- Stack navigation within each tab

### State Management
- **Zustand**: Auth state, UI state, lesson engine state
- **TanStack Query**: All server data (courses, progress, vocabulary)
- **Local Storage**: User preferences, cached audio references

### Lesson Engine
- Generic engine that renders exercises based on type
- Each exercise type is a separate component
- Engine manages progress, scoring, and XP calculation
- Results submitted atomically at lesson completion

### Content Model
- Course → Unit → Chapter → Lesson → Exercise
- All content has status: draft/review/published/archived
- Admin CMS allows full CRUD without code changes

### Security Model
- Supabase RLS for data isolation
- Edge Functions for sensitive operations (AI, Speech)
- Rate limiting per user for paid APIs
- Usage tracking for cost control
