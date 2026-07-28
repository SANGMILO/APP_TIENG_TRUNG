BEGIN;

SELECT plan(22);

SELECT has_column('public', 'courses', 'slug', 'courses have stable slugs');
SELECT has_column('public', 'courses', 'title_zh', 'courses support Chinese titles');
SELECT has_column(
  'public',
  'courses',
  'learning_objectives',
  'courses support structured learning objectives'
);
SELECT has_column(
  'public',
  'courses',
  'estimated_minutes',
  'courses support estimated duration'
);
SELECT has_column('public', 'lessons', 'slug', 'lessons have stable slugs');
SELECT has_column(
  'public',
  'lessons',
  'cultural_note',
  'lessons support cultural and usage notes'
);
SELECT has_column(
  'public',
  'vocabulary',
  'part_of_speech',
  'vocabulary supports part-of-speech metadata'
);
SELECT has_column(
  'public',
  'vocabulary',
  'first_introduced_lesson_id',
  'vocabulary tracks first introduction'
);
SELECT has_column(
  'public',
  'lesson_vocabulary',
  'curriculum_role',
  'lesson vocabulary distinguishes introduction and review'
);
SELECT has_table('public', 'lesson_grammar', 'lesson-to-grammar mapping exists');
SELECT has_table('public', 'lesson_characters', 'lesson-to-character mapping exists');
SELECT has_table(
  'public',
  'vocabulary_prerequisites',
  'vocabulary prerequisites are relational'
);
SELECT has_table('public', 'content_batches', 'content batch registry exists');

SELECT ok(
  (
    SELECT relrowsecurity
    FROM pg_class
    WHERE oid = 'public.lesson_grammar'::REGCLASS
  ),
  'lesson grammar mapping has RLS enabled'
);

SELECT ok(
  (
    SELECT relrowsecurity
    FROM pg_class
    WHERE oid = 'public.lesson_characters'::REGCLASS
  ),
  'lesson character mapping has RLS enabled'
);

SELECT ok(
  (
    SELECT relrowsecurity
    FROM pg_class
    WHERE oid = 'public.content_batches'::REGCLASS
  ),
  'content batch registry has RLS enabled'
);

SELECT ok(
  has_table_privilege('authenticated', 'public.lesson_grammar', 'SELECT')
  AND NOT has_table_privilege('authenticated', 'public.lesson_grammar', 'INSERT')
  AND NOT has_table_privilege('authenticated', 'public.lesson_grammar', 'UPDATE')
  AND NOT has_table_privilege('authenticated', 'public.lesson_grammar', 'DELETE'),
  'authenticated clients can only read permitted lesson grammar links'
);

SELECT ok(
  has_table_privilege('authenticated', 'public.lesson_characters', 'SELECT')
  AND NOT has_table_privilege('authenticated', 'public.lesson_characters', 'INSERT')
  AND NOT has_table_privilege('authenticated', 'public.lesson_characters', 'UPDATE')
  AND NOT has_table_privilege('authenticated', 'public.lesson_characters', 'DELETE'),
  'authenticated clients can only read permitted lesson character links'
);

SELECT ok(
  has_table_privilege('authenticated', 'public.content_batches', 'SELECT')
  AND NOT has_table_privilege('authenticated', 'public.content_batches', 'INSERT')
  AND NOT has_table_privilege('authenticated', 'public.content_batches', 'UPDATE')
  AND NOT has_table_privilege('authenticated', 'public.content_batches', 'DELETE'),
  'content batch metadata cannot be forged by clients'
);

SELECT is(
  (
    SELECT slug
    FROM public.courses
    WHERE id = 'c0000000-0000-0000-0000-000000000001'
  ),
  'chinese-from-zero',
  'existing foundation course receives stable metadata without replacement'
);

SELECT is(
  (
    SELECT COUNT(*)::INTEGER
    FROM public.vocabulary
    WHERE content_key LIKE 'foundation:%'
      AND id::TEXT LIKE 'f0000000-%'
      AND part_of_speech IS NOT NULL
      AND first_introduced_lesson_id IS NOT NULL
  ),
  20,
  'existing foundation vocabulary receives complete curriculum mapping metadata'
);

SELECT has_column(
  'public',
  'characters',
  'common_words',
  'character metadata supports common-word examples without fabricated assets'
);

SELECT * FROM finish();

ROLLBACK;
