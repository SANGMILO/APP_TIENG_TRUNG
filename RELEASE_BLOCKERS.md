# Release Blockers

## P0 — Cannot Release (Security/Data Loss)

| # | Issue | Owner Action | Status |
|---|-------|--------------|--------|
| — | None identified in code | — | ✅ Clear |

## P1 — Core Feature Non-functional

| # | Issue | Owner Action | Status |
|---|-------|--------------|--------|
| 1 | Supabase not deployed | Create project + db push | BLOCKED_BY_ACCOUNT |
| 2 | OpenAI not connected | Set OPENAI_API_KEY secret | BLOCKED_BY_SECRET |
| 3 | Azure not connected | Set AZURE_SPEECH_KEY secret | BLOCKED_BY_SECRET |
| 4 | No Android device test | EAS build + real device | BLOCKED_BY_DEVICE |
| 5 | No iOS device test | Apple Dev + EAS build | BLOCKED_BY_ACCOUNT |

## P2 — Important but Deferrable

| # | Issue | Status |
|---|-------|--------|
| 1 | Push notifications not live tested | Requires dev build |
| 2 | Google/Apple OAuth not configured | Requires provider setup |
| 3 | Video storage bucket not configured | Requires Supabase Storage |
| 4 | Production app icons placeholder | Requires design assets |
| 5 | Error monitoring not connected | Requires Sentry/equivalent |

## P3 — Nice to Have Before Launch

| # | Issue | Status |
|---|-------|--------|
| 1 | expo-av deprecation warning | Migrate to expo-audio future |
| 2 | Analytics provider production | Replace dev console logger |
| 3 | Legal review of Privacy Policy | Requires lawyer |
| 4 | Terms of Service final text | Requires lawyer |
| 5 | Content: more vocabulary/lessons | Requires content team |

---

## Resolution Path

Once P1 items are resolved (all require owner credentials/accounts):
1. Run E2E test on real Supabase
2. Live test AI/Voice/Pronunciation
3. Android device QA
4. iOS device QA
5. Push notification verification
6. Production web deployment
7. Internal test track (Play/TestFlight)
8. Final QA on store build
9. Public release
