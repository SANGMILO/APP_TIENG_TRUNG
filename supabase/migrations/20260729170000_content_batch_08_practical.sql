-- Generated from content/manifests/08_practical.json.
-- Do not hand-edit this migration; edit the manifest and regenerate.
-- Additive and idempotent: deterministic IDs plus ON CONFLICT DO NOTHING.

BEGIN;

INSERT INTO public.courses (id, slug, title, title_zh, description, level, status, order_index, learning_objectives, estimated_minutes, content_version)
VALUES ('5e346c4f-a5e2-5a27-a57b-68a14518cc1b'::UUID, 'practical-conversation', 'Practical Chinese Conversation', '实用汉语会话', 'Hội thoại thực dụng cho các tình huống hằng ngày.', 'beginner', 'review', 8, '["Mở và duy trì hội thoại","Xử lý yêu cầu thường ngày","Phản hồi lịch sự và tự nhiên"]'::JSONB, 78, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.units (id, course_id, slug, title, description, order_index, status, learning_objectives, content_version)
VALUES ('f672de92-ca90-5c58-8fe9-7b637acadf7b'::UUID, '5e346c4f-a5e2-5a27-a57b-68a14518cc1b'::UUID, 'practical-nen-tang', 'Nền tảng', 'Xây dựng ngôn ngữ cốt lõi của lộ trình.', 1, 'review', '["Mở và duy trì hội thoại","Xử lý yêu cầu thường ngày"]'::JSONB, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.chapters (id, unit_id, slug, title, description, order_index, status, learning_objectives, content_version)
VALUES ('08042119-e055-5f66-b68c-c0b7eb3ae8ac'::UUID, 'f672de92-ca90-5c58-8fe9-7b637acadf7b'::UUID, 'practical-nen-tang-chapter', 'Khái niệm cốt lõi', 'Xây dựng ngôn ngữ cốt lõi của lộ trình.', 1, 'review', '["Mở và duy trì hội thoại","Xử lý yêu cầu thường ngày"]'::JSONB, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lessons (id, chapter_id, slug, title, description, order_index, xp_reward, status, lesson_type, estimated_minutes, learning_objectives, cultural_note, content_version)
VALUES ('ee68f5eb-fabe-589d-b1e5-262217b63e76'::UUID, '08042119-e055-5f66-b68c-c0b7eb3ae8ac'::UUID, 'hen-gap', '约时间 — Hẹn gặp', 'Thống nhất thời gian và địa điểm.', 1, 25, 'review', 'standard', 15, '["Hẹn gặp rõ ràng"]'::JSONB, '吧 không dùng khi cần mệnh lệnh dứt khoát.', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('5fa3c2a1-5901-505a-ab8d-9acf855c3d9e'::UUID, 'practical:方便', '方便', 'fāngbiàn', 'tiện', 'convenient', 'beginner', 'hen-gap', 'tính từ', '你明天下午方便吗？', 'Nǐ míngtiān xiàwǔ fāngbiàn ma?', 'Chiều mai bạn có tiện không?', NULL, 'review', 'ee68f5eb-fabe-589d-b1e5-262217b63e76'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('bef3ed00-4827-59a1-8d22-58e00802c719'::UUID, 'ee68f5eb-fabe-589d-b1e5-262217b63e76'::UUID, '5fa3c2a1-5901-505a-ab8d-9acf855c3d9e'::UUID, 1, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('17ea5b8e-5c55-576e-af55-740a0d3c74fa'::UUID, 'practical:见面', '见面', 'jiànmiàn', 'gặp mặt', 'meet', 'beginner', 'hen-gap', 'động từ', '我们周末见面吧。', 'Wǒmen zhōumò jiànmiàn ba.', 'Cuối tuần chúng ta gặp nhau nhé.', NULL, 'review', 'ee68f5eb-fabe-589d-b1e5-262217b63e76'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('0a7e5e1b-c784-54b6-b68a-a63d8c97c43a'::UUID, 'ee68f5eb-fabe-589d-b1e5-262217b63e76'::UUID, '17ea5b8e-5c55-576e-af55-740a0d3c74fa'::UUID, 2, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('1a4412b2-1345-5ee9-a316-c70445bab48a'::UUID, 'practical:确定', '确定', 'quèdìng', 'xác định', 'confirm', 'beginner', 'hen-gap', 'động từ', '时间确定以后告诉我。', 'Shíjiān quèdìng yǐhòu gàosu wǒ.', 'Sau khi chốt thời gian hãy báo tôi.', NULL, 'review', 'ee68f5eb-fabe-589d-b1e5-262217b63e76'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('9ab86709-5168-5ef7-afcf-6f56e63b4fff'::UUID, 'ee68f5eb-fabe-589d-b1e5-262217b63e76'::UUID, '1a4412b2-1345-5ee9-a316-c70445bab48a'::UUID, 3, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.grammar_lessons (id, content_key, title, pattern, explanation, example_chinese, example_pinyin, example_meaning, level, status, usage_note, content_version)
VALUES ('db723cb0-5977-5726-be32-0c3c7815be6d'::UUID, 'practical:hen-gap', 'Đề nghị với 吧', 'câu đề nghị + 吧', '吧 làm đề nghị mềm và thân thiện.', '我们下午三点见面吧。', 'Wǒmen xiàwǔ sān diǎn jiànmiàn ba.', 'Chúng ta gặp nhau lúc ba giờ chiều nhé.', 'beginner', 'review', NULL, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_grammar (id, lesson_id, grammar_lesson_id, order_index, curriculum_role)
VALUES ('7b8a9678-6213-5804-9446-499a5f85a47d'::UUID, 'ee68f5eb-fabe-589d-b1e5-262217b63e76'::UUID, 'db723cb0-5977-5726-be32-0c3c7815be6d'::UUID, 1, 'introduced')
ON CONFLICT (lesson_id, grammar_lesson_id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('6a187d79-c1f4-5550-9c9d-abd13625dc7c'::UUID, 'ee68f5eb-fabe-589d-b1e5-262217b63e76'::UUID, 'vocabulary', 1, 'Từ mới: 方便', NULL, '方便', '方便 (fāngbiàn) — tiện. 你明天下午方便吗？', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"practical:方便","chinese":"方便","pinyin":"fāngbiàn","meaning":"tiện","part_of_speech":"tính từ","example_chinese":"你明天下午方便吗？","example_pinyin":"Nǐ míngtiān xiàwǔ fāngbiàn ma?","example_meaning_vi":"Chiều mai bạn có tiện không?"}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('83d8acf9-3734-53a9-945b-ea2f595a9f0b'::UUID, 'ee68f5eb-fabe-589d-b1e5-262217b63e76'::UUID, 'vocabulary', 2, 'Từ mới: 见面', NULL, '见面', '见面 (jiànmiàn) — gặp mặt. 我们周末见面吧。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"practical:见面","chinese":"见面","pinyin":"jiànmiàn","meaning":"gặp mặt","part_of_speech":"động từ","example_chinese":"我们周末见面吧。","example_pinyin":"Wǒmen zhōumò jiànmiàn ba.","example_meaning_vi":"Cuối tuần chúng ta gặp nhau nhé."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('c0f95879-fc50-51bd-a6a3-4a082f3ce761'::UUID, 'ee68f5eb-fabe-589d-b1e5-262217b63e76'::UUID, 'vocabulary', 3, 'Từ mới: 确定', NULL, '确定', '确定 (quèdìng) — xác định. 时间确定以后告诉我。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"practical:确定","chinese":"确定","pinyin":"quèdìng","meaning":"xác định","part_of_speech":"động từ","example_chinese":"时间确定以后告诉我。","example_pinyin":"Shíjiān quèdìng yǐhòu gàosu wǒ.","example_meaning_vi":"Sau khi chốt thời gian hãy báo tôi."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('64b82cc1-7177-5715-9d16-8298c63ab34d'::UUID, 'ee68f5eb-fabe-589d-b1e5-262217b63e76'::UUID, 'multiple_choice', 4, '“方便” có nghĩa phù hợp nhất là gì?', NULL, 'tiện', '方便 (fāngbiàn) nghĩa là “tiện”.', NULL, 1, '{"activity_type":"chinese_to_vietnamese","vocabulary_key":"practical:方便"}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('3d7b9900-ea35-5cfb-b668-8c877f705d3b'::UUID, '64b82cc1-7177-5715-9d16-8298c63ab34d'::UUID, 'tiện', TRUE, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('995ef4c8-0da8-5c28-b69d-59411761ca78'::UUID, '64b82cc1-7177-5715-9d16-8298c63ab34d'::UUID, 'gặp mặt', FALSE, 2)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('c30c8c63-e17d-5e5e-80a3-437ce3eb5b4d'::UUID, '64b82cc1-7177-5715-9d16-8298c63ab34d'::UUID, 'xác định', FALSE, 3)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('397464ca-f1d3-5947-ae6c-8273daad273d'::UUID, 'ee68f5eb-fabe-589d-b1e5-262217b63e76'::UUID, 'translation', 5, 'Dịch sang tiếng Trung: “Chúng ta gặp nhau lúc ba giờ chiều nhé.”', NULL, '我们下午三点见面吧。', 'Mẫu câu dùng “方便” trong ngữ cảnh của bài.', 'fāngbiàn', 1, '{"activity_type":"vietnamese_to_chinese","source_lang":"vi","target_lang":"zh","acceptable_answers":["我们下午三点见面吧。"]}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('d2c7abfe-e1e2-5d44-a24a-e72d4ebcc1f5'::UUID, 'ee68f5eb-fabe-589d-b1e5-262217b63e76'::UUID, 'sentence_builder', 6, 'Sắp xếp các thành phần thành câu đúng.', NULL, '我们下午三点见面吧。', 'Trật tự đúng tạo thành câu “我们下午三点见面吧。”.', NULL, 1, '{"activity_type":"sentence_ordering","words":["我们","下午","三点","见面","吧","。"],"correct_order":["我们","下午","三点","见面","吧","。"]}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('0ff6b2f9-41e4-5545-ae86-f1a09a6708de'::UUID, 'ee68f5eb-fabe-589d-b1e5-262217b63e76'::UUID, 'multiple_choice', 7, 'Câu nào là một lời đề nghị tự nhiên?', NULL, '我们下午三点见面吧。', '吧 làm đề nghị mềm và thân thiện.', NULL, 1, '{"activity_type":"grammar_selection","passage":null,"grammar_key":"practical:hen-gap"}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('f4f7894b-0b0b-5685-88f1-f6e96093486b'::UUID, '0ff6b2f9-41e4-5545-ae86-f1a09a6708de'::UUID, '我们下午三点见面吧。', TRUE, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('e49c9c13-57d2-5f12-a134-6ced21741b72'::UUID, '0ff6b2f9-41e4-5545-ae86-f1a09a6708de'::UUID, '。吧见面三点下午我们', FALSE, 2)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('9a2d4372-3521-5045-98cb-0691f012d784'::UUID, '0ff6b2f9-41e4-5545-ae86-f1a09a6708de'::UUID, '下午三点见面吧。我们', FALSE, 3)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('face1d13-2c85-5c37-8e17-35082cbbc56e'::UUID, 'ee68f5eb-fabe-589d-b1e5-262217b63e76'::UUID, 'speaking', 8, 'Đọc thành tiếng: 我们下午三点见面吧。', NULL, '我们下午三点见面吧。', 'Đọc chậm, giữ đúng thanh điệu và nhịp của cả câu.', NULL, 1, '{"activity_type":"pronunciation","text":"我们下午三点见面吧。","pinyin":"Wǒmen xiàwǔ sān diǎn jiànmiàn ba."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lessons (id, chapter_id, slug, title, description, order_index, xp_reward, status, lesson_type, estimated_minutes, learning_objectives, cultural_note, content_version)
VALUES ('fc2485b6-51de-5b52-8b9a-8885712cb10b'::UUID, '08042119-e055-5f66-b68c-c0b7eb3ae8ac'::UUID, 'goi-dien', '打电话 — Gọi điện', 'Mở đầu và chuyển cuộc gọi.', 2, 25, 'review', 'standard', 15, '["Xác nhận người nghe qua điện thoại"]'::JSONB, '喂 trong cuộc gọi đọc wéi thanh 2.', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('9196bfab-018a-5d03-b913-339b09ddce8e'::UUID, 'practical:接', '接', 'jiē', 'nghe, nhận', 'answer; receive', 'beginner', 'goi-dien', 'động từ', '他现在不能接电话。', 'Tā xiànzài bù néng jiē diànhuà.', 'Bây giờ anh ấy không thể nghe điện thoại.', NULL, 'review', 'fc2485b6-51de-5b52-8b9a-8885712cb10b'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('1109f770-65e4-52fd-aa7f-10472017e57a'::UUID, 'fc2485b6-51de-5b52-8b9a-8885712cb10b'::UUID, '9196bfab-018a-5d03-b913-339b09ddce8e'::UUID, 1, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('717df9e1-01c0-5c2f-90d2-7c4a4e3833cc'::UUID, 'practical:稍等', '稍等', 'shāoděng', 'xin chờ một chút', 'wait a moment', 'beginner', 'goi-dien', 'động từ', '请稍等，我帮您转接。', 'Qǐng shāoděng, wǒ bāng nín zhuǎnjiē.', 'Xin chờ một chút, tôi sẽ chuyển máy.', NULL, 'review', 'fc2485b6-51de-5b52-8b9a-8885712cb10b'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('9f5f60f3-b8e6-572a-934f-9e902f76960d'::UUID, 'fc2485b6-51de-5b52-8b9a-8885712cb10b'::UUID, '717df9e1-01c0-5c2f-90d2-7c4a4e3833cc'::UUID, 2, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('11c388df-46ea-5406-8e14-f3fb93ee9608'::UUID, 'practical:留言', '留言', 'liúyán', 'để lại lời nhắn', 'leave a message', 'beginner', 'goi-dien', 'động từ/danh từ', '您需要留言吗？', 'Nín xūyào liúyán ma?', 'Ngài có cần để lại lời nhắn không?', NULL, 'review', 'fc2485b6-51de-5b52-8b9a-8885712cb10b'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('798fed90-1632-56fd-8530-65df217552ed'::UUID, 'fc2485b6-51de-5b52-8b9a-8885712cb10b'::UUID, '11c388df-46ea-5406-8e14-f3fb93ee9608'::UUID, 3, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('d897dc2c-3115-5f19-a9fb-ce231653f0d3'::UUID, 'fc2485b6-51de-5b52-8b9a-8885712cb10b'::UUID, '5fa3c2a1-5901-505a-ab8d-9acf855c3d9e'::UUID, 4, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('7e14a87d-64d3-5f49-8ac1-6065afcad222'::UUID, 'fc2485b6-51de-5b52-8b9a-8885712cb10b'::UUID, '17ea5b8e-5c55-576e-af55-740a0d3c74fa'::UUID, 5, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('feff79c2-b166-5a16-a2c0-cc26682dfd42'::UUID, 'fc2485b6-51de-5b52-8b9a-8885712cb10b'::UUID, '1a4412b2-1345-5ee9-a316-c70445bab48a'::UUID, 6, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.grammar_lessons (id, content_key, title, pattern, explanation, example_chinese, example_pinyin, example_meaning, level, status, usage_note, content_version)
VALUES ('c88b2741-c3e1-5317-826a-e35b0ef60776'::UUID, 'practical:goi-dien', 'Cách tự giới thiệu qua điện thoại', '喂，您好，我是…', 'Nêu tên sau lời chào để người nghe nhanh chóng xác định người gọi.', '喂，您好，我是小林。', 'Wéi, nín hǎo, wǒ shì Xiǎolín.', 'A lô, xin chào, tôi là Tiểu Lâm.', 'beginner', 'review', NULL, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_grammar (id, lesson_id, grammar_lesson_id, order_index, curriculum_role)
VALUES ('23b6c1e8-5440-5ef5-8886-0423c2f93f22'::UUID, 'fc2485b6-51de-5b52-8b9a-8885712cb10b'::UUID, 'c88b2741-c3e1-5317-826a-e35b0ef60776'::UUID, 1, 'introduced')
ON CONFLICT (lesson_id, grammar_lesson_id) DO NOTHING;

INSERT INTO public.lesson_grammar (id, lesson_id, grammar_lesson_id, order_index, curriculum_role)
VALUES ('f36a56f9-d950-5c6b-91ca-09c1d892dd95'::UUID, 'fc2485b6-51de-5b52-8b9a-8885712cb10b'::UUID, 'db723cb0-5977-5726-be32-0c3c7815be6d'::UUID, 2, 'review')
ON CONFLICT (lesson_id, grammar_lesson_id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('875e6c8d-de20-5291-8c79-9e9127196bc8'::UUID, 'fc2485b6-51de-5b52-8b9a-8885712cb10b'::UUID, 'vocabulary', 1, 'Từ mới: 接', NULL, '接', '接 (jiē) — nghe, nhận. 他现在不能接电话。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"practical:接","chinese":"接","pinyin":"jiē","meaning":"nghe, nhận","part_of_speech":"động từ","example_chinese":"他现在不能接电话。","example_pinyin":"Tā xiànzài bù néng jiē diànhuà.","example_meaning_vi":"Bây giờ anh ấy không thể nghe điện thoại."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('7ea5e70d-59db-5a24-94be-56ca668f8e5f'::UUID, 'fc2485b6-51de-5b52-8b9a-8885712cb10b'::UUID, 'vocabulary', 2, 'Từ mới: 稍等', NULL, '稍等', '稍等 (shāoděng) — xin chờ một chút. 请稍等，我帮您转接。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"practical:稍等","chinese":"稍等","pinyin":"shāoděng","meaning":"xin chờ một chút","part_of_speech":"động từ","example_chinese":"请稍等，我帮您转接。","example_pinyin":"Qǐng shāoděng, wǒ bāng nín zhuǎnjiē.","example_meaning_vi":"Xin chờ một chút, tôi sẽ chuyển máy."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('6b71ad2e-cab1-5472-9b42-cd777e3655d1'::UUID, 'fc2485b6-51de-5b52-8b9a-8885712cb10b'::UUID, 'vocabulary', 3, 'Từ mới: 留言', NULL, '留言', '留言 (liúyán) — để lại lời nhắn. 您需要留言吗？', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"practical:留言","chinese":"留言","pinyin":"liúyán","meaning":"để lại lời nhắn","part_of_speech":"động từ/danh từ","example_chinese":"您需要留言吗？","example_pinyin":"Nín xūyào liúyán ma?","example_meaning_vi":"Ngài có cần để lại lời nhắn không?"}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('206b2380-8ecf-57c8-aad3-79af1b553b93'::UUID, 'fc2485b6-51de-5b52-8b9a-8885712cb10b'::UUID, 'multiple_choice', 4, '“接” có nghĩa phù hợp nhất là gì?', NULL, 'nghe, nhận', '接 (jiē) nghĩa là “nghe, nhận”.', NULL, 1, '{"activity_type":"chinese_to_vietnamese","vocabulary_key":"practical:接"}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('b8a948fb-bd76-55ac-9af2-1b10a2a9962e'::UUID, '206b2380-8ecf-57c8-aad3-79af1b553b93'::UUID, 'nghe, nhận', TRUE, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('c59f0c23-816d-5519-aa79-285d21a429dd'::UUID, '206b2380-8ecf-57c8-aad3-79af1b553b93'::UUID, 'xin chờ một chút', FALSE, 2)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('5adf5a2a-9b0f-591b-a425-b846a8611b33'::UUID, '206b2380-8ecf-57c8-aad3-79af1b553b93'::UUID, 'để lại lời nhắn', FALSE, 3)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('6cda327b-49a2-5244-9190-94270bf5efeb'::UUID, 'fc2485b6-51de-5b52-8b9a-8885712cb10b'::UUID, 'translation', 5, 'Dịch sang tiếng Trung: “A lô, xin chào, tôi là Tiểu Lâm.”', NULL, '喂，您好，我是小林。', 'Mẫu câu dùng “接” trong ngữ cảnh của bài.', 'jiē', 1, '{"activity_type":"vietnamese_to_chinese","source_lang":"vi","target_lang":"zh","acceptable_answers":["喂，您好，我是小林。"]}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('eb333072-b3ff-53c7-a957-3d4e7345f528'::UUID, 'fc2485b6-51de-5b52-8b9a-8885712cb10b'::UUID, 'sentence_builder', 6, 'Sắp xếp các thành phần thành câu đúng.', NULL, '喂，您好，我是小林。', 'Trật tự đúng tạo thành câu “喂，您好，我是小林。”.', NULL, 1, '{"activity_type":"sentence_ordering","words":["喂，","您好，","我","是","小林","。"],"correct_order":["喂，","您好，","我","是","小林","。"]}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('04332134-4499-511a-b363-d9a62aac088f'::UUID, 'fc2485b6-51de-5b52-8b9a-8885712cb10b'::UUID, 'multiple_choice', 7, 'Câu mở đầu điện thoại nào tự nhiên?', NULL, '喂，您好，我是小林。', 'Nêu tên sau lời chào để người nghe nhanh chóng xác định người gọi.', NULL, 1, '{"activity_type":"grammar_selection","passage":null,"grammar_key":"practical:goi-dien"}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('4c1127a1-42e0-5e7e-9d85-a6ae849db793'::UUID, '04332134-4499-511a-b363-d9a62aac088f'::UUID, '喂，您好，我是小林。', TRUE, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('34f7e844-c5ff-5b80-82a6-3961551d048c'::UUID, '04332134-4499-511a-b363-d9a62aac088f'::UUID, '。小林是我您好，喂，', FALSE, 2)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('21c1748c-a63a-57c6-bd27-b6345d2b5162'::UUID, '04332134-4499-511a-b363-d9a62aac088f'::UUID, '您好，我是小林。喂，', FALSE, 3)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('5a327f34-032c-5f59-9fc8-c7a6713a6b27'::UUID, 'fc2485b6-51de-5b52-8b9a-8885712cb10b'::UUID, 'speaking', 8, 'Đọc thành tiếng: 喂，您好，我是小林。', NULL, '喂，您好，我是小林。', 'Đọc chậm, giữ đúng thanh điệu và nhịp của cả câu.', NULL, 1, '{"activity_type":"pronunciation","text":"喂，您好，我是小林。","pinyin":"Wéi, nín hǎo, wǒ shì Xiǎolín."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.units (id, course_id, slug, title, description, order_index, status, learning_objectives, content_version)
VALUES ('7285924c-1bc5-5521-a320-6c47659a4de6'::UUID, '5e346c4f-a5e2-5a27-a57b-68a14518cc1b'::UUID, 'practical-van-dung', 'Vận dụng', 'Vận dụng mẫu câu trong ngữ cảnh có ý nghĩa.', 2, 'review', '["Xử lý yêu cầu thường ngày","Phản hồi lịch sự và tự nhiên"]'::JSONB, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.chapters (id, unit_id, slug, title, description, order_index, status, learning_objectives, content_version)
VALUES ('011a0219-2f28-5f9b-827a-8bad043ca2cb'::UUID, '7285924c-1bc5-5521-a320-6c47659a4de6'::UUID, 'practical-van-dung-chapter', 'Ngữ cảnh thực tế', 'Vận dụng mẫu câu trong ngữ cảnh có ý nghĩa.', 1, 'review', '["Xử lý yêu cầu thường ngày","Phản hồi lịch sự và tự nhiên"]'::JSONB, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lessons (id, chapter_id, slug, title, description, order_index, xp_reward, status, lesson_type, estimated_minutes, learning_objectives, cultural_note, content_version)
VALUES ('566b44ab-4b81-5312-9dba-8542eb71fe65'::UUID, '011a0219-2f28-5f9b-827a-8bad043ca2cb'::UUID, 'nho-giup', '能帮个忙吗？— Nhờ giúp', 'Đưa ra yêu cầu lịch sự.', 1, 25, 'review', 'standard', 15, '["Nhờ giúp và cảm ơn"]'::JSONB, 'Thêm 一下 làm hành động nghe nhẹ hơn.', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('6bf8921e-0c1c-5ef7-b65d-25af0bcde014'::UUID, 'practical:帮忙', '帮忙', 'bāngmáng', 'giúp đỡ', 'help', 'beginner', 'nho-giup', 'động từ', '你能帮我一个忙吗？', 'Nǐ néng bāng wǒ yí ge máng ma?', 'Bạn có thể giúp tôi một việc không?', NULL, 'review', '566b44ab-4b81-5312-9dba-8542eb71fe65'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('66309774-db2e-5b8a-a2bb-69b212170da2'::UUID, '566b44ab-4b81-5312-9dba-8542eb71fe65'::UUID, '6bf8921e-0c1c-5ef7-b65d-25af0bcde014'::UUID, 1, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('4494b70e-f673-5bf6-9819-5525c50d0320'::UUID, 'practical:麻烦', '麻烦', 'máfan', 'phiền; làm phiền', 'trouble', 'beginner', 'nho-giup', 'động từ/tính từ', '麻烦你再说一遍。', 'Máfan nǐ zài shuō yí biàn.', 'Phiền bạn nói lại một lần.', NULL, 'review', '566b44ab-4b81-5312-9dba-8542eb71fe65'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('6a3946fa-75b1-5c70-afaf-6b492730ec50'::UUID, '566b44ab-4b81-5312-9dba-8542eb71fe65'::UUID, '4494b70e-f673-5bf6-9819-5525c50d0320'::UUID, 2, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('f046cd8e-133f-51a9-9c21-932bc23c3e77'::UUID, 'practical:当然', '当然', 'dāngrán', 'tất nhiên', 'of course', 'beginner', 'nho-giup', 'phó từ', '当然可以，没问题。', 'Dāngrán kěyǐ, méi wèntí.', 'Tất nhiên được, không vấn đề.', NULL, 'review', '566b44ab-4b81-5312-9dba-8542eb71fe65'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('8b2eaa1f-8482-5d25-9d37-c139ec960293'::UUID, '566b44ab-4b81-5312-9dba-8542eb71fe65'::UUID, 'f046cd8e-133f-51a9-9c21-932bc23c3e77'::UUID, 3, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('b34363b3-0a85-57d9-87ba-c95fa527fd6b'::UUID, '566b44ab-4b81-5312-9dba-8542eb71fe65'::UUID, '9196bfab-018a-5d03-b913-339b09ddce8e'::UUID, 4, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('0ac6e0bf-1c6b-5319-8baf-0087e1735791'::UUID, '566b44ab-4b81-5312-9dba-8542eb71fe65'::UUID, '717df9e1-01c0-5c2f-90d2-7c4a4e3833cc'::UUID, 5, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('cad6f06b-f90d-5218-a975-f29096616002'::UUID, '566b44ab-4b81-5312-9dba-8542eb71fe65'::UUID, '11c388df-46ea-5406-8e14-f3fb93ee9608'::UUID, 6, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.grammar_lessons (id, content_key, title, pattern, explanation, example_chinese, example_pinyin, example_meaning, level, status, usage_note, content_version)
VALUES ('a0715850-efa3-59f2-b0db-412e5bae0420'::UUID, 'practical:nho-giup', 'Yêu cầu lịch sự với 能…吗', '能 + động từ + 吗', 'Dạng câu hỏi khả năng làm yêu cầu bớt trực tiếp.', '你能帮我拿一下吗？', 'Nǐ néng bāng wǒ ná yíxià ma?', 'Bạn có thể giúp tôi cầm một chút không?', 'beginner', 'review', NULL, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_grammar (id, lesson_id, grammar_lesson_id, order_index, curriculum_role)
VALUES ('178a44d0-1049-5855-8388-f16aff0b9727'::UUID, '566b44ab-4b81-5312-9dba-8542eb71fe65'::UUID, 'a0715850-efa3-59f2-b0db-412e5bae0420'::UUID, 1, 'introduced')
ON CONFLICT (lesson_id, grammar_lesson_id) DO NOTHING;

INSERT INTO public.lesson_grammar (id, lesson_id, grammar_lesson_id, order_index, curriculum_role)
VALUES ('c5e7fb55-6b88-50c0-8990-cf23b7672244'::UUID, '566b44ab-4b81-5312-9dba-8542eb71fe65'::UUID, 'c88b2741-c3e1-5317-826a-e35b0ef60776'::UUID, 2, 'review')
ON CONFLICT (lesson_id, grammar_lesson_id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('bb398a57-e39b-5093-a72c-7d7d3f90319c'::UUID, '566b44ab-4b81-5312-9dba-8542eb71fe65'::UUID, 'vocabulary', 1, 'Từ mới: 帮忙', NULL, '帮忙', '帮忙 (bāngmáng) — giúp đỡ. 你能帮我一个忙吗？', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"practical:帮忙","chinese":"帮忙","pinyin":"bāngmáng","meaning":"giúp đỡ","part_of_speech":"động từ","example_chinese":"你能帮我一个忙吗？","example_pinyin":"Nǐ néng bāng wǒ yí ge máng ma?","example_meaning_vi":"Bạn có thể giúp tôi một việc không?"}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('004936ba-73bf-5119-b895-ed576276cd6e'::UUID, '566b44ab-4b81-5312-9dba-8542eb71fe65'::UUID, 'vocabulary', 2, 'Từ mới: 麻烦', NULL, '麻烦', '麻烦 (máfan) — phiền; làm phiền. 麻烦你再说一遍。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"practical:麻烦","chinese":"麻烦","pinyin":"máfan","meaning":"phiền; làm phiền","part_of_speech":"động từ/tính từ","example_chinese":"麻烦你再说一遍。","example_pinyin":"Máfan nǐ zài shuō yí biàn.","example_meaning_vi":"Phiền bạn nói lại một lần."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('9ae44c4d-1ec1-536e-a61e-ec36e618bb1d'::UUID, '566b44ab-4b81-5312-9dba-8542eb71fe65'::UUID, 'vocabulary', 3, 'Từ mới: 当然', NULL, '当然', '当然 (dāngrán) — tất nhiên. 当然可以，没问题。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"practical:当然","chinese":"当然","pinyin":"dāngrán","meaning":"tất nhiên","part_of_speech":"phó từ","example_chinese":"当然可以，没问题。","example_pinyin":"Dāngrán kěyǐ, méi wèntí.","example_meaning_vi":"Tất nhiên được, không vấn đề."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('051e52e7-541e-5882-a875-d3f179aac53a'::UUID, '566b44ab-4b81-5312-9dba-8542eb71fe65'::UUID, 'multiple_choice', 4, '“帮忙” có nghĩa phù hợp nhất là gì?', NULL, 'giúp đỡ', '帮忙 (bāngmáng) nghĩa là “giúp đỡ”.', NULL, 1, '{"activity_type":"chinese_to_vietnamese","vocabulary_key":"practical:帮忙"}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('7763d851-e395-53d1-8773-f4869381995b'::UUID, '051e52e7-541e-5882-a875-d3f179aac53a'::UUID, 'phiền; làm phiền', FALSE, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('f127d901-e416-5b22-b5d1-f66a393d143e'::UUID, '051e52e7-541e-5882-a875-d3f179aac53a'::UUID, 'tất nhiên', FALSE, 2)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('7eaf257c-a3aa-5a53-86a4-544b54e5ba38'::UUID, '051e52e7-541e-5882-a875-d3f179aac53a'::UUID, 'giúp đỡ', TRUE, 3)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('700640ac-f85c-5f95-b7bb-05b4e3781204'::UUID, '566b44ab-4b81-5312-9dba-8542eb71fe65'::UUID, 'translation', 5, 'Dịch sang tiếng Trung: “Bạn có thể giúp tôi cầm một chút không?”', NULL, '你能帮我拿一下吗？', 'Mẫu câu dùng “帮忙” trong ngữ cảnh của bài.', 'bāngmáng', 1, '{"activity_type":"vietnamese_to_chinese","source_lang":"vi","target_lang":"zh","acceptable_answers":["你能帮我拿一下吗？"]}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('367a8688-9f35-5dd8-9e40-05b239efb57c'::UUID, '566b44ab-4b81-5312-9dba-8542eb71fe65'::UUID, 'sentence_builder', 6, 'Sắp xếp các thành phần thành câu đúng.', NULL, '你能帮我拿一下吗？', 'Trật tự đúng tạo thành câu “你能帮我拿一下吗？”.', NULL, 1, '{"activity_type":"sentence_ordering","words":["你","能","帮","我","拿","一下","吗","？"],"correct_order":["你","能","帮","我","拿","一下","吗","？"]}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('c5dfdc58-3a2c-513f-8564-c05448c9f85c'::UUID, '566b44ab-4b81-5312-9dba-8542eb71fe65'::UUID, 'multiple_choice', 7, 'Câu nhờ giúp nào lịch sự?', NULL, '你能帮我拿一下吗？', 'Dạng câu hỏi khả năng làm yêu cầu bớt trực tiếp.', NULL, 1, '{"activity_type":"grammar_selection","passage":null,"grammar_key":"practical:nho-giup"}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('5b4cebaa-a740-591b-8827-f7c5a877d156'::UUID, 'c5dfdc58-3a2c-513f-8564-c05448c9f85c'::UUID, '你能帮我拿一下吗？', TRUE, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('bd839c05-b88e-5450-8c40-a99ee39e2086'::UUID, 'c5dfdc58-3a2c-513f-8564-c05448c9f85c'::UUID, '？吗一下拿我帮能你', FALSE, 2)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('b8234d90-b003-53d3-9467-c71b61bcb787'::UUID, 'c5dfdc58-3a2c-513f-8564-c05448c9f85c'::UUID, '能帮我拿一下吗？你', FALSE, 3)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('449a8822-ea79-50b4-974d-39e97f59a7fc'::UUID, '566b44ab-4b81-5312-9dba-8542eb71fe65'::UUID, 'speaking', 8, 'Đọc thành tiếng: 你能帮我拿一下吗？', NULL, '你能帮我拿一下吗？', 'Đọc chậm, giữ đúng thanh điệu và nhịp của cả câu.', NULL, 1, '{"activity_type":"pronunciation","text":"你能帮我拿一下吗？","pinyin":"Nǐ néng bāng wǒ ná yíxià ma?"}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lessons (id, chapter_id, slug, title, description, order_index, xp_reward, status, lesson_type, estimated_minutes, learning_objectives, cultural_note, content_version)
VALUES ('041a9c1d-f3e9-586f-b1c2-1c0cda63e6e6'::UUID, '011a0219-2f28-5f9b-827a-8bad043ca2cb'::UUID, 'xu-ly-hieu-lam', '不好意思，我没听清 — Hiểu lầm', 'Yêu cầu làm rõ mà không gây căng thẳng.', 2, 25, 'review', 'standard', 15, '["Sửa hiểu lầm lịch sự"]'::JSONB, 'Không dùng 不听清 để phủ định một kết quả đã xảy ra.', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('440edc44-8b77-5775-a254-4aa1d6b215b0'::UUID, 'practical:听清', '听清', 'tīngqīng', 'nghe rõ', 'hear clearly', 'beginner', 'xu-ly-hieu-lam', 'động từ', '刚才我没听清地址。', 'Gāngcái wǒ méi tīngqīng dìzhǐ.', 'Lúc nãy tôi không nghe rõ địa chỉ.', NULL, 'review', '041a9c1d-f3e9-586f-b1c2-1c0cda63e6e6'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('a74ef4b7-a62d-5bc4-ab07-634b029aa81a'::UUID, '041a9c1d-f3e9-586f-b1c2-1c0cda63e6e6'::UUID, '440edc44-8b77-5775-a254-4aa1d6b215b0'::UUID, 1, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('776c6df3-402e-58e0-8b2f-9cb4ef4132f0'::UUID, 'practical:误会', '误会', 'wùhuì', 'hiểu lầm', 'misunderstand', 'beginner', 'xu-ly-hieu-lam', 'động từ/danh từ', '对不起，这是一个误会。', 'Duìbuqǐ, zhè shì yí ge wùhuì.', 'Xin lỗi, đây là một sự hiểu lầm.', NULL, 'review', '041a9c1d-f3e9-586f-b1c2-1c0cda63e6e6'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('f87e6db5-dcf8-54af-8849-b048933fe7b3'::UUID, '041a9c1d-f3e9-586f-b1c2-1c0cda63e6e6'::UUID, '776c6df3-402e-58e0-8b2f-9cb4ef4132f0'::UUID, 2, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('e05a0962-a117-506f-a3f2-339123cb913e'::UUID, 'practical:解释', '解释', 'jiěshì', 'giải thích', 'explain', 'beginner', 'xu-ly-hieu-lam', 'động từ', '请让我解释一下。', 'Qǐng ràng wǒ jiěshì yíxià.', 'Xin hãy để tôi giải thích một chút.', NULL, 'review', '041a9c1d-f3e9-586f-b1c2-1c0cda63e6e6'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('04838832-32e0-5a91-a089-1d03279ca1fc'::UUID, '041a9c1d-f3e9-586f-b1c2-1c0cda63e6e6'::UUID, 'e05a0962-a117-506f-a3f2-339123cb913e'::UUID, 3, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('b9af53b7-4481-5b6d-b9ad-8a23c0aae57a'::UUID, '041a9c1d-f3e9-586f-b1c2-1c0cda63e6e6'::UUID, '6bf8921e-0c1c-5ef7-b65d-25af0bcde014'::UUID, 4, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('d2051b42-a269-5457-92d6-b002a5d9e7a5'::UUID, '041a9c1d-f3e9-586f-b1c2-1c0cda63e6e6'::UUID, '4494b70e-f673-5bf6-9819-5525c50d0320'::UUID, 5, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('6fe3647a-2ffa-5c6a-9a93-de04521848e7'::UUID, '041a9c1d-f3e9-586f-b1c2-1c0cda63e6e6'::UUID, 'f046cd8e-133f-51a9-9c21-932bc23c3e77'::UUID, 6, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.grammar_lessons (id, content_key, title, pattern, explanation, example_chinese, example_pinyin, example_meaning, level, status, usage_note, content_version)
VALUES ('92de4aa2-5d33-5e98-827b-16622d1e0932'::UUID, 'practical:xu-ly-hieu-lam', 'Phủ định kết quả với 没', '没 + động từ + bổ ngữ kết quả', '没 phủ định việc đạt được kết quả trong quá khứ.', '不好意思，我没听清。', 'Bù hǎoyìsi, wǒ méi tīngqīng.', 'Xin lỗi, tôi chưa nghe rõ.', 'beginner', 'review', NULL, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_grammar (id, lesson_id, grammar_lesson_id, order_index, curriculum_role)
VALUES ('b346791d-3dd2-50ec-8e57-dee5c4dfa4cc'::UUID, '041a9c1d-f3e9-586f-b1c2-1c0cda63e6e6'::UUID, '92de4aa2-5d33-5e98-827b-16622d1e0932'::UUID, 1, 'introduced')
ON CONFLICT (lesson_id, grammar_lesson_id) DO NOTHING;

INSERT INTO public.lesson_grammar (id, lesson_id, grammar_lesson_id, order_index, curriculum_role)
VALUES ('5a67af8f-8f8e-56cb-8c59-ef7a4e063e89'::UUID, '041a9c1d-f3e9-586f-b1c2-1c0cda63e6e6'::UUID, 'a0715850-efa3-59f2-b0db-412e5bae0420'::UUID, 2, 'review')
ON CONFLICT (lesson_id, grammar_lesson_id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('116b22e2-28fe-58e8-ab19-ead9986df128'::UUID, '041a9c1d-f3e9-586f-b1c2-1c0cda63e6e6'::UUID, 'vocabulary', 1, 'Từ mới: 听清', NULL, '听清', '听清 (tīngqīng) — nghe rõ. 刚才我没听清地址。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"practical:听清","chinese":"听清","pinyin":"tīngqīng","meaning":"nghe rõ","part_of_speech":"động từ","example_chinese":"刚才我没听清地址。","example_pinyin":"Gāngcái wǒ méi tīngqīng dìzhǐ.","example_meaning_vi":"Lúc nãy tôi không nghe rõ địa chỉ."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('3d82e7b3-3207-52df-9719-be90e7f242e7'::UUID, '041a9c1d-f3e9-586f-b1c2-1c0cda63e6e6'::UUID, 'vocabulary', 2, 'Từ mới: 误会', NULL, '误会', '误会 (wùhuì) — hiểu lầm. 对不起，这是一个误会。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"practical:误会","chinese":"误会","pinyin":"wùhuì","meaning":"hiểu lầm","part_of_speech":"động từ/danh từ","example_chinese":"对不起，这是一个误会。","example_pinyin":"Duìbuqǐ, zhè shì yí ge wùhuì.","example_meaning_vi":"Xin lỗi, đây là một sự hiểu lầm."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('17124e1e-f927-5bdc-a908-97d2d97395a6'::UUID, '041a9c1d-f3e9-586f-b1c2-1c0cda63e6e6'::UUID, 'vocabulary', 3, 'Từ mới: 解释', NULL, '解释', '解释 (jiěshì) — giải thích. 请让我解释一下。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"practical:解释","chinese":"解释","pinyin":"jiěshì","meaning":"giải thích","part_of_speech":"động từ","example_chinese":"请让我解释一下。","example_pinyin":"Qǐng ràng wǒ jiěshì yíxià.","example_meaning_vi":"Xin hãy để tôi giải thích một chút."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('571a27e1-1d33-5e1c-885f-6ebb8b8d77f9'::UUID, '041a9c1d-f3e9-586f-b1c2-1c0cda63e6e6'::UUID, 'multiple_choice', 4, '“听清” có nghĩa phù hợp nhất là gì?', NULL, 'nghe rõ', '听清 (tīngqīng) nghĩa là “nghe rõ”.', NULL, 1, '{"activity_type":"chinese_to_vietnamese","vocabulary_key":"practical:听清"}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('3757b2e6-033e-5b7d-a252-af02da3aac17'::UUID, '571a27e1-1d33-5e1c-885f-6ebb8b8d77f9'::UUID, 'hiểu lầm', FALSE, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('0b1e884f-0239-5065-9393-2b24259632b7'::UUID, '571a27e1-1d33-5e1c-885f-6ebb8b8d77f9'::UUID, 'giải thích', FALSE, 2)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('1acfefa3-4f43-5bb2-b1b1-8a6be903e711'::UUID, '571a27e1-1d33-5e1c-885f-6ebb8b8d77f9'::UUID, 'nghe rõ', TRUE, 3)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('1a1c95c8-a042-5e27-b63a-6fb50f4e56e7'::UUID, '041a9c1d-f3e9-586f-b1c2-1c0cda63e6e6'::UUID, 'translation', 5, 'Dịch sang tiếng Trung: “Xin lỗi, tôi chưa nghe rõ.”', NULL, '不好意思，我没听清。', 'Mẫu câu dùng “听清” trong ngữ cảnh của bài.', 'tīngqīng', 1, '{"activity_type":"vietnamese_to_chinese","source_lang":"vi","target_lang":"zh","acceptable_answers":["不好意思，我没听清。"]}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('27a4baef-c230-5b4e-8004-e9bc8fa1f3dc'::UUID, '041a9c1d-f3e9-586f-b1c2-1c0cda63e6e6'::UUID, 'sentence_builder', 6, 'Sắp xếp các thành phần thành câu đúng.', NULL, '不好意思，我没听清。', 'Trật tự đúng tạo thành câu “不好意思，我没听清。”.', NULL, 1, '{"activity_type":"sentence_ordering","words":["不好意思","，","我","没","听清","。"],"correct_order":["不好意思","，","我","没","听清","。"]}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('c8926038-690f-5539-ae2c-f20d9851c124'::UUID, '041a9c1d-f3e9-586f-b1c2-1c0cda63e6e6'::UUID, 'multiple_choice', 7, 'Câu nào nói chưa nghe rõ?', NULL, '不好意思，我没听清。', '没 phủ định việc đạt được kết quả trong quá khứ.', NULL, 1, '{"activity_type":"grammar_selection","passage":null,"grammar_key":"practical:xu-ly-hieu-lam"}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('ae429415-c09c-5dab-91dd-7f71df8910eb'::UUID, 'c8926038-690f-5539-ae2c-f20d9851c124'::UUID, '不好意思，我没听清。', TRUE, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('964322a1-7465-5ece-a932-c74c1fb5cd68'::UUID, 'c8926038-690f-5539-ae2c-f20d9851c124'::UUID, '。听清没我，不好意思', FALSE, 2)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('51cc466b-2030-5aba-bc9a-0ec6bd9c92b2'::UUID, 'c8926038-690f-5539-ae2c-f20d9851c124'::UUID, '，我没听清。不好意思', FALSE, 3)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('b0dadad0-1cb1-5f02-924a-e0d88ff153cf'::UUID, '041a9c1d-f3e9-586f-b1c2-1c0cda63e6e6'::UUID, 'speaking', 8, 'Đọc thành tiếng: 不好意思，我没听清。', NULL, '不好意思，我没听清。', 'Đọc chậm, giữ đúng thanh điệu và nhịp của cả câu.', NULL, 1, '{"activity_type":"pronunciation","text":"不好意思，我没听清。","pinyin":"Bù hǎoyìsi, wǒ méi tīngqīng."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.units (id, course_id, slug, title, description, order_index, status, learning_objectives, content_version)
VALUES ('9e5a4ef2-2b50-507e-a3b5-0449d3446360'::UUID, '5e346c4f-a5e2-5a27-a57b-68a14518cc1b'::UUID, 'practical-on-tap', 'Ôn tập', 'Kiểm tra và củng cố nội dung đã học.', 3, 'review', '["Ôn từ vựng","Ôn mẫu câu"]'::JSONB, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.chapters (id, unit_id, slug, title, description, order_index, status, learning_objectives, content_version)
VALUES ('71b35c80-6b3a-5683-b4a4-263a37d8812b'::UUID, '9e5a4ef2-2b50-507e-a3b5-0449d3446360'::UUID, 'practical-on-tap-chapter', 'Củng cố lộ trình', 'Kiểm tra và củng cố nội dung đã học.', 1, 'review', '["Ôn từ vựng","Ôn mẫu câu"]'::JSONB, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lessons (id, chapter_id, slug, title, description, order_index, xp_reward, status, lesson_type, estimated_minutes, learning_objectives, cultural_note, content_version)
VALUES ('1e335ce4-ba3b-5651-bceb-876eaf2b2659'::UUID, '71b35c80-6b3a-5683-b4a4-263a37d8812b'::UUID, 'practical-review', 'Ôn tập Practical Chinese Conversation', 'Củng cố từ vựng, mẫu câu và khả năng diễn đạt của toàn khóa.', 1, 30, 'review', 'review', 18, '["Vận dụng lại từ vựng trọng tâm","Tự kiểm tra mẫu câu đã học"]'::JSONB, NULL, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('8ad26a8b-2c0e-539c-8e7c-38754124662f'::UUID, '1e335ce4-ba3b-5651-bceb-876eaf2b2659'::UUID, '440edc44-8b77-5775-a254-4aa1d6b215b0'::UUID, 1, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('92f911fe-ec1f-5b7a-a4e7-30cb1cb36dee'::UUID, '1e335ce4-ba3b-5651-bceb-876eaf2b2659'::UUID, '776c6df3-402e-58e0-8b2f-9cb4ef4132f0'::UUID, 2, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('7e8777ff-f4ca-5cf2-b2d0-54dc90ee1097'::UUID, '1e335ce4-ba3b-5651-bceb-876eaf2b2659'::UUID, 'e05a0962-a117-506f-a3f2-339123cb913e'::UUID, 3, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_grammar (id, lesson_id, grammar_lesson_id, order_index, curriculum_role)
VALUES ('f73b4044-6c58-5f6f-a834-659788e47164'::UUID, '1e335ce4-ba3b-5651-bceb-876eaf2b2659'::UUID, '92de4aa2-5d33-5e98-827b-16622d1e0932'::UUID, 1, 'review')
ON CONFLICT (lesson_id, grammar_lesson_id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('42500d2f-1da5-588e-bb09-b347e5555da6'::UUID, '1e335ce4-ba3b-5651-bceb-876eaf2b2659'::UUID, 'multiple_choice', 1, '“听清” có nghĩa phù hợp nhất là gì?', NULL, 'nghe rõ', '听清 (tīngqīng) nghĩa là “nghe rõ”.', NULL, 1, '{"activity_type":"chinese_to_vietnamese","vocabulary_key":"practical:听清"}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('afa39458-84de-5fa7-a50f-e90b483922b8'::UUID, '42500d2f-1da5-588e-bb09-b347e5555da6'::UUID, 'nghe rõ', TRUE, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('2db0b591-4a11-584c-beaa-ff1658cb8baf'::UUID, '42500d2f-1da5-588e-bb09-b347e5555da6'::UUID, 'hiểu lầm', FALSE, 2)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('fe9ecc1c-da0d-5d13-8498-b24283f36a26'::UUID, '42500d2f-1da5-588e-bb09-b347e5555da6'::UUID, 'giải thích', FALSE, 3)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('a6521f56-fc12-598c-860e-03685ee0a616'::UUID, '1e335ce4-ba3b-5651-bceb-876eaf2b2659'::UUID, 'translation', 2, 'Dịch sang tiếng Trung: “Xin lỗi, tôi chưa nghe rõ.”', NULL, '不好意思，我没听清。', 'Mẫu câu dùng “听清” trong ngữ cảnh của bài.', 'tīngqīng', 1, '{"activity_type":"vietnamese_to_chinese","source_lang":"vi","target_lang":"zh","acceptable_answers":["不好意思，我没听清。"]}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('fa4a918d-dc66-5ab8-98a6-6db5c28b6a80'::UUID, '1e335ce4-ba3b-5651-bceb-876eaf2b2659'::UUID, 'sentence_builder', 3, 'Sắp xếp các thành phần thành câu đúng.', NULL, '不好意思，我没听清。', 'Trật tự đúng tạo thành câu “不好意思，我没听清。”.', NULL, 1, '{"activity_type":"sentence_ordering","words":["不好意思","，","我","没","听清","。"],"correct_order":["不好意思","，","我","没","听清","。"]}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('d3fc11a4-e82e-5c5a-a0cb-cac0aeeaccc7'::UUID, '1e335ce4-ba3b-5651-bceb-876eaf2b2659'::UUID, 'multiple_choice', 4, 'Câu nào nói chưa nghe rõ?', NULL, '不好意思，我没听清。', '没 phủ định việc đạt được kết quả trong quá khứ.', NULL, 1, '{"activity_type":"grammar_selection","passage":null,"grammar_key":"practical:xu-ly-hieu-lam"}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('50bed2a6-df71-5c55-8b32-7f27c154bcc9'::UUID, 'd3fc11a4-e82e-5c5a-a0cb-cac0aeeaccc7'::UUID, '不好意思，我没听清。', TRUE, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('c2d2100e-eb71-590f-a614-b741301de45a'::UUID, 'd3fc11a4-e82e-5c5a-a0cb-cac0aeeaccc7'::UUID, '。听清没我，不好意思', FALSE, 2)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('bd5a4f12-56c4-57cf-a29b-a547eec6746d'::UUID, 'd3fc11a4-e82e-5c5a-a0cb-cac0aeeaccc7'::UUID, '，我没听清。不好意思', FALSE, 3)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('eb2b6479-d084-51c4-a265-f64a02e49642'::UUID, '1e335ce4-ba3b-5651-bceb-876eaf2b2659'::UUID, 'speaking', 5, 'Đọc thành tiếng: 不好意思，我没听清。', NULL, '不好意思，我没听清。', 'Đọc chậm, giữ đúng thanh điệu và nhịp của cả câu.', NULL, 1, '{"activity_type":"pronunciation","text":"不好意思，我没听清。","pinyin":"Bù hǎoyìsi, wǒ méi tīngqīng."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.content_batches (id, batch_key, version, migration_name, manifest_checksum, expected_counts)
VALUES ('605d1c55-bd14-51fb-b73b-16dae191f412'::UUID, 'batch-08-practical', 1, '20260729170000_content_batch_08_practical', '54f5fa6b564061ef069da9c9ff41a0614e1728859cd85b3cd293ec1544a9c848', '{"courses":1,"units":3,"chapters":3,"lessons":5,"vocabulary":12,"grammar":4,"characters":0,"exercises":37,"options":30}'::JSONB)
ON CONFLICT (batch_key, version) DO NOTHING;

DO $content_validation$
BEGIN
  IF (SELECT COUNT(*) FROM public.courses WHERE id = ANY(ARRAY['5e346c4f-a5e2-5a27-a57b-68a14518cc1b'::UUID]::UUID[])) <> 1 THEN
    RAISE EXCEPTION 'Content batch batch-08-practical is missing managed courses rows';
  END IF;
  IF (SELECT COUNT(*) FROM public.units WHERE id = ANY(ARRAY['f672de92-ca90-5c58-8fe9-7b637acadf7b'::UUID, '7285924c-1bc5-5521-a320-6c47659a4de6'::UUID, '9e5a4ef2-2b50-507e-a3b5-0449d3446360'::UUID]::UUID[])) <> 3 THEN
    RAISE EXCEPTION 'Content batch batch-08-practical is missing managed units rows';
  END IF;
  IF (SELECT COUNT(*) FROM public.chapters WHERE id = ANY(ARRAY['08042119-e055-5f66-b68c-c0b7eb3ae8ac'::UUID, '011a0219-2f28-5f9b-827a-8bad043ca2cb'::UUID, '71b35c80-6b3a-5683-b4a4-263a37d8812b'::UUID]::UUID[])) <> 3 THEN
    RAISE EXCEPTION 'Content batch batch-08-practical is missing managed chapters rows';
  END IF;
  IF (SELECT COUNT(*) FROM public.lessons WHERE id = ANY(ARRAY['ee68f5eb-fabe-589d-b1e5-262217b63e76'::UUID, 'fc2485b6-51de-5b52-8b9a-8885712cb10b'::UUID, '566b44ab-4b81-5312-9dba-8542eb71fe65'::UUID, '041a9c1d-f3e9-586f-b1c2-1c0cda63e6e6'::UUID, '1e335ce4-ba3b-5651-bceb-876eaf2b2659'::UUID]::UUID[])) <> 5 THEN
    RAISE EXCEPTION 'Content batch batch-08-practical is missing managed lessons rows';
  END IF;
  IF (SELECT COUNT(*) FROM public.vocabulary WHERE id = ANY(ARRAY['5fa3c2a1-5901-505a-ab8d-9acf855c3d9e'::UUID, '17ea5b8e-5c55-576e-af55-740a0d3c74fa'::UUID, '1a4412b2-1345-5ee9-a316-c70445bab48a'::UUID, '9196bfab-018a-5d03-b913-339b09ddce8e'::UUID, '717df9e1-01c0-5c2f-90d2-7c4a4e3833cc'::UUID, '11c388df-46ea-5406-8e14-f3fb93ee9608'::UUID, '6bf8921e-0c1c-5ef7-b65d-25af0bcde014'::UUID, '4494b70e-f673-5bf6-9819-5525c50d0320'::UUID, 'f046cd8e-133f-51a9-9c21-932bc23c3e77'::UUID, '440edc44-8b77-5775-a254-4aa1d6b215b0'::UUID, '776c6df3-402e-58e0-8b2f-9cb4ef4132f0'::UUID, 'e05a0962-a117-506f-a3f2-339123cb913e'::UUID]::UUID[])) <> 12 THEN
    RAISE EXCEPTION 'Content batch batch-08-practical is missing managed vocabulary rows';
  END IF;
  IF (SELECT COUNT(*) FROM public.grammar_lessons WHERE id = ANY(ARRAY['db723cb0-5977-5726-be32-0c3c7815be6d'::UUID, 'c88b2741-c3e1-5317-826a-e35b0ef60776'::UUID, 'a0715850-efa3-59f2-b0db-412e5bae0420'::UUID, '92de4aa2-5d33-5e98-827b-16622d1e0932'::UUID]::UUID[])) <> 4 THEN
    RAISE EXCEPTION 'Content batch batch-08-practical is missing managed grammar_lessons rows';
  END IF;
  IF (SELECT COUNT(*) FROM public.exercises WHERE id = ANY(ARRAY['6a187d79-c1f4-5550-9c9d-abd13625dc7c'::UUID, '83d8acf9-3734-53a9-945b-ea2f595a9f0b'::UUID, 'c0f95879-fc50-51bd-a6a3-4a082f3ce761'::UUID, '64b82cc1-7177-5715-9d16-8298c63ab34d'::UUID, '397464ca-f1d3-5947-ae6c-8273daad273d'::UUID, 'd2c7abfe-e1e2-5d44-a24a-e72d4ebcc1f5'::UUID, '0ff6b2f9-41e4-5545-ae86-f1a09a6708de'::UUID, 'face1d13-2c85-5c37-8e17-35082cbbc56e'::UUID, '875e6c8d-de20-5291-8c79-9e9127196bc8'::UUID, '7ea5e70d-59db-5a24-94be-56ca668f8e5f'::UUID, '6b71ad2e-cab1-5472-9b42-cd777e3655d1'::UUID, '206b2380-8ecf-57c8-aad3-79af1b553b93'::UUID, '6cda327b-49a2-5244-9190-94270bf5efeb'::UUID, 'eb333072-b3ff-53c7-a957-3d4e7345f528'::UUID, '04332134-4499-511a-b363-d9a62aac088f'::UUID, '5a327f34-032c-5f59-9fc8-c7a6713a6b27'::UUID, 'bb398a57-e39b-5093-a72c-7d7d3f90319c'::UUID, '004936ba-73bf-5119-b895-ed576276cd6e'::UUID, '9ae44c4d-1ec1-536e-a61e-ec36e618bb1d'::UUID, '051e52e7-541e-5882-a875-d3f179aac53a'::UUID, '700640ac-f85c-5f95-b7bb-05b4e3781204'::UUID, '367a8688-9f35-5dd8-9e40-05b239efb57c'::UUID, 'c5dfdc58-3a2c-513f-8564-c05448c9f85c'::UUID, '449a8822-ea79-50b4-974d-39e97f59a7fc'::UUID, '116b22e2-28fe-58e8-ab19-ead9986df128'::UUID, '3d82e7b3-3207-52df-9719-be90e7f242e7'::UUID, '17124e1e-f927-5bdc-a908-97d2d97395a6'::UUID, '571a27e1-1d33-5e1c-885f-6ebb8b8d77f9'::UUID, '1a1c95c8-a042-5e27-b63a-6fb50f4e56e7'::UUID, '27a4baef-c230-5b4e-8004-e9bc8fa1f3dc'::UUID, 'c8926038-690f-5539-ae2c-f20d9851c124'::UUID, 'b0dadad0-1cb1-5f02-924a-e0d88ff153cf'::UUID, '42500d2f-1da5-588e-bb09-b347e5555da6'::UUID, 'a6521f56-fc12-598c-860e-03685ee0a616'::UUID, 'fa4a918d-dc66-5ab8-98a6-6db5c28b6a80'::UUID, 'd3fc11a4-e82e-5c5a-a0cb-cac0aeeaccc7'::UUID, 'eb2b6479-d084-51c4-a265-f64a02e49642'::UUID]::UUID[])) <> 37 THEN
    RAISE EXCEPTION 'Content batch batch-08-practical is missing managed exercises rows';
  END IF;
  IF (SELECT COUNT(*) FROM public.exercise_options WHERE id = ANY(ARRAY['3d7b9900-ea35-5cfb-b668-8c877f705d3b'::UUID, '995ef4c8-0da8-5c28-b69d-59411761ca78'::UUID, 'c30c8c63-e17d-5e5e-80a3-437ce3eb5b4d'::UUID, 'f4f7894b-0b0b-5685-88f1-f6e96093486b'::UUID, 'e49c9c13-57d2-5f12-a134-6ced21741b72'::UUID, '9a2d4372-3521-5045-98cb-0691f012d784'::UUID, 'b8a948fb-bd76-55ac-9af2-1b10a2a9962e'::UUID, 'c59f0c23-816d-5519-aa79-285d21a429dd'::UUID, '5adf5a2a-9b0f-591b-a425-b846a8611b33'::UUID, '4c1127a1-42e0-5e7e-9d85-a6ae849db793'::UUID, '34f7e844-c5ff-5b80-82a6-3961551d048c'::UUID, '21c1748c-a63a-57c6-bd27-b6345d2b5162'::UUID, '7763d851-e395-53d1-8773-f4869381995b'::UUID, 'f127d901-e416-5b22-b5d1-f66a393d143e'::UUID, '7eaf257c-a3aa-5a53-86a4-544b54e5ba38'::UUID, '5b4cebaa-a740-591b-8827-f7c5a877d156'::UUID, 'bd839c05-b88e-5450-8c40-a99ee39e2086'::UUID, 'b8234d90-b003-53d3-9467-c71b61bcb787'::UUID, '3757b2e6-033e-5b7d-a252-af02da3aac17'::UUID, '0b1e884f-0239-5065-9393-2b24259632b7'::UUID, '1acfefa3-4f43-5bb2-b1b1-8a6be903e711'::UUID, 'ae429415-c09c-5dab-91dd-7f71df8910eb'::UUID, '964322a1-7465-5ece-a932-c74c1fb5cd68'::UUID, '51cc466b-2030-5aba-bc9a-0ec6bd9c92b2'::UUID, 'afa39458-84de-5fa7-a50f-e90b483922b8'::UUID, '2db0b591-4a11-584c-beaa-ff1658cb8baf'::UUID, 'fe9ecc1c-da0d-5d13-8498-b24283f36a26'::UUID, '50bed2a6-df71-5c55-8b32-7f27c154bcc9'::UUID, 'c2d2100e-eb71-590f-a614-b741301de45a'::UUID, 'bd5a4f12-56c4-57cf-a29b-a547eec6746d'::UUID]::UUID[])) <> 30 THEN
    RAISE EXCEPTION 'Content batch batch-08-practical is missing managed exercise_options rows';
  END IF;
  IF EXISTS (
    SELECT 1 FROM public.lessons AS lesson
    WHERE lesson.id = ANY(ARRAY['ee68f5eb-fabe-589d-b1e5-262217b63e76'::UUID, 'fc2485b6-51de-5b52-8b9a-8885712cb10b'::UUID, '566b44ab-4b81-5312-9dba-8542eb71fe65'::UUID, '041a9c1d-f3e9-586f-b1c2-1c0cda63e6e6'::UUID, '1e335ce4-ba3b-5651-bceb-876eaf2b2659'::UUID]::UUID[])
      AND NOT EXISTS (
        SELECT 1 FROM public.exercises AS exercise
        WHERE exercise.lesson_id = lesson.id
      )
  ) THEN
    RAISE EXCEPTION 'Content batch batch-08-practical contains a lesson without exercises';
  END IF;
  IF EXISTS (
    SELECT 1
    FROM public.lessons AS lesson
    JOIN public.exercises AS exercise ON exercise.lesson_id = lesson.id
    WHERE lesson.id = ANY(ARRAY['ee68f5eb-fabe-589d-b1e5-262217b63e76'::UUID, 'fc2485b6-51de-5b52-8b9a-8885712cb10b'::UUID, '566b44ab-4b81-5312-9dba-8542eb71fe65'::UUID, '041a9c1d-f3e9-586f-b1c2-1c0cda63e6e6'::UUID, '1e335ce4-ba3b-5651-bceb-876eaf2b2659'::UUID]::UUID[])
      AND lesson.status = 'published'
      AND exercise.exercise_type = 'listening'
      AND NULLIF(BTRIM(exercise.question_audio_url), '') IS NULL
  ) THEN
    RAISE EXCEPTION 'Published listening exercise is missing playable audio';
  END IF;
  IF EXISTS (
    SELECT 1
    FROM public.exercises AS exercise
    WHERE exercise.id = ANY(ARRAY['6a187d79-c1f4-5550-9c9d-abd13625dc7c'::UUID, '83d8acf9-3734-53a9-945b-ea2f595a9f0b'::UUID, 'c0f95879-fc50-51bd-a6a3-4a082f3ce761'::UUID, '64b82cc1-7177-5715-9d16-8298c63ab34d'::UUID, '397464ca-f1d3-5947-ae6c-8273daad273d'::UUID, 'd2c7abfe-e1e2-5d44-a24a-e72d4ebcc1f5'::UUID, '0ff6b2f9-41e4-5545-ae86-f1a09a6708de'::UUID, 'face1d13-2c85-5c37-8e17-35082cbbc56e'::UUID, '875e6c8d-de20-5291-8c79-9e9127196bc8'::UUID, '7ea5e70d-59db-5a24-94be-56ca668f8e5f'::UUID, '6b71ad2e-cab1-5472-9b42-cd777e3655d1'::UUID, '206b2380-8ecf-57c8-aad3-79af1b553b93'::UUID, '6cda327b-49a2-5244-9190-94270bf5efeb'::UUID, 'eb333072-b3ff-53c7-a957-3d4e7345f528'::UUID, '04332134-4499-511a-b363-d9a62aac088f'::UUID, '5a327f34-032c-5f59-9fc8-c7a6713a6b27'::UUID, 'bb398a57-e39b-5093-a72c-7d7d3f90319c'::UUID, '004936ba-73bf-5119-b895-ed576276cd6e'::UUID, '9ae44c4d-1ec1-536e-a61e-ec36e618bb1d'::UUID, '051e52e7-541e-5882-a875-d3f179aac53a'::UUID, '700640ac-f85c-5f95-b7bb-05b4e3781204'::UUID, '367a8688-9f35-5dd8-9e40-05b239efb57c'::UUID, 'c5dfdc58-3a2c-513f-8564-c05448c9f85c'::UUID, '449a8822-ea79-50b4-974d-39e97f59a7fc'::UUID, '116b22e2-28fe-58e8-ab19-ead9986df128'::UUID, '3d82e7b3-3207-52df-9719-be90e7f242e7'::UUID, '17124e1e-f927-5bdc-a908-97d2d97395a6'::UUID, '571a27e1-1d33-5e1c-885f-6ebb8b8d77f9'::UUID, '1a1c95c8-a042-5e27-b63a-6fb50f4e56e7'::UUID, '27a4baef-c230-5b4e-8004-e9bc8fa1f3dc'::UUID, 'c8926038-690f-5539-ae2c-f20d9851c124'::UUID, 'b0dadad0-1cb1-5f02-924a-e0d88ff153cf'::UUID, '42500d2f-1da5-588e-bb09-b347e5555da6'::UUID, 'a6521f56-fc12-598c-860e-03685ee0a616'::UUID, 'fa4a918d-dc66-5ab8-98a6-6db5c28b6a80'::UUID, 'd3fc11a4-e82e-5c5a-a0cb-cac0aeeaccc7'::UUID, 'eb2b6479-d084-51c4-a265-f64a02e49642'::UUID]::UUID[])
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
    WHERE link.lesson_id = ANY(ARRAY['ee68f5eb-fabe-589d-b1e5-262217b63e76'::UUID, 'fc2485b6-51de-5b52-8b9a-8885712cb10b'::UUID, '566b44ab-4b81-5312-9dba-8542eb71fe65'::UUID, '041a9c1d-f3e9-586f-b1c2-1c0cda63e6e6'::UUID, '1e335ce4-ba3b-5651-bceb-876eaf2b2659'::UUID]::UUID[])
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
