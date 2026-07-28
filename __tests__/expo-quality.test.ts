declare const require: (moduleName: string) => any;
declare const __dirname: string;

const fs = require('fs');
const path = require('path');
const projectRoot = path.join(__dirname, '..');

function read(relativePath: string): string {
  return fs.readFileSync(path.join(projectRoot, relativePath), 'utf8');
}

describe('Expo dependency quality', () => {
  const packageJson = JSON.parse(read('package.json'));
  const appJson = JSON.parse(read('app.json'));

  it('uses the maintained Expo audio package without expo-av', () => {
    expect(packageJson.dependencies['expo-audio']).toBe('~57.0.3');
    expect(packageJson.dependencies['expo-asset']).toBe('~57.0.7');
    expect(packageJson.dependencies['expo-av']).toBeUndefined();
    expect(read('package-lock.json')).not.toContain('"expo-av"');

    const plugins = appJson.expo.plugins.map((plugin: string | [string, unknown]) => (
      Array.isArray(plugin) ? plugin[0] : plugin
    ));
    expect(plugins).toEqual(expect.arrayContaining(['expo-audio', 'expo-asset']));
  });

  it('keeps Expo-compatible Jest tooling in development dependencies only', () => {
    expect(packageJson.devDependencies.jest).toBe('~29.7.0');
    expect(packageJson.devDependencies['@types/jest']).toBe('29.5.14');
    expect(packageJson.dependencies.jest).toBeUndefined();
    expect(packageJson.dependencies['@types/jest']).toBeUndefined();
  });

  it('records and plays through expo-audio APIs', () => {
    const player = read('components/media/AudioPlayer.tsx');
    const recorder = read('hooks/useAudioRecorder.ts');

    expect(player).toContain(
      "import { useAudioPlayer, useAudioPlayerStatus } from 'expo-audio'",
    );
    expect(recorder).toContain("from 'expo-audio'");
    expect(recorder).toContain('AudioModule.requestRecordingPermissionsAsync()');
    expect(recorder).toContain('setAudioModeAsync({');
    expect(recorder).toContain('useAudioStream({');
    expect(recorder).toContain("encoding: 'int16'");
    expect(recorder).toContain('encodePcm16ChunksAsWav');
    expect(player + recorder).not.toContain('expo-av');
  });
});
