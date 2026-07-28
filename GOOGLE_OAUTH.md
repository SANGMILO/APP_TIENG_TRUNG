# Google OAuth behavior

Google OAuth is initiated through hosted Supabase Auth. The frontend contains no
Google client secret and does not perform manual identity linking.

## Callback URLs

- Expo Web: `http://localhost:8081/callback`
- Production Web placeholder: `https://YOUR_PRODUCTION_DOMAIN/callback`
- Native development/production builds: `mandarin-master://callback`

Web uses a normal browser redirect. Native uses an Expo browser authentication
session with `skipBrowserRedirect: true` and the application scheme from
`app.json`.

## Profiles

The existing `auth.users` trigger remains the only profile creator. It inserts
the authenticated user ID and email. The current trigger does not copy Google
`full_name` or `avatar_url`, so the frontend does not add or overwrite those
fields. This prevents returning Google users from losing customized profile
values.

## Existing-email and identity behavior

Supabase and the configured provider decide whether a verified Google identity
is associated with an existing user or represented as another identity/user.
The application accepts the session returned by Supabase and loads the profile
for that session's user ID.

The application does not automatically delete, merge, or relink users:

- If Supabase returns an existing Google identity, its existing profile is used.
- If Supabase associates Google with an existing email/password user, that
  Supabase user and profile are used.
- If Supabase creates a separate provider identity/user, it receives the normal
  trigger-created profile and starts onboarding.

Any manual account merge or identity-linking policy must be designed and
approved as a separate backend/security phase.
