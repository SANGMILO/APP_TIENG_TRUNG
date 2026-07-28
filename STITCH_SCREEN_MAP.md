# STITCH SCREEN MAP

> Generated: 2026-07-27
> Source: `stitch-reference/manifest.json` (Project ID: 6506278782152367391)
> Total references available: 20 (11 original exports, 3 auth references, 6 Lesson references)

---

## Screen 01 — Home / Learn (Original Version)

| Field | Value |
|-------|-------|
| **Stitch Screen ID** | `c4068b9669d542d88cb416a363045a2e` |
| **Reference Folder** | `stitch-reference/01_c4068b9669d542d88cb416a363045a2e/` |
| **Represents** | Home / Learn tab (main landing screen) |
| **Existing App Route** | `/(tabs)/learn` |
| **Existing Source File** | `app/(tabs)/learn.tsx` |
| **Existing Reusable Components** | `Card`, `ProgressBar`, `Avatar`, `FadeInView`, `AnimatedPressable`, `StatPill`, `GlassCard`, `PulsingDot` |
| **Existing Data/Logic** | `useAuthStore` (profile), Supabase queries: courses→units→chapters→lessons, `user_lesson_progress`, `xp_transactions`, daily XP goal calculation |
| **UI Components to Redesign** | TopAppBar (streak/XP/hearts), greeting section, hero "Continue Learning" card, daily goal circular progress, AI tutor teaser card, learning path journey nodes |
| **Animations/Micro-interactions** | Journey node pulse ring, staggered fade-up entrance, progress bar animated fill, node hover scale, hero card decorative blur accent |

---

## Screen 02 — Video

| Field | Value |
|-------|-------|
| **Stitch Screen ID** | `92df967f5cc04643b66b2192e3954e2d` |
| **Reference Folder** | `stitch-reference/02_92df967f5cc04643b66b2192e3954e2d/` |
| **Represents** | Video tab (video learning hub) |
| **Existing App Route** | `/(tabs)/videos` |
| **Existing Source File** | `app/(tabs)/videos.tsx` |
| **Existing Reusable Components** | `VideoCard`, `FadeInView`, `AnimatedPressable`, `ProgressBar` |
| **Existing Data/Logic** | Supabase: `videos` table, `user_video_progress`, continue watching query, level filter, search |
| **UI Components to Redesign** | Search bar, category tabs (horizontal scroll), hero featured video card with gradient overlay, video feed list items with thumbnails, HSK level badges, view count display |
| **Animations/Micro-interactions** | Featured video hover zoom (group-hover:scale-105), card hover border transition, thumbnail scale on hover |

---

## Screen 03 — AI Tutor (Enhanced with Animations)

| Field | Value |
|-------|-------|
| **Stitch Screen ID** | `8c3dd242d4dc43b083ffb5884d422d2c` |
| **Reference Folder** | `stitch-reference/03_8c3dd242d4dc43b083ffb5884d422d2c/` |
| **Represents** | AI Tutor tab (with skeleton loading, Three.js shader, premium animations) |
| **Existing App Route** | `/(tabs)/ai-tutor` |
| **Existing Source File** | `app/(tabs)/ai-tutor.tsx` |
| **Existing Reusable Components** | `FadeInView`, `AnimatedPressable`, `ProgressBar`, `GlassCard` |
| **Existing Data/Logic** | `ai-tutor-service.ts`: `fetchConversations`, `checkDailyLimit`, conversation scenarios (SCENARIOS array), mode routing |
| **UI Components to Redesign** | Hero section with AI robot image + voice wave animation, conversation scenario cards (difficulty + XP reward), pronunciation practice section with hanzi/pinyin display + score %, glass card styling |
| **Animations/Micro-interactions** | Three.js WebGL shader (AI breathing aura), skeleton loading states with shimmer, `pulse-soft` button animation, `premium-hover` card lift effect, staggered `fade-in-up` sections, glass-nav bottom bar with blur |

---

## Screen 04 — Hero Shader Background (Fallback)

| Field | Value |
|-------|-------|
| **Stitch Screen ID** | `831e9c8aae864bd7b04a4f0b0c72694f` |
| **Reference Folder** | `stitch-reference/fallback_831e9c8aae864bd7b04a4f0b0c72694f/` |
| **Represents** | WebGL shader animation for Home/Learn hero card background (soft ivory-to-red gradient) |
| **Existing App Route** | `/(tabs)/learn` (decorative background element) |
| **Existing Source File** | `app/(tabs)/learn.tsx` (hero card area) |
| **Status** | Export failed — contains only shader animation canvas |
| **Notes** | This is the WebGL background shader used in the Home/Learn hero card. Soft moving gradient effect (ivory → rose). Can be implemented using `react-native-reanimated` or `expo-gl` on native, CSS/canvas on web. |

---

## Screen 05 — Home / Learn (Refined Version with Shader + Animations)

| Field | Value |
|-------|-------|
| **Stitch Screen ID** | `9c1cf71c4355414aaff57de2f4f20562` |
| **Reference Folder** | `stitch-reference/05_9c1cf71c4355414aaff57de2f4f20562/` |
| **Represents** | Home / Learn tab — premium iteration with WebGL hero shader + refined animations |
| **Existing App Route** | `/(tabs)/learn` |
| **Existing Source File** | `app/(tabs)/learn.tsx` |
| **Existing Reusable Components** | Same as Screen 01 |
| **Existing Data/Logic** | Same as Screen 01 |
| **UI Components to Redesign** | Same layout as Screen 01 but with: frosted glass TopAppBar (`backdrop-blur-md`), canvas shader hero background, breathing-ring node animation, refined progress ring animation |
| **Animations/Micro-interactions** | `breathing-entrance` (scale+fade), `staggered-fade-up` with easing, `breathing-ring` (pulsing node ring), `progress-fill` SVG stroke animation, `btn-interactive` active scale feedback, `prefers-reduced-motion` support |
| **Notes** | This is the FINAL design iteration for Home/Learn. Use this over Screen 01. |

---

## Screen 06 — AI Tutor Shader Background (Fallback)

| Field | Value |
|-------|-------|
| **Stitch Screen ID** | `c3eec56fbd9842819dee1be32cb63bec` |
| **Reference Folder** | `stitch-reference/fallback_c3eec56fbd9842819dee1be32cb63bec/` |
| **Represents** | WebGL shader animation for AI Tutor hero (red breathing aura) |
| **Existing App Route** | `/(tabs)/ai-tutor` (decorative hero element) |
| **Existing Source File** | `app/(tabs)/ai-tutor.tsx` (hero section area) |
| **Status** | Export failed — contains only shader animation canvas |
| **Notes** | AI breathing aura shader: pulsating red (#D90429) radial gradient. Used as background for the AI Tutor hero section. |

---

## Screen 07 — Profile

| Field | Value |
|-------|-------|
| **Stitch Screen ID** | `dcad7c1016294ad7a3a2ce669bc53cb2` |
| **Reference Folder** | `stitch-reference/07_dcad7c1016294ad7a3a2ce669bc53cb2/` |
| **Represents** | Profile / "Cá nhân" tab |
| **Existing App Route** | `/(tabs)/profile` |
| **Existing Source File** | `app/(tabs)/profile.tsx` |
| **Existing Reusable Components** | `Card`, `Button`, `Avatar`, `ProgressBar`, `FadeInView`, `AnimatedPressable`, `GlassCard` |
| **Existing Data/Logic** | `useAuthStore` (profile: XP, streak, hearts, coins, level, display_name), `signOut`, `toggleMode` |
| **UI Components to Redesign** | Profile card with gold premium badge + avatar border, 2x2 stats grid (streak/XP/hearts/coins), level progress bar (gradient from primary→gold), achievements section (4-col badge grid with locked states), settings list (icon + title + chevron), sign out button |
| **Animations/Micro-interactions** | Stat cards `hover:-translate-y-1` lift effect, achievement badge `group-hover:scale-110`, settings row hover background transition |

---

## Screen 08 — AI Tutor (Base Version)

| Field | Value |
|-------|-------|
| **Stitch Screen ID** | `dff33d10409c4473a0a812172da78173` |
| **Reference Folder** | `stitch-reference/08_dff33d10409c4473a0a812172da78173/` |
| **Represents** | AI Tutor tab (base version without loading animations/skeleton) |
| **Existing App Route** | `/(tabs)/ai-tutor` |
| **Existing Source File** | `app/(tabs)/ai-tutor.tsx` |
| **Existing Reusable Components** | Same as Screen 03 |
| **Existing Data/Logic** | Same as Screen 03 |
| **UI Components to Redesign** | Same sections as Screen 03 without Three.js shader and skeleton states |
| **Animations/Micro-interactions** | Voice wave bar animation (5 bars with staggered pulse), card hover border-primary/50 transition |
| **Notes** | Screen 03 is the enhanced iteration. Use Screen 03 as the primary visual reference for AI Tutor. Screen 08 serves as fallback if Three.js/skeleton is too heavy. |

---

## Screen 09 — Home / Learn (Fallback — Encoding Issues)

| Field | Value |
|-------|-------|
| **Stitch Screen ID** | `efc80a0a393a446d855e396743ff2200` |
| **Reference Folder** | `stitch-reference/fallback_efc80a0a393a446d855e396743ff2200/` |
| **Represents** | Home / Learn tab — same as Screen 01 but with UTF-8 encoding issues |
| **Existing App Route** | `/(tabs)/learn` |
| **Status** | Export failed — fallback has garbled Vietnamese text (mojibake) |
| **Notes** | Structurally identical to Screen 01/05. Discard. Use Screen 05 as the definitive Learn reference. |

---

## Screen 10 — Review / Ôn tập (Base Version)

| Field | Value |
|-------|-------|
| **Stitch Screen ID** | `a597051bf66f4ff19f8e9fec2e49096b` |
| **Reference Folder** | `stitch-reference/10_a597051bf66f4ff19f8e9fec2e49096b/` |
| **Represents** | Review / Ôn tập tab |
| **Existing App Route** | `/(tabs)/review` |
| **Existing Source File** | `app/(tabs)/review.tsx` |
| **Existing Reusable Components** | `Card`, `Button`, `ProgressBar`, `FadeInView`, `AnimatedPressable`, `GlassCard` |
| **Existing Data/Logic** | Supabase: `user_vocabulary_progress` (due count, learning, mastered, memory_strength), `mistakes` table, SRS engine (`srs-engine.ts`) |
| **UI Components to Redesign** | Hero "Đến hạn hôm nay" CTA card with decorative icon background, 2x2→4-col memory progress grid (circular SVG charts: cần ôn/đang học/thành thạo/hay sai), review tools section (list items with icon circles + descriptions) |
| **Animations/Micro-interactions** | Stat icon `group-hover:scale-110` transition, card hover border/shadow change |

---

## Screen 11 — Review / Ôn tập (Enhanced with Animations)

| Field | Value |
|-------|-------|
| **Stitch Screen ID** | `33ccb869857b4335b5022136e1bad04e` |
| **Reference Folder** | `stitch-reference/11_33ccb869857b4335b5022136e1bad04e/` |
| **Represents** | Review / Ôn tập tab — premium iteration with motion system |
| **Existing App Route** | `/(tabs)/review` |
| **Existing Source File** | `app/(tabs)/review.tsx` |
| **Existing Reusable Components** | Same as Screen 10 |
| **Existing Data/Logic** | Same as Screen 10 |
| **UI Components to Redesign** | Same layout as Screen 10 but with premium floating nav bar, interactive card ripple effects |
| **Animations/Micro-interactions** | `slideUpFade` with staggered delays (50-300ms), animated SVG circle fills (`circleFill1-4`), `interactive-card` with ripple effect (::after pseudo-element), `success-glow` state for completed tasks, floating bottom nav with blur + rounded-2xl |
| **Notes** | This is the FINAL design iteration for Review. Use Screen 11 over Screen 10. |

---

## Additional: Review Extra Reference

| Field | Value |
|-------|-------|
| **Reference Folder** | `stitch-reference/review/` |
| **Represents** | Supplementary review screen reference (possibly earlier iteration) |
| **Notes** | Has encoding issues similar to Screen 09. Use Screen 11 as the definitive Review reference. |

---

## Screens 15-20 - Lesson Experience

All six references map to the same reusable immersive Lesson route. They are state
references, not separate application routes.

| # | Reference Folder | Represents | Existing Route / Source |
|---|------------------|------------|-------------------------|
| 15 | `stitch-reference/15_Lesson_MultipleChoice/` | Default and selected multiple-choice state | `/lesson/[id]` - `app/lesson/[id].tsx` |
| 16 | `stitch-reference/16_Lesson_Correct/` | Correct-answer reveal and feedback panel | `/lesson/[id]` - `app/lesson/[id].tsx` |
| 17 | `stitch-reference/17_Lesson_Listening/` | Listening player and listening answer options | `/lesson/[id]` - `app/lesson/[id].tsx` |
| 18 | `stitch-reference/18_Lesson_Incorrect/` | Incorrect selection, correct reveal and explanation | `/lesson/[id]` - `app/lesson/[id].tsx` |
| 19 | `stitch-reference/19_Lesson_Speaking/` | Speaking recorder, microphone state and pronunciation scores | `/lesson/[id]` - `components/exercise/SpeakingExercise.tsx` |
| 20 | `stitch-reference/20_Lesson_Complete/` | Completion entrance, XP, accuracy, correct count, time and streak | `/lesson/[id]` - `app/lesson/[id].tsx` |

### Existing Lesson Functionality

- Supabase exercise loading and ordering through `services/lesson-engine.ts`
- Dynamic lesson ID routing
- Vocabulary, multiple-choice, listening, translation, sentence-builder and speaking exercises
- Chinese, pinyin and Vietnamese content from exercise data
- Audio playback, recording, pronunciation assessment and saved attempts
- Answer validation, per-exercise timing and progress tracking
- Lesson result calculation, perfect bonus, `complete_lesson` RPC and profile refresh
- Loading, empty, error, feedback and completion states

### Visual Implementation Notes

- Use the jade progress treatment and immersive Lesson header across all exercise types.
- Reuse the Screen 15 option-card language for exercise types without a dedicated reference.
- Use Screen 16 and Screen 18 as the canonical correct/incorrect feedback states.
- Keep the bottom tab bar hidden while the Lesson route is active.
- Bind every label, score, answer, XP amount and elapsed time to real runtime data.

---

## Summary Table

| # | Stitch Screen | Maps To | App Route | Source File | Final Version? |
|---|--------------|---------|-----------|-------------|---------------|
| 01 | c4068b96... | Home/Learn | /(tabs)/learn | app/(tabs)/learn.tsx | ❌ (use 05) |
| 02 | 92df967f... | Video | /(tabs)/videos | app/(tabs)/videos.tsx | ✅ |
| 03 | 8c3dd242... | AI Tutor | /(tabs)/ai-tutor | app/(tabs)/ai-tutor.tsx | ✅ |
| 04 | 831e9c8a... | Learn shader BG | /(tabs)/learn | app/(tabs)/learn.tsx | Shader only |
| 05 | 9c1cf71c... | Home/Learn (final) | /(tabs)/learn | app/(tabs)/learn.tsx | ✅ DEFINITIVE |
| 06 | c3eec56f... | AI Tutor shader BG | /(tabs)/ai-tutor | app/(tabs)/ai-tutor.tsx | Shader only |
| 07 | dcad7c10... | Profile | /(tabs)/profile | app/(tabs)/profile.tsx | ✅ |
| 08 | dff33d10... | AI Tutor (base) | /(tabs)/ai-tutor | app/(tabs)/ai-tutor.tsx | ❌ (use 03) |
| 09 | efc80a0a... | Learn (fallback) | /(tabs)/learn | app/(tabs)/learn.tsx | ❌ (encoding issues) |
| 10 | a597051b... | Review | /(tabs)/review | app/(tabs)/review.tsx | ❌ (use 11) |
| 11 | 33ccb869... | Review (final) | /(tabs)/review | app/(tabs)/review.tsx | ✅ DEFINITIVE |

### Definitive References per Screen:
- **Home/Learn** → Screen 05 + Screen 04 (shader)
- **Video** → Screen 02
- **AI Tutor** → Screen 03 + Screen 06 (shader)
- **Profile** → Screen 07
- **Review** → Screen 11
