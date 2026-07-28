-- Local Development Seed Data
-- This file runs AFTER migrations during `supabase db reset`
-- Since migration 20240101110000 already inserts this content,
-- all INSERTs use ON CONFLICT DO NOTHING to be safely idempotent.

-- Course
INSERT INTO courses (id, title, description, level, status, order_index) VALUES
  ('c0000000-0000-0000-0000-000000000001', 'Chinese From Zero', 'Khóa học tiếng Trung từ con số không dành cho người Việt Nam', 'starter', 'published', 1)
ON CONFLICT (id) DO NOTHING;

-- Unit 1
INSERT INTO units (id, course_id, title, description, order_index, status) VALUES
  ('a0000001-0000-0000-0000-000000000001', 'c0000000-0000-0000-0000-000000000001', 'Nhập môn tiếng Trung', 'Làm quen với tiếng Trung Quốc', 1, 'published')
ON CONFLICT (id) DO NOTHING;

-- Chapter 1
INSERT INTO chapters (id, unit_id, title, description, order_index, status) VALUES
  ('c0000002-0000-0000-0000-000000000001', 'a0000001-0000-0000-0000-000000000001', 'Chào hỏi', 'Học cách chào hỏi cơ bản', 1, 'published')
ON CONFLICT (id) DO NOTHING;

-- Lessons
INSERT INTO lessons (id, chapter_id, title, description, order_index, xp_reward, status, lesson_type, estimated_minutes) VALUES
  ('10000000-0000-0000-0000-000000000001', 'c0000002-0000-0000-0000-000000000001', '你好 - Xin chào', 'Học cách chào hỏi trong tiếng Trung', 1, 15, 'published', 'standard', 5),
  ('10000000-0000-0000-0000-000000000002', 'c0000002-0000-0000-0000-000000000001', '我叫... - Tôi tên là...', 'Học cách tự giới thiệu tên', 2, 15, 'published', 'standard', 5),
  ('10000000-0000-0000-0000-000000000003', 'c0000002-0000-0000-0000-000000000001', '数字 1-10 - Số đếm', 'Học số đếm từ 1 đến 10', 3, 15, 'published', 'standard', 7),
  ('10000000-0000-0000-0000-000000000004', 'c0000002-0000-0000-0000-000000000001', '声调 - Thanh điệu', 'Học 4 thanh điệu tiếng Trung', 4, 20, 'published', 'standard', 8),
  ('10000000-0000-0000-0000-000000000005', 'c0000002-0000-0000-0000-000000000001', '自我介绍 - Tự giới thiệu', 'Thực hành giới thiệu bản thân', 5, 20, 'published', 'standard', 10)
ON CONFLICT (id) DO NOTHING;

-- Vocabulary
INSERT INTO vocabulary (id, chinese, pinyin, meaning_vi, meaning_en, level, category, example_sentence, example_pinyin, example_meaning, hsk_level, status) VALUES
  ('f0000000-0000-0000-0000-000000000001', '你', 'nǐ', 'bạn, anh/chị', 'you', 'starter', 'greetings', '你好！', 'nǐ hǎo!', 'Xin chào!', 1, 'published'),
  ('f0000000-0000-0000-0000-000000000002', '好', 'hǎo', 'tốt, được', 'good', 'starter', 'greetings', '很好！', 'hěn hǎo!', 'Rất tốt!', 1, 'published'),
  ('f0000000-0000-0000-0000-000000000003', '你好', 'nǐ hǎo', 'xin chào', 'hello', 'starter', 'greetings', '你好，我叫小明。', 'nǐ hǎo, wǒ jiào xiǎo míng.', 'Xin chào, tôi tên Tiểu Minh.', 1, 'published'),
  ('f0000000-0000-0000-0000-000000000004', '我', 'wǒ', 'tôi', 'I/me', 'starter', 'pronouns', '我是学生。', 'wǒ shì xuéshēng.', 'Tôi là học sinh.', 1, 'published'),
  ('f0000000-0000-0000-0000-000000000005', '叫', 'jiào', 'gọi là, tên là', 'to be called', 'starter', 'greetings', '你叫什么名字？', 'nǐ jiào shénme míngzì?', 'Bạn tên gì?', 1, 'published'),
  ('f0000000-0000-0000-0000-000000000006', '是', 'shì', 'là', 'to be', 'starter', 'grammar', '我是越南人。', 'wǒ shì yuènán rén.', 'Tôi là người Việt Nam.', 1, 'published'),
  ('f0000000-0000-0000-0000-000000000007', '什么', 'shénme', 'cái gì, gì', 'what', 'starter', 'question', '这是什么？', 'zhè shì shénme?', 'Đây là cái gì?', 1, 'published'),
  ('f0000000-0000-0000-0000-000000000008', '名字', 'míngzì', 'tên', 'name', 'starter', 'greetings', '我的名字是小红。', 'wǒ de míngzì shì xiǎo hóng.', 'Tên tôi là Tiểu Hồng.', 1, 'published'),
  ('f0000000-0000-0000-0000-000000000009', '再见', 'zàijiàn', 'tạm biệt', 'goodbye', 'starter', 'greetings', '明天见！再见！', 'míngtiān jiàn! zàijiàn!', 'Ngày mai gặp! Tạm biệt!', 1, 'published'),
  ('f0000000-0000-0000-0000-000000000010', '谢谢', 'xièxiè', 'cảm ơn', 'thank you', 'starter', 'greetings', '谢谢你！', 'xièxiè nǐ!', 'Cảm ơn bạn!', 1, 'published'),
  ('f0000000-0000-0000-0000-000000000011', '一', 'yī', 'một', 'one', 'starter', 'numbers', '一个人', 'yī gè rén', 'một người', 1, 'published'),
  ('f0000000-0000-0000-0000-000000000012', '二', 'èr', 'hai', 'two', 'starter', 'numbers', '二月', 'èr yuè', 'tháng hai', 1, 'published'),
  ('f0000000-0000-0000-0000-000000000013', '三', 'sān', 'ba', 'three', 'starter', 'numbers', '三天', 'sān tiān', 'ba ngày', 1, 'published'),
  ('f0000000-0000-0000-0000-000000000014', '四', 'sì', 'bốn', 'four', 'starter', 'numbers', '四个月', 'sì gè yuè', 'bốn tháng', 1, 'published'),
  ('f0000000-0000-0000-0000-000000000015', '五', 'wǔ', 'năm', 'five', 'starter', 'numbers', '五年', 'wǔ nián', 'năm năm', 1, 'published'),
  ('f0000000-0000-0000-0000-000000000016', '六', 'liù', 'sáu', 'six', 'starter', 'numbers', '六点', 'liù diǎn', 'sáu giờ', 1, 'published'),
  ('f0000000-0000-0000-0000-000000000017', '七', 'qī', 'bảy', 'seven', 'starter', 'numbers', '七月', 'qī yuè', 'tháng bảy', 1, 'published'),
  ('f0000000-0000-0000-0000-000000000018', '八', 'bā', 'tám', 'eight', 'starter', 'numbers', '八号', 'bā hào', 'ngày tám', 1, 'published'),
  ('f0000000-0000-0000-0000-000000000019', '九', 'jiǔ', 'chín', 'nine', 'starter', 'numbers', '九块钱', 'jiǔ kuài qián', 'chín đồng', 1, 'published'),
  ('f0000000-0000-0000-0000-000000000020', '十', 'shí', 'mười', 'ten', 'starter', 'numbers', '十分钟', 'shí fēnzhōng', 'mười phút', 1, 'published')
ON CONFLICT (id) DO NOTHING;

-- Lesson-Vocabulary links
INSERT INTO lesson_vocabulary (lesson_id, vocabulary_id, order_index) VALUES
  ('10000000-0000-0000-0000-000000000001', 'f0000000-0000-0000-0000-000000000001', 1),
  ('10000000-0000-0000-0000-000000000001', 'f0000000-0000-0000-0000-000000000002', 2),
  ('10000000-0000-0000-0000-000000000001', 'f0000000-0000-0000-0000-000000000003', 3),
  ('10000000-0000-0000-0000-000000000001', 'f0000000-0000-0000-0000-000000000009', 4),
  ('10000000-0000-0000-0000-000000000001', 'f0000000-0000-0000-0000-000000000010', 5),
  ('10000000-0000-0000-0000-000000000002', 'f0000000-0000-0000-0000-000000000004', 1),
  ('10000000-0000-0000-0000-000000000002', 'f0000000-0000-0000-0000-000000000005', 2),
  ('10000000-0000-0000-0000-000000000002', 'f0000000-0000-0000-0000-000000000006', 3),
  ('10000000-0000-0000-0000-000000000002', 'f0000000-0000-0000-0000-000000000007', 4),
  ('10000000-0000-0000-0000-000000000002', 'f0000000-0000-0000-0000-000000000008', 5),
  ('10000000-0000-0000-0000-000000000003', 'f0000000-0000-0000-0000-000000000011', 1),
  ('10000000-0000-0000-0000-000000000003', 'f0000000-0000-0000-0000-000000000012', 2),
  ('10000000-0000-0000-0000-000000000003', 'f0000000-0000-0000-0000-000000000013', 3),
  ('10000000-0000-0000-0000-000000000003', 'f0000000-0000-0000-0000-000000000014', 4),
  ('10000000-0000-0000-0000-000000000003', 'f0000000-0000-0000-0000-000000000015', 5),
  ('10000000-0000-0000-0000-000000000003', 'f0000000-0000-0000-0000-000000000016', 6),
  ('10000000-0000-0000-0000-000000000003', 'f0000000-0000-0000-0000-000000000017', 7),
  ('10000000-0000-0000-0000-000000000003', 'f0000000-0000-0000-0000-000000000018', 8),
  ('10000000-0000-0000-0000-000000000003', 'f0000000-0000-0000-0000-000000000019', 9),
  ('10000000-0000-0000-0000-000000000003', 'f0000000-0000-0000-0000-000000000020', 10)
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

-- Exercises
INSERT INTO exercises (id, lesson_id, exercise_type, order_index, question, correct_answer, explanation, data) VALUES
  ('e0000000-0000-0000-0000-000000000001', '10000000-0000-0000-0000-000000000001', 'vocabulary', 1, '学习新词 - Học từ mới', '你好', 'Đây là cách chào hỏi phổ biến nhất trong tiếng Trung', '{"chinese": "你好", "pinyin": "nǐ hǎo", "meaning": "Xin chào"}'::jsonb),
  ('e0000000-0000-0000-0000-000000000002', '10000000-0000-0000-0000-000000000001', 'multiple_choice', 2, '"你好" có nghĩa là gì?', 'Xin chào', '你好 (nǐ hǎo) là cách chào hỏi cơ bản nhất', '{"type": "meaning"}'::jsonb),
  ('e0000000-0000-0000-0000-000000000003', '10000000-0000-0000-0000-000000000001', 'listening', 3, 'Nghe và chọn từ đúng', '你好', 'Lắng nghe âm thanh và chọn từ tương ứng', '{"audio_text": "你好", "audio_pinyin": "nǐ hǎo"}'::jsonb),
  ('e0000000-0000-0000-0000-000000000004', '10000000-0000-0000-0000-000000000001', 'translation', 4, 'Dịch sang tiếng Trung: "Xin chào"', '你好', '你好 = Xin chào', '{"source_lang": "vi", "target_lang": "zh", "acceptable_answers": ["你好", "你好！"]}'::jsonb),
  ('e0000000-0000-0000-0000-000000000005', '10000000-0000-0000-0000-000000000001', 'sentence_builder', 5, 'Sắp xếp thành câu hoàn chỉnh', '你好，再见！', 'Sắp xếp các từ theo đúng thứ tự', '{"words": ["再见", "你好", "，", "！"], "correct_order": ["你好", "，", "再见", "！"]}'::jsonb),
  ('e0000000-0000-0000-0000-000000000006', '10000000-0000-0000-0000-000000000001', 'speaking', 6, 'Phát âm: 你好 (nǐ hǎo)', '你好', 'Hãy phát âm rõ ràng, chú ý thanh điệu: nǐ (thanh 3) hǎo (thanh 3)', '{"text": "你好", "pinyin": "nǐ hǎo", "expected_tones": [3, 3]}'::jsonb)
ON CONFLICT (id) DO NOTHING;

-- Exercise options already inserted by migration 20240101110000
-- No seed needed for exercise_options

-- Achievements (config)
INSERT INTO achievements (
  id,
  key,
  title,
  description,
  icon,
  category,
  requirement_type,
  requirement_value,
  xp_reward,
  coin_reward,
  is_hidden
) VALUES
  ('a0000000-0000-0000-0000-000000000001', 'first_lesson', 'Bài học đầu tiên', 'Hoàn thành bài học đầu tiên', '🎓', 'lesson', 'lessons_completed', 1, 10, 5, TRUE),
  ('a0000000-0000-0000-0000-000000000002', 'xp_100', '100 XP', 'Đạt 100 điểm kinh nghiệm', '⚡', 'xp', 'total_xp', 100, 20, 10, FALSE),
  ('a0000000-0000-0000-0000-000000000003', 'xp_1000', '1000 XP', 'Đạt 1000 điểm kinh nghiệm', '🌟', 'xp', 'total_xp', 1000, 50, 25, FALSE),
  ('a0000000-0000-0000-0000-000000000004', 'streak_7', '7 ngày liên tục', 'Học 7 ngày không nghỉ', '🔥', 'streak', 'streak_days', 7, 30, 15, FALSE),
  ('a0000000-0000-0000-0000-000000000005', 'streak_30', '30 ngày liên tục', 'Học 30 ngày không nghỉ', '💪', 'streak', 'streak_days', 30, 100, 50, FALSE),
  ('a0000000-0000-0000-0000-000000000006', 'words_100', '100 từ vựng', 'Học được 100 từ', '📚', 'vocabulary', 'words_learned', 100, 40, 20, TRUE),
  ('a0000000-0000-0000-0000-000000000007', 'words_500', '500 từ vựng', 'Học được 500 từ', '🏆', 'vocabulary', 'words_learned', 500, 100, 50, TRUE),
  ('a0000000-0000-0000-0000-000000000008', 'perfect_lesson', 'Hoàn hảo', 'Hoàn thành 1 bài không sai', '💯', 'lesson', 'perfect_lessons', 1, 15, 10, TRUE),
  ('a0000000-0000-0000-0000-000000000009', 'pronunciation_master', 'Phát âm chuẩn', 'Đạt 95+ điểm phát âm', '🎤', 'speaking', 'pronunciation_score', 95, 30, 15, TRUE),
  ('a0000000-0000-0000-0000-000000000010', 'listening_master', 'Thính giác tốt', 'Trả lời đúng 50 bài nghe', '👂', 'listening', 'listening_correct', 50, 30, 15, TRUE)
ON CONFLICT (id) DO UPDATE
SET is_hidden = EXCLUDED.is_hidden;

-- Daily quests (config)
INSERT INTO daily_quests (id, title, description, quest_type, requirement_value, xp_reward, coin_reward) VALUES
  ('d0000000-0000-0000-0000-000000000001', 'Học 1 bài', 'Hoàn thành 1 bài học', 'lessons_completed', 1, 15, 3),
  ('d0000000-0000-0000-0000-000000000002', 'Ôn 5 từ', 'Ôn tập 5 từ vựng', 'words_reviewed', 5, 10, 2),
  ('d0000000-0000-0000-0000-000000000003', 'Luyện nói', 'Hoàn thành 1 bài phát âm', 'speaking_exercises', 1, 20, 5),
  ('d0000000-0000-0000-0000-000000000004', 'Đạt 30 XP', 'Thu thập 30 XP trong ngày', 'daily_xp', 30, 10, 3)
ON CONFLICT (id) DO NOTHING;
