declare const require: (moduleName: string) => any;
declare const __dirname: string;

const fs = require('fs');
const path = require('path');
const projectRoot = path.join(__dirname, '..');

function sourceFiles(relativeDirectories: string[]): string[] {
  const files: string[] = [];

  const visit = (absolutePath: string) => {
    for (const entry of fs.readdirSync(absolutePath, { withFileTypes: true })) {
      const entryPath = path.join(absolutePath, entry.name);
      if (entry.isDirectory()) visit(entryPath);
      else if (/\.(ts|tsx)$/.test(entry.name)) files.push(entryPath);
    }
  };

  relativeDirectories.forEach((directory) => visit(path.join(projectRoot, directory)));
  return files;
}

describe('release security boundaries', () => {
  it('does not expose backend credentials in client source', () => {
    const forbidden = [
      'SUPABASE_SERVICE_ROLE_KEY',
      'OPENAI_API_KEY',
      'AZURE_SPEECH_KEY',
    ];
    const offenders = sourceFiles([
      'app',
      'components',
      'hooks',
      'lib',
      'services',
      'stores',
      'utils',
    ]).filter((file) => {
      const source = fs.readFileSync(file, 'utf8');
      return forbidden.some((name) => source.includes(name));
    });

    expect(offenders).toEqual([]);
  });

  it('authenticates service-role Edge requests before data operations', () => {
    for (const functionName of [
      'ai-tutor-chat',
      'pronunciation-assess',
      'video-playback-url',
      'voice-synthesize',
      'voice-transcribe',
    ]) {
      const source = fs.readFileSync(path.join(
        projectRoot,
        'supabase',
        'functions',
        functionName,
        'index.ts',
      ), 'utf8');
      const authentication = source.indexOf('auth.getUser(token)');
      const firstTableOperation = source.search(/\.(?:from|rpc)\(/);

      expect(authentication).toBeGreaterThan(-1);
      expect(firstTableOperation).toBeGreaterThan(authentication);
      expect(source).not.toMatch(
        /console\.(?:log|warn|error|debug)\([^)]*(?:authHeader|Authorization|Bearer \${|access_token|refresh_token)/s,
      );
    }
  });

  it('uses fixed application destinations after authentication callbacks', () => {
    const callback = fs.readFileSync(
      path.join(projectRoot, 'app', '(auth)', 'callback.tsx'),
      'utf8',
    );

    expect(callback).toContain("router.replace('/(auth)/reset-password')");
    expect(callback).toContain('router.replace(getPostAuthDestination(profile))');
    expect(callback).not.toMatch(/parameters\.get\(['"](?:next|redirect|returnTo)['"]\)/);
  });
});
