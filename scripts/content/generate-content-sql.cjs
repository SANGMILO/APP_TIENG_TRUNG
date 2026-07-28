#!/usr/bin/env node

const crypto = require('crypto');
const fs = require('fs');
const path = require('path');
const {
  deterministicUuid,
  jsonSql,
  loadManifests,
  normalizePractice,
  quoteSql,
  validateManifests,
} = require('./content-tools.cjs');

const rootDir = path.resolve(__dirname, '..', '..');

function parseArgs(argv) {
  const args = { check: false };
  for (let index = 2; index < argv.length; index += 1) {
    const value = argv[index];
    if (value === '--check') args.check = true;
    else if (value === '--manifest') args.manifest = argv[++index];
    else if (value === '--output') args.output = argv[++index];
    else throw new Error(`Unknown argument: ${value}`);
  }
  if (!args.manifest) throw new Error('--manifest is required');
  return args;
}

function row(lines, table, columns, values, conflict = 'id') {
  lines.push(
    `INSERT INTO public.${table} (${columns.join(', ')})`,
    `VALUES (${values.join(', ')})`,
    `ON CONFLICT (${conflict}) DO NOTHING;`,
    '',
  );
}

function asUuid(value) {
  return `${quoteSql(value)}::UUID`;
}

function idFor(type, key, existingId) {
  return existingId ?? deterministicUuid(`${type}:${key}`);
}

function rotateOptions(options, seed) {
  const offset = Number.parseInt(
    crypto.createHash('sha256').update(seed).digest('hex').slice(0, 4),
    16,
  ) % options.length;
  return [...options.slice(offset), ...options.slice(0, offset)];
}

function makeExerciseRows(lesson, vocabularyByKey) {
  const result = [];
  let order = (lesson.exerciseOrderOffset ?? 0) + 1;
  const push = (key, exercise) => {
    result.push({
      key: `${lesson.course.slug}:${lesson.slug}:${key}`,
      orderIndex: order,
      ...exercise,
    });
    order += 1;
  };

  for (const vocabulary of lesson.vocabulary ?? []) {
    push(`vocab:${vocabulary.key}`, {
      type: 'vocabulary',
      question: `Từ mới: ${vocabulary.chinese}`,
      correctAnswer: vocabulary.chinese,
      explanation: `${vocabulary.chinese} (${vocabulary.pinyin}) — ${vocabulary.meaningVi}. ${vocabulary.exampleSentence}`,
      data: {
        activity_type: 'vocabulary_introduction',
        vocabulary_key: vocabulary.key,
        chinese: vocabulary.chinese,
        pinyin: vocabulary.pinyin,
        meaning: vocabulary.meaningVi,
        part_of_speech: vocabulary.partOfSpeech,
        example_chinese: vocabulary.exampleSentence,
        example_pinyin: vocabulary.examplePinyin,
        example_meaning_vi: vocabulary.exampleMeaningVi,
      },
    });
  }

  const practice = normalizePractice(lesson, vocabularyByKey);
  if (practice.meaningChoice) {
    const target = vocabularyByKey.get(practice.meaningChoice.targetKey);
    const distractors = practice.meaningChoice.distractorKeys.map((key) => vocabularyByKey.get(key));
    const options = rotateOptions(
      [
        { text: target.meaningVi, correct: true },
        ...distractors.map((item) => ({ text: item.meaningVi, correct: false })),
      ],
      `${lesson.slug}:meaning`,
    );
    push('meaning-choice', {
      type: 'multiple_choice',
      question: `“${target.chinese}” có nghĩa phù hợp nhất là gì?`,
      correctAnswer: target.meaningVi,
      explanation: `${target.chinese} (${target.pinyin}) nghĩa là “${target.meaningVi}”.`,
      data: {
        activity_type: 'chinese_to_vietnamese',
        vocabulary_key: target.key,
      },
      options,
    });
  }

  if (practice.translation) {
    push('translation', {
      type: 'translation',
      question: `Dịch sang tiếng Trung: “${practice.translation.promptVi}”`,
      correctAnswer: practice.translation.answerZh,
      explanation: practice.translation.explanationVi,
      hint: practice.translation.hint ?? null,
      data: {
        activity_type: 'vietnamese_to_chinese',
        source_lang: 'vi',
        target_lang: 'zh',
        acceptable_answers: practice.translation.acceptableAnswers
          ?? [practice.translation.answerZh],
      },
    });
  }

  if (practice.sentenceBuilder) {
    push('sentence-builder', {
      type: 'sentence_builder',
      question: practice.sentenceBuilder.question ?? 'Sắp xếp các thành phần thành câu đúng.',
      correctAnswer: practice.sentenceBuilder.answerZh,
      explanation: practice.sentenceBuilder.explanationVi,
      data: {
        activity_type: 'sentence_ordering',
        words: practice.sentenceBuilder.tokens,
        correct_order: practice.sentenceBuilder.correctOrder
          ?? practice.sentenceBuilder.tokens,
      },
    });
  }

  if (practice.grammarChoice) {
    push('grammar-choice', {
      type: 'multiple_choice',
      question: practice.grammarChoice.question,
      correctAnswer: practice.grammarChoice.correctAnswer,
      explanation: practice.grammarChoice.explanationVi,
      data: {
        activity_type: practice.grammarChoice.activityType,
        passage: practice.grammarChoice.passage ?? null,
        grammar_key: practice.grammarChoice.grammarKey ?? null,
      },
      options: practice.grammarChoice.options.map((text) => ({
        text,
        correct: text === practice.grammarChoice.correctAnswer,
      })),
    });
  }

  for (const [index, extra] of (practice.extraChoices ?? []).entries()) {
    push(`extra-choice:${index + 1}`, {
      type: 'multiple_choice',
      question: extra.question,
      correctAnswer: extra.correctAnswer,
      explanation: extra.explanationVi,
      data: {
        activity_type: extra.activityType,
        passage: extra.passage ?? null,
      },
      options: extra.options.map((text) => ({
        text,
        correct: text === extra.correctAnswer,
      })),
    });
  }

  if (practice.listening) {
    push('listening', {
      type: 'listening',
      question: practice.listening.question,
      questionAudioUrl: practice.listening.audioUrl,
      correctAnswer: practice.listening.correctAnswer,
      explanation: practice.listening.explanationVi,
      data: {
        activity_type: 'listening_choice',
        audio_status: practice.listening.audioStatus,
        transcript: practice.listening.transcript,
      },
      options: practice.listening.options.map((text) => ({
        text,
        correct: text === practice.listening.correctAnswer,
      })),
    });
  }

  if (practice.speaking) {
    push('speaking', {
      type: 'speaking',
      question: `Đọc thành tiếng: ${practice.speaking.textZh}`,
      correctAnswer: practice.speaking.textZh,
      explanation: practice.speaking.feedbackVi,
      data: {
        activity_type: 'pronunciation',
        text: practice.speaking.textZh,
        pinyin: practice.speaking.pinyin,
      },
    });
  }

  return result;
}

function uuidArray(ids) {
  return `ARRAY[${ids.map(asUuid).join(', ')}]::UUID[]`;
}

function generateSql(targetEntry, allEntries) {
  const manifest = targetEntry.manifest;
  const raw = fs.readFileSync(targetEntry.filePath);
  const checksum = crypto.createHash('sha256').update(raw).digest('hex');
  const allVocabulary = new Map();
  const allGrammar = new Map();
  const allCharacters = new Map();

  for (const entry of allEntries) {
    for (const course of entry.manifest.courses ?? []) {
      for (const unit of course.units ?? []) {
        for (const chapter of unit.chapters ?? []) {
          for (const lesson of chapter.lessons ?? []) {
            for (const item of lesson.vocabulary ?? []) allVocabulary.set(item.key, item);
            for (const item of lesson.grammar ?? []) allGrammar.set(item.key, item);
            for (const item of lesson.characters ?? []) allCharacters.set(item.key, item);
          }
        }
      }
    }
  }

  const lines = [
    `-- Generated from ${path.relative(rootDir, targetEntry.filePath).replace(/\\/g, '/')}.`,
    '-- Do not hand-edit this migration; edit the manifest and regenerate.',
    '-- Additive and idempotent: deterministic IDs plus ON CONFLICT DO NOTHING.',
    '',
    'BEGIN;',
    '',
  ];
  const ids = {
    courses: [],
    units: [],
    chapters: [],
    lessons: [],
    vocabulary: [],
    grammar: [],
    characters: [],
    exercises: [],
    options: [],
  };
  const counts = Object.fromEntries(Object.keys(ids).map((key) => [key, 0]));

  for (const repair of manifest.legacyExerciseRepairs ?? []) {
    lines.push(
      '-- Correct a known non-functional legacy exercise while preserving its ID and attempts.',
      'UPDATE public.exercises',
      'SET',
      `  exercise_type = ${quoteSql(repair.exerciseType)},`,
      `  question = ${quoteSql(repair.question)},`,
      `  correct_answer = ${quoteSql(repair.correctAnswer)},`,
      `  explanation = ${quoteSql(repair.explanationVi)},`,
      `  data = ${jsonSql(repair.data)},`,
      '  updated_at = NOW()',
      `WHERE id = ${asUuid(repair.id)}`,
      `  AND exercise_type = ${quoteSql(repair.expectedExerciseType)}`,
      '  AND question_audio_url IS NULL;',
      '',
    );
    for (const [index, option] of repair.options.entries()) {
      lines.push(
        'UPDATE public.exercise_options',
        `SET text = ${quoteSql(option.text)}, is_correct = ${option.correct ? 'TRUE' : 'FALSE'}`,
        `WHERE exercise_id = ${asUuid(repair.id)} AND order_index = ${index + 1};`,
        '',
      );
    }
  }

  for (const course of manifest.courses) {
    const courseId = idFor('course', course.slug, course.existingId);
    ids.courses.push(courseId);
    if (!course.existingId) {
      row(
        lines,
        'courses',
        [
          'id', 'slug', 'title', 'title_zh', 'description', 'level', 'status',
          'order_index', 'learning_objectives', 'estimated_minutes', 'content_version',
        ],
        [
          asUuid(courseId),
          quoteSql(course.slug),
          quoteSql(course.title),
          quoteSql(course.titleZh),
          quoteSql(course.descriptionVi),
          quoteSql(course.level),
          quoteSql(course.status),
          String(course.orderIndex),
          jsonSql(course.objectives),
          String(course.estimatedMinutes),
          String(manifest.version),
        ],
      );
      counts.courses += 1;
    }

    for (const unit of course.units) {
      const unitId = idFor('unit', `${course.slug}:${unit.slug}`, unit.existingId);
      ids.units.push(unitId);
      if (!unit.existingId) {
        row(
          lines,
          'units',
          [
            'id', 'course_id', 'slug', 'title', 'description', 'order_index',
            'status', 'learning_objectives', 'content_version',
          ],
          [
            asUuid(unitId),
            asUuid(courseId),
            quoteSql(unit.slug),
            quoteSql(unit.title),
            quoteSql(unit.descriptionVi),
            String(unit.orderIndex),
            quoteSql(unit.status),
            jsonSql(unit.objectives ?? []),
            String(manifest.version),
          ],
        );
        counts.units += 1;
      }

      for (const chapter of unit.chapters) {
        const chapterId = idFor(
          'chapter',
          `${course.slug}:${unit.slug}:${chapter.slug}`,
          chapter.existingId,
        );
        ids.chapters.push(chapterId);
        if (!chapter.existingId) {
          row(
            lines,
            'chapters',
            [
              'id', 'unit_id', 'slug', 'title', 'description', 'order_index',
              'status', 'learning_objectives', 'content_version',
            ],
            [
              asUuid(chapterId),
              asUuid(unitId),
              quoteSql(chapter.slug),
              quoteSql(chapter.title),
              quoteSql(chapter.descriptionVi),
              String(chapter.orderIndex),
              quoteSql(chapter.status),
              jsonSql(chapter.objectives ?? []),
              String(manifest.version),
            ],
          );
          counts.chapters += 1;
        }

        for (const lesson of chapter.lessons) {
          lesson.course = course;
          const lessonId = idFor(
            'lesson',
            `${course.slug}:${unit.slug}:${chapter.slug}:${lesson.slug}`,
            lesson.existingId,
          );
          ids.lessons.push(lessonId);
          if (!lesson.existingId) {
            row(
              lines,
              'lessons',
              [
                'id', 'chapter_id', 'slug', 'title', 'description', 'order_index',
                'xp_reward', 'status', 'lesson_type', 'estimated_minutes',
                'learning_objectives', 'cultural_note', 'content_version',
              ],
              [
                asUuid(lessonId),
                asUuid(chapterId),
                quoteSql(lesson.slug),
                quoteSql(lesson.title),
                quoteSql(lesson.descriptionVi),
                String(lesson.orderIndex),
                String(lesson.xpReward),
                quoteSql(lesson.status),
                quoteSql(lesson.lessonType ?? 'standard'),
                String(lesson.estimatedMinutes),
                jsonSql(lesson.objectives),
                quoteSql(lesson.culturalNote ?? null),
                String(manifest.version),
              ],
            );
            counts.lessons += 1;
          }

          if (lesson.unlockForUsersWhoCompletedLessonId) {
            lines.push(
              '-- Preserve real progression when a newly appended published lesson follows existing content.',
              'INSERT INTO public.user_lesson_progress (user_id, lesson_id, status)',
              `SELECT progress.user_id, ${asUuid(lessonId)}, 'available'`,
              'FROM public.user_lesson_progress AS progress',
              `WHERE progress.lesson_id = ${asUuid(lesson.unlockForUsersWhoCompletedLessonId)}`,
              `  AND progress.status = 'completed'`,
              'ON CONFLICT (user_id, lesson_id) DO NOTHING;',
              '',
            );
          }

          for (const [index, vocabulary] of (lesson.vocabulary ?? []).entries()) {
            const vocabularyId = idFor('vocabulary', vocabulary.key, vocabulary.existingId);
            ids.vocabulary.push(vocabularyId);
            if (!vocabulary.existingId) {
              row(
                lines,
                'vocabulary',
                [
                  'id', 'content_key', 'chinese', 'pinyin', 'meaning_vi', 'meaning_en',
                  'level', 'category', 'part_of_speech', 'example_sentence',
                  'example_pinyin', 'example_meaning', 'hsk_level', 'status',
                  'first_introduced_lesson_id', 'source_note', 'content_version',
                ],
                [
                  asUuid(vocabularyId),
                  quoteSql(vocabulary.key),
                  quoteSql(vocabulary.chinese),
                  quoteSql(vocabulary.pinyin),
                  quoteSql(vocabulary.meaningVi),
                  quoteSql(vocabulary.meaningEn ?? null),
                  quoteSql(vocabulary.level),
                  quoteSql(vocabulary.category),
                  quoteSql(vocabulary.partOfSpeech),
                  quoteSql(vocabulary.exampleSentence),
                  quoteSql(vocabulary.examplePinyin),
                  quoteSql(vocabulary.exampleMeaningVi),
                  vocabulary.hskLevel == null ? 'NULL' : String(vocabulary.hskLevel),
                  quoteSql(vocabulary.status),
                  asUuid(lessonId),
                  quoteSql(vocabulary.sourceNote ?? 'Mandarin Master original curriculum'),
                  String(manifest.version),
                ],
              );
              counts.vocabulary += 1;
            }
            const linkId = deterministicUuid(`lesson-vocabulary:${lessonId}:${vocabularyId}`);
            row(
              lines,
              'lesson_vocabulary',
              ['id', 'lesson_id', 'vocabulary_id', 'order_index', 'curriculum_role'],
              [
                asUuid(linkId),
                asUuid(lessonId),
                asUuid(vocabularyId),
                String(index + 1),
                quoteSql('introduced'),
              ],
              'lesson_id, vocabulary_id',
            );
            for (const prerequisiteKey of vocabulary.prerequisiteKeys ?? []) {
              const prerequisite = allVocabulary.get(prerequisiteKey);
              const prerequisiteId = idFor(
                'vocabulary',
                prerequisiteKey,
                prerequisite?.existingId,
              );
              row(
                lines,
                'vocabulary_prerequisites',
                ['vocabulary_id', 'prerequisite_vocabulary_id'],
                [asUuid(vocabularyId), asUuid(prerequisiteId)],
                'vocabulary_id, prerequisite_vocabulary_id',
              );
            }
          }

          for (const [index, key] of (lesson.reviewVocabularyKeys ?? []).entries()) {
            const vocabulary = allVocabulary.get(key);
            const vocabularyId = idFor('vocabulary', key, vocabulary?.existingId);
            const linkId = deterministicUuid(`lesson-vocabulary:${lessonId}:${vocabularyId}`);
            row(
              lines,
              'lesson_vocabulary',
              ['id', 'lesson_id', 'vocabulary_id', 'order_index', 'curriculum_role'],
              [
                asUuid(linkId),
                asUuid(lessonId),
                asUuid(vocabularyId),
                String((lesson.vocabulary?.length ?? 0) + index + 1),
                quoteSql('review'),
              ],
              'lesson_id, vocabulary_id',
            );
          }

          for (const [index, grammar] of (lesson.grammar ?? []).entries()) {
            const grammarId = idFor('grammar', grammar.key, grammar.existingId);
            ids.grammar.push(grammarId);
            if (!grammar.existingId) {
              row(
                lines,
                'grammar_lessons',
                [
                  'id', 'content_key', 'title', 'pattern', 'explanation',
                  'example_chinese', 'example_pinyin', 'example_meaning', 'level',
                  'status', 'usage_note', 'content_version',
                ],
                [
                  asUuid(grammarId),
                  quoteSql(grammar.key),
                  quoteSql(grammar.title),
                  quoteSql(grammar.pattern),
                  quoteSql(grammar.explanationVi),
                  quoteSql(grammar.exampleChinese),
                  quoteSql(grammar.examplePinyin),
                  quoteSql(grammar.exampleMeaningVi),
                  quoteSql(grammar.level),
                  quoteSql(grammar.status),
                  quoteSql(grammar.usageNote ?? null),
                  String(manifest.version),
                ],
              );
              counts.grammar += 1;
            }
            const linkId = deterministicUuid(`lesson-grammar:${lessonId}:${grammarId}`);
            row(
              lines,
              'lesson_grammar',
              ['id', 'lesson_id', 'grammar_lesson_id', 'order_index', 'curriculum_role'],
              [
                asUuid(linkId),
                asUuid(lessonId),
                asUuid(grammarId),
                String(index + 1),
                quoteSql('introduced'),
              ],
              'lesson_id, grammar_lesson_id',
            );
          }

          for (const [index, key] of (lesson.reviewGrammarKeys ?? []).entries()) {
            const grammar = allGrammar.get(key);
            const grammarId = idFor('grammar', key, grammar?.existingId);
            const linkId = deterministicUuid(`lesson-grammar:${lessonId}:${grammarId}`);
            row(
              lines,
              'lesson_grammar',
              ['id', 'lesson_id', 'grammar_lesson_id', 'order_index', 'curriculum_role'],
              [
                asUuid(linkId),
                asUuid(lessonId),
                asUuid(grammarId),
                String((lesson.grammar?.length ?? 0) + index + 1),
                quoteSql('review'),
              ],
              'lesson_id, grammar_lesson_id',
            );
          }

          for (const [index, character] of (lesson.characters ?? []).entries()) {
            const characterId = idFor('character', character.key, character.existingId);
            ids.characters.push(characterId);
            if (!character.existingId) {
              row(
                lines,
                'characters',
                [
                  'id', 'character', 'pinyin', 'meaning_vi', 'radical',
                  'stroke_count', 'stroke_order', 'level', 'status',
                  'component_breakdown', 'common_words', 'content_version',
                ],
                [
                  asUuid(characterId),
                  quoteSql(character.character),
                  quoteSql(character.pinyin),
                  quoteSql(character.meaningVi),
                  quoteSql(character.radical),
                  String(character.strokeCount),
                  'NULL',
                  quoteSql(character.level),
                  quoteSql(character.status),
                  jsonSql(character.componentBreakdown ?? null),
                  jsonSql(character.commonWords ?? []),
                  String(manifest.version),
                ],
              );
              counts.characters += 1;
            }
            const linkId = deterministicUuid(`lesson-character:${lessonId}:${characterId}`);
            row(
              lines,
              'lesson_characters',
              ['id', 'lesson_id', 'character_id', 'order_index', 'curriculum_role'],
              [
                asUuid(linkId),
                asUuid(lessonId),
                asUuid(characterId),
                String(index + 1),
                quoteSql('introduced'),
              ],
              'lesson_id, character_id',
            );
          }

          for (const [index, key] of (lesson.reviewCharacterKeys ?? []).entries()) {
            const character = allCharacters.get(key);
            const characterId = idFor('character', key, character?.existingId);
            const linkId = deterministicUuid(`lesson-character:${lessonId}:${characterId}`);
            row(
              lines,
              'lesson_characters',
              ['id', 'lesson_id', 'character_id', 'order_index', 'curriculum_role'],
              [
                asUuid(linkId),
                asUuid(lessonId),
                asUuid(characterId),
                String((lesson.characters?.length ?? 0) + index + 1),
                quoteSql('review'),
              ],
              'lesson_id, character_id',
            );
          }

          const exercises = makeExerciseRows(lesson, allVocabulary);
          for (const exercise of exercises) {
            const exerciseId = deterministicUuid(`exercise:${exercise.key}`);
            ids.exercises.push(exerciseId);
            row(
              lines,
              'exercises',
              [
                'id', 'lesson_id', 'exercise_type', 'order_index', 'question',
                'question_audio_url', 'correct_answer', 'explanation', 'hint',
                'points', 'data',
              ],
              [
                asUuid(exerciseId),
                asUuid(lessonId),
                quoteSql(exercise.type),
                String(exercise.orderIndex),
                quoteSql(exercise.question),
                quoteSql(exercise.questionAudioUrl ?? null),
                quoteSql(exercise.correctAnswer),
                quoteSql(exercise.explanation ?? null),
                quoteSql(exercise.hint ?? null),
                '1',
                jsonSql(exercise.data ?? {}),
              ],
            );
            counts.exercises += 1;

            for (const [optionIndex, option] of (exercise.options ?? []).entries()) {
              const optionId = deterministicUuid(
                `exercise-option:${exercise.key}:${optionIndex + 1}`,
              );
              ids.options.push(optionId);
              row(
                lines,
                'exercise_options',
                ['id', 'exercise_id', 'text', 'is_correct', 'order_index'],
                [
                  asUuid(optionId),
                  asUuid(exerciseId),
                  quoteSql(option.text),
                  option.correct ? 'TRUE' : 'FALSE',
                  String(optionIndex + 1),
                ],
              );
              counts.options += 1;
            }
          }
        }
      }
    }
  }

  const batchId = deterministicUuid(`content-batch:${manifest.batchKey}:${manifest.version}`);
  row(
    lines,
    'content_batches',
    [
      'id', 'batch_key', 'version', 'migration_name', 'manifest_checksum',
      'expected_counts',
    ],
    [
      asUuid(batchId),
      quoteSql(manifest.batchKey),
      String(manifest.version),
      quoteSql(manifest.migrationName),
      quoteSql(checksum),
      jsonSql(counts),
    ],
    'batch_key, version',
  );

  const checks = [
    ['courses', ids.courses],
    ['units', ids.units],
    ['chapters', ids.chapters],
    ['lessons', ids.lessons],
    ['vocabulary', [...new Set(ids.vocabulary)]],
    ['grammar_lessons', [...new Set(ids.grammar)]],
    ['characters', [...new Set(ids.characters)]],
    ['exercises', ids.exercises],
    ['exercise_options', ids.options],
  ].filter(([, tableIds]) => tableIds.length > 0);

  lines.push('DO $content_validation$', 'BEGIN');
  for (const [table, tableIds] of checks) {
    lines.push(
      `  IF (SELECT COUNT(*) FROM public.${table} WHERE id = ANY(${uuidArray(tableIds)})) <> ${tableIds.length} THEN`,
      `    RAISE EXCEPTION 'Content batch ${manifest.batchKey} is missing managed ${table} rows';`,
      '  END IF;',
    );
  }
  lines.push(
    `  IF EXISTS (`,
    `    SELECT 1 FROM public.lessons AS lesson`,
    `    WHERE lesson.id = ANY(${uuidArray(ids.lessons)})`,
    `      AND NOT EXISTS (`,
    `        SELECT 1 FROM public.exercises AS exercise`,
    `        WHERE exercise.lesson_id = lesson.id`,
    `      )`,
    `  ) THEN`,
    `    RAISE EXCEPTION 'Content batch ${manifest.batchKey} contains a lesson without exercises';`,
    `  END IF;`,
    `  IF EXISTS (`,
    `    SELECT 1`,
    `    FROM public.lessons AS lesson`,
    `    JOIN public.exercises AS exercise ON exercise.lesson_id = lesson.id`,
    `    WHERE lesson.id = ANY(${uuidArray(ids.lessons)})`,
    `      AND lesson.status = 'published'`,
    `      AND exercise.exercise_type = 'listening'`,
    `      AND NULLIF(BTRIM(exercise.question_audio_url), '') IS NULL`,
    `  ) THEN`,
    `    RAISE EXCEPTION 'Published listening exercise is missing playable audio';`,
    `  END IF;`,
    `  IF EXISTS (`,
    `    SELECT 1`,
    `    FROM public.exercises AS exercise`,
    `    WHERE exercise.id = ANY(${uuidArray(ids.exercises)})`,
    `      AND exercise.exercise_type IN ('multiple_choice', 'listening')`,
    `      AND (`,
    `        SELECT COUNT(*) FILTER (WHERE option.is_correct)`,
    `        FROM public.exercise_options AS option`,
    `        WHERE option.exercise_id = exercise.id`,
    `      ) <> 1`,
    `  ) THEN`,
    `    RAISE EXCEPTION 'Choice exercise must have exactly one correct option';`,
    `  END IF;`,
    `  IF EXISTS (`,
    `    SELECT 1`,
    `    FROM public.lesson_vocabulary AS link`,
    `    JOIN public.vocabulary AS vocabulary ON vocabulary.id = link.vocabulary_id`,
    `    WHERE link.lesson_id = ANY(${uuidArray(ids.lessons)})`,
    `      AND (`,
    `        NULLIF(BTRIM(vocabulary.pinyin), '') IS NULL`,
    `        OR NULLIF(BTRIM(vocabulary.meaning_vi), '') IS NULL`,
    `        OR NULLIF(BTRIM(vocabulary.part_of_speech), '') IS NULL`,
    `        OR NULLIF(BTRIM(vocabulary.example_sentence), '') IS NULL`,
    `        OR NULLIF(BTRIM(vocabulary.example_pinyin), '') IS NULL`,
    `        OR NULLIF(BTRIM(vocabulary.example_meaning), '') IS NULL`,
    `      )`,
    `  ) THEN`,
    `    RAISE EXCEPTION 'Managed lesson vocabulary is incomplete';`,
    `  END IF;`,
    'END',
    '$content_validation$;',
    '',
    'COMMIT;',
    '',
  );

  return lines.join('\n');
}

function main() {
  const args = parseArgs(process.argv);
  const manifestPath = path.resolve(rootDir, args.manifest);
  const entries = loadManifests(rootDir);
  const validation = validateManifests(entries, rootDir);
  if (validation.errors.length > 0) {
    for (const issue of validation.errors) {
      process.stderr.write(`ERROR ${issue.file} [${issue.location}] ${issue.message}\n`);
    }
    throw new Error('Content validation failed; SQL was not generated');
  }
  const targetEntry = entries.find(
    (entry) => path.resolve(entry.filePath) === manifestPath,
  );
  if (!targetEntry) throw new Error(`Manifest is not under content/manifests: ${args.manifest}`);
  const sql = generateSql(targetEntry, entries);
  const outputPath = path.resolve(
    rootDir,
    args.output
      ?? path.join('supabase', 'migrations', `${targetEntry.manifest.migrationName}.sql`),
  );

  if (args.check) {
    if (!fs.existsSync(outputPath)) throw new Error(`Generated migration is missing: ${outputPath}`);
    const existing = fs.readFileSync(outputPath, 'utf8').replace(/\r\n/g, '\n');
    if (existing !== sql.replace(/\r\n/g, '\n')) {
      throw new Error(`Generated migration is stale: ${path.relative(rootDir, outputPath)}`);
    }
    process.stdout.write(`Generated migration is current: ${path.relative(rootDir, outputPath)}\n`);
    return;
  }

  if (fs.existsSync(outputPath)) {
    throw new Error(
      `Refusing to overwrite ${path.relative(rootDir, outputPath)}; remove it explicitly or use --check`,
    );
  }
  fs.writeFileSync(outputPath, sql, 'utf8');
  process.stdout.write(`Generated ${path.relative(rootDir, outputPath)}\n`);
}

main();
