# P0-B Auth Recovery Configuration

The application scheme in `app.json` is `mandarin-master`. The password-reset
callback route is `/callback`.

## Hosted Supabase redirect allowlist

Add these exact patterns in **Supabase Dashboard → Authentication → URL
Configuration → Redirect URLs**:

- Local Expo Web: `http://localhost:8081/callback`
- Production Web placeholder: `https://YOUR_PRODUCTION_DOMAIN/callback`
- iOS and Android development/production builds: `mandarin-master://callback`

Replace `YOUR_PRODUCTION_DOMAIN` with the deployed web hostname before release.
If local Expo Web is intentionally started on a different port, add that exact
origin plus `/callback` as a separate redirect URL.

Expo Go uses an `exp://` development URL and cannot be represented by the
installed application's custom scheme reliably. Test the native recovery link
in an iOS/Android development build or production build that registers the
`mandarin-master` scheme.

## Completion boundary

Completed locally in P0-B:

- Platform-specific `redirectTo` generation.
- `/callback` processing for PKCE codes, implicit access/refresh tokens, recovery
  token hashes, and a session explicitly identified by Supabase's
  `PASSWORD_RECOVERY` event.
- `/reset-password` validation and `updateUser({ password })`.
- Web and native route handling for the configured scheme.

Still required in hosted Supabase:

- Add the three redirect URLs above (using the real production hostname).
- Confirm the password-recovery email template redirects through the supplied
  `redirectTo`.
- Exercise one real email link on Web and one development/production native
  build after the allowlist is saved.
