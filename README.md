# Mandarin Master

Nền tảng học tiếng Trung toàn diện dành cho người Việt Nam.
Một codebase, chạy trên Web, Android và iOS.

## Tech Stack

- **Framework**: React Native + Expo SDK 57
- **Router**: Expo Router (file-based)
- **Backend**: Supabase (PostgreSQL, Auth, Storage)
- **State**: Zustand + TanStack Query
- **Language**: TypeScript (strict)

## Cài đặt

### Yêu cầu
- Node.js 18+
- npm hoặc yarn
- Expo CLI (`npm install -g expo-cli`)
- Tài khoản Supabase (miễn phí tại supabase.com)

### Bước 1: Clone & Install

```bash
cd mandarin-master
npm install
```

### Bước 2: Setup Supabase

1. Tạo project mới tại [supabase.com](https://supabase.com)
2. Vào SQL Editor, chạy lần lượt:
   - `supabase/migrations/001_initial_schema.sql`
   - `supabase/migrations/002_rls_policies.sql`
   - `supabase/seed/001_course_data.sql`

### Bước 3: Cấu hình Environment

```bash
cp .env.example .env
```

Mở `.env` và điền:
- `EXPO_PUBLIC_SUPABASE_URL` - URL project Supabase
- `EXPO_PUBLIC_SUPABASE_ANON_KEY` - Anon key từ Settings > API

### Bước 4: Chạy ứng dụng

```bash
# Web
npx expo start --web~

# Android (cần Android Emulator hoặc thiết bị thật)
npx expo start --android

# iOS (chỉ trên macOS, cần Xcode)
npx expo start --ios

# Hoặc chạy Expo Dev Server
npx expo start
```

## Cấu trúc dự án

```
mandarin-master/
├── app/                    # Pages (Expo Router)
│   ├── (auth)/            # Auth screens
│   ├── (tabs)/            # Main tabs
│   ├── lesson/            # Lesson engine
│   └── onboarding/        # Onboarding
├── components/            # Shared components
│   └── ui/               # Design system
├── constants/             # Theme, config
├── hooks/                 # Custom hooks
├── lib/                   # Core libraries
│   ├── supabase/         # Supabase client
│   ├── ai/              # AI abstraction
│   ├── speech/          # Speech abstraction
│   └── analytics/       # Analytics
├── stores/               # Zustand stores
├── types/                # TypeScript types
└── supabase/             # Database
    ├── migrations/       # SQL migrations
    └── seed/            # Seed data
```

## Scripts

```bash
npm run start        # Start Expo dev server
npm run web          # Start web version
npm run android      # Start Android
npm run ios          # Start iOS
npm run ts:check     # TypeScript type check
npm run build:web    # Build for web production
```

## Database

Schema đầy đủ tại `supabase/migrations/`.
Bao gồm 30+ tables với RLS policies, triggers, và indexes.

## Development Roadmap

Xem [ROADMAP.md](./ROADMAP.md) để biết tiến độ chi tiết.

## License

Private - All rights reserved.
