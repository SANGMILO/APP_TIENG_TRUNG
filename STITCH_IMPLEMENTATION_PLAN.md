# STITCH IMPLEMENTATION PLAN

> Safe screen-by-screen migration from current React Native UI to Stitch visual design
> Date: 2026-07-27

---

## Core Principles

1. **Visual only** — Stitch references are the VISUAL source of truth
2. **Logic preserved** — Existing app is the FUNCTIONAL source of truth
3. **No data replacement** — Never copy Stitch's static demo data over real dynamic data
4. **Incremental** — One screen at a time, fully tested before moving to next
5. **Rollback-safe** — Each migration can be reverted independently

---

## What MUST Be Preserved (Non-Negotiable)

| System | Location | Notes |
|--------|----------|-------|
| Supabase client | `lib/supabase/client.ts` | Auth + DB + Edge Functions |
| Authentication flow | `stores/auth-store.ts`, `app/(auth)/*` | Session, profile, signOut |
| Expo Router | `app/_layout.tsx`, all route files | File-based routing structure |
| Learning progress | `user_lesson_progress`, `user_course_progress` | Completion status, scores |
| SRS engine | `services/srs-engine.ts` | SM-2 algorithm, intervals |
| AI Tutor logic | `services/ai-tutor-service.ts`, `services/voice-conversation-service.ts` | Edge Function calls, conversations |
| Pronunciation | `services/pronunciation-service.ts`, `services/pronunciation-feedback.ts` | Azure Speech via Edge Function |
| Video logic | `services/video-service.ts`, `hooks/useVideos.ts` | Progress, subtitles, questions |
| XP / Streak / Hearts / Coins | `hooks/useXp.ts`, `services/gamification-service.ts` | Transactions, daily quests |
| Achievements | `services/gamification-service.ts` | Unlock logic, requirements |
| Tests | `jest.config.*`, `__tests__/` | Must pass after each migration |
| Real dynamic data | All Supabase queries | Never replace with Stitch static content |

---

## Design System: Stitch → React Native Mapping

### Color Tokens (from Stitch Tailwind config)
```
primary: #ac001e → colors.primary
primary-container: #d90429 → colors.primaryContainer  
surface: #fcf9f8 → colors.surface / colors.background
on-surface: #1b1b1b → colors.text
secondary: #5e5f5d → colors.textSecondary
tertiary: #205e44 → colors.jade
outline-variant: #e7bcba → colors.borderLight
surface-container-low: #f6f3f2 → colors.surfaceElevated
Gold accent: #d4af37 → colors.coin / colors.gold (new)
```

### Typography (from Stitch Tailwind config)
```
headline-lg: Montserrat 32px/40px bold
headline-lg-mobile: Montserrat 28px/34px bold
body-vn: Inter 16px/24px regular
label-sm: Inter 12px/16px semibold
display-hanzi: Noto Sans SC 64px/80px medium
pinyin-md: Inter 18px/24px medium, tracking 0.05em
```

### Shared Components (Stitch structure)
- **TopAppBar**: Streak + Brand title + XP/Hearts
- **BottomNavBar**: 5 tabs with active state (filled icon + primary color + bg highlight)
- **Card pattern**: `rounded-xl border border-outline-variant/30 shadow-[0px_4px_20px_rgba(191,0,34,0.05)]`
- **Glass effect**: `backdrop-filter: blur(12px)`, semi-transparent bg

---

## Migration Order

### Phase 1: Profile (LOWEST RISK)

**Screen**: 07 (Profile)
**Risk Level**: 🟢 Low
**Reason**: Profile is display-only, no complex interaction flows. Failure here doesn't block learning.

**Changes**:
- Redesign profile card layout (avatar + gold border + premium badge)
- Implement 2x2 stats grid (streak, XP, hearts, coins)
- Add level progress bar with gradient
- Redesign achievements section (badge grid)
- Redesign settings list
- Add hover/press micro-interactions

**Preserves**: `useAuthStore`, profile data, signOut flow, theme toggle

---

### Phase 2: Review (LOW-MEDIUM RISK)

**Screen**: 11 (Review - final version)
**Risk Level**: 🟡 Low-Medium
**Reason**: SRS logic lives in services layer, UI is presentation only. Circular progress SVGs are new.

**Changes**:
- Redesign hero CTA card ("Đến hạn hôm nay")
- Implement animated SVG circular progress rings (4 metrics)
- Redesign review tools section
- Add staggered slide-up entrance animations
- Add interactive card ripple effect
- Implement floating bottom nav variation (rounded, inset, blur)

**Preserves**: `user_vocabulary_progress` queries, SRS engine, review session routing, mistakes tracking

---

### Phase 3: Video (MEDIUM RISK)

**Screen**: 02 (Video)
**Risk Level**: 🟡 Medium
**Reason**: Search, filters, and video cards need visual overhaul. Featured video hero is new.

**Changes**:
- Redesign search bar (full-width, icon left)
- Implement horizontal category tabs
- Build hero featured video card with gradient overlay + play button + "continue watching" badge
- Redesign video feed items (thumbnail + metadata layout)
- Add HSK level badge styling
- Add duration overlay on thumbnails

**Preserves**: Supabase video queries, level filter logic, search filtering, continue watching queries, video navigation (`router.push`)

---

### Phase 4: AI Tutor (MEDIUM-HIGH RISK)

**Screen**: 03 (AI Tutor - enhanced) + 06 (shader)
**Risk Level**: 🟠 Medium-High
**Reason**: Most visually complex. Three.js shader, skeleton loading, pronunciation list. Must not break AI chat flow.

**Changes**:
- Build hero section with AI image + voice wave bars
- Implement conversation scenario cards (difficulty badge + XP reward + icon)
- Add pronunciation practice section (hanzi + pinyin + score display)
- Implement skeleton loading states with shimmer animation
- Add glass-card styling
- Consider WebGL shader (Three.js on web, simplified on native)

**Preserves**: `fetchConversations`, `checkDailyLimit`, SCENARIOS routing to `/ai-chat`, mode parameter passing, voice session logic

**Risk Mitigation**:
- Shader is optional/progressive enhancement
- Skeleton states wrap existing data loading
- Scenario cards reuse existing SCENARIOS array

---

### Phase 5: Home / Learn (HIGHEST RISK)

**Screen**: 05 (Learn - final) + 04 (shader)
**Risk Level**: 🔴 High
**Reason**: Most critical screen. Contains learning path, progress tracking, daily goal. Any breakage blocks the primary learning flow.

**Changes**:
- Redesign TopAppBar with frosted glass effect
- Redesign hero "Continue Learning" card with shader background
- Implement circular SVG daily goal widget
- Redesign AI tutor teaser card
- Rebuild learning path journey visualization (horizontal nodes with path line + progress fill)
- Add breathing-ring animation on current node
- Implement staggered entrance animations with easing

**Preserves**: Course/unit/chapter/lesson queries, lesson progress status calculation, `getStatus()` logic, daily XP calculation, `router.push('/lesson/${lesson.id}')`, StatPill data

**Risk Mitigation**:
- Build new UI components alongside existing ones
- Feature flag to switch between old/new Learn UI
- Test lesson navigation thoroughly before shipping

---

### Phase 6: Lesson Experience (HIGH RISK)

**Screens**: 15-20 (one reusable Lesson system)
**Risk Level**: High
**Reason**: Lesson is the primary transactional learning flow. Its UI coordinates
multiple exercise types, answer validation, timing, pronunciation services and
atomic completion.

**State References**:
- Screen 15: default/selected multiple choice
- Screen 16: correct feedback
- Screen 17: listening
- Screen 18: incorrect feedback
- Screen 19: speaking/pronunciation
- Screen 20: completion/result

**Changes**:
- Introduce a consistent immersive Lesson header with jade progress
- Create reusable option-card and answer-feedback presentation
- Apply the same visual system to vocabulary, translation and sentence-builder
- Redesign listening around the existing audio player behavior
- Restyle speaking recording, assessment and score presentation
- Build a responsive completion bento using real XP, accuracy, count, time and streak data
- Add focused selection, feedback, microphone and completion motion

**Preserves**:
- Dynamic `/lesson/[id]` routing and back behavior
- `fetchLessonExercises`, exercise ordering and all Supabase contracts
- All six existing exercise types and their interaction models
- `validateAnswer`, timing and result accumulation
- Audio playback, recording, pronunciation assessment and saved attempts
- `calculateLessonResult`, perfect bonus and `complete_lesson`
- Profile refresh after completion
- Loading, empty and error states

**Risk Mitigation**:
- Keep `services/lesson-engine.ts` unchanged unless a functional defect requires it
- Treat screens 15-20 as states of one renderer rather than separate routes
- Keep long content scrollable and bottom actions reachable on short screens
- Validate every exercise type before shipping

---

## Cross-Cutting Concerns

### Shared Components to Build First
Before starting per-screen work, extract these shared Stitch components:

1. **StitchTopAppBar** — Streak icon + brand title + XP/Hearts display
2. **StitchBottomNav** — Floating rounded nav with blur (replaces current tab bar)
3. **StitchCard** — Standard card with ambient shadow + border
4. **StitchGlassCard** — Blur + semi-transparent variant
5. **StitchProgressRing** — SVG circular progress (reused in Profile, Review, Learn)
6. **StitchSkeleton** — Shimmer loading placeholder

### Animation System
- Use `react-native-reanimated` for all animations (already installed)
- Implement staggered entrance pattern as a reusable hook
- Support `prefers-reduced-motion` (already in Stitch CSS)
- WebGL shaders: `expo-gl` for native, `<canvas>` for web (progressive enhancement)

### Typography
- Install/configure Montserrat + Inter + Noto Sans SC via `expo-font`
- Create typography scale constants matching Stitch tokens
- Existing app already uses Inter — extend to include Montserrat and Noto Sans SC

### Color System Update
- Extend `theme-store.ts` colors with Stitch Material 3 tokens
- Add gold accent (#d4af37) for premium/achievement elements
- Maintain dark mode compatibility

---

## Risk Assessment

| Risk | Impact | Mitigation |
|------|--------|------------|
| Breaking lesson navigation | Critical | Feature flag, thorough E2E testing |
| SRS data loss | Critical | UI-only changes, never modify service layer |
| Auth session loss | Critical | Don't touch auth store or Supabase client |
| Performance regression (shaders) | Medium | Progressive enhancement, lazy load shaders |
| Font loading failures | Low | Fallback to system fonts, async load |
| Animation jank on low-end devices | Low | `prefers-reduced-motion`, simpler native fallbacks |
| Bottom nav z-index conflicts | Low | Test on both iOS and Android |

---

## Verification Checklist (Per Screen)

Before marking a screen migration complete:

- [ ] All existing Supabase queries return same data
- [ ] All navigation (`router.push`) works correctly
- [ ] All user interactions (tap, swipe) remain functional
- [ ] Loading states display correctly
- [ ] Error states display correctly
- [ ] Empty states display correctly
- [ ] Dark mode renders correctly
- [ ] Web export renders correctly
- [ ] No TypeScript errors (`tsc --noEmit`)
- [ ] Existing tests pass (`jest`)
- [ ] Visual matches Stitch screenshot reference
- [ ] Animations feel smooth (60fps)
- [ ] Accessibility: screen reader labels preserved

---

## Timeline Estimate

| Phase | Screen | Est. Effort | Dependencies |
|-------|--------|-------------|--------------|
| 0 | Shared components + design tokens | 1-2 days | None |
| 1 | Profile | 1 day | Phase 0 |
| 2 | Review | 1-2 days | Phase 0 |
| 3 | Video | 1-2 days | Phase 0 |
| 4 | AI Tutor | 2-3 days | Phase 0 |
| 5 | Home/Learn | 2-3 days | Phase 0 |
| 6 | Lesson states 15-20 | 2-3 days | Phase 0 + Learn navigation |
| — | **Total** | **8-13 days** | — |
