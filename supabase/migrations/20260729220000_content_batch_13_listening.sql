-- Generated from content/manifests/13_listening.json.
-- Do not hand-edit this migration; edit the manifest and regenerate.
-- Additive and idempotent: deterministic IDs plus ON CONFLICT DO NOTHING.

BEGIN;

INSERT INTO public.courses (id, slug, title, title_zh, description, level, status, order_index, learning_objectives, estimated_minutes, content_version)
VALUES ('878562b7-5609-5d4b-b06c-68a4e4b747b2'::UUID, 'chinese-listening-practice', 'Chinese Listening Practice', '汉语听力训练', 'Chiến lược nghe hiểu; bài nghe thật chờ tài sản âm thanh được duyệt.', 'elementary', 'review', 12, '["Nghe từ khóa và số liệu","Theo dõi ý chính","Suy luận thái độ từ ngữ cảnh"]'::JSONB, 78, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.units (id, course_id, slug, title, description, order_index, status, learning_objectives, content_version)
VALUES ('c7b26d25-b0b9-5bd8-af8f-9bb9b25a02ec'::UUID, '878562b7-5609-5d4b-b06c-68a4e4b747b2'::UUID, 'listening-nen-tang', 'Nền tảng', 'Xây dựng ngôn ngữ cốt lõi của lộ trình.', 1, 'review', '["Nghe từ khóa và số liệu","Theo dõi ý chính"]'::JSONB, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.chapters (id, unit_id, slug, title, description, order_index, status, learning_objectives, content_version)
VALUES ('edd79ee3-e566-5b37-ab5f-071dad309658'::UUID, 'c7b26d25-b0b9-5bd8-af8f-9bb9b25a02ec'::UUID, 'listening-nen-tang-chapter', 'Khái niệm cốt lõi', 'Xây dựng ngôn ngữ cốt lõi của lộ trình.', 1, 'review', '["Nghe từ khóa và số liệu","Theo dõi ý chính"]'::JSONB, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lessons (id, chapter_id, slug, title, description, order_index, xp_reward, status, lesson_type, estimated_minutes, learning_objectives, cultural_note, content_version)
VALUES ('8817f87c-9ee1-5fbd-8a5e-eee67c1f8932'::UUID, 'edd79ee3-e566-5b37-ab5f-071dad309658'::UUID, 'tu-khoa', '抓住关键词 — Từ khóa', 'Xác định từ mang thông tin chính.', 1, 25, 'review', 'standard', 15, '["Nghe và ghi lại từ khóa"]'::JSONB, 'Khóa chưa xuất bản bài listening cho đến khi có audio thật.', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('ad88cae0-45c5-50aa-b861-be3954202db7'::UUID, 'listening:关键词', '关键词', 'guānjiàncí', 'từ khóa', 'keyword', 'elementary', 'tu-khoa', 'danh từ', '先找出对话里的关键词。', 'Xiān zhǎochū duìhuà lǐ de guānjiàncí.', 'Trước tiên tìm từ khóa trong hội thoại.', NULL, 'review', '8817f87c-9ee1-5fbd-8a5e-eee67c1f8932'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('1af742be-19bf-5e06-9725-b57ea783a319'::UUID, '8817f87c-9ee1-5fbd-8a5e-eee67c1f8932'::UUID, 'ad88cae0-45c5-50aa-b861-be3954202db7'::UUID, 1, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('0c1e3514-9447-58d2-b018-7ff1eed82517'::UUID, 'listening:重点', '重点', 'zhòngdiǎn', 'trọng điểm', 'key point', 'elementary', 'tu-khoa', 'danh từ', '老师重复了今天的重点。', 'Lǎoshī chóngfù le jīntiān de zhòngdiǎn.', 'Giáo viên lặp lại trọng điểm hôm nay.', NULL, 'review', '8817f87c-9ee1-5fbd-8a5e-eee67c1f8932'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('a25bfb4b-0049-5156-aaf1-4a1cbcdb5d4d'::UUID, '8817f87c-9ee1-5fbd-8a5e-eee67c1f8932'::UUID, '0c1e3514-9447-58d2-b018-7ff1eed82517'::UUID, 2, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('ba89f0a3-e149-5e7e-a4ce-08f7eacf6b0d'::UUID, 'listening:记录', '记录', 'jìlù', 'ghi chép', 'record', 'elementary', 'tu-khoa', 'động từ/danh từ', '听的时候记录时间和地点。', 'Tīng de shíhou jìlù shíjiān hé dìdiǎn.', 'Khi nghe hãy ghi thời gian và địa điểm.', NULL, 'review', '8817f87c-9ee1-5fbd-8a5e-eee67c1f8932'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('60798e40-67a8-5e2d-be0e-545acd0b0411'::UUID, '8817f87c-9ee1-5fbd-8a5e-eee67c1f8932'::UUID, 'ba89f0a3-e149-5e7e-a4ce-08f7eacf6b0d'::UUID, 3, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.grammar_lessons (id, content_key, title, pattern, explanation, example_chinese, example_pinyin, example_meaning, level, status, usage_note, content_version)
VALUES ('e8f641eb-4f5a-5f60-be3f-3f6d7d9bbf30'::UUID, 'listening:tu-khoa', 'Chiến lược với 先', '先 + hành động ưu tiên', '先 đánh dấu bước nghe cần làm trước.', '听对话时先记录关键词。', 'Tīng duìhuà shí xiān jìlù guānjiàncí.', 'Khi nghe hội thoại hãy ghi từ khóa trước.', 'elementary', 'review', NULL, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_grammar (id, lesson_id, grammar_lesson_id, order_index, curriculum_role)
VALUES ('3a2635d4-d39c-572e-8461-a06fef4405be'::UUID, '8817f87c-9ee1-5fbd-8a5e-eee67c1f8932'::UUID, 'e8f641eb-4f5a-5f60-be3f-3f6d7d9bbf30'::UUID, 1, 'introduced')
ON CONFLICT (lesson_id, grammar_lesson_id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('5ee1cea4-3f37-5ccd-b56e-474bc33118c0'::UUID, '8817f87c-9ee1-5fbd-8a5e-eee67c1f8932'::UUID, 'vocabulary', 1, 'Từ mới: 关键词', NULL, '关键词', '关键词 (guānjiàncí) — từ khóa. 先找出对话里的关键词。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"listening:关键词","chinese":"关键词","pinyin":"guānjiàncí","meaning":"từ khóa","part_of_speech":"danh từ","example_chinese":"先找出对话里的关键词。","example_pinyin":"Xiān zhǎochū duìhuà lǐ de guānjiàncí.","example_meaning_vi":"Trước tiên tìm từ khóa trong hội thoại."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('67807cb6-ab59-56e0-8717-519a00b53370'::UUID, '8817f87c-9ee1-5fbd-8a5e-eee67c1f8932'::UUID, 'vocabulary', 2, 'Từ mới: 重点', NULL, '重点', '重点 (zhòngdiǎn) — trọng điểm. 老师重复了今天的重点。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"listening:重点","chinese":"重点","pinyin":"zhòngdiǎn","meaning":"trọng điểm","part_of_speech":"danh từ","example_chinese":"老师重复了今天的重点。","example_pinyin":"Lǎoshī chóngfù le jīntiān de zhòngdiǎn.","example_meaning_vi":"Giáo viên lặp lại trọng điểm hôm nay."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('7b9aa2bb-2268-51d4-b7f8-910bee6cc97f'::UUID, '8817f87c-9ee1-5fbd-8a5e-eee67c1f8932'::UUID, 'vocabulary', 3, 'Từ mới: 记录', NULL, '记录', '记录 (jìlù) — ghi chép. 听的时候记录时间和地点。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"listening:记录","chinese":"记录","pinyin":"jìlù","meaning":"ghi chép","part_of_speech":"động từ/danh từ","example_chinese":"听的时候记录时间和地点。","example_pinyin":"Tīng de shíhou jìlù shíjiān hé dìdiǎn.","example_meaning_vi":"Khi nghe hãy ghi thời gian và địa điểm."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('a055cce2-fb63-5e99-9481-9d2d32c9162a'::UUID, '8817f87c-9ee1-5fbd-8a5e-eee67c1f8932'::UUID, 'multiple_choice', 4, '“关键词” có nghĩa phù hợp nhất là gì?', NULL, 'từ khóa', '关键词 (guānjiàncí) nghĩa là “từ khóa”.', NULL, 1, '{"activity_type":"chinese_to_vietnamese","vocabulary_key":"listening:关键词"}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('5ae504cd-0aa5-59fd-84e0-03f77254194e'::UUID, 'a055cce2-fb63-5e99-9481-9d2d32c9162a'::UUID, 'trọng điểm', FALSE, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('8916c46f-7377-5e3e-af28-eb691ddc7cda'::UUID, 'a055cce2-fb63-5e99-9481-9d2d32c9162a'::UUID, 'ghi chép', FALSE, 2)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('b6627252-f5a3-5e24-89f9-fba8c6eaab7a'::UUID, 'a055cce2-fb63-5e99-9481-9d2d32c9162a'::UUID, 'từ khóa', TRUE, 3)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('3988a0c4-2166-5200-a9a3-11f37f8ed5e5'::UUID, '8817f87c-9ee1-5fbd-8a5e-eee67c1f8932'::UUID, 'translation', 5, 'Dịch sang tiếng Trung: “Khi nghe hội thoại hãy ghi từ khóa trước.”', NULL, '听对话时先记录关键词。', 'Mẫu câu dùng “关键词” trong ngữ cảnh của bài.', 'guānjiàncí', 1, '{"activity_type":"vietnamese_to_chinese","source_lang":"vi","target_lang":"zh","acceptable_answers":["听对话时先记录关键词。"]}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('cb1c9272-a3b3-5c69-a0c7-eb347bd29a29'::UUID, '8817f87c-9ee1-5fbd-8a5e-eee67c1f8932'::UUID, 'sentence_builder', 6, 'Sắp xếp các thành phần thành câu đúng.', NULL, '听对话时先记录关键词。', 'Trật tự đúng tạo thành câu “听对话时先记录关键词。”.', NULL, 1, '{"activity_type":"sentence_ordering","words":["听","对话","时","先","记录","关键词","。"],"correct_order":["听","对话","时","先","记录","关键词","。"]}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('bc8b6166-510b-5051-9248-6fa56767d1d0'::UUID, '8817f87c-9ee1-5fbd-8a5e-eee67c1f8932'::UUID, 'multiple_choice', 7, 'Câu nào nêu chiến lược nghe?', NULL, '听对话时先记录关键词。', '先 đánh dấu bước nghe cần làm trước.', NULL, 1, '{"activity_type":"grammar_selection","passage":null,"grammar_key":"listening:tu-khoa"}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('0ff6f450-652c-543a-9e1f-a22c2c44c251'::UUID, 'bc8b6166-510b-5051-9248-6fa56767d1d0'::UUID, '听对话时先记录关键词。', TRUE, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('a676b150-5c51-5402-9824-7f74b70a936b'::UUID, 'bc8b6166-510b-5051-9248-6fa56767d1d0'::UUID, '。关键词记录先时对话听', FALSE, 2)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('a1ca014f-ca17-595e-88cd-fe7b5737f593'::UUID, 'bc8b6166-510b-5051-9248-6fa56767d1d0'::UUID, '对话时先记录关键词。听', FALSE, 3)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('fa0a4661-e6c3-5c87-b9b2-99982d905429'::UUID, '8817f87c-9ee1-5fbd-8a5e-eee67c1f8932'::UUID, 'speaking', 8, 'Đọc thành tiếng: 听对话时先记录关键词。', NULL, '听对话时先记录关键词。', 'Đọc chậm, giữ đúng thanh điệu và nhịp của cả câu.', NULL, 1, '{"activity_type":"pronunciation","text":"听对话时先记录关键词。","pinyin":"Tīng duìhuà shí xiān jìlù guānjiàncí."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lessons (id, chapter_id, slug, title, description, order_index, xp_reward, status, lesson_type, estimated_minutes, learning_objectives, cultural_note, content_version)
VALUES ('b37d05ac-6356-5150-9b84-4f202ce43f2a'::UUID, 'edd79ee3-e566-5b37-ab5f-071dad309658'::UUID, 'so-lieu', '听清数字 — Số liệu', 'Phân biệt thời gian, giá và số điện thoại.', 2, 25, 'review', 'standard', 15, '["Kiểm tra lại số liệu nghe được"]'::JSONB, 'Không tạo bài nghe khi tệp âm thanh chưa sẵn sàng.', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('eb8a9a03-b496-51d0-a8c0-4fa7e86e25e3'::UUID, 'listening:数字', '数字', 'shùzì', 'con số', 'number', 'elementary', 'so-lieu', 'danh từ', '请把听到的数字写下来。', 'Qǐng bǎ tīngdào de shùzì xiě xiàlai.', 'Hãy viết lại con số nghe được.', NULL, 'review', 'b37d05ac-6356-5150-9b84-4f202ce43f2a'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('3a13ce76-b54c-51e6-8cd5-c9948e4e5200'::UUID, 'b37d05ac-6356-5150-9b84-4f202ce43f2a'::UUID, 'eb8a9a03-b496-51d0-a8c0-4fa7e86e25e3'::UUID, 1, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('463c69c2-8525-5d3b-9e7c-dd42964961f9'::UUID, 'listening:重复', '重复', 'chóngfù', 'lặp lại', 'repeat', 'elementary', 'so-lieu', 'động từ', '这个号码请重复一遍。', 'Zhège hàomǎ qǐng chóngfù yí biàn.', 'Xin lặp lại số này một lần.', NULL, 'review', 'b37d05ac-6356-5150-9b84-4f202ce43f2a'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('b32229e7-9a7b-5ca1-9be1-f50d897d633c'::UUID, 'b37d05ac-6356-5150-9b84-4f202ce43f2a'::UUID, '463c69c2-8525-5d3b-9e7c-dd42964961f9'::UUID, 2, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('8ee3849c-5958-5d87-b614-3e4917a1195f'::UUID, 'listening:核对', '核对', 'héduì', 'đối chiếu', 'verify', 'elementary', 'so-lieu', 'động từ', '订票前请核对日期。', 'Dìngpiào qián qǐng héduì rìqī.', 'Trước khi đặt vé hãy đối chiếu ngày.', NULL, 'review', 'b37d05ac-6356-5150-9b84-4f202ce43f2a'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('9a7d8a13-64b5-51dd-a95f-dfb8e4c022f1'::UUID, 'b37d05ac-6356-5150-9b84-4f202ce43f2a'::UUID, '8ee3849c-5958-5d87-b614-3e4917a1195f'::UUID, 3, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('d8c17bcb-fd7e-5945-a59d-be79fb014781'::UUID, 'b37d05ac-6356-5150-9b84-4f202ce43f2a'::UUID, 'ad88cae0-45c5-50aa-b861-be3954202db7'::UUID, 4, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('1d5a1582-7130-5a23-9a56-1b3beefcf6d9'::UUID, 'b37d05ac-6356-5150-9b84-4f202ce43f2a'::UUID, '0c1e3514-9447-58d2-b018-7ff1eed82517'::UUID, 5, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('e6de4df2-8487-57ec-bb9a-849507d9fc19'::UUID, 'b37d05ac-6356-5150-9b84-4f202ce43f2a'::UUID, 'ba89f0a3-e149-5e7e-a4ce-08f7eacf6b0d'::UUID, 6, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.grammar_lessons (id, content_key, title, pattern, explanation, example_chinese, example_pinyin, example_meaning, level, status, usage_note, content_version)
VALUES ('7d08e43f-db2a-58ce-87f4-1da0f2638fef'::UUID, 'listening:so-lieu', 'Số lần với 遍', 'động từ + 一遍', '遍 đếm một lượt trọn vẹn của hành động.', '麻烦您把号码再说一遍。', 'Máfan nín bǎ hàomǎ zài shuō yí biàn.', 'Phiền ngài nói lại số một lần nữa.', 'elementary', 'review', NULL, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_grammar (id, lesson_id, grammar_lesson_id, order_index, curriculum_role)
VALUES ('9889eed3-5a30-512f-8b33-ffda6771e65c'::UUID, 'b37d05ac-6356-5150-9b84-4f202ce43f2a'::UUID, '7d08e43f-db2a-58ce-87f4-1da0f2638fef'::UUID, 1, 'introduced')
ON CONFLICT (lesson_id, grammar_lesson_id) DO NOTHING;

INSERT INTO public.lesson_grammar (id, lesson_id, grammar_lesson_id, order_index, curriculum_role)
VALUES ('5d85fc9a-a9a1-565e-9357-d5fc5a8711df'::UUID, 'b37d05ac-6356-5150-9b84-4f202ce43f2a'::UUID, 'e8f641eb-4f5a-5f60-be3f-3f6d7d9bbf30'::UUID, 2, 'review')
ON CONFLICT (lesson_id, grammar_lesson_id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('c9dc2f5c-0d09-530f-ad41-68cfaa49af92'::UUID, 'b37d05ac-6356-5150-9b84-4f202ce43f2a'::UUID, 'vocabulary', 1, 'Từ mới: 数字', NULL, '数字', '数字 (shùzì) — con số. 请把听到的数字写下来。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"listening:数字","chinese":"数字","pinyin":"shùzì","meaning":"con số","part_of_speech":"danh từ","example_chinese":"请把听到的数字写下来。","example_pinyin":"Qǐng bǎ tīngdào de shùzì xiě xiàlai.","example_meaning_vi":"Hãy viết lại con số nghe được."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('3e53d5b5-656e-578c-8dba-937d82b6acd1'::UUID, 'b37d05ac-6356-5150-9b84-4f202ce43f2a'::UUID, 'vocabulary', 2, 'Từ mới: 重复', NULL, '重复', '重复 (chóngfù) — lặp lại. 这个号码请重复一遍。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"listening:重复","chinese":"重复","pinyin":"chóngfù","meaning":"lặp lại","part_of_speech":"động từ","example_chinese":"这个号码请重复一遍。","example_pinyin":"Zhège hàomǎ qǐng chóngfù yí biàn.","example_meaning_vi":"Xin lặp lại số này một lần."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('23885421-58fd-5fa2-9b61-4928922f7d3f'::UUID, 'b37d05ac-6356-5150-9b84-4f202ce43f2a'::UUID, 'vocabulary', 3, 'Từ mới: 核对', NULL, '核对', '核对 (héduì) — đối chiếu. 订票前请核对日期。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"listening:核对","chinese":"核对","pinyin":"héduì","meaning":"đối chiếu","part_of_speech":"động từ","example_chinese":"订票前请核对日期。","example_pinyin":"Dìngpiào qián qǐng héduì rìqī.","example_meaning_vi":"Trước khi đặt vé hãy đối chiếu ngày."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('f75cee64-b58b-5d51-a818-ffd42a3b1fea'::UUID, 'b37d05ac-6356-5150-9b84-4f202ce43f2a'::UUID, 'multiple_choice', 4, '“数字” có nghĩa phù hợp nhất là gì?', NULL, 'con số', '数字 (shùzì) nghĩa là “con số”.', NULL, 1, '{"activity_type":"chinese_to_vietnamese","vocabulary_key":"listening:数字"}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('ecffd7bb-bbbd-537e-b785-08a69e31ad85'::UUID, 'f75cee64-b58b-5d51-a818-ffd42a3b1fea'::UUID, 'con số', TRUE, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('9890ff9c-51b8-5b28-b55d-672cc63444ad'::UUID, 'f75cee64-b58b-5d51-a818-ffd42a3b1fea'::UUID, 'lặp lại', FALSE, 2)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('f1382dcc-a63a-5ed0-bad3-78fd529aad48'::UUID, 'f75cee64-b58b-5d51-a818-ffd42a3b1fea'::UUID, 'đối chiếu', FALSE, 3)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('578979db-166c-528c-8ce2-aaaef8dd5be9'::UUID, 'b37d05ac-6356-5150-9b84-4f202ce43f2a'::UUID, 'translation', 5, 'Dịch sang tiếng Trung: “Phiền ngài nói lại số một lần nữa.”', NULL, '麻烦您把号码再说一遍。', 'Mẫu câu dùng “数字” trong ngữ cảnh của bài.', 'shùzì', 1, '{"activity_type":"vietnamese_to_chinese","source_lang":"vi","target_lang":"zh","acceptable_answers":["麻烦您把号码再说一遍。"]}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('706ef840-5f24-50d4-813b-2271041915bd'::UUID, 'b37d05ac-6356-5150-9b84-4f202ce43f2a'::UUID, 'sentence_builder', 6, 'Sắp xếp các thành phần thành câu đúng.', NULL, '麻烦您把号码再说一遍。', 'Trật tự đúng tạo thành câu “麻烦您把号码再说一遍。”.', NULL, 1, '{"activity_type":"sentence_ordering","words":["麻烦","您","把","号码","再","说","一遍","。"],"correct_order":["麻烦","您","把","号码","再","说","一遍","。"]}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('7801e85b-e79c-5dd0-aff5-56eb1089dd81'::UUID, 'b37d05ac-6356-5150-9b84-4f202ce43f2a'::UUID, 'multiple_choice', 7, 'Câu nào yêu cầu lặp lại trọn vẹn?', NULL, '麻烦您把号码再说一遍。', '遍 đếm một lượt trọn vẹn của hành động.', NULL, 1, '{"activity_type":"grammar_selection","passage":null,"grammar_key":"listening:so-lieu"}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('04e7c457-9aa5-5316-a742-0bcb741dd322'::UUID, '7801e85b-e79c-5dd0-aff5-56eb1089dd81'::UUID, '麻烦您把号码再说一遍。', TRUE, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('f59103c7-54bc-5891-a937-cb3b4de4e228'::UUID, '7801e85b-e79c-5dd0-aff5-56eb1089dd81'::UUID, '。一遍说再号码把您麻烦', FALSE, 2)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('dedd86a2-5f3c-5383-81b5-b94c4aa91cf7'::UUID, '7801e85b-e79c-5dd0-aff5-56eb1089dd81'::UUID, '您把号码再说一遍。麻烦', FALSE, 3)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('d3164e40-fbbf-5e72-9f10-7e7df7971272'::UUID, 'b37d05ac-6356-5150-9b84-4f202ce43f2a'::UUID, 'speaking', 8, 'Đọc thành tiếng: 麻烦您把号码再说一遍。', NULL, '麻烦您把号码再说一遍。', 'Đọc chậm, giữ đúng thanh điệu và nhịp của cả câu.', NULL, 1, '{"activity_type":"pronunciation","text":"麻烦您把号码再说一遍。","pinyin":"Máfan nín bǎ hàomǎ zài shuō yí biàn."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.units (id, course_id, slug, title, description, order_index, status, learning_objectives, content_version)
VALUES ('2784272c-dda3-5d9c-b62b-254c2f7895c2'::UUID, '878562b7-5609-5d4b-b06c-68a4e4b747b2'::UUID, 'listening-van-dung', 'Vận dụng', 'Vận dụng mẫu câu trong ngữ cảnh có ý nghĩa.', 2, 'review', '["Theo dõi ý chính","Suy luận thái độ từ ngữ cảnh"]'::JSONB, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.chapters (id, unit_id, slug, title, description, order_index, status, learning_objectives, content_version)
VALUES ('7764f771-4acb-5d86-8f91-cb303c7059e9'::UUID, '2784272c-dda3-5d9c-b62b-254c2f7895c2'::UUID, 'listening-van-dung-chapter', 'Ngữ cảnh thực tế', 'Vận dụng mẫu câu trong ngữ cảnh có ý nghĩa.', 1, 'review', '["Theo dõi ý chính","Suy luận thái độ từ ngữ cảnh"]'::JSONB, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lessons (id, chapter_id, slug, title, description, order_index, xp_reward, status, lesson_type, estimated_minutes, learning_objectives, cultural_note, content_version)
VALUES ('21fb3baa-b626-55d9-a92f-25218e98eed4'::UUID, '7764f771-4acb-5d86-8f91-cb303c7059e9'::UUID, 'y-chinh', '概括大意 — Ý chính', 'Theo dõi chủ đề và kết luận.', 1, 25, 'review', 'standard', 15, '["Tóm tắt nội dung nghe"]'::JSONB, 'Chỉ bài tập đọc/thực hành chiến lược được sinh khi audio còn pending.', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('2dd6519b-e9d3-5d76-9ed4-38ed235a67fc'::UUID, 'listening:大意', '大意', 'dàyì', 'đại ý', 'main idea', 'elementary', 'y-chinh', 'danh từ', '听完以后请概括大意。', 'Tīngwán yǐhòu qǐng gàikuò dàyì.', 'Sau khi nghe xong hãy khái quát đại ý.', NULL, 'review', '21fb3baa-b626-55d9-a92f-25218e98eed4'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('beb022e6-16cc-56fd-832e-1f1385d70f57'::UUID, '21fb3baa-b626-55d9-a92f-25218e98eed4'::UUID, '2dd6519b-e9d3-5d76-9ed4-38ed235a67fc'::UUID, 1, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('bee86a6e-9f0f-5117-ab28-250ef682043f'::UUID, 'listening:主题', '主题', 'zhǔtí', 'chủ đề', 'theme', 'elementary', 'y-chinh', 'danh từ', '这段谈话的主题是健康。', 'Zhè duàn tánhuà de zhǔtí shì jiànkāng.', 'Chủ đề đoạn hội thoại này là sức khỏe.', NULL, 'review', '21fb3baa-b626-55d9-a92f-25218e98eed4'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('595af409-4060-51b3-946d-0dd41936c3e4'::UUID, '21fb3baa-b626-55d9-a92f-25218e98eed4'::UUID, 'bee86a6e-9f0f-5117-ab28-250ef682043f'::UUID, 2, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('72d68fa5-ba3a-5c5d-8092-7c0b7f48145c'::UUID, 'listening:概括', '概括', 'gàikuò', 'khái quát', 'summarize', 'elementary', 'y-chinh', 'động từ', '请用一句话概括主要内容。', 'Qǐng yòng yí jù huà gàikuò zhǔyào nèiróng.', 'Hãy dùng một câu khái quát nội dung chính.', NULL, 'review', '21fb3baa-b626-55d9-a92f-25218e98eed4'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('190d8fff-c1b6-5c36-b33f-61762768297f'::UUID, '21fb3baa-b626-55d9-a92f-25218e98eed4'::UUID, '72d68fa5-ba3a-5c5d-8092-7c0b7f48145c'::UUID, 3, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('6c527978-ef89-5740-b2ed-42d9b1f369a2'::UUID, '21fb3baa-b626-55d9-a92f-25218e98eed4'::UUID, 'eb8a9a03-b496-51d0-a8c0-4fa7e86e25e3'::UUID, 4, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('bccdbc9b-5fdf-5a68-8e25-29316a114b7a'::UUID, '21fb3baa-b626-55d9-a92f-25218e98eed4'::UUID, '463c69c2-8525-5d3b-9e7c-dd42964961f9'::UUID, 5, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('2d7c9a51-9bf0-55ea-bf37-3e605bc964a5'::UUID, '21fb3baa-b626-55d9-a92f-25218e98eed4'::UUID, '8ee3849c-5958-5d87-b614-3e4917a1195f'::UUID, 6, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.grammar_lessons (id, content_key, title, pattern, explanation, example_chinese, example_pinyin, example_meaning, level, status, usage_note, content_version)
VALUES ('dcb5ec2a-33b8-5d39-9a94-c365044801fe'::UUID, 'listening:y-chinh', 'Sau khi hoàn tất với 以后', 'động từ + 完 + 以后，…', '完 đánh dấu hoàn tất; 以后 dẫn bước tiếp theo.', '听完以后再概括主要内容。', 'Tīngwán yǐhòu zài gàikuò zhǔyào nèiróng.', 'Sau khi nghe xong hãy khái quát nội dung chính.', 'elementary', 'review', NULL, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_grammar (id, lesson_id, grammar_lesson_id, order_index, curriculum_role)
VALUES ('7e6ab52f-0073-58b4-9191-3e605aef669f'::UUID, '21fb3baa-b626-55d9-a92f-25218e98eed4'::UUID, 'dcb5ec2a-33b8-5d39-9a94-c365044801fe'::UUID, 1, 'introduced')
ON CONFLICT (lesson_id, grammar_lesson_id) DO NOTHING;

INSERT INTO public.lesson_grammar (id, lesson_id, grammar_lesson_id, order_index, curriculum_role)
VALUES ('51c99134-1ae4-5a35-9866-addd6fabdf2d'::UUID, '21fb3baa-b626-55d9-a92f-25218e98eed4'::UUID, '7d08e43f-db2a-58ce-87f4-1da0f2638fef'::UUID, 2, 'review')
ON CONFLICT (lesson_id, grammar_lesson_id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('ac867853-9ea2-5013-b530-08d9add73056'::UUID, '21fb3baa-b626-55d9-a92f-25218e98eed4'::UUID, 'vocabulary', 1, 'Từ mới: 大意', NULL, '大意', '大意 (dàyì) — đại ý. 听完以后请概括大意。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"listening:大意","chinese":"大意","pinyin":"dàyì","meaning":"đại ý","part_of_speech":"danh từ","example_chinese":"听完以后请概括大意。","example_pinyin":"Tīngwán yǐhòu qǐng gàikuò dàyì.","example_meaning_vi":"Sau khi nghe xong hãy khái quát đại ý."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('0ed023a4-9949-537d-9cc3-8b5c4b7d2d48'::UUID, '21fb3baa-b626-55d9-a92f-25218e98eed4'::UUID, 'vocabulary', 2, 'Từ mới: 主题', NULL, '主题', '主题 (zhǔtí) — chủ đề. 这段谈话的主题是健康。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"listening:主题","chinese":"主题","pinyin":"zhǔtí","meaning":"chủ đề","part_of_speech":"danh từ","example_chinese":"这段谈话的主题是健康。","example_pinyin":"Zhè duàn tánhuà de zhǔtí shì jiànkāng.","example_meaning_vi":"Chủ đề đoạn hội thoại này là sức khỏe."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('9a5c71d9-fa4b-57fb-9205-1ca63bf0a687'::UUID, '21fb3baa-b626-55d9-a92f-25218e98eed4'::UUID, 'vocabulary', 3, 'Từ mới: 概括', NULL, '概括', '概括 (gàikuò) — khái quát. 请用一句话概括主要内容。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"listening:概括","chinese":"概括","pinyin":"gàikuò","meaning":"khái quát","part_of_speech":"động từ","example_chinese":"请用一句话概括主要内容。","example_pinyin":"Qǐng yòng yí jù huà gàikuò zhǔyào nèiróng.","example_meaning_vi":"Hãy dùng một câu khái quát nội dung chính."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('ea7a348a-f70e-5358-9c12-f6a79f30b0b7'::UUID, '21fb3baa-b626-55d9-a92f-25218e98eed4'::UUID, 'multiple_choice', 4, '“大意” có nghĩa phù hợp nhất là gì?', NULL, 'đại ý', '大意 (dàyì) nghĩa là “đại ý”.', NULL, 1, '{"activity_type":"chinese_to_vietnamese","vocabulary_key":"listening:大意"}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('15f9d3c6-797e-5cdf-88d9-3d65069c3889'::UUID, 'ea7a348a-f70e-5358-9c12-f6a79f30b0b7'::UUID, 'khái quát', FALSE, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('84a8be22-b2eb-5bbd-ad44-46cb82592ef8'::UUID, 'ea7a348a-f70e-5358-9c12-f6a79f30b0b7'::UUID, 'đại ý', TRUE, 2)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('dcfd0043-f42a-5c4a-80e0-b490ab329d41'::UUID, 'ea7a348a-f70e-5358-9c12-f6a79f30b0b7'::UUID, 'chủ đề', FALSE, 3)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('1074fec4-15d2-58a1-abcd-8a38cf251668'::UUID, '21fb3baa-b626-55d9-a92f-25218e98eed4'::UUID, 'translation', 5, 'Dịch sang tiếng Trung: “Sau khi nghe xong hãy khái quát nội dung chính.”', NULL, '听完以后再概括主要内容。', 'Mẫu câu dùng “大意” trong ngữ cảnh của bài.', 'dàyì', 1, '{"activity_type":"vietnamese_to_chinese","source_lang":"vi","target_lang":"zh","acceptable_answers":["听完以后再概括主要内容。"]}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('e474f247-46d3-547d-8800-830b75a2a9de'::UUID, '21fb3baa-b626-55d9-a92f-25218e98eed4'::UUID, 'sentence_builder', 6, 'Sắp xếp các thành phần thành câu đúng.', NULL, '听完以后再概括主要内容。', 'Trật tự đúng tạo thành câu “听完以后再概括主要内容。”.', NULL, 1, '{"activity_type":"sentence_ordering","words":["听","完","以后","再","概括","主要","内容","。"],"correct_order":["听","完","以后","再","概括","主要","内容","。"]}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('40c85402-8550-5454-b71f-b0713fd3d07f'::UUID, '21fb3baa-b626-55d9-a92f-25218e98eed4'::UUID, 'multiple_choice', 7, 'Câu nào có trình tự nghe rồi tóm tắt?', NULL, '听完以后再概括主要内容。', '完 đánh dấu hoàn tất; 以后 dẫn bước tiếp theo.', NULL, 1, '{"activity_type":"grammar_selection","passage":null,"grammar_key":"listening:y-chinh"}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('ab99606b-9d18-5d90-8522-7ba2e523fbaa'::UUID, '40c85402-8550-5454-b71f-b0713fd3d07f'::UUID, '听完以后再概括主要内容。', TRUE, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('17760bda-bc58-549b-ae10-ef8a48ef63cb'::UUID, '40c85402-8550-5454-b71f-b0713fd3d07f'::UUID, '。内容主要概括再以后完听', FALSE, 2)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('77beca62-e7c6-5f8b-9483-8c3bc1261d01'::UUID, '40c85402-8550-5454-b71f-b0713fd3d07f'::UUID, '完以后再概括主要内容。听', FALSE, 3)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('cff59ea1-1087-5b82-bee9-6c45a46e840b'::UUID, '21fb3baa-b626-55d9-a92f-25218e98eed4'::UUID, 'speaking', 8, 'Đọc thành tiếng: 听完以后再概括主要内容。', NULL, '听完以后再概括主要内容。', 'Đọc chậm, giữ đúng thanh điệu và nhịp của cả câu.', NULL, 1, '{"activity_type":"pronunciation","text":"听完以后再概括主要内容。","pinyin":"Tīngwán yǐhòu zài gàikuò zhǔyào nèiróng."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lessons (id, chapter_id, slug, title, description, order_index, xp_reward, status, lesson_type, estimated_minutes, learning_objectives, cultural_note, content_version)
VALUES ('49115d06-8714-5dbb-9d71-201f1899261a'::UUID, '7764f771-4acb-5d86-8f91-cb303c7059e9'::UUID, 'thai-do', '判断语气 — Thái độ', 'Suy luận thái độ qua từ ngữ và ngữ điệu.', 2, 25, 'review', 'standard', 15, '["Nhận biết thái độ người nói"]'::JSONB, 'Suy luận thái độ cần audio thật; hiện được giữ ở trạng thái review.', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('a70b8bf4-465b-5477-84d1-173dc60671d7'::UUID, 'listening:语气', '语气', 'yǔqì', 'ngữ khí, giọng điệu', 'tone of voice', 'elementary', 'thai-do', 'danh từ', '她的语气听起来很轻松。', 'Tā de yǔqì tīngqilai hěn qīngsōng.', 'Giọng điệu của cô ấy nghe rất thoải mái.', NULL, 'review', '49115d06-8714-5dbb-9d71-201f1899261a'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('96c25334-788a-5e40-877a-92cf082391ca'::UUID, '49115d06-8714-5dbb-9d71-201f1899261a'::UUID, 'a70b8bf4-465b-5477-84d1-173dc60671d7'::UUID, 1, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('b50dec50-5576-596f-b0ea-6369615bc487'::UUID, 'listening:态度', '态度', 'tàidu', 'thái độ', 'attitude', 'elementary', 'thai-do', 'danh từ', '他说话的态度很诚恳。', 'Tā shuōhuà de tàidu hěn chéngkěn.', 'Thái độ nói chuyện của anh ấy rất chân thành.', NULL, 'review', '49115d06-8714-5dbb-9d71-201f1899261a'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('f358089a-5c75-51c4-8d74-e6c91be4ed97'::UUID, '49115d06-8714-5dbb-9d71-201f1899261a'::UUID, 'b50dec50-5576-596f-b0ea-6369615bc487'::UUID, 2, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('d047ce05-6cc8-523d-bd59-9b527ba95349'::UUID, 'listening:推测', '推测', 'tuīcè', 'suy đoán', 'infer', 'elementary', 'thai-do', 'động từ', '我们可以从语气推测他的态度。', 'Wǒmen kěyǐ cóng yǔqì tuīcè tā de tàidu.', 'Chúng ta có thể suy đoán thái độ của anh ấy từ giọng điệu.', NULL, 'review', '49115d06-8714-5dbb-9d71-201f1899261a'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('cb7171c8-5264-5257-bf50-cb44b28433b8'::UUID, '49115d06-8714-5dbb-9d71-201f1899261a'::UUID, 'd047ce05-6cc8-523d-bd59-9b527ba95349'::UUID, 3, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('9ad6640a-2c48-5257-be8d-7269fe6f55bb'::UUID, '49115d06-8714-5dbb-9d71-201f1899261a'::UUID, '2dd6519b-e9d3-5d76-9ed4-38ed235a67fc'::UUID, 4, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('e1443add-f530-5fbb-899d-41dc47eaabe5'::UUID, '49115d06-8714-5dbb-9d71-201f1899261a'::UUID, 'bee86a6e-9f0f-5117-ab28-250ef682043f'::UUID, 5, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('c07f0e9f-1e8f-52f2-8961-56785bf54c0f'::UUID, '49115d06-8714-5dbb-9d71-201f1899261a'::UUID, '72d68fa5-ba3a-5c5d-8092-7c0b7f48145c'::UUID, 6, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.grammar_lessons (id, content_key, title, pattern, explanation, example_chinese, example_pinyin, example_meaning, level, status, usage_note, content_version)
VALUES ('23f5d00e-57ee-5bad-853d-eee7520ff864'::UUID, 'listening:thai-do', 'Nguồn suy luận với 从', '从 + căn cứ + 推测 + kết luận', '从 giới thiệu căn cứ dùng để suy luận.', '我们从语气推测说话人的态度。', 'Wǒmen cóng yǔqì tuīcè shuōhuàrén de tàidu.', 'Chúng ta suy đoán thái độ người nói từ giọng điệu.', 'elementary', 'review', NULL, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_grammar (id, lesson_id, grammar_lesson_id, order_index, curriculum_role)
VALUES ('55118d5b-73aa-5106-ad75-f825b2417a97'::UUID, '49115d06-8714-5dbb-9d71-201f1899261a'::UUID, '23f5d00e-57ee-5bad-853d-eee7520ff864'::UUID, 1, 'introduced')
ON CONFLICT (lesson_id, grammar_lesson_id) DO NOTHING;

INSERT INTO public.lesson_grammar (id, lesson_id, grammar_lesson_id, order_index, curriculum_role)
VALUES ('89ab86b3-87af-5033-8838-b5d387d0401a'::UUID, '49115d06-8714-5dbb-9d71-201f1899261a'::UUID, 'dcb5ec2a-33b8-5d39-9a94-c365044801fe'::UUID, 2, 'review')
ON CONFLICT (lesson_id, grammar_lesson_id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('0862ab83-dddb-5072-8863-2d84165239d2'::UUID, '49115d06-8714-5dbb-9d71-201f1899261a'::UUID, 'vocabulary', 1, 'Từ mới: 语气', NULL, '语气', '语气 (yǔqì) — ngữ khí, giọng điệu. 她的语气听起来很轻松。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"listening:语气","chinese":"语气","pinyin":"yǔqì","meaning":"ngữ khí, giọng điệu","part_of_speech":"danh từ","example_chinese":"她的语气听起来很轻松。","example_pinyin":"Tā de yǔqì tīngqilai hěn qīngsōng.","example_meaning_vi":"Giọng điệu của cô ấy nghe rất thoải mái."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('92b4edcc-0ce0-57a1-a5d2-2eb448124b35'::UUID, '49115d06-8714-5dbb-9d71-201f1899261a'::UUID, 'vocabulary', 2, 'Từ mới: 态度', NULL, '态度', '态度 (tàidu) — thái độ. 他说话的态度很诚恳。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"listening:态度","chinese":"态度","pinyin":"tàidu","meaning":"thái độ","part_of_speech":"danh từ","example_chinese":"他说话的态度很诚恳。","example_pinyin":"Tā shuōhuà de tàidu hěn chéngkěn.","example_meaning_vi":"Thái độ nói chuyện của anh ấy rất chân thành."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('5da8d6a8-f125-58d2-a4d5-1f323a61b668'::UUID, '49115d06-8714-5dbb-9d71-201f1899261a'::UUID, 'vocabulary', 3, 'Từ mới: 推测', NULL, '推测', '推测 (tuīcè) — suy đoán. 我们可以从语气推测他的态度。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"listening:推测","chinese":"推测","pinyin":"tuīcè","meaning":"suy đoán","part_of_speech":"động từ","example_chinese":"我们可以从语气推测他的态度。","example_pinyin":"Wǒmen kěyǐ cóng yǔqì tuīcè tā de tàidu.","example_meaning_vi":"Chúng ta có thể suy đoán thái độ của anh ấy từ giọng điệu."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('fd3d0f6c-ce0a-5f63-b0ba-5c1147279dc9'::UUID, '49115d06-8714-5dbb-9d71-201f1899261a'::UUID, 'multiple_choice', 4, '“语气” có nghĩa phù hợp nhất là gì?', NULL, 'ngữ khí, giọng điệu', '语气 (yǔqì) nghĩa là “ngữ khí, giọng điệu”.', NULL, 1, '{"activity_type":"chinese_to_vietnamese","vocabulary_key":"listening:语气"}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('588a9610-dbaf-5513-a17a-87d6996b452c'::UUID, 'fd3d0f6c-ce0a-5f63-b0ba-5c1147279dc9'::UUID, 'suy đoán', FALSE, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('b9ba7848-89e0-534f-8970-7b2787adfba5'::UUID, 'fd3d0f6c-ce0a-5f63-b0ba-5c1147279dc9'::UUID, 'ngữ khí, giọng điệu', TRUE, 2)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('ca3a1024-9be6-5886-986b-be4345408f1a'::UUID, 'fd3d0f6c-ce0a-5f63-b0ba-5c1147279dc9'::UUID, 'thái độ', FALSE, 3)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('533a144d-1bca-504f-b752-ad6a2185fbad'::UUID, '49115d06-8714-5dbb-9d71-201f1899261a'::UUID, 'translation', 5, 'Dịch sang tiếng Trung: “Chúng ta suy đoán thái độ người nói từ giọng điệu.”', NULL, '我们从语气推测说话人的态度。', 'Mẫu câu dùng “语气” trong ngữ cảnh của bài.', 'yǔqì', 1, '{"activity_type":"vietnamese_to_chinese","source_lang":"vi","target_lang":"zh","acceptable_answers":["我们从语气推测说话人的态度。"]}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('ea430ec7-4722-56ba-bb88-e851347f0002'::UUID, '49115d06-8714-5dbb-9d71-201f1899261a'::UUID, 'sentence_builder', 6, 'Sắp xếp các thành phần thành câu đúng.', NULL, '我们从语气推测说话人的态度。', 'Trật tự đúng tạo thành câu “我们从语气推测说话人的态度。”.', NULL, 1, '{"activity_type":"sentence_ordering","words":["我们","从","语气","推测","说话人","的","态度","。"],"correct_order":["我们","从","语气","推测","说话人","的","态度","。"]}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('fc11ad1b-4c36-5605-8f35-3f64ce6d1dd7'::UUID, '49115d06-8714-5dbb-9d71-201f1899261a'::UUID, 'multiple_choice', 7, 'Câu nào nêu căn cứ suy luận?', NULL, '我们从语气推测说话人的态度。', '从 giới thiệu căn cứ dùng để suy luận.', NULL, 1, '{"activity_type":"grammar_selection","passage":null,"grammar_key":"listening:thai-do"}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('1b0ce508-cbe5-5e0d-8740-74cf7316432e'::UUID, 'fc11ad1b-4c36-5605-8f35-3f64ce6d1dd7'::UUID, '我们从语气推测说话人的态度。', TRUE, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('26a43703-ae88-51ad-b720-ae8605a97370'::UUID, 'fc11ad1b-4c36-5605-8f35-3f64ce6d1dd7'::UUID, '。态度的说话人推测语气从我们', FALSE, 2)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('b20ea172-c584-5f46-9e7b-44370e0c8bc8'::UUID, 'fc11ad1b-4c36-5605-8f35-3f64ce6d1dd7'::UUID, '从语气推测说话人的态度。我们', FALSE, 3)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('9e4388c0-8762-5cf0-b093-25f162bdbcb0'::UUID, '49115d06-8714-5dbb-9d71-201f1899261a'::UUID, 'speaking', 8, 'Đọc thành tiếng: 我们从语气推测说话人的态度。', NULL, '我们从语气推测说话人的态度。', 'Đọc chậm, giữ đúng thanh điệu và nhịp của cả câu.', NULL, 1, '{"activity_type":"pronunciation","text":"我们从语气推测说话人的态度。","pinyin":"Wǒmen cóng yǔqì tuīcè shuōhuàrén de tàidu."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.units (id, course_id, slug, title, description, order_index, status, learning_objectives, content_version)
VALUES ('d05d8393-b95f-5375-8d34-10f8663f56e5'::UUID, '878562b7-5609-5d4b-b06c-68a4e4b747b2'::UUID, 'listening-on-tap', 'Ôn tập', 'Kiểm tra và củng cố nội dung đã học.', 3, 'review', '["Ôn từ vựng","Ôn mẫu câu"]'::JSONB, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.chapters (id, unit_id, slug, title, description, order_index, status, learning_objectives, content_version)
VALUES ('0899beb1-4180-5102-b7c4-479e47167094'::UUID, 'd05d8393-b95f-5375-8d34-10f8663f56e5'::UUID, 'listening-on-tap-chapter', 'Củng cố lộ trình', 'Kiểm tra và củng cố nội dung đã học.', 1, 'review', '["Ôn từ vựng","Ôn mẫu câu"]'::JSONB, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lessons (id, chapter_id, slug, title, description, order_index, xp_reward, status, lesson_type, estimated_minutes, learning_objectives, cultural_note, content_version)
VALUES ('8164cd33-11ec-507f-8732-3aaca12431bd'::UUID, '0899beb1-4180-5102-b7c4-479e47167094'::UUID, 'listening-review', 'Ôn tập Chinese Listening Practice', 'Củng cố từ vựng, mẫu câu và khả năng diễn đạt của toàn khóa.', 1, 30, 'review', 'review', 18, '["Vận dụng lại từ vựng trọng tâm","Tự kiểm tra mẫu câu đã học"]'::JSONB, NULL, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('8206e203-1bdd-5c52-bdd9-d0b68d1e648d'::UUID, '8164cd33-11ec-507f-8732-3aaca12431bd'::UUID, 'a70b8bf4-465b-5477-84d1-173dc60671d7'::UUID, 1, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('e44a84b3-55b7-5895-b210-8425fd4bdf77'::UUID, '8164cd33-11ec-507f-8732-3aaca12431bd'::UUID, 'b50dec50-5576-596f-b0ea-6369615bc487'::UUID, 2, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('220558db-600c-52cf-aab0-331ab514283c'::UUID, '8164cd33-11ec-507f-8732-3aaca12431bd'::UUID, 'd047ce05-6cc8-523d-bd59-9b527ba95349'::UUID, 3, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_grammar (id, lesson_id, grammar_lesson_id, order_index, curriculum_role)
VALUES ('8e4c1ab4-3633-5627-ba01-55b0f59b4bc2'::UUID, '8164cd33-11ec-507f-8732-3aaca12431bd'::UUID, '23f5d00e-57ee-5bad-853d-eee7520ff864'::UUID, 1, 'review')
ON CONFLICT (lesson_id, grammar_lesson_id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('12f5bf1c-4fe2-5d84-a636-3adcb9dc4b22'::UUID, '8164cd33-11ec-507f-8732-3aaca12431bd'::UUID, 'multiple_choice', 1, '“语气” có nghĩa phù hợp nhất là gì?', NULL, 'ngữ khí, giọng điệu', '语气 (yǔqì) nghĩa là “ngữ khí, giọng điệu”.', NULL, 1, '{"activity_type":"chinese_to_vietnamese","vocabulary_key":"listening:语气"}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('41ed8e9b-aa27-53db-b023-69c3f929da67'::UUID, '12f5bf1c-4fe2-5d84-a636-3adcb9dc4b22'::UUID, 'thái độ', FALSE, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('a5afe046-aa64-56db-8df1-d24e58f85141'::UUID, '12f5bf1c-4fe2-5d84-a636-3adcb9dc4b22'::UUID, 'suy đoán', FALSE, 2)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('3fc75e44-d950-5d93-89a3-734ba393e20c'::UUID, '12f5bf1c-4fe2-5d84-a636-3adcb9dc4b22'::UUID, 'ngữ khí, giọng điệu', TRUE, 3)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('b5b1d4ba-4b52-558e-a3c2-a3cc3bd3e0f7'::UUID, '8164cd33-11ec-507f-8732-3aaca12431bd'::UUID, 'translation', 2, 'Dịch sang tiếng Trung: “Chúng ta suy đoán thái độ người nói từ giọng điệu.”', NULL, '我们从语气推测说话人的态度。', 'Mẫu câu dùng “语气” trong ngữ cảnh của bài.', 'yǔqì', 1, '{"activity_type":"vietnamese_to_chinese","source_lang":"vi","target_lang":"zh","acceptable_answers":["我们从语气推测说话人的态度。"]}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('5c9f6d6e-2aad-52ac-aa2b-57afb6e1da84'::UUID, '8164cd33-11ec-507f-8732-3aaca12431bd'::UUID, 'sentence_builder', 3, 'Sắp xếp các thành phần thành câu đúng.', NULL, '我们从语气推测说话人的态度。', 'Trật tự đúng tạo thành câu “我们从语气推测说话人的态度。”.', NULL, 1, '{"activity_type":"sentence_ordering","words":["我们","从","语气","推测","说话人","的","态度","。"],"correct_order":["我们","从","语气","推测","说话人","的","态度","。"]}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('9e4814dd-5efa-516b-8f20-e1132eb4f184'::UUID, '8164cd33-11ec-507f-8732-3aaca12431bd'::UUID, 'multiple_choice', 4, 'Câu nào nêu căn cứ suy luận?', NULL, '我们从语气推测说话人的态度。', '从 giới thiệu căn cứ dùng để suy luận.', NULL, 1, '{"activity_type":"grammar_selection","passage":null,"grammar_key":"listening:thai-do"}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('fdb627b9-4608-52b4-bffb-9d48ac7cd74d'::UUID, '9e4814dd-5efa-516b-8f20-e1132eb4f184'::UUID, '我们从语气推测说话人的态度。', TRUE, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('f7fab386-4f93-5c80-9a33-de17d4293ccf'::UUID, '9e4814dd-5efa-516b-8f20-e1132eb4f184'::UUID, '。态度的说话人推测语气从我们', FALSE, 2)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('a794f2a4-1e02-5771-b6ec-32ee1fee4869'::UUID, '9e4814dd-5efa-516b-8f20-e1132eb4f184'::UUID, '从语气推测说话人的态度。我们', FALSE, 3)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('edd09200-ac31-5b82-9260-eaf6c0ef7dd5'::UUID, '8164cd33-11ec-507f-8732-3aaca12431bd'::UUID, 'speaking', 5, 'Đọc thành tiếng: 我们从语气推测说话人的态度。', NULL, '我们从语气推测说话人的态度。', 'Đọc chậm, giữ đúng thanh điệu và nhịp của cả câu.', NULL, 1, '{"activity_type":"pronunciation","text":"我们从语气推测说话人的态度。","pinyin":"Wǒmen cóng yǔqì tuīcè shuōhuàrén de tàidu."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.content_batches (id, batch_key, version, migration_name, manifest_checksum, expected_counts)
VALUES ('0045bcf9-e3b2-50cc-a399-d6ef6e5a75cd'::UUID, 'batch-13-listening', 1, '20260729220000_content_batch_13_listening', '5ec63821a6acf1716ce9573bb8c22769064a4c9c07e2e512fccc5fb11d06e436', '{"courses":1,"units":3,"chapters":3,"lessons":5,"vocabulary":12,"grammar":4,"characters":0,"exercises":37,"options":30}'::JSONB)
ON CONFLICT (batch_key, version) DO NOTHING;

DO $content_validation$
BEGIN
  IF (SELECT COUNT(*) FROM public.courses WHERE id = ANY(ARRAY['878562b7-5609-5d4b-b06c-68a4e4b747b2'::UUID]::UUID[])) <> 1 THEN
    RAISE EXCEPTION 'Content batch batch-13-listening is missing managed courses rows';
  END IF;
  IF (SELECT COUNT(*) FROM public.units WHERE id = ANY(ARRAY['c7b26d25-b0b9-5bd8-af8f-9bb9b25a02ec'::UUID, '2784272c-dda3-5d9c-b62b-254c2f7895c2'::UUID, 'd05d8393-b95f-5375-8d34-10f8663f56e5'::UUID]::UUID[])) <> 3 THEN
    RAISE EXCEPTION 'Content batch batch-13-listening is missing managed units rows';
  END IF;
  IF (SELECT COUNT(*) FROM public.chapters WHERE id = ANY(ARRAY['edd79ee3-e566-5b37-ab5f-071dad309658'::UUID, '7764f771-4acb-5d86-8f91-cb303c7059e9'::UUID, '0899beb1-4180-5102-b7c4-479e47167094'::UUID]::UUID[])) <> 3 THEN
    RAISE EXCEPTION 'Content batch batch-13-listening is missing managed chapters rows';
  END IF;
  IF (SELECT COUNT(*) FROM public.lessons WHERE id = ANY(ARRAY['8817f87c-9ee1-5fbd-8a5e-eee67c1f8932'::UUID, 'b37d05ac-6356-5150-9b84-4f202ce43f2a'::UUID, '21fb3baa-b626-55d9-a92f-25218e98eed4'::UUID, '49115d06-8714-5dbb-9d71-201f1899261a'::UUID, '8164cd33-11ec-507f-8732-3aaca12431bd'::UUID]::UUID[])) <> 5 THEN
    RAISE EXCEPTION 'Content batch batch-13-listening is missing managed lessons rows';
  END IF;
  IF (SELECT COUNT(*) FROM public.vocabulary WHERE id = ANY(ARRAY['ad88cae0-45c5-50aa-b861-be3954202db7'::UUID, '0c1e3514-9447-58d2-b018-7ff1eed82517'::UUID, 'ba89f0a3-e149-5e7e-a4ce-08f7eacf6b0d'::UUID, 'eb8a9a03-b496-51d0-a8c0-4fa7e86e25e3'::UUID, '463c69c2-8525-5d3b-9e7c-dd42964961f9'::UUID, '8ee3849c-5958-5d87-b614-3e4917a1195f'::UUID, '2dd6519b-e9d3-5d76-9ed4-38ed235a67fc'::UUID, 'bee86a6e-9f0f-5117-ab28-250ef682043f'::UUID, '72d68fa5-ba3a-5c5d-8092-7c0b7f48145c'::UUID, 'a70b8bf4-465b-5477-84d1-173dc60671d7'::UUID, 'b50dec50-5576-596f-b0ea-6369615bc487'::UUID, 'd047ce05-6cc8-523d-bd59-9b527ba95349'::UUID]::UUID[])) <> 12 THEN
    RAISE EXCEPTION 'Content batch batch-13-listening is missing managed vocabulary rows';
  END IF;
  IF (SELECT COUNT(*) FROM public.grammar_lessons WHERE id = ANY(ARRAY['e8f641eb-4f5a-5f60-be3f-3f6d7d9bbf30'::UUID, '7d08e43f-db2a-58ce-87f4-1da0f2638fef'::UUID, 'dcb5ec2a-33b8-5d39-9a94-c365044801fe'::UUID, '23f5d00e-57ee-5bad-853d-eee7520ff864'::UUID]::UUID[])) <> 4 THEN
    RAISE EXCEPTION 'Content batch batch-13-listening is missing managed grammar_lessons rows';
  END IF;
  IF (SELECT COUNT(*) FROM public.exercises WHERE id = ANY(ARRAY['5ee1cea4-3f37-5ccd-b56e-474bc33118c0'::UUID, '67807cb6-ab59-56e0-8717-519a00b53370'::UUID, '7b9aa2bb-2268-51d4-b7f8-910bee6cc97f'::UUID, 'a055cce2-fb63-5e99-9481-9d2d32c9162a'::UUID, '3988a0c4-2166-5200-a9a3-11f37f8ed5e5'::UUID, 'cb1c9272-a3b3-5c69-a0c7-eb347bd29a29'::UUID, 'bc8b6166-510b-5051-9248-6fa56767d1d0'::UUID, 'fa0a4661-e6c3-5c87-b9b2-99982d905429'::UUID, 'c9dc2f5c-0d09-530f-ad41-68cfaa49af92'::UUID, '3e53d5b5-656e-578c-8dba-937d82b6acd1'::UUID, '23885421-58fd-5fa2-9b61-4928922f7d3f'::UUID, 'f75cee64-b58b-5d51-a818-ffd42a3b1fea'::UUID, '578979db-166c-528c-8ce2-aaaef8dd5be9'::UUID, '706ef840-5f24-50d4-813b-2271041915bd'::UUID, '7801e85b-e79c-5dd0-aff5-56eb1089dd81'::UUID, 'd3164e40-fbbf-5e72-9f10-7e7df7971272'::UUID, 'ac867853-9ea2-5013-b530-08d9add73056'::UUID, '0ed023a4-9949-537d-9cc3-8b5c4b7d2d48'::UUID, '9a5c71d9-fa4b-57fb-9205-1ca63bf0a687'::UUID, 'ea7a348a-f70e-5358-9c12-f6a79f30b0b7'::UUID, '1074fec4-15d2-58a1-abcd-8a38cf251668'::UUID, 'e474f247-46d3-547d-8800-830b75a2a9de'::UUID, '40c85402-8550-5454-b71f-b0713fd3d07f'::UUID, 'cff59ea1-1087-5b82-bee9-6c45a46e840b'::UUID, '0862ab83-dddb-5072-8863-2d84165239d2'::UUID, '92b4edcc-0ce0-57a1-a5d2-2eb448124b35'::UUID, '5da8d6a8-f125-58d2-a4d5-1f323a61b668'::UUID, 'fd3d0f6c-ce0a-5f63-b0ba-5c1147279dc9'::UUID, '533a144d-1bca-504f-b752-ad6a2185fbad'::UUID, 'ea430ec7-4722-56ba-bb88-e851347f0002'::UUID, 'fc11ad1b-4c36-5605-8f35-3f64ce6d1dd7'::UUID, '9e4388c0-8762-5cf0-b093-25f162bdbcb0'::UUID, '12f5bf1c-4fe2-5d84-a636-3adcb9dc4b22'::UUID, 'b5b1d4ba-4b52-558e-a3c2-a3cc3bd3e0f7'::UUID, '5c9f6d6e-2aad-52ac-aa2b-57afb6e1da84'::UUID, '9e4814dd-5efa-516b-8f20-e1132eb4f184'::UUID, 'edd09200-ac31-5b82-9260-eaf6c0ef7dd5'::UUID]::UUID[])) <> 37 THEN
    RAISE EXCEPTION 'Content batch batch-13-listening is missing managed exercises rows';
  END IF;
  IF (SELECT COUNT(*) FROM public.exercise_options WHERE id = ANY(ARRAY['5ae504cd-0aa5-59fd-84e0-03f77254194e'::UUID, '8916c46f-7377-5e3e-af28-eb691ddc7cda'::UUID, 'b6627252-f5a3-5e24-89f9-fba8c6eaab7a'::UUID, '0ff6f450-652c-543a-9e1f-a22c2c44c251'::UUID, 'a676b150-5c51-5402-9824-7f74b70a936b'::UUID, 'a1ca014f-ca17-595e-88cd-fe7b5737f593'::UUID, 'ecffd7bb-bbbd-537e-b785-08a69e31ad85'::UUID, '9890ff9c-51b8-5b28-b55d-672cc63444ad'::UUID, 'f1382dcc-a63a-5ed0-bad3-78fd529aad48'::UUID, '04e7c457-9aa5-5316-a742-0bcb741dd322'::UUID, 'f59103c7-54bc-5891-a937-cb3b4de4e228'::UUID, 'dedd86a2-5f3c-5383-81b5-b94c4aa91cf7'::UUID, '15f9d3c6-797e-5cdf-88d9-3d65069c3889'::UUID, '84a8be22-b2eb-5bbd-ad44-46cb82592ef8'::UUID, 'dcfd0043-f42a-5c4a-80e0-b490ab329d41'::UUID, 'ab99606b-9d18-5d90-8522-7ba2e523fbaa'::UUID, '17760bda-bc58-549b-ae10-ef8a48ef63cb'::UUID, '77beca62-e7c6-5f8b-9483-8c3bc1261d01'::UUID, '588a9610-dbaf-5513-a17a-87d6996b452c'::UUID, 'b9ba7848-89e0-534f-8970-7b2787adfba5'::UUID, 'ca3a1024-9be6-5886-986b-be4345408f1a'::UUID, '1b0ce508-cbe5-5e0d-8740-74cf7316432e'::UUID, '26a43703-ae88-51ad-b720-ae8605a97370'::UUID, 'b20ea172-c584-5f46-9e7b-44370e0c8bc8'::UUID, '41ed8e9b-aa27-53db-b023-69c3f929da67'::UUID, 'a5afe046-aa64-56db-8df1-d24e58f85141'::UUID, '3fc75e44-d950-5d93-89a3-734ba393e20c'::UUID, 'fdb627b9-4608-52b4-bffb-9d48ac7cd74d'::UUID, 'f7fab386-4f93-5c80-9a33-de17d4293ccf'::UUID, 'a794f2a4-1e02-5771-b6ec-32ee1fee4869'::UUID]::UUID[])) <> 30 THEN
    RAISE EXCEPTION 'Content batch batch-13-listening is missing managed exercise_options rows';
  END IF;
  IF EXISTS (
    SELECT 1 FROM public.lessons AS lesson
    WHERE lesson.id = ANY(ARRAY['8817f87c-9ee1-5fbd-8a5e-eee67c1f8932'::UUID, 'b37d05ac-6356-5150-9b84-4f202ce43f2a'::UUID, '21fb3baa-b626-55d9-a92f-25218e98eed4'::UUID, '49115d06-8714-5dbb-9d71-201f1899261a'::UUID, '8164cd33-11ec-507f-8732-3aaca12431bd'::UUID]::UUID[])
      AND NOT EXISTS (
        SELECT 1 FROM public.exercises AS exercise
        WHERE exercise.lesson_id = lesson.id
      )
  ) THEN
    RAISE EXCEPTION 'Content batch batch-13-listening contains a lesson without exercises';
  END IF;
  IF EXISTS (
    SELECT 1
    FROM public.lessons AS lesson
    JOIN public.exercises AS exercise ON exercise.lesson_id = lesson.id
    WHERE lesson.id = ANY(ARRAY['8817f87c-9ee1-5fbd-8a5e-eee67c1f8932'::UUID, 'b37d05ac-6356-5150-9b84-4f202ce43f2a'::UUID, '21fb3baa-b626-55d9-a92f-25218e98eed4'::UUID, '49115d06-8714-5dbb-9d71-201f1899261a'::UUID, '8164cd33-11ec-507f-8732-3aaca12431bd'::UUID]::UUID[])
      AND lesson.status = 'published'
      AND exercise.exercise_type = 'listening'
      AND NULLIF(BTRIM(exercise.question_audio_url), '') IS NULL
  ) THEN
    RAISE EXCEPTION 'Published listening exercise is missing playable audio';
  END IF;
  IF EXISTS (
    SELECT 1
    FROM public.exercises AS exercise
    WHERE exercise.id = ANY(ARRAY['5ee1cea4-3f37-5ccd-b56e-474bc33118c0'::UUID, '67807cb6-ab59-56e0-8717-519a00b53370'::UUID, '7b9aa2bb-2268-51d4-b7f8-910bee6cc97f'::UUID, 'a055cce2-fb63-5e99-9481-9d2d32c9162a'::UUID, '3988a0c4-2166-5200-a9a3-11f37f8ed5e5'::UUID, 'cb1c9272-a3b3-5c69-a0c7-eb347bd29a29'::UUID, 'bc8b6166-510b-5051-9248-6fa56767d1d0'::UUID, 'fa0a4661-e6c3-5c87-b9b2-99982d905429'::UUID, 'c9dc2f5c-0d09-530f-ad41-68cfaa49af92'::UUID, '3e53d5b5-656e-578c-8dba-937d82b6acd1'::UUID, '23885421-58fd-5fa2-9b61-4928922f7d3f'::UUID, 'f75cee64-b58b-5d51-a818-ffd42a3b1fea'::UUID, '578979db-166c-528c-8ce2-aaaef8dd5be9'::UUID, '706ef840-5f24-50d4-813b-2271041915bd'::UUID, '7801e85b-e79c-5dd0-aff5-56eb1089dd81'::UUID, 'd3164e40-fbbf-5e72-9f10-7e7df7971272'::UUID, 'ac867853-9ea2-5013-b530-08d9add73056'::UUID, '0ed023a4-9949-537d-9cc3-8b5c4b7d2d48'::UUID, '9a5c71d9-fa4b-57fb-9205-1ca63bf0a687'::UUID, 'ea7a348a-f70e-5358-9c12-f6a79f30b0b7'::UUID, '1074fec4-15d2-58a1-abcd-8a38cf251668'::UUID, 'e474f247-46d3-547d-8800-830b75a2a9de'::UUID, '40c85402-8550-5454-b71f-b0713fd3d07f'::UUID, 'cff59ea1-1087-5b82-bee9-6c45a46e840b'::UUID, '0862ab83-dddb-5072-8863-2d84165239d2'::UUID, '92b4edcc-0ce0-57a1-a5d2-2eb448124b35'::UUID, '5da8d6a8-f125-58d2-a4d5-1f323a61b668'::UUID, 'fd3d0f6c-ce0a-5f63-b0ba-5c1147279dc9'::UUID, '533a144d-1bca-504f-b752-ad6a2185fbad'::UUID, 'ea430ec7-4722-56ba-bb88-e851347f0002'::UUID, 'fc11ad1b-4c36-5605-8f35-3f64ce6d1dd7'::UUID, '9e4388c0-8762-5cf0-b093-25f162bdbcb0'::UUID, '12f5bf1c-4fe2-5d84-a636-3adcb9dc4b22'::UUID, 'b5b1d4ba-4b52-558e-a3c2-a3cc3bd3e0f7'::UUID, '5c9f6d6e-2aad-52ac-aa2b-57afb6e1da84'::UUID, '9e4814dd-5efa-516b-8f20-e1132eb4f184'::UUID, 'edd09200-ac31-5b82-9260-eaf6c0ef7dd5'::UUID]::UUID[])
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
    WHERE link.lesson_id = ANY(ARRAY['8817f87c-9ee1-5fbd-8a5e-eee67c1f8932'::UUID, 'b37d05ac-6356-5150-9b84-4f202ce43f2a'::UUID, '21fb3baa-b626-55d9-a92f-25218e98eed4'::UUID, '49115d06-8714-5dbb-9d71-201f1899261a'::UUID, '8164cd33-11ec-507f-8732-3aaca12431bd'::UUID]::UUID[])
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
