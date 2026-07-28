-- Generated from content/manifests/07_hsk6.json.
-- Do not hand-edit this migration; edit the manifest and regenerate.
-- Additive and idempotent: deterministic IDs plus ON CONFLICT DO NOTHING.

BEGIN;

INSERT INTO public.courses (id, slug, title, title_zh, description, level, status, order_index, learning_objectives, estimated_minutes, content_version)
VALUES ('4d34bda1-b911-5aa0-8ba3-d504fdc38ca0'::UUID, 'hsk-6', 'HSK 6', 'HSK 六级', 'Diễn đạt học thuật, hàm ý và lập luận ở mức nâng cao.', 'advanced', 'review', 7, '["Đọc hiểu lập luận trừu tượng","Dùng kết cấu văn viết nâng cao","Diễn đạt hàm ý chính xác"]'::JSONB, 78, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.units (id, course_id, slug, title, description, order_index, status, learning_objectives, content_version)
VALUES ('d3f65d26-3076-5a3e-ac86-75670f1a9000'::UUID, '4d34bda1-b911-5aa0-8ba3-d504fdc38ca0'::UUID, 'hsk6-nen-tang', 'Nền tảng', 'Xây dựng ngôn ngữ cốt lõi của lộ trình.', 1, 'review', '["Đọc hiểu lập luận trừu tượng","Dùng kết cấu văn viết nâng cao"]'::JSONB, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.chapters (id, unit_id, slug, title, description, order_index, status, learning_objectives, content_version)
VALUES ('54d768ce-6f8d-56c2-a1e7-329043905273'::UUID, 'd3f65d26-3076-5a3e-ac86-75670f1a9000'::UUID, 'hsk6-nen-tang-chapter', 'Khái niệm cốt lõi', 'Xây dựng ngôn ngữ cốt lõi của lộ trình.', 1, 'review', '["Đọc hiểu lập luận trừu tượng","Dùng kết cấu văn viết nâng cao"]'::JSONB, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lessons (id, chapter_id, slug, title, description, order_index, xp_reward, status, lesson_type, estimated_minutes, learning_objectives, cultural_note, content_version)
VALUES ('12d366be-904b-521e-9a8c-7dff513ba8d3'::UUID, '54d768ce-6f8d-56c2-a1e7-329043905273'::UUID, 'ham-y', '言外之意 — Hàm ý', 'Nhận biết ý ngoài lời và sắc thái.', 1, 25, 'review', 'standard', 15, '["Suy luận hàm ý trong ngữ cảnh"]'::JSONB, '无非 thường có sắc thái đánh giá và không hoàn toàn trung tính.', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('492a8633-7b36-56da-b18e-9ce93ea197f3'::UUID, 'hsk6:暗示', '暗示', 'ànshì', 'ám chỉ', 'imply', 'advanced', 'ham-y', 'động từ/danh từ', '他的回答暗示计划可能改变。', 'Tā de huídá ànshì jìhuà kěnéng gǎibiàn.', 'Câu trả lời của anh ấy ám chỉ kế hoạch có thể thay đổi.', NULL, 'review', '12d366be-904b-521e-9a8c-7dff513ba8d3'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('451981f7-5e8c-5729-9b91-b3f99a417fb0'::UUID, '12d366be-904b-521e-9a8c-7dff513ba8d3'::UUID, '492a8633-7b36-56da-b18e-9ce93ea197f3'::UUID, 1, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('6716eb08-d9f2-5869-b574-40e9155b08f7'::UUID, 'hsk6:含义', '含义', 'hányì', 'hàm nghĩa', 'implication; meaning', 'advanced', 'ham-y', 'danh từ', '这句话有很深的含义。', 'Zhè jù huà yǒu hěn shēn de hányì.', 'Câu này có hàm nghĩa rất sâu.', NULL, 'review', '12d366be-904b-521e-9a8c-7dff513ba8d3'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('61715320-c703-56bb-a648-0a78a4e2ee0b'::UUID, '12d366be-904b-521e-9a8c-7dff513ba8d3'::UUID, '6716eb08-d9f2-5869-b574-40e9155b08f7'::UUID, 2, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('a0d6013e-4ebb-58ff-a58e-f74aff702a69'::UUID, 'hsk6:揣摩', '揣摩', 'chuǎimó', 'suy ngẫm, đoán ý', 'ponder; infer', 'advanced', 'ham-y', 'động từ', '读者需要揣摩作者的语气。', 'Dúzhě xūyào chuǎimó zuòzhě de yǔqì.', 'Người đọc cần suy ngẫm giọng điệu của tác giả.', NULL, 'review', '12d366be-904b-521e-9a8c-7dff513ba8d3'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('bc6db571-e437-5b1a-b430-7bd440c49bf2'::UUID, '12d366be-904b-521e-9a8c-7dff513ba8d3'::UUID, 'a0d6013e-4ebb-58ff-a58e-f74aff702a69'::UUID, 3, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.grammar_lessons (id, content_key, title, pattern, explanation, example_chinese, example_pinyin, example_meaning, level, status, usage_note, content_version)
VALUES ('92911f09-5c17-5cd6-92cc-1a4b084f6db5'::UUID, 'hsk6:ham-y', 'Hàm ý với 无非', '无非是 + phạm vi được quy về', '无非 thu hẹp một hiện tượng vào nguyên nhân hoặc bản chất mà người nói cho là rõ.', '他的言外之意无非是希望我们让步。', 'Tā de yánwàizhīyì wúfēi shì xīwàng wǒmen ràngbù.', 'Hàm ý của anh ấy chẳng qua là mong chúng ta nhượng bộ.', 'advanced', 'review', NULL, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_grammar (id, lesson_id, grammar_lesson_id, order_index, curriculum_role)
VALUES ('eb1cd2bb-a59f-5b39-b0e4-9746227ce96c'::UUID, '12d366be-904b-521e-9a8c-7dff513ba8d3'::UUID, '92911f09-5c17-5cd6-92cc-1a4b084f6db5'::UUID, 1, 'introduced')
ON CONFLICT (lesson_id, grammar_lesson_id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('d3a400ac-8681-5ea1-bce4-91c56277f9c0'::UUID, '12d366be-904b-521e-9a8c-7dff513ba8d3'::UUID, 'vocabulary', 1, 'Từ mới: 暗示', NULL, '暗示', '暗示 (ànshì) — ám chỉ. 他的回答暗示计划可能改变。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"hsk6:暗示","chinese":"暗示","pinyin":"ànshì","meaning":"ám chỉ","part_of_speech":"động từ/danh từ","example_chinese":"他的回答暗示计划可能改变。","example_pinyin":"Tā de huídá ànshì jìhuà kěnéng gǎibiàn.","example_meaning_vi":"Câu trả lời của anh ấy ám chỉ kế hoạch có thể thay đổi."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('0a796789-1de3-58ee-af9c-54f1c933d06e'::UUID, '12d366be-904b-521e-9a8c-7dff513ba8d3'::UUID, 'vocabulary', 2, 'Từ mới: 含义', NULL, '含义', '含义 (hányì) — hàm nghĩa. 这句话有很深的含义。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"hsk6:含义","chinese":"含义","pinyin":"hányì","meaning":"hàm nghĩa","part_of_speech":"danh từ","example_chinese":"这句话有很深的含义。","example_pinyin":"Zhè jù huà yǒu hěn shēn de hányì.","example_meaning_vi":"Câu này có hàm nghĩa rất sâu."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('847dde17-91c2-57fa-a41f-d1650b32ad35'::UUID, '12d366be-904b-521e-9a8c-7dff513ba8d3'::UUID, 'vocabulary', 3, 'Từ mới: 揣摩', NULL, '揣摩', '揣摩 (chuǎimó) — suy ngẫm, đoán ý. 读者需要揣摩作者的语气。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"hsk6:揣摩","chinese":"揣摩","pinyin":"chuǎimó","meaning":"suy ngẫm, đoán ý","part_of_speech":"động từ","example_chinese":"读者需要揣摩作者的语气。","example_pinyin":"Dúzhě xūyào chuǎimó zuòzhě de yǔqì.","example_meaning_vi":"Người đọc cần suy ngẫm giọng điệu của tác giả."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('8eef9be3-b57f-51bb-b068-eaf6fcf3d8ac'::UUID, '12d366be-904b-521e-9a8c-7dff513ba8d3'::UUID, 'multiple_choice', 4, '“暗示” có nghĩa phù hợp nhất là gì?', NULL, 'ám chỉ', '暗示 (ànshì) nghĩa là “ám chỉ”.', NULL, 1, '{"activity_type":"chinese_to_vietnamese","vocabulary_key":"hsk6:暗示"}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('929bf141-ba9d-5243-9f2a-39644ce1ab3b'::UUID, '8eef9be3-b57f-51bb-b068-eaf6fcf3d8ac'::UUID, 'suy ngẫm, đoán ý', FALSE, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('9cd6b631-855c-5232-95f5-81ff71242be6'::UUID, '8eef9be3-b57f-51bb-b068-eaf6fcf3d8ac'::UUID, 'ám chỉ', TRUE, 2)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('a5c94402-9efc-59ba-8b29-81f31d2b01ab'::UUID, '8eef9be3-b57f-51bb-b068-eaf6fcf3d8ac'::UUID, 'hàm nghĩa', FALSE, 3)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('a3b3e619-78d7-55d3-9c02-0cc037f921df'::UUID, '12d366be-904b-521e-9a8c-7dff513ba8d3'::UUID, 'translation', 5, 'Dịch sang tiếng Trung: “Hàm ý của anh ấy chẳng qua là mong chúng ta nhượng bộ.”', NULL, '他的言外之意无非是希望我们让步。', 'Mẫu câu dùng “暗示” trong ngữ cảnh của bài.', 'ànshì', 1, '{"activity_type":"vietnamese_to_chinese","source_lang":"vi","target_lang":"zh","acceptable_answers":["他的言外之意无非是希望我们让步。"]}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('002be7d4-dce4-5593-88fa-cbc48bce410e'::UUID, '12d366be-904b-521e-9a8c-7dff513ba8d3'::UUID, 'sentence_builder', 6, 'Sắp xếp các thành phần thành câu đúng.', NULL, '他的言外之意无非是希望我们让步。', 'Trật tự đúng tạo thành câu “他的言外之意无非是希望我们让步。”.', NULL, 1, '{"activity_type":"sentence_ordering","words":["他","的","言外之意","无非","是","希望","我们","让步","。"],"correct_order":["他","的","言外之意","无非","是","希望","我们","让步","。"]}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('6f0f520e-1257-59fc-97d8-94784510cd18'::UUID, '12d366be-904b-521e-9a8c-7dff513ba8d3'::UUID, 'multiple_choice', 7, 'Câu nào diễn giải hàm ý?', NULL, '他的言外之意无非是希望我们让步。', '无非 thu hẹp một hiện tượng vào nguyên nhân hoặc bản chất mà người nói cho là rõ.', NULL, 1, '{"activity_type":"grammar_selection","passage":null,"grammar_key":"hsk6:ham-y"}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('6013656f-d7e0-5cbb-9688-a9bdf35ba71a'::UUID, '6f0f520e-1257-59fc-97d8-94784510cd18'::UUID, '他的言外之意无非是希望我们让步。', TRUE, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('f829ddf8-bec3-5254-ac5e-00b521a2d96b'::UUID, '6f0f520e-1257-59fc-97d8-94784510cd18'::UUID, '。让步我们希望是无非言外之意的他', FALSE, 2)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('543df219-37f6-5694-80bb-c8380381522a'::UUID, '6f0f520e-1257-59fc-97d8-94784510cd18'::UUID, '的言外之意无非是希望我们让步。他', FALSE, 3)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('7df69095-4691-5233-953b-4c8e4f36aa1e'::UUID, '12d366be-904b-521e-9a8c-7dff513ba8d3'::UUID, 'speaking', 8, 'Đọc thành tiếng: 他的言外之意无非是希望我们让步。', NULL, '他的言外之意无非是希望我们让步。', 'Đọc chậm, giữ đúng thanh điệu và nhịp của cả câu.', NULL, 1, '{"activity_type":"pronunciation","text":"他的言外之意无非是希望我们让步。","pinyin":"Tā de yánwàizhīyì wúfēi shì xīwàng wǒmen ràngbù."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lessons (id, chapter_id, slug, title, description, order_index, xp_reward, status, lesson_type, estimated_minutes, learning_objectives, cultural_note, content_version)
VALUES ('8bd5a896-12df-5cda-8833-4ba103dc0142'::UUID, '54d768ce-6f8d-56c2-a1e7-329043905273'::UUID, 'lap-luan-phuc', '固然…然而… — Thừa nhận rồi phản biện', 'Thừa nhận một mặt trước khi nêu trọng tâm đối lập.', 2, 25, 'review', 'standard', 15, '["Xây dựng phản biện cân bằng"]'::JSONB, 'Vế sau thường mang trọng tâm lập luận.', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('d2375c64-0b10-5a4a-b611-8dca62d700c9'::UUID, 'hsk6:固然', '固然', 'gùrán', 'dĩ nhiên, đúng là', 'admittedly', 'advanced', 'lap-luan-phuc', 'liên từ', '经验固然重要，方法也不能忽视。', 'Jīngyàn gùrán zhòngyào, fāngfǎ yě bù néng hūshì.', 'Kinh nghiệm dĩ nhiên quan trọng, phương pháp cũng không thể xem nhẹ.', NULL, 'review', '8bd5a896-12df-5cda-8833-4ba103dc0142'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('f351c59e-7a1d-54c1-9b44-9d69d7d94a5c'::UUID, '8bd5a896-12df-5cda-8833-4ba103dc0142'::UUID, 'd2375c64-0b10-5a4a-b611-8dca62d700c9'::UUID, 1, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('6e447dee-f07c-599c-9620-43986361c986'::UUID, 'hsk6:然而', '然而', 'rán ér', 'tuy nhiên', 'however', 'advanced', 'lap-luan-phuc', 'liên từ', '条件有限，然而团队没有退缩。', 'Tiáojiàn yǒuxiàn, rán ér tuánduì méiyǒu tuìsuō.', 'Điều kiện hạn chế, tuy nhiên nhóm không lùi bước.', NULL, 'review', '8bd5a896-12df-5cda-8833-4ba103dc0142'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('f93f805f-5379-59fe-a41a-af1760396a77'::UUID, '8bd5a896-12df-5cda-8833-4ba103dc0142'::UUID, '6e447dee-f07c-599c-9620-43986361c986'::UUID, 2, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('24f1bd55-f464-5660-94f5-b7fc0f72b196'::UUID, 'hsk6:权衡', '权衡', 'quánhéng', 'cân nhắc', 'weigh; balance', 'advanced', 'lap-luan-phuc', 'động từ', '决策前要权衡利弊。', 'Juécè qián yào quánhéng lìbì.', 'Trước khi quyết định cần cân nhắc lợi hại.', NULL, 'review', '8bd5a896-12df-5cda-8833-4ba103dc0142'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('a9c3b292-2e28-594e-9ea4-d7df986a8645'::UUID, '8bd5a896-12df-5cda-8833-4ba103dc0142'::UUID, '24f1bd55-f464-5660-94f5-b7fc0f72b196'::UUID, 3, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('cb8e7fa2-f993-5027-97ee-06426af8e578'::UUID, '8bd5a896-12df-5cda-8833-4ba103dc0142'::UUID, '492a8633-7b36-56da-b18e-9ce93ea197f3'::UUID, 4, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('fb1b1d96-3b8e-5f43-81d5-9ea26d5135ae'::UUID, '8bd5a896-12df-5cda-8833-4ba103dc0142'::UUID, '6716eb08-d9f2-5869-b574-40e9155b08f7'::UUID, 5, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('69711dfb-37b8-5bd9-b3a4-550a4ac5242a'::UUID, '8bd5a896-12df-5cda-8833-4ba103dc0142'::UUID, 'a0d6013e-4ebb-58ff-a58e-f74aff702a69'::UUID, 6, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.grammar_lessons (id, content_key, title, pattern, explanation, example_chinese, example_pinyin, example_meaning, level, status, usage_note, content_version)
VALUES ('6d952775-2ef4-57df-bdab-52c8b5b22190'::UUID, 'hsk6:lap-luan-phuc', 'Thừa nhận–chuyển hướng', 'A 固然…，然而 B…', '固然 thừa nhận A, còn 然而 đưa ra ý B mà người viết muốn nhấn mạnh.', '效率固然重要，然而公平也不容忽视。', 'Xiàolǜ gùrán zhòngyào, rán ér gōngpíng yě bùróng hūshì.', 'Hiệu quả dĩ nhiên quan trọng, nhưng công bằng cũng không thể xem nhẹ.', 'advanced', 'review', NULL, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_grammar (id, lesson_id, grammar_lesson_id, order_index, curriculum_role)
VALUES ('a2a46e24-6201-5717-adc3-da28faf8feaa'::UUID, '8bd5a896-12df-5cda-8833-4ba103dc0142'::UUID, '6d952775-2ef4-57df-bdab-52c8b5b22190'::UUID, 1, 'introduced')
ON CONFLICT (lesson_id, grammar_lesson_id) DO NOTHING;

INSERT INTO public.lesson_grammar (id, lesson_id, grammar_lesson_id, order_index, curriculum_role)
VALUES ('e415a23d-7bd9-54d5-9361-d46da5d60b34'::UUID, '8bd5a896-12df-5cda-8833-4ba103dc0142'::UUID, '92911f09-5c17-5cd6-92cc-1a4b084f6db5'::UUID, 2, 'review')
ON CONFLICT (lesson_id, grammar_lesson_id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('6aa55ed6-2c12-5bd7-bf32-b400fce6c463'::UUID, '8bd5a896-12df-5cda-8833-4ba103dc0142'::UUID, 'vocabulary', 1, 'Từ mới: 固然', NULL, '固然', '固然 (gùrán) — dĩ nhiên, đúng là. 经验固然重要，方法也不能忽视。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"hsk6:固然","chinese":"固然","pinyin":"gùrán","meaning":"dĩ nhiên, đúng là","part_of_speech":"liên từ","example_chinese":"经验固然重要，方法也不能忽视。","example_pinyin":"Jīngyàn gùrán zhòngyào, fāngfǎ yě bù néng hūshì.","example_meaning_vi":"Kinh nghiệm dĩ nhiên quan trọng, phương pháp cũng không thể xem nhẹ."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('c06e0f2e-1b97-5bc5-a205-806f24ee9cc6'::UUID, '8bd5a896-12df-5cda-8833-4ba103dc0142'::UUID, 'vocabulary', 2, 'Từ mới: 然而', NULL, '然而', '然而 (rán ér) — tuy nhiên. 条件有限，然而团队没有退缩。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"hsk6:然而","chinese":"然而","pinyin":"rán ér","meaning":"tuy nhiên","part_of_speech":"liên từ","example_chinese":"条件有限，然而团队没有退缩。","example_pinyin":"Tiáojiàn yǒuxiàn, rán ér tuánduì méiyǒu tuìsuō.","example_meaning_vi":"Điều kiện hạn chế, tuy nhiên nhóm không lùi bước."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('1bec6ae4-b86e-5e9c-8405-f965361103a1'::UUID, '8bd5a896-12df-5cda-8833-4ba103dc0142'::UUID, 'vocabulary', 3, 'Từ mới: 权衡', NULL, '权衡', '权衡 (quánhéng) — cân nhắc. 决策前要权衡利弊。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"hsk6:权衡","chinese":"权衡","pinyin":"quánhéng","meaning":"cân nhắc","part_of_speech":"động từ","example_chinese":"决策前要权衡利弊。","example_pinyin":"Juécè qián yào quánhéng lìbì.","example_meaning_vi":"Trước khi quyết định cần cân nhắc lợi hại."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('090758da-ef35-5169-9774-c008cffa10ab'::UUID, '8bd5a896-12df-5cda-8833-4ba103dc0142'::UUID, 'multiple_choice', 4, '“固然” có nghĩa phù hợp nhất là gì?', NULL, 'dĩ nhiên, đúng là', '固然 (gùrán) nghĩa là “dĩ nhiên, đúng là”.', NULL, 1, '{"activity_type":"chinese_to_vietnamese","vocabulary_key":"hsk6:固然"}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('8baa3f2d-fdb1-5c75-afe3-e71e5571a067'::UUID, '090758da-ef35-5169-9774-c008cffa10ab'::UUID, 'dĩ nhiên, đúng là', TRUE, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('7323e59f-a60d-5781-afcf-baea1584936c'::UUID, '090758da-ef35-5169-9774-c008cffa10ab'::UUID, 'tuy nhiên', FALSE, 2)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('317f5bd5-70c2-51eb-8084-cd516b76eac0'::UUID, '090758da-ef35-5169-9774-c008cffa10ab'::UUID, 'cân nhắc', FALSE, 3)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('d5ca1f70-8942-5892-84ef-202a8bd24258'::UUID, '8bd5a896-12df-5cda-8833-4ba103dc0142'::UUID, 'translation', 5, 'Dịch sang tiếng Trung: “Hiệu quả dĩ nhiên quan trọng, nhưng công bằng cũng không thể xem nhẹ.”', NULL, '效率固然重要，然而公平也不容忽视。', 'Mẫu câu dùng “固然” trong ngữ cảnh của bài.', 'gùrán', 1, '{"activity_type":"vietnamese_to_chinese","source_lang":"vi","target_lang":"zh","acceptable_answers":["效率固然重要，然而公平也不容忽视。"]}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('1cdf4b86-038f-527e-8bdf-b183940deefd'::UUID, '8bd5a896-12df-5cda-8833-4ba103dc0142'::UUID, 'sentence_builder', 6, 'Sắp xếp các thành phần thành câu đúng.', NULL, '效率固然重要，然而公平也不容忽视。', 'Trật tự đúng tạo thành câu “效率固然重要，然而公平也不容忽视。”.', NULL, 1, '{"activity_type":"sentence_ordering","words":["效率","固然","重要","，","然而","公平","也","不容","忽视","。"],"correct_order":["效率","固然","重要","，","然而","公平","也","不容","忽视","。"]}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('bc7b1920-698f-5e75-9fb0-000efcdbb456'::UUID, '8bd5a896-12df-5cda-8833-4ba103dc0142'::UUID, 'multiple_choice', 7, 'Câu nào có lập luận thừa nhận rồi chuyển hướng?', NULL, '效率固然重要，然而公平也不容忽视。', '固然 thừa nhận A, còn 然而 đưa ra ý B mà người viết muốn nhấn mạnh.', NULL, 1, '{"activity_type":"grammar_selection","passage":null,"grammar_key":"hsk6:lap-luan-phuc"}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('9c2f2df8-0447-5a5b-998a-99328ecca634'::UUID, 'bc7b1920-698f-5e75-9fb0-000efcdbb456'::UUID, '效率固然重要，然而公平也不容忽视。', TRUE, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('f256dc48-8b74-5933-974d-cd2cf363b091'::UUID, 'bc7b1920-698f-5e75-9fb0-000efcdbb456'::UUID, '。忽视不容也公平然而，重要固然效率', FALSE, 2)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('ac04bbc9-b77b-53c6-b229-bb768044dd74'::UUID, 'bc7b1920-698f-5e75-9fb0-000efcdbb456'::UUID, '固然重要，然而公平也不容忽视。效率', FALSE, 3)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('fdb987a9-72d7-5af8-82ea-014f4c9f1a53'::UUID, '8bd5a896-12df-5cda-8833-4ba103dc0142'::UUID, 'speaking', 8, 'Đọc thành tiếng: 效率固然重要，然而公平也不容忽视。', NULL, '效率固然重要，然而公平也不容忽视。', 'Đọc chậm, giữ đúng thanh điệu và nhịp của cả câu.', NULL, 1, '{"activity_type":"pronunciation","text":"效率固然重要，然而公平也不容忽视。","pinyin":"Xiàolǜ gùrán zhòngyào, rán ér gōngpíng yě bùróng hūshì."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.units (id, course_id, slug, title, description, order_index, status, learning_objectives, content_version)
VALUES ('237d7ee6-46dd-5ff5-b346-3f88e3cddd37'::UUID, '4d34bda1-b911-5aa0-8ba3-d504fdc38ca0'::UUID, 'hsk6-van-dung', 'Vận dụng', 'Vận dụng mẫu câu trong ngữ cảnh có ý nghĩa.', 2, 'review', '["Dùng kết cấu văn viết nâng cao","Diễn đạt hàm ý chính xác"]'::JSONB, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.chapters (id, unit_id, slug, title, description, order_index, status, learning_objectives, content_version)
VALUES ('60dd593f-25dc-556a-8d0d-97d1542b3a61'::UUID, '237d7ee6-46dd-5ff5-b346-3f88e3cddd37'::UUID, 'hsk6-van-dung-chapter', 'Ngữ cảnh thực tế', 'Vận dụng mẫu câu trong ngữ cảnh có ý nghĩa.', 1, 'review', '["Dùng kết cấu văn viết nâng cao","Diễn đạt hàm ý chính xác"]'::JSONB, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lessons (id, chapter_id, slug, title, description, order_index, xp_reward, status, lesson_type, estimated_minutes, learning_objectives, cultural_note, content_version)
VALUES ('635163b4-3110-5f68-a937-ce9f93ccfbb3'::UUID, '60dd593f-25dc-556a-8d0d-97d1542b3a61'::UUID, 'hoc-thuat', '就…而言 — Giới hạn phạm vi', 'Khoanh vùng bình diện đánh giá.', 1, 25, 'review', 'standard', 15, '["Trình bày nhận định học thuật chính xác"]'::JSONB, 'Có thể thay 就 bằng 对…来说 trong văn phong ít trang trọng hơn.', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('d1a7d371-bb6b-5f6a-808d-bf7ef53a287c'::UUID, 'hsk6:范畴', '范畴', 'fànchóu', 'phạm trù', 'category; domain', 'advanced', 'hoc-thuat', 'danh từ', '这个问题属于社会学范畴。', 'Zhège wèntí shǔyú shèhuìxué fànchóu.', 'Vấn đề này thuộc phạm trù xã hội học.', NULL, 'review', '635163b4-3110-5f68-a937-ce9f93ccfbb3'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('b58fd6be-1e59-5d4c-928a-4972401dfec7'::UUID, '635163b4-3110-5f68-a937-ce9f93ccfbb3'::UUID, 'd1a7d371-bb6b-5f6a-808d-bf7ef53a287c'::UUID, 1, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('0262e2dc-756e-5f3f-87c8-a7ef303c91d1'::UUID, 'hsk6:前提', '前提', 'qiántí', 'tiền đề', 'premise', 'advanced', 'hoc-thuat', 'danh từ', '结论成立需要一个前提。', 'Jiélùn chénglì xūyào yí ge qiántí.', 'Để kết luận đứng vững cần một tiền đề.', NULL, 'review', '635163b4-3110-5f68-a937-ce9f93ccfbb3'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('cb85e7a2-7b19-5650-81e7-030441c4f451'::UUID, '635163b4-3110-5f68-a937-ce9f93ccfbb3'::UUID, '0262e2dc-756e-5f3f-87c8-a7ef303c91d1'::UUID, 2, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('1116d856-193e-567c-be32-d736348b9b92'::UUID, 'hsk6:阐述', '阐述', 'chǎnshù', 'trình bày, luận giải', 'expound', 'advanced', 'hoc-thuat', 'động từ', '作者详细阐述了核心观点。', 'Zuòzhě xiángxì chǎnshù le héxīn guāndiǎn.', 'Tác giả trình bày chi tiết quan điểm cốt lõi.', NULL, 'review', '635163b4-3110-5f68-a937-ce9f93ccfbb3'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('18301a43-689f-5999-b090-942fc0ee62b2'::UUID, '635163b4-3110-5f68-a937-ce9f93ccfbb3'::UUID, '1116d856-193e-567c-be32-d736348b9b92'::UUID, 3, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('49463007-68ed-58bf-860b-009d3373c356'::UUID, '635163b4-3110-5f68-a937-ce9f93ccfbb3'::UUID, 'd2375c64-0b10-5a4a-b611-8dca62d700c9'::UUID, 4, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('27c2ba91-d5c2-509b-8cb1-cec33a84a13b'::UUID, '635163b4-3110-5f68-a937-ce9f93ccfbb3'::UUID, '6e447dee-f07c-599c-9620-43986361c986'::UUID, 5, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('7eb090ba-3e64-5aeb-9156-d24aff7410cc'::UUID, '635163b4-3110-5f68-a937-ce9f93ccfbb3'::UUID, '24f1bd55-f464-5660-94f5-b7fc0f72b196'::UUID, 6, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.grammar_lessons (id, content_key, title, pattern, explanation, example_chinese, example_pinyin, example_meaning, level, status, usage_note, content_version)
VALUES ('d4c91dca-4a6e-5cd0-864c-a05369265d00'::UUID, 'hsk6:hoc-thuat', 'Giới hạn bình diện', '就 + phạm vi + 而言', 'Kết cấu văn viết xác định phương diện mà nhận định có hiệu lực.', '就研究方法而言，这个设计仍有改进空间。', 'Jiù yánjiū fāngfǎ ér yán, zhège shèjì réng yǒu gǎijìn kōngjiān.', 'Xét về phương pháp nghiên cứu, thiết kế này vẫn còn chỗ cải thiện.', 'advanced', 'review', NULL, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_grammar (id, lesson_id, grammar_lesson_id, order_index, curriculum_role)
VALUES ('6f85e154-350c-5e23-aaab-8bbb17efce22'::UUID, '635163b4-3110-5f68-a937-ce9f93ccfbb3'::UUID, 'd4c91dca-4a6e-5cd0-864c-a05369265d00'::UUID, 1, 'introduced')
ON CONFLICT (lesson_id, grammar_lesson_id) DO NOTHING;

INSERT INTO public.lesson_grammar (id, lesson_id, grammar_lesson_id, order_index, curriculum_role)
VALUES ('792b236b-c982-5c9e-b165-58832bd46c96'::UUID, '635163b4-3110-5f68-a937-ce9f93ccfbb3'::UUID, '6d952775-2ef4-57df-bdab-52c8b5b22190'::UUID, 2, 'review')
ON CONFLICT (lesson_id, grammar_lesson_id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('953cba48-5a0d-5ec9-a4df-697dff432af8'::UUID, '635163b4-3110-5f68-a937-ce9f93ccfbb3'::UUID, 'vocabulary', 1, 'Từ mới: 范畴', NULL, '范畴', '范畴 (fànchóu) — phạm trù. 这个问题属于社会学范畴。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"hsk6:范畴","chinese":"范畴","pinyin":"fànchóu","meaning":"phạm trù","part_of_speech":"danh từ","example_chinese":"这个问题属于社会学范畴。","example_pinyin":"Zhège wèntí shǔyú shèhuìxué fànchóu.","example_meaning_vi":"Vấn đề này thuộc phạm trù xã hội học."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('f9a0c7b2-805c-5d05-ba36-7e58dd5288cd'::UUID, '635163b4-3110-5f68-a937-ce9f93ccfbb3'::UUID, 'vocabulary', 2, 'Từ mới: 前提', NULL, '前提', '前提 (qiántí) — tiền đề. 结论成立需要一个前提。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"hsk6:前提","chinese":"前提","pinyin":"qiántí","meaning":"tiền đề","part_of_speech":"danh từ","example_chinese":"结论成立需要一个前提。","example_pinyin":"Jiélùn chénglì xūyào yí ge qiántí.","example_meaning_vi":"Để kết luận đứng vững cần một tiền đề."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('2dd60aad-a6de-5fb6-bd92-062f13eadf00'::UUID, '635163b4-3110-5f68-a937-ce9f93ccfbb3'::UUID, 'vocabulary', 3, 'Từ mới: 阐述', NULL, '阐述', '阐述 (chǎnshù) — trình bày, luận giải. 作者详细阐述了核心观点。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"hsk6:阐述","chinese":"阐述","pinyin":"chǎnshù","meaning":"trình bày, luận giải","part_of_speech":"động từ","example_chinese":"作者详细阐述了核心观点。","example_pinyin":"Zuòzhě xiángxì chǎnshù le héxīn guāndiǎn.","example_meaning_vi":"Tác giả trình bày chi tiết quan điểm cốt lõi."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('468320ee-b27a-56f0-bc55-16999b8c1c52'::UUID, '635163b4-3110-5f68-a937-ce9f93ccfbb3'::UUID, 'multiple_choice', 4, '“范畴” có nghĩa phù hợp nhất là gì?', NULL, 'phạm trù', '范畴 (fànchóu) nghĩa là “phạm trù”.', NULL, 1, '{"activity_type":"chinese_to_vietnamese","vocabulary_key":"hsk6:范畴"}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('53ee3bb6-9d80-5731-a601-851fe04e1ce8'::UUID, '468320ee-b27a-56f0-bc55-16999b8c1c52'::UUID, 'phạm trù', TRUE, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('38957f0d-7ae4-5e7a-92c3-6f718aea9647'::UUID, '468320ee-b27a-56f0-bc55-16999b8c1c52'::UUID, 'tiền đề', FALSE, 2)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('39c4c8f8-7352-5900-bb41-47b2d8b95206'::UUID, '468320ee-b27a-56f0-bc55-16999b8c1c52'::UUID, 'trình bày, luận giải', FALSE, 3)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('27770c2d-7ed8-5ac2-9029-73a91d28529d'::UUID, '635163b4-3110-5f68-a937-ce9f93ccfbb3'::UUID, 'translation', 5, 'Dịch sang tiếng Trung: “Xét về phương pháp nghiên cứu, thiết kế này vẫn còn chỗ cải thiện.”', NULL, '就研究方法而言，这个设计仍有改进空间。', 'Mẫu câu dùng “范畴” trong ngữ cảnh của bài.', 'fànchóu', 1, '{"activity_type":"vietnamese_to_chinese","source_lang":"vi","target_lang":"zh","acceptable_answers":["就研究方法而言，这个设计仍有改进空间。"]}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('e3d9d3ab-ab3c-5e78-a679-5eec7103a297'::UUID, '635163b4-3110-5f68-a937-ce9f93ccfbb3'::UUID, 'sentence_builder', 6, 'Sắp xếp các thành phần thành câu đúng.', NULL, '就研究方法而言，这个设计仍有改进空间。', 'Trật tự đúng tạo thành câu “就研究方法而言，这个设计仍有改进空间。”.', NULL, 1, '{"activity_type":"sentence_ordering","words":["就","研究","方法","而言","，","这个","设计","仍","有","改进","空间","。"],"correct_order":["就","研究","方法","而言","，","这个","设计","仍","有","改进","空间","。"]}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('e2f0d14f-1189-5961-b2d4-13d98be5fb13'::UUID, '635163b4-3110-5f68-a937-ce9f93ccfbb3'::UUID, 'multiple_choice', 7, 'Câu nào giới hạn rõ phạm vi đánh giá?', NULL, '就研究方法而言，这个设计仍有改进空间。', 'Kết cấu văn viết xác định phương diện mà nhận định có hiệu lực.', NULL, 1, '{"activity_type":"grammar_selection","passage":null,"grammar_key":"hsk6:hoc-thuat"}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('11d8fe16-5a06-5e64-b6fa-bff0b5a2562c'::UUID, 'e2f0d14f-1189-5961-b2d4-13d98be5fb13'::UUID, '就研究方法而言，这个设计仍有改进空间。', TRUE, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('209df938-dbc7-509f-a0e1-d4dc521dcb25'::UUID, 'e2f0d14f-1189-5961-b2d4-13d98be5fb13'::UUID, '。空间改进有仍设计这个，而言方法研究就', FALSE, 2)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('68c75f54-8f51-51f5-acb0-c7eafd43b556'::UUID, 'e2f0d14f-1189-5961-b2d4-13d98be5fb13'::UUID, '研究方法而言，这个设计仍有改进空间。就', FALSE, 3)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('6f909e7f-9793-57df-8a1d-d439b8c1f466'::UUID, '635163b4-3110-5f68-a937-ce9f93ccfbb3'::UUID, 'speaking', 8, 'Đọc thành tiếng: 就研究方法而言，这个设计仍有改进空间。', NULL, '就研究方法而言，这个设计仍有改进空间。', 'Đọc chậm, giữ đúng thanh điệu và nhịp của cả câu.', NULL, 1, '{"activity_type":"pronunciation","text":"就研究方法而言，这个设计仍有改进空间。","pinyin":"Jiù yánjiū fāngfǎ ér yán, zhège shèjì réng yǒu gǎijìn kōngjiān."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lessons (id, chapter_id, slug, title, description, order_index, xp_reward, status, lesson_type, estimated_minutes, learning_objectives, cultural_note, content_version)
VALUES ('a3af845c-ac0d-54b9-99fd-a0c9131d7ab4'::UUID, '60dd593f-25dc-556a-8d0d-97d1542b3a61'::UUID, 'thanh-ngu', '实事求是 — Thành ngữ trong văn cảnh', 'Dùng thành ngữ theo đúng sắc thái.', 2, 25, 'review', 'standard', 15, '["Hiểu và vận dụng thành ngữ phổ biến"]'::JSONB, 'Không ghép thành ngữ chỉ vì cùng nghĩa gần; cần kiểm tra chức năng cú pháp.', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('b7410e4b-f29c-51b8-955f-e541bcd4ba04'::UUID, 'hsk6:实事求是', '实事求是', 'shíshì qiúshì', 'tôn trọng sự thật', 'seek truth from facts', 'advanced', 'thanh-ngu', 'thành ngữ', '分析问题应该实事求是。', 'Fēnxī wèntí yīnggāi shíshì qiúshì.', 'Phân tích vấn đề nên tôn trọng sự thật.', NULL, 'review', 'a3af845c-ac0d-54b9-99fd-a0c9131d7ab4'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('4c830aae-2acc-59f1-aa18-19f4c2cde53c'::UUID, 'a3af845c-ac0d-54b9-99fd-a0c9131d7ab4'::UUID, 'b7410e4b-f29c-51b8-955f-e541bcd4ba04'::UUID, 1, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('89296b7d-9d4e-5c17-96ef-642e124377d4'::UUID, 'hsk6:因地制宜', '因地制宜', 'yīndì zhìyí', 'tùy nơi mà áp dụng phù hợp', 'adapt to local conditions', 'advanced', 'thanh-ngu', 'thành ngữ', '各地应该因地制宜发展产业。', 'Gèdì yīnggāi yīndì zhìyí fāzhǎn chǎnyè.', 'Các nơi nên phát triển ngành nghề phù hợp điều kiện địa phương.', NULL, 'review', 'a3af845c-ac0d-54b9-99fd-a0c9131d7ab4'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('46469987-f704-57a1-a27d-f5f78a988714'::UUID, 'a3af845c-ac0d-54b9-99fd-a0c9131d7ab4'::UUID, '89296b7d-9d4e-5c17-96ef-642e124377d4'::UUID, 2, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('e276b8d0-262a-50a9-887c-57b81c247e0c'::UUID, 'hsk6:循序渐进', '循序渐进', 'xúnxù jiànjìn', 'tiến dần theo trình tự', 'advance step by step', 'advanced', 'thanh-ngu', 'thành ngữ', '学习语言需要循序渐进。', 'Xuéxí yǔyán xūyào xúnxù jiànjìn.', 'Học ngôn ngữ cần tiến dần từng bước.', NULL, 'review', 'a3af845c-ac0d-54b9-99fd-a0c9131d7ab4'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('ba84693f-5873-505e-8533-e07ece3f3329'::UUID, 'a3af845c-ac0d-54b9-99fd-a0c9131d7ab4'::UUID, 'e276b8d0-262a-50a9-887c-57b81c247e0c'::UUID, 3, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('73afbe46-a9c5-5302-825a-1ddb350c786b'::UUID, 'a3af845c-ac0d-54b9-99fd-a0c9131d7ab4'::UUID, 'd1a7d371-bb6b-5f6a-808d-bf7ef53a287c'::UUID, 4, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('557c232d-ccc6-5bc0-9380-fd85703bd1bd'::UUID, 'a3af845c-ac0d-54b9-99fd-a0c9131d7ab4'::UUID, '0262e2dc-756e-5f3f-87c8-a7ef303c91d1'::UUID, 5, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('9d4afce3-10cf-5320-a266-379dace0cf70'::UUID, 'a3af845c-ac0d-54b9-99fd-a0c9131d7ab4'::UUID, '1116d856-193e-567c-be32-d736348b9b92'::UUID, 6, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.grammar_lessons (id, content_key, title, pattern, explanation, example_chinese, example_pinyin, example_meaning, level, status, usage_note, content_version)
VALUES ('fb700ebd-a816-54f7-b170-76e20a96d73f'::UUID, 'hsk6:thanh-ngu', 'Cách dùng thành ngữ làm vị ngữ', 'chủ ngữ + 应该/需要 + thành ngữ', 'Nhiều thành ngữ bốn chữ có thể làm vị ngữ hoặc trạng ngữ theo ngữ cảnh.', '制定方案时应该实事求是、因地制宜。', 'Zhìdìng fāngàn shí yīnggāi shíshì qiúshì, yīndì zhìyí.', 'Khi lập phương án nên tôn trọng thực tế và phù hợp điều kiện địa phương.', 'advanced', 'review', NULL, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_grammar (id, lesson_id, grammar_lesson_id, order_index, curriculum_role)
VALUES ('fe0120f3-4c17-5526-983a-ec143ee4578b'::UUID, 'a3af845c-ac0d-54b9-99fd-a0c9131d7ab4'::UUID, 'fb700ebd-a816-54f7-b170-76e20a96d73f'::UUID, 1, 'introduced')
ON CONFLICT (lesson_id, grammar_lesson_id) DO NOTHING;

INSERT INTO public.lesson_grammar (id, lesson_id, grammar_lesson_id, order_index, curriculum_role)
VALUES ('9cfe2c1c-dd25-5098-acca-078fbdb177a9'::UUID, 'a3af845c-ac0d-54b9-99fd-a0c9131d7ab4'::UUID, 'd4c91dca-4a6e-5cd0-864c-a05369265d00'::UUID, 2, 'review')
ON CONFLICT (lesson_id, grammar_lesson_id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('e1277706-d0e5-553c-b807-e2ab9085748f'::UUID, 'a3af845c-ac0d-54b9-99fd-a0c9131d7ab4'::UUID, 'vocabulary', 1, 'Từ mới: 实事求是', NULL, '实事求是', '实事求是 (shíshì qiúshì) — tôn trọng sự thật. 分析问题应该实事求是。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"hsk6:实事求是","chinese":"实事求是","pinyin":"shíshì qiúshì","meaning":"tôn trọng sự thật","part_of_speech":"thành ngữ","example_chinese":"分析问题应该实事求是。","example_pinyin":"Fēnxī wèntí yīnggāi shíshì qiúshì.","example_meaning_vi":"Phân tích vấn đề nên tôn trọng sự thật."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('ea470d78-eb4b-558d-9401-6b21c9210020'::UUID, 'a3af845c-ac0d-54b9-99fd-a0c9131d7ab4'::UUID, 'vocabulary', 2, 'Từ mới: 因地制宜', NULL, '因地制宜', '因地制宜 (yīndì zhìyí) — tùy nơi mà áp dụng phù hợp. 各地应该因地制宜发展产业。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"hsk6:因地制宜","chinese":"因地制宜","pinyin":"yīndì zhìyí","meaning":"tùy nơi mà áp dụng phù hợp","part_of_speech":"thành ngữ","example_chinese":"各地应该因地制宜发展产业。","example_pinyin":"Gèdì yīnggāi yīndì zhìyí fāzhǎn chǎnyè.","example_meaning_vi":"Các nơi nên phát triển ngành nghề phù hợp điều kiện địa phương."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('62cff0a2-6643-5369-8ccf-fdef1a9617b9'::UUID, 'a3af845c-ac0d-54b9-99fd-a0c9131d7ab4'::UUID, 'vocabulary', 3, 'Từ mới: 循序渐进', NULL, '循序渐进', '循序渐进 (xúnxù jiànjìn) — tiến dần theo trình tự. 学习语言需要循序渐进。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"hsk6:循序渐进","chinese":"循序渐进","pinyin":"xúnxù jiànjìn","meaning":"tiến dần theo trình tự","part_of_speech":"thành ngữ","example_chinese":"学习语言需要循序渐进。","example_pinyin":"Xuéxí yǔyán xūyào xúnxù jiànjìn.","example_meaning_vi":"Học ngôn ngữ cần tiến dần từng bước."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('c4952c7b-88fd-55c7-8705-b02ec4651131'::UUID, 'a3af845c-ac0d-54b9-99fd-a0c9131d7ab4'::UUID, 'multiple_choice', 4, '“实事求是” có nghĩa phù hợp nhất là gì?', NULL, 'tôn trọng sự thật', '实事求是 (shíshì qiúshì) nghĩa là “tôn trọng sự thật”.', NULL, 1, '{"activity_type":"chinese_to_vietnamese","vocabulary_key":"hsk6:实事求是"}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('a40cf0cd-5cdb-5db1-8f2f-18016a978d9a'::UUID, 'c4952c7b-88fd-55c7-8705-b02ec4651131'::UUID, 'tiến dần theo trình tự', FALSE, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('e881c219-d34f-5eef-b6fb-237534ab9acf'::UUID, 'c4952c7b-88fd-55c7-8705-b02ec4651131'::UUID, 'tôn trọng sự thật', TRUE, 2)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('60463b67-88b2-5c7d-9486-5a76aaa1eaf2'::UUID, 'c4952c7b-88fd-55c7-8705-b02ec4651131'::UUID, 'tùy nơi mà áp dụng phù hợp', FALSE, 3)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('61727b6c-ebca-5cea-a73b-90cea0eb292d'::UUID, 'a3af845c-ac0d-54b9-99fd-a0c9131d7ab4'::UUID, 'translation', 5, 'Dịch sang tiếng Trung: “Khi lập phương án nên tôn trọng thực tế và phù hợp điều kiện địa phương.”', NULL, '制定方案时应该实事求是、因地制宜。', 'Mẫu câu dùng “实事求是” trong ngữ cảnh của bài.', 'shíshì qiúshì', 1, '{"activity_type":"vietnamese_to_chinese","source_lang":"vi","target_lang":"zh","acceptable_answers":["制定方案时应该实事求是、因地制宜。"]}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('d7ff7760-3927-5793-b111-3615d754d4d6'::UUID, 'a3af845c-ac0d-54b9-99fd-a0c9131d7ab4'::UUID, 'sentence_builder', 6, 'Sắp xếp các thành phần thành câu đúng.', NULL, '制定方案时应该实事求是、因地制宜。', 'Trật tự đúng tạo thành câu “制定方案时应该实事求是、因地制宜。”.', NULL, 1, '{"activity_type":"sentence_ordering","words":["制定","方案","时","应该","实事求是","、","因地制宜","。"],"correct_order":["制定","方案","时","应该","实事求是","、","因地制宜","。"]}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('58d54489-9637-5c6e-81e1-6cb9a5f2fef3'::UUID, 'a3af845c-ac0d-54b9-99fd-a0c9131d7ab4'::UUID, 'multiple_choice', 7, 'Câu nào dùng thành ngữ phù hợp ngữ cảnh?', NULL, '制定方案时应该实事求是、因地制宜。', 'Nhiều thành ngữ bốn chữ có thể làm vị ngữ hoặc trạng ngữ theo ngữ cảnh.', NULL, 1, '{"activity_type":"grammar_selection","passage":null,"grammar_key":"hsk6:thanh-ngu"}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('0fbfe351-c995-59ab-9f34-fe965a064648'::UUID, '58d54489-9637-5c6e-81e1-6cb9a5f2fef3'::UUID, '制定方案时应该实事求是、因地制宜。', TRUE, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('ea7a7fa5-a9c4-5c6f-8b92-6a8edb3bcbdd'::UUID, '58d54489-9637-5c6e-81e1-6cb9a5f2fef3'::UUID, '。因地制宜、实事求是应该时方案制定', FALSE, 2)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('234ef8ea-77ef-585b-ad03-edf4e614ced5'::UUID, '58d54489-9637-5c6e-81e1-6cb9a5f2fef3'::UUID, '方案时应该实事求是、因地制宜。制定', FALSE, 3)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('92434f09-0739-5b0e-b500-7c8cb044b18a'::UUID, 'a3af845c-ac0d-54b9-99fd-a0c9131d7ab4'::UUID, 'speaking', 8, 'Đọc thành tiếng: 制定方案时应该实事求是、因地制宜。', NULL, '制定方案时应该实事求是、因地制宜。', 'Đọc chậm, giữ đúng thanh điệu và nhịp của cả câu.', NULL, 1, '{"activity_type":"pronunciation","text":"制定方案时应该实事求是、因地制宜。","pinyin":"Zhìdìng fāngàn shí yīnggāi shíshì qiúshì, yīndì zhìyí."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.units (id, course_id, slug, title, description, order_index, status, learning_objectives, content_version)
VALUES ('bb6e9f06-c770-550f-8d70-2fb52253403e'::UUID, '4d34bda1-b911-5aa0-8ba3-d504fdc38ca0'::UUID, 'hsk6-on-tap', 'Ôn tập', 'Kiểm tra và củng cố nội dung đã học.', 3, 'review', '["Ôn từ vựng","Ôn mẫu câu"]'::JSONB, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.chapters (id, unit_id, slug, title, description, order_index, status, learning_objectives, content_version)
VALUES ('eb1a8a8f-35d1-5cc5-9ed1-48f602e36d97'::UUID, 'bb6e9f06-c770-550f-8d70-2fb52253403e'::UUID, 'hsk6-on-tap-chapter', 'Củng cố lộ trình', 'Kiểm tra và củng cố nội dung đã học.', 1, 'review', '["Ôn từ vựng","Ôn mẫu câu"]'::JSONB, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lessons (id, chapter_id, slug, title, description, order_index, xp_reward, status, lesson_type, estimated_minutes, learning_objectives, cultural_note, content_version)
VALUES ('d9efa62c-e983-57f4-bf3a-d0c671f0b553'::UUID, 'eb1a8a8f-35d1-5cc5-9ed1-48f602e36d97'::UUID, 'hsk6-review', 'Ôn tập HSK 6', 'Củng cố từ vựng, mẫu câu và khả năng diễn đạt của toàn khóa.', 1, 30, 'review', 'review', 18, '["Vận dụng lại từ vựng trọng tâm","Tự kiểm tra mẫu câu đã học"]'::JSONB, NULL, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('6ea4f186-fc6d-5f32-a9ff-a4eb209e114f'::UUID, 'd9efa62c-e983-57f4-bf3a-d0c671f0b553'::UUID, 'b7410e4b-f29c-51b8-955f-e541bcd4ba04'::UUID, 1, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('26a60c72-b7d3-58ba-b887-64d369e60c11'::UUID, 'd9efa62c-e983-57f4-bf3a-d0c671f0b553'::UUID, '89296b7d-9d4e-5c17-96ef-642e124377d4'::UUID, 2, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('e4f54adc-b50f-5d67-bdf3-96081e3a803e'::UUID, 'd9efa62c-e983-57f4-bf3a-d0c671f0b553'::UUID, 'e276b8d0-262a-50a9-887c-57b81c247e0c'::UUID, 3, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_grammar (id, lesson_id, grammar_lesson_id, order_index, curriculum_role)
VALUES ('b7f0ec26-6e39-55bb-ba5b-dba5ab87f0fe'::UUID, 'd9efa62c-e983-57f4-bf3a-d0c671f0b553'::UUID, 'fb700ebd-a816-54f7-b170-76e20a96d73f'::UUID, 1, 'review')
ON CONFLICT (lesson_id, grammar_lesson_id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('523c3a5a-f115-5150-9674-8c5fcf5c4c4a'::UUID, 'd9efa62c-e983-57f4-bf3a-d0c671f0b553'::UUID, 'multiple_choice', 1, '“实事求是” có nghĩa phù hợp nhất là gì?', NULL, 'tôn trọng sự thật', '实事求是 (shíshì qiúshì) nghĩa là “tôn trọng sự thật”.', NULL, 1, '{"activity_type":"chinese_to_vietnamese","vocabulary_key":"hsk6:实事求是"}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('9d8ff61e-1013-5d0f-bb71-4e1b9b011b0c'::UUID, '523c3a5a-f115-5150-9674-8c5fcf5c4c4a'::UUID, 'tùy nơi mà áp dụng phù hợp', FALSE, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('0aefcc86-deed-515a-9a6a-a73b6952b325'::UUID, '523c3a5a-f115-5150-9674-8c5fcf5c4c4a'::UUID, 'tiến dần theo trình tự', FALSE, 2)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('25d812b4-00d0-5339-8124-7514a46d2a7b'::UUID, '523c3a5a-f115-5150-9674-8c5fcf5c4c4a'::UUID, 'tôn trọng sự thật', TRUE, 3)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('b02147b2-b879-5eb6-b647-f6c4a502f4d3'::UUID, 'd9efa62c-e983-57f4-bf3a-d0c671f0b553'::UUID, 'translation', 2, 'Dịch sang tiếng Trung: “Khi lập phương án nên tôn trọng thực tế và phù hợp điều kiện địa phương.”', NULL, '制定方案时应该实事求是、因地制宜。', 'Mẫu câu dùng “实事求是” trong ngữ cảnh của bài.', 'shíshì qiúshì', 1, '{"activity_type":"vietnamese_to_chinese","source_lang":"vi","target_lang":"zh","acceptable_answers":["制定方案时应该实事求是、因地制宜。"]}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('3090dbe5-0fdc-5b09-a6b2-87ff0464ae3c'::UUID, 'd9efa62c-e983-57f4-bf3a-d0c671f0b553'::UUID, 'sentence_builder', 3, 'Sắp xếp các thành phần thành câu đúng.', NULL, '制定方案时应该实事求是、因地制宜。', 'Trật tự đúng tạo thành câu “制定方案时应该实事求是、因地制宜。”.', NULL, 1, '{"activity_type":"sentence_ordering","words":["制定","方案","时","应该","实事求是","、","因地制宜","。"],"correct_order":["制定","方案","时","应该","实事求是","、","因地制宜","。"]}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('c5e8ac52-46ec-5179-b049-f59e151f7bc2'::UUID, 'd9efa62c-e983-57f4-bf3a-d0c671f0b553'::UUID, 'multiple_choice', 4, 'Câu nào dùng thành ngữ phù hợp ngữ cảnh?', NULL, '制定方案时应该实事求是、因地制宜。', 'Nhiều thành ngữ bốn chữ có thể làm vị ngữ hoặc trạng ngữ theo ngữ cảnh.', NULL, 1, '{"activity_type":"grammar_selection","passage":null,"grammar_key":"hsk6:thanh-ngu"}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('019fe772-a2cc-58d9-82dd-1d39e86497a2'::UUID, 'c5e8ac52-46ec-5179-b049-f59e151f7bc2'::UUID, '制定方案时应该实事求是、因地制宜。', TRUE, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('2f66296e-d7b6-5def-a6e2-60c806faec9f'::UUID, 'c5e8ac52-46ec-5179-b049-f59e151f7bc2'::UUID, '。因地制宜、实事求是应该时方案制定', FALSE, 2)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('f4428436-6736-5c5c-9969-982954c27c78'::UUID, 'c5e8ac52-46ec-5179-b049-f59e151f7bc2'::UUID, '方案时应该实事求是、因地制宜。制定', FALSE, 3)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('c6d5c5c5-b1a5-5dea-a90e-e5ff60101db9'::UUID, 'd9efa62c-e983-57f4-bf3a-d0c671f0b553'::UUID, 'speaking', 5, 'Đọc thành tiếng: 制定方案时应该实事求是、因地制宜。', NULL, '制定方案时应该实事求是、因地制宜。', 'Đọc chậm, giữ đúng thanh điệu và nhịp của cả câu.', NULL, 1, '{"activity_type":"pronunciation","text":"制定方案时应该实事求是、因地制宜。","pinyin":"Zhìdìng fāngàn shí yīnggāi shíshì qiúshì, yīndì zhìyí."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.content_batches (id, batch_key, version, migration_name, manifest_checksum, expected_counts)
VALUES ('fe93d3b7-d865-525b-8ede-da0d26d1f52d'::UUID, 'batch-07-hsk6', 1, '20260729160000_content_batch_07_hsk6', '65861ddba232842c07742dde78090a1f798c392c0fc46185643dc2d7508efc4e', '{"courses":1,"units":3,"chapters":3,"lessons":5,"vocabulary":12,"grammar":4,"characters":0,"exercises":37,"options":30}'::JSONB)
ON CONFLICT (batch_key, version) DO NOTHING;

DO $content_validation$
BEGIN
  IF (SELECT COUNT(*) FROM public.courses WHERE id = ANY(ARRAY['4d34bda1-b911-5aa0-8ba3-d504fdc38ca0'::UUID]::UUID[])) <> 1 THEN
    RAISE EXCEPTION 'Content batch batch-07-hsk6 is missing managed courses rows';
  END IF;
  IF (SELECT COUNT(*) FROM public.units WHERE id = ANY(ARRAY['d3f65d26-3076-5a3e-ac86-75670f1a9000'::UUID, '237d7ee6-46dd-5ff5-b346-3f88e3cddd37'::UUID, 'bb6e9f06-c770-550f-8d70-2fb52253403e'::UUID]::UUID[])) <> 3 THEN
    RAISE EXCEPTION 'Content batch batch-07-hsk6 is missing managed units rows';
  END IF;
  IF (SELECT COUNT(*) FROM public.chapters WHERE id = ANY(ARRAY['54d768ce-6f8d-56c2-a1e7-329043905273'::UUID, '60dd593f-25dc-556a-8d0d-97d1542b3a61'::UUID, 'eb1a8a8f-35d1-5cc5-9ed1-48f602e36d97'::UUID]::UUID[])) <> 3 THEN
    RAISE EXCEPTION 'Content batch batch-07-hsk6 is missing managed chapters rows';
  END IF;
  IF (SELECT COUNT(*) FROM public.lessons WHERE id = ANY(ARRAY['12d366be-904b-521e-9a8c-7dff513ba8d3'::UUID, '8bd5a896-12df-5cda-8833-4ba103dc0142'::UUID, '635163b4-3110-5f68-a937-ce9f93ccfbb3'::UUID, 'a3af845c-ac0d-54b9-99fd-a0c9131d7ab4'::UUID, 'd9efa62c-e983-57f4-bf3a-d0c671f0b553'::UUID]::UUID[])) <> 5 THEN
    RAISE EXCEPTION 'Content batch batch-07-hsk6 is missing managed lessons rows';
  END IF;
  IF (SELECT COUNT(*) FROM public.vocabulary WHERE id = ANY(ARRAY['492a8633-7b36-56da-b18e-9ce93ea197f3'::UUID, '6716eb08-d9f2-5869-b574-40e9155b08f7'::UUID, 'a0d6013e-4ebb-58ff-a58e-f74aff702a69'::UUID, 'd2375c64-0b10-5a4a-b611-8dca62d700c9'::UUID, '6e447dee-f07c-599c-9620-43986361c986'::UUID, '24f1bd55-f464-5660-94f5-b7fc0f72b196'::UUID, 'd1a7d371-bb6b-5f6a-808d-bf7ef53a287c'::UUID, '0262e2dc-756e-5f3f-87c8-a7ef303c91d1'::UUID, '1116d856-193e-567c-be32-d736348b9b92'::UUID, 'b7410e4b-f29c-51b8-955f-e541bcd4ba04'::UUID, '89296b7d-9d4e-5c17-96ef-642e124377d4'::UUID, 'e276b8d0-262a-50a9-887c-57b81c247e0c'::UUID]::UUID[])) <> 12 THEN
    RAISE EXCEPTION 'Content batch batch-07-hsk6 is missing managed vocabulary rows';
  END IF;
  IF (SELECT COUNT(*) FROM public.grammar_lessons WHERE id = ANY(ARRAY['92911f09-5c17-5cd6-92cc-1a4b084f6db5'::UUID, '6d952775-2ef4-57df-bdab-52c8b5b22190'::UUID, 'd4c91dca-4a6e-5cd0-864c-a05369265d00'::UUID, 'fb700ebd-a816-54f7-b170-76e20a96d73f'::UUID]::UUID[])) <> 4 THEN
    RAISE EXCEPTION 'Content batch batch-07-hsk6 is missing managed grammar_lessons rows';
  END IF;
  IF (SELECT COUNT(*) FROM public.exercises WHERE id = ANY(ARRAY['d3a400ac-8681-5ea1-bce4-91c56277f9c0'::UUID, '0a796789-1de3-58ee-af9c-54f1c933d06e'::UUID, '847dde17-91c2-57fa-a41f-d1650b32ad35'::UUID, '8eef9be3-b57f-51bb-b068-eaf6fcf3d8ac'::UUID, 'a3b3e619-78d7-55d3-9c02-0cc037f921df'::UUID, '002be7d4-dce4-5593-88fa-cbc48bce410e'::UUID, '6f0f520e-1257-59fc-97d8-94784510cd18'::UUID, '7df69095-4691-5233-953b-4c8e4f36aa1e'::UUID, '6aa55ed6-2c12-5bd7-bf32-b400fce6c463'::UUID, 'c06e0f2e-1b97-5bc5-a205-806f24ee9cc6'::UUID, '1bec6ae4-b86e-5e9c-8405-f965361103a1'::UUID, '090758da-ef35-5169-9774-c008cffa10ab'::UUID, 'd5ca1f70-8942-5892-84ef-202a8bd24258'::UUID, '1cdf4b86-038f-527e-8bdf-b183940deefd'::UUID, 'bc7b1920-698f-5e75-9fb0-000efcdbb456'::UUID, 'fdb987a9-72d7-5af8-82ea-014f4c9f1a53'::UUID, '953cba48-5a0d-5ec9-a4df-697dff432af8'::UUID, 'f9a0c7b2-805c-5d05-ba36-7e58dd5288cd'::UUID, '2dd60aad-a6de-5fb6-bd92-062f13eadf00'::UUID, '468320ee-b27a-56f0-bc55-16999b8c1c52'::UUID, '27770c2d-7ed8-5ac2-9029-73a91d28529d'::UUID, 'e3d9d3ab-ab3c-5e78-a679-5eec7103a297'::UUID, 'e2f0d14f-1189-5961-b2d4-13d98be5fb13'::UUID, '6f909e7f-9793-57df-8a1d-d439b8c1f466'::UUID, 'e1277706-d0e5-553c-b807-e2ab9085748f'::UUID, 'ea470d78-eb4b-558d-9401-6b21c9210020'::UUID, '62cff0a2-6643-5369-8ccf-fdef1a9617b9'::UUID, 'c4952c7b-88fd-55c7-8705-b02ec4651131'::UUID, '61727b6c-ebca-5cea-a73b-90cea0eb292d'::UUID, 'd7ff7760-3927-5793-b111-3615d754d4d6'::UUID, '58d54489-9637-5c6e-81e1-6cb9a5f2fef3'::UUID, '92434f09-0739-5b0e-b500-7c8cb044b18a'::UUID, '523c3a5a-f115-5150-9674-8c5fcf5c4c4a'::UUID, 'b02147b2-b879-5eb6-b647-f6c4a502f4d3'::UUID, '3090dbe5-0fdc-5b09-a6b2-87ff0464ae3c'::UUID, 'c5e8ac52-46ec-5179-b049-f59e151f7bc2'::UUID, 'c6d5c5c5-b1a5-5dea-a90e-e5ff60101db9'::UUID]::UUID[])) <> 37 THEN
    RAISE EXCEPTION 'Content batch batch-07-hsk6 is missing managed exercises rows';
  END IF;
  IF (SELECT COUNT(*) FROM public.exercise_options WHERE id = ANY(ARRAY['929bf141-ba9d-5243-9f2a-39644ce1ab3b'::UUID, '9cd6b631-855c-5232-95f5-81ff71242be6'::UUID, 'a5c94402-9efc-59ba-8b29-81f31d2b01ab'::UUID, '6013656f-d7e0-5cbb-9688-a9bdf35ba71a'::UUID, 'f829ddf8-bec3-5254-ac5e-00b521a2d96b'::UUID, '543df219-37f6-5694-80bb-c8380381522a'::UUID, '8baa3f2d-fdb1-5c75-afe3-e71e5571a067'::UUID, '7323e59f-a60d-5781-afcf-baea1584936c'::UUID, '317f5bd5-70c2-51eb-8084-cd516b76eac0'::UUID, '9c2f2df8-0447-5a5b-998a-99328ecca634'::UUID, 'f256dc48-8b74-5933-974d-cd2cf363b091'::UUID, 'ac04bbc9-b77b-53c6-b229-bb768044dd74'::UUID, '53ee3bb6-9d80-5731-a601-851fe04e1ce8'::UUID, '38957f0d-7ae4-5e7a-92c3-6f718aea9647'::UUID, '39c4c8f8-7352-5900-bb41-47b2d8b95206'::UUID, '11d8fe16-5a06-5e64-b6fa-bff0b5a2562c'::UUID, '209df938-dbc7-509f-a0e1-d4dc521dcb25'::UUID, '68c75f54-8f51-51f5-acb0-c7eafd43b556'::UUID, 'a40cf0cd-5cdb-5db1-8f2f-18016a978d9a'::UUID, 'e881c219-d34f-5eef-b6fb-237534ab9acf'::UUID, '60463b67-88b2-5c7d-9486-5a76aaa1eaf2'::UUID, '0fbfe351-c995-59ab-9f34-fe965a064648'::UUID, 'ea7a7fa5-a9c4-5c6f-8b92-6a8edb3bcbdd'::UUID, '234ef8ea-77ef-585b-ad03-edf4e614ced5'::UUID, '9d8ff61e-1013-5d0f-bb71-4e1b9b011b0c'::UUID, '0aefcc86-deed-515a-9a6a-a73b6952b325'::UUID, '25d812b4-00d0-5339-8124-7514a46d2a7b'::UUID, '019fe772-a2cc-58d9-82dd-1d39e86497a2'::UUID, '2f66296e-d7b6-5def-a6e2-60c806faec9f'::UUID, 'f4428436-6736-5c5c-9969-982954c27c78'::UUID]::UUID[])) <> 30 THEN
    RAISE EXCEPTION 'Content batch batch-07-hsk6 is missing managed exercise_options rows';
  END IF;
  IF EXISTS (
    SELECT 1 FROM public.lessons AS lesson
    WHERE lesson.id = ANY(ARRAY['12d366be-904b-521e-9a8c-7dff513ba8d3'::UUID, '8bd5a896-12df-5cda-8833-4ba103dc0142'::UUID, '635163b4-3110-5f68-a937-ce9f93ccfbb3'::UUID, 'a3af845c-ac0d-54b9-99fd-a0c9131d7ab4'::UUID, 'd9efa62c-e983-57f4-bf3a-d0c671f0b553'::UUID]::UUID[])
      AND NOT EXISTS (
        SELECT 1 FROM public.exercises AS exercise
        WHERE exercise.lesson_id = lesson.id
      )
  ) THEN
    RAISE EXCEPTION 'Content batch batch-07-hsk6 contains a lesson without exercises';
  END IF;
  IF EXISTS (
    SELECT 1
    FROM public.lessons AS lesson
    JOIN public.exercises AS exercise ON exercise.lesson_id = lesson.id
    WHERE lesson.id = ANY(ARRAY['12d366be-904b-521e-9a8c-7dff513ba8d3'::UUID, '8bd5a896-12df-5cda-8833-4ba103dc0142'::UUID, '635163b4-3110-5f68-a937-ce9f93ccfbb3'::UUID, 'a3af845c-ac0d-54b9-99fd-a0c9131d7ab4'::UUID, 'd9efa62c-e983-57f4-bf3a-d0c671f0b553'::UUID]::UUID[])
      AND lesson.status = 'published'
      AND exercise.exercise_type = 'listening'
      AND NULLIF(BTRIM(exercise.question_audio_url), '') IS NULL
  ) THEN
    RAISE EXCEPTION 'Published listening exercise is missing playable audio';
  END IF;
  IF EXISTS (
    SELECT 1
    FROM public.exercises AS exercise
    WHERE exercise.id = ANY(ARRAY['d3a400ac-8681-5ea1-bce4-91c56277f9c0'::UUID, '0a796789-1de3-58ee-af9c-54f1c933d06e'::UUID, '847dde17-91c2-57fa-a41f-d1650b32ad35'::UUID, '8eef9be3-b57f-51bb-b068-eaf6fcf3d8ac'::UUID, 'a3b3e619-78d7-55d3-9c02-0cc037f921df'::UUID, '002be7d4-dce4-5593-88fa-cbc48bce410e'::UUID, '6f0f520e-1257-59fc-97d8-94784510cd18'::UUID, '7df69095-4691-5233-953b-4c8e4f36aa1e'::UUID, '6aa55ed6-2c12-5bd7-bf32-b400fce6c463'::UUID, 'c06e0f2e-1b97-5bc5-a205-806f24ee9cc6'::UUID, '1bec6ae4-b86e-5e9c-8405-f965361103a1'::UUID, '090758da-ef35-5169-9774-c008cffa10ab'::UUID, 'd5ca1f70-8942-5892-84ef-202a8bd24258'::UUID, '1cdf4b86-038f-527e-8bdf-b183940deefd'::UUID, 'bc7b1920-698f-5e75-9fb0-000efcdbb456'::UUID, 'fdb987a9-72d7-5af8-82ea-014f4c9f1a53'::UUID, '953cba48-5a0d-5ec9-a4df-697dff432af8'::UUID, 'f9a0c7b2-805c-5d05-ba36-7e58dd5288cd'::UUID, '2dd60aad-a6de-5fb6-bd92-062f13eadf00'::UUID, '468320ee-b27a-56f0-bc55-16999b8c1c52'::UUID, '27770c2d-7ed8-5ac2-9029-73a91d28529d'::UUID, 'e3d9d3ab-ab3c-5e78-a679-5eec7103a297'::UUID, 'e2f0d14f-1189-5961-b2d4-13d98be5fb13'::UUID, '6f909e7f-9793-57df-8a1d-d439b8c1f466'::UUID, 'e1277706-d0e5-553c-b807-e2ab9085748f'::UUID, 'ea470d78-eb4b-558d-9401-6b21c9210020'::UUID, '62cff0a2-6643-5369-8ccf-fdef1a9617b9'::UUID, 'c4952c7b-88fd-55c7-8705-b02ec4651131'::UUID, '61727b6c-ebca-5cea-a73b-90cea0eb292d'::UUID, 'd7ff7760-3927-5793-b111-3615d754d4d6'::UUID, '58d54489-9637-5c6e-81e1-6cb9a5f2fef3'::UUID, '92434f09-0739-5b0e-b500-7c8cb044b18a'::UUID, '523c3a5a-f115-5150-9674-8c5fcf5c4c4a'::UUID, 'b02147b2-b879-5eb6-b647-f6c4a502f4d3'::UUID, '3090dbe5-0fdc-5b09-a6b2-87ff0464ae3c'::UUID, 'c5e8ac52-46ec-5179-b049-f59e151f7bc2'::UUID, 'c6d5c5c5-b1a5-5dea-a90e-e5ff60101db9'::UUID]::UUID[])
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
    WHERE link.lesson_id = ANY(ARRAY['12d366be-904b-521e-9a8c-7dff513ba8d3'::UUID, '8bd5a896-12df-5cda-8833-4ba103dc0142'::UUID, '635163b4-3110-5f68-a937-ce9f93ccfbb3'::UUID, 'a3af845c-ac0d-54b9-99fd-a0c9131d7ab4'::UUID, 'd9efa62c-e983-57f4-bf3a-d0c671f0b553'::UUID]::UUID[])
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
