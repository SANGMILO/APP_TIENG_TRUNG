-- Maintainable curriculum metadata and relationship support.
-- Additive only: existing content and every user-progress row are preserved.

BEGIN;

ALTER TABLE public.courses
  ADD COLUMN IF NOT EXISTS slug TEXT,
  ADD COLUMN IF NOT EXISTS title_zh TEXT,
  ADD COLUMN IF NOT EXISTS learning_objectives JSONB NOT NULL DEFAULT '[]'::JSONB,
  ADD COLUMN IF NOT EXISTS estimated_minutes INTEGER,
  ADD COLUMN IF NOT EXISTS content_version INTEGER NOT NULL DEFAULT 1;

ALTER TABLE public.units
  ADD COLUMN IF NOT EXISTS slug TEXT,
  ADD COLUMN IF NOT EXISTS learning_objectives JSONB NOT NULL DEFAULT '[]'::JSONB,
  ADD COLUMN IF NOT EXISTS content_version INTEGER NOT NULL DEFAULT 1;

ALTER TABLE public.chapters
  ADD COLUMN IF NOT EXISTS slug TEXT,
  ADD COLUMN IF NOT EXISTS learning_objectives JSONB NOT NULL DEFAULT '[]'::JSONB,
  ADD COLUMN IF NOT EXISTS content_version INTEGER NOT NULL DEFAULT 1;

ALTER TABLE public.lessons
  ADD COLUMN IF NOT EXISTS slug TEXT,
  ADD COLUMN IF NOT EXISTS learning_objectives JSONB NOT NULL DEFAULT '[]'::JSONB,
  ADD COLUMN IF NOT EXISTS cultural_note TEXT,
  ADD COLUMN IF NOT EXISTS content_version INTEGER NOT NULL DEFAULT 1;

ALTER TABLE public.vocabulary
  ADD COLUMN IF NOT EXISTS content_key TEXT,
  ADD COLUMN IF NOT EXISTS part_of_speech TEXT,
  ADD COLUMN IF NOT EXISTS first_introduced_lesson_id UUID
    REFERENCES public.lessons(id) ON DELETE SET NULL,
  ADD COLUMN IF NOT EXISTS source_note TEXT,
  ADD COLUMN IF NOT EXISTS content_version INTEGER NOT NULL DEFAULT 1;

ALTER TABLE public.lesson_vocabulary
  ADD COLUMN IF NOT EXISTS curriculum_role TEXT NOT NULL DEFAULT 'introduced';

ALTER TABLE public.lesson_vocabulary
  DROP CONSTRAINT IF EXISTS lesson_vocabulary_curriculum_role_check;
ALTER TABLE public.lesson_vocabulary
  ADD CONSTRAINT lesson_vocabulary_curriculum_role_check
  CHECK (curriculum_role IN ('introduced', 'review'));

ALTER TABLE public.grammar_lessons
  ADD COLUMN IF NOT EXISTS content_key TEXT,
  ADD COLUMN IF NOT EXISTS usage_note TEXT,
  ADD COLUMN IF NOT EXISTS content_version INTEGER NOT NULL DEFAULT 1;

ALTER TABLE public.characters
  ADD COLUMN IF NOT EXISTS component_breakdown JSONB,
  ADD COLUMN IF NOT EXISTS common_words JSONB NOT NULL DEFAULT '[]'::JSONB,
  ADD COLUMN IF NOT EXISTS content_version INTEGER NOT NULL DEFAULT 1;

CREATE UNIQUE INDEX IF NOT EXISTS courses_slug_unique
  ON public.courses(slug)
  WHERE slug IS NOT NULL;

CREATE UNIQUE INDEX IF NOT EXISTS units_course_slug_unique
  ON public.units(course_id, slug)
  WHERE slug IS NOT NULL;

CREATE UNIQUE INDEX IF NOT EXISTS chapters_unit_slug_unique
  ON public.chapters(unit_id, slug)
  WHERE slug IS NOT NULL;

CREATE UNIQUE INDEX IF NOT EXISTS lessons_chapter_slug_unique
  ON public.lessons(chapter_id, slug)
  WHERE slug IS NOT NULL;

CREATE UNIQUE INDEX IF NOT EXISTS vocabulary_content_key_unique
  ON public.vocabulary(content_key)
  WHERE content_key IS NOT NULL;

CREATE UNIQUE INDEX IF NOT EXISTS grammar_lessons_content_key_unique
  ON public.grammar_lessons(content_key)
  WHERE content_key IS NOT NULL;

CREATE UNIQUE INDEX IF NOT EXISTS exercises_lesson_order_unique
  ON public.exercises(lesson_id, order_index);

CREATE UNIQUE INDEX IF NOT EXISTS exercise_options_exercise_order_unique
  ON public.exercise_options(exercise_id, order_index);

CREATE TABLE IF NOT EXISTS public.lesson_grammar (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  lesson_id UUID NOT NULL REFERENCES public.lessons(id) ON DELETE CASCADE,
  grammar_lesson_id UUID NOT NULL
    REFERENCES public.grammar_lessons(id) ON DELETE CASCADE,
  order_index INTEGER NOT NULL DEFAULT 0,
  curriculum_role TEXT NOT NULL DEFAULT 'introduced'
    CHECK (curriculum_role IN ('introduced', 'review')),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE (lesson_id, grammar_lesson_id)
);

CREATE TABLE IF NOT EXISTS public.lesson_characters (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  lesson_id UUID NOT NULL REFERENCES public.lessons(id) ON DELETE CASCADE,
  character_id UUID NOT NULL REFERENCES public.characters(id) ON DELETE CASCADE,
  order_index INTEGER NOT NULL DEFAULT 0,
  curriculum_role TEXT NOT NULL DEFAULT 'introduced'
    CHECK (curriculum_role IN ('introduced', 'review')),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE (lesson_id, character_id)
);

CREATE TABLE IF NOT EXISTS public.vocabulary_prerequisites (
  vocabulary_id UUID NOT NULL
    REFERENCES public.vocabulary(id) ON DELETE CASCADE,
  prerequisite_vocabulary_id UUID NOT NULL
    REFERENCES public.vocabulary(id) ON DELETE CASCADE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  PRIMARY KEY (vocabulary_id, prerequisite_vocabulary_id),
  CHECK (vocabulary_id <> prerequisite_vocabulary_id)
);

CREATE TABLE IF NOT EXISTS public.content_batches (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  batch_key TEXT NOT NULL,
  version INTEGER NOT NULL CHECK (version > 0),
  migration_name TEXT NOT NULL,
  manifest_checksum TEXT NOT NULL,
  expected_counts JSONB NOT NULL DEFAULT '{}'::JSONB,
  applied_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE (batch_key, version),
  UNIQUE (migration_name)
);

CREATE INDEX IF NOT EXISTS lesson_grammar_lesson_order
  ON public.lesson_grammar(lesson_id, order_index);
CREATE INDEX IF NOT EXISTS lesson_characters_lesson_order
  ON public.lesson_characters(lesson_id, order_index);
CREATE INDEX IF NOT EXISTS vocabulary_first_lesson
  ON public.vocabulary(first_introduced_lesson_id)
  WHERE first_introduced_lesson_id IS NOT NULL;

-- Add metadata to the existing validated foundation rows without changing any
-- title, description, order, status, reward, vocabulary text, or example.
UPDATE public.courses
SET
  slug = COALESCE(slug, 'chinese-from-zero'),
  title_zh = COALESCE(title_zh, '零基础中文'),
  learning_objectives = CASE
    WHEN learning_objectives = '[]'::JSONB THEN
      '["Đọc pinyin và thanh điệu cơ bản","Chào hỏi và tự giới thiệu","Dùng số trong tình huống hằng ngày"]'::JSONB
    ELSE learning_objectives
  END,
  estimated_minutes = COALESCE(estimated_minutes, 40)
WHERE id = 'c0000000-0000-0000-0000-000000000001';

UPDATE public.units
SET
  slug = COALESCE(slug, 'nhap-mon-tieng-trung'),
  learning_objectives = CASE
    WHEN learning_objectives = '[]'::JSONB THEN
      '["Làm quen âm thanh tiếng Phổ thông","Thực hiện hội thoại mở đầu ngắn"]'::JSONB
    ELSE learning_objectives
  END
WHERE id = 'a0000001-0000-0000-0000-000000000001';

UPDATE public.chapters
SET
  slug = COALESCE(slug, 'chao-hoi'),
  learning_objectives = CASE
    WHEN learning_objectives = '[]'::JSONB THEN
      '["Chào hỏi lịch sự","Nói tên và thông tin cơ bản"]'::JSONB
    ELSE learning_objectives
  END
WHERE id = 'c0000002-0000-0000-0000-000000000001';

UPDATE public.lessons AS lesson
SET slug = metadata.slug
FROM (
  VALUES
    ('10000000-0000-0000-0000-000000000001'::UUID, 'xin-chao'),
    ('10000000-0000-0000-0000-000000000002'::UUID, 'toi-ten-la'),
    ('10000000-0000-0000-0000-000000000003'::UUID, 'so-dem-1-10'),
    ('10000000-0000-0000-0000-000000000004'::UUID, 'bon-thanh-dieu'),
    ('10000000-0000-0000-0000-000000000005'::UUID, 'tu-gioi-thieu')
) AS metadata(id, slug)
WHERE lesson.id = metadata.id
  AND lesson.slug IS NULL;

UPDATE public.vocabulary AS vocabulary
SET
  content_key = metadata.content_key,
  part_of_speech = metadata.part_of_speech,
  first_introduced_lesson_id = metadata.lesson_id,
  source_note = COALESCE(vocabulary.source_note, 'Existing production foundation content')
FROM (
  VALUES
    ('f0000000-0000-0000-0000-000000000001'::UUID, 'foundation:你', 'đại từ', '10000000-0000-0000-0000-000000000001'::UUID),
    ('f0000000-0000-0000-0000-000000000002'::UUID, 'foundation:好', 'tính từ', '10000000-0000-0000-0000-000000000001'::UUID),
    ('f0000000-0000-0000-0000-000000000003'::UUID, 'foundation:你好', 'cụm từ', '10000000-0000-0000-0000-000000000001'::UUID),
    ('f0000000-0000-0000-0000-000000000004'::UUID, 'foundation:我', 'đại từ', '10000000-0000-0000-0000-000000000002'::UUID),
    ('f0000000-0000-0000-0000-000000000005'::UUID, 'foundation:叫', 'động từ', '10000000-0000-0000-0000-000000000002'::UUID),
    ('f0000000-0000-0000-0000-000000000006'::UUID, 'foundation:是', 'động từ', '10000000-0000-0000-0000-000000000002'::UUID),
    ('f0000000-0000-0000-0000-000000000007'::UUID, 'foundation:什么', 'đại từ nghi vấn', '10000000-0000-0000-0000-000000000002'::UUID),
    ('f0000000-0000-0000-0000-000000000008'::UUID, 'foundation:名字', 'danh từ', '10000000-0000-0000-0000-000000000002'::UUID),
    ('f0000000-0000-0000-0000-000000000009'::UUID, 'foundation:再见', 'cụm từ', '10000000-0000-0000-0000-000000000001'::UUID),
    ('f0000000-0000-0000-0000-000000000010'::UUID, 'foundation:谢谢', 'động từ', '10000000-0000-0000-0000-000000000001'::UUID),
    ('f0000000-0000-0000-0000-000000000011'::UUID, 'foundation:一', 'số từ', '10000000-0000-0000-0000-000000000003'::UUID),
    ('f0000000-0000-0000-0000-000000000012'::UUID, 'foundation:二', 'số từ', '10000000-0000-0000-0000-000000000003'::UUID),
    ('f0000000-0000-0000-0000-000000000013'::UUID, 'foundation:三', 'số từ', '10000000-0000-0000-0000-000000000003'::UUID),
    ('f0000000-0000-0000-0000-000000000014'::UUID, 'foundation:四', 'số từ', '10000000-0000-0000-0000-000000000003'::UUID),
    ('f0000000-0000-0000-0000-000000000015'::UUID, 'foundation:五', 'số từ', '10000000-0000-0000-0000-000000000003'::UUID),
    ('f0000000-0000-0000-0000-000000000016'::UUID, 'foundation:六', 'số từ', '10000000-0000-0000-0000-000000000003'::UUID),
    ('f0000000-0000-0000-0000-000000000017'::UUID, 'foundation:七', 'số từ', '10000000-0000-0000-0000-000000000003'::UUID),
    ('f0000000-0000-0000-0000-000000000018'::UUID, 'foundation:八', 'số từ', '10000000-0000-0000-0000-000000000003'::UUID),
    ('f0000000-0000-0000-0000-000000000019'::UUID, 'foundation:九', 'số từ', '10000000-0000-0000-0000-000000000003'::UUID),
    ('f0000000-0000-0000-0000-000000000020'::UUID, 'foundation:十', 'số từ', '10000000-0000-0000-0000-000000000003'::UUID)
) AS metadata(id, content_key, part_of_speech, lesson_id)
WHERE vocabulary.id = metadata.id
  AND vocabulary.content_key IS NULL;

ALTER TABLE public.lesson_grammar ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.lesson_characters ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.vocabulary_prerequisites ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.content_batches ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Published lesson grammar readable"
  ON public.lesson_grammar;
CREATE POLICY "Published lesson grammar readable"
  ON public.lesson_grammar FOR SELECT
  USING (
    auth.uid() IS NOT NULL
    AND EXISTS (
      SELECT 1
      FROM public.lessons
      WHERE lessons.id = lesson_grammar.lesson_id
        AND lessons.status = 'published'
    )
  );

DROP POLICY IF EXISTS "Editors manage lesson grammar"
  ON public.lesson_grammar;
CREATE POLICY "Editors manage lesson grammar"
  ON public.lesson_grammar FOR ALL
  USING (public.is_editor_or_above())
  WITH CHECK (public.is_editor_or_above());

DROP POLICY IF EXISTS "Published lesson characters readable"
  ON public.lesson_characters;
CREATE POLICY "Published lesson characters readable"
  ON public.lesson_characters FOR SELECT
  USING (
    auth.uid() IS NOT NULL
    AND EXISTS (
      SELECT 1
      FROM public.lessons
      WHERE lessons.id = lesson_characters.lesson_id
        AND lessons.status = 'published'
    )
  );

DROP POLICY IF EXISTS "Editors manage lesson characters"
  ON public.lesson_characters;
CREATE POLICY "Editors manage lesson characters"
  ON public.lesson_characters FOR ALL
  USING (public.is_editor_or_above())
  WITH CHECK (public.is_editor_or_above());

DROP POLICY IF EXISTS "Published vocabulary prerequisites readable"
  ON public.vocabulary_prerequisites;
CREATE POLICY "Published vocabulary prerequisites readable"
  ON public.vocabulary_prerequisites FOR SELECT
  USING (
    auth.uid() IS NOT NULL
    AND EXISTS (
      SELECT 1
      FROM public.vocabulary
      WHERE vocabulary.id = vocabulary_prerequisites.vocabulary_id
        AND vocabulary.status = 'published'
    )
  );

DROP POLICY IF EXISTS "Editors manage vocabulary prerequisites"
  ON public.vocabulary_prerequisites;
CREATE POLICY "Editors manage vocabulary prerequisites"
  ON public.vocabulary_prerequisites FOR ALL
  USING (public.is_editor_or_above())
  WITH CHECK (public.is_editor_or_above());

DROP POLICY IF EXISTS "Admins read content batches"
  ON public.content_batches;
CREATE POLICY "Admins read content batches"
  ON public.content_batches FOR SELECT
  USING (public.is_admin());

REVOKE ALL ON TABLE
  public.lesson_grammar,
  public.lesson_characters,
  public.vocabulary_prerequisites,
  public.content_batches
FROM anon, authenticated;

GRANT SELECT ON TABLE
  public.lesson_grammar,
  public.lesson_characters,
  public.vocabulary_prerequisites
TO authenticated;

GRANT SELECT ON TABLE public.content_batches TO authenticated;

GRANT ALL ON TABLE
  public.lesson_grammar,
  public.lesson_characters,
  public.vocabulary_prerequisites,
  public.content_batches
TO service_role;

COMMIT;
