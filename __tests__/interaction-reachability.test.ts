declare const require: (moduleName: string) => any;
declare const __dirname: string;

import {
  analytics,
  configureAnalyticsProvider,
  type IAnalyticsProvider,
} from '../lib/analytics';
import { hasPermission } from '../services/admin-service';

const fs = require('fs');
const path = require('path');
const projectRoot = path.join(__dirname, '..');

jest.mock('../lib/supabase', () => ({
  supabase: {
    from: jest.fn(),
    rpc: jest.fn(),
    auth: { getUser: jest.fn() },
  },
}));

function read(relativePath: string): string {
  return fs.readFileSync(path.join(projectRoot, relativePath), 'utf8');
}

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

describe('user interaction reachability', () => {
  const welcome = read('app/(auth)/welcome.tsx');
  const learn = read('app/(tabs)/learn.tsx');
  const review = read('app/(tabs)/review.tsx');
  const profile = read('app/(tabs)/profile.tsx');

  it('does not give decorative cards or stat rings press feedback', () => {
    expect(welcome).not.toContain('scaleValue={0.98} activeOpacity={1}');
    expect(review).toContain('<View style={styles.topBarPill}>');
    expect(review).toContain(
      '<View style={[styles.ringCard, { backgroundColor: colors.card, borderColor: colors.border }]}>',
    );
  });

  it('gives every rendered pressable an action or forwarded action props', () => {
    const missingHandlers: string[] = [];
    const pressablePattern = /<(TouchableOpacity|Pressable|AnimatedPressable)\b((?:(?!>).)*)>/gs;

    for (const file of sourceFiles(['app', 'components'])) {
      const source = fs.readFileSync(file, 'utf8');
      for (const match of source.matchAll(pressablePattern)) {
        const attributes = match[2];
        if (!/\bonPress\s*=/.test(attributes) && !/\{\.\.\.props\}/.test(attributes)) {
          missingHandlers.push(path.relative(projectRoot, file));
        }
      }
    }

    expect(missingHandlers).toEqual([]);
  });

  it('expands the complete Learn journey and disables an unavailable hero', () => {
    expect(learn).toContain('setShowAllLessons');
    expect(learn).toContain("showAllLessons ? 'Thu gọn' : 'Xem tất cả'");
    expect(learn).toContain('disabled={!currentLesson}');
    expect(learn).toContain('visibleLessons?.map');
    expect(learn).toContain('getGamificationSummary');
    expect(learn).not.toContain("queryKey: ['today-xp']");
  });

  it('makes pronunciation, leaderboard, and shop reachable from primary screens', () => {
    expect(review).toContain("router.push('/pronunciation')");
    expect(profile).toContain("router.push('/gamification/leaderboard')");
    expect(profile).toContain("router.push('/gamification/shop')");

    const pronunciation = read('app/pronunciation/index.tsx');
    expect(pronunciation).toContain("router.push('/pronunciation/tone-training')");
    expect(pronunciation).toContain("router.push('/pronunciation/history')");
  });

  it('keeps every newly reachable pronunciation view retryable', () => {
    for (const route of [
      'app/pronunciation/index.tsx',
      'app/pronunciation/history.tsx',
      'app/pronunciation/tone-training.tsx',
    ]) {
      const source = read(route);
      expect(source).toContain('isError');
      expect(source).toContain('void refetch()');
    }
  });
});

describe('honest admin and analytics behavior', () => {
  afterEach(() => {
    configureAnalyticsProvider();
  });

  it('does not expose dummy one-click content creation', () => {
    const courses = read('app/admin/courses.tsx');
    const vocabulary = read('app/admin/vocabulary.tsx');

    expect(courses).not.toContain('createAdminItem');
    expect(courses).not.toContain('Khóa học mới');
    expect(vocabulary).not.toContain('createAdminItem');
    expect(vocabulary).not.toContain("chinese: '新词'");
  });

  it('aligns editor analytics visibility with the server permission', () => {
    expect(hasPermission('editor', 'view_analytics')).toBe(false);
    expect(hasPermission('admin', 'view_analytics')).toBe(true);
    expect(read('app/admin/analytics.tsx')).toContain('Không thể tải analytics');
  });

  it('searches vocabulary fields rather than nonexistent course fields', () => {
    const service = read('services/admin-service.ts');
    expect(service).toContain(
      'chinese.ilike.%${search}%,pinyin.ilike.%${search}%,meaning_vi.ilike.%${search}%',
    );
    expect(service).toContain("replace(/[,%()]/g, '')");
  });

  it('defaults analytics to silent and delegates only after configuration', () => {
    expect(() => {
      analytics.identify('private-user-id', { level: 2 });
      analytics.track('lesson_started', { lessonId: 'private-lesson-id' });
      analytics.reset();
    }).not.toThrow();

    const provider: IAnalyticsProvider = {
      track: jest.fn(),
      identify: jest.fn(),
      reset: jest.fn(),
    };
    configureAnalyticsProvider(provider);

    analytics.track('lesson_completed', { score: 90 });
    analytics.identify('user-id');
    analytics.reset();

    expect(provider.track).toHaveBeenCalledWith('lesson_completed', { score: 90 });
    expect(provider.identify).toHaveBeenCalledWith('user-id', undefined);
    expect(provider.reset).toHaveBeenCalled();
  });

  it('does not log client identity, audio URLs, or raw errors to consoles', () => {
    const offenders = sourceFiles([
      'app',
      'components',
      'hooks',
      'lib',
      'services',
      'stores',
    ]).filter((file) => /console\.(log|warn|error|debug)/.test(fs.readFileSync(file, 'utf8')));

    expect(offenders).toEqual([]);
  });
});
