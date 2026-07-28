#!/usr/bin/env node

const path = require('path');
const { loadManifests, validateManifests } = require('./content-tools.cjs');

const rootDir = path.resolve(__dirname, '..', '..');
const entries = loadManifests(rootDir);
const result = validateManifests(entries, rootDir);
const jsonMode = process.argv.includes('--json');

const summary = {
  manifests: entries.length,
  courses: result.state.courses.length,
  units: result.state.units.length,
  chapters: result.state.chapters.length,
  lessons: result.state.lessons.length,
  vocabulary: result.state.vocabulary.length,
  grammar: result.state.grammar.length,
  characters: result.state.characters.length,
  errors: result.errors.length,
  warnings: result.warnings.length,
};

if (jsonMode) {
  process.stdout.write(`${JSON.stringify({ summary, errors: result.errors, warnings: result.warnings }, null, 2)}\n`);
} else {
  for (const issue of result.errors) {
    process.stderr.write(`ERROR ${issue.file} [${issue.location}] ${issue.message}\n`);
  }
  for (const issue of result.warnings) {
    process.stderr.write(`WARN  ${issue.file} [${issue.location}] ${issue.message}\n`);
  }
  process.stdout.write(
    `Content validation: ${summary.manifests} manifests, ${summary.courses} courses, `
    + `${summary.lessons} lessons, ${summary.vocabulary} vocabulary, `
    + `${summary.grammar} grammar, ${summary.errors} errors, ${summary.warnings} warnings.\n`,
  );
}

if (result.errors.length > 0) process.exitCode = 1;
