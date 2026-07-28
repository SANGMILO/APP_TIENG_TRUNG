# Owner Action Required

Status reviewed: 2026-07-29

The repository, linked Supabase project, and active Edge Functions already exist.
Do not create a replacement project or rerun historical seed data against the
hosted database.

## 1. Configure the Missing AI Provider Secret

Required for AI Tutor chat, voice transcription, and voice synthesis:

1. Create an OpenAI API key in the owner-controlled OpenAI project.
2. Add `OPENAI_API_KEY` in Supabase Dashboard → Project Settings → Edge
   Functions → Secrets. Do not paste the key into this repository or chat.
3. Optionally configure `OPENAI_MODEL`, `OPENAI_STT_MODEL`,
   `OPENAI_TTS_MODEL`, and `OPENAI_TTS_VOICE`; the code has safe defaults.
4. Confirm the project has a spending limit and billing alerts.
5. With a non-production test account, run:
   - one AI chat response;
   - one voice transcription;
   - one voice synthesis;
   - one retry after a simulated network interruption.

Until the secret exists, these actions remain disabled through the deployed
capability check and do not report false success.

## 2. Supply Real Learning Content

Content work is required before beta:

- Add real exercises to published lessons 2–5.
- Upload or link real media for published videos.
- Keep video storage objects private and use the existing signed playback path.
- Do not substitute demo rows or invented media URLs.
- Validate one complete lesson and one complete video with a test account after
  publishing.

The one-click placeholder creation controls were intentionally removed. Use an
approved admin/content workflow or reviewed SQL/import tooling for production
content.

## 3. Make Product and Operations Decisions

The following features remain hidden or inactive until their rules are defined:

- premium subscription and video entitlement;
- hearts loss/recovery;
- XP boost consumption and multipliers;
- league promotion/demotion;
- weekly quest completion;
- queued account-deletion retention, cancellation, and processing ownership.

Document the rules before asking engineering to expose these features. Account
deletion processing must use a privileged server-side runbook or protected Edge
Function; never place a service-role key in the app.

## 4. Configure Native Release Accounts

1. Replace placeholder EAS project/submission values with owner-controlled
   credentials.
2. Create Android and iOS preview builds.
3. Test microphone permissions, audio recording/playback, OAuth callbacks,
   SecureStore session persistence, deep links, and push-token registration on
   physical devices.
4. Configure Apple Sign-In only after the Apple capability, Services ID,
   key/team identifiers, and Supabase provider are ready. Keep the button hidden
   until the end-to-end test passes.

## 5. Finish Delivery and Compliance

- Configure and test the push delivery provider.
- Choose analytics/crash reporting only after approving consent and privacy
  handling.
- Supply final app icons and store assets.
- Obtain legal review for Terms and Privacy.
- Validate store Data Safety/App Privacy disclosures, including account
  deletion and AI/voice data handling.

## Secret Safety

- `.env`, `.env.local`, and `.env.production` are ignored.
- Only public Supabase URL/publishable values belong in the client environment.
- Provider and service-role secrets belong only in Supabase-managed secrets.
- Never include tokens, passwords, authorization codes, or private keys in
  commits, logs, screenshots, issue text, or the completion report.
