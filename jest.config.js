module.exports = {
  preset: 'ts-jest',
  testEnvironment: 'node',
  roots: ['<rootDir>/__tests__'],
  moduleNameMapper: {
    '^@/(.*)$': '<rootDir>/$1',
  },
  transform: {
    '^.+\\.tsx?$': ['ts-jest', {
      tsconfig: {
        strict: true,
        module: 'commonjs',
        esModuleInterop: true,
        moduleResolution: 'node',
        paths: { '@/*': ['./*'] },
        baseUrl: '.',
        types: ['jest'],
      },
    }],
  },
};
