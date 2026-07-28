declare const require: (moduleName: string) => any;
declare const __dirname: string;

const path = require('path');
const {
  deterministicUuid,
  loadManifests,
  validateManifests,
} = require('../scripts/content/content-tools.cjs');

const projectRoot = path.join(__dirname, '..');

describe('curriculum content manifests', () => {
  it('uses stable RFC 4122 version-5-style UUIDs', () => {
    const first = deterministicUuid('lesson:hsk-1:greetings');
    const second = deterministicUuid('lesson:hsk-1:greetings');

    expect(first).toBe(second);
    expect(first).toMatch(
      /^[0-9a-f]{8}-[0-9a-f]{4}-5[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/,
    );
  });

  it('passes relationship, language-field, practice, and review validation', () => {
    const entries = loadManifests(projectRoot);
    const result = validateManifests(entries, projectRoot);

    expect(entries.length).toBeGreaterThanOrEqual(1);
    expect(result.state.courses.length).toBeGreaterThanOrEqual(2);
    expect(result.errors).toEqual([]);
    expect(result.warnings).toEqual([]);
  });
});
