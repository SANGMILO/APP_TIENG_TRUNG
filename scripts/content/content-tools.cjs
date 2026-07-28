const crypto = require('crypto');
const fs = require('fs');
const path = require('path');

const CONTENT_STATUSES = new Set(['draft', 'review', 'published', 'archived']);
const LEVELS = new Set([
  'starter',
  'beginner',
  'elementary',
  'intermediate',
  'upper-intermediate',
  'advanced',
]);
const SUPPORTED_EXERCISE_TYPES = new Set([
  'vocabulary',
  'multiple_choice',
  'listening',
  'speaking',
  'translation',
  'sentence_builder',
  'flashcard',
  'character_writing',
  'grammar',
  'tone_practice',
]);
const TONE_MARK_PATTERN = /[āáǎàēéěèīíǐìōóǒòūúǔùǖǘǚǜ]/i;
const HANZI_PATTERN = /[\u3400-\u9fff]/;
const TRADITIONAL_ONLY_PATTERN = /[萬與專業東絲兩嚴喪個豐臨為麗舉麼義烏樂喬習鄉書買亂爭於虧雲亞產畝親億僅從侖倉儀們價眾優會傘偉傳傷倫偽體餘傭傾僑儉儲兒兌黨蘭關興養獸內岡冊寫軍農馮沖決況凍淨準幾鳳凱別刪則劑剝劇劉劍辦務動勵勁勞勢勳區醫華協單賣盧衛卻廠廳曆歷壓厭廁廂廈廚縣參雙發變敘葉號歎後嚇嗎噸聽啟員喚問啞響頁]/;

function deterministicUuid(key) {
  const bytes = Buffer.from(
    crypto.createHash('sha256').update(`mandarin-master:${key}`).digest('hex').slice(0, 32),
    'hex',
  );
  bytes[6] = (bytes[6] & 0x0f) | 0x50;
  bytes[8] = (bytes[8] & 0x3f) | 0x80;
  const hex = bytes.toString('hex');
  return `${hex.slice(0, 8)}-${hex.slice(8, 12)}-${hex.slice(12, 16)}-${hex.slice(16, 20)}-${hex.slice(20)}`;
}

function listManifestFiles(rootDir) {
  const manifestDir = path.join(rootDir, 'content', 'manifests');
  if (!fs.existsSync(manifestDir)) return [];
  return fs.readdirSync(manifestDir)
    .filter((name) => name.endsWith('.json'))
    .sort()
    .map((name) => path.join(manifestDir, name));
}

function loadManifests(rootDir) {
  return listManifestFiles(rootDir).map((filePath) => ({
    filePath,
    manifest: JSON.parse(fs.readFileSync(filePath, 'utf8')),
  }));
}

function flattenManifest(entry, state) {
  const { manifest, filePath } = entry;
  const file = path.relative(state.rootDir, filePath).replace(/\\/g, '/');
  const batch = {
    file,
    batchKey: manifest.batchKey,
    version: manifest.version,
    migrationName: manifest.migrationName,
  };
  state.batches.push(batch);

  for (const course of manifest.courses ?? []) {
    const courseEntry = { ...course, file, batch, lessons: [] };
    state.courses.push(courseEntry);
    for (const unit of course.units ?? []) {
      state.units.push({ ...unit, course, file, batch });
      for (const chapter of unit.chapters ?? []) {
        state.chapters.push({ ...chapter, course, unit, file, batch });
        for (const lesson of chapter.lessons ?? []) {
          const lessonEntry = { ...lesson, course, unit, chapter, file, batch };
          courseEntry.lessons.push(lessonEntry);
          state.lessons.push(lessonEntry);
          for (const vocabulary of lesson.vocabulary ?? []) {
            state.vocabulary.push({ ...vocabulary, lesson: lessonEntry, file, batch });
          }
          for (const grammar of lesson.grammar ?? []) {
            state.grammar.push({ ...grammar, lesson: lessonEntry, file, batch });
          }
          for (const character of lesson.characters ?? []) {
            state.characters.push({ ...character, lesson: lessonEntry, file, batch });
          }
        }
      }
    }
  }
}

function buildState(entries, rootDir) {
  const state = {
    rootDir,
    batches: [],
    courses: [],
    units: [],
    chapters: [],
    lessons: [],
    vocabulary: [],
    grammar: [],
    characters: [],
  };
  entries.forEach((entry) => flattenManifest(entry, state));
  return state;
}

function normalizePractice(lesson, vocabularyByKey) {
  const practice = lesson.practice ?? {};
  if (practice.meaningChoice) return practice;

  const target = vocabularyByKey.get(practice.targetKey);
  if (!target) return practice;

  return {
    meaningChoice: {
      targetKey: practice.targetKey,
      distractorKeys: practice.distractorKeys,
    },
    translation: {
      promptVi: practice.translationPromptVi ?? target.exampleMeaningVi,
      answerZh: practice.translationAnswerZh ?? target.exampleSentence,
      acceptableAnswers: practice.acceptableAnswers
        ?? [practice.translationAnswerZh ?? target.exampleSentence],
      explanationVi: practice.translationExplanationVi
        ?? `Mẫu câu dùng “${target.chinese}” trong ngữ cảnh của bài.`,
      hint: practice.translationHint ?? target.pinyin,
    },
    sentenceBuilder: {
      question: practice.sentenceQuestion ?? 'Sắp xếp các thành phần thành câu đúng.',
      answerZh: practice.sentenceAnswerZh ?? target.exampleSentence,
      tokens: practice.sentenceTokens,
      correctOrder: practice.sentenceCorrectOrder ?? practice.sentenceTokens,
      explanationVi: practice.sentenceExplanationVi
        ?? `Trật tự đúng tạo thành câu “${practice.sentenceAnswerZh ?? target.exampleSentence}”.`,
    },
    grammarChoice: {
      question: practice.grammarQuestion,
      options: practice.grammarOptions,
      correctAnswer: practice.grammarCorrect,
      explanationVi: practice.grammarExplanationVi,
      activityType: practice.grammarActivityType ?? 'grammar_selection',
      grammarKey: practice.grammarKey ?? null,
      passage: practice.grammarPassage ?? null,
    },
    speaking: {
      textZh: practice.speakingTextZh ?? target.exampleSentence,
      pinyin: practice.speakingPinyin ?? target.examplePinyin,
      feedbackVi: practice.speakingFeedbackVi
        ?? 'Đọc chậm, giữ đúng thanh điệu và nhịp của cả câu.',
    },
    extraChoices: practice.extraChoices ?? [],
    listening: practice.listening,
  };
}

function validateManifests(entries, rootDir) {
  const state = buildState(entries, rootDir);
  const errors = [];
  const warnings = [];
  const addError = (file, location, message) => errors.push({ file, location, message });
  const requiredText = (file, location, field, value) => {
    if (typeof value !== 'string' || value.trim() === '') {
      addError(file, location, `${field} is required`);
      return false;
    }
    return true;
  };
  const requireUnique = (items, selector, label) => {
    const seen = new Map();
    for (const item of items) {
      const key = selector(item);
      if (!key) continue;
      if (seen.has(key)) {
        addError(item.file, label, `duplicate ${label}: ${key}`);
      } else {
        seen.set(key, item);
      }
    }
  };

  requireUnique(state.batches, (item) => `${item.batchKey}@${item.version}`, 'batch');
  requireUnique(state.batches, (item) => item.migrationName, 'migration name');
  requireUnique(state.courses, (item) => item.slug, 'course slug');
  requireUnique(
    state.units,
    (item) => `${item.course.slug}/${item.slug}`,
    'unit slug within course',
  );
  requireUnique(
    state.chapters,
    (item) => `${item.course.slug}/${item.unit.slug}/${item.slug}`,
    'chapter slug within unit',
  );
  requireUnique(
    state.lessons,
    (item) => `${item.course.slug}/${item.unit.slug}/${item.chapter.slug}/${item.slug}`,
    'lesson slug within chapter',
  );
  requireUnique(state.vocabulary, (item) => item.key, 'vocabulary key');
  requireUnique(state.grammar, (item) => item.key, 'grammar key');
  requireUnique(state.characters, (item) => item.key, 'character key');

  for (const entry of entries) {
    const { manifest, filePath } = entry;
    const file = path.relative(rootDir, filePath).replace(/\\/g, '/');
    if (manifest.schemaVersion !== 1) addError(file, 'manifest', 'schemaVersion must be 1');
    requiredText(file, 'manifest', 'batchKey', manifest.batchKey);
    requiredText(file, 'manifest', 'migrationName', manifest.migrationName);
    if (!Number.isInteger(manifest.version) || manifest.version < 1) {
      addError(file, 'manifest', 'version must be a positive integer');
    }
    if (!Array.isArray(manifest.courses) || manifest.courses.length === 0) {
      addError(file, 'manifest', 'at least one course is required');
    }
  }

  for (const course of state.courses) {
    const at = `course:${course.slug ?? '?'}`;
    requiredText(course.file, at, 'title', course.title);
    requiredText(course.file, at, 'titleZh', course.titleZh);
    requiredText(course.file, at, 'descriptionVi', course.descriptionVi);
    if (!LEVELS.has(course.level)) addError(course.file, at, `unsupported level: ${course.level}`);
    if (!CONTENT_STATUSES.has(course.status)) addError(course.file, at, `unsupported status: ${course.status}`);
    if (!Array.isArray(course.objectives) || course.objectives.length < 2) {
      addError(course.file, at, 'at least two learning objectives are required');
    }
    if (!Number.isInteger(course.estimatedMinutes) || course.estimatedMinutes <= 0) {
      addError(course.file, at, 'estimatedMinutes must be positive');
    }
    if (!Array.isArray(course.units) || course.units.length === 0) {
      addError(course.file, at, 'course must contain units');
    }
  }

  const checkParentPublication = (child, parent, childType, parentType) => {
    if (child.status === 'published' && parent.status !== 'published') {
      addError(
        child.file,
        `${childType}:${child.slug}`,
        `published ${childType} has unpublished ${parentType}`,
      );
    }
  };

  for (const unit of state.units) {
    requiredText(unit.file, `unit:${unit.slug}`, 'title', unit.title);
    requiredText(unit.file, `unit:${unit.slug}`, 'descriptionVi', unit.descriptionVi);
    if (!CONTENT_STATUSES.has(unit.status)) {
      addError(unit.file, `unit:${unit.slug}`, `unsupported status: ${unit.status}`);
    }
    checkParentPublication(unit, unit.course, 'unit', 'course');
    if (!Array.isArray(unit.chapters) || unit.chapters.length === 0) {
      addError(unit.file, `unit:${unit.slug}`, 'unit must contain chapters');
    }
  }

  for (const chapter of state.chapters) {
    requiredText(chapter.file, `chapter:${chapter.slug}`, 'title', chapter.title);
    requiredText(chapter.file, `chapter:${chapter.slug}`, 'descriptionVi', chapter.descriptionVi);
    if (!CONTENT_STATUSES.has(chapter.status)) {
      addError(chapter.file, `chapter:${chapter.slug}`, `unsupported status: ${chapter.status}`);
    }
    checkParentPublication(chapter, chapter.unit, 'chapter', 'unit');
    if (!Array.isArray(chapter.lessons) || chapter.lessons.length === 0) {
      addError(chapter.file, `chapter:${chapter.slug}`, 'chapter must contain lessons');
    }
  }

  const vocabularyByKey = new Map(state.vocabulary.map((item) => [item.key, item]));
  const grammarByKey = new Map(state.grammar.map((item) => [item.key, item]));
  const characterByKey = new Map(state.characters.map((item) => [item.key, item]));

  for (const vocabulary of state.vocabulary) {
    const at = `vocabulary:${vocabulary.key ?? '?'}`;
    for (const field of [
      'key',
      'chinese',
      'pinyin',
      'meaningVi',
      'partOfSpeech',
      'level',
      'category',
      'exampleSentence',
      'examplePinyin',
      'exampleMeaningVi',
    ]) {
      requiredText(vocabulary.file, at, field, vocabulary[field]);
    }
    if (!LEVELS.has(vocabulary.level)) {
      addError(vocabulary.file, at, `unsupported level: ${vocabulary.level}`);
    }
    if (!CONTENT_STATUSES.has(vocabulary.status)) {
      addError(vocabulary.file, at, `unsupported status: ${vocabulary.status}`);
    }
    if (!HANZI_PATTERN.test(vocabulary.chinese)) {
      addError(vocabulary.file, at, 'chinese must contain a Han character');
    }
    if (TRADITIONAL_ONLY_PATTERN.test(vocabulary.chinese) && !vocabulary.teachesTraditional) {
      addError(vocabulary.file, at, 'traditional-only form requires teachesTraditional=true');
    }
    if (!TONE_MARK_PATTERN.test(vocabulary.pinyin) && !vocabulary.neutralTone) {
      addError(vocabulary.file, at, 'pinyin requires tone marks or neutralTone=true');
    }
    if (!TONE_MARK_PATTERN.test(vocabulary.examplePinyin)) {
      addError(vocabulary.file, at, 'examplePinyin requires tone-marked syllables');
    }
    for (const prerequisite of vocabulary.prerequisiteKeys ?? []) {
      if (!vocabularyByKey.has(prerequisite)) {
        addError(vocabulary.file, at, `unknown prerequisite vocabulary key: ${prerequisite}`);
      }
      if (prerequisite === vocabulary.key) {
        addError(vocabulary.file, at, 'vocabulary cannot require itself');
      }
    }
  }

  const duplicateChineseLevel = new Map();
  for (const vocabulary of state.vocabulary) {
    const key = `${vocabulary.level}:${vocabulary.chinese}`;
    if (duplicateChineseLevel.has(key)) {
      addError(
        vocabulary.file,
        `vocabulary:${vocabulary.key}`,
        `duplicate Chinese form within level; reference ${duplicateChineseLevel.get(key)} instead`,
      );
    } else {
      duplicateChineseLevel.set(key, vocabulary.key);
    }
  }

  for (const grammar of state.grammar) {
    const at = `grammar:${grammar.key ?? '?'}`;
    for (const field of [
      'key',
      'title',
      'pattern',
      'explanationVi',
      'exampleChinese',
      'examplePinyin',
      'exampleMeaningVi',
      'level',
    ]) {
      requiredText(grammar.file, at, field, grammar[field]);
    }
    if (!LEVELS.has(grammar.level)) addError(grammar.file, at, `unsupported level: ${grammar.level}`);
    if (!CONTENT_STATUSES.has(grammar.status)) addError(grammar.file, at, `unsupported status: ${grammar.status}`);
    if (!TONE_MARK_PATTERN.test(grammar.examplePinyin)) {
      addError(grammar.file, at, 'examplePinyin requires tone-marked syllables');
    }
  }

  for (const character of state.characters) {
    const at = `character:${character.key ?? '?'}`;
    for (const field of ['key', 'character', 'pinyin', 'meaningVi', 'radical', 'level']) {
      requiredText(character.file, at, field, character[field]);
    }
    if ([...character.character].length !== 1 || !HANZI_PATTERN.test(character.character)) {
      addError(character.file, at, 'character must be exactly one Han character');
    }
    if (!Number.isInteger(character.strokeCount) || character.strokeCount <= 0) {
      addError(character.file, at, 'strokeCount must be positive');
    }
    if (character.strokeOrderUrl) {
      addError(character.file, at, 'stroke-order asset URLs are not accepted by content manifests');
    }
    if (!CONTENT_STATUSES.has(character.status)) {
      addError(character.file, at, `unsupported status: ${character.status}`);
    }
  }

  const lessonPosition = new Map();
  for (const course of state.courses) {
    course.lessons.forEach((lesson, index) => lessonPosition.set(lesson, index));
  }
  const introduced = new Map();
  const reviews = new Map();

  for (const lesson of state.lessons) {
    const at = `lesson:${lesson.slug ?? '?'}`;
    requiredText(lesson.file, at, 'title', lesson.title);
    requiredText(lesson.file, at, 'descriptionVi', lesson.descriptionVi);
    if (!CONTENT_STATUSES.has(lesson.status)) addError(lesson.file, at, `unsupported status: ${lesson.status}`);
    checkParentPublication(lesson, lesson.chapter, 'lesson', 'chapter');
    if (!Number.isInteger(lesson.xpReward) || lesson.xpReward <= 0) {
      addError(lesson.file, at, 'xpReward must be positive');
    }
    if (!Number.isInteger(lesson.estimatedMinutes) || lesson.estimatedMinutes <= 0) {
      addError(lesson.file, at, 'estimatedMinutes must be positive');
    }
    if (!Array.isArray(lesson.objectives) || lesson.objectives.length === 0) {
      addError(lesson.file, at, 'lesson objectives are required');
    }
    if (
      lesson.unlockForUsersWhoCompletedLessonId
      && (
        lesson.status !== 'published'
        || !/^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i
          .test(lesson.unlockForUsersWhoCompletedLessonId)
      )
    ) {
      addError(
        lesson.file,
        at,
        'progression unlock requires a published lesson and valid completed prerequisite UUID',
      );
    }
    const introducedKeys = (lesson.vocabulary ?? []).map((item) => item.key);
    const reviewKeys = lesson.reviewVocabularyKeys ?? [];
    if (introducedKeys.length + reviewKeys.length === 0) {
      addError(lesson.file, at, 'lesson has no introduced or review vocabulary');
    }
    for (const key of introducedKeys) {
      if (introduced.has(key)) addError(lesson.file, at, `vocabulary ${key} is introduced more than once`);
      introduced.set(key, lesson);
    }
    for (const key of reviewKeys) {
      if (!vocabularyByKey.has(key)) addError(lesson.file, at, `unknown review vocabulary key: ${key}`);
      if (!reviews.has(key)) reviews.set(key, []);
      reviews.get(key).push(lesson);
    }
    for (const key of lesson.reviewGrammarKeys ?? []) {
      if (!grammarByKey.has(key)) addError(lesson.file, at, `unknown review grammar key: ${key}`);
    }
    for (const key of lesson.reviewCharacterKeys ?? []) {
      if (!characterByKey.has(key)) addError(lesson.file, at, `unknown review character key: ${key}`);
    }

    const practice = normalizePractice(lesson, vocabularyByKey);
    if (!practice || typeof practice !== 'object') {
      addError(lesson.file, at, 'practice definition is required');
      continue;
    }
    for (const block of ['meaningChoice', 'translation', 'sentenceBuilder', 'grammarChoice', 'speaking']) {
      if (!practice[block]) addError(lesson.file, at, `${block} practice is required`);
    }
    if (practice.meaningChoice) {
      const { targetKey, distractorKeys } = practice.meaningChoice;
      if (!vocabularyByKey.has(targetKey)) addError(lesson.file, at, `unknown meaning target: ${targetKey}`);
      if (!Array.isArray(distractorKeys) || distractorKeys.length < 2) {
        addError(lesson.file, at, 'meaningChoice requires at least two distractors');
      }
      const optionKeys = [targetKey, ...(distractorKeys ?? [])];
      if (new Set(optionKeys).size !== optionKeys.length) {
        addError(lesson.file, at, 'meaningChoice options must be unique');
      }
      for (const key of distractorKeys ?? []) {
        if (!vocabularyByKey.has(key)) addError(lesson.file, at, `unknown meaning distractor: ${key}`);
      }
    }
    if (practice.translation) {
      requiredText(lesson.file, at, 'translation.promptVi', practice.translation.promptVi);
      requiredText(lesson.file, at, 'translation.answerZh', practice.translation.answerZh);
      requiredText(lesson.file, at, 'translation.explanationVi', practice.translation.explanationVi);
    }
    if (practice.sentenceBuilder) {
      requiredText(lesson.file, at, 'sentenceBuilder.answerZh', practice.sentenceBuilder.answerZh);
      if (!Array.isArray(practice.sentenceBuilder.tokens) || practice.sentenceBuilder.tokens.length < 2) {
        addError(lesson.file, at, 'sentenceBuilder requires at least two tokens');
      }
      if (new Set(practice.sentenceBuilder.tokens ?? []).size !== (practice.sentenceBuilder.tokens ?? []).length) {
        warnings.push({ file: lesson.file, location: at, message: 'sentenceBuilder repeats a token; verify token identity handling' });
      }
    }
    if (practice.grammarChoice) {
      const options = practice.grammarChoice.options ?? [];
      if (options.length < 3 || new Set(options).size !== options.length) {
        addError(lesson.file, at, 'grammarChoice requires at least three unique options');
      }
      if (!options.includes(practice.grammarChoice.correctAnswer)) {
        addError(lesson.file, at, 'grammarChoice correctAnswer must be one option');
      }
      if (!['grammar_selection', 'fill_in_blank', 'reading_comprehension'].includes(practice.grammarChoice.activityType)) {
        addError(lesson.file, at, 'grammarChoice activityType is unsupported');
      }
    }
    if (practice.speaking) {
      requiredText(lesson.file, at, 'speaking.textZh', practice.speaking.textZh);
      requiredText(lesson.file, at, 'speaking.pinyin', practice.speaking.pinyin);
      if (!TONE_MARK_PATTERN.test(practice.speaking.pinyin)) {
        addError(lesson.file, at, 'speaking pinyin requires tone marks');
      }
    }
    for (const extra of practice.extraChoices ?? []) {
      if (!SUPPORTED_EXERCISE_TYPES.has('multiple_choice')) {
        addError(lesson.file, at, 'internal exercise mapping is invalid');
      }
      const options = extra.options ?? [];
      if (options.length < 3 || new Set(options).size !== options.length) {
        addError(lesson.file, at, 'extra choice requires at least three unique options');
      }
      if (!options.includes(extra.correctAnswer)) {
        addError(lesson.file, at, 'extra choice correctAnswer must be one option');
      }
      if (!['chinese_to_vietnamese', 'vietnamese_to_chinese', 'grammar_selection', 'fill_in_blank', 'reading_comprehension'].includes(extra.activityType)) {
        addError(lesson.file, at, `unsupported extra choice activityType: ${extra.activityType}`);
      }
    }
    if (practice.listening) {
      if (!practice.listening.audioUrl) {
        addError(lesson.file, at, 'listening exercise requires a real audioUrl');
      }
      if (lesson.status === 'published' && practice.listening.audioStatus !== 'ready') {
        addError(lesson.file, at, 'published listening exercise requires audioStatus=ready');
      }
    }
  }

  for (const [key, introLesson] of introduced) {
    const laterReviews = (reviews.get(key) ?? []).filter(
      (lesson) => lesson.course.slug !== introLesson.course.slug
        || lessonPosition.get(lesson) > lessonPosition.get(introLesson),
    );
    if (laterReviews.length === 0) {
      addError(
        introLesson.file,
        `vocabulary:${key}`,
        'introduced vocabulary is never reviewed in a later lesson',
      );
    }
  }

  return { errors, warnings, state };
}

function quoteSql(value) {
  if (value === null || value === undefined) return 'NULL';
  return `'${String(value).replace(/'/g, "''")}'`;
}

function jsonSql(value) {
  return `${quoteSql(JSON.stringify(value ?? null))}::JSONB`;
}

function statusRank(status) {
  return { draft: 0, review: 1, published: 2, archived: -1 }[status] ?? -2;
}

module.exports = {
  CONTENT_STATUSES,
  LEVELS,
  SUPPORTED_EXERCISE_TYPES,
  buildState,
  deterministicUuid,
  jsonSql,
  listManifestFiles,
  loadManifests,
  normalizePractice,
  quoteSql,
  statusRank,
  validateManifests,
};
