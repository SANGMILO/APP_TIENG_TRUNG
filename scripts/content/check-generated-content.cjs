#!/usr/bin/env node

const { spawnSync } = require('child_process');
const path = require('path');
const { loadManifests } = require('./content-tools.cjs');

const rootDir = path.resolve(__dirname, '..', '..');
const entries = loadManifests(rootDir);

for (const entry of entries) {
  const relativeManifest = path.relative(rootDir, entry.filePath);
  const result = spawnSync(
    process.execPath,
    [
      path.join(__dirname, 'generate-content-sql.cjs'),
      '--manifest',
      relativeManifest,
      '--check',
    ],
    {
      cwd: rootDir,
      encoding: 'utf8',
    },
  );
  if (result.stdout) process.stdout.write(result.stdout);
  if (result.stderr) process.stderr.write(result.stderr);
  if (result.status !== 0) process.exit(result.status ?? 1);
}

process.stdout.write(`Checked ${entries.length} generated content migrations.\n`);
