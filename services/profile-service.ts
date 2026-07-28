import type { Profile } from '@/types';

interface QueryResult {
  data: Profile | null;
  error: { message: string; code?: string } | null;
}

interface EnsureResult {
  error: { message: string; code?: string } | null;
}

interface ProfileLoaderDependencies {
  queryProfile: (userId: string) => Promise<QueryResult>;
  ensureCurrentUserProfile: () => Promise<EnsureResult>;
}

export class ProfileLoadError extends Error {
  readonly code?: string;

  constructor(message: string, code?: string) {
    super(message);
    this.name = 'ProfileLoadError';
    this.code = code;
  }
}

function throwQueryError(error: QueryResult['error']): never {
  throw new ProfileLoadError(
    error?.message ?? 'Không thể tải hồ sơ người dùng.',
    error?.code,
  );
}

export function createProfileLoader(dependencies: ProfileLoaderDependencies) {
  const inFlightByUser = new Map<string, Promise<Profile>>();

  return function loadProfile(userId: string): Promise<Profile> {
    const existingRequest = inFlightByUser.get(userId);
    if (existingRequest) {
      return existingRequest;
    }

    const request = (async () => {
      const firstQuery = await dependencies.queryProfile(userId);
      if (firstQuery.error) {
        throwQueryError(firstQuery.error);
      }

      if (firstQuery.data) {
        return firstQuery.data;
      }

      const ensureResult = await dependencies.ensureCurrentUserProfile();
      if (ensureResult.error) {
        throw new ProfileLoadError(
          ensureResult.error.message,
          ensureResult.error.code,
        );
      }

      const secondQuery = await dependencies.queryProfile(userId);
      if (secondQuery.error) {
        throwQueryError(secondQuery.error);
      }

      if (!secondQuery.data) {
        throw new ProfileLoadError(
          'Hồ sơ vẫn chưa tồn tại sau khi khôi phục. Vui lòng thử lại.',
          'PROFILE_NOT_PROVISIONED',
        );
      }

      return secondQuery.data;
    })();

    inFlightByUser.set(userId, request);
    void request.finally(() => {
      if (inFlightByUser.get(userId) === request) {
        inFlightByUser.delete(userId);
      }
    }).catch(() => {
      // The original request carries the error to every caller.
    });

    return request;
  };
}
