#!/usr/bin/env node

const fs = require('fs');
const path = require('path');
const {
  deterministicUuid,
  loadManifests,
  normalizePractice,
  validateManifests,
} = require('./content-tools.cjs');

const rootDir = path.resolve(__dirname, '..', '..');
const entries = loadManifests(rootDir);
const validation = validateManifests(entries, rootDir);
if (validation.errors.length > 0) {
  throw new Error('Content validation must pass before reports can be generated');
}

const { state } = validation;
const vocabularyByKey = new Map(state.vocabulary.map((item) => [item.key, item]));
const courseRows = [];
const levelVocabulary = new Map();
const levelGrammar = new Map();
const exerciseTypes = new Map();
const activityTypes = new Map();
const introduced = new Set();
const reviewed = new Set();
const audioRequests = [];

function increment(map, key, amount = 1) {
  map.set(key, (map.get(key) ?? 0) + amount);
}

function lessonId(lesson) {
  return lesson.existingId ?? deterministicUuid(
    `lesson:${lesson.course.slug}:${lesson.unit.slug}:${lesson.chapter.slug}:${lesson.slug}`,
  );
}

for (const vocabulary of state.vocabulary) {
  introduced.add(vocabulary.key);
  increment(levelVocabulary, vocabulary.level);
  const id = vocabulary.existingId ?? deterministicUuid(`vocabulary:${vocabulary.key}`);
  audioRequests.push({
    lesson_id: lessonId(vocabulary.lesson),
    item_type: 'vocabulary',
    item_id: id,
    chinese_text: vocabulary.chinese,
    pinyin: vocabulary.pinyin,
    desired_voice: 'zh-CN-XiaoxiaoNeural',
    speaking_rate: 0.9,
    audio_status: 'pending',
    output_filename: `vocabulary/${id}.mp3`,
  });
}

for (const grammar of state.grammar) increment(levelGrammar, grammar.level);

for (const course of state.courses) {
  const courseVocabulary = new Set();
  const courseGrammar = new Set();
  let lessonCount = 0;
  let exerciseCount = 0;

  for (const lesson of course.lessons) {
    lessonCount += 1;
    for (const vocabulary of lesson.vocabulary ?? []) courseVocabulary.add(vocabulary.key);
    for (const key of lesson.reviewVocabularyKeys ?? []) {
      courseVocabulary.add(key);
      reviewed.add(key);
    }
    for (const grammar of lesson.grammar ?? []) courseGrammar.add(grammar.key);
    for (const key of lesson.reviewGrammarKeys ?? []) courseGrammar.add(key);

    for (const type of lesson.existingExerciseTypes ?? []) {
      increment(exerciseTypes, type);
      exerciseCount += 1;
    }
    const introducedCards = lesson.vocabulary?.length ?? 0;
    increment(exerciseTypes, 'vocabulary', introducedCards);
    increment(activityTypes, 'vocabulary_recognition', introducedCards);
    exerciseCount += introducedCards;

    const practice = normalizePractice(lesson, vocabularyByKey);
    increment(exerciseTypes, 'multiple_choice', 2 + (practice.extraChoices?.length ?? 0));
    increment(exerciseTypes, 'translation');
    increment(exerciseTypes, 'sentence_builder');
    increment(exerciseTypes, 'speaking');
    increment(activityTypes, 'chinese_to_vietnamese');
    increment(activityTypes, 'vietnamese_to_chinese');
    increment(activityTypes, 'sentence_ordering');
    increment(activityTypes, practice.grammarChoice.activityType);
    increment(activityTypes, 'pronunciation');
    exerciseCount += 5 + (practice.extraChoices?.length ?? 0);

    for (const extra of practice.extraChoices ?? []) increment(activityTypes, extra.activityType);
    if (practice.listening) {
      increment(exerciseTypes, 'listening');
      increment(activityTypes, 'listening_choice');
      exerciseCount += 1;
    }

    const speakingId = deterministicUuid(
      `exercise:${lesson.course.slug}:${lesson.slug}:speaking`,
    );
    audioRequests.push({
      lesson_id: lessonId(lesson),
      item_type: 'sentence',
      item_id: speakingId,
      chinese_text: practice.speaking.textZh,
      pinyin: practice.speaking.pinyin,
      desired_voice: 'zh-CN-XiaoxiaoNeural',
      speaking_rate: 0.88,
      audio_status: 'pending',
      output_filename: `sentences/${speakingId}.mp3`,
    });
  }

  courseRows.push({
    title: course.title,
    status: course.status,
    units: course.units.length,
    chapters: course.units.reduce((sum, unit) => sum + unit.chapters.length, 0),
    lessons: lessonCount,
    vocabulary: courseVocabulary.size,
    grammar: courseGrammar.size,
    exercises: exerciseCount,
  });
}

const duplicateVocabulary = [];
const vocabularyForms = new Map();
for (const item of state.vocabulary) {
  const key = `${item.level}:${item.chinese}`;
  if (vocabularyForms.has(key)) duplicateVocabulary.push(key);
  else vocabularyForms.set(key, item.key);
}

const lessonsWithoutVocabulary = state.lessons.filter(
  (lesson) => (lesson.vocabulary?.length ?? 0) + (lesson.reviewVocabularyKeys?.length ?? 0) === 0,
);
const lessonsWithoutExercises = state.lessons.filter(
  (lesson) => (
    (lesson.existingExerciseTypes?.length ?? 0)
    + (lesson.vocabulary?.length ?? 0)
    + 5
  ) === 0,
);
const missingPinyin = state.vocabulary.filter((item) => !item.pinyin?.trim());
const missingVietnamese = state.vocabulary.filter((item) => !item.meaningVi?.trim());
const neverReviewed = [...introduced].filter((key) => !reviewed.has(key));

const table = (headers, rows) => [
  `| ${headers.join(' | ')} |`,
  `| ${headers.map(() => '---').join(' | ')} |`,
  ...rows.map((row) => `| ${row.join(' | ')} |`),
].join('\n');

const report = `# Content Coverage Report

Generated from the committed curriculum manifests. Counts include existing
foundation rows explicitly mapped by Batch 1 and all additive managed content.
No user progress is included.

## Coverage by course

${table(
  ['Course', 'Status', 'Units', 'Chapters', 'Lessons', 'Vocabulary', 'Grammar', 'Exercises'],
  courseRows.map((row) => [
    row.title,
    row.status,
    row.units,
    row.chapters,
    row.lessons,
    row.vocabulary,
    row.grammar,
    row.exercises,
  ]),
)}

## Vocabulary by level

${table(
  ['Level', 'Definitions'],
  [...levelVocabulary.entries()].sort().map(([level, count]) => [level, count]),
)}

## Grammar by level

${table(
  ['Level', 'Grammar points'],
  [...levelGrammar.entries()].sort().map(([level, count]) => [level, count]),
)}

## Exercises by database type

${table(
  ['Exercise type', 'Count'],
  [...exerciseTypes.entries()].sort().map(([type, count]) => [type, count]),
)}

## Exercises by pedagogical activity

${table(
  ['Activity', 'Count'],
  [...activityTypes.entries()].sort().map(([type, count]) => [type, count]),
)}

## Integrity findings

- Words introduced but never reviewed: ${neverReviewed.length}
- Lessons without exercises: ${lessonsWithoutExercises.length}
- Lessons without vocabulary: ${lessonsWithoutVocabulary.length}
- Duplicate vocabulary definitions within one level: ${duplicateVocabulary.length}
- Vocabulary missing pinyin: ${missingPinyin.length}
- Vocabulary missing Vietnamese meaning: ${missingVietnamese.length}
- Content validator errors: ${validation.errors.length}
- Content validator warnings: ${validation.warnings.length}

## Publication state

${table(
  ['Status', 'Courses'],
  [...new Set(courseRows.map((row) => row.status))]
    .sort()
    .map((status) => [status, courseRows.filter((row) => row.status === status).length]),
)}

Listening activities are omitted from published content until real audio exists.
Pending audio requests are tracked in \`CONTENT_AUDIO_MANIFEST.json\`.
`;

audioRequests.sort((left, right) => (
  left.lesson_id.localeCompare(right.lesson_id)
  || left.item_type.localeCompare(right.item_type)
  || left.item_id.localeCompare(right.item_id)
));

fs.writeFileSync(
  path.join(rootDir, 'CONTENT_COVERAGE_REPORT.md'),
  report,
  'utf8',
);
fs.writeFileSync(
  path.join(rootDir, 'CONTENT_AUDIO_MANIFEST.json'),
  `${JSON.stringify({
    schema_version: 1,
    generated_audio_count: 0,
    pending_audio_count: audioRequests.length,
    requests: audioRequests,
  }, null, 2)}\n`,
  'utf8',
);

process.stdout.write(
  `Generated coverage report for ${courseRows.length} courses and `
  + `${audioRequests.length} pending audio requests.\n`,
);
