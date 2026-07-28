#!/usr/bin/env node

const fs = require('fs');
const path = require('path');

const rootDir = path.resolve(__dirname, '..', '..');

function parseArgs(argv) {
  const result = { check: false };
  for (let index = 2; index < argv.length; index += 1) {
    if (argv[index] === '--spec') result.spec = argv[++index];
    else if (argv[index] === '--check') result.check = true;
    else throw new Error(`Unknown argument: ${argv[index]}`);
  }
  if (!result.spec) throw new Error('--spec is required');
  return result;
}

function vocabulary(courseKey, level, status, lessonSlug, row) {
  const [chinese, pinyin, meaningVi, meaningEn, partOfSpeech, sentence, sentencePinyin, sentenceVi, metadata] = row;
  return {
    key: `${courseKey}:${chinese}`,
    chinese,
    pinyin,
    meaningVi,
    meaningEn,
    partOfSpeech,
    level,
    category: lessonSlug,
    status,
    exampleSentence: sentence,
    examplePinyin: sentencePinyin,
    exampleMeaningVi: sentenceVi,
    ...(metadata ?? {}),
  };
}

function grammar(courseKey, level, status, lesson) {
  return {
    key: `${courseKey}:${lesson.slug}`,
    title: lesson.grammar.title,
    pattern: lesson.grammar.pattern,
    explanationVi: lesson.grammar.explanationVi,
    exampleChinese: lesson.grammar.correct,
    examplePinyin: lesson.grammar.pinyin,
    exampleMeaningVi: lesson.grammar.meaningVi,
    level,
    status,
    usageNote: lesson.grammar.usageNote,
  };
}

function practice(targetKey, distractorKeys, lesson, grammarKey) {
  const wrong = lesson.grammar.wrong ?? [
    [...lesson.tokens].reverse().join(''),
    [...lesson.tokens.slice(1), lesson.tokens[0]].join(''),
  ];
  return {
    targetKey,
    distractorKeys,
    sentenceTokens: lesson.tokens,
    sentenceAnswerZh: lesson.grammar.correct,
    translationPromptVi: lesson.grammar.meaningVi,
    translationAnswerZh: lesson.grammar.correct,
    grammarQuestion: lesson.grammar.question,
    grammarOptions: [lesson.grammar.correct, ...wrong],
    grammarCorrect: lesson.grammar.correct,
    grammarExplanationVi: lesson.grammar.explanationVi,
    grammarActivityType: lesson.grammar.activityType ?? 'grammar_selection',
    grammarKey,
    speakingTextZh: lesson.grammar.correct,
    speakingPinyin: lesson.grammar.pinyin,
  };
}

function build(spec) {
  const status = spec.status ?? 'review';
  const builtLessons = [];
  let previousVocabularyKeys = spec.initialReviewKeys ?? [];
  let previousGrammarKeys = spec.initialReviewGrammarKeys ?? [];

  for (let index = 0; index < spec.lessons.length; index += 1) {
    const lesson = spec.lessons[index];
    const words = lesson.words.map((row) =>
      vocabulary(spec.courseKey, spec.level, status, lesson.slug, row));
    const grammarRow = grammar(spec.courseKey, spec.level, status, lesson);
    const keys = words.map((word) => word.key);
    builtLessons.push({
      slug: lesson.slug,
      title: lesson.title,
      descriptionVi: lesson.descriptionVi,
      orderIndex: (index % spec.lessonsPerUnit) + 1,
      xpReward: lesson.xpReward ?? 25,
      status,
      lessonType: 'standard',
      estimatedMinutes: lesson.estimatedMinutes ?? 15,
      objectives: lesson.objectives,
      culturalNote: lesson.culturalNote,
      reviewVocabularyKeys: previousVocabularyKeys,
      reviewGrammarKeys: previousGrammarKeys,
      vocabulary: words,
      grammar: [grammarRow],
      ...(lesson.characters ? { characters: lesson.characters } : {}),
      practice: practice(keys[0], keys.slice(1), lesson, grammarRow.key),
    });
    previousVocabularyKeys = keys;
    previousGrammarKeys = [grammarRow.key];
  }

  const last = spec.lessons.at(-1);
  builtLessons.push({
    slug: `${spec.courseKey}-review`,
    title: `Ôn tập ${spec.title}`,
    descriptionVi: 'Củng cố từ vựng, mẫu câu và khả năng diễn đạt của toàn khóa.',
    orderIndex: ((spec.lessons.length) % spec.lessonsPerUnit) + 1,
    xpReward: 30,
    status,
    lessonType: 'review',
    estimatedMinutes: 18,
    objectives: ['Vận dụng lại từ vựng trọng tâm', 'Tự kiểm tra mẫu câu đã học'],
    reviewVocabularyKeys: previousVocabularyKeys,
    reviewGrammarKeys: previousGrammarKeys,
    vocabulary: [],
    grammar: [],
    practice: practice(
      previousVocabularyKeys[0],
      previousVocabularyKeys.slice(1),
      last,
      previousGrammarKeys[0],
    ),
  });

  const units = [];
  for (let start = 0; start < builtLessons.length; start += spec.lessonsPerUnit) {
    const unitIndex = units.length;
    const unitSpec = spec.units[unitIndex];
    const lessons = builtLessons.slice(start, start + spec.lessonsPerUnit);
    units.push({
      slug: unitSpec.slug,
      title: unitSpec.title,
      descriptionVi: unitSpec.descriptionVi,
      orderIndex: unitIndex + 1,
      status,
      objectives: unitSpec.objectives,
      chapters: [{
        slug: `${unitSpec.slug}-chapter`,
        title: unitSpec.chapterTitle,
        descriptionVi: unitSpec.descriptionVi,
        orderIndex: 1,
        status,
        objectives: unitSpec.objectives,
        lessons,
      }],
    });
  }

  return {
    schemaVersion: 1,
    batchKey: spec.batchKey,
    version: 1,
    migrationName: spec.migrationName,
    description: spec.description,
    courses: [{
      slug: spec.slug,
      title: spec.title,
      titleZh: spec.titleZh,
      descriptionVi: spec.descriptionVi,
      level: spec.level,
      orderIndex: spec.orderIndex,
      status,
      estimatedMinutes: builtLessons.reduce((sum, lesson) => sum + lesson.estimatedMinutes, 0),
      objectives: spec.objectives,
      units,
    }],
  };
}

function main() {
  const args = parseArgs(process.argv);
  const specPath = path.resolve(rootDir, args.spec);
  delete require.cache[specPath];
  const spec = require(specPath);
  const outputPath = path.join(rootDir, 'content', 'manifests', `${spec.fileName}.json`);
  const output = `${JSON.stringify(build(spec), null, 2)}\n`;
  if (args.check) {
    if (!fs.existsSync(outputPath) || fs.readFileSync(outputPath, 'utf8') !== output) {
      throw new Error(`Generated manifest is stale: ${path.relative(rootDir, outputPath)}`);
    }
    process.stdout.write(`Generated manifest is current: ${path.relative(rootDir, outputPath)}\n`);
    return;
  }
  fs.writeFileSync(outputPath, output, 'utf8');
  process.stdout.write(`Generated ${path.relative(rootDir, outputPath)}\n`);
}

main();
