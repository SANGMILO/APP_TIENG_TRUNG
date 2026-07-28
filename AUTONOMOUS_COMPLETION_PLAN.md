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
- Commit: `6a89ba6` (`fix: persist SRS review state`)

### Phase 4 — Auth and OAuth finishing

- Status: COMPLETE
- Files:
  - `app/(auth)/login.tsx`
  - `app/(auth)/register.tsx`
  - `app/onboarding/index.tsx`
  - `app/terms.tsx`
  - `app/_layout.tsx`
  - `services/auth-navigation.ts`
  - `stores/auth-store.ts`
  - `__tests__/auth-finishing.test.ts`
- Migrations: none
- Deployments: none
- Validation:
  - Focused auth/OAuth/recovery: 4 suites / 57 tests passed
  - TypeScript: 0 errors
  - Jest: 22 suites / 269 tests passed
  - Expo Web: 49 routes exported, including public `/terms`
- Result:
  - Existing email/password, recovery, Google PKCE, first-time onboarding,
    returning-user routing, logout, and protected-route behavior remain intact
  - Auth initialization is single-flight and replaces the prior subscription
    before registering another listener
  - Session persistence remains always enabled with localStorage on Web and
    SecureStore on native; the non-functional Remember Me checkbox was removed
  - Unconfigured Apple buttons were hidden rather than presenting a dead action
  - Terms and Privacy are independent public links and no longer toggle consent
  - Added a real Terms route and retryable onboarding persistence error state
- Blockers:
  - P1 external configuration: Apple Sign-In requires an Apple Developer
    account, Sign in with Apple capability/Services ID, key/team identifiers,
    Supabase Apple provider secret, Expo dependency/configuration, and real EAS
    submission values; the current `eas.json` values are placeholders
  - P1 manual QA: Google provider collision and full browser redirect/relogin
    require interactive owner-controlled provider accounts; automated PKCE,
    replay, routing, recovery, and logout regressions pass
  - P2 legal: the in-app Terms content should receive owner/legal review before
    public release
- Commit: `d2e3f64` (`fix: finish auth and legal flows`)

### Phase 5 — Profile, levels, achievements, account, and privacy

- Status: COMPLETE
- Files:
  - `app/(tabs)/profile.tsx`
  - `app/account.tsx`
  - `app/notification-settings.tsx`
  - `app/delete-account.tsx`
  - `app/privacy.tsx`
  - `app/gamification/achievements.tsx`
  - `app/_layout.tsx`
  - `services/account-service.ts`
  - `services/gamification-service.ts`
  - `__tests__/account-deletion-migration.test.ts`
  - `__tests__/profile-account.test.ts`
  - `supabase/tests/account_deletion_requests.test.sql`
- Migrations:
  - `20260729040000_account_deletion_requests.sql`
- Deployments:
  - Migration `20260729040000` applied to the linked Supabase project
  - Remote schema independently dumped and verified; temporary dump removed
- Validation:
  - Local database recreated from all migrations successfully
  - pgTAP: 6 files / 132 assertions passed
  - TypeScript: 0 errors
  - Jest: 24 suites / 279 tests passed
  - Expo Web: 51 routes exported
  - Hosted migration list: local and remote matched through `20260729040000`
- Result:
  - Profile achievements now come from real achievement/unlock rows with earned
    dates and honest loading, empty, and retryable error states
  - Level progress now uses exact `level_thresholds` boundaries and handles the
    maximum level without modulo rollover
  - Account editing, Achievements, Notifications, and Privacy destinations work
  - Notification preferences persist to the existing caller-owned backend model
  - Premium management is hidden because no entitlement/subscription model exists
  - Decorative Profile stats/achievement badges no longer imply dead actions
  - Account deletion now creates one caller-owned, confirmation-gated, auditable
    request and reloads its real status; failures never report success
  - Privacy accurately describes queued deletion and links to the request flow
- Blockers:
  - P1 operations/product: queued deletion requests require an owner-approved
    retention window, cancellation/support policy, processor ownership, and a
    privileged service-role deletion runbook or protected Edge Function before
    requests can be completed; no production user/request was used for QA
  - P1 product/backend: no premium entitlement or subscription source exists, so
    Premium management remains hidden
  - P1 delivery configuration: notification preferences are functional, but
    actual push delivery still requires device token registration and provider
    credentials/configuration
  - Supabase CLI emitted the same non-fatal pg-delta temporary certificate cache
    warning after migration apply; matching history and a fresh remote schema
    dump independently confirmed the hosted schema
- Commit: `1e109a9` (`fix: complete profile and account workflows`)

### Phase 6 — AI Tutor and voice reliability

- Status: COMPLETE
- Files:
  - `app/(tabs)/ai-tutor.tsx`
  - `app/ai-chat.tsx`
  - `app/ai-tutor/voice.tsx`
  - `services/ai-context-builder.ts`
  - `services/ai-tutor-service.ts`
  - `services/voice-conversation-service.ts`
  - `supabase/functions/_shared/tutor-response.ts`
  - `supabase/functions/ai-tutor-chat/index.ts`
  - `supabase/functions/voice-transcribe/index.ts`
  - `supabase/functions/voice-synthesize/index.ts`
  - `__tests__/ai-tutor.test.ts`
  - `__tests__/ai-tutor-service.test.ts`
  - `__tests__/voice-conversation.test.ts`
  - `__tests__/p0-security-hardening.test.ts`
  - `supabase/tests/authoritative_ai_voice.test.sql`
- Migrations:
  - `20260729050000_authoritative_ai_voice.sql`
- Deployments:
  - Migration `20260729050000` applied to the linked Supabase project
  - `ai-tutor-chat` deployed as active version 4 with JWT verification
  - `voice-transcribe` deployed as active version 1 with JWT verification
  - `voice-synthesize` deployed as active version 1 with JWT verification
  - Remote schema independently dumped and verified; temporary dump removed
- Validation:
  - Local database recreated from all migrations successfully
  - pgTAP: 7 files / 162 assertions passed
  - Focused AI/voice Jest: 3 suites / 33 tests passed
  - TypeScript: 0 errors
  - Jest: 25 suites / 285 tests passed
  - Expo Web: 51 routes exported
  - Hosted migration list: local and remote matched through `20260729050000`
- Result:
  - AI messages are transactionally reserved against the database-owned daily
    setting and retries can return only the assistant linked to that exact input
  - Failed sends preserve the draft, show per-message failure, and retry with the
    same stable idempotency key; initialization failures are retryable
  - Untrusted model JSON is bounded, normalized, and schema-validated on both
    server and client before reaching render code
  - AI usage display and enforcement share authoritative database counts/settings
  - Fictional per-scenario XP promises were removed
  - Voice turns are persisted by authenticated server functions; direct client
    writes were revoked, every persistence failure is surfaced, and retries reuse
    the same server turn and AI message
  - Voice completion derives duration, turns, vocabulary, corrections, and XP
    from persisted completed turns and remains idempotent
  - Provider capability is checked dynamically; unavailable chat/voice actions
    are disabled instead of creating empty conversations or failing after capture
- Blockers:
  - P0 external configuration: the hosted project has no generative AI provider
    key configured. No secret was invented or copied. The deployed capability
    endpoint therefore disables AI chat and voice honestly until an owner adds
    `OPENAI_API_KEY` (and optionally the model variables) in Supabase secrets.
  - Voice STT/TTS currently use that same provider and cannot be exercised
    end-to-end without it; the deployed functions safely return not-configured
    rather than reporting false success
  - Interactive microphone/provider QA requires a real authenticated session,
    microphone permission, and the missing provider configuration
  - Supabase CLI emitted the same non-fatal pg-delta temporary certificate cache
    warning after migration apply; matching migration history and a fresh remote
    schema dump independently confirmed the hosted schema
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
