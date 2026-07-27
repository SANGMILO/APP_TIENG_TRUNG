# Owner Action Required — Production Deployment

Bạn cần thực hiện các bước sau để đưa Mandarin Master vào hoạt động.
Không cần kiến thức lập trình cho hầu hết các bước.
Sử dụng terminal/command line cho các lệnh deploy.

---

## 1. SUPABASE (Bắt buộc)

### 1.1 Tạo Project
1. Đăng ký tại https://supabase.com
2. Tạo project mới (region: Singapore hoặc Southeast Asia)
3. Ghi lại:
   - Project URL (ví dụ: `https://abc123.supabase.co`)
   - Anon Key (trong Settings → API)
   - Service Role Key (trong Settings → API) — **KHÔNG chia sẻ**

### 1.2 Cập nhật .env
```
EXPO_PUBLIC_SUPABASE_URL=https://YOUR_PROJECT.supabase.co
EXPO_PUBLIC_SUPABASE_ANON_KEY=your-anon-key-here
```

### 1.3 Deploy Database
```bash
cd mandarin-master
npx supabase login
npx supabase link --project-ref YOUR_PROJECT_REF
npx supabase db push
```

### 1.4 Chạy Seed Data
Vào Supabase Dashboard → SQL Editor → chạy file:
`supabase/seed/001_course_data.sql`

### 1.5 Tạo Admin Account
1. Đăng ký tài khoản qua app
2. Vào Supabase Dashboard → Table Editor → profiles
3. Tìm user vừa đăng ký
4. Đổi `role` thành `super_admin`

---

## 2. OPENAI (Bắt buộc cho AI Tutor + Voice)

### 2.1 Lấy API Key
1. Đăng ký tại https://platform.openai.com
2. Tạo API Key tại API Keys section
3. Nạp credit (tối thiểu $5-10 cho testing)

### 2.2 Set Secret
```bash
npx supabase secrets set OPENAI_API_KEY=sk-your-key-here
npx supabase secrets set OPENAI_MODEL=gpt-4o-mini
npx supabase secrets set OPENAI_TTS_VOICE=alloy
```

---

## 3. AZURE SPEECH (Bắt buộc cho Pronunciation)

### 3.1 Tạo Resource
1. Đăng ký Azure tại https://portal.azure.com
2. Tạo "Speech Services" resource (Free F0 tier)
3. Region: East Asia
4. Lấy Key 1 từ Keys and Endpoint

### 3.2 Set Secret
```bash
npx supabase secrets set AZURE_SPEECH_KEY=your-key
npx supabase secrets set AZURE_SPEECH_REGION=eastasia
```

---

## 4. DEPLOY EDGE FUNCTIONS

```bash
npx supabase functions deploy pronunciation-assess
npx supabase functions deploy ai-tutor-chat
npx supabase functions deploy voice-transcribe
npx supabase functions deploy voice-synthesize
```

---

## 5. EXPO / EAS (Bắt buộc cho Android/iOS)

### 5.1 Setup
```bash
npm install -g eas-cli
eas login
eas init
```

### 5.2 Cập nhật eas.json
Thay `YOUR_EAS_PROJECT_ID` trong app.json bằng project ID thật.

### 5.3 Android Build
```bash
eas build --platform android --profile preview
```
Cài APK lên device thật để test.

### 5.4 iOS Build
```bash
eas build --platform ios --profile preview
```
Cần Apple Developer Account ($99/năm).

---

## 6. WEB DEPLOYMENT

### Option A: Expo Hosting
```bash
npx expo export --platform web
# Deploy dist/ folder
```

### Option B: Vercel/Netlify
Upload thư mục `dist/` sau khi build.
Cấu hình: SPA fallback (mọi route → index.html)

---

## 7. GOOGLE PLAY (Tùy chọn)

1. Google Play Developer Account ($25 one-time)
2. Tạo app trong Play Console
3. Upload AAB từ `eas build --platform android --profile production`
4. Điền: Data Safety, Privacy Policy URL, Delete Account URL

---

## 8. APP STORE (Tùy chọn)

1. Apple Developer Account ($99/năm)
2. App Store Connect → New App
3. Upload via TestFlight (EAS submit hoặc Transporter)
4. Điền: Privacy Policy, App Privacy, Review Notes

---

## QUAN TRỌNG — KHÔNG LÀM

- ❌ Không gửi API key qua chat/email
- ❌ Không commit .env có secret vào Git
- ❌ Không dùng Service Role Key ở frontend
- ❌ Không deploy production trước khi test preview build
- ❌ Không submit App Store trước khi TestFlight qua QA
