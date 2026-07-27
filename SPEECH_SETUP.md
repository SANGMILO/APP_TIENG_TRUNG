# Speech Service Setup Guide

## Azure Speech Service Configuration

### 1. Create Azure Speech Resource

1. Đăng nhập [Azure Portal](https://portal.azure.com)
2. Tạo resource mới: **Speech Services**
3. Chọn pricing tier: **Free (F0)** cho development (5000 calls/month)
4. Chọn region: **East Asia** (gần Việt Nam nhất)
5. Sau khi tạo xong, vào **Keys and Endpoint**
6. Copy **Key 1** và **Region**

### 2. Configure Environment

Trong Supabase Edge Functions environment (hoặc file `.env` cho local):

```
AZURE_SPEECH_KEY=your-key-1-here
AZURE_SPEECH_REGION=eastasia
```

**KHÔNG BAO GIỜ** đặt key này vào frontend. Nó chỉ được sử dụng bởi Edge Function server-side.

### 3. Deploy Edge Function

```bash
# Cài Supabase CLI
npm install -g supabase

# Login
supabase login

# Link project
supabase link --project-ref YOUR_PROJECT_REF

# Set secrets
supabase secrets set AZURE_SPEECH_KEY=your-key
supabase secrets set AZURE_SPEECH_REGION=eastasia

# Deploy function
supabase functions deploy pronunciation-assess
```

### 4. Test Endpoint

```bash
curl -X POST \
  https://YOUR_PROJECT.supabase.co/functions/v1/pronunciation-assess \
  -H "Authorization: Bearer YOUR_USER_JWT" \
  -H "Content-Type: application/json" \
  -d '{
    "audio": "BASE64_WAV_DATA",
    "referenceText": "你好",
    "locale": "zh-CN",
    "clientAttemptId": "test-001"
  }'
```

### 5. Expected Response

```json
{
  "result": {
    "overallScore": 87,
    "accuracyScore": 90,
    "fluencyScore": 84,
    "completenessScore": 100,
    "recognizedText": "你好",
    "expectedText": "你好",
    "words": [
      { "word": "你", "accuracyScore": 92, "errorType": "None" },
      { "word": "好", "accuracyScore": 88, "errorType": "None" }
    ],
    "provider": "azure",
    "durationMs": 1200,
    "assessedAt": "2024-01-01T00:00:00.000Z"
  }
}
```

### 6. Audio Format Requirements

Azure Speech Service accepts:
- WAV (PCM, 16kHz, mono, 16-bit) — **preferred**
- MP3
- OGG/Opus
- WebM (may need transcoding)

The app records in:
- iOS/Android: WAV 16kHz mono
- Web: WebM (may need server-side conversion)

### 7. Rate Limits

Default configuration:
- Free plan: 20 assessments/user/day
- Premium: configurable in database

### 8. Cost Estimation

Azure Speech free tier: 5,000 transactions/month
Standard tier: ~$1 per 1,000 transactions

### 9. Troubleshooting

| Error | Solution |
|-------|----------|
| 401 Unauthorized | Check AZURE_SPEECH_KEY is correct |
| Speech not detected | User should speak louder/closer to mic |
| Wrong language | Ensure locale is set to `zh-CN` |
| Audio too large | Max 5MB, typically < 1MB for speech |

### 10. Local Development Without Azure

If Azure key is not configured:
- App shows "Dịch vụ phát âm chưa được cấu hình"
- Recording still works (can test mic permission, recording, playback)
- Assessment returns `NOT_CONFIGURED` error code
- UI handles gracefully without crash
