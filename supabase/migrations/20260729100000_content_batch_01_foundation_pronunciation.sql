-- Generated from content/manifests/01_foundation_pronunciation.json.
-- Do not hand-edit this migration; edit the manifest and regenerate.
-- Additive and idempotent: deterministic IDs plus ON CONFLICT DO NOTHING.

BEGIN;

-- Correct a known non-functional legacy exercise while preserving its ID and attempts.
UPDATE public.exercises
SET
  exercise_type = 'multiple_choice',
  question = 'Chọn pinyin đúng của “你好”.',
  correct_answer = 'nǐ hǎo',
  explanation = '你好 đọc là nǐ hǎo: cả hai âm tiết đều mang thanh 3 ở dạng từ điển.',
  data = '{"activity_type":"pronunciation_choice","legacy_audio_repair":true}'::JSONB,
  updated_at = NOW()
WHERE id = 'e0000000-0000-0000-0000-000000000003'::UUID
  AND exercise_type = 'listening'
  AND question_audio_url IS NULL;

UPDATE public.exercise_options
SET text = 'nǐ hǎo', is_correct = TRUE
WHERE exercise_id = 'e0000000-0000-0000-0000-000000000003'::UUID AND order_index = 1;

UPDATE public.exercise_options
SET text = 'nǐ hào', is_correct = FALSE
WHERE exercise_id = 'e0000000-0000-0000-0000-000000000003'::UUID AND order_index = 2;

UPDATE public.exercise_options
SET text = 'ní hǎo', is_correct = FALSE
WHERE exercise_id = 'e0000000-0000-0000-0000-000000000003'::UUID AND order_index = 3;

UPDATE public.exercise_options
SET text = 'nì hǎo', is_correct = FALSE
WHERE exercise_id = 'e0000000-0000-0000-0000-000000000003'::UUID AND order_index = 4;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('154744f8-d882-53de-8a0d-8f9848d9490c'::UUID, '10000000-0000-0000-0000-000000000001'::UUID, 'f0000000-0000-0000-0000-000000000001'::UUID, 1, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('46c266d7-9b89-5bb1-9ad0-a21db897c1c7'::UUID, '10000000-0000-0000-0000-000000000001'::UUID, 'f0000000-0000-0000-0000-000000000002'::UUID, 2, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('98efb785-2eba-5c0c-aa14-26713170d393'::UUID, '10000000-0000-0000-0000-000000000001'::UUID, 'f0000000-0000-0000-0000-000000000003'::UUID, 3, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('5824ce30-7547-53cc-908f-973922cfa023'::UUID, '10000000-0000-0000-0000-000000000001'::UUID, 'f0000000-0000-0000-0000-000000000009'::UUID, 4, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('b47ed3ca-46b4-59f4-b560-a4fa19979030'::UUID, '10000000-0000-0000-0000-000000000001'::UUID, 'f0000000-0000-0000-0000-000000000010'::UUID, 5, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.grammar_lessons (id, content_key, title, pattern, explanation, example_chinese, example_pinyin, example_meaning, level, status, usage_note, content_version)
VALUES ('2df08b1e-075e-5550-83fa-5b649bdc5670'::UUID, 'foundation:greeting-sequence', 'Trình tự chào hỏi', '你好 + thông tin mở đầu', 'Dùng 你好 để mở đầu, sau đó mới nói tên hoặc mục đích giao tiếp.', '你好，我叫安。', 'Nǐ hǎo, wǒ jiào Ān.', 'Xin chào, tôi tên An.', 'starter', 'published', 'Không dùng 再见 để mở đầu cuộc gặp.', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_grammar (id, lesson_id, grammar_lesson_id, order_index, curriculum_role)
VALUES ('1b2afa16-fe64-54d7-b398-a399f24036ea'::UUID, '10000000-0000-0000-0000-000000000001'::UUID, '2df08b1e-075e-5550-83fa-5b649bdc5670'::UUID, 1, 'introduced')
ON CONFLICT (lesson_id, grammar_lesson_id) DO NOTHING;

INSERT INTO public.characters (id, character, pinyin, meaning_vi, radical, stroke_count, stroke_order, level, status, component_breakdown, common_words, content_version)
VALUES ('9a8bfa8f-c6d0-5db3-86ee-4d3a970c413f'::UUID, '你', 'nǐ', 'bạn', '亻', 7, NULL, 'starter', 'published', '{"left":"亻 (người)","right":"尔 (gợi âm)"}'::JSONB, '["你好","你们"]'::JSONB, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_characters (id, lesson_id, character_id, order_index, curriculum_role)
VALUES ('5c3b8143-b093-5c90-bea6-cf95a9601fa9'::UUID, '10000000-0000-0000-0000-000000000001'::UUID, '9a8bfa8f-c6d0-5db3-86ee-4d3a970c413f'::UUID, 1, 'introduced')
ON CONFLICT (lesson_id, character_id) DO NOTHING;

INSERT INTO public.characters (id, character, pinyin, meaning_vi, radical, stroke_count, stroke_order, level, status, component_breakdown, common_words, content_version)
VALUES ('6a952254-d816-5b43-940b-a9b12223be3c'::UUID, '好', 'hǎo', 'tốt', '女', 6, NULL, 'starter', 'published', '{"left":"女","right":"子"}'::JSONB, '["你好","好吃"]'::JSONB, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_characters (id, lesson_id, character_id, order_index, curriculum_role)
VALUES ('a7c4ded7-31dd-5c43-b084-c772bce3fccf'::UUID, '10000000-0000-0000-0000-000000000001'::UUID, '6a952254-d816-5b43-940b-a9b12223be3c'::UUID, 2, 'introduced')
ON CONFLICT (lesson_id, character_id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('d0258bd8-45bb-5e16-90f1-57b290b249c4'::UUID, '10000000-0000-0000-0000-000000000001'::UUID, 'vocabulary', 7, 'Từ mới: 你', NULL, '你', '你 (nǐ) — bạn, anh/chị. 你好吗？', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"foundation:你","chinese":"你","pinyin":"nǐ","meaning":"bạn, anh/chị","part_of_speech":"đại từ","example_chinese":"你好吗？","example_pinyin":"Nǐ hǎo ma?","example_meaning_vi":"Bạn có khỏe không?"}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('5e2b863c-2323-529f-a636-020c99fcb7d6'::UUID, '10000000-0000-0000-0000-000000000001'::UUID, 'vocabulary', 8, 'Từ mới: 好', NULL, '好', '好 (hǎo) — tốt, khỏe. 我很好。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"foundation:好","chinese":"好","pinyin":"hǎo","meaning":"tốt, khỏe","part_of_speech":"tính từ","example_chinese":"我很好。","example_pinyin":"Wǒ hěn hǎo.","example_meaning_vi":"Tôi rất khỏe."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('0fadf4a5-1507-5974-bf65-f0c84831321a'::UUID, '10000000-0000-0000-0000-000000000001'::UUID, 'vocabulary', 9, 'Từ mới: 你好', NULL, '你好', '你好 (nǐ hǎo) — xin chào. 你好，我叫小明。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"foundation:你好","chinese":"你好","pinyin":"nǐ hǎo","meaning":"xin chào","part_of_speech":"cụm từ","example_chinese":"你好，我叫小明。","example_pinyin":"Nǐ hǎo, wǒ jiào Xiǎomíng.","example_meaning_vi":"Xin chào, tôi tên là Tiểu Minh."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('b38bebfa-65ef-538d-a739-de3aa2618ad0'::UUID, '10000000-0000-0000-0000-000000000001'::UUID, 'vocabulary', 10, 'Từ mới: 再见', NULL, '再见', '再见 (zàijiàn) — tạm biệt. 明天见，再见！', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"foundation:再见","chinese":"再见","pinyin":"zàijiàn","meaning":"tạm biệt","part_of_speech":"cụm từ","example_chinese":"明天见，再见！","example_pinyin":"Míngtiān jiàn, zàijiàn!","example_meaning_vi":"Hẹn gặp ngày mai, tạm biệt!"}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('b9ebf219-5402-5696-988b-33e7ff235fb2'::UUID, '10000000-0000-0000-0000-000000000001'::UUID, 'vocabulary', 11, 'Từ mới: 谢谢', NULL, '谢谢', '谢谢 (xièxie) — cảm ơn. 谢谢你的帮助。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"foundation:谢谢","chinese":"谢谢","pinyin":"xièxie","meaning":"cảm ơn","part_of_speech":"động từ","example_chinese":"谢谢你的帮助。","example_pinyin":"Xièxie nǐ de bāngzhù.","example_meaning_vi":"Cảm ơn sự giúp đỡ của bạn."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('b8a3ae38-0643-5116-b3be-7f0575a17069'::UUID, '10000000-0000-0000-0000-000000000001'::UUID, 'multiple_choice', 12, '“你好” có nghĩa phù hợp nhất là gì?', NULL, 'xin chào', '你好 (nǐ hǎo) nghĩa là “xin chào”.', NULL, 1, '{"activity_type":"chinese_to_vietnamese","vocabulary_key":"foundation:你好"}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('48f633ec-8940-5b7b-b004-01c3108ec393'::UUID, 'b8a3ae38-0643-5116-b3be-7f0575a17069'::UUID, 'tạm biệt', FALSE, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('13f69498-e64a-5041-a374-4b210643975e'::UUID, 'b8a3ae38-0643-5116-b3be-7f0575a17069'::UUID, 'cảm ơn', FALSE, 2)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('7ca89710-9f13-5c89-a28a-4d55428b02fe'::UUID, 'b8a3ae38-0643-5116-b3be-7f0575a17069'::UUID, 'tốt, khỏe', FALSE, 3)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('973a4910-1a66-56e8-b921-d4c13f760800'::UUID, 'b8a3ae38-0643-5116-b3be-7f0575a17069'::UUID, 'xin chào', TRUE, 4)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('a8668f83-9762-55f1-9fd0-179d2af50092'::UUID, '10000000-0000-0000-0000-000000000001'::UUID, 'translation', 13, 'Dịch sang tiếng Trung: “Xin chào, tôi tên là Tiểu Minh.”', NULL, '你好，我叫小明。', 'Mẫu câu dùng “你好” trong ngữ cảnh của bài.', 'nǐ hǎo', 1, '{"activity_type":"vietnamese_to_chinese","source_lang":"vi","target_lang":"zh","acceptable_answers":["你好，我叫小明。"]}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('b2a48976-6f54-53ae-b136-17ac22a8d3c7'::UUID, '10000000-0000-0000-0000-000000000001'::UUID, 'sentence_builder', 14, 'Sắp xếp các thành phần thành câu đúng.', NULL, '你好，我叫小明。', 'Trật tự đúng tạo thành câu “你好，我叫小明。”.', NULL, 1, '{"activity_type":"sentence_ordering","words":["你好","，","我","叫","小明","。"],"correct_order":["你好","，","我","叫","小明","。"]}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('874552a5-ad5d-5193-abd7-6cf5bb32a5fa'::UUID, '10000000-0000-0000-0000-000000000001'::UUID, 'multiple_choice', 15, 'Câu nào mở đầu một lời giới thiệu tự nhiên?', NULL, '你好，我叫安。', '你好 mở đầu cuộc gặp; 再见 dùng khi chia tay.', NULL, 1, '{"activity_type":"grammar_selection","passage":null,"grammar_key":"foundation:greeting-sequence"}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('42a6aea8-07b3-57f1-8049-4406f712b7f9'::UUID, '874552a5-ad5d-5193-abd7-6cf5bb32a5fa'::UUID, '你好，我叫安。', TRUE, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('1a984081-6dfb-58f2-ad79-305e4f3c9ad3'::UUID, '874552a5-ad5d-5193-abd7-6cf5bb32a5fa'::UUID, '再见，我叫安。', FALSE, 2)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('1bc392c0-ca3f-5e2c-bd89-5218150ae707'::UUID, '874552a5-ad5d-5193-abd7-6cf5bb32a5fa'::UUID, '谢谢，我叫安。', FALSE, 3)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('6c69a6d3-084a-5c1e-bfe2-6f1474b4e70a'::UUID, '10000000-0000-0000-0000-000000000001'::UUID, 'speaking', 16, 'Đọc thành tiếng: 你好，我叫小明。', NULL, '你好，我叫小明。', 'Đọc chậm, giữ đúng thanh điệu và nhịp của cả câu.', NULL, 1, '{"activity_type":"pronunciation","text":"你好，我叫小明。","pinyin":"Nǐ hǎo, wǒ jiào Xiǎomíng."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('aa290fcf-038a-56a5-b2af-f72db5c62542'::UUID, '10000000-0000-0000-0000-000000000002'::UUID, 'f0000000-0000-0000-0000-000000000004'::UUID, 1, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('c838785d-7d21-5a6a-8c78-757f9b58820e'::UUID, '10000000-0000-0000-0000-000000000002'::UUID, 'f0000000-0000-0000-0000-000000000005'::UUID, 2, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('f0ae8806-c15b-5570-996f-fcf6ccfc8550'::UUID, '10000000-0000-0000-0000-000000000002'::UUID, 'f0000000-0000-0000-0000-000000000006'::UUID, 3, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('1442d931-c5f3-519c-85c7-694f74022670'::UUID, '10000000-0000-0000-0000-000000000002'::UUID, 'f0000000-0000-0000-0000-000000000007'::UUID, 4, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('7403af88-76be-501c-b12f-3f78c7ab7eed'::UUID, '10000000-0000-0000-0000-000000000002'::UUID, 'f0000000-0000-0000-0000-000000000008'::UUID, 5, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('c551c58e-42c4-57de-b5f9-f9abb3012622'::UUID, '10000000-0000-0000-0000-000000000002'::UUID, 'f0000000-0000-0000-0000-000000000001'::UUID, 6, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('a7d8dbaf-9aed-5acd-8c35-a7e785ad3824'::UUID, '10000000-0000-0000-0000-000000000002'::UUID, 'f0000000-0000-0000-0000-000000000002'::UUID, 7, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('953340d9-624a-562e-9844-da2eada293b5'::UUID, '10000000-0000-0000-0000-000000000002'::UUID, 'f0000000-0000-0000-0000-000000000003'::UUID, 8, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('70e568ee-e281-5288-a1c3-ad6d3d0ceecb'::UUID, '10000000-0000-0000-0000-000000000002'::UUID, 'f0000000-0000-0000-0000-000000000009'::UUID, 9, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('27977992-b762-596f-826a-95aa6a2f4663'::UUID, '10000000-0000-0000-0000-000000000002'::UUID, 'f0000000-0000-0000-0000-000000000010'::UUID, 10, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.grammar_lessons (id, content_key, title, pattern, explanation, example_chinese, example_pinyin, example_meaning, level, status, usage_note, content_version)
VALUES ('cc829157-96aa-55c6-823c-ab112447cf96'::UUID, 'foundation:called-name', 'Nói tên với 叫', 'Chủ ngữ + 叫 + tên', '叫 đứng trước tên khi giới thiệu một người được gọi là gì.', '我叫兰。', 'Wǒ jiào Lán.', 'Tôi tên Lan.', 'starter', 'published', 'Không thêm 是 giữa 叫 và tên.', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_grammar (id, lesson_id, grammar_lesson_id, order_index, curriculum_role)
VALUES ('364eb3e2-83b1-5638-9da5-31c178757d98'::UUID, '10000000-0000-0000-0000-000000000002'::UUID, 'cc829157-96aa-55c6-823c-ab112447cf96'::UUID, 1, 'introduced')
ON CONFLICT (lesson_id, grammar_lesson_id) DO NOTHING;

INSERT INTO public.lesson_grammar (id, lesson_id, grammar_lesson_id, order_index, curriculum_role)
VALUES ('032e67ad-9222-516a-951f-394e39a37057'::UUID, '10000000-0000-0000-0000-000000000002'::UUID, '2df08b1e-075e-5550-83fa-5b649bdc5670'::UUID, 2, 'review')
ON CONFLICT (lesson_id, grammar_lesson_id) DO NOTHING;

INSERT INTO public.characters (id, character, pinyin, meaning_vi, radical, stroke_count, stroke_order, level, status, component_breakdown, common_words, content_version)
VALUES ('9fb58e63-8f87-5714-93d6-5f5a3f752cf4'::UUID, '我', 'wǒ', 'tôi', '戈', 7, NULL, 'starter', 'published', '{"note":"Chữ độc thể; học theo thứ tự nét chuẩn."}'::JSONB, '["我们","自我"]'::JSONB, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_characters (id, lesson_id, character_id, order_index, curriculum_role)
VALUES ('540c9e5e-232c-5973-bdc3-2a61ccd007bc'::UUID, '10000000-0000-0000-0000-000000000002'::UUID, '9fb58e63-8f87-5714-93d6-5f5a3f752cf4'::UUID, 1, 'introduced')
ON CONFLICT (lesson_id, character_id) DO NOTHING;

INSERT INTO public.lesson_characters (id, lesson_id, character_id, order_index, curriculum_role)
VALUES ('3e98c7f6-4e40-58a9-a91d-fd123676235e'::UUID, '10000000-0000-0000-0000-000000000002'::UUID, '9a8bfa8f-c6d0-5db3-86ee-4d3a970c413f'::UUID, 2, 'review')
ON CONFLICT (lesson_id, character_id) DO NOTHING;

INSERT INTO public.lesson_characters (id, lesson_id, character_id, order_index, curriculum_role)
VALUES ('dfef493f-4269-5103-a2b9-fb192340cdee'::UUID, '10000000-0000-0000-0000-000000000002'::UUID, '6a952254-d816-5b43-940b-a9b12223be3c'::UUID, 3, 'review')
ON CONFLICT (lesson_id, character_id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('376e78a1-1a6b-50e5-9fda-8e0581ea9216'::UUID, '10000000-0000-0000-0000-000000000002'::UUID, 'vocabulary', 1, 'Từ mới: 我', NULL, '我', '我 (wǒ) — tôi. 我是学生。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"foundation:我","chinese":"我","pinyin":"wǒ","meaning":"tôi","part_of_speech":"đại từ","example_chinese":"我是学生。","example_pinyin":"Wǒ shì xuésheng.","example_meaning_vi":"Tôi là học sinh."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('55216da1-1994-5bc6-8bfb-360ec1f29c3c'::UUID, '10000000-0000-0000-0000-000000000002'::UUID, 'vocabulary', 2, 'Từ mới: 叫', NULL, '叫', '叫 (jiào) — gọi là, tên là. 我叫兰。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"foundation:叫","chinese":"叫","pinyin":"jiào","meaning":"gọi là, tên là","part_of_speech":"động từ","example_chinese":"我叫兰。","example_pinyin":"Wǒ jiào Lán.","example_meaning_vi":"Tôi tên Lan."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('566fe4f0-e69f-50e2-9f38-7e482bbd61e5'::UUID, '10000000-0000-0000-0000-000000000002'::UUID, 'vocabulary', 3, 'Từ mới: 是', NULL, '是', '是 (shì) — là. 他是老师。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"foundation:是","chinese":"是","pinyin":"shì","meaning":"là","part_of_speech":"động từ","example_chinese":"他是老师。","example_pinyin":"Tā shì lǎoshī.","example_meaning_vi":"Anh ấy là giáo viên."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('0994dc28-f663-5264-94ee-9cc0a4cffbd4'::UUID, '10000000-0000-0000-0000-000000000002'::UUID, 'vocabulary', 4, 'Từ mới: 什么', NULL, '什么', '什么 (shénme) — gì, cái gì. 这是什么？', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"foundation:什么","chinese":"什么","pinyin":"shénme","meaning":"gì, cái gì","part_of_speech":"đại từ nghi vấn","example_chinese":"这是什么？","example_pinyin":"Zhè shì shénme?","example_meaning_vi":"Đây là gì?"}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('0cda4f86-1a08-5bfc-a01c-28cce9ec9abc'::UUID, '10000000-0000-0000-0000-000000000002'::UUID, 'vocabulary', 5, 'Từ mới: 名字', NULL, '名字', '名字 (míngzi) — tên. 你的名字是什么？', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"foundation:名字","chinese":"名字","pinyin":"míngzi","meaning":"tên","part_of_speech":"danh từ","example_chinese":"你的名字是什么？","example_pinyin":"Nǐ de míngzi shì shénme?","example_meaning_vi":"Tên bạn là gì?"}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('de6e0996-e9c9-5446-8cb1-60440a277716'::UUID, '10000000-0000-0000-0000-000000000002'::UUID, 'multiple_choice', 6, '“名字” có nghĩa phù hợp nhất là gì?', NULL, 'tên', '名字 (míngzi) nghĩa là “tên”.', NULL, 1, '{"activity_type":"chinese_to_vietnamese","vocabulary_key":"foundation:名字"}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('96aa9dcc-ea57-5484-982f-914f12b50b92'::UUID, 'de6e0996-e9c9-5446-8cb1-60440a277716'::UUID, 'tôi', FALSE, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('397f9e69-1db3-5163-b267-36c5a2be6790'::UUID, 'de6e0996-e9c9-5446-8cb1-60440a277716'::UUID, 'gọi là, tên là', FALSE, 2)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('197f68fb-6309-57e3-94e7-6e1a758b26c6'::UUID, 'de6e0996-e9c9-5446-8cb1-60440a277716'::UUID, 'là', FALSE, 3)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('9fe99c65-df10-5ba2-991f-c8e8faeff8d3'::UUID, 'de6e0996-e9c9-5446-8cb1-60440a277716'::UUID, 'tên', TRUE, 4)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('3657ef54-cd96-53d9-be50-424b89595230'::UUID, '10000000-0000-0000-0000-000000000002'::UUID, 'translation', 7, 'Dịch sang tiếng Trung: “Tên bạn là gì?”', NULL, '你的名字是什么？', 'Mẫu câu dùng “名字” trong ngữ cảnh của bài.', 'míngzi', 1, '{"activity_type":"vietnamese_to_chinese","source_lang":"vi","target_lang":"zh","acceptable_answers":["你的名字是什么？"]}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('62bdf135-dd22-5a72-9603-85d86397a831'::UUID, '10000000-0000-0000-0000-000000000002'::UUID, 'sentence_builder', 8, 'Sắp xếp các thành phần thành câu đúng.', NULL, '你的名字是什么？', 'Trật tự đúng tạo thành câu “你的名字是什么？”.', NULL, 1, '{"activity_type":"sentence_ordering","words":["我","叫","兰","。"],"correct_order":["我","叫","兰","。"]}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('cbfad24b-dc5f-5740-96f6-968e3f703229'::UUID, '10000000-0000-0000-0000-000000000002'::UUID, 'multiple_choice', 9, 'Câu nào có nghĩa “Tôi tên Lan”?', NULL, '我叫兰。', 'Trật tự đúng là chủ ngữ 我 + 叫 + tên 兰.', NULL, 1, '{"activity_type":"grammar_selection","passage":null,"grammar_key":"foundation:called-name"}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('3604701c-5419-5908-a127-f38ccc1bb2b2'::UUID, 'cbfad24b-dc5f-5740-96f6-968e3f703229'::UUID, '我叫兰。', TRUE, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('d6b4b574-9aba-5bb9-85d6-baf4a18b9276'::UUID, 'cbfad24b-dc5f-5740-96f6-968e3f703229'::UUID, '我是叫兰。', FALSE, 2)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('59eea7aa-0264-5f2d-b565-b5ff7f32c1b5'::UUID, 'cbfad24b-dc5f-5740-96f6-968e3f703229'::UUID, '我兰叫。', FALSE, 3)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('bd82d061-0c0f-53aa-a0fc-043f3aa3dbc8'::UUID, '10000000-0000-0000-0000-000000000002'::UUID, 'speaking', 10, 'Đọc thành tiếng: 你的名字是什么？', NULL, '你的名字是什么？', 'Đọc chậm, giữ đúng thanh điệu và nhịp của cả câu.', NULL, 1, '{"activity_type":"pronunciation","text":"你的名字是什么？","pinyin":"Nǐ de míngzi shì shénme?"}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('fe49daf1-19a2-5cf7-9af9-d29173699cdd'::UUID, '10000000-0000-0000-0000-000000000003'::UUID, 'f0000000-0000-0000-0000-000000000011'::UUID, 1, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('61a719da-e46b-597b-be16-039c2cb7688e'::UUID, '10000000-0000-0000-0000-000000000003'::UUID, 'f0000000-0000-0000-0000-000000000012'::UUID, 2, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('5dd713ac-5c06-551f-a81e-3692da234c20'::UUID, '10000000-0000-0000-0000-000000000003'::UUID, 'f0000000-0000-0000-0000-000000000013'::UUID, 3, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('a7179162-d7b8-590d-9832-871a257a6f8f'::UUID, '10000000-0000-0000-0000-000000000003'::UUID, 'f0000000-0000-0000-0000-000000000014'::UUID, 4, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('8d2fb7bf-4153-5aea-bb62-e1bba655cae6'::UUID, '10000000-0000-0000-0000-000000000003'::UUID, 'f0000000-0000-0000-0000-000000000015'::UUID, 5, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('321290d9-f757-56ea-871c-ac695df51c3b'::UUID, '10000000-0000-0000-0000-000000000003'::UUID, 'f0000000-0000-0000-0000-000000000016'::UUID, 6, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('4c55723f-597c-5b95-ac2f-32349ad0d49b'::UUID, '10000000-0000-0000-0000-000000000003'::UUID, 'f0000000-0000-0000-0000-000000000017'::UUID, 7, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('372fe84e-a698-5b66-b380-1282e9474de2'::UUID, '10000000-0000-0000-0000-000000000003'::UUID, 'f0000000-0000-0000-0000-000000000018'::UUID, 8, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('a0be3427-ae66-57d9-b35b-2221503e793f'::UUID, '10000000-0000-0000-0000-000000000003'::UUID, 'f0000000-0000-0000-0000-000000000019'::UUID, 9, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('8f7cb023-298d-50fa-bc13-e5051818304c'::UUID, '10000000-0000-0000-0000-000000000003'::UUID, 'f0000000-0000-0000-0000-000000000020'::UUID, 10, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('ab33d0c8-96ab-5ffe-9b1a-0ad3ce4a6eec'::UUID, '10000000-0000-0000-0000-000000000003'::UUID, 'f0000000-0000-0000-0000-000000000004'::UUID, 11, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('7b7b11a3-2d04-57dc-b688-3650593c5f72'::UUID, '10000000-0000-0000-0000-000000000003'::UUID, 'f0000000-0000-0000-0000-000000000005'::UUID, 12, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('0b7efb85-a691-56d9-8d52-447c9a519a32'::UUID, '10000000-0000-0000-0000-000000000003'::UUID, 'f0000000-0000-0000-0000-000000000006'::UUID, 13, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('50d6f216-71cb-519b-b3fc-111a35a1142d'::UUID, '10000000-0000-0000-0000-000000000003'::UUID, 'f0000000-0000-0000-0000-000000000007'::UUID, 14, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('f5f6e017-6c0d-5008-9f42-61922d3941cf'::UUID, '10000000-0000-0000-0000-000000000003'::UUID, 'f0000000-0000-0000-0000-000000000008'::UUID, 15, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.grammar_lessons (id, content_key, title, pattern, explanation, example_chinese, example_pinyin, example_meaning, level, status, usage_note, content_version)
VALUES ('ce0fde8f-cdac-55b0-8f57-5c4baf9e9027'::UUID, 'foundation:number-measure', 'Số + lượng từ + danh từ', 'Số + 个 + danh từ', 'Trong tiếng Trung, số thường đứng trước lượng từ rồi mới đến danh từ.', '我有三个朋友。', 'Wǒ yǒu sān ge péngyou.', 'Tôi có ba người bạn.', 'starter', 'published', '个 là lượng từ thông dụng; nhiều danh từ có lượng từ riêng.', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_grammar (id, lesson_id, grammar_lesson_id, order_index, curriculum_role)
VALUES ('6400d200-1a44-52bd-9310-993ecd8dca1c'::UUID, '10000000-0000-0000-0000-000000000003'::UUID, 'ce0fde8f-cdac-55b0-8f57-5c4baf9e9027'::UUID, 1, 'introduced')
ON CONFLICT (lesson_id, grammar_lesson_id) DO NOTHING;

INSERT INTO public.lesson_grammar (id, lesson_id, grammar_lesson_id, order_index, curriculum_role)
VALUES ('0b0bda0d-bf7a-5e3a-bb5d-27a34bf4324c'::UUID, '10000000-0000-0000-0000-000000000003'::UUID, 'cc829157-96aa-55c6-823c-ab112447cf96'::UUID, 2, 'review')
ON CONFLICT (lesson_id, grammar_lesson_id) DO NOTHING;

INSERT INTO public.lesson_characters (id, lesson_id, character_id, order_index, curriculum_role)
VALUES ('0430bbd4-97ba-5e8e-8559-7ff64083ba69'::UUID, '10000000-0000-0000-0000-000000000003'::UUID, '9fb58e63-8f87-5714-93d6-5f5a3f752cf4'::UUID, 1, 'review')
ON CONFLICT (lesson_id, character_id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('4a5b9252-db42-597b-a9cc-aa6d62b95859'::UUID, '10000000-0000-0000-0000-000000000003'::UUID, 'vocabulary', 1, 'Từ mới: 一', NULL, '一', '一 (yī) — một. 我有一个朋友。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"foundation:一","chinese":"一","pinyin":"yī","meaning":"một","part_of_speech":"số từ","example_chinese":"我有一个朋友。","example_pinyin":"Wǒ yǒu yí ge péngyou.","example_meaning_vi":"Tôi có một người bạn."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('2d570e55-c161-5c4c-ac09-de92703292c7'::UUID, '10000000-0000-0000-0000-000000000003'::UUID, 'vocabulary', 2, 'Từ mới: 二', NULL, '二', '二 (èr) — hai. 二月很冷。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"foundation:二","chinese":"二","pinyin":"èr","meaning":"hai","part_of_speech":"số từ","example_chinese":"二月很冷。","example_pinyin":"Èryuè hěn lěng.","example_meaning_vi":"Tháng Hai rất lạnh."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('972c0879-bc25-594d-8e6a-cdb9cda7d332'::UUID, '10000000-0000-0000-0000-000000000003'::UUID, 'vocabulary', 3, 'Từ mới: 三', NULL, '三', '三 (sān) — ba. 我买三个苹果。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"foundation:三","chinese":"三","pinyin":"sān","meaning":"ba","part_of_speech":"số từ","example_chinese":"我买三个苹果。","example_pinyin":"Wǒ mǎi sān ge píngguǒ.","example_meaning_vi":"Tôi mua ba quả táo."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('d309ff29-776b-57c7-a521-8e875cec5080'::UUID, '10000000-0000-0000-0000-000000000003'::UUID, 'vocabulary', 4, 'Từ mới: 四', NULL, '四', '四 (sì) — bốn. 汉语有四个声调。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"foundation:四","chinese":"四","pinyin":"sì","meaning":"bốn","part_of_speech":"số từ","example_chinese":"汉语有四个声调。","example_pinyin":"Hànyǔ yǒu sì ge shēngdiào.","example_meaning_vi":"Tiếng Trung có bốn thanh điệu."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('84f08efc-129e-5d68-8273-f9362e241c94'::UUID, '10000000-0000-0000-0000-000000000003'::UUID, 'vocabulary', 5, 'Từ mới: 五', NULL, '五', '五 (wǔ) — năm. 我们五点见。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"foundation:五","chinese":"五","pinyin":"wǔ","meaning":"năm","part_of_speech":"số từ","example_chinese":"我们五点见。","example_pinyin":"Wǒmen wǔ diǎn jiàn.","example_meaning_vi":"Chúng ta gặp nhau lúc năm giờ."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('5d697f84-6f32-5760-8cf4-2f60a460d3eb'::UUID, '10000000-0000-0000-0000-000000000003'::UUID, 'vocabulary', 6, 'Từ mới: 六', NULL, '六', '六 (liù) — sáu. 她六岁。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"foundation:六","chinese":"六","pinyin":"liù","meaning":"sáu","part_of_speech":"số từ","example_chinese":"她六岁。","example_pinyin":"Tā liù suì.","example_meaning_vi":"Cô bé sáu tuổi."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('37a2a44a-382e-56ee-a5b8-d857a3b03fc9'::UUID, '10000000-0000-0000-0000-000000000003'::UUID, 'vocabulary', 7, 'Từ mới: 七', NULL, '七', '七 (qī) — bảy. 一周有七天。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"foundation:七","chinese":"七","pinyin":"qī","meaning":"bảy","part_of_speech":"số từ","example_chinese":"一周有七天。","example_pinyin":"Yì zhōu yǒu qī tiān.","example_meaning_vi":"Một tuần có bảy ngày."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('7c96bdfc-32e1-589e-ab32-e139ec43fb5e'::UUID, '10000000-0000-0000-0000-000000000003'::UUID, 'vocabulary', 8, 'Từ mới: 八', NULL, '八', '八 (bā) — tám. 现在八点。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"foundation:八","chinese":"八","pinyin":"bā","meaning":"tám","part_of_speech":"số từ","example_chinese":"现在八点。","example_pinyin":"Xiànzài bā diǎn.","example_meaning_vi":"Bây giờ là tám giờ."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('26660975-6f93-5e51-b983-5edaece0bf13'::UUID, '10000000-0000-0000-0000-000000000003'::UUID, 'vocabulary', 9, 'Từ mới: 九', NULL, '九', '九 (jiǔ) — chín. 商店九点开门。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"foundation:九","chinese":"九","pinyin":"jiǔ","meaning":"chín","part_of_speech":"số từ","example_chinese":"商店九点开门。","example_pinyin":"Shāngdiàn jiǔ diǎn kāimén.","example_meaning_vi":"Cửa hàng mở cửa lúc chín giờ."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('99c81f1c-bced-566a-b49d-e7e1a89a1fce'::UUID, '10000000-0000-0000-0000-000000000003'::UUID, 'vocabulary', 10, 'Từ mới: 十', NULL, '十', '十 (shí) — mười. 请等十分钟。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"foundation:十","chinese":"十","pinyin":"shí","meaning":"mười","part_of_speech":"số từ","example_chinese":"请等十分钟。","example_pinyin":"Qǐng děng shí fēnzhōng.","example_meaning_vi":"Vui lòng đợi mười phút."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('bdc30f54-b7be-56d8-9ede-9a19d60a0df8'::UUID, '10000000-0000-0000-0000-000000000003'::UUID, 'multiple_choice', 11, '“一” có nghĩa phù hợp nhất là gì?', NULL, 'một', '一 (yī) nghĩa là “một”.', NULL, 1, '{"activity_type":"chinese_to_vietnamese","vocabulary_key":"foundation:一"}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('3ffd9cae-db15-5d33-8ac6-9dcc983afad3'::UUID, 'bdc30f54-b7be-56d8-9ede-9a19d60a0df8'::UUID, 'hai', FALSE, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('0e5ab853-a5aa-5f39-9483-dc4e7d6521e7'::UUID, 'bdc30f54-b7be-56d8-9ede-9a19d60a0df8'::UUID, 'ba', FALSE, 2)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('79c5364d-0afb-5cd8-8282-92f2c3ef867a'::UUID, 'bdc30f54-b7be-56d8-9ede-9a19d60a0df8'::UUID, 'mười', FALSE, 3)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('077d3fe7-f200-5fa8-8ae0-e49199a31179'::UUID, 'bdc30f54-b7be-56d8-9ede-9a19d60a0df8'::UUID, 'một', TRUE, 4)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('7feade02-b049-53a7-a97f-3a7aaf87af88'::UUID, '10000000-0000-0000-0000-000000000003'::UUID, 'translation', 12, 'Dịch sang tiếng Trung: “Tôi có một người bạn.”', NULL, '我有一个朋友。', 'Mẫu câu dùng “一” trong ngữ cảnh của bài.', 'yī', 1, '{"activity_type":"vietnamese_to_chinese","source_lang":"vi","target_lang":"zh","acceptable_answers":["我有一个朋友。"]}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('3b91ae32-be96-5080-8a8f-aec7e17141b6'::UUID, '10000000-0000-0000-0000-000000000003'::UUID, 'sentence_builder', 13, 'Sắp xếp các thành phần thành câu đúng.', NULL, '我有一个朋友。', 'Trật tự đúng tạo thành câu “我有一个朋友。”.', NULL, 1, '{"activity_type":"sentence_ordering","words":["我","有","一","个","朋友","。"],"correct_order":["我","有","一","个","朋友","。"]}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('37138ef2-bc7e-5ead-b5f3-d6d073ddd56d'::UUID, '10000000-0000-0000-0000-000000000003'::UUID, 'multiple_choice', 14, 'Cụm nào có trật tự đúng?', NULL, '三个人', 'Trật tự là số 三 + lượng từ 个 + danh từ 人.', NULL, 1, '{"activity_type":"grammar_selection","passage":null,"grammar_key":"foundation:number-measure"}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('7ca22576-1e85-541e-8d44-7f9dae8f3b8e'::UUID, '37138ef2-bc7e-5ead-b5f3-d6d073ddd56d'::UUID, '三个人', TRUE, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('bb2c0424-4351-52e7-8522-2b3fdbaa72ae'::UUID, '37138ef2-bc7e-5ead-b5f3-d6d073ddd56d'::UUID, '个三人', FALSE, 2)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('ec26fedd-f089-5682-a835-7ba91b73d60d'::UUID, '37138ef2-bc7e-5ead-b5f3-d6d073ddd56d'::UUID, '人三个', FALSE, 3)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('d96e512f-b815-5d8c-94c2-b0cc0d4130eb'::UUID, '10000000-0000-0000-0000-000000000003'::UUID, 'speaking', 15, 'Đọc thành tiếng: 我有一个朋友。', NULL, '我有一个朋友。', 'Đọc chậm, giữ đúng thanh điệu và nhịp của cả câu.', NULL, 1, '{"activity_type":"pronunciation","text":"我有一个朋友。","pinyin":"Wǒ yǒu yí ge péngyou."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('833a2bed-d3c2-5bc0-90bb-7020b8572c27'::UUID, 'foundation:声调', '声调', 'shēngdiào', 'thanh điệu', 'tone', 'starter', 'pronunciation', 'danh từ', '汉语有四个声调。', 'Hànyǔ yǒu sì ge shēngdiào.', 'Tiếng Trung có bốn thanh điệu.', NULL, 'published', '10000000-0000-0000-0000-000000000004'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('fdf4bfd7-1274-5387-8436-3dcb107f917e'::UUID, '10000000-0000-0000-0000-000000000004'::UUID, '833a2bed-d3c2-5bc0-90bb-7020b8572c27'::UUID, 1, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('93a3a1e7-7e54-5759-b830-135f86188ed0'::UUID, 'foundation:第一声', '第一声', 'dì yī shēng', 'thanh thứ nhất', 'first tone', 'starter', 'pronunciation', 'cụm danh từ', '“妈”读第一声。', '“Mā” dú dì yī shēng.', '“妈” đọc thanh thứ nhất.', NULL, 'published', '10000000-0000-0000-0000-000000000004'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('e6aa0f18-5c13-5f43-bee5-a181327886a8'::UUID, '10000000-0000-0000-0000-000000000004'::UUID, '93a3a1e7-7e54-5759-b830-135f86188ed0'::UUID, 2, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('b31fb9ef-3df0-53a1-bb9f-2b449ee8f42b'::UUID, 'foundation:第二声', '第二声', 'dì èr shēng', 'thanh thứ hai', 'second tone', 'starter', 'pronunciation', 'cụm danh từ', '“麻”读第二声。', '“Má” dú dì èr shēng.', '“麻” đọc thanh thứ hai.', NULL, 'published', '10000000-0000-0000-0000-000000000004'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('81b32cbc-8f14-5762-8643-78f58da89d0b'::UUID, '10000000-0000-0000-0000-000000000004'::UUID, 'b31fb9ef-3df0-53a1-bb9f-2b449ee8f42b'::UUID, 3, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('f321f82f-4d1d-5ee0-9024-784a4931a68e'::UUID, 'foundation:第三声', '第三声', 'dì sān shēng', 'thanh thứ ba', 'third tone', 'starter', 'pronunciation', 'cụm danh từ', '“马”读第三声。', '“Mǎ” dú dì sān shēng.', '“马” đọc thanh thứ ba.', NULL, 'published', '10000000-0000-0000-0000-000000000004'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('5d9d1dba-7715-52ba-bf4e-aecb91a60538'::UUID, '10000000-0000-0000-0000-000000000004'::UUID, 'f321f82f-4d1d-5ee0-9024-784a4931a68e'::UUID, 4, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('85612ee6-945a-56a4-894e-b55aef0d3633'::UUID, 'foundation:第四声', '第四声', 'dì sì shēng', 'thanh thứ tư', 'fourth tone', 'starter', 'pronunciation', 'cụm danh từ', '“骂”读第四声。', '“Mà” dú dì sì shēng.', '“骂” đọc thanh thứ tư.', NULL, 'published', '10000000-0000-0000-0000-000000000004'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('4c5541ba-2f67-5d6b-b5bb-eb545e7e40fb'::UUID, '10000000-0000-0000-0000-000000000004'::UUID, '85612ee6-945a-56a4-894e-b55aef0d3633'::UUID, 5, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('faf207c6-cdd9-542d-825b-e3eede9452ce'::UUID, '10000000-0000-0000-0000-000000000004'::UUID, 'f0000000-0000-0000-0000-000000000011'::UUID, 6, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('b15b3233-7716-5107-be8b-ccb017d3f7f8'::UUID, '10000000-0000-0000-0000-000000000004'::UUID, 'f0000000-0000-0000-0000-000000000012'::UUID, 7, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('7c2815f8-6867-5313-bac4-20ae9fb1b98f'::UUID, '10000000-0000-0000-0000-000000000004'::UUID, 'f0000000-0000-0000-0000-000000000013'::UUID, 8, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('8919f02b-f897-5153-9bb4-8d821ee68d36'::UUID, '10000000-0000-0000-0000-000000000004'::UUID, 'f0000000-0000-0000-0000-000000000014'::UUID, 9, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('2ea9209d-6697-51b5-a0a9-4271d4bdad50'::UUID, '10000000-0000-0000-0000-000000000004'::UUID, 'f0000000-0000-0000-0000-000000000015'::UUID, 10, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('67bf4dcc-481d-51f9-8636-de1309aa3f71'::UUID, '10000000-0000-0000-0000-000000000004'::UUID, 'f0000000-0000-0000-0000-000000000016'::UUID, 11, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('08b93e79-985b-533c-9440-84f0d02952f5'::UUID, '10000000-0000-0000-0000-000000000004'::UUID, 'f0000000-0000-0000-0000-000000000017'::UUID, 12, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('c20f0eab-a025-5c96-9a5c-ca7b3a79f2d2'::UUID, '10000000-0000-0000-0000-000000000004'::UUID, 'f0000000-0000-0000-0000-000000000018'::UUID, 13, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('dd9560c4-c582-54e4-a77a-d9783cfb7c46'::UUID, '10000000-0000-0000-0000-000000000004'::UUID, 'f0000000-0000-0000-0000-000000000019'::UUID, 14, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('a4c71fbe-9510-5057-bacc-5ad69cca4b6d'::UUID, '10000000-0000-0000-0000-000000000004'::UUID, 'f0000000-0000-0000-0000-000000000020'::UUID, 15, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.grammar_lessons (id, content_key, title, pattern, explanation, example_chinese, example_pinyin, example_meaning, level, status, usage_note, content_version)
VALUES ('055638e0-11e5-5af8-9176-a596b5da0afc'::UUID, 'foundation:ordinal-di', 'Số thứ tự với 第', '第 + số', 'Thêm 第 trước số để tạo số thứ tự.', '这是第一课。', 'Zhè shì dì yī kè.', 'Đây là bài thứ nhất.', 'starter', 'published', '第 không cần lượng từ khi chỉ thứ tự bài hoặc lần.', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_grammar (id, lesson_id, grammar_lesson_id, order_index, curriculum_role)
VALUES ('8cd836d0-6f3b-5807-a9dc-cf18fb3866fb'::UUID, '10000000-0000-0000-0000-000000000004'::UUID, '055638e0-11e5-5af8-9176-a596b5da0afc'::UUID, 1, 'introduced')
ON CONFLICT (lesson_id, grammar_lesson_id) DO NOTHING;

INSERT INTO public.lesson_grammar (id, lesson_id, grammar_lesson_id, order_index, curriculum_role)
VALUES ('99f1e8b1-8ba9-56f3-9c96-ce891ab2991a'::UUID, '10000000-0000-0000-0000-000000000004'::UUID, 'ce0fde8f-cdac-55b0-8f57-5c4baf9e9027'::UUID, 2, 'review')
ON CONFLICT (lesson_id, grammar_lesson_id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('fb79a13a-20fd-5e35-958a-0cb1e89c1457'::UUID, '10000000-0000-0000-0000-000000000004'::UUID, 'vocabulary', 1, 'Từ mới: 声调', NULL, '声调', '声调 (shēngdiào) — thanh điệu. 汉语有四个声调。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"foundation:声调","chinese":"声调","pinyin":"shēngdiào","meaning":"thanh điệu","part_of_speech":"danh từ","example_chinese":"汉语有四个声调。","example_pinyin":"Hànyǔ yǒu sì ge shēngdiào.","example_meaning_vi":"Tiếng Trung có bốn thanh điệu."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('a956ac17-91a6-533a-85da-6b82377814ca'::UUID, '10000000-0000-0000-0000-000000000004'::UUID, 'vocabulary', 2, 'Từ mới: 第一声', NULL, '第一声', '第一声 (dì yī shēng) — thanh thứ nhất. “妈”读第一声。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"foundation:第一声","chinese":"第一声","pinyin":"dì yī shēng","meaning":"thanh thứ nhất","part_of_speech":"cụm danh từ","example_chinese":"“妈”读第一声。","example_pinyin":"“Mā” dú dì yī shēng.","example_meaning_vi":"“妈” đọc thanh thứ nhất."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('8df83f4e-195e-5a15-9890-f6d5ccd755d5'::UUID, '10000000-0000-0000-0000-000000000004'::UUID, 'vocabulary', 3, 'Từ mới: 第二声', NULL, '第二声', '第二声 (dì èr shēng) — thanh thứ hai. “麻”读第二声。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"foundation:第二声","chinese":"第二声","pinyin":"dì èr shēng","meaning":"thanh thứ hai","part_of_speech":"cụm danh từ","example_chinese":"“麻”读第二声。","example_pinyin":"“Má” dú dì èr shēng.","example_meaning_vi":"“麻” đọc thanh thứ hai."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('094b3137-83b4-5653-b643-9df4eb670a0b'::UUID, '10000000-0000-0000-0000-000000000004'::UUID, 'vocabulary', 4, 'Từ mới: 第三声', NULL, '第三声', '第三声 (dì sān shēng) — thanh thứ ba. “马”读第三声。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"foundation:第三声","chinese":"第三声","pinyin":"dì sān shēng","meaning":"thanh thứ ba","part_of_speech":"cụm danh từ","example_chinese":"“马”读第三声。","example_pinyin":"“Mǎ” dú dì sān shēng.","example_meaning_vi":"“马” đọc thanh thứ ba."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('54ca807b-4036-56ad-ba7d-7f7cfc3a9ad9'::UUID, '10000000-0000-0000-0000-000000000004'::UUID, 'vocabulary', 5, 'Từ mới: 第四声', NULL, '第四声', '第四声 (dì sì shēng) — thanh thứ tư. “骂”读第四声。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"foundation:第四声","chinese":"第四声","pinyin":"dì sì shēng","meaning":"thanh thứ tư","part_of_speech":"cụm danh từ","example_chinese":"“骂”读第四声。","example_pinyin":"“Mà” dú dì sì shēng.","example_meaning_vi":"“骂” đọc thanh thứ tư."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('b70f395c-dd7d-5abe-bc66-02d4d86b6afd'::UUID, '10000000-0000-0000-0000-000000000004'::UUID, 'multiple_choice', 6, '“声调” có nghĩa phù hợp nhất là gì?', NULL, 'thanh điệu', '声调 (shēngdiào) nghĩa là “thanh điệu”.', NULL, 1, '{"activity_type":"chinese_to_vietnamese","vocabulary_key":"foundation:声调"}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('311bea29-2093-52fc-985d-3a329b025443'::UUID, 'b70f395c-dd7d-5abe-bc66-02d4d86b6afd'::UUID, 'thanh thứ nhất', FALSE, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('9750d3b0-b623-581e-a9ac-178e7a04767a'::UUID, 'b70f395c-dd7d-5abe-bc66-02d4d86b6afd'::UUID, 'thanh thứ hai', FALSE, 2)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('c853e12e-753b-5885-a248-3c0d4be3ead9'::UUID, 'b70f395c-dd7d-5abe-bc66-02d4d86b6afd'::UUID, 'thanh thứ tư', FALSE, 3)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('5d93e486-a982-597c-a5b2-dd0912d1c504'::UUID, 'b70f395c-dd7d-5abe-bc66-02d4d86b6afd'::UUID, 'thanh điệu', TRUE, 4)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('336234a1-548c-56d3-af6c-e2043edcd816'::UUID, '10000000-0000-0000-0000-000000000004'::UUID, 'translation', 7, 'Dịch sang tiếng Trung: “Tiếng Trung có bốn thanh điệu.”', NULL, '汉语有四个声调。', 'Mẫu câu dùng “声调” trong ngữ cảnh của bài.', 'shēngdiào', 1, '{"activity_type":"vietnamese_to_chinese","source_lang":"vi","target_lang":"zh","acceptable_answers":["汉语有四个声调。"]}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('a53bc47a-af27-5c8f-b625-3843c1632ee4'::UUID, '10000000-0000-0000-0000-000000000004'::UUID, 'sentence_builder', 8, 'Sắp xếp các thành phần thành câu đúng.', NULL, '汉语有四个声调。', 'Trật tự đúng tạo thành câu “汉语有四个声调。”.', NULL, 1, '{"activity_type":"sentence_ordering","words":["汉语","有","四","个","声调","。"],"correct_order":["汉语","有","四","个","声调","。"]}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('d392318c-62e3-5971-8571-136ed5521e00'::UUID, '10000000-0000-0000-0000-000000000004'::UUID, 'multiple_choice', 9, '“Bài thứ nhất” nói thế nào?', NULL, '第一课', '第 đặt trước số: 第一, sau đó là danh từ 课.', NULL, 1, '{"activity_type":"grammar_selection","passage":null,"grammar_key":"foundation:ordinal-di"}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('28af190e-792c-55c5-99a7-6289815a7c7d'::UUID, 'd392318c-62e3-5971-8571-136ed5521e00'::UUID, '第一课', TRUE, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('a630f1a9-66a5-5b2e-93e8-97d373013f0a'::UUID, 'd392318c-62e3-5971-8571-136ed5521e00'::UUID, '一第课', FALSE, 2)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('df6880d1-3400-5986-a450-0122bb97b16c'::UUID, 'd392318c-62e3-5971-8571-136ed5521e00'::UUID, '课第一', FALSE, 3)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('dd4b127b-1529-555c-9a0c-1fbe4e1ee454'::UUID, '10000000-0000-0000-0000-000000000004'::UUID, 'speaking', 10, 'Đọc thành tiếng: 汉语有四个声调。', NULL, '汉语有四个声调。', 'Đọc chậm, giữ đúng thanh điệu và nhịp của cả câu.', NULL, 1, '{"activity_type":"pronunciation","text":"汉语有四个声调。","pinyin":"Hànyǔ yǒu sì ge shēngdiào."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('20c5acb6-c78c-56b0-8a30-38b4319249e1'::UUID, 'foundation:人', '人', 'rén', 'người', 'person', 'starter', 'identity', 'danh từ', '他是中国人。', 'Tā shì Zhōngguó rén.', 'Anh ấy là người Trung Quốc.', 1, 'published', '10000000-0000-0000-0000-000000000005'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('91e174da-b769-54d8-8242-81b6f1027fa8'::UUID, '10000000-0000-0000-0000-000000000005'::UUID, '20c5acb6-c78c-56b0-8a30-38b4319249e1'::UUID, 1, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('6b8f96ba-b343-557b-804e-20cba7bd19ce'::UUID, 'foundation:越南', '越南', 'Yuènán', 'Việt Nam', 'Vietnam', 'starter', 'identity', 'danh từ riêng', '我来自越南。', 'Wǒ láizì Yuènán.', 'Tôi đến từ Việt Nam.', NULL, 'published', '10000000-0000-0000-0000-000000000005'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('ed9a6bfd-040b-5cb7-980e-c9b94032829c'::UUID, '10000000-0000-0000-0000-000000000005'::UUID, '6b8f96ba-b343-557b-804e-20cba7bd19ce'::UUID, 2, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('b4532d2f-c0a1-52f0-b907-73fe8bb1c3f8'::UUID, 'foundation:中国', '中国', 'Zhōngguó', 'Trung Quốc', 'China', 'starter', 'identity', 'danh từ riêng', '北京在中国。', 'Běijīng zài Zhōngguó.', 'Bắc Kinh ở Trung Quốc.', 1, 'published', '10000000-0000-0000-0000-000000000005'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('35b8abd7-804f-5117-acf6-3cf3f4a44915'::UUID, '10000000-0000-0000-0000-000000000005'::UUID, 'b4532d2f-c0a1-52f0-b907-73fe8bb1c3f8'::UUID, 3, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('47bd12e9-c8f1-57e7-976b-776f1d9ed3d0'::UUID, 'foundation:学生', '学生', 'xuésheng', 'học sinh, sinh viên', 'student', 'starter', 'identity', 'danh từ', '我是大学生。', 'Wǒ shì dàxuéshēng.', 'Tôi là sinh viên đại học.', 1, 'published', '10000000-0000-0000-0000-000000000005'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('52a29bdc-ed4d-55c5-9c12-d0ea4b3d4d63'::UUID, '10000000-0000-0000-0000-000000000005'::UUID, '47bd12e9-c8f1-57e7-976b-776f1d9ed3d0'::UUID, 4, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('050fb165-102e-594d-8446-72519162c9c1'::UUID, 'foundation:也', '也', 'yě', 'cũng', 'also', 'starter', 'grammar', 'phó từ', '我也是学生。', 'Wǒ yě shì xuésheng.', 'Tôi cũng là sinh viên.', 1, 'published', '10000000-0000-0000-0000-000000000005'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('4bb51b41-3897-59d3-a724-148b8ceb19ec'::UUID, '10000000-0000-0000-0000-000000000005'::UUID, '050fb165-102e-594d-8446-72519162c9c1'::UUID, 5, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('c5e8c9a0-1c25-58e8-911b-99a5e5f5cf2b'::UUID, '10000000-0000-0000-0000-000000000005'::UUID, '833a2bed-d3c2-5bc0-90bb-7020b8572c27'::UUID, 6, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('e46dcd7c-6f2a-5ee1-b900-6c3dc724bd04'::UUID, '10000000-0000-0000-0000-000000000005'::UUID, '93a3a1e7-7e54-5759-b830-135f86188ed0'::UUID, 7, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('ac62480a-1c5a-547b-9290-bcff05f21d03'::UUID, '10000000-0000-0000-0000-000000000005'::UUID, 'b31fb9ef-3df0-53a1-bb9f-2b449ee8f42b'::UUID, 8, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('b8cbb602-001b-5a20-a256-0fc29b265c6c'::UUID, '10000000-0000-0000-0000-000000000005'::UUID, 'f321f82f-4d1d-5ee0-9024-784a4931a68e'::UUID, 9, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('b099d851-aba6-560c-ac96-38435435adc1'::UUID, '10000000-0000-0000-0000-000000000005'::UUID, '85612ee6-945a-56a4-894e-b55aef0d3633'::UUID, 10, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.grammar_lessons (id, content_key, title, pattern, explanation, example_chinese, example_pinyin, example_meaning, level, status, usage_note, content_version)
VALUES ('fd3f559d-63c5-59f6-998e-7a4aee208002'::UUID, 'foundation:also-ye', 'Phó từ 也', 'Chủ ngữ + 也 + động từ/tính từ', '也 đứng trước vị ngữ để biểu thị “cũng”.', '我也是学生。', 'Wǒ yě shì xuésheng.', 'Tôi cũng là sinh viên.', 'starter', 'published', 'Không đặt 也 sau 是 trong mẫu câu này.', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_grammar (id, lesson_id, grammar_lesson_id, order_index, curriculum_role)
VALUES ('43b059e6-485c-599f-9d34-90ee2fbd210d'::UUID, '10000000-0000-0000-0000-000000000005'::UUID, 'fd3f559d-63c5-59f6-998e-7a4aee208002'::UUID, 1, 'introduced')
ON CONFLICT (lesson_id, grammar_lesson_id) DO NOTHING;

INSERT INTO public.lesson_grammar (id, lesson_id, grammar_lesson_id, order_index, curriculum_role)
VALUES ('9ffe259f-eab7-5ed6-b0ee-a2735cb9dc61'::UUID, '10000000-0000-0000-0000-000000000005'::UUID, '055638e0-11e5-5af8-9176-a596b5da0afc'::UUID, 2, 'review')
ON CONFLICT (lesson_id, grammar_lesson_id) DO NOTHING;

INSERT INTO public.characters (id, character, pinyin, meaning_vi, radical, stroke_count, stroke_order, level, status, component_breakdown, common_words, content_version)
VALUES ('0f7fe753-6ab7-51d3-a0a8-d449cd63d99c'::UUID, '中', 'zhōng', 'giữa, trung', '丨', 4, NULL, 'starter', 'published', '{"note":"Nét dọc đi qua giữa khung."}'::JSONB, '["中国","中文"]'::JSONB, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_characters (id, lesson_id, character_id, order_index, curriculum_role)
VALUES ('649eaf7a-d572-5684-8888-10b2ae5c7b2d'::UUID, '10000000-0000-0000-0000-000000000005'::UUID, '0f7fe753-6ab7-51d3-a0a8-d449cd63d99c'::UUID, 1, 'introduced')
ON CONFLICT (lesson_id, character_id) DO NOTHING;

INSERT INTO public.characters (id, character, pinyin, meaning_vi, radical, stroke_count, stroke_order, level, status, component_breakdown, common_words, content_version)
VALUES ('66c1b0a2-a009-5822-81e3-763dd80e7d57'::UUID, '国', 'guó', 'nước, quốc gia', '囗', 8, NULL, 'starter', 'published', '{"outside":"囗","inside":"玉"}'::JSONB, '["中国","国家"]'::JSONB, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_characters (id, lesson_id, character_id, order_index, curriculum_role)
VALUES ('67799209-b72b-5c5a-969b-cd533b0b824c'::UUID, '10000000-0000-0000-0000-000000000005'::UUID, '66c1b0a2-a009-5822-81e3-763dd80e7d57'::UUID, 2, 'introduced')
ON CONFLICT (lesson_id, character_id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('da31112a-5fbf-563d-856d-7adde1dd5e15'::UUID, '10000000-0000-0000-0000-000000000005'::UUID, 'vocabulary', 1, 'Từ mới: 人', NULL, '人', '人 (rén) — người. 他是中国人。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"foundation:人","chinese":"人","pinyin":"rén","meaning":"người","part_of_speech":"danh từ","example_chinese":"他是中国人。","example_pinyin":"Tā shì Zhōngguó rén.","example_meaning_vi":"Anh ấy là người Trung Quốc."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('889b8a17-17b7-56a8-8289-6c4edb94f12f'::UUID, '10000000-0000-0000-0000-000000000005'::UUID, 'vocabulary', 2, 'Từ mới: 越南', NULL, '越南', '越南 (Yuènán) — Việt Nam. 我来自越南。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"foundation:越南","chinese":"越南","pinyin":"Yuènán","meaning":"Việt Nam","part_of_speech":"danh từ riêng","example_chinese":"我来自越南。","example_pinyin":"Wǒ láizì Yuènán.","example_meaning_vi":"Tôi đến từ Việt Nam."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('c0af14f6-929b-5664-9055-e1dc4f318d43'::UUID, '10000000-0000-0000-0000-000000000005'::UUID, 'vocabulary', 3, 'Từ mới: 中国', NULL, '中国', '中国 (Zhōngguó) — Trung Quốc. 北京在中国。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"foundation:中国","chinese":"中国","pinyin":"Zhōngguó","meaning":"Trung Quốc","part_of_speech":"danh từ riêng","example_chinese":"北京在中国。","example_pinyin":"Běijīng zài Zhōngguó.","example_meaning_vi":"Bắc Kinh ở Trung Quốc."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('e5ddb7ab-1e6f-501c-85d0-c6535285d4cd'::UUID, '10000000-0000-0000-0000-000000000005'::UUID, 'vocabulary', 4, 'Từ mới: 学生', NULL, '学生', '学生 (xuésheng) — học sinh, sinh viên. 我是大学生。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"foundation:学生","chinese":"学生","pinyin":"xuésheng","meaning":"học sinh, sinh viên","part_of_speech":"danh từ","example_chinese":"我是大学生。","example_pinyin":"Wǒ shì dàxuéshēng.","example_meaning_vi":"Tôi là sinh viên đại học."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('acb79880-e46f-5227-8d57-3178d08d9e17'::UUID, '10000000-0000-0000-0000-000000000005'::UUID, 'vocabulary', 5, 'Từ mới: 也', NULL, '也', '也 (yě) — cũng. 我也是学生。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"foundation:也","chinese":"也","pinyin":"yě","meaning":"cũng","part_of_speech":"phó từ","example_chinese":"我也是学生。","example_pinyin":"Wǒ yě shì xuésheng.","example_meaning_vi":"Tôi cũng là sinh viên."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('5855f63c-0b5b-5da6-863d-9c4ff232c8f4'::UUID, '10000000-0000-0000-0000-000000000005'::UUID, 'multiple_choice', 6, '“越南” có nghĩa phù hợp nhất là gì?', NULL, 'Việt Nam', '越南 (Yuènán) nghĩa là “Việt Nam”.', NULL, 1, '{"activity_type":"chinese_to_vietnamese","vocabulary_key":"foundation:越南"}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('ba61e6e0-1dac-5b44-8a88-eb84cdc0e403'::UUID, '5855f63c-0b5b-5da6-863d-9c4ff232c8f4'::UUID, 'Trung Quốc', FALSE, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('9601086d-2342-5319-b3b5-622ecdfa1686'::UUID, '5855f63c-0b5b-5da6-863d-9c4ff232c8f4'::UUID, 'học sinh, sinh viên', FALSE, 2)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('01e00bd8-9aaa-5345-a387-1fb737d4ec52'::UUID, '5855f63c-0b5b-5da6-863d-9c4ff232c8f4'::UUID, 'người', FALSE, 3)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('b53358d4-46b4-5db2-8b9c-9b8c6cb83ea9'::UUID, '5855f63c-0b5b-5da6-863d-9c4ff232c8f4'::UUID, 'Việt Nam', TRUE, 4)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('a4c5439c-fa13-5625-bd52-30c3ce785f32'::UUID, '10000000-0000-0000-0000-000000000005'::UUID, 'translation', 7, 'Dịch sang tiếng Trung: “Tôi đến từ Việt Nam.”', NULL, '我来自越南。', 'Mẫu câu dùng “越南” trong ngữ cảnh của bài.', 'Yuènán', 1, '{"activity_type":"vietnamese_to_chinese","source_lang":"vi","target_lang":"zh","acceptable_answers":["我来自越南。"]}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('44151e7b-b004-5ab6-b680-291180861433'::UUID, '10000000-0000-0000-0000-000000000005'::UUID, 'sentence_builder', 8, 'Sắp xếp các thành phần thành câu đúng.', NULL, '我来自越南。', 'Trật tự đúng tạo thành câu “我来自越南。”.', NULL, 1, '{"activity_type":"sentence_ordering","words":["我","是","越南","人","。"],"correct_order":["我","是","越南","人","。"]}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('05ce9353-92d7-505d-b62c-d586b1ae2c2a'::UUID, '10000000-0000-0000-0000-000000000005'::UUID, 'multiple_choice', 9, 'Câu nào có nghĩa “Tôi cũng là sinh viên”?', NULL, '我也是学生。', '也 đứng sau chủ ngữ 我 và trước vị ngữ 是学生.', NULL, 1, '{"activity_type":"grammar_selection","passage":null,"grammar_key":"foundation:also-ye"}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('efa60f29-3da9-5a32-823e-dd79a02b16c4'::UUID, '05ce9353-92d7-505d-b62c-d586b1ae2c2a'::UUID, '我也是学生。', TRUE, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('cb785f88-dd00-5ba5-a16b-d8deea51c128'::UUID, '05ce9353-92d7-505d-b62c-d586b1ae2c2a'::UUID, '我是也学生。', FALSE, 2)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('cc8907c2-c7b6-50f1-b749-8388ccda744e'::UUID, '05ce9353-92d7-505d-b62c-d586b1ae2c2a'::UUID, '也我是学生。', FALSE, 3)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('0458f9e3-0b49-5b32-8cde-b1ebab0e1962'::UUID, '10000000-0000-0000-0000-000000000005'::UUID, 'speaking', 10, 'Đọc thành tiếng: 我来自越南。', NULL, '我来自越南。', 'Đọc chậm, giữ đúng thanh điệu và nhịp của cả câu.', NULL, 1, '{"activity_type":"pronunciation","text":"我来自越南。","pinyin":"Wǒ láizì Yuènán."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.units (id, course_id, slug, title, description, order_index, status, learning_objectives, content_version)
VALUES ('baf1538b-0780-5683-81ec-7be46cd81fcc'::UUID, 'c0000000-0000-0000-0000-000000000001'::UUID, 'sinh-hoat-co-ban', 'Sinh hoạt cơ bản', 'Gia đình, thời gian, hoạt động trong ngày và mua đồ ăn.', 2, 'published', '["Trao đổi thông tin gia đình","Nói giờ và hoạt động quen thuộc"]'::JSONB, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.chapters (id, unit_id, slug, title, description, order_index, status, learning_objectives, content_version)
VALUES ('667e3e76-dbbd-53da-ba2e-a6c0faa7e55d'::UUID, 'baf1538b-0780-5683-81ec-7be46cd81fcc'::UUID, 'gia-dinh-va-thoi-gian', 'Gia đình và thời gian', 'Nói về người thân và mốc thời gian đơn giản.', 1, 'published', '["Giới thiệu người thân","Hỏi và nói thời gian"]'::JSONB, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lessons (id, chapter_id, slug, title, description, order_index, xp_reward, status, lesson_type, estimated_minutes, learning_objectives, cultural_note, content_version)
VALUES ('17dd9d54-3f33-51c0-8492-84b7a4962632'::UUID, '667e3e76-dbbd-53da-ba2e-a6c0faa7e55d'::UUID, 'gia-dinh', '我的家人 - Gia đình tôi', 'Từ vựng gia đình và sở hữu với 的.', 1, 20, 'published', 'standard', 12, '["Giới thiệu người thân bằng mẫu 我的..."]'::JSONB, NULL, 1)
ON CONFLICT (id) DO NOTHING;

-- Preserve real progression when a newly appended published lesson follows existing content.
INSERT INTO public.user_lesson_progress (user_id, lesson_id, status)
SELECT progress.user_id, '17dd9d54-3f33-51c0-8492-84b7a4962632'::UUID, 'available'
FROM public.user_lesson_progress AS progress
WHERE progress.lesson_id = '10000000-0000-0000-0000-000000000005'::UUID
  AND progress.status = 'completed'
ON CONFLICT (user_id, lesson_id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('c9808f2b-7b4c-50fd-b27f-3f9ca944c91f'::UUID, 'foundation:家', '家', 'jiā', 'nhà, gia đình', 'home; family', 'starter', 'family', 'danh từ', '我家在河内。', 'Wǒ jiā zài Hénèi.', 'Nhà tôi ở Hà Nội.', 1, 'published', '17dd9d54-3f33-51c0-8492-84b7a4962632'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('2b27a615-8e4c-5a27-8d59-699db52a9137'::UUID, '17dd9d54-3f33-51c0-8492-84b7a4962632'::UUID, 'c9808f2b-7b4c-50fd-b27f-3f9ca944c91f'::UUID, 1, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('c8b6cb2b-901e-5926-b935-1d6c66a3f16a'::UUID, 'foundation:家人', '家人', 'jiārén', 'người nhà', 'family member', 'starter', 'family', 'danh từ', '这是我的家人。', 'Zhè shì wǒ de jiārén.', 'Đây là người nhà của tôi.', NULL, 'published', '17dd9d54-3f33-51c0-8492-84b7a4962632'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('452e2151-37ce-5503-af24-23eb2310c4b4'::UUID, '17dd9d54-3f33-51c0-8492-84b7a4962632'::UUID, 'c8b6cb2b-901e-5926-b935-1d6c66a3f16a'::UUID, 2, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('9c612634-0de7-5b2b-aa23-fafc039e386c'::UUID, 'foundation:爸爸', '爸爸', 'bàba', 'bố', 'father', 'starter', 'family', 'danh từ', '我爸爸是医生。', 'Wǒ bàba shì yīshēng.', 'Bố tôi là bác sĩ.', 1, 'published', '17dd9d54-3f33-51c0-8492-84b7a4962632'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('fba4dd66-e51f-5cc0-8740-19d9f3b6f616'::UUID, '17dd9d54-3f33-51c0-8492-84b7a4962632'::UUID, '9c612634-0de7-5b2b-aa23-fafc039e386c'::UUID, 3, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('1ea38532-9419-5a76-b964-e0b147aea634'::UUID, 'foundation:妈妈', '妈妈', 'māma', 'mẹ', 'mother', 'starter', 'family', 'danh từ', '妈妈今天休息。', 'Māma jīntiān xiūxi.', 'Hôm nay mẹ nghỉ.', 1, 'published', '17dd9d54-3f33-51c0-8492-84b7a4962632'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('b96ecb40-3d51-5902-8d74-b8cef74dc4c3'::UUID, '17dd9d54-3f33-51c0-8492-84b7a4962632'::UUID, '1ea38532-9419-5a76-b964-e0b147aea634'::UUID, 4, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('5a6c73f9-0881-5285-94d1-124428914976'::UUID, 'foundation:朋友', '朋友', 'péngyou', 'bạn bè', 'friend', 'starter', 'relationships', 'danh từ', '兰是我的朋友。', 'Lán shì wǒ de péngyou.', 'Lan là bạn của tôi.', 1, 'published', '17dd9d54-3f33-51c0-8492-84b7a4962632'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('b86b5af3-e290-556b-81ee-1b5840bab7bd'::UUID, '17dd9d54-3f33-51c0-8492-84b7a4962632'::UUID, '5a6c73f9-0881-5285-94d1-124428914976'::UUID, 5, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('a04f0b00-a147-5a73-9187-772bcfec883a'::UUID, '17dd9d54-3f33-51c0-8492-84b7a4962632'::UUID, '20c5acb6-c78c-56b0-8a30-38b4319249e1'::UUID, 6, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('61c41c73-5d6a-54c7-a506-0a913277ba68'::UUID, '17dd9d54-3f33-51c0-8492-84b7a4962632'::UUID, '6b8f96ba-b343-557b-804e-20cba7bd19ce'::UUID, 7, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('172dc9ca-ebc6-5f2e-b50d-b4fd9c6d1031'::UUID, '17dd9d54-3f33-51c0-8492-84b7a4962632'::UUID, 'b4532d2f-c0a1-52f0-b907-73fe8bb1c3f8'::UUID, 8, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('b8eb913b-51ca-584e-b110-9cecef65cd4c'::UUID, '17dd9d54-3f33-51c0-8492-84b7a4962632'::UUID, '47bd12e9-c8f1-57e7-976b-776f1d9ed3d0'::UUID, 9, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('cb22a6b4-2d3d-5a70-9e7c-013f34628411'::UUID, '17dd9d54-3f33-51c0-8492-84b7a4962632'::UUID, '050fb165-102e-594d-8446-72519162c9c1'::UUID, 10, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.grammar_lessons (id, content_key, title, pattern, explanation, example_chinese, example_pinyin, example_meaning, level, status, usage_note, content_version)
VALUES ('ed17b98c-f80a-56bd-9274-371dcf28e056'::UUID, 'foundation:possession-de', 'Sở hữu với 的', 'Người sở hữu + 的 + danh từ', '的 nối người sở hữu với sự vật hoặc người thuộc về họ.', '这是我的朋友。', 'Zhè shì wǒ de péngyou.', 'Đây là bạn của tôi.', 'starter', 'published', 'Trong khẩu ngữ, 的 đôi khi được lược với quan hệ thân thuộc như 我妈妈.', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_grammar (id, lesson_id, grammar_lesson_id, order_index, curriculum_role)
VALUES ('a42d6913-d5fa-59c7-a9e9-03cc8247abba'::UUID, '17dd9d54-3f33-51c0-8492-84b7a4962632'::UUID, 'ed17b98c-f80a-56bd-9274-371dcf28e056'::UUID, 1, 'introduced')
ON CONFLICT (lesson_id, grammar_lesson_id) DO NOTHING;

INSERT INTO public.lesson_grammar (id, lesson_id, grammar_lesson_id, order_index, curriculum_role)
VALUES ('1fbfc414-84e4-5855-852d-d2004d1276d3'::UUID, '17dd9d54-3f33-51c0-8492-84b7a4962632'::UUID, 'fd3f559d-63c5-59f6-998e-7a4aee208002'::UUID, 2, 'review')
ON CONFLICT (lesson_id, grammar_lesson_id) DO NOTHING;

INSERT INTO public.lesson_characters (id, lesson_id, character_id, order_index, curriculum_role)
VALUES ('a84c2870-6e21-5b29-9401-468ce6658216'::UUID, '17dd9d54-3f33-51c0-8492-84b7a4962632'::UUID, '0f7fe753-6ab7-51d3-a0a8-d449cd63d99c'::UUID, 1, 'review')
ON CONFLICT (lesson_id, character_id) DO NOTHING;

INSERT INTO public.lesson_characters (id, lesson_id, character_id, order_index, curriculum_role)
VALUES ('95ba5a9a-c89c-5d8d-8ce9-1fd68eb66415'::UUID, '17dd9d54-3f33-51c0-8492-84b7a4962632'::UUID, '66c1b0a2-a009-5822-81e3-763dd80e7d57'::UUID, 2, 'review')
ON CONFLICT (lesson_id, character_id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('deb5d41f-b672-52e0-8154-f2317714f6db'::UUID, '17dd9d54-3f33-51c0-8492-84b7a4962632'::UUID, 'vocabulary', 1, 'Từ mới: 家', NULL, '家', '家 (jiā) — nhà, gia đình. 我家在河内。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"foundation:家","chinese":"家","pinyin":"jiā","meaning":"nhà, gia đình","part_of_speech":"danh từ","example_chinese":"我家在河内。","example_pinyin":"Wǒ jiā zài Hénèi.","example_meaning_vi":"Nhà tôi ở Hà Nội."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('94fb092c-5d9b-57d5-a446-b69b7f0d62ff'::UUID, '17dd9d54-3f33-51c0-8492-84b7a4962632'::UUID, 'vocabulary', 2, 'Từ mới: 家人', NULL, '家人', '家人 (jiārén) — người nhà. 这是我的家人。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"foundation:家人","chinese":"家人","pinyin":"jiārén","meaning":"người nhà","part_of_speech":"danh từ","example_chinese":"这是我的家人。","example_pinyin":"Zhè shì wǒ de jiārén.","example_meaning_vi":"Đây là người nhà của tôi."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('192ec822-a8ef-580f-99cd-250eb9f0a32a'::UUID, '17dd9d54-3f33-51c0-8492-84b7a4962632'::UUID, 'vocabulary', 3, 'Từ mới: 爸爸', NULL, '爸爸', '爸爸 (bàba) — bố. 我爸爸是医生。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"foundation:爸爸","chinese":"爸爸","pinyin":"bàba","meaning":"bố","part_of_speech":"danh từ","example_chinese":"我爸爸是医生。","example_pinyin":"Wǒ bàba shì yīshēng.","example_meaning_vi":"Bố tôi là bác sĩ."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('061d0bb0-e8b7-5534-8806-2184c1bad451'::UUID, '17dd9d54-3f33-51c0-8492-84b7a4962632'::UUID, 'vocabulary', 4, 'Từ mới: 妈妈', NULL, '妈妈', '妈妈 (māma) — mẹ. 妈妈今天休息。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"foundation:妈妈","chinese":"妈妈","pinyin":"māma","meaning":"mẹ","part_of_speech":"danh từ","example_chinese":"妈妈今天休息。","example_pinyin":"Māma jīntiān xiūxi.","example_meaning_vi":"Hôm nay mẹ nghỉ."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('c4f9092f-3a14-5412-bfdb-783ed1950514'::UUID, '17dd9d54-3f33-51c0-8492-84b7a4962632'::UUID, 'vocabulary', 5, 'Từ mới: 朋友', NULL, '朋友', '朋友 (péngyou) — bạn bè. 兰是我的朋友。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"foundation:朋友","chinese":"朋友","pinyin":"péngyou","meaning":"bạn bè","part_of_speech":"danh từ","example_chinese":"兰是我的朋友。","example_pinyin":"Lán shì wǒ de péngyou.","example_meaning_vi":"Lan là bạn của tôi."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('c0c5bfa5-0ae1-5b2c-aa85-49ae4179b6ca'::UUID, '17dd9d54-3f33-51c0-8492-84b7a4962632'::UUID, 'multiple_choice', 6, '“家人” có nghĩa phù hợp nhất là gì?', NULL, 'người nhà', '家人 (jiārén) nghĩa là “người nhà”.', NULL, 1, '{"activity_type":"chinese_to_vietnamese","vocabulary_key":"foundation:家人"}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('815bbbb1-e90d-5bec-b1fb-6bc53534197e'::UUID, 'c0c5bfa5-0ae1-5b2c-aa85-49ae4179b6ca'::UUID, 'người nhà', TRUE, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('6ae5ef1e-d002-5974-a0db-b85187b7d708'::UUID, 'c0c5bfa5-0ae1-5b2c-aa85-49ae4179b6ca'::UUID, 'bố', FALSE, 2)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('dd421918-24b0-5e37-8158-a8b2f444866d'::UUID, 'c0c5bfa5-0ae1-5b2c-aa85-49ae4179b6ca'::UUID, 'mẹ', FALSE, 3)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('67111c10-a468-54c7-b982-be4655bbaefc'::UUID, 'c0c5bfa5-0ae1-5b2c-aa85-49ae4179b6ca'::UUID, 'bạn bè', FALSE, 4)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('94454541-c5a5-571e-b717-1bd090957175'::UUID, '17dd9d54-3f33-51c0-8492-84b7a4962632'::UUID, 'translation', 7, 'Dịch sang tiếng Trung: “Đây là người nhà của tôi.”', NULL, '这是我的家人。', 'Mẫu câu dùng “家人” trong ngữ cảnh của bài.', 'jiārén', 1, '{"activity_type":"vietnamese_to_chinese","source_lang":"vi","target_lang":"zh","acceptable_answers":["这是我的家人。"]}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('83104647-570f-5640-99b2-ea807a1816c7'::UUID, '17dd9d54-3f33-51c0-8492-84b7a4962632'::UUID, 'sentence_builder', 8, 'Sắp xếp các thành phần thành câu đúng.', NULL, '这是我的家人。', 'Trật tự đúng tạo thành câu “这是我的家人。”.', NULL, 1, '{"activity_type":"sentence_ordering","words":["这","是","我","的","家人","。"],"correct_order":["这","是","我","的","家人","。"]}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('8c539273-2835-53c2-ad22-1ac29043b91d'::UUID, '17dd9d54-3f33-51c0-8492-84b7a4962632'::UUID, 'multiple_choice', 9, 'Cụm nào có nghĩa “bạn của tôi”?', NULL, '我的朋友', 'Người sở hữu 我 đứng trước 的, sau đó là 朋友.', NULL, 1, '{"activity_type":"grammar_selection","passage":null,"grammar_key":"foundation:possession-de"}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('72fdd626-83fd-50fd-9ffc-d3db839bff18'::UUID, '8c539273-2835-53c2-ad22-1ac29043b91d'::UUID, '我的朋友', TRUE, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('bd069e8a-b3a9-5290-84ce-b27f644a4c72'::UUID, '8c539273-2835-53c2-ad22-1ac29043b91d'::UUID, '我朋友的', FALSE, 2)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('d6202801-0ffd-57c2-9965-575ab6dfe20d'::UUID, '8c539273-2835-53c2-ad22-1ac29043b91d'::UUID, '的我朋友', FALSE, 3)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('c88fb6de-d610-55b8-8202-518df1a94622'::UUID, '17dd9d54-3f33-51c0-8492-84b7a4962632'::UUID, 'speaking', 10, 'Đọc thành tiếng: 这是我的家人。', NULL, '这是我的家人。', 'Đọc chậm, giữ đúng thanh điệu và nhịp của cả câu.', NULL, 1, '{"activity_type":"pronunciation","text":"这是我的家人。","pinyin":"Zhè shì wǒ de jiārén."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lessons (id, chapter_id, slug, title, description, order_index, xp_reward, status, lesson_type, estimated_minutes, learning_objectives, cultural_note, content_version)
VALUES ('e5a77950-bd6d-5080-8434-b7ec4b17e279'::UUID, '667e3e76-dbbd-53da-ba2e-a6c0faa7e55d'::UUID, 'ngay-gio', '现在几点？ - Bây giờ mấy giờ?', 'Nói hôm nay, ngày mai và giờ phút.', 2, 20, 'published', 'standard', 12, '["Hỏi và trả lời giờ hiện tại"]'::JSONB, NULL, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('6a7bac41-7cc6-5b92-86fb-d78a49460de7'::UUID, 'foundation:今天', '今天', 'jīntiān', 'hôm nay', 'today', 'starter', 'time', 'danh từ thời gian', '今天是星期一。', 'Jīntiān shì Xīngqīyī.', 'Hôm nay là thứ Hai.', 1, 'published', 'e5a77950-bd6d-5080-8434-b7ec4b17e279'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('22b1d84a-9507-5c91-a4b9-fb3d95dae22e'::UUID, 'e5a77950-bd6d-5080-8434-b7ec4b17e279'::UUID, '6a7bac41-7cc6-5b92-86fb-d78a49460de7'::UUID, 1, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('8546e8fa-1a87-5798-a312-a3bd52370710'::UUID, 'foundation:明天', '明天', 'míngtiān', 'ngày mai', 'tomorrow', 'starter', 'time', 'danh từ thời gian', '明天我们见面。', 'Míngtiān wǒmen jiànmiàn.', 'Ngày mai chúng ta gặp nhau.', 1, 'published', 'e5a77950-bd6d-5080-8434-b7ec4b17e279'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('2a67d4b6-a079-504a-b503-58de8ab7e877'::UUID, 'e5a77950-bd6d-5080-8434-b7ec4b17e279'::UUID, '8546e8fa-1a87-5798-a312-a3bd52370710'::UUID, 2, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('b3f21e12-613c-53c4-b161-215ebad4b593'::UUID, 'foundation:现在', '现在', 'xiànzài', 'bây giờ', 'now', 'starter', 'time', 'danh từ thời gian', '现在八点。', 'Xiànzài bā diǎn.', 'Bây giờ là tám giờ.', 1, 'published', 'e5a77950-bd6d-5080-8434-b7ec4b17e279'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('add2659a-ed06-56b3-bbbc-ffeb753a4662'::UUID, 'e5a77950-bd6d-5080-8434-b7ec4b17e279'::UUID, 'b3f21e12-613c-53c4-b161-215ebad4b593'::UUID, 3, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('dbd9e534-47ea-5a5f-9e3a-aab16ea89798'::UUID, 'foundation:点', '点', 'diǎn', 'giờ (khi nói thời gian)', 'o''clock', 'starter', 'time', 'lượng từ thời gian', '我七点起床。', 'Wǒ qī diǎn qǐchuáng.', 'Tôi thức dậy lúc bảy giờ.', 1, 'published', 'e5a77950-bd6d-5080-8434-b7ec4b17e279'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('edb074ad-6b4d-5da3-8447-129f80965d0e'::UUID, 'e5a77950-bd6d-5080-8434-b7ec4b17e279'::UUID, 'dbd9e534-47ea-5a5f-9e3a-aab16ea89798'::UUID, 4, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('c2ab9048-8877-59c7-ad35-80cc596d4135'::UUID, 'foundation:分钟', '分钟', 'fēnzhōng', 'phút', 'minute', 'starter', 'time', 'danh từ', '请等五分钟。', 'Qǐng děng wǔ fēnzhōng.', 'Vui lòng đợi năm phút.', 1, 'published', 'e5a77950-bd6d-5080-8434-b7ec4b17e279'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('77d91804-75f6-54e1-9ae3-cb490fa60fb9'::UUID, 'e5a77950-bd6d-5080-8434-b7ec4b17e279'::UUID, 'c2ab9048-8877-59c7-ad35-80cc596d4135'::UUID, 5, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('a6fe058f-b834-5aa5-988d-73745daa086a'::UUID, 'e5a77950-bd6d-5080-8434-b7ec4b17e279'::UUID, 'c9808f2b-7b4c-50fd-b27f-3f9ca944c91f'::UUID, 6, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('7fc1b55e-5111-5f9b-9c39-14d911f032df'::UUID, 'e5a77950-bd6d-5080-8434-b7ec4b17e279'::UUID, 'c8b6cb2b-901e-5926-b935-1d6c66a3f16a'::UUID, 7, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('fc72ffc6-e8eb-5466-aee0-a1f84568cb9b'::UUID, 'e5a77950-bd6d-5080-8434-b7ec4b17e279'::UUID, '9c612634-0de7-5b2b-aa23-fafc039e386c'::UUID, 8, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('2000b92a-a832-56e7-8f45-4bf82f94263d'::UUID, 'e5a77950-bd6d-5080-8434-b7ec4b17e279'::UUID, '1ea38532-9419-5a76-b964-e0b147aea634'::UUID, 9, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('eafb9747-8121-5ed0-a727-f456052b553c'::UUID, 'e5a77950-bd6d-5080-8434-b7ec4b17e279'::UUID, '5a6c73f9-0881-5285-94d1-124428914976'::UUID, 10, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.grammar_lessons (id, content_key, title, pattern, explanation, example_chinese, example_pinyin, example_meaning, level, status, usage_note, content_version)
VALUES ('9632b5ca-aba2-532f-888b-da79da75f754'::UUID, 'foundation:time-before-verb', 'Thời gian đứng trước động từ', 'Chủ ngữ + thời gian + động từ', 'Mốc giờ thường đứng sau chủ ngữ và trước hành động.', '我七点起床。', 'Wǒ qī diǎn qǐchuáng.', 'Tôi thức dậy lúc bảy giờ.', 'starter', 'published', 'Từ chỉ ngày như 今天 có thể đứng đầu câu hoặc sau chủ ngữ.', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_grammar (id, lesson_id, grammar_lesson_id, order_index, curriculum_role)
VALUES ('dd89d9e4-2343-515c-be44-d17c3ac1fa68'::UUID, 'e5a77950-bd6d-5080-8434-b7ec4b17e279'::UUID, '9632b5ca-aba2-532f-888b-da79da75f754'::UUID, 1, 'introduced')
ON CONFLICT (lesson_id, grammar_lesson_id) DO NOTHING;

INSERT INTO public.lesson_grammar (id, lesson_id, grammar_lesson_id, order_index, curriculum_role)
VALUES ('0ac00e89-32d9-55a7-ac90-dcc61ba26005'::UUID, 'e5a77950-bd6d-5080-8434-b7ec4b17e279'::UUID, 'ed17b98c-f80a-56bd-9274-371dcf28e056'::UUID, 2, 'review')
ON CONFLICT (lesson_id, grammar_lesson_id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('bd512c07-e13f-5686-98a1-48bd1928aed9'::UUID, 'e5a77950-bd6d-5080-8434-b7ec4b17e279'::UUID, 'vocabulary', 1, 'Từ mới: 今天', NULL, '今天', '今天 (jīntiān) — hôm nay. 今天是星期一。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"foundation:今天","chinese":"今天","pinyin":"jīntiān","meaning":"hôm nay","part_of_speech":"danh từ thời gian","example_chinese":"今天是星期一。","example_pinyin":"Jīntiān shì Xīngqīyī.","example_meaning_vi":"Hôm nay là thứ Hai."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('79916d18-321a-5f6b-904f-7da94dbb63ee'::UUID, 'e5a77950-bd6d-5080-8434-b7ec4b17e279'::UUID, 'vocabulary', 2, 'Từ mới: 明天', NULL, '明天', '明天 (míngtiān) — ngày mai. 明天我们见面。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"foundation:明天","chinese":"明天","pinyin":"míngtiān","meaning":"ngày mai","part_of_speech":"danh từ thời gian","example_chinese":"明天我们见面。","example_pinyin":"Míngtiān wǒmen jiànmiàn.","example_meaning_vi":"Ngày mai chúng ta gặp nhau."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('57bcc03f-1872-598b-ab12-82368b338325'::UUID, 'e5a77950-bd6d-5080-8434-b7ec4b17e279'::UUID, 'vocabulary', 3, 'Từ mới: 现在', NULL, '现在', '现在 (xiànzài) — bây giờ. 现在八点。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"foundation:现在","chinese":"现在","pinyin":"xiànzài","meaning":"bây giờ","part_of_speech":"danh từ thời gian","example_chinese":"现在八点。","example_pinyin":"Xiànzài bā diǎn.","example_meaning_vi":"Bây giờ là tám giờ."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('246a9790-d742-5350-8b9a-90d9f32430da'::UUID, 'e5a77950-bd6d-5080-8434-b7ec4b17e279'::UUID, 'vocabulary', 4, 'Từ mới: 点', NULL, '点', '点 (diǎn) — giờ (khi nói thời gian). 我七点起床。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"foundation:点","chinese":"点","pinyin":"diǎn","meaning":"giờ (khi nói thời gian)","part_of_speech":"lượng từ thời gian","example_chinese":"我七点起床。","example_pinyin":"Wǒ qī diǎn qǐchuáng.","example_meaning_vi":"Tôi thức dậy lúc bảy giờ."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('fdc5f546-a5e3-5a72-86eb-88feb0e0a4dd'::UUID, 'e5a77950-bd6d-5080-8434-b7ec4b17e279'::UUID, 'vocabulary', 5, 'Từ mới: 分钟', NULL, '分钟', '分钟 (fēnzhōng) — phút. 请等五分钟。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"foundation:分钟","chinese":"分钟","pinyin":"fēnzhōng","meaning":"phút","part_of_speech":"danh từ","example_chinese":"请等五分钟。","example_pinyin":"Qǐng děng wǔ fēnzhōng.","example_meaning_vi":"Vui lòng đợi năm phút."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('36888100-faa7-5e08-bb15-dd503f8361f6'::UUID, 'e5a77950-bd6d-5080-8434-b7ec4b17e279'::UUID, 'multiple_choice', 6, '“现在” có nghĩa phù hợp nhất là gì?', NULL, 'bây giờ', '现在 (xiànzài) nghĩa là “bây giờ”.', NULL, 1, '{"activity_type":"chinese_to_vietnamese","vocabulary_key":"foundation:现在"}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('f5d5a96c-d6fa-5ea6-a451-25b522d115c8'::UUID, '36888100-faa7-5e08-bb15-dd503f8361f6'::UUID, 'phút', FALSE, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('5acd64b5-f2d4-529f-9c97-5007ad595655'::UUID, '36888100-faa7-5e08-bb15-dd503f8361f6'::UUID, 'bây giờ', TRUE, 2)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('22139d68-4d7b-5444-a1e4-29d764866536'::UUID, '36888100-faa7-5e08-bb15-dd503f8361f6'::UUID, 'hôm nay', FALSE, 3)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('0df740b9-55cb-512e-8781-bcac3afdbe98'::UUID, '36888100-faa7-5e08-bb15-dd503f8361f6'::UUID, 'ngày mai', FALSE, 4)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('2da72acf-e452-5e04-aa18-356c88170d02'::UUID, 'e5a77950-bd6d-5080-8434-b7ec4b17e279'::UUID, 'translation', 7, 'Dịch sang tiếng Trung: “Bây giờ là tám giờ.”', NULL, '现在八点。', 'Mẫu câu dùng “现在” trong ngữ cảnh của bài.', 'xiànzài', 1, '{"activity_type":"vietnamese_to_chinese","source_lang":"vi","target_lang":"zh","acceptable_answers":["现在八点。"]}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('4d960787-fb61-589d-986c-4551a3021cf3'::UUID, 'e5a77950-bd6d-5080-8434-b7ec4b17e279'::UUID, 'sentence_builder', 8, 'Sắp xếp các thành phần thành câu đúng.', NULL, '现在八点。', 'Trật tự đúng tạo thành câu “现在八点。”.', NULL, 1, '{"activity_type":"sentence_ordering","words":["现在","八","点","。"],"correct_order":["现在","八","点","。"]}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('037b3629-42f3-5ebf-82c1-25f287454b37'::UUID, 'e5a77950-bd6d-5080-8434-b7ec4b17e279'::UUID, 'multiple_choice', 9, 'Câu nào có trật tự tự nhiên?', NULL, '我七点起床。', 'Mốc thời gian 七点 đứng trước động từ 起床.', NULL, 1, '{"activity_type":"grammar_selection","passage":null,"grammar_key":"foundation:time-before-verb"}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('3b7813c1-aa17-5b51-b725-e39ab6f1b4f3'::UUID, '037b3629-42f3-5ebf-82c1-25f287454b37'::UUID, '我七点起床。', TRUE, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('0a8ae48f-2365-5af7-a42a-1bbd8103cef9'::UUID, '037b3629-42f3-5ebf-82c1-25f287454b37'::UUID, '我起床七点。', FALSE, 2)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('384293ce-2e38-53d5-bbaa-bdf66ec1b270'::UUID, '037b3629-42f3-5ebf-82c1-25f287454b37'::UUID, '七起床我点。', FALSE, 3)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('6a963960-411a-533a-ad2b-de8fee25e952'::UUID, 'e5a77950-bd6d-5080-8434-b7ec4b17e279'::UUID, 'speaking', 10, 'Đọc thành tiếng: 现在八点。', NULL, '现在八点。', 'Đọc chậm, giữ đúng thanh điệu và nhịp của cả câu.', NULL, 1, '{"activity_type":"pronunciation","text":"现在八点。","pinyin":"Xiànzài bā diǎn."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.chapters (id, unit_id, slug, title, description, order_index, status, learning_objectives, content_version)
VALUES ('b477ec9c-a7fa-5abf-9e65-8d40989befde'::UUID, 'baf1538b-0780-5683-81ec-7be46cd81fcc'::UUID, 'hoat-dong-va-mua-sam', 'Hoạt động và mua sắm', 'Nói hoạt động trong ngày, gọi đồ uống và hỏi giá.', 2, 'published', '["Mô tả thói quen","Hỏi giá món ăn, đồ uống"]'::JSONB, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lessons (id, chapter_id, slug, title, description, order_index, xp_reward, status, lesson_type, estimated_minutes, learning_objectives, cultural_note, content_version)
VALUES ('a31244dd-d46d-5763-821c-909302dcf743'::UUID, 'b477ec9c-a7fa-5abf-9e65-8d40989befde'::UUID, 'hoat-dong-hang-ngay', '我的一天 - Một ngày của tôi', 'Các động từ sinh hoạt và trình tự hoạt động.', 1, 20, 'published', 'standard', 12, '["Nói bốn hoạt động quen thuộc trong ngày"]'::JSONB, NULL, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('4186d928-779f-5977-8383-55e16ed403e0'::UUID, 'foundation:起床', '起床', 'qǐchuáng', 'thức dậy, rời giường', 'get up', 'starter', 'daily_routine', 'động từ', '我每天六点起床。', 'Wǒ měitiān liù diǎn qǐchuáng.', 'Mỗi ngày tôi thức dậy lúc sáu giờ.', 1, 'published', 'a31244dd-d46d-5763-821c-909302dcf743'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('a1578fd5-b463-5741-b22c-7085528130ce'::UUID, 'a31244dd-d46d-5763-821c-909302dcf743'::UUID, '4186d928-779f-5977-8383-55e16ed403e0'::UUID, 1, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('fafc9144-dfe6-590a-818e-55b052a3b54d'::UUID, 'foundation:吃饭', '吃饭', 'chīfàn', 'ăn cơm, dùng bữa', 'eat a meal', 'starter', 'daily_routine', 'động từ', '我们十二点吃饭。', 'Wǒmen shí''èr diǎn chīfàn.', 'Chúng tôi ăn lúc mười hai giờ.', 1, 'published', 'a31244dd-d46d-5763-821c-909302dcf743'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('95999823-9882-51b9-97c5-c5be1e480237'::UUID, 'a31244dd-d46d-5763-821c-909302dcf743'::UUID, 'fafc9144-dfe6-590a-818e-55b052a3b54d'::UUID, 2, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('3cdc325b-8d79-5a27-a746-e729758fe09d'::UUID, 'foundation:学习', '学习', 'xuéxí', 'học tập', 'study', 'starter', 'daily_routine', 'động từ', '我学习汉语。', 'Wǒ xuéxí Hànyǔ.', 'Tôi học tiếng Trung.', 1, 'published', 'a31244dd-d46d-5763-821c-909302dcf743'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('2584cce7-b6c9-5764-81d2-bdefdb6ec236'::UUID, 'a31244dd-d46d-5763-821c-909302dcf743'::UUID, '3cdc325b-8d79-5a27-a746-e729758fe09d'::UUID, 3, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('04c4fcaf-338f-5e7e-99b4-dc02f5b11f8e'::UUID, 'foundation:工作', '工作', 'gōngzuò', 'làm việc, công việc', 'work', 'starter', 'daily_routine', 'động từ/danh từ', '爸爸在银行工作。', 'Bàba zài yínháng gōngzuò.', 'Bố làm việc ở ngân hàng.', 1, 'published', 'a31244dd-d46d-5763-821c-909302dcf743'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('7a017463-970c-5a48-bdeb-b249aac6843d'::UUID, 'a31244dd-d46d-5763-821c-909302dcf743'::UUID, '04c4fcaf-338f-5e7e-99b4-dc02f5b11f8e'::UUID, 4, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('d7d61680-13ed-5bf6-84bc-069bd30b53b2'::UUID, 'foundation:睡觉', '睡觉', 'shuìjiào', 'đi ngủ', 'sleep', 'starter', 'daily_routine', 'động từ', '我十点睡觉。', 'Wǒ shí diǎn shuìjiào.', 'Tôi đi ngủ lúc mười giờ.', 1, 'published', 'a31244dd-d46d-5763-821c-909302dcf743'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('dfae6700-6b64-5fc6-b962-240facaaf17d'::UUID, 'a31244dd-d46d-5763-821c-909302dcf743'::UUID, 'd7d61680-13ed-5bf6-84bc-069bd30b53b2'::UUID, 5, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('950b146d-6140-5aa9-9024-3ba36fb34fca'::UUID, 'a31244dd-d46d-5763-821c-909302dcf743'::UUID, '6a7bac41-7cc6-5b92-86fb-d78a49460de7'::UUID, 6, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('7616e0bf-9acc-5b84-b400-983336f31000'::UUID, 'a31244dd-d46d-5763-821c-909302dcf743'::UUID, '8546e8fa-1a87-5798-a312-a3bd52370710'::UUID, 7, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('312023f7-a6bc-5d90-b285-0ec1127c84e2'::UUID, 'a31244dd-d46d-5763-821c-909302dcf743'::UUID, 'b3f21e12-613c-53c4-b161-215ebad4b593'::UUID, 8, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('c55142e0-43f1-5707-a6f0-816aeaf698b6'::UUID, 'a31244dd-d46d-5763-821c-909302dcf743'::UUID, 'dbd9e534-47ea-5a5f-9e3a-aab16ea89798'::UUID, 9, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('195b2d44-fa24-5633-8d6c-a80b045ad263'::UUID, 'a31244dd-d46d-5763-821c-909302dcf743'::UUID, 'c2ab9048-8877-59c7-ad35-80cc596d4135'::UUID, 10, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.grammar_lessons (id, content_key, title, pattern, explanation, example_chinese, example_pinyin, example_meaning, level, status, usage_note, content_version)
VALUES ('e242badd-9725-533f-ae67-abb1ecf4e82a'::UUID, 'foundation:first-then', 'Trình tự 先...再...', '先 + hành động 1 + 再 + hành động 2', '先...再... diễn tả làm việc thứ nhất rồi mới làm việc thứ hai.', '我先学习，再睡觉。', 'Wǒ xiān xuéxí, zài shuìjiào.', 'Tôi học trước, rồi đi ngủ.', 'starter', 'published', '再 ở đây chỉ bước tiếp theo, không phải nghĩa “lại”.', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_grammar (id, lesson_id, grammar_lesson_id, order_index, curriculum_role)
VALUES ('3c4e8192-05f3-5109-af4d-91f306592964'::UUID, 'a31244dd-d46d-5763-821c-909302dcf743'::UUID, 'e242badd-9725-533f-ae67-abb1ecf4e82a'::UUID, 1, 'introduced')
ON CONFLICT (lesson_id, grammar_lesson_id) DO NOTHING;

INSERT INTO public.lesson_grammar (id, lesson_id, grammar_lesson_id, order_index, curriculum_role)
VALUES ('089c35ab-ab94-5c3f-acdc-7d85a0cceb59'::UUID, 'a31244dd-d46d-5763-821c-909302dcf743'::UUID, '9632b5ca-aba2-532f-888b-da79da75f754'::UUID, 2, 'review')
ON CONFLICT (lesson_id, grammar_lesson_id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('f68c49d0-bab7-5f71-897b-8875e4e0b618'::UUID, 'a31244dd-d46d-5763-821c-909302dcf743'::UUID, 'vocabulary', 1, 'Từ mới: 起床', NULL, '起床', '起床 (qǐchuáng) — thức dậy, rời giường. 我每天六点起床。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"foundation:起床","chinese":"起床","pinyin":"qǐchuáng","meaning":"thức dậy, rời giường","part_of_speech":"động từ","example_chinese":"我每天六点起床。","example_pinyin":"Wǒ měitiān liù diǎn qǐchuáng.","example_meaning_vi":"Mỗi ngày tôi thức dậy lúc sáu giờ."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('cb79ad64-8439-5cc0-82d4-56abb5e7dd37'::UUID, 'a31244dd-d46d-5763-821c-909302dcf743'::UUID, 'vocabulary', 2, 'Từ mới: 吃饭', NULL, '吃饭', '吃饭 (chīfàn) — ăn cơm, dùng bữa. 我们十二点吃饭。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"foundation:吃饭","chinese":"吃饭","pinyin":"chīfàn","meaning":"ăn cơm, dùng bữa","part_of_speech":"động từ","example_chinese":"我们十二点吃饭。","example_pinyin":"Wǒmen shí''èr diǎn chīfàn.","example_meaning_vi":"Chúng tôi ăn lúc mười hai giờ."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('e45fb5f2-90e6-5896-a130-71581fb5ceca'::UUID, 'a31244dd-d46d-5763-821c-909302dcf743'::UUID, 'vocabulary', 3, 'Từ mới: 学习', NULL, '学习', '学习 (xuéxí) — học tập. 我学习汉语。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"foundation:学习","chinese":"学习","pinyin":"xuéxí","meaning":"học tập","part_of_speech":"động từ","example_chinese":"我学习汉语。","example_pinyin":"Wǒ xuéxí Hànyǔ.","example_meaning_vi":"Tôi học tiếng Trung."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('c5f6d647-36f5-5328-bc9c-93da6d71a900'::UUID, 'a31244dd-d46d-5763-821c-909302dcf743'::UUID, 'vocabulary', 4, 'Từ mới: 工作', NULL, '工作', '工作 (gōngzuò) — làm việc, công việc. 爸爸在银行工作。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"foundation:工作","chinese":"工作","pinyin":"gōngzuò","meaning":"làm việc, công việc","part_of_speech":"động từ/danh từ","example_chinese":"爸爸在银行工作。","example_pinyin":"Bàba zài yínháng gōngzuò.","example_meaning_vi":"Bố làm việc ở ngân hàng."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('edc1338a-e369-5d5b-8755-65c915cfbd92'::UUID, 'a31244dd-d46d-5763-821c-909302dcf743'::UUID, 'vocabulary', 5, 'Từ mới: 睡觉', NULL, '睡觉', '睡觉 (shuìjiào) — đi ngủ. 我十点睡觉。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"foundation:睡觉","chinese":"睡觉","pinyin":"shuìjiào","meaning":"đi ngủ","part_of_speech":"động từ","example_chinese":"我十点睡觉。","example_pinyin":"Wǒ shí diǎn shuìjiào.","example_meaning_vi":"Tôi đi ngủ lúc mười giờ."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('25deb3dd-ba1e-5a0c-9365-47c744d77bf5'::UUID, 'a31244dd-d46d-5763-821c-909302dcf743'::UUID, 'multiple_choice', 6, '“学习” có nghĩa phù hợp nhất là gì?', NULL, 'học tập', '学习 (xuéxí) nghĩa là “học tập”.', NULL, 1, '{"activity_type":"chinese_to_vietnamese","vocabulary_key":"foundation:学习"}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('daf0ca1a-8258-593e-ad87-9e9a624c14eb'::UUID, '25deb3dd-ba1e-5a0c-9365-47c744d77bf5'::UUID, 'làm việc, công việc', FALSE, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('c944cc00-6316-5c6d-b95f-011d4a96aa75'::UUID, '25deb3dd-ba1e-5a0c-9365-47c744d77bf5'::UUID, 'đi ngủ', FALSE, 2)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('d94f3530-880a-5995-9779-e131a484e77a'::UUID, '25deb3dd-ba1e-5a0c-9365-47c744d77bf5'::UUID, 'ăn cơm, dùng bữa', FALSE, 3)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('82a06769-5747-54de-954a-76ecb8c3f26e'::UUID, '25deb3dd-ba1e-5a0c-9365-47c744d77bf5'::UUID, 'học tập', TRUE, 4)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('a3ce55d4-c99b-5e64-a749-f9bca0604dd5'::UUID, 'a31244dd-d46d-5763-821c-909302dcf743'::UUID, 'translation', 7, 'Dịch sang tiếng Trung: “Tôi học tiếng Trung.”', NULL, '我学习汉语。', 'Mẫu câu dùng “学习” trong ngữ cảnh của bài.', 'xuéxí', 1, '{"activity_type":"vietnamese_to_chinese","source_lang":"vi","target_lang":"zh","acceptable_answers":["我学习汉语。"]}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('6acf50b0-b91a-5dde-94f8-13dda189f884'::UUID, 'a31244dd-d46d-5763-821c-909302dcf743'::UUID, 'sentence_builder', 8, 'Sắp xếp các thành phần thành câu đúng.', NULL, '我学习汉语。', 'Trật tự đúng tạo thành câu “我学习汉语。”.', NULL, 1, '{"activity_type":"sentence_ordering","words":["我","学习","汉语","。"],"correct_order":["我","学习","汉语","。"]}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('66d1cfdd-a302-5cff-ae0e-321da9ea8d7e'::UUID, 'a31244dd-d46d-5763-821c-909302dcf743'::UUID, 'multiple_choice', 9, 'Câu nào diễn tả “học trước rồi đi ngủ”?', NULL, '先学习，再睡觉。', '先 đánh dấu hành động đầu; 再 giới thiệu hành động tiếp theo.', NULL, 1, '{"activity_type":"grammar_selection","passage":null,"grammar_key":"foundation:first-then"}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('15f9a47a-cdd6-55f7-ac5a-77358a4b2f40'::UUID, '66d1cfdd-a302-5cff-ae0e-321da9ea8d7e'::UUID, '先学习，再睡觉。', TRUE, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('ca476fcb-e233-5640-a290-b9c19c4fe9e8'::UUID, '66d1cfdd-a302-5cff-ae0e-321da9ea8d7e'::UUID, '再学习，先睡觉。', FALSE, 2)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('ee8eb474-9964-57ab-ac01-e8cd16a00235'::UUID, '66d1cfdd-a302-5cff-ae0e-321da9ea8d7e'::UUID, '学习先睡觉再。', FALSE, 3)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('608bc3ad-ce30-55c4-9955-18f5638fab75'::UUID, 'a31244dd-d46d-5763-821c-909302dcf743'::UUID, 'speaking', 10, 'Đọc thành tiếng: 我学习汉语。', NULL, '我学习汉语。', 'Đọc chậm, giữ đúng thanh điệu và nhịp của cả câu.', NULL, 1, '{"activity_type":"pronunciation","text":"我学习汉语。","pinyin":"Wǒ xuéxí Hànyǔ."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lessons (id, chapter_id, slug, title, description, order_index, xp_reward, status, lesson_type, estimated_minutes, learning_objectives, cultural_note, content_version)
VALUES ('e86c4323-6319-5c95-bc71-d6fe6c98e3be'::UUID, 'b477ec9c-a7fa-5abf-9e65-8d40989befde'::UUID, 'do-an-va-gia-ca', '多少钱？ - Bao nhiêu tiền?', 'Gọi món đơn giản và hỏi giá.', 2, 20, 'published', 'standard', 12, '["Hỏi giá và nói nhu cầu mua món cơ bản"]'::JSONB, NULL, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('f11f19aa-9dfb-5011-af72-249acfce7246'::UUID, 'foundation:米饭', '米饭', 'mǐfàn', 'cơm', 'cooked rice', 'starter', 'food', 'danh từ', '我想吃米饭。', 'Wǒ xiǎng chī mǐfàn.', 'Tôi muốn ăn cơm.', 1, 'published', 'e86c4323-6319-5c95-bc71-d6fe6c98e3be'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('3dbe0222-4346-5144-831c-f0a0ac882f00'::UUID, 'e86c4323-6319-5c95-bc71-d6fe6c98e3be'::UUID, 'f11f19aa-9dfb-5011-af72-249acfce7246'::UUID, 1, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('8b4027a7-6a7e-542a-a0e6-9b7de1728c7f'::UUID, 'foundation:水', '水', 'shuǐ', 'nước', 'water', 'starter', 'food', 'danh từ', '请给我一杯水。', 'Qǐng gěi wǒ yì bēi shuǐ.', 'Vui lòng cho tôi một cốc nước.', 1, 'published', 'e86c4323-6319-5c95-bc71-d6fe6c98e3be'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('06acafe1-bcf4-56a8-95a8-6f5f1a6e9007'::UUID, 'e86c4323-6319-5c95-bc71-d6fe6c98e3be'::UUID, '8b4027a7-6a7e-542a-a0e6-9b7de1728c7f'::UUID, 2, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('05836bb7-8f4c-5ccd-90a1-a3847259a984'::UUID, 'foundation:茶', '茶', 'chá', 'trà', 'tea', 'starter', 'food', 'danh từ', '这杯茶很好喝。', 'Zhè bēi chá hěn hǎohē.', 'Cốc trà này rất ngon.', 1, 'published', 'e86c4323-6319-5c95-bc71-d6fe6c98e3be'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('fef60345-de0f-5e22-99e3-67f107de3e2a'::UUID, 'e86c4323-6319-5c95-bc71-d6fe6c98e3be'::UUID, '05836bb7-8f4c-5ccd-90a1-a3847259a984'::UUID, 3, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('11eb3139-6193-5a33-ad16-0c5365a413cb'::UUID, 'foundation:多少钱', '多少钱', 'duōshao qián', 'bao nhiêu tiền', 'how much money', 'starter', 'shopping', 'cụm nghi vấn', '这杯茶多少钱？', 'Zhè bēi chá duōshao qián?', 'Cốc trà này bao nhiêu tiền?', 1, 'published', 'e86c4323-6319-5c95-bc71-d6fe6c98e3be'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('92693134-af74-57dc-ae0a-b8f0ab46ab0b'::UUID, 'e86c4323-6319-5c95-bc71-d6fe6c98e3be'::UUID, '11eb3139-6193-5a33-ad16-0c5365a413cb'::UUID, 4, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('a7c41243-3c0c-50dd-9906-ca4b006fc913'::UUID, 'foundation:买', '买', 'mǎi', 'mua', 'buy', 'starter', 'shopping', 'động từ', '我买两瓶水。', 'Wǒ mǎi liǎng píng shuǐ.', 'Tôi mua hai chai nước.', 1, 'published', 'e86c4323-6319-5c95-bc71-d6fe6c98e3be'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('3df80b34-ded9-5721-a052-57adabdd39fd'::UUID, 'e86c4323-6319-5c95-bc71-d6fe6c98e3be'::UUID, 'a7c41243-3c0c-50dd-9906-ca4b006fc913'::UUID, 5, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('1b2f90d5-737a-5247-99a2-b987c097f5e5'::UUID, 'e86c4323-6319-5c95-bc71-d6fe6c98e3be'::UUID, '4186d928-779f-5977-8383-55e16ed403e0'::UUID, 6, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('541c4c54-852c-59e4-adb3-e38db2fccb4a'::UUID, 'e86c4323-6319-5c95-bc71-d6fe6c98e3be'::UUID, 'fafc9144-dfe6-590a-818e-55b052a3b54d'::UUID, 7, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('d2359865-fca7-5b9e-972d-aba60df964fd'::UUID, 'e86c4323-6319-5c95-bc71-d6fe6c98e3be'::UUID, '3cdc325b-8d79-5a27-a746-e729758fe09d'::UUID, 8, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('b933e160-2672-5c6a-9876-c4e1e119ede5'::UUID, 'e86c4323-6319-5c95-bc71-d6fe6c98e3be'::UUID, '04c4fcaf-338f-5e7e-99b4-dc02f5b11f8e'::UUID, 9, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('2f323c32-491f-511a-9ec4-985cea26cc9e'::UUID, 'e86c4323-6319-5c95-bc71-d6fe6c98e3be'::UUID, 'd7d61680-13ed-5bf6-84bc-069bd30b53b2'::UUID, 10, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.grammar_lessons (id, content_key, title, pattern, explanation, example_chinese, example_pinyin, example_meaning, level, status, usage_note, content_version)
VALUES ('dc9eb19c-d0a3-52ca-a11d-1f8bd368eccf'::UUID, 'foundation:how-much', 'Hỏi giá với 多少钱', 'Danh từ + 多少钱？', 'Đặt 多少钱 sau món đồ để hỏi giá.', '这杯茶多少钱？', 'Zhè bēi chá duōshao qián?', 'Cốc trà này bao nhiêu tiền?', 'starter', 'published', 'Có thể nói ngắn gọn 多少钱？ khi món đồ đã rõ.', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_grammar (id, lesson_id, grammar_lesson_id, order_index, curriculum_role)
VALUES ('d6c355cc-3a46-5e61-a84b-25e6bc31f382'::UUID, 'e86c4323-6319-5c95-bc71-d6fe6c98e3be'::UUID, 'dc9eb19c-d0a3-52ca-a11d-1f8bd368eccf'::UUID, 1, 'introduced')
ON CONFLICT (lesson_id, grammar_lesson_id) DO NOTHING;

INSERT INTO public.lesson_grammar (id, lesson_id, grammar_lesson_id, order_index, curriculum_role)
VALUES ('fe508c06-685c-5264-92b7-265eb6f77529'::UUID, 'e86c4323-6319-5c95-bc71-d6fe6c98e3be'::UUID, 'e242badd-9725-533f-ae67-abb1ecf4e82a'::UUID, 2, 'review')
ON CONFLICT (lesson_id, grammar_lesson_id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('2a1f890d-6da1-58b5-9554-283daac56290'::UUID, 'e86c4323-6319-5c95-bc71-d6fe6c98e3be'::UUID, 'vocabulary', 1, 'Từ mới: 米饭', NULL, '米饭', '米饭 (mǐfàn) — cơm. 我想吃米饭。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"foundation:米饭","chinese":"米饭","pinyin":"mǐfàn","meaning":"cơm","part_of_speech":"danh từ","example_chinese":"我想吃米饭。","example_pinyin":"Wǒ xiǎng chī mǐfàn.","example_meaning_vi":"Tôi muốn ăn cơm."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('61e56c82-ff21-5d91-b275-9dfac08e403a'::UUID, 'e86c4323-6319-5c95-bc71-d6fe6c98e3be'::UUID, 'vocabulary', 2, 'Từ mới: 水', NULL, '水', '水 (shuǐ) — nước. 请给我一杯水。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"foundation:水","chinese":"水","pinyin":"shuǐ","meaning":"nước","part_of_speech":"danh từ","example_chinese":"请给我一杯水。","example_pinyin":"Qǐng gěi wǒ yì bēi shuǐ.","example_meaning_vi":"Vui lòng cho tôi một cốc nước."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('6e6019d5-32ea-50ac-8377-482e8695f639'::UUID, 'e86c4323-6319-5c95-bc71-d6fe6c98e3be'::UUID, 'vocabulary', 3, 'Từ mới: 茶', NULL, '茶', '茶 (chá) — trà. 这杯茶很好喝。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"foundation:茶","chinese":"茶","pinyin":"chá","meaning":"trà","part_of_speech":"danh từ","example_chinese":"这杯茶很好喝。","example_pinyin":"Zhè bēi chá hěn hǎohē.","example_meaning_vi":"Cốc trà này rất ngon."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('ccea12f5-1ce0-5ce2-9216-dc7aa113ccda'::UUID, 'e86c4323-6319-5c95-bc71-d6fe6c98e3be'::UUID, 'vocabulary', 4, 'Từ mới: 多少钱', NULL, '多少钱', '多少钱 (duōshao qián) — bao nhiêu tiền. 这杯茶多少钱？', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"foundation:多少钱","chinese":"多少钱","pinyin":"duōshao qián","meaning":"bao nhiêu tiền","part_of_speech":"cụm nghi vấn","example_chinese":"这杯茶多少钱？","example_pinyin":"Zhè bēi chá duōshao qián?","example_meaning_vi":"Cốc trà này bao nhiêu tiền?"}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('4ddace76-68bf-55e4-8763-c171dd87b164'::UUID, 'e86c4323-6319-5c95-bc71-d6fe6c98e3be'::UUID, 'vocabulary', 5, 'Từ mới: 买', NULL, '买', '买 (mǎi) — mua. 我买两瓶水。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"foundation:买","chinese":"买","pinyin":"mǎi","meaning":"mua","part_of_speech":"động từ","example_chinese":"我买两瓶水。","example_pinyin":"Wǒ mǎi liǎng píng shuǐ.","example_meaning_vi":"Tôi mua hai chai nước."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('6664cc51-4817-5232-8905-f1a028a5ee3f'::UUID, 'e86c4323-6319-5c95-bc71-d6fe6c98e3be'::UUID, 'multiple_choice', 6, '“多少钱” có nghĩa phù hợp nhất là gì?', NULL, 'bao nhiêu tiền', '多少钱 (duōshao qián) nghĩa là “bao nhiêu tiền”.', NULL, 1, '{"activity_type":"chinese_to_vietnamese","vocabulary_key":"foundation:多少钱"}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('bc18efc4-c0ca-5733-a7de-307b265c40c5'::UUID, '6664cc51-4817-5232-8905-f1a028a5ee3f'::UUID, 'bao nhiêu tiền', TRUE, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('f84f5e1b-cf65-53da-b146-535189db54e4'::UUID, '6664cc51-4817-5232-8905-f1a028a5ee3f'::UUID, 'cơm', FALSE, 2)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('25a38c9a-76e1-530b-a690-7277370fc2cd'::UUID, '6664cc51-4817-5232-8905-f1a028a5ee3f'::UUID, 'nước', FALSE, 3)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('f30a6162-15ec-55ec-bd0c-892fea925410'::UUID, '6664cc51-4817-5232-8905-f1a028a5ee3f'::UUID, 'mua', FALSE, 4)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('8f6e20c1-1824-5fd0-afeb-cc3b60249181'::UUID, 'e86c4323-6319-5c95-bc71-d6fe6c98e3be'::UUID, 'translation', 7, 'Dịch sang tiếng Trung: “Cốc trà này bao nhiêu tiền?”', NULL, '这杯茶多少钱？', 'Mẫu câu dùng “多少钱” trong ngữ cảnh của bài.', 'duōshao qián', 1, '{"activity_type":"vietnamese_to_chinese","source_lang":"vi","target_lang":"zh","acceptable_answers":["这杯茶多少钱？"]}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('cea471c5-a5b1-54a7-bf00-6a90767316ae'::UUID, 'e86c4323-6319-5c95-bc71-d6fe6c98e3be'::UUID, 'sentence_builder', 8, 'Sắp xếp các thành phần thành câu đúng.', NULL, '这杯茶多少钱？', 'Trật tự đúng tạo thành câu “这杯茶多少钱？”.', NULL, 1, '{"activity_type":"sentence_ordering","words":["这","杯","茶","多少","钱","？"],"correct_order":["这","杯","茶","多少","钱","？"]}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('31e404a7-9fb3-5a0f-881c-eb88c43f72fe'::UUID, 'e86c4323-6319-5c95-bc71-d6fe6c98e3be'::UUID, 'multiple_choice', 9, 'Muốn hỏi giá cốc trà, dùng câu nào?', NULL, '这杯茶多少钱？', '多少钱 là cụm nghi vấn về giá tiền.', NULL, 1, '{"activity_type":"grammar_selection","passage":null,"grammar_key":"foundation:how-much"}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('54fa7ebd-a1ab-56a8-8b7e-6e5d97e963ff'::UUID, '31e404a7-9fb3-5a0f-881c-eb88c43f72fe'::UUID, '这杯茶多少钱？', TRUE, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('441d4e74-10a7-570b-ac24-c286a941591d'::UUID, '31e404a7-9fb3-5a0f-881c-eb88c43f72fe'::UUID, '这杯茶什么人？', FALSE, 2)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('4601601f-b399-55a3-90ad-ee4b3d04d3fd'::UUID, '31e404a7-9fb3-5a0f-881c-eb88c43f72fe'::UUID, '这杯茶几点？', FALSE, 3)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('f981e82b-6320-5689-b193-7af6a419441c'::UUID, 'e86c4323-6319-5c95-bc71-d6fe6c98e3be'::UUID, 'speaking', 10, 'Đọc thành tiếng: 这杯茶多少钱？', NULL, '这杯茶多少钱？', 'Đọc chậm, giữ đúng thanh điệu và nhịp của cả câu.', NULL, 1, '{"activity_type":"pronunciation","text":"这杯茶多少钱？","pinyin":"Zhè bēi chá duōshao qián?"}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lessons (id, chapter_id, slug, title, description, order_index, xp_reward, status, lesson_type, estimated_minutes, learning_objectives, cultural_note, content_version)
VALUES ('0c573448-400a-5235-9bd7-629c7480b6ee'::UUID, 'b477ec9c-a7fa-5abf-9e65-8d40989befde'::UUID, 'on-tap-nen-tang', '复习 - Ôn tập nền tảng', 'Ôn giới thiệu, thời gian, sinh hoạt và mua sắm.', 3, 25, 'published', 'review', 15, '["Kết hợp từ và mẫu câu của toàn khóa vào hội thoại ngắn"]'::JSONB, NULL, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('5618298e-8f20-503b-9489-8d042a78331b'::UUID, '0c573448-400a-5235-9bd7-629c7480b6ee'::UUID, 'f11f19aa-9dfb-5011-af72-249acfce7246'::UUID, 1, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('5f1a8059-f50a-5268-a3fc-adfc061d7ede'::UUID, '0c573448-400a-5235-9bd7-629c7480b6ee'::UUID, '8b4027a7-6a7e-542a-a0e6-9b7de1728c7f'::UUID, 2, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('db468d70-06fd-5e5a-b4f2-e6063813fa7c'::UUID, '0c573448-400a-5235-9bd7-629c7480b6ee'::UUID, '05836bb7-8f4c-5ccd-90a1-a3847259a984'::UUID, 3, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('50281b17-f177-5005-8f51-5f186edd95f2'::UUID, '0c573448-400a-5235-9bd7-629c7480b6ee'::UUID, '11eb3139-6193-5a33-ad16-0c5365a413cb'::UUID, 4, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('d2a71e9e-a266-522b-b180-0353feea999a'::UUID, '0c573448-400a-5235-9bd7-629c7480b6ee'::UUID, 'a7c41243-3c0c-50dd-9906-ca4b006fc913'::UUID, 5, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('52b55519-5857-5c53-b468-8c68577553bc'::UUID, '0c573448-400a-5235-9bd7-629c7480b6ee'::UUID, '3cdc325b-8d79-5a27-a746-e729758fe09d'::UUID, 6, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('028de559-e84b-5716-9578-2e49696470b6'::UUID, '0c573448-400a-5235-9bd7-629c7480b6ee'::UUID, '04c4fcaf-338f-5e7e-99b4-dc02f5b11f8e'::UUID, 7, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('47dcd01d-38b2-5cc0-9eb7-0e39a822e1ab'::UUID, '0c573448-400a-5235-9bd7-629c7480b6ee'::UUID, '6a7bac41-7cc6-5b92-86fb-d78a49460de7'::UUID, 8, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('44a76d82-a431-5b1a-ab60-ff586e9744a5'::UUID, '0c573448-400a-5235-9bd7-629c7480b6ee'::UUID, 'c8b6cb2b-901e-5926-b935-1d6c66a3f16a'::UUID, 9, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('9d4ad823-d966-52bb-93c9-44bc74ab7707'::UUID, '0c573448-400a-5235-9bd7-629c7480b6ee'::UUID, '6b8f96ba-b343-557b-804e-20cba7bd19ce'::UUID, 10, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_grammar (id, lesson_id, grammar_lesson_id, order_index, curriculum_role)
VALUES ('cd2ed27e-5112-5413-9f63-54a0dc04d6d2'::UUID, '0c573448-400a-5235-9bd7-629c7480b6ee'::UUID, 'dc9eb19c-d0a3-52ca-a11d-1f8bd368eccf'::UUID, 1, 'review')
ON CONFLICT (lesson_id, grammar_lesson_id) DO NOTHING;

INSERT INTO public.lesson_grammar (id, lesson_id, grammar_lesson_id, order_index, curriculum_role)
VALUES ('28b8b786-b899-5c84-8955-ee214170dece'::UUID, '0c573448-400a-5235-9bd7-629c7480b6ee'::UUID, 'e242badd-9725-533f-ae67-abb1ecf4e82a'::UUID, 2, 'review')
ON CONFLICT (lesson_id, grammar_lesson_id) DO NOTHING;

INSERT INTO public.lesson_grammar (id, lesson_id, grammar_lesson_id, order_index, curriculum_role)
VALUES ('dd06bb49-fe03-5714-b01c-e95cdd9aafd1'::UUID, '0c573448-400a-5235-9bd7-629c7480b6ee'::UUID, '9632b5ca-aba2-532f-888b-da79da75f754'::UUID, 3, 'review')
ON CONFLICT (lesson_id, grammar_lesson_id) DO NOTHING;

INSERT INTO public.lesson_grammar (id, lesson_id, grammar_lesson_id, order_index, curriculum_role)
VALUES ('54275226-cd07-546a-8dfa-8b036967757c'::UUID, '0c573448-400a-5235-9bd7-629c7480b6ee'::UUID, 'ed17b98c-f80a-56bd-9274-371dcf28e056'::UUID, 4, 'review')
ON CONFLICT (lesson_id, grammar_lesson_id) DO NOTHING;

INSERT INTO public.lesson_grammar (id, lesson_id, grammar_lesson_id, order_index, curriculum_role)
VALUES ('b2e0d728-e278-5c0a-b73d-c840c9032868'::UUID, '0c573448-400a-5235-9bd7-629c7480b6ee'::UUID, 'cc829157-96aa-55c6-823c-ab112447cf96'::UUID, 5, 'review')
ON CONFLICT (lesson_id, grammar_lesson_id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('2a03eea9-513e-570e-b6c2-a4b9212d5597'::UUID, '0c573448-400a-5235-9bd7-629c7480b6ee'::UUID, 'multiple_choice', 1, '“买” có nghĩa phù hợp nhất là gì?', NULL, 'mua', '买 (mǎi) nghĩa là “mua”.', NULL, 1, '{"activity_type":"chinese_to_vietnamese","vocabulary_key":"foundation:买"}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('a178c00b-6fa4-5074-8410-cccbd2b1ad78'::UUID, '2a03eea9-513e-570e-b6c2-a4b9212d5597'::UUID, 'làm việc, công việc', FALSE, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('4b2b1bd4-b9f9-519d-ae84-4d5af1f9d9c8'::UUID, '2a03eea9-513e-570e-b6c2-a4b9212d5597'::UUID, 'đi ngủ', FALSE, 2)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('fa172262-0051-5baf-8b8a-154c21c27406'::UUID, '2a03eea9-513e-570e-b6c2-a4b9212d5597'::UUID, 'mua', TRUE, 3)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('972f8c92-601b-5d4e-8351-b1e54f1cbcf9'::UUID, '2a03eea9-513e-570e-b6c2-a4b9212d5597'::UUID, 'học tập', FALSE, 4)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('d9dcd423-6c82-5b6b-ae7c-8a1c470b53b7'::UUID, '0c573448-400a-5235-9bd7-629c7480b6ee'::UUID, 'translation', 2, 'Dịch sang tiếng Trung: “Tôi là sinh viên Việt Nam.”', NULL, '我是越南学生。', '我是... giới thiệu vai trò; 越南 đứng trước 学生 để bổ nghĩa.', 'mǎi', 1, '{"activity_type":"vietnamese_to_chinese","source_lang":"vi","target_lang":"zh","acceptable_answers":["我是越南学生。","我是越南的学生。"]}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('fdbe4660-6af2-5931-90a8-5e7332b83d18'::UUID, '0c573448-400a-5235-9bd7-629c7480b6ee'::UUID, 'sentence_builder', 3, 'Sắp xếp các thành phần thành câu đúng.', NULL, '我是越南学生。', 'Trật tự đúng tạo thành câu “我是越南学生。”.', NULL, 1, '{"activity_type":"sentence_ordering","words":["我","是","越南","学生","。"],"correct_order":["我","是","越南","学生","。"]}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('f80ec44b-0936-5241-9059-c7f71ab265ca'::UUID, '0c573448-400a-5235-9bd7-629c7480b6ee'::UUID, 'multiple_choice', 4, 'Câu nào hỏi giá đúng?', NULL, '这杯茶多少钱？', '多少钱 dùng để hỏi giá.', NULL, 1, '{"activity_type":"reading_comprehension","passage":"兰想买一杯茶。她先问价格。","grammar_key":null}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('98ae04c4-9c33-5a30-9f61-62f6eecb07d1'::UUID, 'f80ec44b-0936-5241-9059-c7f71ab265ca'::UUID, '这杯茶多少钱？', TRUE, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('c07f5813-9bde-5103-bb0f-bff2e1f737c5'::UUID, 'f80ec44b-0936-5241-9059-c7f71ab265ca'::UUID, '这杯茶什么名字？', FALSE, 2)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('1bd0bbb4-1ae8-5d83-88e4-77289af4b333'::UUID, 'f80ec44b-0936-5241-9059-c7f71ab265ca'::UUID, '这杯茶几个人？', FALSE, 3)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('3a36cf1f-391e-5ace-bb90-f66f1f6384f9'::UUID, '0c573448-400a-5235-9bd7-629c7480b6ee'::UUID, 'speaking', 5, 'Đọc thành tiếng: 你好，我叫兰。我是越南学生。', NULL, '你好，我叫兰。我是越南学生。', 'Đọc chậm, giữ đúng thanh điệu và nhịp của cả câu.', NULL, 1, '{"activity_type":"pronunciation","text":"你好，我叫兰。我是越南学生。","pinyin":"Nǐ hǎo, wǒ jiào Lán. Wǒ shì Yuènán xuésheng."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.courses (id, slug, title, title_zh, description, level, status, order_index, learning_objectives, estimated_minutes, content_version)
VALUES ('2d1402c4-4084-5436-9b92-ad6eeeaf0e2a'::UUID, 'chinese-pronunciation-tones', 'Chinese Pronunciation and Tones', '汉语语音与声调', 'Lộ trình phát âm có hệ thống: âm tiết pinyin, thanh mẫu, vận mẫu, bốn thanh, biến điệu và các âm khó.', 'beginner', 'review', 9, '["Phân tích cấu tạo một âm tiết pinyin","Phân biệt và phát âm bốn thanh điệu","Áp dụng biến điệu của thanh 3, 一 và 不"]'::JSONB, 100, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.units (id, course_id, slug, title, description, order_index, status, learning_objectives, content_version)
VALUES ('755916ff-f96f-5eaf-8fa2-a344d78fa512'::UUID, '2d1402c4-4084-5436-9b92-ad6eeeaf0e2a'::UUID, 'he-thong-pinyin', 'Hệ thống pinyin', 'Cấu tạo âm tiết, thanh mẫu và vận mẫu.', 1, 'review', '["Nhận biết các thành phần của pinyin","Đọc nhóm âm môi và vận mẫu cơ bản"]'::JSONB, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.chapters (id, unit_id, slug, title, description, order_index, status, learning_objectives, content_version)
VALUES ('9f32b770-dcb9-54d5-8c34-24283979f4df'::UUID, '755916ff-f96f-5eaf-8fa2-a344d78fa512'::UUID, 'cau-tao-am-tiet', 'Cấu tạo âm tiết', 'Thanh mẫu, vận mẫu và âm tiết hoàn chỉnh.', 1, 'review', '["Phân tách âm tiết pinyin"]'::JSONB, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lessons (id, chapter_id, slug, title, description, order_index, xp_reward, status, lesson_type, estimated_minutes, learning_objectives, cultural_note, content_version)
VALUES ('30c43e9c-4198-5b27-97b6-3ae4227fa545'::UUID, '9f32b770-dcb9-54d5-8c34-24283979f4df'::UUID, 'pinyin-thanh-mau-van-mau', '拼音、声母、韵母', 'Ba khái niệm nền tảng để đọc pinyin.', 1, 20, 'review', 'pronunciation', 12, '["Phân biệt thanh mẫu, vận mẫu và âm tiết"]'::JSONB, NULL, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('7a84a37b-3d6e-51bc-a24c-3e10b017a3a5'::UUID, 'pronunciation:拼音', '拼音', 'pīnyīn', 'pinyin, hệ thống phiên âm', 'pinyin', 'beginner', 'pronunciation', 'danh từ', '学习拼音能帮助我们读准汉字。', 'Xuéxí pīnyīn néng bāngzhù wǒmen dú zhǔn Hànzì.', 'Học pinyin giúp chúng ta đọc chữ Hán chính xác.', NULL, 'review', '30c43e9c-4198-5b27-97b6-3ae4227fa545'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('a62f5421-280f-5267-8c6c-7e2130a7e761'::UUID, '30c43e9c-4198-5b27-97b6-3ae4227fa545'::UUID, '7a84a37b-3d6e-51bc-a24c-3e10b017a3a5'::UUID, 1, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('1f290002-5735-5f03-835f-c3b12cae2ad4'::UUID, 'pronunciation:声母', '声母', 'shēngmǔ', 'thanh mẫu, phụ âm đầu', 'initial', 'beginner', 'pronunciation', 'danh từ', '“b”是一个声母。', '“b” shì yí ge shēngmǔ.', '“b” là một thanh mẫu.', NULL, 'review', '30c43e9c-4198-5b27-97b6-3ae4227fa545'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('2fb2b3c0-6d65-597b-b139-4f8c85209d41'::UUID, '30c43e9c-4198-5b27-97b6-3ae4227fa545'::UUID, '1f290002-5735-5f03-835f-c3b12cae2ad4'::UUID, 2, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('bacac630-deda-55d4-980e-dd68f365dbc1'::UUID, 'pronunciation:韵母', '韵母', 'yùnmǔ', 'vận mẫu, phần vần', 'final', 'beginner', 'pronunciation', 'danh từ', '“ang”是一个韵母。', '“ang” shì yí ge yùnmǔ.', '“ang” là một vận mẫu.', NULL, 'review', '30c43e9c-4198-5b27-97b6-3ae4227fa545'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('f9d07085-56ed-5e59-9bf4-cb212b4b0220'::UUID, '30c43e9c-4198-5b27-97b6-3ae4227fa545'::UUID, 'bacac630-deda-55d4-980e-dd68f365dbc1'::UUID, 3, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('711339be-02a4-5758-963b-2c2cbd32627f'::UUID, 'pronunciation:音节', '音节', 'yīnjié', 'âm tiết', 'syllable', 'beginner', 'pronunciation', 'danh từ', '“mā”是一个音节。', '“mā” shì yí ge yīnjié.', '“mā” là một âm tiết.', NULL, 'review', '30c43e9c-4198-5b27-97b6-3ae4227fa545'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('2ce1717b-ae6d-5b25-aec5-679a9942d20c'::UUID, '30c43e9c-4198-5b27-97b6-3ae4227fa545'::UUID, '711339be-02a4-5758-963b-2c2cbd32627f'::UUID, 4, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.grammar_lessons (id, content_key, title, pattern, explanation, example_chinese, example_pinyin, example_meaning, level, status, usage_note, content_version)
VALUES ('731f2619-8a28-5d88-b586-9b5942afdd54'::UUID, 'pronunciation:syllable-structure', 'Cấu tạo âm tiết pinyin', 'thanh mẫu + vận mẫu + thanh điệu', 'Nhiều âm tiết gồm thanh mẫu đứng trước, vận mẫu đứng sau và dấu thanh đặt trên nguyên âm chính.', '妈：m + a + thanh 1', 'Mā: m + a + dì yī shēng.', '妈 gồm thanh mẫu m, vận mẫu a và thanh 1.', 'beginner', 'review', 'Một số âm tiết không có thanh mẫu, ví dụ 安 ān.', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_grammar (id, lesson_id, grammar_lesson_id, order_index, curriculum_role)
VALUES ('7a95980f-ff72-5ccf-aa84-b06486a73750'::UUID, '30c43e9c-4198-5b27-97b6-3ae4227fa545'::UUID, '731f2619-8a28-5d88-b586-9b5942afdd54'::UUID, 1, 'introduced')
ON CONFLICT (lesson_id, grammar_lesson_id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('6f7cf582-e3e7-5e30-beb3-2a4c77a33b96'::UUID, '30c43e9c-4198-5b27-97b6-3ae4227fa545'::UUID, 'vocabulary', 1, 'Từ mới: 拼音', NULL, '拼音', '拼音 (pīnyīn) — pinyin, hệ thống phiên âm. 学习拼音能帮助我们读准汉字。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"pronunciation:拼音","chinese":"拼音","pinyin":"pīnyīn","meaning":"pinyin, hệ thống phiên âm","part_of_speech":"danh từ","example_chinese":"学习拼音能帮助我们读准汉字。","example_pinyin":"Xuéxí pīnyīn néng bāngzhù wǒmen dú zhǔn Hànzì.","example_meaning_vi":"Học pinyin giúp chúng ta đọc chữ Hán chính xác."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('ecf947e1-200b-57e6-9011-cedef5649d2f'::UUID, '30c43e9c-4198-5b27-97b6-3ae4227fa545'::UUID, 'vocabulary', 2, 'Từ mới: 声母', NULL, '声母', '声母 (shēngmǔ) — thanh mẫu, phụ âm đầu. “b”是一个声母。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"pronunciation:声母","chinese":"声母","pinyin":"shēngmǔ","meaning":"thanh mẫu, phụ âm đầu","part_of_speech":"danh từ","example_chinese":"“b”是一个声母。","example_pinyin":"“b” shì yí ge shēngmǔ.","example_meaning_vi":"“b” là một thanh mẫu."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('0fe43644-2d01-5248-bb8a-569c518c2547'::UUID, '30c43e9c-4198-5b27-97b6-3ae4227fa545'::UUID, 'vocabulary', 3, 'Từ mới: 韵母', NULL, '韵母', '韵母 (yùnmǔ) — vận mẫu, phần vần. “ang”是一个韵母。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"pronunciation:韵母","chinese":"韵母","pinyin":"yùnmǔ","meaning":"vận mẫu, phần vần","part_of_speech":"danh từ","example_chinese":"“ang”是一个韵母。","example_pinyin":"“ang” shì yí ge yùnmǔ.","example_meaning_vi":"“ang” là một vận mẫu."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('4f33d6d0-b931-51e5-a8c1-4849865b44fc'::UUID, '30c43e9c-4198-5b27-97b6-3ae4227fa545'::UUID, 'vocabulary', 4, 'Từ mới: 音节', NULL, '音节', '音节 (yīnjié) — âm tiết. “mā”是一个音节。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"pronunciation:音节","chinese":"音节","pinyin":"yīnjié","meaning":"âm tiết","part_of_speech":"danh từ","example_chinese":"“mā”是一个音节。","example_pinyin":"“mā” shì yí ge yīnjié.","example_meaning_vi":"“mā” là một âm tiết."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('ed0a3f7e-52a4-5c7d-b114-dbe3a1aa0b1c'::UUID, '30c43e9c-4198-5b27-97b6-3ae4227fa545'::UUID, 'multiple_choice', 5, '“拼音” có nghĩa phù hợp nhất là gì?', NULL, 'pinyin, hệ thống phiên âm', '拼音 (pīnyīn) nghĩa là “pinyin, hệ thống phiên âm”.', NULL, 1, '{"activity_type":"chinese_to_vietnamese","vocabulary_key":"pronunciation:拼音"}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('aae6c6dc-82af-5f08-8dfa-f4b1b3e44fc7'::UUID, 'ed0a3f7e-52a4-5c7d-b114-dbe3a1aa0b1c'::UUID, 'pinyin, hệ thống phiên âm', TRUE, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('eaa7d7a7-7c1a-544e-b3f3-6e58d1b8a25e'::UUID, 'ed0a3f7e-52a4-5c7d-b114-dbe3a1aa0b1c'::UUID, 'thanh mẫu, phụ âm đầu', FALSE, 2)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('3bdb5522-043c-51b6-a152-33828cc992ac'::UUID, 'ed0a3f7e-52a4-5c7d-b114-dbe3a1aa0b1c'::UUID, 'vận mẫu, phần vần', FALSE, 3)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('faff40ca-04ac-5cc4-95d7-de8b9e92f96e'::UUID, 'ed0a3f7e-52a4-5c7d-b114-dbe3a1aa0b1c'::UUID, 'âm tiết', FALSE, 4)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('04aa609e-c273-5fc4-a32b-dce11450c697'::UUID, '30c43e9c-4198-5b27-97b6-3ae4227fa545'::UUID, 'translation', 6, 'Dịch sang tiếng Trung: “Học pinyin giúp chúng ta đọc chữ Hán chính xác.”', NULL, '学习拼音能帮助我们读准汉字。', 'Mẫu câu dùng “拼音” trong ngữ cảnh của bài.', 'pīnyīn', 1, '{"activity_type":"vietnamese_to_chinese","source_lang":"vi","target_lang":"zh","acceptable_answers":["学习拼音能帮助我们读准汉字。"]}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('7984d2ec-3c83-56f2-a534-b9b63ae6e51c'::UUID, '30c43e9c-4198-5b27-97b6-3ae4227fa545'::UUID, 'sentence_builder', 7, 'Sắp xếp các thành phần thành câu đúng.', NULL, '学习拼音很重要。', 'Trật tự đúng tạo thành câu “学习拼音很重要。”.', NULL, 1, '{"activity_type":"sentence_ordering","words":["学习","拼音","很","重要","。"],"correct_order":["学习","拼音","很","重要","。"]}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('00b7b370-2630-527d-9375-a30dc2d4b2ff'::UUID, '30c43e9c-4198-5b27-97b6-3ae4227fa545'::UUID, 'multiple_choice', 8, 'Trong âm tiết mā, “m” là thành phần nào?', NULL, '声母', 'm đứng đầu âm tiết nên là thanh mẫu.', NULL, 1, '{"activity_type":"grammar_selection","passage":null,"grammar_key":"pronunciation:syllable-structure"}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('9b21c736-c092-51f0-a899-886e0e51b051'::UUID, '00b7b370-2630-527d-9375-a30dc2d4b2ff'::UUID, '声母', TRUE, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('a3bbc443-0422-563c-bf23-8c7962efb5bd'::UUID, '00b7b370-2630-527d-9375-a30dc2d4b2ff'::UUID, '韵母', FALSE, 2)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('95846c4c-15c0-5591-aac1-cb20f57dd4d6'::UUID, '00b7b370-2630-527d-9375-a30dc2d4b2ff'::UUID, '声调', FALSE, 3)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('0edf99b8-b034-5a25-bb7e-2990f49ba63b'::UUID, '30c43e9c-4198-5b27-97b6-3ae4227fa545'::UUID, 'speaking', 9, 'Đọc thành tiếng: 学习拼音能帮助我们读准汉字。', NULL, '学习拼音能帮助我们读准汉字。', 'Đọc chậm, giữ đúng thanh điệu và nhịp của cả câu.', NULL, 1, '{"activity_type":"pronunciation","text":"学习拼音能帮助我们读准汉字。","pinyin":"Xuéxí pīnyīn néng bāngzhù wǒmen dú zhǔn Hànzì."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lessons (id, chapter_id, slug, title, description, order_index, xp_reward, status, lesson_type, estimated_minutes, learning_objectives, cultural_note, content_version)
VALUES ('4c9084f4-7c21-52fb-b1c5-e88cf5c19ba3'::UUID, '9f32b770-dcb9-54d5-8c34-24283979f4df'::UUID, 'am-moi-b-p-m-f', 'b、p、m、f và độ bật hơi', 'Luyện các âm môi qua từ đơn quen thuộc.', 2, 20, 'review', 'pronunciation', 12, '["Phân biệt b/p và giữ vị trí môi của m/f"]'::JSONB, NULL, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('20d759b7-88e1-554f-8ccf-af7312b57f76'::UUID, 'pronunciation:白', '白', 'bái', 'trắng', 'white', 'beginner', 'pronunciation_bpmf', 'tính từ', '这张纸是白色的。', 'Zhè zhāng zhǐ shì báisè de.', 'Tờ giấy này màu trắng.', 1, 'review', '4c9084f4-7c21-52fb-b1c5-e88cf5c19ba3'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('d30535f8-805c-52ba-8abf-fff007f38c91'::UUID, '4c9084f4-7c21-52fb-b1c5-e88cf5c19ba3'::UUID, '20d759b7-88e1-554f-8ccf-af7312b57f76'::UUID, 1, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('a1850a8d-aa67-5730-9cab-2ad6220cd3cf'::UUID, 'pronunciation:跑', '跑', 'pǎo', 'chạy', 'run', 'beginner', 'pronunciation_bpmf', 'động từ', '他每天跑步。', 'Tā měitiān pǎobù.', 'Anh ấy chạy bộ mỗi ngày.', 2, 'review', '4c9084f4-7c21-52fb-b1c5-e88cf5c19ba3'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('4d8b0219-1521-594c-a7b4-e5e70e0c836b'::UUID, '4c9084f4-7c21-52fb-b1c5-e88cf5c19ba3'::UUID, 'a1850a8d-aa67-5730-9cab-2ad6220cd3cf'::UUID, 2, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('f99dccb6-bb36-555c-b1c7-87c177fd3118'::UUID, 'pronunciation:米', '米', 'mǐ', 'gạo', 'rice grain', 'beginner', 'pronunciation_bpmf', 'danh từ', '这袋米很香。', 'Zhè dài mǐ hěn xiāng.', 'Túi gạo này rất thơm.', 1, 'review', '4c9084f4-7c21-52fb-b1c5-e88cf5c19ba3'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('2c533035-3099-5a62-808c-7aa14bffb6b7'::UUID, '4c9084f4-7c21-52fb-b1c5-e88cf5c19ba3'::UUID, 'f99dccb6-bb36-555c-b1c7-87c177fd3118'::UUID, 3, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('0dea2ca4-5ef0-5149-9231-e35b06f29b27'::UUID, 'pronunciation:发', '发', 'fā', 'phát, gửi', 'send; issue', 'beginner', 'pronunciation_bpmf', 'động từ', '我给你发消息。', 'Wǒ gěi nǐ fā xiāoxi.', 'Tôi gửi tin nhắn cho bạn.', 2, 'review', '4c9084f4-7c21-52fb-b1c5-e88cf5c19ba3'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('bd4c00e2-d2f2-5f6a-9623-5044e06d5263'::UUID, '4c9084f4-7c21-52fb-b1c5-e88cf5c19ba3'::UUID, '0dea2ca4-5ef0-5149-9231-e35b06f29b27'::UUID, 4, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('b916e8aa-fd9e-5866-abbd-aee73a7d32a2'::UUID, '4c9084f4-7c21-52fb-b1c5-e88cf5c19ba3'::UUID, '7a84a37b-3d6e-51bc-a24c-3e10b017a3a5'::UUID, 5, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('93702fb7-7a70-5221-aef2-b097b6cd17d3'::UUID, '4c9084f4-7c21-52fb-b1c5-e88cf5c19ba3'::UUID, '1f290002-5735-5f03-835f-c3b12cae2ad4'::UUID, 6, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('a7566c84-fcad-573c-b218-7f185a5feccb'::UUID, '4c9084f4-7c21-52fb-b1c5-e88cf5c19ba3'::UUID, 'bacac630-deda-55d4-980e-dd68f365dbc1'::UUID, 7, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('4aa15377-8370-52d7-b8d8-ab398d88b0ca'::UUID, '4c9084f4-7c21-52fb-b1c5-e88cf5c19ba3'::UUID, '711339be-02a4-5758-963b-2c2cbd32627f'::UUID, 8, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.grammar_lessons (id, content_key, title, pattern, explanation, example_chinese, example_pinyin, example_meaning, level, status, usage_note, content_version)
VALUES ('81d0ac74-12cd-584a-9d48-3c543ff1c813'::UUID, 'pronunciation:aspiration-bp', 'Phân biệt b và p', 'b không bật hơi mạnh; p bật hơi', 'Đặt mảnh giấy trước miệng: p làm giấy chuyển động rõ hơn b.', '白 bái / 跑 pǎo', 'Bái / pǎo.', 'trắng / chạy', 'beginner', 'review', 'Khác biệt chính là độ bật hơi, không phải hữu thanh/vô thanh như một số ngôn ngữ.', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_grammar (id, lesson_id, grammar_lesson_id, order_index, curriculum_role)
VALUES ('bcbdcb55-d9a3-5566-b045-9f4256db4dda'::UUID, '4c9084f4-7c21-52fb-b1c5-e88cf5c19ba3'::UUID, '81d0ac74-12cd-584a-9d48-3c543ff1c813'::UUID, 1, 'introduced')
ON CONFLICT (lesson_id, grammar_lesson_id) DO NOTHING;

INSERT INTO public.lesson_grammar (id, lesson_id, grammar_lesson_id, order_index, curriculum_role)
VALUES ('bfefa8c1-13be-5e54-9b7a-f5978e96de9d'::UUID, '4c9084f4-7c21-52fb-b1c5-e88cf5c19ba3'::UUID, '731f2619-8a28-5d88-b586-9b5942afdd54'::UUID, 2, 'review')
ON CONFLICT (lesson_id, grammar_lesson_id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('d767209a-2666-5319-a912-ce0c4d4875c2'::UUID, '4c9084f4-7c21-52fb-b1c5-e88cf5c19ba3'::UUID, 'vocabulary', 1, 'Từ mới: 白', NULL, '白', '白 (bái) — trắng. 这张纸是白色的。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"pronunciation:白","chinese":"白","pinyin":"bái","meaning":"trắng","part_of_speech":"tính từ","example_chinese":"这张纸是白色的。","example_pinyin":"Zhè zhāng zhǐ shì báisè de.","example_meaning_vi":"Tờ giấy này màu trắng."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('806f07ed-85f6-5959-a188-5d7d383f4643'::UUID, '4c9084f4-7c21-52fb-b1c5-e88cf5c19ba3'::UUID, 'vocabulary', 2, 'Từ mới: 跑', NULL, '跑', '跑 (pǎo) — chạy. 他每天跑步。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"pronunciation:跑","chinese":"跑","pinyin":"pǎo","meaning":"chạy","part_of_speech":"động từ","example_chinese":"他每天跑步。","example_pinyin":"Tā měitiān pǎobù.","example_meaning_vi":"Anh ấy chạy bộ mỗi ngày."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('ee409ccc-9d2f-55ea-b130-2d50eaa22dcd'::UUID, '4c9084f4-7c21-52fb-b1c5-e88cf5c19ba3'::UUID, 'vocabulary', 3, 'Từ mới: 米', NULL, '米', '米 (mǐ) — gạo. 这袋米很香。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"pronunciation:米","chinese":"米","pinyin":"mǐ","meaning":"gạo","part_of_speech":"danh từ","example_chinese":"这袋米很香。","example_pinyin":"Zhè dài mǐ hěn xiāng.","example_meaning_vi":"Túi gạo này rất thơm."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('9f020b67-afc8-5828-97eb-da2179322460'::UUID, '4c9084f4-7c21-52fb-b1c5-e88cf5c19ba3'::UUID, 'vocabulary', 4, 'Từ mới: 发', NULL, '发', '发 (fā) — phát, gửi. 我给你发消息。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"pronunciation:发","chinese":"发","pinyin":"fā","meaning":"phát, gửi","part_of_speech":"động từ","example_chinese":"我给你发消息。","example_pinyin":"Wǒ gěi nǐ fā xiāoxi.","example_meaning_vi":"Tôi gửi tin nhắn cho bạn."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('f55cbd2f-ae14-537d-a294-dc4f0a054855'::UUID, '4c9084f4-7c21-52fb-b1c5-e88cf5c19ba3'::UUID, 'multiple_choice', 5, '“跑” có nghĩa phù hợp nhất là gì?', NULL, 'chạy', '跑 (pǎo) nghĩa là “chạy”.', NULL, 1, '{"activity_type":"chinese_to_vietnamese","vocabulary_key":"pronunciation:跑"}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('cf9851ab-fcc8-545b-8bdc-1fde7b3de09c'::UUID, 'f55cbd2f-ae14-537d-a294-dc4f0a054855'::UUID, 'phát, gửi', FALSE, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('c06e3aff-d182-557a-a83b-cfc9c978d80f'::UUID, 'f55cbd2f-ae14-537d-a294-dc4f0a054855'::UUID, 'chạy', TRUE, 2)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('05774925-af25-50d3-937d-a4ab082b3b6c'::UUID, 'f55cbd2f-ae14-537d-a294-dc4f0a054855'::UUID, 'trắng', FALSE, 3)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('529ce0a5-f202-59a8-ae86-b25677ca49f0'::UUID, 'f55cbd2f-ae14-537d-a294-dc4f0a054855'::UUID, 'gạo', FALSE, 4)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('ec1c2266-a40b-5ade-a0c3-a1cbb14abcaa'::UUID, '4c9084f4-7c21-52fb-b1c5-e88cf5c19ba3'::UUID, 'translation', 6, 'Dịch sang tiếng Trung: “Anh ấy chạy bộ mỗi ngày.”', NULL, '他每天跑步。', 'Mẫu câu dùng “跑” trong ngữ cảnh của bài.', 'pǎo', 1, '{"activity_type":"vietnamese_to_chinese","source_lang":"vi","target_lang":"zh","acceptable_answers":["他每天跑步。"]}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('e683aae7-b3dd-5334-8068-7f49f44f2ea3'::UUID, '4c9084f4-7c21-52fb-b1c5-e88cf5c19ba3'::UUID, 'sentence_builder', 7, 'Sắp xếp các thành phần thành câu đúng.', NULL, '他每天跑步。', 'Trật tự đúng tạo thành câu “他每天跑步。”.', NULL, 1, '{"activity_type":"sentence_ordering","words":["他","每天","跑步","。"],"correct_order":["他","每天","跑步","。"]}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('2a1e9900-a1c2-5e38-a768-6409b5f0dea7'::UUID, '4c9084f4-7c21-52fb-b1c5-e88cf5c19ba3'::UUID, 'multiple_choice', 8, 'Âm nào bật hơi mạnh hơn?', NULL, 'p', 'p là âm bật hơi; b không bật hơi mạnh.', NULL, 1, '{"activity_type":"grammar_selection","passage":null,"grammar_key":"pronunciation:aspiration-bp"}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('0dbe5d82-56b2-5330-aa0d-cce1622592f6'::UUID, '2a1e9900-a1c2-5e38-a768-6409b5f0dea7'::UUID, 'p', TRUE, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('ed7a6798-a5fb-5e7b-ba3f-045594f8f5cb'::UUID, '2a1e9900-a1c2-5e38-a768-6409b5f0dea7'::UUID, 'b', FALSE, 2)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('0f57bc98-0577-52b1-a8b1-22a4034a36f7'::UUID, '2a1e9900-a1c2-5e38-a768-6409b5f0dea7'::UUID, 'm', FALSE, 3)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('2a786106-5fa3-5db8-a13f-2af9495b3de4'::UUID, '4c9084f4-7c21-52fb-b1c5-e88cf5c19ba3'::UUID, 'speaking', 9, 'Đọc thành tiếng: 他每天跑步。', NULL, '他每天跑步。', 'Đọc chậm, giữ đúng thanh điệu và nhịp của cả câu.', NULL, 1, '{"activity_type":"pronunciation","text":"他每天跑步。","pinyin":"Tā měitiān pǎobù."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.chapters (id, unit_id, slug, title, description, order_index, status, learning_objectives, content_version)
VALUES ('51fe6100-d1e3-534d-87ee-c580119f4822'::UUID, '755916ff-f96f-5eaf-8fa2-a344d78fa512'::UUID, 'van-mau-va-bon-thanh', 'Vận mẫu và bốn thanh', 'Nguyên âm cơ bản và đối lập mā–má–mǎ–mà.', 2, 'review', '["Đọc vận mẫu đơn","Nghe và phát âm đường nét bốn thanh"]'::JSONB, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lessons (id, chapter_id, slug, title, description, order_index, xp_reward, status, lesson_type, estimated_minutes, learning_objectives, cultural_note, content_version)
VALUES ('c44683a2-76ec-52f4-8a2c-192346300aa4'::UUID, '51fe6100-d1e3-534d-87ee-c580119f4822'::UUID, 'van-mau-don', 'a、o、e、i、u、ü', 'Luyện khẩu hình qua các từ có vận mẫu đơn.', 1, 20, 'review', 'pronunciation', 14, '["Giữ đúng khẩu hình sáu vận mẫu đơn"]'::JSONB, NULL, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('13e5fdfd-a3be-5503-b5b6-54123b2d0c66'::UUID, 'pronunciation:阿姨', '阿姨', 'āyí', 'cô, dì', 'aunt', 'beginner', 'pronunciation_finals', 'danh từ', '阿姨住在上海。', 'Āyí zhù zài Shànghǎi.', 'Dì sống ở Thượng Hải.', 2, 'review', 'c44683a2-76ec-52f4-8a2c-192346300aa4'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('028fed0c-bc5b-5976-80be-3f71aef32b8f'::UUID, 'c44683a2-76ec-52f4-8a2c-192346300aa4'::UUID, '13e5fdfd-a3be-5503-b5b6-54123b2d0c66'::UUID, 1, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('5852b1ff-b7ff-5836-9190-71fde815292d'::UUID, 'pronunciation:饿', '饿', 'è', 'đói', 'hungry', 'beginner', 'pronunciation_finals', 'tính từ', '我有点儿饿。', 'Wǒ yǒudiǎnr è.', 'Tôi hơi đói.', 1, 'review', 'c44683a2-76ec-52f4-8a2c-192346300aa4'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('18c03dc5-14d9-55c1-9508-04c1778aea88'::UUID, 'c44683a2-76ec-52f4-8a2c-192346300aa4'::UUID, '5852b1ff-b7ff-5836-9190-71fde815292d'::UUID, 2, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('323a0411-c889-5db5-8220-c643db2876c8'::UUID, 'pronunciation:衣服', '衣服', 'yīfu', 'quần áo', 'clothes', 'beginner', 'pronunciation_finals', 'danh từ', '这件衣服很合适。', 'Zhè jiàn yīfu hěn héshì.', 'Bộ quần áo này rất vừa.', 1, 'review', 'c44683a2-76ec-52f4-8a2c-192346300aa4'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('abfbfbe4-86dc-546c-a3ee-43473dd24c93'::UUID, 'c44683a2-76ec-52f4-8a2c-192346300aa4'::UUID, '323a0411-c889-5db5-8220-c643db2876c8'::UUID, 3, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('35c86a8a-2089-59fc-a575-e19baff40763'::UUID, 'pronunciation:乌云', '乌云', 'wūyún', 'mây đen', 'dark cloud', 'beginner', 'pronunciation_finals', 'danh từ', '天上有很多乌云。', 'Tiānshang yǒu hěn duō wūyún.', 'Trên trời có nhiều mây đen.', NULL, 'review', 'c44683a2-76ec-52f4-8a2c-192346300aa4'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('aac57f95-fc8e-5f94-a919-85bd1509c618'::UUID, 'c44683a2-76ec-52f4-8a2c-192346300aa4'::UUID, '35c86a8a-2089-59fc-a575-e19baff40763'::UUID, 4, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('893c5ff6-2393-5894-809d-b5ef690ba97f'::UUID, 'pronunciation:女儿', '女儿', 'nǚ''ér', 'con gái', 'daughter', 'beginner', 'pronunciation_finals', 'danh từ', '她女儿今年十岁。', 'Tā nǚ''ér jīnnián shí suì.', 'Con gái cô ấy năm nay mười tuổi.', 1, 'review', 'c44683a2-76ec-52f4-8a2c-192346300aa4'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('414d014b-3280-5c64-beb4-23eef9a0ccc2'::UUID, 'c44683a2-76ec-52f4-8a2c-192346300aa4'::UUID, '893c5ff6-2393-5894-809d-b5ef690ba97f'::UUID, 5, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('b2b0f3b5-10a9-5d4f-b724-6a97dc015790'::UUID, 'c44683a2-76ec-52f4-8a2c-192346300aa4'::UUID, '20d759b7-88e1-554f-8ccf-af7312b57f76'::UUID, 6, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('464f19fa-1b49-5f05-8abf-ae9db7e571ca'::UUID, 'c44683a2-76ec-52f4-8a2c-192346300aa4'::UUID, 'a1850a8d-aa67-5730-9cab-2ad6220cd3cf'::UUID, 7, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('9371f255-852c-5bab-85b7-9a56d7ef6023'::UUID, 'c44683a2-76ec-52f4-8a2c-192346300aa4'::UUID, 'f99dccb6-bb36-555c-b1c7-87c177fd3118'::UUID, 8, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('8f368f33-b0f5-50a2-8cbc-79591d7832a6'::UUID, 'c44683a2-76ec-52f4-8a2c-192346300aa4'::UUID, '0dea2ca4-5ef0-5149-9231-e35b06f29b27'::UUID, 9, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.grammar_lessons (id, content_key, title, pattern, explanation, example_chinese, example_pinyin, example_meaning, level, status, usage_note, content_version)
VALUES ('38111e04-873a-5ca0-a772-a4b5992c7a5c'::UUID, 'pronunciation:umlaut-u', 'Khẩu hình ü', 'i + môi tròn', 'Giữ lưỡi như khi đọc i rồi làm tròn môi; không đọc thành u.', '女 nǚ', 'Nǚ.', 'nữ, con gái', 'beginner', 'review', 'Sau j, q, x, y, hai chấm thường bị lược trong chữ viết pinyin.', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_grammar (id, lesson_id, grammar_lesson_id, order_index, curriculum_role)
VALUES ('69a10469-b795-54dd-8c7f-bd68e3805356'::UUID, 'c44683a2-76ec-52f4-8a2c-192346300aa4'::UUID, '38111e04-873a-5ca0-a772-a4b5992c7a5c'::UUID, 1, 'introduced')
ON CONFLICT (lesson_id, grammar_lesson_id) DO NOTHING;

INSERT INTO public.lesson_grammar (id, lesson_id, grammar_lesson_id, order_index, curriculum_role)
VALUES ('34bbd4b0-03ac-5ddf-84b8-75970134c1be'::UUID, 'c44683a2-76ec-52f4-8a2c-192346300aa4'::UUID, '81d0ac74-12cd-584a-9d48-3c543ff1c813'::UUID, 2, 'review')
ON CONFLICT (lesson_id, grammar_lesson_id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('c7aaa938-b471-5014-8761-e23a866fe241'::UUID, 'c44683a2-76ec-52f4-8a2c-192346300aa4'::UUID, 'vocabulary', 1, 'Từ mới: 阿姨', NULL, '阿姨', '阿姨 (āyí) — cô, dì. 阿姨住在上海。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"pronunciation:阿姨","chinese":"阿姨","pinyin":"āyí","meaning":"cô, dì","part_of_speech":"danh từ","example_chinese":"阿姨住在上海。","example_pinyin":"Āyí zhù zài Shànghǎi.","example_meaning_vi":"Dì sống ở Thượng Hải."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('30005f55-73ff-5e20-98f3-aaabcb2bd9b1'::UUID, 'c44683a2-76ec-52f4-8a2c-192346300aa4'::UUID, 'vocabulary', 2, 'Từ mới: 饿', NULL, '饿', '饿 (è) — đói. 我有点儿饿。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"pronunciation:饿","chinese":"饿","pinyin":"è","meaning":"đói","part_of_speech":"tính từ","example_chinese":"我有点儿饿。","example_pinyin":"Wǒ yǒudiǎnr è.","example_meaning_vi":"Tôi hơi đói."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('796872a5-72ee-5064-89f2-e5280682e181'::UUID, 'c44683a2-76ec-52f4-8a2c-192346300aa4'::UUID, 'vocabulary', 3, 'Từ mới: 衣服', NULL, '衣服', '衣服 (yīfu) — quần áo. 这件衣服很合适。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"pronunciation:衣服","chinese":"衣服","pinyin":"yīfu","meaning":"quần áo","part_of_speech":"danh từ","example_chinese":"这件衣服很合适。","example_pinyin":"Zhè jiàn yīfu hěn héshì.","example_meaning_vi":"Bộ quần áo này rất vừa."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('59f09415-5c56-5f51-851a-0ae73b23a3a1'::UUID, 'c44683a2-76ec-52f4-8a2c-192346300aa4'::UUID, 'vocabulary', 4, 'Từ mới: 乌云', NULL, '乌云', '乌云 (wūyún) — mây đen. 天上有很多乌云。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"pronunciation:乌云","chinese":"乌云","pinyin":"wūyún","meaning":"mây đen","part_of_speech":"danh từ","example_chinese":"天上有很多乌云。","example_pinyin":"Tiānshang yǒu hěn duō wūyún.","example_meaning_vi":"Trên trời có nhiều mây đen."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('930370dc-3314-5940-8a1b-610bb01e9aff'::UUID, 'c44683a2-76ec-52f4-8a2c-192346300aa4'::UUID, 'vocabulary', 5, 'Từ mới: 女儿', NULL, '女儿', '女儿 (nǚ''ér) — con gái. 她女儿今年十岁。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"pronunciation:女儿","chinese":"女儿","pinyin":"nǚ''ér","meaning":"con gái","part_of_speech":"danh từ","example_chinese":"她女儿今年十岁。","example_pinyin":"Tā nǚ''ér jīnnián shí suì.","example_meaning_vi":"Con gái cô ấy năm nay mười tuổi."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('dc507870-05d1-5cfd-af54-a1d72bd60062'::UUID, 'c44683a2-76ec-52f4-8a2c-192346300aa4'::UUID, 'multiple_choice', 6, '“女儿” có nghĩa phù hợp nhất là gì?', NULL, 'con gái', '女儿 (nǚ''ér) nghĩa là “con gái”.', NULL, 1, '{"activity_type":"chinese_to_vietnamese","vocabulary_key":"pronunciation:女儿"}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('9cc95da5-e791-50a6-8178-ba2f70ed2cf7'::UUID, 'dc507870-05d1-5cfd-af54-a1d72bd60062'::UUID, 'mây đen', FALSE, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('bf97f9c8-1763-5ded-92d0-03c4592e5446'::UUID, 'dc507870-05d1-5cfd-af54-a1d72bd60062'::UUID, 'con gái', TRUE, 2)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('f473f035-4bfb-56db-a619-53c3ef1db0e3'::UUID, 'dc507870-05d1-5cfd-af54-a1d72bd60062'::UUID, 'cô, dì', FALSE, 3)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('b72e33dd-33e5-5526-903a-63b7b3a14867'::UUID, 'dc507870-05d1-5cfd-af54-a1d72bd60062'::UUID, 'quần áo', FALSE, 4)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('df15d433-71fa-5357-ac1a-7bd23fbde063'::UUID, 'c44683a2-76ec-52f4-8a2c-192346300aa4'::UUID, 'translation', 7, 'Dịch sang tiếng Trung: “Con gái cô ấy năm nay mười tuổi.”', NULL, '她女儿今年十岁。', 'Mẫu câu dùng “女儿” trong ngữ cảnh của bài.', 'nǚ''ér', 1, '{"activity_type":"vietnamese_to_chinese","source_lang":"vi","target_lang":"zh","acceptable_answers":["她女儿今年十岁。"]}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('1403b981-ec88-5f27-9bf3-ced46120d19e'::UUID, 'c44683a2-76ec-52f4-8a2c-192346300aa4'::UUID, 'sentence_builder', 8, 'Sắp xếp các thành phần thành câu đúng.', NULL, '她女儿十岁。', 'Trật tự đúng tạo thành câu “她女儿十岁。”.', NULL, 1, '{"activity_type":"sentence_ordering","words":["她","女儿","十","岁","。"],"correct_order":["她","女儿","十","岁","。"]}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('f5442283-bdf5-5ec0-9be9-6eba433ccec6'::UUID, 'c44683a2-76ec-52f4-8a2c-192346300aa4'::UUID, 'multiple_choice', 9, 'Âm ü được tạo bằng cách nào?', NULL, 'Giữ lưỡi như i và làm tròn môi', 'ü có vị trí lưỡi gần i nhưng môi tròn.', NULL, 1, '{"activity_type":"grammar_selection","passage":null,"grammar_key":"pronunciation:umlaut-u"}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('6b9ef39b-09b9-580f-a656-6d35b6c00ca1'::UUID, 'f5442283-bdf5-5ec0-9be9-6eba433ccec6'::UUID, 'Giữ lưỡi như i và làm tròn môi', TRUE, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('b3f6d443-67f2-5d1c-9723-628cddf7bb68'::UUID, 'f5442283-bdf5-5ec0-9be9-6eba433ccec6'::UUID, 'Đọc giống u tiếng Việt', FALSE, 2)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('038e088c-1e7c-5c45-b0bd-8a7f93e1dfab'::UUID, 'f5442283-bdf5-5ec0-9be9-6eba433ccec6'::UUID, 'Mở miệng như a', FALSE, 3)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('da985efc-07cb-51d1-b9a6-64bd90453f52'::UUID, 'c44683a2-76ec-52f4-8a2c-192346300aa4'::UUID, 'speaking', 10, 'Đọc thành tiếng: 她女儿今年十岁。', NULL, '她女儿今年十岁。', 'Đọc chậm, giữ đúng thanh điệu và nhịp của cả câu.', NULL, 1, '{"activity_type":"pronunciation","text":"她女儿今年十岁。","pinyin":"Tā nǚ''ér jīnnián shí suì."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lessons (id, chapter_id, slug, title, description, order_index, xp_reward, status, lesson_type, estimated_minutes, learning_objectives, cultural_note, content_version)
VALUES ('1ca62a8a-98d3-5fa5-bf21-00e62d72c93c'::UUID, '51fe6100-d1e3-534d-87ee-c580119f4822'::UUID, 'ma-ma-ma-ma', 'mā、má、mǎ、mà', 'Bốn thanh tạo bốn nghĩa khác nhau.', 2, 25, 'review', 'tone_practice', 15, '["Phát âm rõ bốn đường nét thanh điệu"]'::JSONB, NULL, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('0dcf44c5-8066-5b7d-b859-0d464a8ff0d3'::UUID, 'pronunciation:妈', '妈', 'mā', 'mẹ', 'mom', 'beginner', 'tones', 'danh từ', '我妈今天很忙。', 'Wǒ mā jīntiān hěn máng.', 'Hôm nay mẹ tôi rất bận.', 1, 'review', '1ca62a8a-98d3-5fa5-bf21-00e62d72c93c'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('26609a4c-5908-551b-b199-706529219e98'::UUID, '1ca62a8a-98d3-5fa5-bf21-00e62d72c93c'::UUID, '0dcf44c5-8066-5b7d-b859-0d464a8ff0d3'::UUID, 1, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('dad4815d-6df5-511c-ad6e-93cb5084d08a'::UUID, 'pronunciation:麻', '麻', 'má', 'tê; cây gai', 'numb; hemp', 'beginner', 'tones', 'tính từ/danh từ', '我的腿有点儿麻。', 'Wǒ de tuǐ yǒudiǎnr má.', 'Chân tôi hơi tê.', NULL, 'review', '1ca62a8a-98d3-5fa5-bf21-00e62d72c93c'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('a238b43c-d9d2-5d60-99b8-a3dea2484f03'::UUID, '1ca62a8a-98d3-5fa5-bf21-00e62d72c93c'::UUID, 'dad4815d-6df5-511c-ad6e-93cb5084d08a'::UUID, 2, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('e0c9d5ea-d393-568a-9b77-24ee9c47a52f'::UUID, 'pronunciation:马', '马', 'mǎ', 'ngựa', 'horse', 'beginner', 'tones', 'danh từ', '草原上有一匹马。', 'Cǎoyuán shang yǒu yì pǐ mǎ.', 'Trên thảo nguyên có một con ngựa.', 2, 'review', '1ca62a8a-98d3-5fa5-bf21-00e62d72c93c'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('3ed85c82-88f7-5df7-94e0-b680bfd2abd0'::UUID, '1ca62a8a-98d3-5fa5-bf21-00e62d72c93c'::UUID, 'e0c9d5ea-d393-568a-9b77-24ee9c47a52f'::UUID, 3, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('d93e1565-9e33-59e4-8cbd-0607d2a1b74f'::UUID, 'pronunciation:骂', '骂', 'mà', 'mắng', 'scold', 'beginner', 'tones', 'động từ', '请不要骂人。', 'Qǐng bú yào mà rén.', 'Xin đừng mắng người khác.', 4, 'review', '1ca62a8a-98d3-5fa5-bf21-00e62d72c93c'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('146fc682-8dca-596a-b895-e174cd9fc067'::UUID, '1ca62a8a-98d3-5fa5-bf21-00e62d72c93c'::UUID, 'd93e1565-9e33-59e4-8cbd-0607d2a1b74f'::UUID, 4, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('caee12ff-6f35-5bdf-8426-8c8b493220d6'::UUID, '1ca62a8a-98d3-5fa5-bf21-00e62d72c93c'::UUID, '13e5fdfd-a3be-5503-b5b6-54123b2d0c66'::UUID, 5, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('cf07dda7-b468-5b83-8faf-b932d437789e'::UUID, '1ca62a8a-98d3-5fa5-bf21-00e62d72c93c'::UUID, '5852b1ff-b7ff-5836-9190-71fde815292d'::UUID, 6, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('5232901a-af5e-558d-bd02-cccd61633cab'::UUID, '1ca62a8a-98d3-5fa5-bf21-00e62d72c93c'::UUID, '323a0411-c889-5db5-8220-c643db2876c8'::UUID, 7, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('deb12291-2114-5ff8-9508-195bc3c10644'::UUID, '1ca62a8a-98d3-5fa5-bf21-00e62d72c93c'::UUID, '35c86a8a-2089-59fc-a575-e19baff40763'::UUID, 8, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('00f436be-c6e2-5371-bda4-550bab882294'::UUID, '1ca62a8a-98d3-5fa5-bf21-00e62d72c93c'::UUID, '893c5ff6-2393-5894-809d-b5ef690ba97f'::UUID, 9, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.grammar_lessons (id, content_key, title, pattern, explanation, example_chinese, example_pinyin, example_meaning, level, status, usage_note, content_version)
VALUES ('9961d3bc-097b-55ff-b132-de07bc28a088'::UUID, 'pronunciation:four-tone-contours', 'Đường nét bốn thanh', 'cao ngang / đi lên / hạ rồi lên / đi xuống', 'Thanh 1 giữ cao; thanh 2 đi lên; thanh 3 hạ thấp rồi lên khi đọc riêng; thanh 4 rơi nhanh.', '妈、麻、马、骂', 'Mā, má, mǎ, mà.', 'mẹ, tê, ngựa, mắng', 'beginner', 'review', 'Trong chuỗi lời nói, thanh 3 thường không lên đầy đủ.', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_grammar (id, lesson_id, grammar_lesson_id, order_index, curriculum_role)
VALUES ('fb4e6a76-0a2f-536a-a6fe-682de4660946'::UUID, '1ca62a8a-98d3-5fa5-bf21-00e62d72c93c'::UUID, '9961d3bc-097b-55ff-b132-de07bc28a088'::UUID, 1, 'introduced')
ON CONFLICT (lesson_id, grammar_lesson_id) DO NOTHING;

INSERT INTO public.lesson_grammar (id, lesson_id, grammar_lesson_id, order_index, curriculum_role)
VALUES ('93ccbefd-eccf-59e6-a82a-1e5ad8621b5e'::UUID, '1ca62a8a-98d3-5fa5-bf21-00e62d72c93c'::UUID, '38111e04-873a-5ca0-a772-a4b5992c7a5c'::UUID, 2, 'review')
ON CONFLICT (lesson_id, grammar_lesson_id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('3d4cc3cf-c31e-567a-b59e-9f8c7523e74a'::UUID, '1ca62a8a-98d3-5fa5-bf21-00e62d72c93c'::UUID, 'vocabulary', 1, 'Từ mới: 妈', NULL, '妈', '妈 (mā) — mẹ. 我妈今天很忙。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"pronunciation:妈","chinese":"妈","pinyin":"mā","meaning":"mẹ","part_of_speech":"danh từ","example_chinese":"我妈今天很忙。","example_pinyin":"Wǒ mā jīntiān hěn máng.","example_meaning_vi":"Hôm nay mẹ tôi rất bận."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('8afdd320-57c7-5c7c-8281-36f6e7ae0273'::UUID, '1ca62a8a-98d3-5fa5-bf21-00e62d72c93c'::UUID, 'vocabulary', 2, 'Từ mới: 麻', NULL, '麻', '麻 (má) — tê; cây gai. 我的腿有点儿麻。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"pronunciation:麻","chinese":"麻","pinyin":"má","meaning":"tê; cây gai","part_of_speech":"tính từ/danh từ","example_chinese":"我的腿有点儿麻。","example_pinyin":"Wǒ de tuǐ yǒudiǎnr má.","example_meaning_vi":"Chân tôi hơi tê."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('f0e71811-f93a-50e0-b49d-789d5bdf72bd'::UUID, '1ca62a8a-98d3-5fa5-bf21-00e62d72c93c'::UUID, 'vocabulary', 3, 'Từ mới: 马', NULL, '马', '马 (mǎ) — ngựa. 草原上有一匹马。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"pronunciation:马","chinese":"马","pinyin":"mǎ","meaning":"ngựa","part_of_speech":"danh từ","example_chinese":"草原上有一匹马。","example_pinyin":"Cǎoyuán shang yǒu yì pǐ mǎ.","example_meaning_vi":"Trên thảo nguyên có một con ngựa."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('27c63919-e5c7-5799-84fa-7618a4e2f559'::UUID, '1ca62a8a-98d3-5fa5-bf21-00e62d72c93c'::UUID, 'vocabulary', 4, 'Từ mới: 骂', NULL, '骂', '骂 (mà) — mắng. 请不要骂人。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"pronunciation:骂","chinese":"骂","pinyin":"mà","meaning":"mắng","part_of_speech":"động từ","example_chinese":"请不要骂人。","example_pinyin":"Qǐng bú yào mà rén.","example_meaning_vi":"Xin đừng mắng người khác."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('4279317b-7eed-5705-bb16-a04649a14943'::UUID, '1ca62a8a-98d3-5fa5-bf21-00e62d72c93c'::UUID, 'multiple_choice', 5, '“马” có nghĩa phù hợp nhất là gì?', NULL, 'ngựa', '马 (mǎ) nghĩa là “ngựa”.', NULL, 1, '{"activity_type":"chinese_to_vietnamese","vocabulary_key":"pronunciation:马"}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('7658fcbb-2f8e-537b-93f7-cb9bfdc8dec2'::UUID, '4279317b-7eed-5705-bb16-a04649a14943'::UUID, 'mẹ', FALSE, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('05bebff5-418f-5e7c-99ca-f2487bb9545e'::UUID, '4279317b-7eed-5705-bb16-a04649a14943'::UUID, 'tê; cây gai', FALSE, 2)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('4e14b566-3069-5e37-90f1-5555ec64d778'::UUID, '4279317b-7eed-5705-bb16-a04649a14943'::UUID, 'mắng', FALSE, 3)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('cd8c4142-6a22-5e04-af41-f8450f034e03'::UUID, '4279317b-7eed-5705-bb16-a04649a14943'::UUID, 'ngựa', TRUE, 4)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('57caa387-e1c0-57bd-8d2d-e128915c907d'::UUID, '1ca62a8a-98d3-5fa5-bf21-00e62d72c93c'::UUID, 'translation', 6, 'Dịch sang tiếng Trung: “Trên thảo nguyên có một con ngựa.”', NULL, '草原上有一匹马。', 'Mẫu câu dùng “马” trong ngữ cảnh của bài.', 'mǎ', 1, '{"activity_type":"vietnamese_to_chinese","source_lang":"vi","target_lang":"zh","acceptable_answers":["草原上有一匹马。"]}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('c468b8b1-68b2-55ac-8a0d-1f3e417299bd'::UUID, '1ca62a8a-98d3-5fa5-bf21-00e62d72c93c'::UUID, 'sentence_builder', 7, 'Sắp xếp các thành phần thành câu đúng.', NULL, '草原上有一匹马。', 'Trật tự đúng tạo thành câu “草原上有一匹马。”.', NULL, 1, '{"activity_type":"sentence_ordering","words":["草原","上","有","一","匹","马","。"],"correct_order":["草原","上","有","一","匹","马","。"]}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('964cccc4-ac46-5b83-b07b-5ae925fccb49'::UUID, '1ca62a8a-98d3-5fa5-bf21-00e62d72c93c'::UUID, 'multiple_choice', 8, 'Pinyin nào biểu thị thanh 4?', NULL, 'mà', 'Dấu huyền trong pinyin (à) biểu thị thanh 4 đi xuống.', NULL, 1, '{"activity_type":"grammar_selection","passage":null,"grammar_key":"pronunciation:four-tone-contours"}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('950be2ef-efb0-5470-a6f1-b77a68080922'::UUID, '964cccc4-ac46-5b83-b07b-5ae925fccb49'::UUID, 'mà', TRUE, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('b7fa2c46-1573-5de6-a9bd-8b1d4e352ff2'::UUID, '964cccc4-ac46-5b83-b07b-5ae925fccb49'::UUID, 'mā', FALSE, 2)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('11ce5f50-b551-5d99-99ff-ea9f7d8722b9'::UUID, '964cccc4-ac46-5b83-b07b-5ae925fccb49'::UUID, 'má', FALSE, 3)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('9138f740-9500-5625-bc47-e504131c2fd1'::UUID, '964cccc4-ac46-5b83-b07b-5ae925fccb49'::UUID, 'mǎ', FALSE, 4)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('722ad7e2-7e4b-5f15-8144-59c8207331a5'::UUID, '1ca62a8a-98d3-5fa5-bf21-00e62d72c93c'::UUID, 'speaking', 9, 'Đọc thành tiếng: 草原上有一匹马。', NULL, '草原上有一匹马。', 'Đọc chậm, giữ đúng thanh điệu và nhịp của cả câu.', NULL, 1, '{"activity_type":"pronunciation","text":"草原上有一匹马。","pinyin":"Cǎoyuán shang yǒu yì pǐ mǎ."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.units (id, course_id, slug, title, description, order_index, status, learning_objectives, content_version)
VALUES ('da2be2a9-aa0f-5203-88cf-4ccafa3db2dc'::UUID, '2d1402c4-4084-5436-9b92-ad6eeeaf0e2a'::UUID, 'bien-dieu-va-am-kho', 'Biến điệu và âm khó', 'Thanh 3 liên tiếp, 一, 不 và nhóm âm đầu dễ nhầm.', 2, 'review', '["Áp dụng biến điệu trong cụm từ","Phân biệt zh/ch/sh/r với z/c/s"]'::JSONB, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.chapters (id, unit_id, slug, title, description, order_index, status, learning_objectives, content_version)
VALUES ('cca32be6-206d-5dc0-93f0-077d23c7ed86'::UUID, 'da2be2a9-aa0f-5203-88cf-4ccafa3db2dc'::UUID, 'bien-dieu', 'Biến điệu thường gặp', 'Đọc tự nhiên thanh 3, 一 và 不 trong câu.', 1, 'review', '["Đọc biến điệu theo âm tiết kế tiếp"]'::JSONB, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lessons (id, chapter_id, slug, title, description, order_index, xp_reward, status, lesson_type, estimated_minutes, learning_objectives, cultural_note, content_version)
VALUES ('954f9f30-034a-502e-8703-555242f1aff3'::UUID, 'cca32be6-206d-5dc0-93f0-077d23c7ed86'::UUID, 'yi-bu-thanh-ba', '你好、一个、不要', 'Ba quy tắc biến điệu có tần suất cao.', 1, 25, 'review', 'tone_practice', 15, '["Đọc tự nhiên 你好, 一个, 不要"]'::JSONB, NULL, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('60f7f71c-1c00-5da7-a307-7224a3ebe210'::UUID, 'pronunciation:一起', '一起', 'yìqǐ', 'cùng nhau', 'together', 'beginner', 'tone_sandhi', 'phó từ', '我们一起学习吧。', 'Wǒmen yìqǐ xuéxí ba.', 'Chúng ta cùng học nhé.', 1, 'review', '954f9f30-034a-502e-8703-555242f1aff3'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('64742405-0148-5cce-aecf-ecd5d1c0d610'::UUID, '954f9f30-034a-502e-8703-555242f1aff3'::UUID, '60f7f71c-1c00-5da7-a307-7224a3ebe210'::UUID, 1, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('d8730732-36a1-5c87-a406-452c13f34af5'::UUID, 'pronunciation:一个', '一个', 'yí ge', 'một (cái/người)', 'one', 'beginner', 'tone_sandhi', 'cụm số lượng', '我有一个问题。', 'Wǒ yǒu yí ge wèntí.', 'Tôi có một câu hỏi.', 1, 'review', '954f9f30-034a-502e-8703-555242f1aff3'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('818f5277-108b-55f9-b020-71764640f524'::UUID, '954f9f30-034a-502e-8703-555242f1aff3'::UUID, 'd8730732-36a1-5c87-a406-452c13f34af5'::UUID, 2, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('7772503e-b268-5faf-b9f9-0bafdf69e195'::UUID, 'pronunciation:不要', '不要', 'bú yào', 'đừng; không muốn', 'do not; do not want', 'beginner', 'tone_sandhi', 'cụm động từ', '不要担心。', 'Bú yào dānxīn.', 'Đừng lo.', 1, 'review', '954f9f30-034a-502e-8703-555242f1aff3'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('44daf2c6-f9d6-5187-a843-eceb1cf6b4f3'::UUID, '954f9f30-034a-502e-8703-555242f1aff3'::UUID, '7772503e-b268-5faf-b9f9-0bafdf69e195'::UUID, 3, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('dbba2bd2-41e5-553a-854f-821f81d80c43'::UUID, 'pronunciation:很好', '很好', 'hén hǎo', 'rất tốt', 'very good', 'beginner', 'tone_sandhi', 'cụm tính từ', '你的发音很好。', 'Nǐ de fāyīn hén hǎo.', 'Phát âm của bạn rất tốt.', 1, 'review', '954f9f30-034a-502e-8703-555242f1aff3'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('b62effea-43c6-51c9-a532-fb5106951e3a'::UUID, '954f9f30-034a-502e-8703-555242f1aff3'::UUID, 'dbba2bd2-41e5-553a-854f-821f81d80c43'::UUID, 4, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('55b5ffe2-edf0-5f99-bce5-6d18dcd98fe6'::UUID, 'pronunciation:不是', '不是', 'bú shì', 'không phải', 'is not', 'beginner', 'tone_sandhi', 'cụm động từ', '这不是我的书。', 'Zhè bú shì wǒ de shū.', 'Đây không phải sách của tôi.', 1, 'review', '954f9f30-034a-502e-8703-555242f1aff3'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('d0f0df0f-c551-53d0-90fc-687d96af7074'::UUID, '954f9f30-034a-502e-8703-555242f1aff3'::UUID, '55b5ffe2-edf0-5f99-bce5-6d18dcd98fe6'::UUID, 5, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('3d871ab5-c7be-5508-9d26-f6e9071ecde6'::UUID, '954f9f30-034a-502e-8703-555242f1aff3'::UUID, '0dcf44c5-8066-5b7d-b859-0d464a8ff0d3'::UUID, 6, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('a6ef6c84-69e4-5978-a767-06752e61626e'::UUID, '954f9f30-034a-502e-8703-555242f1aff3'::UUID, 'dad4815d-6df5-511c-ad6e-93cb5084d08a'::UUID, 7, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('2683b70c-f07b-59d0-a1f2-5eea4e5fd0a2'::UUID, '954f9f30-034a-502e-8703-555242f1aff3'::UUID, 'e0c9d5ea-d393-568a-9b77-24ee9c47a52f'::UUID, 8, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('e063aef6-e683-5163-a63f-2fe19b2ea1c4'::UUID, '954f9f30-034a-502e-8703-555242f1aff3'::UUID, 'd93e1565-9e33-59e4-8cbd-0607d2a1b74f'::UUID, 9, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.grammar_lessons (id, content_key, title, pattern, explanation, example_chinese, example_pinyin, example_meaning, level, status, usage_note, content_version)
VALUES ('432503f6-88e0-5e06-837d-b96bab139350'::UUID, 'pronunciation:tone-sandhi-core', 'Biến điệu cốt lõi', '3+3 → 2+3; 一/不 đổi theo thanh sau', 'Âm tiết thanh 3 đầu tiên đổi gần thanh 2 trước một thanh 3 khác. 一 và 不 đổi thanh theo âm tiết theo sau.', '你好、一个、不要', 'Ní hǎo, yí ge, bú yào.', 'xin chào, một cái, đừng', 'beginner', 'review', 'Chính tả pinyin thường giữ dấu thanh từ điển cho từ như 你好; phần pinyin phát âm có thể ghi biến điệu khi giảng âm.', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_grammar (id, lesson_id, grammar_lesson_id, order_index, curriculum_role)
VALUES ('6864eae5-8811-5410-8d63-a49a51f1b91e'::UUID, '954f9f30-034a-502e-8703-555242f1aff3'::UUID, '432503f6-88e0-5e06-837d-b96bab139350'::UUID, 1, 'introduced')
ON CONFLICT (lesson_id, grammar_lesson_id) DO NOTHING;

INSERT INTO public.lesson_grammar (id, lesson_id, grammar_lesson_id, order_index, curriculum_role)
VALUES ('cf04c02f-683f-5e19-b544-40ed9f5b913a'::UUID, '954f9f30-034a-502e-8703-555242f1aff3'::UUID, '9961d3bc-097b-55ff-b132-de07bc28a088'::UUID, 2, 'review')
ON CONFLICT (lesson_id, grammar_lesson_id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('e4cc33b7-8cb7-533f-99f4-6662342e759a'::UUID, '954f9f30-034a-502e-8703-555242f1aff3'::UUID, 'vocabulary', 1, 'Từ mới: 一起', NULL, '一起', '一起 (yìqǐ) — cùng nhau. 我们一起学习吧。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"pronunciation:一起","chinese":"一起","pinyin":"yìqǐ","meaning":"cùng nhau","part_of_speech":"phó từ","example_chinese":"我们一起学习吧。","example_pinyin":"Wǒmen yìqǐ xuéxí ba.","example_meaning_vi":"Chúng ta cùng học nhé."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('6dae727c-ecd7-5fff-89b3-b115762446e3'::UUID, '954f9f30-034a-502e-8703-555242f1aff3'::UUID, 'vocabulary', 2, 'Từ mới: 一个', NULL, '一个', '一个 (yí ge) — một (cái/người). 我有一个问题。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"pronunciation:一个","chinese":"一个","pinyin":"yí ge","meaning":"một (cái/người)","part_of_speech":"cụm số lượng","example_chinese":"我有一个问题。","example_pinyin":"Wǒ yǒu yí ge wèntí.","example_meaning_vi":"Tôi có một câu hỏi."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('15f3bea2-c69b-52e8-a143-2a1e53dc143d'::UUID, '954f9f30-034a-502e-8703-555242f1aff3'::UUID, 'vocabulary', 3, 'Từ mới: 不要', NULL, '不要', '不要 (bú yào) — đừng; không muốn. 不要担心。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"pronunciation:不要","chinese":"不要","pinyin":"bú yào","meaning":"đừng; không muốn","part_of_speech":"cụm động từ","example_chinese":"不要担心。","example_pinyin":"Bú yào dānxīn.","example_meaning_vi":"Đừng lo."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('5d1e3b33-ee88-54fd-96f8-01674319b434'::UUID, '954f9f30-034a-502e-8703-555242f1aff3'::UUID, 'vocabulary', 4, 'Từ mới: 很好', NULL, '很好', '很好 (hén hǎo) — rất tốt. 你的发音很好。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"pronunciation:很好","chinese":"很好","pinyin":"hén hǎo","meaning":"rất tốt","part_of_speech":"cụm tính từ","example_chinese":"你的发音很好。","example_pinyin":"Nǐ de fāyīn hén hǎo.","example_meaning_vi":"Phát âm của bạn rất tốt."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('f18a6e2d-1c5f-5426-aae2-2c7532ae1736'::UUID, '954f9f30-034a-502e-8703-555242f1aff3'::UUID, 'vocabulary', 5, 'Từ mới: 不是', NULL, '不是', '不是 (bú shì) — không phải. 这不是我的书。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"pronunciation:不是","chinese":"不是","pinyin":"bú shì","meaning":"không phải","part_of_speech":"cụm động từ","example_chinese":"这不是我的书。","example_pinyin":"Zhè bú shì wǒ de shū.","example_meaning_vi":"Đây không phải sách của tôi."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('b8a0a413-a098-58f6-a1a0-54ed9c99bd38'::UUID, '954f9f30-034a-502e-8703-555242f1aff3'::UUID, 'multiple_choice', 6, '“不要” có nghĩa phù hợp nhất là gì?', NULL, 'đừng; không muốn', '不要 (bú yào) nghĩa là “đừng; không muốn”.', NULL, 1, '{"activity_type":"chinese_to_vietnamese","vocabulary_key":"pronunciation:不要"}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('5ee9d882-c3c1-5ab7-87e7-0856a1162a14'::UUID, 'b8a0a413-a098-58f6-a1a0-54ed9c99bd38'::UUID, 'không phải', FALSE, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('0c3e75ae-a5f3-5f34-8e6c-418a60cbba97'::UUID, 'b8a0a413-a098-58f6-a1a0-54ed9c99bd38'::UUID, 'đừng; không muốn', TRUE, 2)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('edaf55ef-afb3-50d9-ad1a-3ced5d1ba9b5'::UUID, 'b8a0a413-a098-58f6-a1a0-54ed9c99bd38'::UUID, 'cùng nhau', FALSE, 3)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('869ed964-ca1f-5577-a7ba-4eab11436f73'::UUID, 'b8a0a413-a098-58f6-a1a0-54ed9c99bd38'::UUID, 'một (cái/người)', FALSE, 4)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('bf265c1b-088f-5360-9c82-0d6669209ec4'::UUID, '954f9f30-034a-502e-8703-555242f1aff3'::UUID, 'translation', 7, 'Dịch sang tiếng Trung: “Đừng lo.”', NULL, '不要担心。', 'Mẫu câu dùng “不要” trong ngữ cảnh của bài.', 'bú yào', 1, '{"activity_type":"vietnamese_to_chinese","source_lang":"vi","target_lang":"zh","acceptable_answers":["不要担心。"]}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('ac2ef0a2-6a7f-5369-84f8-aeba93795e2d'::UUID, '954f9f30-034a-502e-8703-555242f1aff3'::UUID, 'sentence_builder', 8, 'Sắp xếp các thành phần thành câu đúng.', NULL, '不要担心。', 'Trật tự đúng tạo thành câu “不要担心。”.', NULL, 1, '{"activity_type":"sentence_ordering","words":["不要","担心","。"],"correct_order":["不要","担心","。"]}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('d5c33780-29e8-55c4-b54f-188fdac86538'::UUID, '954f9f30-034a-502e-8703-555242f1aff3'::UUID, 'multiple_choice', 9, 'Trong lời nói tự nhiên, 不要 đọc thế nào?', NULL, 'bú yào', '不 đổi thành thanh 2 trước âm tiết thanh 4 要.', NULL, 1, '{"activity_type":"grammar_selection","passage":null,"grammar_key":"pronunciation:tone-sandhi-core"}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('6ad584d0-f27a-58c4-bec7-471de28ab7ac'::UUID, 'd5c33780-29e8-55c4-b54f-188fdac86538'::UUID, 'bú yào', TRUE, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('8601e692-1540-5616-a78b-b11013508732'::UUID, 'd5c33780-29e8-55c4-b54f-188fdac86538'::UUID, 'bù yào', FALSE, 2)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('725b5fac-14c2-555d-a8a8-d6166f8719b0'::UUID, 'd5c33780-29e8-55c4-b54f-188fdac86538'::UUID, 'bǔ yào', FALSE, 3)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('de255b18-f99c-5d5b-b901-31a6937035fc'::UUID, '954f9f30-034a-502e-8703-555242f1aff3'::UUID, 'speaking', 10, 'Đọc thành tiếng: 不要担心。', NULL, '不要担心。', 'Đọc chậm, giữ đúng thanh điệu và nhịp của cả câu.', NULL, 1, '{"activity_type":"pronunciation","text":"不要担心。","pinyin":"Bú yào dānxīn."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lessons (id, chapter_id, slug, title, description, order_index, xp_reward, status, lesson_type, estimated_minutes, learning_objectives, cultural_note, content_version)
VALUES ('6752bea1-bb65-5742-90ba-ac7b74d32362'::UUID, 'cca32be6-206d-5dc0-93f0-077d23c7ed86'::UUID, 'zh-ch-sh-r', 'zh、ch、sh、r', 'Luyện nhóm âm đầu uốn lưỡi qua từ có tần suất cao.', 2, 25, 'review', 'pronunciation', 15, '["Đặt đầu lưỡi đúng cho zh, ch, sh, r"]'::JSONB, NULL, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('0e9096ce-3611-59a7-b53d-c3e1753bbea2'::UUID, 'pronunciation:知道', '知道', 'zhīdao', 'biết', 'know', 'beginner', 'retroflex_initials', 'động từ', '我知道他的名字。', 'Wǒ zhīdao tā de míngzi.', 'Tôi biết tên anh ấy.', 2, 'review', '6752bea1-bb65-5742-90ba-ac7b74d32362'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('0b34961c-1126-5a9a-b340-44d74fd3642e'::UUID, '6752bea1-bb65-5742-90ba-ac7b74d32362'::UUID, '0e9096ce-3611-59a7-b53d-c3e1753bbea2'::UUID, 1, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('d9264e98-0a7c-552f-8f8e-f5e3e70b8f32'::UUID, 'pronunciation:吃', '吃', 'chī', 'ăn', 'eat', 'beginner', 'retroflex_initials', 'động từ', '我们去吃面条吧。', 'Wǒmen qù chī miàntiáo ba.', 'Chúng ta đi ăn mì nhé.', 1, 'review', '6752bea1-bb65-5742-90ba-ac7b74d32362'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('45e4278f-ed75-5e22-a769-919e63f4c658'::UUID, '6752bea1-bb65-5742-90ba-ac7b74d32362'::UUID, 'd9264e98-0a7c-552f-8f8e-f5e3e70b8f32'::UUID, 2, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('99d025d4-41c7-5459-b248-d6587b0e6ffe'::UUID, 'pronunciation:热', '热', 'rè', 'nóng', 'hot', 'beginner', 'retroflex_initials', 'tính từ', '今天太热了。', 'Jīntiān tài rè le.', 'Hôm nay nóng quá.', 1, 'review', '6752bea1-bb65-5742-90ba-ac7b74d32362'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('70677eff-2dc8-52fb-8aaf-b28f1ac7f819'::UUID, '6752bea1-bb65-5742-90ba-ac7b74d32362'::UUID, '99d025d4-41c7-5459-b248-d6587b0e6ffe'::UUID, 3, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('ec49092c-4c6e-57d8-af17-a3e7836c8d9a'::UUID, 'pronunciation:西', '西', 'xī', 'phía tây', 'west', 'beginner', 'initial_contrast', 'danh từ phương vị', '太阳从西边落下。', 'Tàiyáng cóng xībian luòxia.', 'Mặt trời lặn ở phía tây.', 2, 'review', '6752bea1-bb65-5742-90ba-ac7b74d32362'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('fc2bba33-947d-51f8-8ed5-d4343c6e4602'::UUID, '6752bea1-bb65-5742-90ba-ac7b74d32362'::UUID, 'ec49092c-4c6e-57d8-af17-a3e7836c8d9a'::UUID, 4, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('7430bd6d-5fcf-5abf-abaa-57c38e8ca94c'::UUID, '6752bea1-bb65-5742-90ba-ac7b74d32362'::UUID, '60f7f71c-1c00-5da7-a307-7224a3ebe210'::UUID, 5, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('f97415a3-6b27-570b-b1ef-94de129cb76e'::UUID, '6752bea1-bb65-5742-90ba-ac7b74d32362'::UUID, 'd8730732-36a1-5c87-a406-452c13f34af5'::UUID, 6, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('17f66ef4-8317-56cf-a68c-5b4dd7cb39ec'::UUID, '6752bea1-bb65-5742-90ba-ac7b74d32362'::UUID, '7772503e-b268-5faf-b9f9-0bafdf69e195'::UUID, 7, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('f41ac4dd-4475-5a26-b26a-79d1999e0f85'::UUID, '6752bea1-bb65-5742-90ba-ac7b74d32362'::UUID, 'dbba2bd2-41e5-553a-854f-821f81d80c43'::UUID, 8, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('2e64e5f1-13cc-51c8-b86a-daf018facc58'::UUID, '6752bea1-bb65-5742-90ba-ac7b74d32362'::UUID, '55b5ffe2-edf0-5f99-bce5-6d18dcd98fe6'::UUID, 9, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('803c00a3-989a-5c15-b11b-ea94da00c6a8'::UUID, '6752bea1-bb65-5742-90ba-ac7b74d32362'::UUID, 'f0000000-0000-0000-0000-000000000006'::UUID, 10, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('008ac7a0-6454-57b9-9e80-32af6463ed4d'::UUID, '6752bea1-bb65-5742-90ba-ac7b74d32362'::UUID, '20c5acb6-c78c-56b0-8a30-38b4319249e1'::UUID, 11, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.grammar_lessons (id, content_key, title, pattern, explanation, example_chinese, example_pinyin, example_meaning, level, status, usage_note, content_version)
VALUES ('d38ee683-0248-559b-a28f-1f8fd4984ce9'::UUID, 'pronunciation:retroflex-position', 'Vị trí đầu lưỡi của zh/ch/sh/r', 'đầu lưỡi hơi cong về sau, không chạm quá mạnh', 'Nhóm zh/ch/sh/r dùng vị trí uốn lưỡi; ch bật hơi mạnh hơn zh.', '知道、吃、热', 'Zhīdao, chī, rè.', 'biết, ăn, nóng', 'beginner', 'review', 'Không thêm nguyên âm rời sau zh/ch/sh/r; i trong zhi/chi/shi/ri là âm đặc biệt.', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_grammar (id, lesson_id, grammar_lesson_id, order_index, curriculum_role)
VALUES ('bbe75390-b0aa-544f-a6a6-d2524cf225e3'::UUID, '6752bea1-bb65-5742-90ba-ac7b74d32362'::UUID, 'd38ee683-0248-559b-a28f-1f8fd4984ce9'::UUID, 1, 'introduced')
ON CONFLICT (lesson_id, grammar_lesson_id) DO NOTHING;

INSERT INTO public.lesson_grammar (id, lesson_id, grammar_lesson_id, order_index, curriculum_role)
VALUES ('0b18cfc0-dbd7-5958-8cab-89dafa310a02'::UUID, '6752bea1-bb65-5742-90ba-ac7b74d32362'::UUID, '432503f6-88e0-5e06-837d-b96bab139350'::UUID, 2, 'review')
ON CONFLICT (lesson_id, grammar_lesson_id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('58528731-61b5-59cd-b4f1-39e41e8265c9'::UUID, '6752bea1-bb65-5742-90ba-ac7b74d32362'::UUID, 'vocabulary', 1, 'Từ mới: 知道', NULL, '知道', '知道 (zhīdao) — biết. 我知道他的名字。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"pronunciation:知道","chinese":"知道","pinyin":"zhīdao","meaning":"biết","part_of_speech":"động từ","example_chinese":"我知道他的名字。","example_pinyin":"Wǒ zhīdao tā de míngzi.","example_meaning_vi":"Tôi biết tên anh ấy."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('ab4cc15c-729d-57cd-893c-a6a765853d55'::UUID, '6752bea1-bb65-5742-90ba-ac7b74d32362'::UUID, 'vocabulary', 2, 'Từ mới: 吃', NULL, '吃', '吃 (chī) — ăn. 我们去吃面条吧。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"pronunciation:吃","chinese":"吃","pinyin":"chī","meaning":"ăn","part_of_speech":"động từ","example_chinese":"我们去吃面条吧。","example_pinyin":"Wǒmen qù chī miàntiáo ba.","example_meaning_vi":"Chúng ta đi ăn mì nhé."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('1f353c15-1a50-591f-b8e0-71419afb9462'::UUID, '6752bea1-bb65-5742-90ba-ac7b74d32362'::UUID, 'vocabulary', 3, 'Từ mới: 热', NULL, '热', '热 (rè) — nóng. 今天太热了。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"pronunciation:热","chinese":"热","pinyin":"rè","meaning":"nóng","part_of_speech":"tính từ","example_chinese":"今天太热了。","example_pinyin":"Jīntiān tài rè le.","example_meaning_vi":"Hôm nay nóng quá."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('c964b943-9345-552c-b722-c0bfbc327bab'::UUID, '6752bea1-bb65-5742-90ba-ac7b74d32362'::UUID, 'vocabulary', 4, 'Từ mới: 西', NULL, '西', '西 (xī) — phía tây. 太阳从西边落下。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"pronunciation:西","chinese":"西","pinyin":"xī","meaning":"phía tây","part_of_speech":"danh từ phương vị","example_chinese":"太阳从西边落下。","example_pinyin":"Tàiyáng cóng xībian luòxia.","example_meaning_vi":"Mặt trời lặn ở phía tây."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('fa34ceb7-4604-5971-9267-bcc8da74ba83'::UUID, '6752bea1-bb65-5742-90ba-ac7b74d32362'::UUID, 'multiple_choice', 5, '“知道” có nghĩa phù hợp nhất là gì?', NULL, 'biết', '知道 (zhīdao) nghĩa là “biết”.', NULL, 1, '{"activity_type":"chinese_to_vietnamese","vocabulary_key":"pronunciation:知道"}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('e0679591-ce86-540d-b131-31966ce96f36'::UUID, 'fa34ceb7-4604-5971-9267-bcc8da74ba83'::UUID, 'ăn', FALSE, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('c04a6336-5fec-5b3c-bec4-13ff64b392c3'::UUID, 'fa34ceb7-4604-5971-9267-bcc8da74ba83'::UUID, 'nóng', FALSE, 2)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('f27a460f-d9f2-581e-986d-a3c821e35225'::UUID, 'fa34ceb7-4604-5971-9267-bcc8da74ba83'::UUID, 'phía tây', FALSE, 3)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('3c36dbd4-da00-578e-bfc9-0586cdfe11a5'::UUID, 'fa34ceb7-4604-5971-9267-bcc8da74ba83'::UUID, 'biết', TRUE, 4)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('539907bc-4c6c-5605-ac0b-b477c559c0b9'::UUID, '6752bea1-bb65-5742-90ba-ac7b74d32362'::UUID, 'translation', 6, 'Dịch sang tiếng Trung: “Tôi biết tên anh ấy.”', NULL, '我知道他的名字。', 'Mẫu câu dùng “知道” trong ngữ cảnh của bài.', 'zhīdao', 1, '{"activity_type":"vietnamese_to_chinese","source_lang":"vi","target_lang":"zh","acceptable_answers":["我知道他的名字。"]}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('d47ee627-0ba6-582d-bd87-ead39773bbf3'::UUID, '6752bea1-bb65-5742-90ba-ac7b74d32362'::UUID, 'sentence_builder', 7, 'Sắp xếp các thành phần thành câu đúng.', NULL, '我知道他的名字。', 'Trật tự đúng tạo thành câu “我知道他的名字。”.', NULL, 1, '{"activity_type":"sentence_ordering","words":["我","知道","他","的","名字","。"],"correct_order":["我","知道","他","的","名字","。"]}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('822a5c43-e5f8-594b-88bc-a1d1f0550d95'::UUID, '6752bea1-bb65-5742-90ba-ac7b74d32362'::UUID, 'multiple_choice', 8, 'Âm nào bật hơi trong cặp zh/ch?', NULL, 'ch', 'ch bật hơi; zh không bật hơi mạnh.', NULL, 1, '{"activity_type":"grammar_selection","passage":null,"grammar_key":"pronunciation:retroflex-position"}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('feca4495-6133-5f37-b319-557798132ced'::UUID, '822a5c43-e5f8-594b-88bc-a1d1f0550d95'::UUID, 'ch', TRUE, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('fc1ac373-794d-5f26-9562-e27264de1af2'::UUID, '822a5c43-e5f8-594b-88bc-a1d1f0550d95'::UUID, 'zh', FALSE, 2)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('b642e17d-5dcc-509b-bf30-ef13a6be47c9'::UUID, '822a5c43-e5f8-594b-88bc-a1d1f0550d95'::UUID, 'Cả hai như nhau', FALSE, 3)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('d29af9e2-50a5-5ddb-8ff3-1dccea483b79'::UUID, '6752bea1-bb65-5742-90ba-ac7b74d32362'::UUID, 'speaking', 9, 'Đọc thành tiếng: 我知道他的名字。', NULL, '我知道他的名字。', 'Đọc chậm, giữ đúng thanh điệu và nhịp của cả câu.', NULL, 1, '{"activity_type":"pronunciation","text":"我知道他的名字。","pinyin":"Wǒ zhīdao tā de míngzi."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.chapters (id, unit_id, slug, title, description, order_index, status, learning_objectives, content_version)
VALUES ('00fc3ddd-0be8-53dc-9f20-8ab8cb145948'::UUID, 'da2be2a9-aa0f-5203-88cf-4ccafa3db2dc'::UUID, 'on-tap-phat-am', 'Ôn tập phát âm', 'Tổng hợp pinyin, bốn thanh và biến điệu.', 2, 'review', '["Đọc đoạn ngắn với thanh điệu ổn định"]'::JSONB, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lessons (id, chapter_id, slug, title, description, order_index, xp_reward, status, lesson_type, estimated_minutes, learning_objectives, cultural_note, content_version)
VALUES ('c9c113ff-9bd7-5684-b48b-046e0681b831'::UUID, '00fc3ddd-0be8-53dc-9f20-8ab8cb145948'::UUID, 'on-tap-pinyin-thanh-dieu', '语音复习 - Ôn pinyin và thanh điệu', 'Ôn âm môi, vận mẫu, bốn thanh, biến điệu và âm uốn lưỡi.', 1, 30, 'review', 'review', 18, '["Đọc một đoạn giới thiệu ngắn với pinyin chuẩn"]'::JSONB, NULL, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('d5a365cf-fd69-5ed0-9b45-b4dd4dbac355'::UUID, 'c9c113ff-9bd7-5684-b48b-046e0681b831'::UUID, '0e9096ce-3611-59a7-b53d-c3e1753bbea2'::UUID, 1, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('4b96fe11-a26c-5533-9ef6-3daeac134f2d'::UUID, 'c9c113ff-9bd7-5684-b48b-046e0681b831'::UUID, 'd9264e98-0a7c-552f-8f8e-f5e3e70b8f32'::UUID, 2, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('dbe4194c-ae33-556a-a362-b5f4701a4ff0'::UUID, 'c9c113ff-9bd7-5684-b48b-046e0681b831'::UUID, '99d025d4-41c7-5459-b248-d6587b0e6ffe'::UUID, 3, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('c466e3e9-c056-5138-995d-c731a230c069'::UUID, 'c9c113ff-9bd7-5684-b48b-046e0681b831'::UUID, 'ec49092c-4c6e-57d8-af17-a3e7836c8d9a'::UUID, 4, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('3de918ee-53d7-5f98-a13c-86fb68de7e3a'::UUID, 'c9c113ff-9bd7-5684-b48b-046e0681b831'::UUID, '7a84a37b-3d6e-51bc-a24c-3e10b017a3a5'::UUID, 5, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('dd409e48-dc13-5d76-9332-402c6e2e4ec6'::UUID, 'c9c113ff-9bd7-5684-b48b-046e0681b831'::UUID, 'a1850a8d-aa67-5730-9cab-2ad6220cd3cf'::UUID, 6, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('a1e4357b-c46c-5204-8bdb-add7b0bd9ef1'::UUID, 'c9c113ff-9bd7-5684-b48b-046e0681b831'::UUID, '893c5ff6-2393-5894-809d-b5ef690ba97f'::UUID, 7, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('b1d461db-d291-5f2a-b52d-1e3d07b7e58b'::UUID, 'c9c113ff-9bd7-5684-b48b-046e0681b831'::UUID, 'e0c9d5ea-d393-568a-9b77-24ee9c47a52f'::UUID, 8, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('af3208c7-9f07-57bd-95b0-dd22ab4efe24'::UUID, 'c9c113ff-9bd7-5684-b48b-046e0681b831'::UUID, '7772503e-b268-5faf-b9f9-0bafdf69e195'::UUID, 9, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('82f6fd01-30be-592a-8b13-5137af90ed21'::UUID, 'c9c113ff-9bd7-5684-b48b-046e0681b831'::UUID, 'f0000000-0000-0000-0000-000000000003'::UUID, 10, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_grammar (id, lesson_id, grammar_lesson_id, order_index, curriculum_role)
VALUES ('8e6b9bd4-42b9-54d3-a9f2-3ef27a7c066b'::UUID, 'c9c113ff-9bd7-5684-b48b-046e0681b831'::UUID, 'd38ee683-0248-559b-a28f-1f8fd4984ce9'::UUID, 1, 'review')
ON CONFLICT (lesson_id, grammar_lesson_id) DO NOTHING;

INSERT INTO public.lesson_grammar (id, lesson_id, grammar_lesson_id, order_index, curriculum_role)
VALUES ('2d652baf-9451-5979-8758-fce02b1f6f20'::UUID, 'c9c113ff-9bd7-5684-b48b-046e0681b831'::UUID, '432503f6-88e0-5e06-837d-b96bab139350'::UUID, 2, 'review')
ON CONFLICT (lesson_id, grammar_lesson_id) DO NOTHING;

INSERT INTO public.lesson_grammar (id, lesson_id, grammar_lesson_id, order_index, curriculum_role)
VALUES ('919dfa37-0546-5568-984e-dc483a5b4f73'::UUID, 'c9c113ff-9bd7-5684-b48b-046e0681b831'::UUID, '9961d3bc-097b-55ff-b132-de07bc28a088'::UUID, 3, 'review')
ON CONFLICT (lesson_id, grammar_lesson_id) DO NOTHING;

INSERT INTO public.lesson_grammar (id, lesson_id, grammar_lesson_id, order_index, curriculum_role)
VALUES ('dbec9065-2c54-51ff-8d11-65739995a5c1'::UUID, 'c9c113ff-9bd7-5684-b48b-046e0681b831'::UUID, '38111e04-873a-5ca0-a772-a4b5992c7a5c'::UUID, 4, 'review')
ON CONFLICT (lesson_id, grammar_lesson_id) DO NOTHING;

INSERT INTO public.lesson_grammar (id, lesson_id, grammar_lesson_id, order_index, curriculum_role)
VALUES ('6142181e-d7cf-5c08-b2db-6d59b2dd3533'::UUID, 'c9c113ff-9bd7-5684-b48b-046e0681b831'::UUID, '81d0ac74-12cd-584a-9d48-3c543ff1c813'::UUID, 5, 'review')
ON CONFLICT (lesson_id, grammar_lesson_id) DO NOTHING;

INSERT INTO public.lesson_grammar (id, lesson_id, grammar_lesson_id, order_index, curriculum_role)
VALUES ('19216851-3bd8-5e37-b2a9-12f504b9e247'::UUID, 'c9c113ff-9bd7-5684-b48b-046e0681b831'::UUID, '731f2619-8a28-5d88-b586-9b5942afdd54'::UUID, 6, 'review')
ON CONFLICT (lesson_id, grammar_lesson_id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('150dea4c-cb96-5ff7-b60c-6c99dfd75d47'::UUID, 'c9c113ff-9bd7-5684-b48b-046e0681b831'::UUID, 'multiple_choice', 1, '“知道” có nghĩa phù hợp nhất là gì?', NULL, 'biết', '知道 (zhīdao) nghĩa là “biết”.', NULL, 1, '{"activity_type":"chinese_to_vietnamese","vocabulary_key":"pronunciation:知道"}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('efd7230c-6cd9-53fb-9080-56d2929b4389'::UUID, '150dea4c-cb96-5ff7-b60c-6c99dfd75d47'::UUID, 'ăn', FALSE, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('e0b5e902-0a7c-5230-b082-62a1014e6a94'::UUID, '150dea4c-cb96-5ff7-b60c-6c99dfd75d47'::UUID, 'nóng', FALSE, 2)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('f9956922-736e-5218-a17b-5996169a1f6e'::UUID, '150dea4c-cb96-5ff7-b60c-6c99dfd75d47'::UUID, 'phía tây', FALSE, 3)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('2b7ea7e6-ff56-5719-b331-a5da8f28795a'::UUID, '150dea4c-cb96-5ff7-b60c-6c99dfd75d47'::UUID, 'biết', TRUE, 4)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('7d971daa-ed2e-5534-9e59-8a581eed3c6e'::UUID, 'c9c113ff-9bd7-5684-b48b-046e0681b831'::UUID, 'translation', 2, 'Dịch sang tiếng Trung: “Phát âm của bạn rất tốt.”', NULL, '你的发音很好。', '发音 là “phát âm”; 很好 đọc tự nhiên với biến điệu thanh 3.', 'zhīdao', 1, '{"activity_type":"vietnamese_to_chinese","source_lang":"vi","target_lang":"zh","acceptable_answers":["你的发音很好。"]}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('bcf54380-1ad4-51fa-a7da-65e86c594cfb'::UUID, 'c9c113ff-9bd7-5684-b48b-046e0681b831'::UUID, 'sentence_builder', 3, 'Sắp xếp các thành phần thành câu đúng.', NULL, '你的发音很好。', 'Trật tự đúng tạo thành câu “你的发音很好。”.', NULL, 1, '{"activity_type":"sentence_ordering","words":["你","的","发音","很","好","。"],"correct_order":["你","的","发音","很","好","。"]}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('c6ebe5b1-9c57-5922-9276-da2afe4a4e10'::UUID, 'c9c113ff-9bd7-5684-b48b-046e0681b831'::UUID, 'multiple_choice', 4, 'Cách đọc tự nhiên nào đúng với 不要?', NULL, 'bú yào', '不 đổi thành thanh 2 trước thanh 4.', NULL, 1, '{"activity_type":"reading_comprehension","passage":"兰学习拼音。她每天练习声调，现在发音很好。","grammar_key":null}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('8f1ed645-52d9-532f-abf7-d6df4794ea07'::UUID, 'c6ebe5b1-9c57-5922-9276-da2afe4a4e10'::UUID, 'bú yào', TRUE, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('ccd8b3c8-0093-5528-90b4-02ec14645d59'::UUID, 'c6ebe5b1-9c57-5922-9276-da2afe4a4e10'::UUID, 'bù yào', FALSE, 2)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('75ef038d-22bb-5822-97f5-233db5688fc2'::UUID, 'c6ebe5b1-9c57-5922-9276-da2afe4a4e10'::UUID, 'bū yào', FALSE, 3)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('c78f12c8-05e2-5f0f-a7fa-d51088dd89b0'::UUID, 'c9c113ff-9bd7-5684-b48b-046e0681b831'::UUID, 'speaking', 5, 'Đọc thành tiếng: 你好，我叫兰。我们一起学习拼音吧。', NULL, '你好，我叫兰。我们一起学习拼音吧。', 'Đọc chậm, giữ đúng thanh điệu và nhịp của cả câu.', NULL, 1, '{"activity_type":"pronunciation","text":"你好，我叫兰。我们一起学习拼音吧。","pinyin":"Nǐ hǎo, wǒ jiào Lán. Wǒmen yìqǐ xuéxí pīnyīn ba."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.content_batches (id, batch_key, version, migration_name, manifest_checksum, expected_counts)
VALUES ('c1fd5e6b-c935-5910-8712-5f8280af324c'::UUID, 'batch-01-foundation-pronunciation', 1, '20260729100000_content_batch_01_foundation_pronunciation', 'a3576f532e1820b7db057eca0b1a36751a959629e46528fc3c4e16ffb2f40315', '{"courses":1,"units":3,"chapters":6,"lessons":12,"vocabulary":56,"grammar":15,"characters":5,"exercises":161,"options":120}'::JSONB)
ON CONFLICT (batch_key, version) DO NOTHING;

DO $content_validation$
BEGIN
  IF (SELECT COUNT(*) FROM public.courses WHERE id = ANY(ARRAY['c0000000-0000-0000-0000-000000000001'::UUID, '2d1402c4-4084-5436-9b92-ad6eeeaf0e2a'::UUID]::UUID[])) <> 2 THEN
    RAISE EXCEPTION 'Content batch batch-01-foundation-pronunciation is missing managed courses rows';
  END IF;
  IF (SELECT COUNT(*) FROM public.units WHERE id = ANY(ARRAY['a0000001-0000-0000-0000-000000000001'::UUID, 'baf1538b-0780-5683-81ec-7be46cd81fcc'::UUID, '755916ff-f96f-5eaf-8fa2-a344d78fa512'::UUID, 'da2be2a9-aa0f-5203-88cf-4ccafa3db2dc'::UUID]::UUID[])) <> 4 THEN
    RAISE EXCEPTION 'Content batch batch-01-foundation-pronunciation is missing managed units rows';
  END IF;
  IF (SELECT COUNT(*) FROM public.chapters WHERE id = ANY(ARRAY['c0000002-0000-0000-0000-000000000001'::UUID, '667e3e76-dbbd-53da-ba2e-a6c0faa7e55d'::UUID, 'b477ec9c-a7fa-5abf-9e65-8d40989befde'::UUID, '9f32b770-dcb9-54d5-8c34-24283979f4df'::UUID, '51fe6100-d1e3-534d-87ee-c580119f4822'::UUID, 'cca32be6-206d-5dc0-93f0-077d23c7ed86'::UUID, '00fc3ddd-0be8-53dc-9f20-8ab8cb145948'::UUID]::UUID[])) <> 7 THEN
    RAISE EXCEPTION 'Content batch batch-01-foundation-pronunciation is missing managed chapters rows';
  END IF;
  IF (SELECT COUNT(*) FROM public.lessons WHERE id = ANY(ARRAY['10000000-0000-0000-0000-000000000001'::UUID, '10000000-0000-0000-0000-000000000002'::UUID, '10000000-0000-0000-0000-000000000003'::UUID, '10000000-0000-0000-0000-000000000004'::UUID, '10000000-0000-0000-0000-000000000005'::UUID, '17dd9d54-3f33-51c0-8492-84b7a4962632'::UUID, 'e5a77950-bd6d-5080-8434-b7ec4b17e279'::UUID, 'a31244dd-d46d-5763-821c-909302dcf743'::UUID, 'e86c4323-6319-5c95-bc71-d6fe6c98e3be'::UUID, '0c573448-400a-5235-9bd7-629c7480b6ee'::UUID, '30c43e9c-4198-5b27-97b6-3ae4227fa545'::UUID, '4c9084f4-7c21-52fb-b1c5-e88cf5c19ba3'::UUID, 'c44683a2-76ec-52f4-8a2c-192346300aa4'::UUID, '1ca62a8a-98d3-5fa5-bf21-00e62d72c93c'::UUID, '954f9f30-034a-502e-8703-555242f1aff3'::UUID, '6752bea1-bb65-5742-90ba-ac7b74d32362'::UUID, 'c9c113ff-9bd7-5684-b48b-046e0681b831'::UUID]::UUID[])) <> 17 THEN
    RAISE EXCEPTION 'Content batch batch-01-foundation-pronunciation is missing managed lessons rows';
  END IF;
  IF (SELECT COUNT(*) FROM public.vocabulary WHERE id = ANY(ARRAY['f0000000-0000-0000-0000-000000000001'::UUID, 'f0000000-0000-0000-0000-000000000002'::UUID, 'f0000000-0000-0000-0000-000000000003'::UUID, 'f0000000-0000-0000-0000-000000000009'::UUID, 'f0000000-0000-0000-0000-000000000010'::UUID, 'f0000000-0000-0000-0000-000000000004'::UUID, 'f0000000-0000-0000-0000-000000000005'::UUID, 'f0000000-0000-0000-0000-000000000006'::UUID, 'f0000000-0000-0000-0000-000000000007'::UUID, 'f0000000-0000-0000-0000-000000000008'::UUID, 'f0000000-0000-0000-0000-000000000011'::UUID, 'f0000000-0000-0000-0000-000000000012'::UUID, 'f0000000-0000-0000-0000-000000000013'::UUID, 'f0000000-0000-0000-0000-000000000014'::UUID, 'f0000000-0000-0000-0000-000000000015'::UUID, 'f0000000-0000-0000-0000-000000000016'::UUID, 'f0000000-0000-0000-0000-000000000017'::UUID, 'f0000000-0000-0000-0000-000000000018'::UUID, 'f0000000-0000-0000-0000-000000000019'::UUID, 'f0000000-0000-0000-0000-000000000020'::UUID, '833a2bed-d3c2-5bc0-90bb-7020b8572c27'::UUID, '93a3a1e7-7e54-5759-b830-135f86188ed0'::UUID, 'b31fb9ef-3df0-53a1-bb9f-2b449ee8f42b'::UUID, 'f321f82f-4d1d-5ee0-9024-784a4931a68e'::UUID, '85612ee6-945a-56a4-894e-b55aef0d3633'::UUID, '20c5acb6-c78c-56b0-8a30-38b4319249e1'::UUID, '6b8f96ba-b343-557b-804e-20cba7bd19ce'::UUID, 'b4532d2f-c0a1-52f0-b907-73fe8bb1c3f8'::UUID, '47bd12e9-c8f1-57e7-976b-776f1d9ed3d0'::UUID, '050fb165-102e-594d-8446-72519162c9c1'::UUID, 'c9808f2b-7b4c-50fd-b27f-3f9ca944c91f'::UUID, 'c8b6cb2b-901e-5926-b935-1d6c66a3f16a'::UUID, '9c612634-0de7-5b2b-aa23-fafc039e386c'::UUID, '1ea38532-9419-5a76-b964-e0b147aea634'::UUID, '5a6c73f9-0881-5285-94d1-124428914976'::UUID, '6a7bac41-7cc6-5b92-86fb-d78a49460de7'::UUID, '8546e8fa-1a87-5798-a312-a3bd52370710'::UUID, 'b3f21e12-613c-53c4-b161-215ebad4b593'::UUID, 'dbd9e534-47ea-5a5f-9e3a-aab16ea89798'::UUID, 'c2ab9048-8877-59c7-ad35-80cc596d4135'::UUID, '4186d928-779f-5977-8383-55e16ed403e0'::UUID, 'fafc9144-dfe6-590a-818e-55b052a3b54d'::UUID, '3cdc325b-8d79-5a27-a746-e729758fe09d'::UUID, '04c4fcaf-338f-5e7e-99b4-dc02f5b11f8e'::UUID, 'd7d61680-13ed-5bf6-84bc-069bd30b53b2'::UUID, 'f11f19aa-9dfb-5011-af72-249acfce7246'::UUID, '8b4027a7-6a7e-542a-a0e6-9b7de1728c7f'::UUID, '05836bb7-8f4c-5ccd-90a1-a3847259a984'::UUID, '11eb3139-6193-5a33-ad16-0c5365a413cb'::UUID, 'a7c41243-3c0c-50dd-9906-ca4b006fc913'::UUID, '7a84a37b-3d6e-51bc-a24c-3e10b017a3a5'::UUID, '1f290002-5735-5f03-835f-c3b12cae2ad4'::UUID, 'bacac630-deda-55d4-980e-dd68f365dbc1'::UUID, '711339be-02a4-5758-963b-2c2cbd32627f'::UUID, '20d759b7-88e1-554f-8ccf-af7312b57f76'::UUID, 'a1850a8d-aa67-5730-9cab-2ad6220cd3cf'::UUID, 'f99dccb6-bb36-555c-b1c7-87c177fd3118'::UUID, '0dea2ca4-5ef0-5149-9231-e35b06f29b27'::UUID, '13e5fdfd-a3be-5503-b5b6-54123b2d0c66'::UUID, '5852b1ff-b7ff-5836-9190-71fde815292d'::UUID, '323a0411-c889-5db5-8220-c643db2876c8'::UUID, '35c86a8a-2089-59fc-a575-e19baff40763'::UUID, '893c5ff6-2393-5894-809d-b5ef690ba97f'::UUID, '0dcf44c5-8066-5b7d-b859-0d464a8ff0d3'::UUID, 'dad4815d-6df5-511c-ad6e-93cb5084d08a'::UUID, 'e0c9d5ea-d393-568a-9b77-24ee9c47a52f'::UUID, 'd93e1565-9e33-59e4-8cbd-0607d2a1b74f'::UUID, '60f7f71c-1c00-5da7-a307-7224a3ebe210'::UUID, 'd8730732-36a1-5c87-a406-452c13f34af5'::UUID, '7772503e-b268-5faf-b9f9-0bafdf69e195'::UUID, 'dbba2bd2-41e5-553a-854f-821f81d80c43'::UUID, '55b5ffe2-edf0-5f99-bce5-6d18dcd98fe6'::UUID, '0e9096ce-3611-59a7-b53d-c3e1753bbea2'::UUID, 'd9264e98-0a7c-552f-8f8e-f5e3e70b8f32'::UUID, '99d025d4-41c7-5459-b248-d6587b0e6ffe'::UUID, 'ec49092c-4c6e-57d8-af17-a3e7836c8d9a'::UUID]::UUID[])) <> 76 THEN
    RAISE EXCEPTION 'Content batch batch-01-foundation-pronunciation is missing managed vocabulary rows';
  END IF;
  IF (SELECT COUNT(*) FROM public.grammar_lessons WHERE id = ANY(ARRAY['2df08b1e-075e-5550-83fa-5b649bdc5670'::UUID, 'cc829157-96aa-55c6-823c-ab112447cf96'::UUID, 'ce0fde8f-cdac-55b0-8f57-5c4baf9e9027'::UUID, '055638e0-11e5-5af8-9176-a596b5da0afc'::UUID, 'fd3f559d-63c5-59f6-998e-7a4aee208002'::UUID, 'ed17b98c-f80a-56bd-9274-371dcf28e056'::UUID, '9632b5ca-aba2-532f-888b-da79da75f754'::UUID, 'e242badd-9725-533f-ae67-abb1ecf4e82a'::UUID, 'dc9eb19c-d0a3-52ca-a11d-1f8bd368eccf'::UUID, '731f2619-8a28-5d88-b586-9b5942afdd54'::UUID, '81d0ac74-12cd-584a-9d48-3c543ff1c813'::UUID, '38111e04-873a-5ca0-a772-a4b5992c7a5c'::UUID, '9961d3bc-097b-55ff-b132-de07bc28a088'::UUID, '432503f6-88e0-5e06-837d-b96bab139350'::UUID, 'd38ee683-0248-559b-a28f-1f8fd4984ce9'::UUID]::UUID[])) <> 15 THEN
    RAISE EXCEPTION 'Content batch batch-01-foundation-pronunciation is missing managed grammar_lessons rows';
  END IF;
  IF (SELECT COUNT(*) FROM public.characters WHERE id = ANY(ARRAY['9a8bfa8f-c6d0-5db3-86ee-4d3a970c413f'::UUID, '6a952254-d816-5b43-940b-a9b12223be3c'::UUID, '9fb58e63-8f87-5714-93d6-5f5a3f752cf4'::UUID, '0f7fe753-6ab7-51d3-a0a8-d449cd63d99c'::UUID, '66c1b0a2-a009-5822-81e3-763dd80e7d57'::UUID]::UUID[])) <> 5 THEN
    RAISE EXCEPTION 'Content batch batch-01-foundation-pronunciation is missing managed characters rows';
  END IF;
  IF (SELECT COUNT(*) FROM public.exercises WHERE id = ANY(ARRAY['d0258bd8-45bb-5e16-90f1-57b290b249c4'::UUID, '5e2b863c-2323-529f-a636-020c99fcb7d6'::UUID, '0fadf4a5-1507-5974-bf65-f0c84831321a'::UUID, 'b38bebfa-65ef-538d-a739-de3aa2618ad0'::UUID, 'b9ebf219-5402-5696-988b-33e7ff235fb2'::UUID, 'b8a3ae38-0643-5116-b3be-7f0575a17069'::UUID, 'a8668f83-9762-55f1-9fd0-179d2af50092'::UUID, 'b2a48976-6f54-53ae-b136-17ac22a8d3c7'::UUID, '874552a5-ad5d-5193-abd7-6cf5bb32a5fa'::UUID, '6c69a6d3-084a-5c1e-bfe2-6f1474b4e70a'::UUID, '376e78a1-1a6b-50e5-9fda-8e0581ea9216'::UUID, '55216da1-1994-5bc6-8bfb-360ec1f29c3c'::UUID, '566fe4f0-e69f-50e2-9f38-7e482bbd61e5'::UUID, '0994dc28-f663-5264-94ee-9cc0a4cffbd4'::UUID, '0cda4f86-1a08-5bfc-a01c-28cce9ec9abc'::UUID, 'de6e0996-e9c9-5446-8cb1-60440a277716'::UUID, '3657ef54-cd96-53d9-be50-424b89595230'::UUID, '62bdf135-dd22-5a72-9603-85d86397a831'::UUID, 'cbfad24b-dc5f-5740-96f6-968e3f703229'::UUID, 'bd82d061-0c0f-53aa-a0fc-043f3aa3dbc8'::UUID, '4a5b9252-db42-597b-a9cc-aa6d62b95859'::UUID, '2d570e55-c161-5c4c-ac09-de92703292c7'::UUID, '972c0879-bc25-594d-8e6a-cdb9cda7d332'::UUID, 'd309ff29-776b-57c7-a521-8e875cec5080'::UUID, '84f08efc-129e-5d68-8273-f9362e241c94'::UUID, '5d697f84-6f32-5760-8cf4-2f60a460d3eb'::UUID, '37a2a44a-382e-56ee-a5b8-d857a3b03fc9'::UUID, '7c96bdfc-32e1-589e-ab32-e139ec43fb5e'::UUID, '26660975-6f93-5e51-b983-5edaece0bf13'::UUID, '99c81f1c-bced-566a-b49d-e7e1a89a1fce'::UUID, 'bdc30f54-b7be-56d8-9ede-9a19d60a0df8'::UUID, '7feade02-b049-53a7-a97f-3a7aaf87af88'::UUID, '3b91ae32-be96-5080-8a8f-aec7e17141b6'::UUID, '37138ef2-bc7e-5ead-b5f3-d6d073ddd56d'::UUID, 'd96e512f-b815-5d8c-94c2-b0cc0d4130eb'::UUID, 'fb79a13a-20fd-5e35-958a-0cb1e89c1457'::UUID, 'a956ac17-91a6-533a-85da-6b82377814ca'::UUID, '8df83f4e-195e-5a15-9890-f6d5ccd755d5'::UUID, '094b3137-83b4-5653-b643-9df4eb670a0b'::UUID, '54ca807b-4036-56ad-ba7d-7f7cfc3a9ad9'::UUID, 'b70f395c-dd7d-5abe-bc66-02d4d86b6afd'::UUID, '336234a1-548c-56d3-af6c-e2043edcd816'::UUID, 'a53bc47a-af27-5c8f-b625-3843c1632ee4'::UUID, 'd392318c-62e3-5971-8571-136ed5521e00'::UUID, 'dd4b127b-1529-555c-9a0c-1fbe4e1ee454'::UUID, 'da31112a-5fbf-563d-856d-7adde1dd5e15'::UUID, '889b8a17-17b7-56a8-8289-6c4edb94f12f'::UUID, 'c0af14f6-929b-5664-9055-e1dc4f318d43'::UUID, 'e5ddb7ab-1e6f-501c-85d0-c6535285d4cd'::UUID, 'acb79880-e46f-5227-8d57-3178d08d9e17'::UUID, '5855f63c-0b5b-5da6-863d-9c4ff232c8f4'::UUID, 'a4c5439c-fa13-5625-bd52-30c3ce785f32'::UUID, '44151e7b-b004-5ab6-b680-291180861433'::UUID, '05ce9353-92d7-505d-b62c-d586b1ae2c2a'::UUID, '0458f9e3-0b49-5b32-8cde-b1ebab0e1962'::UUID, 'deb5d41f-b672-52e0-8154-f2317714f6db'::UUID, '94fb092c-5d9b-57d5-a446-b69b7f0d62ff'::UUID, '192ec822-a8ef-580f-99cd-250eb9f0a32a'::UUID, '061d0bb0-e8b7-5534-8806-2184c1bad451'::UUID, 'c4f9092f-3a14-5412-bfdb-783ed1950514'::UUID, 'c0c5bfa5-0ae1-5b2c-aa85-49ae4179b6ca'::UUID, '94454541-c5a5-571e-b717-1bd090957175'::UUID, '83104647-570f-5640-99b2-ea807a1816c7'::UUID, '8c539273-2835-53c2-ad22-1ac29043b91d'::UUID, 'c88fb6de-d610-55b8-8202-518df1a94622'::UUID, 'bd512c07-e13f-5686-98a1-48bd1928aed9'::UUID, '79916d18-321a-5f6b-904f-7da94dbb63ee'::UUID, '57bcc03f-1872-598b-ab12-82368b338325'::UUID, '246a9790-d742-5350-8b9a-90d9f32430da'::UUID, 'fdc5f546-a5e3-5a72-86eb-88feb0e0a4dd'::UUID, '36888100-faa7-5e08-bb15-dd503f8361f6'::UUID, '2da72acf-e452-5e04-aa18-356c88170d02'::UUID, '4d960787-fb61-589d-986c-4551a3021cf3'::UUID, '037b3629-42f3-5ebf-82c1-25f287454b37'::UUID, '6a963960-411a-533a-ad2b-de8fee25e952'::UUID, 'f68c49d0-bab7-5f71-897b-8875e4e0b618'::UUID, 'cb79ad64-8439-5cc0-82d4-56abb5e7dd37'::UUID, 'e45fb5f2-90e6-5896-a130-71581fb5ceca'::UUID, 'c5f6d647-36f5-5328-bc9c-93da6d71a900'::UUID, 'edc1338a-e369-5d5b-8755-65c915cfbd92'::UUID, '25deb3dd-ba1e-5a0c-9365-47c744d77bf5'::UUID, 'a3ce55d4-c99b-5e64-a749-f9bca0604dd5'::UUID, '6acf50b0-b91a-5dde-94f8-13dda189f884'::UUID, '66d1cfdd-a302-5cff-ae0e-321da9ea8d7e'::UUID, '608bc3ad-ce30-55c4-9955-18f5638fab75'::UUID, '2a1f890d-6da1-58b5-9554-283daac56290'::UUID, '61e56c82-ff21-5d91-b275-9dfac08e403a'::UUID, '6e6019d5-32ea-50ac-8377-482e8695f639'::UUID, 'ccea12f5-1ce0-5ce2-9216-dc7aa113ccda'::UUID, '4ddace76-68bf-55e4-8763-c171dd87b164'::UUID, '6664cc51-4817-5232-8905-f1a028a5ee3f'::UUID, '8f6e20c1-1824-5fd0-afeb-cc3b60249181'::UUID, 'cea471c5-a5b1-54a7-bf00-6a90767316ae'::UUID, '31e404a7-9fb3-5a0f-881c-eb88c43f72fe'::UUID, 'f981e82b-6320-5689-b193-7af6a419441c'::UUID, '2a03eea9-513e-570e-b6c2-a4b9212d5597'::UUID, 'd9dcd423-6c82-5b6b-ae7c-8a1c470b53b7'::UUID, 'fdbe4660-6af2-5931-90a8-5e7332b83d18'::UUID, 'f80ec44b-0936-5241-9059-c7f71ab265ca'::UUID, '3a36cf1f-391e-5ace-bb90-f66f1f6384f9'::UUID, '6f7cf582-e3e7-5e30-beb3-2a4c77a33b96'::UUID, 'ecf947e1-200b-57e6-9011-cedef5649d2f'::UUID, '0fe43644-2d01-5248-bb8a-569c518c2547'::UUID, '4f33d6d0-b931-51e5-a8c1-4849865b44fc'::UUID, 'ed0a3f7e-52a4-5c7d-b114-dbe3a1aa0b1c'::UUID, '04aa609e-c273-5fc4-a32b-dce11450c697'::UUID, '7984d2ec-3c83-56f2-a534-b9b63ae6e51c'::UUID, '00b7b370-2630-527d-9375-a30dc2d4b2ff'::UUID, '0edf99b8-b034-5a25-bb7e-2990f49ba63b'::UUID, 'd767209a-2666-5319-a912-ce0c4d4875c2'::UUID, '806f07ed-85f6-5959-a188-5d7d383f4643'::UUID, 'ee409ccc-9d2f-55ea-b130-2d50eaa22dcd'::UUID, '9f020b67-afc8-5828-97eb-da2179322460'::UUID, 'f55cbd2f-ae14-537d-a294-dc4f0a054855'::UUID, 'ec1c2266-a40b-5ade-a0c3-a1cbb14abcaa'::UUID, 'e683aae7-b3dd-5334-8068-7f49f44f2ea3'::UUID, '2a1e9900-a1c2-5e38-a768-6409b5f0dea7'::UUID, '2a786106-5fa3-5db8-a13f-2af9495b3de4'::UUID, 'c7aaa938-b471-5014-8761-e23a866fe241'::UUID, '30005f55-73ff-5e20-98f3-aaabcb2bd9b1'::UUID, '796872a5-72ee-5064-89f2-e5280682e181'::UUID, '59f09415-5c56-5f51-851a-0ae73b23a3a1'::UUID, '930370dc-3314-5940-8a1b-610bb01e9aff'::UUID, 'dc507870-05d1-5cfd-af54-a1d72bd60062'::UUID, 'df15d433-71fa-5357-ac1a-7bd23fbde063'::UUID, '1403b981-ec88-5f27-9bf3-ced46120d19e'::UUID, 'f5442283-bdf5-5ec0-9be9-6eba433ccec6'::UUID, 'da985efc-07cb-51d1-b9a6-64bd90453f52'::UUID, '3d4cc3cf-c31e-567a-b59e-9f8c7523e74a'::UUID, '8afdd320-57c7-5c7c-8281-36f6e7ae0273'::UUID, 'f0e71811-f93a-50e0-b49d-789d5bdf72bd'::UUID, '27c63919-e5c7-5799-84fa-7618a4e2f559'::UUID, '4279317b-7eed-5705-bb16-a04649a14943'::UUID, '57caa387-e1c0-57bd-8d2d-e128915c907d'::UUID, 'c468b8b1-68b2-55ac-8a0d-1f3e417299bd'::UUID, '964cccc4-ac46-5b83-b07b-5ae925fccb49'::UUID, '722ad7e2-7e4b-5f15-8144-59c8207331a5'::UUID, 'e4cc33b7-8cb7-533f-99f4-6662342e759a'::UUID, '6dae727c-ecd7-5fff-89b3-b115762446e3'::UUID, '15f3bea2-c69b-52e8-a143-2a1e53dc143d'::UUID, '5d1e3b33-ee88-54fd-96f8-01674319b434'::UUID, 'f18a6e2d-1c5f-5426-aae2-2c7532ae1736'::UUID, 'b8a0a413-a098-58f6-a1a0-54ed9c99bd38'::UUID, 'bf265c1b-088f-5360-9c82-0d6669209ec4'::UUID, 'ac2ef0a2-6a7f-5369-84f8-aeba93795e2d'::UUID, 'd5c33780-29e8-55c4-b54f-188fdac86538'::UUID, 'de255b18-f99c-5d5b-b901-31a6937035fc'::UUID, '58528731-61b5-59cd-b4f1-39e41e8265c9'::UUID, 'ab4cc15c-729d-57cd-893c-a6a765853d55'::UUID, '1f353c15-1a50-591f-b8e0-71419afb9462'::UUID, 'c964b943-9345-552c-b722-c0bfbc327bab'::UUID, 'fa34ceb7-4604-5971-9267-bcc8da74ba83'::UUID, '539907bc-4c6c-5605-ac0b-b477c559c0b9'::UUID, 'd47ee627-0ba6-582d-bd87-ead39773bbf3'::UUID, '822a5c43-e5f8-594b-88bc-a1d1f0550d95'::UUID, 'd29af9e2-50a5-5ddb-8ff3-1dccea483b79'::UUID, '150dea4c-cb96-5ff7-b60c-6c99dfd75d47'::UUID, '7d971daa-ed2e-5534-9e59-8a581eed3c6e'::UUID, 'bcf54380-1ad4-51fa-a7da-65e86c594cfb'::UUID, 'c6ebe5b1-9c57-5922-9276-da2afe4a4e10'::UUID, 'c78f12c8-05e2-5f0f-a7fa-d51088dd89b0'::UUID]::UUID[])) <> 161 THEN
    RAISE EXCEPTION 'Content batch batch-01-foundation-pronunciation is missing managed exercises rows';
  END IF;
  IF (SELECT COUNT(*) FROM public.exercise_options WHERE id = ANY(ARRAY['48f633ec-8940-5b7b-b004-01c3108ec393'::UUID, '13f69498-e64a-5041-a374-4b210643975e'::UUID, '7ca89710-9f13-5c89-a28a-4d55428b02fe'::UUID, '973a4910-1a66-56e8-b921-d4c13f760800'::UUID, '42a6aea8-07b3-57f1-8049-4406f712b7f9'::UUID, '1a984081-6dfb-58f2-ad79-305e4f3c9ad3'::UUID, '1bc392c0-ca3f-5e2c-bd89-5218150ae707'::UUID, '96aa9dcc-ea57-5484-982f-914f12b50b92'::UUID, '397f9e69-1db3-5163-b267-36c5a2be6790'::UUID, '197f68fb-6309-57e3-94e7-6e1a758b26c6'::UUID, '9fe99c65-df10-5ba2-991f-c8e8faeff8d3'::UUID, '3604701c-5419-5908-a127-f38ccc1bb2b2'::UUID, 'd6b4b574-9aba-5bb9-85d6-baf4a18b9276'::UUID, '59eea7aa-0264-5f2d-b565-b5ff7f32c1b5'::UUID, '3ffd9cae-db15-5d33-8ac6-9dcc983afad3'::UUID, '0e5ab853-a5aa-5f39-9483-dc4e7d6521e7'::UUID, '79c5364d-0afb-5cd8-8282-92f2c3ef867a'::UUID, '077d3fe7-f200-5fa8-8ae0-e49199a31179'::UUID, '7ca22576-1e85-541e-8d44-7f9dae8f3b8e'::UUID, 'bb2c0424-4351-52e7-8522-2b3fdbaa72ae'::UUID, 'ec26fedd-f089-5682-a835-7ba91b73d60d'::UUID, '311bea29-2093-52fc-985d-3a329b025443'::UUID, '9750d3b0-b623-581e-a9ac-178e7a04767a'::UUID, 'c853e12e-753b-5885-a248-3c0d4be3ead9'::UUID, '5d93e486-a982-597c-a5b2-dd0912d1c504'::UUID, '28af190e-792c-55c5-99a7-6289815a7c7d'::UUID, 'a630f1a9-66a5-5b2e-93e8-97d373013f0a'::UUID, 'df6880d1-3400-5986-a450-0122bb97b16c'::UUID, 'ba61e6e0-1dac-5b44-8a88-eb84cdc0e403'::UUID, '9601086d-2342-5319-b3b5-622ecdfa1686'::UUID, '01e00bd8-9aaa-5345-a387-1fb737d4ec52'::UUID, 'b53358d4-46b4-5db2-8b9c-9b8c6cb83ea9'::UUID, 'efa60f29-3da9-5a32-823e-dd79a02b16c4'::UUID, 'cb785f88-dd00-5ba5-a16b-d8deea51c128'::UUID, 'cc8907c2-c7b6-50f1-b749-8388ccda744e'::UUID, '815bbbb1-e90d-5bec-b1fb-6bc53534197e'::UUID, '6ae5ef1e-d002-5974-a0db-b85187b7d708'::UUID, 'dd421918-24b0-5e37-8158-a8b2f444866d'::UUID, '67111c10-a468-54c7-b982-be4655bbaefc'::UUID, '72fdd626-83fd-50fd-9ffc-d3db839bff18'::UUID, 'bd069e8a-b3a9-5290-84ce-b27f644a4c72'::UUID, 'd6202801-0ffd-57c2-9965-575ab6dfe20d'::UUID, 'f5d5a96c-d6fa-5ea6-a451-25b522d115c8'::UUID, '5acd64b5-f2d4-529f-9c97-5007ad595655'::UUID, '22139d68-4d7b-5444-a1e4-29d764866536'::UUID, '0df740b9-55cb-512e-8781-bcac3afdbe98'::UUID, '3b7813c1-aa17-5b51-b725-e39ab6f1b4f3'::UUID, '0a8ae48f-2365-5af7-a42a-1bbd8103cef9'::UUID, '384293ce-2e38-53d5-bbaa-bdf66ec1b270'::UUID, 'daf0ca1a-8258-593e-ad87-9e9a624c14eb'::UUID, 'c944cc00-6316-5c6d-b95f-011d4a96aa75'::UUID, 'd94f3530-880a-5995-9779-e131a484e77a'::UUID, '82a06769-5747-54de-954a-76ecb8c3f26e'::UUID, '15f9a47a-cdd6-55f7-ac5a-77358a4b2f40'::UUID, 'ca476fcb-e233-5640-a290-b9c19c4fe9e8'::UUID, 'ee8eb474-9964-57ab-ac01-e8cd16a00235'::UUID, 'bc18efc4-c0ca-5733-a7de-307b265c40c5'::UUID, 'f84f5e1b-cf65-53da-b146-535189db54e4'::UUID, '25a38c9a-76e1-530b-a690-7277370fc2cd'::UUID, 'f30a6162-15ec-55ec-bd0c-892fea925410'::UUID, '54fa7ebd-a1ab-56a8-8b7e-6e5d97e963ff'::UUID, '441d4e74-10a7-570b-ac24-c286a941591d'::UUID, '4601601f-b399-55a3-90ad-ee4b3d04d3fd'::UUID, 'a178c00b-6fa4-5074-8410-cccbd2b1ad78'::UUID, '4b2b1bd4-b9f9-519d-ae84-4d5af1f9d9c8'::UUID, 'fa172262-0051-5baf-8b8a-154c21c27406'::UUID, '972f8c92-601b-5d4e-8351-b1e54f1cbcf9'::UUID, '98ae04c4-9c33-5a30-9f61-62f6eecb07d1'::UUID, 'c07f5813-9bde-5103-bb0f-bff2e1f737c5'::UUID, '1bd0bbb4-1ae8-5d83-88e4-77289af4b333'::UUID, 'aae6c6dc-82af-5f08-8dfa-f4b1b3e44fc7'::UUID, 'eaa7d7a7-7c1a-544e-b3f3-6e58d1b8a25e'::UUID, '3bdb5522-043c-51b6-a152-33828cc992ac'::UUID, 'faff40ca-04ac-5cc4-95d7-de8b9e92f96e'::UUID, '9b21c736-c092-51f0-a899-886e0e51b051'::UUID, 'a3bbc443-0422-563c-bf23-8c7962efb5bd'::UUID, '95846c4c-15c0-5591-aac1-cb20f57dd4d6'::UUID, 'cf9851ab-fcc8-545b-8bdc-1fde7b3de09c'::UUID, 'c06e3aff-d182-557a-a83b-cfc9c978d80f'::UUID, '05774925-af25-50d3-937d-a4ab082b3b6c'::UUID, '529ce0a5-f202-59a8-ae86-b25677ca49f0'::UUID, '0dbe5d82-56b2-5330-aa0d-cce1622592f6'::UUID, 'ed7a6798-a5fb-5e7b-ba3f-045594f8f5cb'::UUID, '0f57bc98-0577-52b1-a8b1-22a4034a36f7'::UUID, '9cc95da5-e791-50a6-8178-ba2f70ed2cf7'::UUID, 'bf97f9c8-1763-5ded-92d0-03c4592e5446'::UUID, 'f473f035-4bfb-56db-a619-53c3ef1db0e3'::UUID, 'b72e33dd-33e5-5526-903a-63b7b3a14867'::UUID, '6b9ef39b-09b9-580f-a656-6d35b6c00ca1'::UUID, 'b3f6d443-67f2-5d1c-9723-628cddf7bb68'::UUID, '038e088c-1e7c-5c45-b0bd-8a7f93e1dfab'::UUID, '7658fcbb-2f8e-537b-93f7-cb9bfdc8dec2'::UUID, '05bebff5-418f-5e7c-99ca-f2487bb9545e'::UUID, '4e14b566-3069-5e37-90f1-5555ec64d778'::UUID, 'cd8c4142-6a22-5e04-af41-f8450f034e03'::UUID, '950be2ef-efb0-5470-a6f1-b77a68080922'::UUID, 'b7fa2c46-1573-5de6-a9bd-8b1d4e352ff2'::UUID, '11ce5f50-b551-5d99-99ff-ea9f7d8722b9'::UUID, '9138f740-9500-5625-bc47-e504131c2fd1'::UUID, '5ee9d882-c3c1-5ab7-87e7-0856a1162a14'::UUID, '0c3e75ae-a5f3-5f34-8e6c-418a60cbba97'::UUID, 'edaf55ef-afb3-50d9-ad1a-3ced5d1ba9b5'::UUID, '869ed964-ca1f-5577-a7ba-4eab11436f73'::UUID, '6ad584d0-f27a-58c4-bec7-471de28ab7ac'::UUID, '8601e692-1540-5616-a78b-b11013508732'::UUID, '725b5fac-14c2-555d-a8a8-d6166f8719b0'::UUID, 'e0679591-ce86-540d-b131-31966ce96f36'::UUID, 'c04a6336-5fec-5b3c-bec4-13ff64b392c3'::UUID, 'f27a460f-d9f2-581e-986d-a3c821e35225'::UUID, '3c36dbd4-da00-578e-bfc9-0586cdfe11a5'::UUID, 'feca4495-6133-5f37-b319-557798132ced'::UUID, 'fc1ac373-794d-5f26-9562-e27264de1af2'::UUID, 'b642e17d-5dcc-509b-bf30-ef13a6be47c9'::UUID, 'efd7230c-6cd9-53fb-9080-56d2929b4389'::UUID, 'e0b5e902-0a7c-5230-b082-62a1014e6a94'::UUID, 'f9956922-736e-5218-a17b-5996169a1f6e'::UUID, '2b7ea7e6-ff56-5719-b331-a5da8f28795a'::UUID, '8f1ed645-52d9-532f-abf7-d6df4794ea07'::UUID, 'ccd8b3c8-0093-5528-90b4-02ec14645d59'::UUID, '75ef038d-22bb-5822-97f5-233db5688fc2'::UUID]::UUID[])) <> 120 THEN
    RAISE EXCEPTION 'Content batch batch-01-foundation-pronunciation is missing managed exercise_options rows';
  END IF;
  IF EXISTS (
    SELECT 1 FROM public.lessons AS lesson
    WHERE lesson.id = ANY(ARRAY['10000000-0000-0000-0000-000000000001'::UUID, '10000000-0000-0000-0000-000000000002'::UUID, '10000000-0000-0000-0000-000000000003'::UUID, '10000000-0000-0000-0000-000000000004'::UUID, '10000000-0000-0000-0000-000000000005'::UUID, '17dd9d54-3f33-51c0-8492-84b7a4962632'::UUID, 'e5a77950-bd6d-5080-8434-b7ec4b17e279'::UUID, 'a31244dd-d46d-5763-821c-909302dcf743'::UUID, 'e86c4323-6319-5c95-bc71-d6fe6c98e3be'::UUID, '0c573448-400a-5235-9bd7-629c7480b6ee'::UUID, '30c43e9c-4198-5b27-97b6-3ae4227fa545'::UUID, '4c9084f4-7c21-52fb-b1c5-e88cf5c19ba3'::UUID, 'c44683a2-76ec-52f4-8a2c-192346300aa4'::UUID, '1ca62a8a-98d3-5fa5-bf21-00e62d72c93c'::UUID, '954f9f30-034a-502e-8703-555242f1aff3'::UUID, '6752bea1-bb65-5742-90ba-ac7b74d32362'::UUID, 'c9c113ff-9bd7-5684-b48b-046e0681b831'::UUID]::UUID[])
      AND NOT EXISTS (
        SELECT 1 FROM public.exercises AS exercise
        WHERE exercise.lesson_id = lesson.id
      )
  ) THEN
    RAISE EXCEPTION 'Content batch batch-01-foundation-pronunciation contains a lesson without exercises';
  END IF;
  IF EXISTS (
    SELECT 1
    FROM public.lessons AS lesson
    JOIN public.exercises AS exercise ON exercise.lesson_id = lesson.id
    WHERE lesson.id = ANY(ARRAY['10000000-0000-0000-0000-000000000001'::UUID, '10000000-0000-0000-0000-000000000002'::UUID, '10000000-0000-0000-0000-000000000003'::UUID, '10000000-0000-0000-0000-000000000004'::UUID, '10000000-0000-0000-0000-000000000005'::UUID, '17dd9d54-3f33-51c0-8492-84b7a4962632'::UUID, 'e5a77950-bd6d-5080-8434-b7ec4b17e279'::UUID, 'a31244dd-d46d-5763-821c-909302dcf743'::UUID, 'e86c4323-6319-5c95-bc71-d6fe6c98e3be'::UUID, '0c573448-400a-5235-9bd7-629c7480b6ee'::UUID, '30c43e9c-4198-5b27-97b6-3ae4227fa545'::UUID, '4c9084f4-7c21-52fb-b1c5-e88cf5c19ba3'::UUID, 'c44683a2-76ec-52f4-8a2c-192346300aa4'::UUID, '1ca62a8a-98d3-5fa5-bf21-00e62d72c93c'::UUID, '954f9f30-034a-502e-8703-555242f1aff3'::UUID, '6752bea1-bb65-5742-90ba-ac7b74d32362'::UUID, 'c9c113ff-9bd7-5684-b48b-046e0681b831'::UUID]::UUID[])
      AND lesson.status = 'published'
      AND exercise.exercise_type = 'listening'
      AND NULLIF(BTRIM(exercise.question_audio_url), '') IS NULL
  ) THEN
    RAISE EXCEPTION 'Published listening exercise is missing playable audio';
  END IF;
  IF EXISTS (
    SELECT 1
    FROM public.exercises AS exercise
    WHERE exercise.id = ANY(ARRAY['d0258bd8-45bb-5e16-90f1-57b290b249c4'::UUID, '5e2b863c-2323-529f-a636-020c99fcb7d6'::UUID, '0fadf4a5-1507-5974-bf65-f0c84831321a'::UUID, 'b38bebfa-65ef-538d-a739-de3aa2618ad0'::UUID, 'b9ebf219-5402-5696-988b-33e7ff235fb2'::UUID, 'b8a3ae38-0643-5116-b3be-7f0575a17069'::UUID, 'a8668f83-9762-55f1-9fd0-179d2af50092'::UUID, 'b2a48976-6f54-53ae-b136-17ac22a8d3c7'::UUID, '874552a5-ad5d-5193-abd7-6cf5bb32a5fa'::UUID, '6c69a6d3-084a-5c1e-bfe2-6f1474b4e70a'::UUID, '376e78a1-1a6b-50e5-9fda-8e0581ea9216'::UUID, '55216da1-1994-5bc6-8bfb-360ec1f29c3c'::UUID, '566fe4f0-e69f-50e2-9f38-7e482bbd61e5'::UUID, '0994dc28-f663-5264-94ee-9cc0a4cffbd4'::UUID, '0cda4f86-1a08-5bfc-a01c-28cce9ec9abc'::UUID, 'de6e0996-e9c9-5446-8cb1-60440a277716'::UUID, '3657ef54-cd96-53d9-be50-424b89595230'::UUID, '62bdf135-dd22-5a72-9603-85d86397a831'::UUID, 'cbfad24b-dc5f-5740-96f6-968e3f703229'::UUID, 'bd82d061-0c0f-53aa-a0fc-043f3aa3dbc8'::UUID, '4a5b9252-db42-597b-a9cc-aa6d62b95859'::UUID, '2d570e55-c161-5c4c-ac09-de92703292c7'::UUID, '972c0879-bc25-594d-8e6a-cdb9cda7d332'::UUID, 'd309ff29-776b-57c7-a521-8e875cec5080'::UUID, '84f08efc-129e-5d68-8273-f9362e241c94'::UUID, '5d697f84-6f32-5760-8cf4-2f60a460d3eb'::UUID, '37a2a44a-382e-56ee-a5b8-d857a3b03fc9'::UUID, '7c96bdfc-32e1-589e-ab32-e139ec43fb5e'::UUID, '26660975-6f93-5e51-b983-5edaece0bf13'::UUID, '99c81f1c-bced-566a-b49d-e7e1a89a1fce'::UUID, 'bdc30f54-b7be-56d8-9ede-9a19d60a0df8'::UUID, '7feade02-b049-53a7-a97f-3a7aaf87af88'::UUID, '3b91ae32-be96-5080-8a8f-aec7e17141b6'::UUID, '37138ef2-bc7e-5ead-b5f3-d6d073ddd56d'::UUID, 'd96e512f-b815-5d8c-94c2-b0cc0d4130eb'::UUID, 'fb79a13a-20fd-5e35-958a-0cb1e89c1457'::UUID, 'a956ac17-91a6-533a-85da-6b82377814ca'::UUID, '8df83f4e-195e-5a15-9890-f6d5ccd755d5'::UUID, '094b3137-83b4-5653-b643-9df4eb670a0b'::UUID, '54ca807b-4036-56ad-ba7d-7f7cfc3a9ad9'::UUID, 'b70f395c-dd7d-5abe-bc66-02d4d86b6afd'::UUID, '336234a1-548c-56d3-af6c-e2043edcd816'::UUID, 'a53bc47a-af27-5c8f-b625-3843c1632ee4'::UUID, 'd392318c-62e3-5971-8571-136ed5521e00'::UUID, 'dd4b127b-1529-555c-9a0c-1fbe4e1ee454'::UUID, 'da31112a-5fbf-563d-856d-7adde1dd5e15'::UUID, '889b8a17-17b7-56a8-8289-6c4edb94f12f'::UUID, 'c0af14f6-929b-5664-9055-e1dc4f318d43'::UUID, 'e5ddb7ab-1e6f-501c-85d0-c6535285d4cd'::UUID, 'acb79880-e46f-5227-8d57-3178d08d9e17'::UUID, '5855f63c-0b5b-5da6-863d-9c4ff232c8f4'::UUID, 'a4c5439c-fa13-5625-bd52-30c3ce785f32'::UUID, '44151e7b-b004-5ab6-b680-291180861433'::UUID, '05ce9353-92d7-505d-b62c-d586b1ae2c2a'::UUID, '0458f9e3-0b49-5b32-8cde-b1ebab0e1962'::UUID, 'deb5d41f-b672-52e0-8154-f2317714f6db'::UUID, '94fb092c-5d9b-57d5-a446-b69b7f0d62ff'::UUID, '192ec822-a8ef-580f-99cd-250eb9f0a32a'::UUID, '061d0bb0-e8b7-5534-8806-2184c1bad451'::UUID, 'c4f9092f-3a14-5412-bfdb-783ed1950514'::UUID, 'c0c5bfa5-0ae1-5b2c-aa85-49ae4179b6ca'::UUID, '94454541-c5a5-571e-b717-1bd090957175'::UUID, '83104647-570f-5640-99b2-ea807a1816c7'::UUID, '8c539273-2835-53c2-ad22-1ac29043b91d'::UUID, 'c88fb6de-d610-55b8-8202-518df1a94622'::UUID, 'bd512c07-e13f-5686-98a1-48bd1928aed9'::UUID, '79916d18-321a-5f6b-904f-7da94dbb63ee'::UUID, '57bcc03f-1872-598b-ab12-82368b338325'::UUID, '246a9790-d742-5350-8b9a-90d9f32430da'::UUID, 'fdc5f546-a5e3-5a72-86eb-88feb0e0a4dd'::UUID, '36888100-faa7-5e08-bb15-dd503f8361f6'::UUID, '2da72acf-e452-5e04-aa18-356c88170d02'::UUID, '4d960787-fb61-589d-986c-4551a3021cf3'::UUID, '037b3629-42f3-5ebf-82c1-25f287454b37'::UUID, '6a963960-411a-533a-ad2b-de8fee25e952'::UUID, 'f68c49d0-bab7-5f71-897b-8875e4e0b618'::UUID, 'cb79ad64-8439-5cc0-82d4-56abb5e7dd37'::UUID, 'e45fb5f2-90e6-5896-a130-71581fb5ceca'::UUID, 'c5f6d647-36f5-5328-bc9c-93da6d71a900'::UUID, 'edc1338a-e369-5d5b-8755-65c915cfbd92'::UUID, '25deb3dd-ba1e-5a0c-9365-47c744d77bf5'::UUID, 'a3ce55d4-c99b-5e64-a749-f9bca0604dd5'::UUID, '6acf50b0-b91a-5dde-94f8-13dda189f884'::UUID, '66d1cfdd-a302-5cff-ae0e-321da9ea8d7e'::UUID, '608bc3ad-ce30-55c4-9955-18f5638fab75'::UUID, '2a1f890d-6da1-58b5-9554-283daac56290'::UUID, '61e56c82-ff21-5d91-b275-9dfac08e403a'::UUID, '6e6019d5-32ea-50ac-8377-482e8695f639'::UUID, 'ccea12f5-1ce0-5ce2-9216-dc7aa113ccda'::UUID, '4ddace76-68bf-55e4-8763-c171dd87b164'::UUID, '6664cc51-4817-5232-8905-f1a028a5ee3f'::UUID, '8f6e20c1-1824-5fd0-afeb-cc3b60249181'::UUID, 'cea471c5-a5b1-54a7-bf00-6a90767316ae'::UUID, '31e404a7-9fb3-5a0f-881c-eb88c43f72fe'::UUID, 'f981e82b-6320-5689-b193-7af6a419441c'::UUID, '2a03eea9-513e-570e-b6c2-a4b9212d5597'::UUID, 'd9dcd423-6c82-5b6b-ae7c-8a1c470b53b7'::UUID, 'fdbe4660-6af2-5931-90a8-5e7332b83d18'::UUID, 'f80ec44b-0936-5241-9059-c7f71ab265ca'::UUID, '3a36cf1f-391e-5ace-bb90-f66f1f6384f9'::UUID, '6f7cf582-e3e7-5e30-beb3-2a4c77a33b96'::UUID, 'ecf947e1-200b-57e6-9011-cedef5649d2f'::UUID, '0fe43644-2d01-5248-bb8a-569c518c2547'::UUID, '4f33d6d0-b931-51e5-a8c1-4849865b44fc'::UUID, 'ed0a3f7e-52a4-5c7d-b114-dbe3a1aa0b1c'::UUID, '04aa609e-c273-5fc4-a32b-dce11450c697'::UUID, '7984d2ec-3c83-56f2-a534-b9b63ae6e51c'::UUID, '00b7b370-2630-527d-9375-a30dc2d4b2ff'::UUID, '0edf99b8-b034-5a25-bb7e-2990f49ba63b'::UUID, 'd767209a-2666-5319-a912-ce0c4d4875c2'::UUID, '806f07ed-85f6-5959-a188-5d7d383f4643'::UUID, 'ee409ccc-9d2f-55ea-b130-2d50eaa22dcd'::UUID, '9f020b67-afc8-5828-97eb-da2179322460'::UUID, 'f55cbd2f-ae14-537d-a294-dc4f0a054855'::UUID, 'ec1c2266-a40b-5ade-a0c3-a1cbb14abcaa'::UUID, 'e683aae7-b3dd-5334-8068-7f49f44f2ea3'::UUID, '2a1e9900-a1c2-5e38-a768-6409b5f0dea7'::UUID, '2a786106-5fa3-5db8-a13f-2af9495b3de4'::UUID, 'c7aaa938-b471-5014-8761-e23a866fe241'::UUID, '30005f55-73ff-5e20-98f3-aaabcb2bd9b1'::UUID, '796872a5-72ee-5064-89f2-e5280682e181'::UUID, '59f09415-5c56-5f51-851a-0ae73b23a3a1'::UUID, '930370dc-3314-5940-8a1b-610bb01e9aff'::UUID, 'dc507870-05d1-5cfd-af54-a1d72bd60062'::UUID, 'df15d433-71fa-5357-ac1a-7bd23fbde063'::UUID, '1403b981-ec88-5f27-9bf3-ced46120d19e'::UUID, 'f5442283-bdf5-5ec0-9be9-6eba433ccec6'::UUID, 'da985efc-07cb-51d1-b9a6-64bd90453f52'::UUID, '3d4cc3cf-c31e-567a-b59e-9f8c7523e74a'::UUID, '8afdd320-57c7-5c7c-8281-36f6e7ae0273'::UUID, 'f0e71811-f93a-50e0-b49d-789d5bdf72bd'::UUID, '27c63919-e5c7-5799-84fa-7618a4e2f559'::UUID, '4279317b-7eed-5705-bb16-a04649a14943'::UUID, '57caa387-e1c0-57bd-8d2d-e128915c907d'::UUID, 'c468b8b1-68b2-55ac-8a0d-1f3e417299bd'::UUID, '964cccc4-ac46-5b83-b07b-5ae925fccb49'::UUID, '722ad7e2-7e4b-5f15-8144-59c8207331a5'::UUID, 'e4cc33b7-8cb7-533f-99f4-6662342e759a'::UUID, '6dae727c-ecd7-5fff-89b3-b115762446e3'::UUID, '15f3bea2-c69b-52e8-a143-2a1e53dc143d'::UUID, '5d1e3b33-ee88-54fd-96f8-01674319b434'::UUID, 'f18a6e2d-1c5f-5426-aae2-2c7532ae1736'::UUID, 'b8a0a413-a098-58f6-a1a0-54ed9c99bd38'::UUID, 'bf265c1b-088f-5360-9c82-0d6669209ec4'::UUID, 'ac2ef0a2-6a7f-5369-84f8-aeba93795e2d'::UUID, 'd5c33780-29e8-55c4-b54f-188fdac86538'::UUID, 'de255b18-f99c-5d5b-b901-31a6937035fc'::UUID, '58528731-61b5-59cd-b4f1-39e41e8265c9'::UUID, 'ab4cc15c-729d-57cd-893c-a6a765853d55'::UUID, '1f353c15-1a50-591f-b8e0-71419afb9462'::UUID, 'c964b943-9345-552c-b722-c0bfbc327bab'::UUID, 'fa34ceb7-4604-5971-9267-bcc8da74ba83'::UUID, '539907bc-4c6c-5605-ac0b-b477c559c0b9'::UUID, 'd47ee627-0ba6-582d-bd87-ead39773bbf3'::UUID, '822a5c43-e5f8-594b-88bc-a1d1f0550d95'::UUID, 'd29af9e2-50a5-5ddb-8ff3-1dccea483b79'::UUID, '150dea4c-cb96-5ff7-b60c-6c99dfd75d47'::UUID, '7d971daa-ed2e-5534-9e59-8a581eed3c6e'::UUID, 'bcf54380-1ad4-51fa-a7da-65e86c594cfb'::UUID, 'c6ebe5b1-9c57-5922-9276-da2afe4a4e10'::UUID, 'c78f12c8-05e2-5f0f-a7fa-d51088dd89b0'::UUID]::UUID[])
      AND exercise.exercise_type IN ('multiple_choice', 'listening')
      AND (
        SELECT COUNT(*) FILTER (WHERE option.is_correct)
        FROM public.exercise_options AS option
        WHERE option.exercise_id = exercise.id
      ) <> 1
  ) THEN
    RAISE EXCEPTION 'Choice exercise must have exactly one correct option';
  END IF;
  IF EXISTS (
    SELECT 1
    FROM public.lesson_vocabulary AS link
    JOIN public.vocabulary AS vocabulary ON vocabulary.id = link.vocabulary_id
    WHERE link.lesson_id = ANY(ARRAY['10000000-0000-0000-0000-000000000001'::UUID, '10000000-0000-0000-0000-000000000002'::UUID, '10000000-0000-0000-0000-000000000003'::UUID, '10000000-0000-0000-0000-000000000004'::UUID, '10000000-0000-0000-0000-000000000005'::UUID, '17dd9d54-3f33-51c0-8492-84b7a4962632'::UUID, 'e5a77950-bd6d-5080-8434-b7ec4b17e279'::UUID, 'a31244dd-d46d-5763-821c-909302dcf743'::UUID, 'e86c4323-6319-5c95-bc71-d6fe6c98e3be'::UUID, '0c573448-400a-5235-9bd7-629c7480b6ee'::UUID, '30c43e9c-4198-5b27-97b6-3ae4227fa545'::UUID, '4c9084f4-7c21-52fb-b1c5-e88cf5c19ba3'::UUID, 'c44683a2-76ec-52f4-8a2c-192346300aa4'::UUID, '1ca62a8a-98d3-5fa5-bf21-00e62d72c93c'::UUID, '954f9f30-034a-502e-8703-555242f1aff3'::UUID, '6752bea1-bb65-5742-90ba-ac7b74d32362'::UUID, 'c9c113ff-9bd7-5684-b48b-046e0681b831'::UUID]::UUID[])
      AND (
        NULLIF(BTRIM(vocabulary.pinyin), '') IS NULL
        OR NULLIF(BTRIM(vocabulary.meaning_vi), '') IS NULL
        OR NULLIF(BTRIM(vocabulary.part_of_speech), '') IS NULL
        OR NULLIF(BTRIM(vocabulary.example_sentence), '') IS NULL
        OR NULLIF(BTRIM(vocabulary.example_pinyin), '') IS NULL
        OR NULLIF(BTRIM(vocabulary.example_meaning), '') IS NULL
      )
  ) THEN
    RAISE EXCEPTION 'Managed lesson vocabulary is incomplete';
  END IF;
END
$content_validation$;

COMMIT;
