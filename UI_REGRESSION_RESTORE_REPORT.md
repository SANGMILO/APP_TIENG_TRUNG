# UI Regression Restoration Report

Design baseline: `origin/backup/pre-full-completion-20260729`.
Functional baseline: current `fix/restore-original-ui` branch.

The regressions came from an overly broad interpretation of “remove placeholder
functionality”: unavailable entry points were removed instead of retained in an
honest disabled state, and a real-data conversion collapsed one Profile grid
instead of preserving its approved structure.

| Screen | Original structure | Current structure before restoration | Unwanted change | Restoration performed | Real data retained | Remaining external blocker |
| --- | --- | --- | --- | --- | --- | --- |
| Welcome | Branded hero and Login/Register entry points | Same approved composition with safer navigation | None requiring restoration | Kept current file | Auth route state | None |
| Login | Branded header, rounded inputs, recovery, Google and Apple rows, remembered-session presentation | Google and recovery worked; Apple and remembered-session presentation were removed | Missing Apple entry and altered options row | Restored remembered-session visual and Apple row; Apple is disabled and labeled `Sắp có` | Password auth, persistent SecureStore session, Google OAuth PKCE, profile provisioning and errors | Apple provider credentials/configuration |
| Register | Branded form, legal consent, Google and Apple actions | Legal links and Google worked; Apple was removed | Missing Apple entry | Restored Apple in the original social area as disabled with `Sắp có` | Registration, Google OAuth, legal destinations, validation and provisioning | Apple provider credentials/configuration |
| Forgot Password / Reset Password | Dedicated recovery forms | Functional recovery implementation retained | No visual regression found | No code change | Supabase recovery session and reset flow | Email delivery/provider configuration must remain healthy |
| Learn | Greeting, bento hero, goal card and lesson journey | Approved layout plus authoritative progression/error handling | No design rollback needed; current hierarchy fix is required for all published chapters | Kept current layout and complete published hierarchy query | Courses, lesson status, transactional completion, XP and gamification summary | Additional review courses remain intentionally unpublished |
| Review | Dashboard cards, review actions and pronunciation entry | Approved layout plus persisted SRS/error handling | No unwanted visual simplification found | Kept current file | Authoritative SRS queue, mistakes and persisted review submissions | None |
| AI Tutor | Hero, usage counter, scenarios, recent activity and chat entry | Scenarios remained, but missing provider configuration used a large unavailable component | Configuration state visually dominated the page | Replaced it with a compact warning; only provider-dependent actions are disabled | Conversation ownership, limits, retry/error behavior, Edge Function capabilities | Supabase secret `OPENAI_API_KEY` |
| Video | Search, filters, sections/cards and player navigation | Approved structure plus real thumbnails, progress and retryable empty/error states | No unwanted visual regression found | Kept current files | Hosted video rows, playback authorization and progress | No additional licensed hosted videos |
| Profile | Profile card, 2×2 stats, level, achievements, settings and logout | Real achievements/levels/actions were added, but the stats grid collapsed and Premium disappeared | Loss of approved grid density and Premium entry | Restored four real stat cards, robust name/avatar fallback, and disabled Premium row | Profiles, OAuth metadata, vocabulary progress, XP, streak, coins, thresholds and achievements | Premium product/route decision |
| Achievements | Achievement list and progress presentation | Converted from placeholders to authoritative gamification data | No unwanted design removal found | Kept current implementation | Achievements and user achievements | None |
| Settings / account actions | Account, notifications, privacy, theme and logout | Real routes were added; dead actions removed | Premium was over-removed | Restored Premium as clearly disabled; retained all working destinations | Profile updates, notification preferences, privacy and logout | Premium product configuration |
| PremiumTabBar | Floating five-tab navigation with labels, active treatment and safe-area inset | No diff from approved backup | None | No code change | Route-safe tab navigation and shared content inset | None |

## Responsive and interaction QA

- Live browser QA: Login and Register at `390 × 844`; no horizontal overflow,
  Apple is present, Google remains actionable, and recovery/legal actions remain
  reachable.
- Static responsive audit: `430 × 932`, `768px`, and desktop constraints use the
  approved max-width containers and unchanged PremiumTabBar safe-area inset.
- Protected screens: source/design comparison plus interaction-reachability,
  route-safety, TypeScript, Jest, and static-render validation. Hosted test-user
  credentials were not used or requested.
- Every rendered pressable now has an action or an explicit disabled state.
- No database migration, Edge Function, course-content, hosted data, or security
  policy was changed during this restoration.

## Validation

- TypeScript: 0 errors
- Jest: 31 suites, 303 tests passing
- Expo Web: 51 static routes exported
- Expo Doctor: 20/20 checks passing
