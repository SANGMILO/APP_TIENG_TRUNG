# Curriculum source manifests

The JSON files in `content/manifests/` are the editable source of truth for
Mandarin Master curriculum additions. They map directly to the existing
Course → Unit → Chapter → Lesson hierarchy. Generated SQL is committed as
additive Supabase migrations so hosted deployment remains transactional,
reviewable, and resumable.

Rules:

- IDs are deterministic UUIDs derived from stable content keys.
- Existing validated rows use explicit `existingId` values and are never
  replaced by the generator.
- New content defaults to `review`; publication requires automated validation,
  audio readiness where applicable, and content-owner language review.
- Vocabulary is defined once and referenced by key for later review.
- `reviewVocabularyKeys` creates Review coverage metadata only; it never creates
  user progress.
- Listening requests without real audio belong in
  `CONTENT_AUDIO_MANIFEST.json`, not in published exercises.

Commands:

```text
npm run content:validate
node scripts/content/generate-content-sql.cjs --manifest content/manifests/<file>.json
```

The generator refuses to overwrite an existing migration file unless
`--check` is used to compare the committed output.
