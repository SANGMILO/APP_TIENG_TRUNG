# Mandarin Master Autonomous Completion Plan

Run date: 2026-07-29  
Working branch: `feature/AI`  
Start commit: `34581fc`  
Remote: `origin` (`https://github.com/SANGMILO/APP_TIENG_TRUNG.git`)  
Pre-run backup: `origin/backup/pre-full-completion-20260729` at `34581fc`

This file is the execution ledger for the master autonomous completion run. The
existing application remains the functional source of truth and the completed
Stitch migration remains the visual source of truth.

## Safety constraints

- Additive migrations only; never reset, truncate, or destructively test the linked project.
- Never weaken P0-A ownership, reward, role, or profile-column protections.
- Never commit secrets, `.env` files, generated exports, or local tool caches.
- Never create fake production data to conceal missing content.
- Never force-push or merge into `main`.

## Reconciled starting state

| Item | State |
| --- | --- |
| Working tree | Clean at `34581fc` |
| Branch | `feature/AI`, tracking `origin/feature/AI` |
| P0-B auth | Committed and pushed |
| Google OAuth | Committed and pushed |
| Profile provisioning | Committed, pushed, and migration deployed |
| Local/remote migrations | Matched through `20260729000000` |
| Active Edge Functions | `pronunciation-assess` v11; `ai-tutor-chat` v2 |
| TypeScript baseline | 0 errors |
| Jest baseline | 17 suites / 222 tests passed |
| Expo Web baseline | 48 static routes exported |
| Secret hygiene | `.env` and `.env.local` ignored; no secret output captured |
| Generated output | `dist/` ignored |

## Phase ledger

### Phase 0 — Preflight, backup, and state reconciliation

- Status: COMPLETE
- Files created: `AUTONOMOUS_COMPLETION_PLAN.md`
- Migrations: none
- Deployments: pushed backup branch `backup/pre-full-completion-20260729`
- Validation:
  - `npx.cmd tsc --noEmit`: passed
  - `npm.cmd test -- --runInBand`: 17 suites / 222 tests passed
  - `npx.cmd expo export --platform web`: passed, 48 routes
  - `npx.cmd supabase migration list`: local and remote matched
  - `npx.cmd supabase functions list`: passed
- Blockers: none
- Commit: `1ffd2d2` (`chore: establish autonomous completion checkpoint`)

### Phase 1 — Lesson progression, review seeding, attempts, and mistakes

- Status: COMPLETE
- Files:
  - `components/lesson/LessonExperience.tsx`
  - `services/lesson-engine.ts`
  - `__tests__/lesson-engine.test.ts`
  - `__tests__/transactional-lesson-completion.test.ts`
  - `supabase/tests/p0_security_hardening.test.sql`
  - `supabase/tests/transactional_lesson_completion.test.sql`
- Migrations:
  - `20260729010000_transactional_lesson_completion.sql`
- Deployments:
  - Migration `20260729010000` applied to linked Supabase project
  - Remote schema independently dumped and verified; temporary dump removed
- Validation:
  - Local database recreated from all migrations successfully
  - pgTAP: 3 files / 62 assertions passed
  - TypeScript: 0 errors
  - Jest: 18 suites / 235 tests passed
  - Expo Web: 48 routes exported
  - Hosted migration list: local and remote matched through `20260729010000`
- Result:
  - Completion is atomic, caller-owned, published/lock validated, and idempotent
  - XP and perfect bonus are server-derived and awarded once per lesson
  - Raw exercise answers are server-validated and persisted once per submission
  - Incorrect answers aggregate into the real Mistakes model
  - Lesson vocabulary seeds Review without overwriting advanced progress
  - Only the next ordered published lesson is unlocked
  - Client shows saving/failure/retry and displays success only after confirmation
- Blockers:
  - P1 content: published lessons 2–5 currently have no exercise content; the app
    reports this honestly and does not fabricate lesson data
- Commit: `792967f` (`fix: make lesson progression transactional`)

### Phase 2 — Real video playback and progress

- Status: COMPLETE
- Files:
  - `app/(tabs)/videos.tsx`
  - `app/videos/[id].tsx`
  - `components/video/VideoQuestionOverlay.tsx`
  - `services/video-service.ts`
  - `supabase/functions/_shared/video-playback-authorization.ts`
  - `supabase/functions/video-playback-url/index.ts`
  - `__tests__/authoritative-video-progress.test.ts`
  - `__tests__/video-service.test.ts`
  - `supabase/tests/authoritative_video_progress.test.sql`
- Migrations:
  - `20260729020000_authoritative_video_progress.sql`
- Deployments:
  - Migration `20260729020000` applied to the linked Supabase project
  - Edge Function `video-playback-url` deployed as active version 1 with JWT
    verification enabled
  - Remote schema independently dumped and verified; temporary dump removed
- Validation:
  - Local database recreated from all migrations successfully
  - pgTAP: 4 files / 88 assertions passed
  - TypeScript: 0 errors
  - Jest: 19 suites / 254 tests passed
  - Expo Web: 48 routes exported
  - Hosted migration list: local and remote matched through `20260729020000`
  - Edge Function unauthenticated production smoke: correctly returned HTTP 401
- Result:
  - Replaced simulated playback time with real `expo-video` player events
  - Restores persisted playback position and records bounded, idempotent events
  - Preserves monotonic furthest position and cumulative watch time server-side
  - Scores interactive questions on the server without exposing answer keys
  - Completes videos and awards XP only after server-derived eligibility checks
  - Supports direct media and authenticated private-storage signed URLs
  - Premium media remains blocked until an authoritative entitlement model exists
  - Saved-video action is functional on the detail screen
  - Catalog and continue-watching sections hide entries with no usable source
- Blockers:
  - P1 content/configuration: all currently published seeded videos have no media
    URL or storage object path, so no honest authenticated playback smoke is
    possible until real media is uploaded and linked
  - P1 product/backend: no subscription or entitlement source exists; premium
    videos are intentionally unavailable rather than relying on a client flag
  - Local standalone `deno check` is unavailable because Deno is not installed;
    the Supabase deployment bundler accepted the function
  - Supabase CLI emitted a non-fatal pg-delta temporary certificate cache warning
    after migration apply; migration history and a fresh remote schema dump
    independently confirmed the hosted schema
- Commit: `c4d3c56` (`fix: make video learning authoritative`)

### Phase 3 — Review SRS and mistake practice

- Status: COMPLETE
- Files:
  - `app/(tabs)/review.tsx`
  - `app/review/session.tsx`
  - `app/review/mistakes.tsx`
  - `services/review-service.ts`
  - `services/srs-engine.ts`
  - `__tests__/authoritative-review-srs.test.ts`
  - `__tests__/review-service.test.ts`
  - `__tests__/srs-engine.test.ts`
  - `supabase/tests/authoritative_review_srs.test.sql`
- Migrations:
  - `20260729030000_authoritative_review_srs.sql`
- Deployments:
  - Migration `20260729030000` applied to the linked Supabase project
  - Remote schema independently dumped and verified; temporary dump removed
- Validation:
  - Local database recreated from all migrations successfully
  - pgTAP: 5 files / 118 assertions passed
  - TypeScript: 0 errors
  - Jest: 21 suites / 264 tests passed
  - Expo Web: 48 routes exported
  - Hosted migration list: local and remote matched through `20260729030000`
- Result:
  - Existing SRS rules now persist bounded interval and explicit card state
  - Existing reviewed cards are backfilled from their real persisted due dates
  - Ratings are caller-owned, due-validated, atomic, and idempotent on retry
  - Direct client mutation of vocabulary progress is revoked
  - Review load/update failures are visible and retryable
  - Review statistics use persisted state rather than inferred memory thresholds
  - Mistakes now provide real typed-answer practice with server-side checking
  - Incorrect practice remains unresolved; a correct answer marks the mistake
    reviewed, and every practice submission is auditable/idempotent
- Blockers:
  - Supabase CLI emitted the same non-fatal pg-delta temporary certificate cache
    warning after migration apply; matching migration history and a fresh remote
    schema dump independently confirmed the hosted schema
- Commit: pending

### Phase 4 — Auth and OAuth finishing

- Status: PENDING
- Files: pending
- Migrations: pending
- Deployments: pending
- Validation: pending
- Blockers: Apple configuration and legal content to be verified
- Commit: pending

### Phase 5 — Profile, levels, achievements, account, and privacy

- Status: PENDING
- Files: pending
- Migrations: pending
- Deployments: pending
- Validation: pending
- Blockers: pending audit
- Commit: pending

### Phase 6 — AI Tutor and voice reliability

- Status: PENDING
- Files: pending
- Migrations: pending
- Deployments: pending
- Validation: pending
- Blockers: provider configuration to be verified without exposing secrets
- Commit: pending

### Phase 7 — Pronunciation quick practice

- Status: PENDING
- Files: pending
- Migrations: pending
- Deployments: pending
- Validation: pending
- Blockers: pending audit
- Commit: pending

### Phase 8 — Gamification population

- Status: PENDING
- Files: pending
- Migrations: pending
- Deployments: pending
- Validation: pending
- Blockers: product-rule gaps to be documented where applicable
- Commit: pending

### Phase 9 — Dead interactions, route reachability, and analytics

- Status: PENDING
- Files: pending
- Migrations: none expected
- Deployments: none expected
- Validation: pending
- Blockers: pending audit
- Commit: pending

### Phase 10 — Dependency, Expo, security, and quality audit

- Status: PENDING
- Files: pending
- Migrations: pending audit
- Deployments: pending
- Validation: pending
- Blockers: pending audit
- Commit: pending

### Phase 11 — Hosted deployment and database testing

- Status: PENDING
- Files: pending
- Migrations: pending
- Deployments: pending
- Validation: pending
- Blockers: local Docker availability to be verified
- Commit: pending

### Phase 12 — Full product QA

- Status: PENDING
- Files: pending
- Migrations: none expected
- Deployments: none expected
- Validation: pending
- Blockers: native-device and provider-interactive QA may require owner accounts/devices
- Commit: pending

### Finalization

- Status: PENDING
- Deliverable: `FULL_AUTONOMOUS_COMPLETION_REPORT.md`
- Final validation: pending
- Working tree clean: pending
- Branch pushed: pending
- Merge to `main`: explicitly excluded
