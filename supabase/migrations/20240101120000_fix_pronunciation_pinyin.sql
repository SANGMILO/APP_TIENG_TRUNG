-- Migration 013: Fix pronunciation_attempts.pinyin nullability
-- Pinyin is not always available (e.g. arbitrary text from AI tutor)
-- Allow NULL so pronunciation assessment can save without pinyin.

ALTER TABLE public.pronunciation_attempts
  ALTER COLUMN pinyin DROP NOT NULL;
