-- Generated from content/manifests/09_travel.json.
-- Do not hand-edit this migration; edit the manifest and regenerate.
-- Additive and idempotent: deterministic IDs plus ON CONFLICT DO NOTHING.

BEGIN;

INSERT INTO public.courses (id, slug, title, title_zh, description, level, status, order_index, learning_objectives, estimated_minutes, content_version)
VALUES ('09663c66-0d0d-5bf3-88cc-c7bd5eb7d17f'::UUID, 'chinese-for-travel', 'Chinese for Travel', '旅游汉语', 'Tiếng Trung thiết yếu cho hành trình, khách sạn và sự cố.', 'elementary', 'review', 13, '["Làm thủ tục di chuyển","Giao tiếp tại nơi lưu trú","Xử lý thay đổi và sự cố"]'::JSONB, 78, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.units (id, course_id, slug, title, description, order_index, status, learning_objectives, content_version)
VALUES ('389544b8-1d84-5b90-baaf-3357fba9e1ae'::UUID, '09663c66-0d0d-5bf3-88cc-c7bd5eb7d17f'::UUID, 'travel-nen-tang', 'Nền tảng', 'Xây dựng ngôn ngữ cốt lõi của lộ trình.', 1, 'review', '["Làm thủ tục di chuyển","Giao tiếp tại nơi lưu trú"]'::JSONB, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.chapters (id, unit_id, slug, title, description, order_index, status, learning_objectives, content_version)
VALUES ('f16a2ddc-3e64-59ab-8aea-15fd9466fa12'::UUID, '389544b8-1d84-5b90-baaf-3357fba9e1ae'::UUID, 'travel-nen-tang-chapter', 'Khái niệm cốt lõi', 'Xây dựng ngôn ngữ cốt lõi của lộ trình.', 1, 'review', '["Làm thủ tục di chuyển","Giao tiếp tại nơi lưu trú"]'::JSONB, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lessons (id, chapter_id, slug, title, description, order_index, xp_reward, status, lesson_type, estimated_minutes, learning_objectives, cultural_note, content_version)
VALUES ('cd86a494-4f77-50a4-9514-c10703882434'::UUID, 'f16a2ddc-3e64-59ab-8aea-15fd9466fa12'::UUID, 'san-bay', '办理登机 — Làm thủ tục bay', 'Hỏi quầy và làm thủ tục.', 1, 25, 'review', 'standard', 15, '["Hoàn thành thủ tục sân bay"]'::JSONB, '出示 dùng cho giấy tờ cần đưa ra kiểm tra.', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('afe3257d-ee40-59aa-b9e7-ce445e203874'::UUID, 'travel:登机牌', '登机牌', 'dēngjīpái', 'thẻ lên máy bay', 'boarding pass', 'elementary', 'san-bay', 'danh từ', '请收好您的登机牌。', 'Qǐng shōuhǎo nín de dēngjīpái.', 'Xin giữ cẩn thận thẻ lên máy bay.', NULL, 'review', 'cd86a494-4f77-50a4-9514-c10703882434'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('0380ab00-375d-52be-a0b9-949b95986563'::UUID, 'cd86a494-4f77-50a4-9514-c10703882434'::UUID, 'afe3257d-ee40-59aa-b9e7-ce445e203874'::UUID, 1, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('3adeaafd-d279-579c-848e-aaef1dd91792'::UUID, 'travel:行李', '行李', 'xíngli', 'hành lý', 'luggage', 'elementary', 'san-bay', 'danh từ', '这件行李需要托运。', 'Zhè jiàn xíngli xūyào tuōyùn.', 'Kiện hành lý này cần ký gửi.', NULL, 'review', 'cd86a494-4f77-50a4-9514-c10703882434'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('b636d59c-4b40-535b-b75e-cf0a09c2b7a6'::UUID, 'cd86a494-4f77-50a4-9514-c10703882434'::UUID, '3adeaafd-d279-579c-848e-aaef1dd91792'::UUID, 2, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('4b026097-241e-528f-8c09-afbd02bce060'::UUID, 'travel:护照', '护照', 'hùzhào', 'hộ chiếu', 'passport', 'elementary', 'san-bay', 'danh từ', '办理手续时请出示护照。', 'Bànlǐ shǒuxù shí qǐng chūshì hùzhào.', 'Khi làm thủ tục xin xuất trình hộ chiếu.', NULL, 'review', 'cd86a494-4f77-50a4-9514-c10703882434'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('c1171f5a-801c-5281-8105-8dd3bef7e272'::UUID, 'cd86a494-4f77-50a4-9514-c10703882434'::UUID, '4b026097-241e-528f-8c09-afbd02bce060'::UUID, 3, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.grammar_lessons (id, content_key, title, pattern, explanation, example_chinese, example_pinyin, example_meaning, level, status, usage_note, content_version)
VALUES ('d1904929-dd79-5080-9ba8-a6a14bcefc5a'::UUID, 'travel:san-bay', 'Yêu cầu xuất trình với 请', '请 + động từ + tân ngữ', '请 trước động từ tạo yêu cầu lịch sự.', '办理登机时请出示护照。', 'Bànlǐ dēngjī shí qǐng chūshì hùzhào.', 'Khi làm thủ tục lên máy bay xin xuất trình hộ chiếu.', 'elementary', 'review', NULL, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_grammar (id, lesson_id, grammar_lesson_id, order_index, curriculum_role)
VALUES ('bf078d68-ad0b-531d-9081-83dd7f58a476'::UUID, 'cd86a494-4f77-50a4-9514-c10703882434'::UUID, 'd1904929-dd79-5080-9ba8-a6a14bcefc5a'::UUID, 1, 'introduced')
ON CONFLICT (lesson_id, grammar_lesson_id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('426a9cee-630e-5b6a-818e-9076b1be20aa'::UUID, 'cd86a494-4f77-50a4-9514-c10703882434'::UUID, 'vocabulary', 1, 'Từ mới: 登机牌', NULL, '登机牌', '登机牌 (dēngjīpái) — thẻ lên máy bay. 请收好您的登机牌。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"travel:登机牌","chinese":"登机牌","pinyin":"dēngjīpái","meaning":"thẻ lên máy bay","part_of_speech":"danh từ","example_chinese":"请收好您的登机牌。","example_pinyin":"Qǐng shōuhǎo nín de dēngjīpái.","example_meaning_vi":"Xin giữ cẩn thận thẻ lên máy bay."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('2c1ede9f-3911-52af-9451-df81eedc0aea'::UUID, 'cd86a494-4f77-50a4-9514-c10703882434'::UUID, 'vocabulary', 2, 'Từ mới: 行李', NULL, '行李', '行李 (xíngli) — hành lý. 这件行李需要托运。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"travel:行李","chinese":"行李","pinyin":"xíngli","meaning":"hành lý","part_of_speech":"danh từ","example_chinese":"这件行李需要托运。","example_pinyin":"Zhè jiàn xíngli xūyào tuōyùn.","example_meaning_vi":"Kiện hành lý này cần ký gửi."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('c67c671a-ed78-55d4-95ee-6eb7218b34bd'::UUID, 'cd86a494-4f77-50a4-9514-c10703882434'::UUID, 'vocabulary', 3, 'Từ mới: 护照', NULL, '护照', '护照 (hùzhào) — hộ chiếu. 办理手续时请出示护照。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"travel:护照","chinese":"护照","pinyin":"hùzhào","meaning":"hộ chiếu","part_of_speech":"danh từ","example_chinese":"办理手续时请出示护照。","example_pinyin":"Bànlǐ shǒuxù shí qǐng chūshì hùzhào.","example_meaning_vi":"Khi làm thủ tục xin xuất trình hộ chiếu."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('9ba1718e-288b-5fcf-acbd-08ff8aed83a7'::UUID, 'cd86a494-4f77-50a4-9514-c10703882434'::UUID, 'multiple_choice', 4, '“登机牌” có nghĩa phù hợp nhất là gì?', NULL, 'thẻ lên máy bay', '登机牌 (dēngjīpái) nghĩa là “thẻ lên máy bay”.', NULL, 1, '{"activity_type":"chinese_to_vietnamese","vocabulary_key":"travel:登机牌"}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('bfa823c6-ccc2-5268-bc84-1bc7468b1929'::UUID, '9ba1718e-288b-5fcf-acbd-08ff8aed83a7'::UUID, 'hộ chiếu', FALSE, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('8e187fcb-ec81-5e72-9fee-d17c78b474f9'::UUID, '9ba1718e-288b-5fcf-acbd-08ff8aed83a7'::UUID, 'thẻ lên máy bay', TRUE, 2)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('9b9a9a55-e2a6-5b69-98dd-e9fe5ec07ab7'::UUID, '9ba1718e-288b-5fcf-acbd-08ff8aed83a7'::UUID, 'hành lý', FALSE, 3)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('680df5ec-45d4-56fb-a666-13b6fb1755b5'::UUID, 'cd86a494-4f77-50a4-9514-c10703882434'::UUID, 'translation', 5, 'Dịch sang tiếng Trung: “Khi làm thủ tục lên máy bay xin xuất trình hộ chiếu.”', NULL, '办理登机时请出示护照。', 'Mẫu câu dùng “登机牌” trong ngữ cảnh của bài.', 'dēngjīpái', 1, '{"activity_type":"vietnamese_to_chinese","source_lang":"vi","target_lang":"zh","acceptable_answers":["办理登机时请出示护照。"]}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('21518d43-0711-5f51-8627-a2a7845fdfb7'::UUID, 'cd86a494-4f77-50a4-9514-c10703882434'::UUID, 'sentence_builder', 6, 'Sắp xếp các thành phần thành câu đúng.', NULL, '办理登机时请出示护照。', 'Trật tự đúng tạo thành câu “办理登机时请出示护照。”.', NULL, 1, '{"activity_type":"sentence_ordering","words":["办理","登机","时","请","出示","护照","。"],"correct_order":["办理","登机","时","请","出示","护照","。"]}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('58981e46-3778-539e-9ec4-d230ea34009d'::UUID, 'cd86a494-4f77-50a4-9514-c10703882434'::UUID, 'multiple_choice', 7, 'Câu hướng dẫn nào lịch sự?', NULL, '办理登机时请出示护照。', '请 trước động từ tạo yêu cầu lịch sự.', NULL, 1, '{"activity_type":"grammar_selection","passage":null,"grammar_key":"travel:san-bay"}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('b5ee1e87-aa03-5270-96c9-b54b1a10d339'::UUID, '58981e46-3778-539e-9ec4-d230ea34009d'::UUID, '办理登机时请出示护照。', TRUE, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('dae64db3-dc73-55d6-b6fc-fe56189807ea'::UUID, '58981e46-3778-539e-9ec4-d230ea34009d'::UUID, '。护照出示请时登机办理', FALSE, 2)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('552998e5-208c-511a-a2b8-e32dd78dab6d'::UUID, '58981e46-3778-539e-9ec4-d230ea34009d'::UUID, '登机时请出示护照。办理', FALSE, 3)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('4111b144-447c-5b6d-b387-9adc6bf461bd'::UUID, 'cd86a494-4f77-50a4-9514-c10703882434'::UUID, 'speaking', 8, 'Đọc thành tiếng: 办理登机时请出示护照。', NULL, '办理登机时请出示护照。', 'Đọc chậm, giữ đúng thanh điệu và nhịp của cả câu.', NULL, 1, '{"activity_type":"pronunciation","text":"办理登机时请出示护照。","pinyin":"Bànlǐ dēngjī shí qǐng chūshì hùzhào."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lessons (id, chapter_id, slug, title, description, order_index, xp_reward, status, lesson_type, estimated_minutes, learning_objectives, cultural_note, content_version)
VALUES ('e7b82c88-0422-577f-a63d-5ec1db376c66'::UUID, 'f16a2ddc-3e64-59ab-8aea-15fd9466fa12'::UUID, 'khach-san', '预订房间 — Khách sạn', 'Đặt phòng và xác nhận dịch vụ.', 2, 25, 'review', 'standard', 15, '["Nhận phòng bằng thông tin đặt chỗ"]'::JSONB, '已经 thường đi cùng 了 để nhấn mạnh trạng thái hoàn tất.', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('7f5bf3bd-dc14-54ee-a679-c6a62c567d13'::UUID, 'travel:预订', '预订', 'yùdìng', 'đặt trước', 'reserve', 'elementary', 'khach-san', 'động từ', '我在网上预订了房间。', 'Wǒ zài wǎngshang yùdìng le fángjiān.', 'Tôi đã đặt phòng trên mạng.', NULL, 'review', 'e7b82c88-0422-577f-a63d-5ec1db376c66'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('eef79700-8dd4-5282-b167-91c55c693690'::UUID, 'e7b82c88-0422-577f-a63d-5ec1db376c66'::UUID, '7f5bf3bd-dc14-54ee-a679-c6a62c567d13'::UUID, 1, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('c67e9ca2-bc20-5d76-a5ca-dfc1389f5d39'::UUID, 'travel:前台', '前台', 'qiántái', 'quầy lễ tân', 'front desk', 'elementary', 'khach-san', 'danh từ', '请到前台办理入住。', 'Qǐng dào qiántái bànlǐ rùzhù.', 'Xin đến quầy lễ tân làm thủ tục nhận phòng.', NULL, 'review', 'e7b82c88-0422-577f-a63d-5ec1db376c66'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('db78b6f5-d23d-53ea-ab1b-b4d81250859e'::UUID, 'e7b82c88-0422-577f-a63d-5ec1db376c66'::UUID, 'c67e9ca2-bc20-5d76-a5ca-dfc1389f5d39'::UUID, 2, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('61ba05a2-3c46-5974-b337-e62065fe3f6c'::UUID, 'travel:退房', '退房', 'tuìfáng', 'trả phòng', 'check out', 'elementary', 'khach-san', 'động từ', '酒店要求中午十二点前退房。', 'Jiǔdiàn yāoqiú zhōngwǔ shí’èr diǎn qián tuìfáng.', 'Khách sạn yêu cầu trả phòng trước 12 giờ trưa.', NULL, 'review', 'e7b82c88-0422-577f-a63d-5ec1db376c66'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('e235a320-c30c-5791-bd3f-32df4074c212'::UUID, 'e7b82c88-0422-577f-a63d-5ec1db376c66'::UUID, '61ba05a2-3c46-5974-b337-e62065fe3f6c'::UUID, 3, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('e787e058-7ba4-5fe3-a1dd-400f7390b7ce'::UUID, 'e7b82c88-0422-577f-a63d-5ec1db376c66'::UUID, 'afe3257d-ee40-59aa-b9e7-ce445e203874'::UUID, 4, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('3cfa4005-bfaf-519f-b670-340659f71526'::UUID, 'e7b82c88-0422-577f-a63d-5ec1db376c66'::UUID, '3adeaafd-d279-579c-848e-aaef1dd91792'::UUID, 5, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('d684ca79-6814-5003-8432-3ed73a844f27'::UUID, 'e7b82c88-0422-577f-a63d-5ec1db376c66'::UUID, '4b026097-241e-528f-8c09-afbd02bce060'::UUID, 6, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.grammar_lessons (id, content_key, title, pattern, explanation, example_chinese, example_pinyin, example_meaning, level, status, usage_note, content_version)
VALUES ('89d2faaa-6906-5e7c-ae52-503a9c98dd24'::UUID, 'travel:khach-san', 'Đã hoàn tất với 了', 'động từ + 了 + tân ngữ', '了 sau động từ đánh dấu hành động đã hoàn tất.', '我已经预订了一个双人间。', 'Wǒ yǐjīng yùdìng le yí ge shuāngrénjiān.', 'Tôi đã đặt một phòng đôi.', 'elementary', 'review', NULL, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_grammar (id, lesson_id, grammar_lesson_id, order_index, curriculum_role)
VALUES ('6687979b-3c71-5355-a300-0adfbf6d44bc'::UUID, 'e7b82c88-0422-577f-a63d-5ec1db376c66'::UUID, '89d2faaa-6906-5e7c-ae52-503a9c98dd24'::UUID, 1, 'introduced')
ON CONFLICT (lesson_id, grammar_lesson_id) DO NOTHING;

INSERT INTO public.lesson_grammar (id, lesson_id, grammar_lesson_id, order_index, curriculum_role)
VALUES ('7baf215e-86e6-5da6-8897-3a5ce5f3abbc'::UUID, 'e7b82c88-0422-577f-a63d-5ec1db376c66'::UUID, 'd1904929-dd79-5080-9ba8-a6a14bcefc5a'::UUID, 2, 'review')
ON CONFLICT (lesson_id, grammar_lesson_id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('5f292e25-c261-5ec3-b2c7-9282dd1c7187'::UUID, 'e7b82c88-0422-577f-a63d-5ec1db376c66'::UUID, 'vocabulary', 1, 'Từ mới: 预订', NULL, '预订', '预订 (yùdìng) — đặt trước. 我在网上预订了房间。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"travel:预订","chinese":"预订","pinyin":"yùdìng","meaning":"đặt trước","part_of_speech":"động từ","example_chinese":"我在网上预订了房间。","example_pinyin":"Wǒ zài wǎngshang yùdìng le fángjiān.","example_meaning_vi":"Tôi đã đặt phòng trên mạng."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('f309ae75-c227-5e59-8453-9201a0fb1f1d'::UUID, 'e7b82c88-0422-577f-a63d-5ec1db376c66'::UUID, 'vocabulary', 2, 'Từ mới: 前台', NULL, '前台', '前台 (qiántái) — quầy lễ tân. 请到前台办理入住。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"travel:前台","chinese":"前台","pinyin":"qiántái","meaning":"quầy lễ tân","part_of_speech":"danh từ","example_chinese":"请到前台办理入住。","example_pinyin":"Qǐng dào qiántái bànlǐ rùzhù.","example_meaning_vi":"Xin đến quầy lễ tân làm thủ tục nhận phòng."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('098bc2c9-7f9c-5a19-a0d6-4b3c96b19196'::UUID, 'e7b82c88-0422-577f-a63d-5ec1db376c66'::UUID, 'vocabulary', 3, 'Từ mới: 退房', NULL, '退房', '退房 (tuìfáng) — trả phòng. 酒店要求中午十二点前退房。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"travel:退房","chinese":"退房","pinyin":"tuìfáng","meaning":"trả phòng","part_of_speech":"động từ","example_chinese":"酒店要求中午十二点前退房。","example_pinyin":"Jiǔdiàn yāoqiú zhōngwǔ shí’èr diǎn qián tuìfáng.","example_meaning_vi":"Khách sạn yêu cầu trả phòng trước 12 giờ trưa."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('820a1b87-624f-5491-97d8-3aeea306042d'::UUID, 'e7b82c88-0422-577f-a63d-5ec1db376c66'::UUID, 'multiple_choice', 4, '“预订” có nghĩa phù hợp nhất là gì?', NULL, 'đặt trước', '预订 (yùdìng) nghĩa là “đặt trước”.', NULL, 1, '{"activity_type":"chinese_to_vietnamese","vocabulary_key":"travel:预订"}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('bacba8bc-7280-5b75-8864-f535fe765c8f'::UUID, '820a1b87-624f-5491-97d8-3aeea306042d'::UUID, 'quầy lễ tân', FALSE, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('221a6afe-4cec-5dae-8533-ced4d411f297'::UUID, '820a1b87-624f-5491-97d8-3aeea306042d'::UUID, 'trả phòng', FALSE, 2)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('3f09b7e5-4506-51aa-8982-5c2f881e0846'::UUID, '820a1b87-624f-5491-97d8-3aeea306042d'::UUID, 'đặt trước', TRUE, 3)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('7b958598-59ba-5ce0-994a-9c1522ed55b2'::UUID, 'e7b82c88-0422-577f-a63d-5ec1db376c66'::UUID, 'translation', 5, 'Dịch sang tiếng Trung: “Tôi đã đặt một phòng đôi.”', NULL, '我已经预订了一个双人间。', 'Mẫu câu dùng “预订” trong ngữ cảnh của bài.', 'yùdìng', 1, '{"activity_type":"vietnamese_to_chinese","source_lang":"vi","target_lang":"zh","acceptable_answers":["我已经预订了一个双人间。"]}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('aac02a08-e06a-59c2-9f55-099b92c65515'::UUID, 'e7b82c88-0422-577f-a63d-5ec1db376c66'::UUID, 'sentence_builder', 6, 'Sắp xếp các thành phần thành câu đúng.', NULL, '我已经预订了一个双人间。', 'Trật tự đúng tạo thành câu “我已经预订了一个双人间。”.', NULL, 1, '{"activity_type":"sentence_ordering","words":["我","已经","预订","了","一个","双人间","。"],"correct_order":["我","已经","预订","了","一个","双人间","。"]}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('466c3006-80bd-58e1-8eb8-a5ffd2ccf4e0'::UUID, 'e7b82c88-0422-577f-a63d-5ec1db376c66'::UUID, 'multiple_choice', 7, 'Câu nào xác nhận đã đặt phòng?', NULL, '我已经预订了一个双人间。', '了 sau động từ đánh dấu hành động đã hoàn tất.', NULL, 1, '{"activity_type":"grammar_selection","passage":null,"grammar_key":"travel:khach-san"}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('e2c847f0-d85d-593f-880d-d90d1a67fd4c'::UUID, '466c3006-80bd-58e1-8eb8-a5ffd2ccf4e0'::UUID, '我已经预订了一个双人间。', TRUE, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('45f23c45-318b-572b-b29a-d1253c597230'::UUID, '466c3006-80bd-58e1-8eb8-a5ffd2ccf4e0'::UUID, '。双人间一个了预订已经我', FALSE, 2)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('b188eea6-97ea-5dce-9c2c-25fe07224bda'::UUID, '466c3006-80bd-58e1-8eb8-a5ffd2ccf4e0'::UUID, '已经预订了一个双人间。我', FALSE, 3)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('1f81881c-b53e-59a1-ab89-4e19fddbdb93'::UUID, 'e7b82c88-0422-577f-a63d-5ec1db376c66'::UUID, 'speaking', 8, 'Đọc thành tiếng: 我已经预订了一个双人间。', NULL, '我已经预订了一个双人间。', 'Đọc chậm, giữ đúng thanh điệu và nhịp của cả câu.', NULL, 1, '{"activity_type":"pronunciation","text":"我已经预订了一个双人间。","pinyin":"Wǒ yǐjīng yùdìng le yí ge shuāngrénjiān."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.units (id, course_id, slug, title, description, order_index, status, learning_objectives, content_version)
VALUES ('a28e6b3b-9760-54e8-a8e2-e426cd819730'::UUID, '09663c66-0d0d-5bf3-88cc-c7bd5eb7d17f'::UUID, 'travel-van-dung', 'Vận dụng', 'Vận dụng mẫu câu trong ngữ cảnh có ý nghĩa.', 2, 'review', '["Giao tiếp tại nơi lưu trú","Xử lý thay đổi và sự cố"]'::JSONB, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.chapters (id, unit_id, slug, title, description, order_index, status, learning_objectives, content_version)
VALUES ('667acf53-8feb-57e2-ad67-4596dd17843c'::UUID, 'a28e6b3b-9760-54e8-a8e2-e426cd819730'::UUID, 'travel-van-dung-chapter', 'Ngữ cảnh thực tế', 'Vận dụng mẫu câu trong ngữ cảnh có ý nghĩa.', 1, 'review', '["Giao tiếp tại nơi lưu trú","Xử lý thay đổi và sự cố"]'::JSONB, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lessons (id, chapter_id, slug, title, description, order_index, xp_reward, status, lesson_type, estimated_minutes, learning_objectives, cultural_note, content_version)
VALUES ('0f97f8ff-e0bd-53e1-a965-34ce17d6a0e1'::UUID, '667acf53-8feb-57e2-ad67-4596dd17843c'::UUID, 'hoi-duong', '换乘地铁 — Đổi tuyến', 'Hỏi đường và đổi phương tiện.', 1, 25, 'review', 'standard', 15, '["Hiểu chỉ dẫn nhiều chặng"]'::JSONB, '再 trong cấu trúc này chỉ bước tiếp theo.', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('4fe7cbea-b7de-5328-8886-daf6e2bbfcd1'::UUID, 'travel:换乘', '换乘', 'huànchéng', 'chuyển tuyến', 'transfer', 'elementary', 'hoi-duong', 'động từ', '在中心站换乘二号线。', 'Zài Zhōngxīn Zhàn huànchéng èr hào xiàn.', 'Chuyển sang tuyến số 2 tại ga Trung Tâm.', NULL, 'review', '0f97f8ff-e0bd-53e1-a965-34ce17d6a0e1'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('43744320-206f-5565-8dcd-a2a75db80bde'::UUID, '0f97f8ff-e0bd-53e1-a965-34ce17d6a0e1'::UUID, '4fe7cbea-b7de-5328-8886-daf6e2bbfcd1'::UUID, 1, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('255cbc39-894d-5070-9d0b-503daaa7aec4'::UUID, 'travel:出口', '出口', 'chūkǒu', 'lối ra', 'exit', 'elementary', 'hoi-duong', 'danh từ', '博物馆离三号出口最近。', 'Bówùguǎn lí sān hào chūkǒu zuì jìn.', 'Bảo tàng gần lối ra số 3 nhất.', NULL, 'review', '0f97f8ff-e0bd-53e1-a965-34ce17d6a0e1'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('82464941-dc22-5f6b-b0db-2b5b110a8851'::UUID, '0f97f8ff-e0bd-53e1-a965-34ce17d6a0e1'::UUID, '255cbc39-894d-5070-9d0b-503daaa7aec4'::UUID, 2, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('a503c3a9-7da0-58bf-bf3c-f81cbaacce4e'::UUID, 'travel:直走', '直走', 'zhízǒu', 'đi thẳng', 'go straight', 'elementary', 'hoi-duong', 'động từ', '从这里直走五百米。', 'Cóng zhèlǐ zhízǒu wǔbǎi mǐ.', 'Từ đây đi thẳng 500 mét.', NULL, 'review', '0f97f8ff-e0bd-53e1-a965-34ce17d6a0e1'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('1ec218d2-c625-5950-a68c-e223680ef8c4'::UUID, '0f97f8ff-e0bd-53e1-a965-34ce17d6a0e1'::UUID, 'a503c3a9-7da0-58bf-bf3c-f81cbaacce4e'::UUID, 3, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('8bd0f6ff-d561-5e30-8d65-9e9372900621'::UUID, '0f97f8ff-e0bd-53e1-a965-34ce17d6a0e1'::UUID, '7f5bf3bd-dc14-54ee-a679-c6a62c567d13'::UUID, 4, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('b120db0b-5ab2-5daf-b6f2-8bf8260b7aed'::UUID, '0f97f8ff-e0bd-53e1-a965-34ce17d6a0e1'::UUID, 'c67e9ca2-bc20-5d76-a5ca-dfc1389f5d39'::UUID, 5, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('c6c09b1c-6c5a-52a1-aa83-a28a380535b6'::UUID, '0f97f8ff-e0bd-53e1-a965-34ce17d6a0e1'::UUID, '61ba05a2-3c46-5974-b337-e62065fe3f6c'::UUID, 6, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.grammar_lessons (id, content_key, title, pattern, explanation, example_chinese, example_pinyin, example_meaning, level, status, usage_note, content_version)
VALUES ('ef5d60d0-f3ab-5728-a0aa-731b186ddb26'::UUID, 'travel:hoi-duong', 'Chỉ lộ trình với 先…再…', '先 + bước 1，再 + bước 2', 'Cặp nối sắp xếp hai bước theo thời gian.', '先坐一号线，再换乘二号线。', 'Xiān zuò yī hào xiàn, zài huànchéng èr hào xiàn.', 'Đi tuyến số 1 trước, rồi chuyển tuyến số 2.', 'elementary', 'review', NULL, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_grammar (id, lesson_id, grammar_lesson_id, order_index, curriculum_role)
VALUES ('6a78b8d3-8855-5b42-9af7-28f32a0bb57e'::UUID, '0f97f8ff-e0bd-53e1-a965-34ce17d6a0e1'::UUID, 'ef5d60d0-f3ab-5728-a0aa-731b186ddb26'::UUID, 1, 'introduced')
ON CONFLICT (lesson_id, grammar_lesson_id) DO NOTHING;

INSERT INTO public.lesson_grammar (id, lesson_id, grammar_lesson_id, order_index, curriculum_role)
VALUES ('12495ed4-4662-539c-86ab-0d7048c4aa67'::UUID, '0f97f8ff-e0bd-53e1-a965-34ce17d6a0e1'::UUID, '89d2faaa-6906-5e7c-ae52-503a9c98dd24'::UUID, 2, 'review')
ON CONFLICT (lesson_id, grammar_lesson_id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('b28851cb-0a83-5b1a-958b-4ea48e8b4bbd'::UUID, '0f97f8ff-e0bd-53e1-a965-34ce17d6a0e1'::UUID, 'vocabulary', 1, 'Từ mới: 换乘', NULL, '换乘', '换乘 (huànchéng) — chuyển tuyến. 在中心站换乘二号线。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"travel:换乘","chinese":"换乘","pinyin":"huànchéng","meaning":"chuyển tuyến","part_of_speech":"động từ","example_chinese":"在中心站换乘二号线。","example_pinyin":"Zài Zhōngxīn Zhàn huànchéng èr hào xiàn.","example_meaning_vi":"Chuyển sang tuyến số 2 tại ga Trung Tâm."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('7e71d26a-4cf7-5361-965f-06434b6eb7d6'::UUID, '0f97f8ff-e0bd-53e1-a965-34ce17d6a0e1'::UUID, 'vocabulary', 2, 'Từ mới: 出口', NULL, '出口', '出口 (chūkǒu) — lối ra. 博物馆离三号出口最近。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"travel:出口","chinese":"出口","pinyin":"chūkǒu","meaning":"lối ra","part_of_speech":"danh từ","example_chinese":"博物馆离三号出口最近。","example_pinyin":"Bówùguǎn lí sān hào chūkǒu zuì jìn.","example_meaning_vi":"Bảo tàng gần lối ra số 3 nhất."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('4055524a-6aa7-50b8-914e-73ccbc1e655a'::UUID, '0f97f8ff-e0bd-53e1-a965-34ce17d6a0e1'::UUID, 'vocabulary', 3, 'Từ mới: 直走', NULL, '直走', '直走 (zhízǒu) — đi thẳng. 从这里直走五百米。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"travel:直走","chinese":"直走","pinyin":"zhízǒu","meaning":"đi thẳng","part_of_speech":"động từ","example_chinese":"从这里直走五百米。","example_pinyin":"Cóng zhèlǐ zhízǒu wǔbǎi mǐ.","example_meaning_vi":"Từ đây đi thẳng 500 mét."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('03ee479e-02cf-5029-99b5-6b65b3b0aeb8'::UUID, '0f97f8ff-e0bd-53e1-a965-34ce17d6a0e1'::UUID, 'multiple_choice', 4, '“换乘” có nghĩa phù hợp nhất là gì?', NULL, 'chuyển tuyến', '换乘 (huànchéng) nghĩa là “chuyển tuyến”.', NULL, 1, '{"activity_type":"chinese_to_vietnamese","vocabulary_key":"travel:换乘"}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('d97c24df-ccd7-50c0-938c-47ff48469f76'::UUID, '03ee479e-02cf-5029-99b5-6b65b3b0aeb8'::UUID, 'chuyển tuyến', TRUE, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('6eb7983d-0bd1-57a8-8193-b72113ea2e31'::UUID, '03ee479e-02cf-5029-99b5-6b65b3b0aeb8'::UUID, 'lối ra', FALSE, 2)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('8a764c0a-591c-58aa-9e6b-de09d15a0db7'::UUID, '03ee479e-02cf-5029-99b5-6b65b3b0aeb8'::UUID, 'đi thẳng', FALSE, 3)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('82530065-6301-5a9d-906e-5b9d8b21425d'::UUID, '0f97f8ff-e0bd-53e1-a965-34ce17d6a0e1'::UUID, 'translation', 5, 'Dịch sang tiếng Trung: “Đi tuyến số 1 trước, rồi chuyển tuyến số 2.”', NULL, '先坐一号线，再换乘二号线。', 'Mẫu câu dùng “换乘” trong ngữ cảnh của bài.', 'huànchéng', 1, '{"activity_type":"vietnamese_to_chinese","source_lang":"vi","target_lang":"zh","acceptable_answers":["先坐一号线，再换乘二号线。"]}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('67d70b3d-2093-52bf-b42d-f5a1a6b66852'::UUID, '0f97f8ff-e0bd-53e1-a965-34ce17d6a0e1'::UUID, 'sentence_builder', 6, 'Sắp xếp các thành phần thành câu đúng.', NULL, '先坐一号线，再换乘二号线。', 'Trật tự đúng tạo thành câu “先坐一号线，再换乘二号线。”.', NULL, 1, '{"activity_type":"sentence_ordering","words":["先","坐","一号线","，","再","换乘","二号线","。"],"correct_order":["先","坐","一号线","，","再","换乘","二号线","。"]}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('de3c6299-b249-566c-a563-aeb093fcccec'::UUID, '0f97f8ff-e0bd-53e1-a965-34ce17d6a0e1'::UUID, 'multiple_choice', 7, 'Câu nào chỉ đúng trình tự đổi tuyến?', NULL, '先坐一号线，再换乘二号线。', 'Cặp nối sắp xếp hai bước theo thời gian.', NULL, 1, '{"activity_type":"grammar_selection","passage":null,"grammar_key":"travel:hoi-duong"}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('9aaa9b62-b65c-53d5-b9cc-4cf2f4e91cf8'::UUID, 'de3c6299-b249-566c-a563-aeb093fcccec'::UUID, '先坐一号线，再换乘二号线。', TRUE, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('2c25c3d8-23b0-550f-808a-82c78f7736db'::UUID, 'de3c6299-b249-566c-a563-aeb093fcccec'::UUID, '。二号线换乘再，一号线坐先', FALSE, 2)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('a5c5a5c2-4bcf-579b-9e95-0a39c9b0086d'::UUID, 'de3c6299-b249-566c-a563-aeb093fcccec'::UUID, '坐一号线，再换乘二号线。先', FALSE, 3)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('65ed661b-9035-5784-9647-320689230d55'::UUID, '0f97f8ff-e0bd-53e1-a965-34ce17d6a0e1'::UUID, 'speaking', 8, 'Đọc thành tiếng: 先坐一号线，再换乘二号线。', NULL, '先坐一号线，再换乘二号线。', 'Đọc chậm, giữ đúng thanh điệu và nhịp của cả câu.', NULL, 1, '{"activity_type":"pronunciation","text":"先坐一号线，再换乘二号线。","pinyin":"Xiān zuò yī hào xiàn, zài huànchéng èr hào xiàn."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lessons (id, chapter_id, slug, title, description, order_index, xp_reward, status, lesson_type, estimated_minutes, learning_objectives, cultural_note, content_version)
VALUES ('dbabad25-e3a0-57d6-b962-8f5521aca9aa'::UUID, '667acf53-8feb-57e2-ad67-4596dd17843c'::UUID, 'su-co', '航班延误 — Sự cố hành trình', 'Báo mất đồ và xử lý chuyến bị chậm.', 2, 25, 'review', 'standard', 15, '["Yêu cầu hỗ trợ khi có sự cố"]'::JSONB, 'Nêu rõ đối tượng trước 可以 để tránh mơ hồ.', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('ab1c064b-f4ff-5fca-abc8-3abf7f95840f'::UUID, 'travel:延误', '延误', 'yánwù', 'chậm trễ', 'delay', 'elementary', 'su-co', 'động từ/danh từ', '航班因为天气延误了。', 'Hángbān yīnwèi tiānqì yánwù le.', 'Chuyến bay bị chậm do thời tiết.', NULL, 'review', 'dbabad25-e3a0-57d6-b962-8f5521aca9aa'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('81f4ea1e-775b-5657-8df5-0cda388d9fa4'::UUID, 'dbabad25-e3a0-57d6-b962-8f5521aca9aa'::UUID, 'ab1c064b-f4ff-5fca-abc8-3abf7f95840f'::UUID, 1, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('4db69dcf-b4a7-568f-999e-49d7134aa7b1'::UUID, 'travel:丢失', '丢失', 'diūshī', 'thất lạc', 'lose; be missing', 'elementary', 'su-co', 'động từ', '我的行李在途中丢失了。', 'Wǒ de xíngli zài túzhōng diūshī le.', 'Hành lý của tôi bị thất lạc trên đường.', NULL, 'review', 'dbabad25-e3a0-57d6-b962-8f5521aca9aa'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('eca7fa9f-fcdf-5667-aea1-95c85d4010b2'::UUID, 'dbabad25-e3a0-57d6-b962-8f5521aca9aa'::UUID, '4db69dcf-b4a7-568f-999e-49d7134aa7b1'::UUID, 2, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('928a7357-1963-5c1a-9832-ea3ce28c59d8'::UUID, 'travel:改签', '改签', 'gǎiqiān', 'đổi vé', 'rebook', 'elementary', 'su-co', 'động từ', '我想把机票改签到明天。', 'Wǒ xiǎng bǎ jīpiào gǎiqiān dào míngtiān.', 'Tôi muốn đổi vé máy bay sang ngày mai.', NULL, 'review', 'dbabad25-e3a0-57d6-b962-8f5521aca9aa'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('a62b7549-ca84-5be5-9ede-72da135b7100'::UUID, 'dbabad25-e3a0-57d6-b962-8f5521aca9aa'::UUID, '928a7357-1963-5c1a-9832-ea3ce28c59d8'::UUID, 3, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('aa6ac49c-fbcb-567b-8c8d-1cadd24e26af'::UUID, 'dbabad25-e3a0-57d6-b962-8f5521aca9aa'::UUID, '4fe7cbea-b7de-5328-8886-daf6e2bbfcd1'::UUID, 4, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('2218d209-636d-5902-84da-a2aaf3b36122'::UUID, 'dbabad25-e3a0-57d6-b962-8f5521aca9aa'::UUID, '255cbc39-894d-5070-9d0b-503daaa7aec4'::UUID, 5, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('68b96dd6-b5f9-522a-b2c3-e189ba4ea145'::UUID, 'dbabad25-e3a0-57d6-b962-8f5521aca9aa'::UUID, 'a503c3a9-7da0-58bf-bf3c-f81cbaacce4e'::UUID, 6, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.grammar_lessons (id, content_key, title, pattern, explanation, example_chinese, example_pinyin, example_meaning, level, status, usage_note, content_version)
VALUES ('7cb7abcf-83a7-5c1a-9546-8a23722c9d10'::UUID, 'travel:su-co', 'Yêu cầu xử lý với 可以…吗', '可以 + động từ + 吗', 'Câu hỏi xin phép hoặc hỏi khả năng dịch vụ.', '这个航班可以免费改签吗？', 'Zhège hángbān kěyǐ miǎnfèi gǎiqiān ma?', 'Chuyến bay này có thể đổi vé miễn phí không?', 'elementary', 'review', NULL, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_grammar (id, lesson_id, grammar_lesson_id, order_index, curriculum_role)
VALUES ('5811fc3d-0053-52df-a195-774622a482fd'::UUID, 'dbabad25-e3a0-57d6-b962-8f5521aca9aa'::UUID, '7cb7abcf-83a7-5c1a-9546-8a23722c9d10'::UUID, 1, 'introduced')
ON CONFLICT (lesson_id, grammar_lesson_id) DO NOTHING;

INSERT INTO public.lesson_grammar (id, lesson_id, grammar_lesson_id, order_index, curriculum_role)
VALUES ('6b49c34c-d6f6-56b8-b1a8-96e86e5ded8e'::UUID, 'dbabad25-e3a0-57d6-b962-8f5521aca9aa'::UUID, 'ef5d60d0-f3ab-5728-a0aa-731b186ddb26'::UUID, 2, 'review')
ON CONFLICT (lesson_id, grammar_lesson_id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('21eef112-67e5-5285-93d6-18118f72071d'::UUID, 'dbabad25-e3a0-57d6-b962-8f5521aca9aa'::UUID, 'vocabulary', 1, 'Từ mới: 延误', NULL, '延误', '延误 (yánwù) — chậm trễ. 航班因为天气延误了。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"travel:延误","chinese":"延误","pinyin":"yánwù","meaning":"chậm trễ","part_of_speech":"động từ/danh từ","example_chinese":"航班因为天气延误了。","example_pinyin":"Hángbān yīnwèi tiānqì yánwù le.","example_meaning_vi":"Chuyến bay bị chậm do thời tiết."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('50bc3945-811a-587a-8c4d-b52ecc435c6f'::UUID, 'dbabad25-e3a0-57d6-b962-8f5521aca9aa'::UUID, 'vocabulary', 2, 'Từ mới: 丢失', NULL, '丢失', '丢失 (diūshī) — thất lạc. 我的行李在途中丢失了。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"travel:丢失","chinese":"丢失","pinyin":"diūshī","meaning":"thất lạc","part_of_speech":"động từ","example_chinese":"我的行李在途中丢失了。","example_pinyin":"Wǒ de xíngli zài túzhōng diūshī le.","example_meaning_vi":"Hành lý của tôi bị thất lạc trên đường."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('c880443d-818b-5cdf-9af2-a47796841f7f'::UUID, 'dbabad25-e3a0-57d6-b962-8f5521aca9aa'::UUID, 'vocabulary', 3, 'Từ mới: 改签', NULL, '改签', '改签 (gǎiqiān) — đổi vé. 我想把机票改签到明天。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"travel:改签","chinese":"改签","pinyin":"gǎiqiān","meaning":"đổi vé","part_of_speech":"động từ","example_chinese":"我想把机票改签到明天。","example_pinyin":"Wǒ xiǎng bǎ jīpiào gǎiqiān dào míngtiān.","example_meaning_vi":"Tôi muốn đổi vé máy bay sang ngày mai."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('a19ee071-2412-537c-ab4a-ee9ecb1629d0'::UUID, 'dbabad25-e3a0-57d6-b962-8f5521aca9aa'::UUID, 'multiple_choice', 4, '“延误” có nghĩa phù hợp nhất là gì?', NULL, 'chậm trễ', '延误 (yánwù) nghĩa là “chậm trễ”.', NULL, 1, '{"activity_type":"chinese_to_vietnamese","vocabulary_key":"travel:延误"}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('920f4a6d-5777-513b-babb-8902a70e64f3'::UUID, 'a19ee071-2412-537c-ab4a-ee9ecb1629d0'::UUID, 'thất lạc', FALSE, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('29cc07d2-044c-54cf-aa42-29111b528c69'::UUID, 'a19ee071-2412-537c-ab4a-ee9ecb1629d0'::UUID, 'đổi vé', FALSE, 2)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('f6f71feb-1382-56aa-abcb-6bb0a35830f9'::UUID, 'a19ee071-2412-537c-ab4a-ee9ecb1629d0'::UUID, 'chậm trễ', TRUE, 3)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('defd60f6-58c2-5f79-abac-8db6ad3022d1'::UUID, 'dbabad25-e3a0-57d6-b962-8f5521aca9aa'::UUID, 'translation', 5, 'Dịch sang tiếng Trung: “Chuyến bay này có thể đổi vé miễn phí không?”', NULL, '这个航班可以免费改签吗？', 'Mẫu câu dùng “延误” trong ngữ cảnh của bài.', 'yánwù', 1, '{"activity_type":"vietnamese_to_chinese","source_lang":"vi","target_lang":"zh","acceptable_answers":["这个航班可以免费改签吗？"]}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('4f69c296-4057-511f-b722-5f5cf1d7b553'::UUID, 'dbabad25-e3a0-57d6-b962-8f5521aca9aa'::UUID, 'sentence_builder', 6, 'Sắp xếp các thành phần thành câu đúng.', NULL, '这个航班可以免费改签吗？', 'Trật tự đúng tạo thành câu “这个航班可以免费改签吗？”.', NULL, 1, '{"activity_type":"sentence_ordering","words":["这个","航班","可以","免费","改签","吗","？"],"correct_order":["这个","航班","可以","免费","改签","吗","？"]}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('073b9221-4417-56fb-911a-8d07eed7e6fc'::UUID, 'dbabad25-e3a0-57d6-b962-8f5521aca9aa'::UUID, 'multiple_choice', 7, 'Câu nào hỏi đúng về đổi vé?', NULL, '这个航班可以免费改签吗？', 'Câu hỏi xin phép hoặc hỏi khả năng dịch vụ.', NULL, 1, '{"activity_type":"grammar_selection","passage":null,"grammar_key":"travel:su-co"}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('6735d639-fc0d-5147-969e-dd598d65ddb7'::UUID, '073b9221-4417-56fb-911a-8d07eed7e6fc'::UUID, '这个航班可以免费改签吗？', TRUE, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('49f4f29f-c4cf-57f0-bebd-daa0e27a048f'::UUID, '073b9221-4417-56fb-911a-8d07eed7e6fc'::UUID, '？吗改签免费可以航班这个', FALSE, 2)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('48a53798-01e1-577a-bf8e-6cbe40989a87'::UUID, '073b9221-4417-56fb-911a-8d07eed7e6fc'::UUID, '航班可以免费改签吗？这个', FALSE, 3)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('4d5890e7-898d-5812-8e45-b4bb55f099af'::UUID, 'dbabad25-e3a0-57d6-b962-8f5521aca9aa'::UUID, 'speaking', 8, 'Đọc thành tiếng: 这个航班可以免费改签吗？', NULL, '这个航班可以免费改签吗？', 'Đọc chậm, giữ đúng thanh điệu và nhịp của cả câu.', NULL, 1, '{"activity_type":"pronunciation","text":"这个航班可以免费改签吗？","pinyin":"Zhège hángbān kěyǐ miǎnfèi gǎiqiān ma?"}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.units (id, course_id, slug, title, description, order_index, status, learning_objectives, content_version)
VALUES ('ac4fb1b9-c1a1-5e75-9e0c-ab8970928516'::UUID, '09663c66-0d0d-5bf3-88cc-c7bd5eb7d17f'::UUID, 'travel-on-tap', 'Ôn tập', 'Kiểm tra và củng cố nội dung đã học.', 3, 'review', '["Ôn từ vựng","Ôn mẫu câu"]'::JSONB, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.chapters (id, unit_id, slug, title, description, order_index, status, learning_objectives, content_version)
VALUES ('9d0386f2-01c5-525e-9be1-c4d9009d0b4d'::UUID, 'ac4fb1b9-c1a1-5e75-9e0c-ab8970928516'::UUID, 'travel-on-tap-chapter', 'Củng cố lộ trình', 'Kiểm tra và củng cố nội dung đã học.', 1, 'review', '["Ôn từ vựng","Ôn mẫu câu"]'::JSONB, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lessons (id, chapter_id, slug, title, description, order_index, xp_reward, status, lesson_type, estimated_minutes, learning_objectives, cultural_note, content_version)
VALUES ('bb6a8afe-b064-5cd0-adc2-6eea3f59e311'::UUID, '9d0386f2-01c5-525e-9be1-c4d9009d0b4d'::UUID, 'travel-review', 'Ôn tập Chinese for Travel', 'Củng cố từ vựng, mẫu câu và khả năng diễn đạt của toàn khóa.', 1, 30, 'review', 'review', 18, '["Vận dụng lại từ vựng trọng tâm","Tự kiểm tra mẫu câu đã học"]'::JSONB, NULL, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('32e18b88-6915-5fd9-b812-b4a1397edf13'::UUID, 'bb6a8afe-b064-5cd0-adc2-6eea3f59e311'::UUID, 'ab1c064b-f4ff-5fca-abc8-3abf7f95840f'::UUID, 1, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('14ad2ee1-7a53-5fd4-a06f-5e427cc5c0da'::UUID, 'bb6a8afe-b064-5cd0-adc2-6eea3f59e311'::UUID, '4db69dcf-b4a7-568f-999e-49d7134aa7b1'::UUID, 2, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('4374bc9e-28de-5ae6-a4e4-e045c6659dd5'::UUID, 'bb6a8afe-b064-5cd0-adc2-6eea3f59e311'::UUID, '928a7357-1963-5c1a-9832-ea3ce28c59d8'::UUID, 3, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_grammar (id, lesson_id, grammar_lesson_id, order_index, curriculum_role)
VALUES ('f66f2fd0-ae53-597f-9b78-1b8f10b1b0dd'::UUID, 'bb6a8afe-b064-5cd0-adc2-6eea3f59e311'::UUID, '7cb7abcf-83a7-5c1a-9546-8a23722c9d10'::UUID, 1, 'review')
ON CONFLICT (lesson_id, grammar_lesson_id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('e33abd5e-e954-51ad-abd0-92d2ce3ee719'::UUID, 'bb6a8afe-b064-5cd0-adc2-6eea3f59e311'::UUID, 'multiple_choice', 1, '“延误” có nghĩa phù hợp nhất là gì?', NULL, 'chậm trễ', '延误 (yánwù) nghĩa là “chậm trễ”.', NULL, 1, '{"activity_type":"chinese_to_vietnamese","vocabulary_key":"travel:延误"}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('30429c19-6060-5d5f-a52d-7b76bce10ebe'::UUID, 'e33abd5e-e954-51ad-abd0-92d2ce3ee719'::UUID, 'thất lạc', FALSE, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('daa66311-8725-5303-b724-7bdb83e03436'::UUID, 'e33abd5e-e954-51ad-abd0-92d2ce3ee719'::UUID, 'đổi vé', FALSE, 2)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('9b46f784-006a-51f8-bfad-603a4e14498d'::UUID, 'e33abd5e-e954-51ad-abd0-92d2ce3ee719'::UUID, 'chậm trễ', TRUE, 3)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('8e1676de-3276-5368-a5c0-d5ba03179c4f'::UUID, 'bb6a8afe-b064-5cd0-adc2-6eea3f59e311'::UUID, 'translation', 2, 'Dịch sang tiếng Trung: “Chuyến bay này có thể đổi vé miễn phí không?”', NULL, '这个航班可以免费改签吗？', 'Mẫu câu dùng “延误” trong ngữ cảnh của bài.', 'yánwù', 1, '{"activity_type":"vietnamese_to_chinese","source_lang":"vi","target_lang":"zh","acceptable_answers":["这个航班可以免费改签吗？"]}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('8b94ab81-e4b1-5184-96f8-c9220ba70307'::UUID, 'bb6a8afe-b064-5cd0-adc2-6eea3f59e311'::UUID, 'sentence_builder', 3, 'Sắp xếp các thành phần thành câu đúng.', NULL, '这个航班可以免费改签吗？', 'Trật tự đúng tạo thành câu “这个航班可以免费改签吗？”.', NULL, 1, '{"activity_type":"sentence_ordering","words":["这个","航班","可以","免费","改签","吗","？"],"correct_order":["这个","航班","可以","免费","改签","吗","？"]}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('f5757dfa-ae4d-5a44-bac7-e2b460feaa05'::UUID, 'bb6a8afe-b064-5cd0-adc2-6eea3f59e311'::UUID, 'multiple_choice', 4, 'Câu nào hỏi đúng về đổi vé?', NULL, '这个航班可以免费改签吗？', 'Câu hỏi xin phép hoặc hỏi khả năng dịch vụ.', NULL, 1, '{"activity_type":"grammar_selection","passage":null,"grammar_key":"travel:su-co"}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('99706c2f-543c-5b1d-ba29-5e5a376ba86a'::UUID, 'f5757dfa-ae4d-5a44-bac7-e2b460feaa05'::UUID, '这个航班可以免费改签吗？', TRUE, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('9a07da7d-a94a-51a2-b513-514b12d4bd18'::UUID, 'f5757dfa-ae4d-5a44-bac7-e2b460feaa05'::UUID, '？吗改签免费可以航班这个', FALSE, 2)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('a7e111fd-44ea-5c07-b7fa-835e219ee5a8'::UUID, 'f5757dfa-ae4d-5a44-bac7-e2b460feaa05'::UUID, '航班可以免费改签吗？这个', FALSE, 3)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('fa809237-1171-53fb-9179-c1d9f3f1b251'::UUID, 'bb6a8afe-b064-5cd0-adc2-6eea3f59e311'::UUID, 'speaking', 5, 'Đọc thành tiếng: 这个航班可以免费改签吗？', NULL, '这个航班可以免费改签吗？', 'Đọc chậm, giữ đúng thanh điệu và nhịp của cả câu.', NULL, 1, '{"activity_type":"pronunciation","text":"这个航班可以免费改签吗？","pinyin":"Zhège hángbān kěyǐ miǎnfèi gǎiqiān ma?"}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.content_batches (id, batch_key, version, migration_name, manifest_checksum, expected_counts)
VALUES ('48025798-bccd-5b31-ae8c-2368f344f7b9'::UUID, 'batch-09-travel', 1, '20260729180000_content_batch_09_travel', 'dad8746761517781bc4002aa25ad57d4fa5ed4645ee7c5a78d63cb1e9a1456d7', '{"courses":1,"units":3,"chapters":3,"lessons":5,"vocabulary":12,"grammar":4,"characters":0,"exercises":37,"options":30}'::JSONB)
ON CONFLICT (batch_key, version) DO NOTHING;

DO $content_validation$
BEGIN
  IF (SELECT COUNT(*) FROM public.courses WHERE id = ANY(ARRAY['09663c66-0d0d-5bf3-88cc-c7bd5eb7d17f'::UUID]::UUID[])) <> 1 THEN
    RAISE EXCEPTION 'Content batch batch-09-travel is missing managed courses rows';
  END IF;
  IF (SELECT COUNT(*) FROM public.units WHERE id = ANY(ARRAY['389544b8-1d84-5b90-baaf-3357fba9e1ae'::UUID, 'a28e6b3b-9760-54e8-a8e2-e426cd819730'::UUID, 'ac4fb1b9-c1a1-5e75-9e0c-ab8970928516'::UUID]::UUID[])) <> 3 THEN
    RAISE EXCEPTION 'Content batch batch-09-travel is missing managed units rows';
  END IF;
  IF (SELECT COUNT(*) FROM public.chapters WHERE id = ANY(ARRAY['f16a2ddc-3e64-59ab-8aea-15fd9466fa12'::UUID, '667acf53-8feb-57e2-ad67-4596dd17843c'::UUID, '9d0386f2-01c5-525e-9be1-c4d9009d0b4d'::UUID]::UUID[])) <> 3 THEN
    RAISE EXCEPTION 'Content batch batch-09-travel is missing managed chapters rows';
  END IF;
  IF (SELECT COUNT(*) FROM public.lessons WHERE id = ANY(ARRAY['cd86a494-4f77-50a4-9514-c10703882434'::UUID, 'e7b82c88-0422-577f-a63d-5ec1db376c66'::UUID, '0f97f8ff-e0bd-53e1-a965-34ce17d6a0e1'::UUID, 'dbabad25-e3a0-57d6-b962-8f5521aca9aa'::UUID, 'bb6a8afe-b064-5cd0-adc2-6eea3f59e311'::UUID]::UUID[])) <> 5 THEN
    RAISE EXCEPTION 'Content batch batch-09-travel is missing managed lessons rows';
  END IF;
  IF (SELECT COUNT(*) FROM public.vocabulary WHERE id = ANY(ARRAY['afe3257d-ee40-59aa-b9e7-ce445e203874'::UUID, '3adeaafd-d279-579c-848e-aaef1dd91792'::UUID, '4b026097-241e-528f-8c09-afbd02bce060'::UUID, '7f5bf3bd-dc14-54ee-a679-c6a62c567d13'::UUID, 'c67e9ca2-bc20-5d76-a5ca-dfc1389f5d39'::UUID, '61ba05a2-3c46-5974-b337-e62065fe3f6c'::UUID, '4fe7cbea-b7de-5328-8886-daf6e2bbfcd1'::UUID, '255cbc39-894d-5070-9d0b-503daaa7aec4'::UUID, 'a503c3a9-7da0-58bf-bf3c-f81cbaacce4e'::UUID, 'ab1c064b-f4ff-5fca-abc8-3abf7f95840f'::UUID, '4db69dcf-b4a7-568f-999e-49d7134aa7b1'::UUID, '928a7357-1963-5c1a-9832-ea3ce28c59d8'::UUID]::UUID[])) <> 12 THEN
    RAISE EXCEPTION 'Content batch batch-09-travel is missing managed vocabulary rows';
  END IF;
  IF (SELECT COUNT(*) FROM public.grammar_lessons WHERE id = ANY(ARRAY['d1904929-dd79-5080-9ba8-a6a14bcefc5a'::UUID, '89d2faaa-6906-5e7c-ae52-503a9c98dd24'::UUID, 'ef5d60d0-f3ab-5728-a0aa-731b186ddb26'::UUID, '7cb7abcf-83a7-5c1a-9546-8a23722c9d10'::UUID]::UUID[])) <> 4 THEN
    RAISE EXCEPTION 'Content batch batch-09-travel is missing managed grammar_lessons rows';
  END IF;
  IF (SELECT COUNT(*) FROM public.exercises WHERE id = ANY(ARRAY['426a9cee-630e-5b6a-818e-9076b1be20aa'::UUID, '2c1ede9f-3911-52af-9451-df81eedc0aea'::UUID, 'c67c671a-ed78-55d4-95ee-6eb7218b34bd'::UUID, '9ba1718e-288b-5fcf-acbd-08ff8aed83a7'::UUID, '680df5ec-45d4-56fb-a666-13b6fb1755b5'::UUID, '21518d43-0711-5f51-8627-a2a7845fdfb7'::UUID, '58981e46-3778-539e-9ec4-d230ea34009d'::UUID, '4111b144-447c-5b6d-b387-9adc6bf461bd'::UUID, '5f292e25-c261-5ec3-b2c7-9282dd1c7187'::UUID, 'f309ae75-c227-5e59-8453-9201a0fb1f1d'::UUID, '098bc2c9-7f9c-5a19-a0d6-4b3c96b19196'::UUID, '820a1b87-624f-5491-97d8-3aeea306042d'::UUID, '7b958598-59ba-5ce0-994a-9c1522ed55b2'::UUID, 'aac02a08-e06a-59c2-9f55-099b92c65515'::UUID, '466c3006-80bd-58e1-8eb8-a5ffd2ccf4e0'::UUID, '1f81881c-b53e-59a1-ab89-4e19fddbdb93'::UUID, 'b28851cb-0a83-5b1a-958b-4ea48e8b4bbd'::UUID, '7e71d26a-4cf7-5361-965f-06434b6eb7d6'::UUID, '4055524a-6aa7-50b8-914e-73ccbc1e655a'::UUID, '03ee479e-02cf-5029-99b5-6b65b3b0aeb8'::UUID, '82530065-6301-5a9d-906e-5b9d8b21425d'::UUID, '67d70b3d-2093-52bf-b42d-f5a1a6b66852'::UUID, 'de3c6299-b249-566c-a563-aeb093fcccec'::UUID, '65ed661b-9035-5784-9647-320689230d55'::UUID, '21eef112-67e5-5285-93d6-18118f72071d'::UUID, '50bc3945-811a-587a-8c4d-b52ecc435c6f'::UUID, 'c880443d-818b-5cdf-9af2-a47796841f7f'::UUID, 'a19ee071-2412-537c-ab4a-ee9ecb1629d0'::UUID, 'defd60f6-58c2-5f79-abac-8db6ad3022d1'::UUID, '4f69c296-4057-511f-b722-5f5cf1d7b553'::UUID, '073b9221-4417-56fb-911a-8d07eed7e6fc'::UUID, '4d5890e7-898d-5812-8e45-b4bb55f099af'::UUID, 'e33abd5e-e954-51ad-abd0-92d2ce3ee719'::UUID, '8e1676de-3276-5368-a5c0-d5ba03179c4f'::UUID, '8b94ab81-e4b1-5184-96f8-c9220ba70307'::UUID, 'f5757dfa-ae4d-5a44-bac7-e2b460feaa05'::UUID, 'fa809237-1171-53fb-9179-c1d9f3f1b251'::UUID]::UUID[])) <> 37 THEN
    RAISE EXCEPTION 'Content batch batch-09-travel is missing managed exercises rows';
  END IF;
  IF (SELECT COUNT(*) FROM public.exercise_options WHERE id = ANY(ARRAY['bfa823c6-ccc2-5268-bc84-1bc7468b1929'::UUID, '8e187fcb-ec81-5e72-9fee-d17c78b474f9'::UUID, '9b9a9a55-e2a6-5b69-98dd-e9fe5ec07ab7'::UUID, 'b5ee1e87-aa03-5270-96c9-b54b1a10d339'::UUID, 'dae64db3-dc73-55d6-b6fc-fe56189807ea'::UUID, '552998e5-208c-511a-a2b8-e32dd78dab6d'::UUID, 'bacba8bc-7280-5b75-8864-f535fe765c8f'::UUID, '221a6afe-4cec-5dae-8533-ced4d411f297'::UUID, '3f09b7e5-4506-51aa-8982-5c2f881e0846'::UUID, 'e2c847f0-d85d-593f-880d-d90d1a67fd4c'::UUID, '45f23c45-318b-572b-b29a-d1253c597230'::UUID, 'b188eea6-97ea-5dce-9c2c-25fe07224bda'::UUID, 'd97c24df-ccd7-50c0-938c-47ff48469f76'::UUID, '6eb7983d-0bd1-57a8-8193-b72113ea2e31'::UUID, '8a764c0a-591c-58aa-9e6b-de09d15a0db7'::UUID, '9aaa9b62-b65c-53d5-b9cc-4cf2f4e91cf8'::UUID, '2c25c3d8-23b0-550f-808a-82c78f7736db'::UUID, 'a5c5a5c2-4bcf-579b-9e95-0a39c9b0086d'::UUID, '920f4a6d-5777-513b-babb-8902a70e64f3'::UUID, '29cc07d2-044c-54cf-aa42-29111b528c69'::UUID, 'f6f71feb-1382-56aa-abcb-6bb0a35830f9'::UUID, '6735d639-fc0d-5147-969e-dd598d65ddb7'::UUID, '49f4f29f-c4cf-57f0-bebd-daa0e27a048f'::UUID, '48a53798-01e1-577a-bf8e-6cbe40989a87'::UUID, '30429c19-6060-5d5f-a52d-7b76bce10ebe'::UUID, 'daa66311-8725-5303-b724-7bdb83e03436'::UUID, '9b46f784-006a-51f8-bfad-603a4e14498d'::UUID, '99706c2f-543c-5b1d-ba29-5e5a376ba86a'::UUID, '9a07da7d-a94a-51a2-b513-514b12d4bd18'::UUID, 'a7e111fd-44ea-5c07-b7fa-835e219ee5a8'::UUID]::UUID[])) <> 30 THEN
    RAISE EXCEPTION 'Content batch batch-09-travel is missing managed exercise_options rows';
  END IF;
  IF EXISTS (
    SELECT 1 FROM public.lessons AS lesson
    WHERE lesson.id = ANY(ARRAY['cd86a494-4f77-50a4-9514-c10703882434'::UUID, 'e7b82c88-0422-577f-a63d-5ec1db376c66'::UUID, '0f97f8ff-e0bd-53e1-a965-34ce17d6a0e1'::UUID, 'dbabad25-e3a0-57d6-b962-8f5521aca9aa'::UUID, 'bb6a8afe-b064-5cd0-adc2-6eea3f59e311'::UUID]::UUID[])
      AND NOT EXISTS (
        SELECT 1 FROM public.exercises AS exercise
        WHERE exercise.lesson_id = lesson.id
      )
  ) THEN
    RAISE EXCEPTION 'Content batch batch-09-travel contains a lesson without exercises';
  END IF;
  IF EXISTS (
    SELECT 1
    FROM public.lessons AS lesson
    JOIN public.exercises AS exercise ON exercise.lesson_id = lesson.id
    WHERE lesson.id = ANY(ARRAY['cd86a494-4f77-50a4-9514-c10703882434'::UUID, 'e7b82c88-0422-577f-a63d-5ec1db376c66'::UUID, '0f97f8ff-e0bd-53e1-a965-34ce17d6a0e1'::UUID, 'dbabad25-e3a0-57d6-b962-8f5521aca9aa'::UUID, 'bb6a8afe-b064-5cd0-adc2-6eea3f59e311'::UUID]::UUID[])
      AND lesson.status = 'published'
      AND exercise.exercise_type = 'listening'
      AND NULLIF(BTRIM(exercise.question_audio_url), '') IS NULL
  ) THEN
    RAISE EXCEPTION 'Published listening exercise is missing playable audio';
  END IF;
  IF EXISTS (
    SELECT 1
    FROM public.exercises AS exercise
    WHERE exercise.id = ANY(ARRAY['426a9cee-630e-5b6a-818e-9076b1be20aa'::UUID, '2c1ede9f-3911-52af-9451-df81eedc0aea'::UUID, 'c67c671a-ed78-55d4-95ee-6eb7218b34bd'::UUID, '9ba1718e-288b-5fcf-acbd-08ff8aed83a7'::UUID, '680df5ec-45d4-56fb-a666-13b6fb1755b5'::UUID, '21518d43-0711-5f51-8627-a2a7845fdfb7'::UUID, '58981e46-3778-539e-9ec4-d230ea34009d'::UUID, '4111b144-447c-5b6d-b387-9adc6bf461bd'::UUID, '5f292e25-c261-5ec3-b2c7-9282dd1c7187'::UUID, 'f309ae75-c227-5e59-8453-9201a0fb1f1d'::UUID, '098bc2c9-7f9c-5a19-a0d6-4b3c96b19196'::UUID, '820a1b87-624f-5491-97d8-3aeea306042d'::UUID, '7b958598-59ba-5ce0-994a-9c1522ed55b2'::UUID, 'aac02a08-e06a-59c2-9f55-099b92c65515'::UUID, '466c3006-80bd-58e1-8eb8-a5ffd2ccf4e0'::UUID, '1f81881c-b53e-59a1-ab89-4e19fddbdb93'::UUID, 'b28851cb-0a83-5b1a-958b-4ea48e8b4bbd'::UUID, '7e71d26a-4cf7-5361-965f-06434b6eb7d6'::UUID, '4055524a-6aa7-50b8-914e-73ccbc1e655a'::UUID, '03ee479e-02cf-5029-99b5-6b65b3b0aeb8'::UUID, '82530065-6301-5a9d-906e-5b9d8b21425d'::UUID, '67d70b3d-2093-52bf-b42d-f5a1a6b66852'::UUID, 'de3c6299-b249-566c-a563-aeb093fcccec'::UUID, '65ed661b-9035-5784-9647-320689230d55'::UUID, '21eef112-67e5-5285-93d6-18118f72071d'::UUID, '50bc3945-811a-587a-8c4d-b52ecc435c6f'::UUID, 'c880443d-818b-5cdf-9af2-a47796841f7f'::UUID, 'a19ee071-2412-537c-ab4a-ee9ecb1629d0'::UUID, 'defd60f6-58c2-5f79-abac-8db6ad3022d1'::UUID, '4f69c296-4057-511f-b722-5f5cf1d7b553'::UUID, '073b9221-4417-56fb-911a-8d07eed7e6fc'::UUID, '4d5890e7-898d-5812-8e45-b4bb55f099af'::UUID, 'e33abd5e-e954-51ad-abd0-92d2ce3ee719'::UUID, '8e1676de-3276-5368-a5c0-d5ba03179c4f'::UUID, '8b94ab81-e4b1-5184-96f8-c9220ba70307'::UUID, 'f5757dfa-ae4d-5a44-bac7-e2b460feaa05'::UUID, 'fa809237-1171-53fb-9179-c1d9f3f1b251'::UUID]::UUID[])
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
    WHERE link.lesson_id = ANY(ARRAY['cd86a494-4f77-50a4-9514-c10703882434'::UUID, 'e7b82c88-0422-577f-a63d-5ec1db376c66'::UUID, '0f97f8ff-e0bd-53e1-a965-34ce17d6a0e1'::UUID, 'dbabad25-e3a0-57d6-b962-8f5521aca9aa'::UUID, 'bb6a8afe-b064-5cd0-adc2-6eea3f59e311'::UUID]::UUID[])
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
