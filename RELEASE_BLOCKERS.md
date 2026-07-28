# Release Blockers

Status reviewed: 2026-07-29

## P0 — Cannot Release

| # | Issue | Owner action | Status |
|---|---|---|---|
| 1 | Generative AI provider is unavailable in the hosted project | Add `OPENAI_API_KEY` to Supabase secrets, then run authenticated chat and voice smoke tests | `BLOCKED_BY_SECRET` |

## P1 — Important Before Beta

| # | Issue | Owner action | Status |
|---|---|---|---|
| 1 | Published seeded videos have no usable media source | Upload/link real media and run playback/progress QA | `BLOCKED_BY_CONTENT` |
| 2 | Premium video/subscription entitlement has no authoritative backend model | Define and implement entitlement rules before exposing Premium | `BLOCKED_BY_PRODUCT` |
| 3 | Published lessons 2–5 have no exercise content | Author and publish real exercises | `BLOCKED_BY_CONTENT` |
| 4 | Hearts, XP boosts, leagues, and weekly quests lack complete product rules | Define authoritative lifecycle and reward semantics before enabling | `BLOCKED_BY_PRODUCT` |
| 5 | Account-deletion requests have no approved processing runbook | Define retention/support policy and privileged processor ownership | `BLOCKED_BY_OPERATIONS` |
| 6 | Android and iOS have not been validated on real devices | Create EAS builds and execute the native QA matrix | `BLOCKED_BY_DEVICE` |

## P2 — Configuration and Release Polish

| # | Issue | Owner action | Status |
|---|---|---|---|
| 1 | Apple Sign-In is not configured | Add Apple/Supabase/Expo credentials and perform device QA before exposing it | `BLOCKED_BY_ACCOUNT` |
| 2 | Push delivery is not live-tested | Configure provider credentials and test a development build | `BLOCKED_BY_CONFIG` |
| 3 | Analytics/crash reporting has no approved provider | Choose a provider and define consent/privacy handling | `BLOCKED_BY_PRODUCT` |
| 4 | Production app icons remain placeholders | Supply approved production assets | `BLOCKED_BY_ASSET` |
| 5 | Terms and Privacy need final legal review | Obtain owner/legal approval | `BLOCKED_BY_REVIEW` |

## Resolved During Autonomous Completion

- Supabase is linked and migrations are deployed through `20260729070000`.
- Google OAuth, password recovery, protected navigation, and profile provisioning
  are implemented and regression-tested.
- `expo-av` was replaced by the maintained `expo-audio` package.
- Client analytics and diagnostic logging default to silent, non-identifying
  behavior.

## Safe Release Path

1. Resolve the P0 provider secret and run authenticated AI/voice smoke tests.
2. Add real lesson/video content and validate the authoritative progress paths.
3. Complete Android and iOS device QA.
4. Resolve the applicable product/operations decisions above.
5. Produce release builds, validate store metadata, and run final regression QA.
