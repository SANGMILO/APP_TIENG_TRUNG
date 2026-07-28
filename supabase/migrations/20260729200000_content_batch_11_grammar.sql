-- Generated from content/manifests/11_grammar.json.
-- Do not hand-edit this migration; edit the manifest and regenerate.
-- Additive and idempotent: deterministic IDs plus ON CONFLICT DO NOTHING.

BEGIN;

INSERT INTO public.courses (id, slug, title, title_zh, description, level, status, order_index, learning_objectives, estimated_minutes, content_version)
VALUES ('255b8c5e-b8e8-5c7d-ba59-2e4046a33497'::UUID, 'chinese-grammar', 'Chinese Grammar', '汉语语法', 'Hệ thống hóa cấu trúc câu từ cơ bản đến phức hợp.', 'upper-intermediate', 'review', 10, '["Phân tích thành phần câu","Chọn cấu trúc theo ý nghĩa","Sửa lỗi trật tự và liên kết"]'::JSONB, 78, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.units (id, course_id, slug, title, description, order_index, status, learning_objectives, content_version)
VALUES ('24bcfe6b-5c23-5348-a9ee-00e81609d6c7'::UUID, '255b8c5e-b8e8-5c7d-ba59-2e4046a33497'::UUID, 'grammar-nen-tang', 'Nền tảng', 'Xây dựng ngôn ngữ cốt lõi của lộ trình.', 1, 'review', '["Phân tích thành phần câu","Chọn cấu trúc theo ý nghĩa"]'::JSONB, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.chapters (id, unit_id, slug, title, description, order_index, status, learning_objectives, content_version)
VALUES ('6912ef97-3dcc-5b05-9e6b-663e678c245b'::UUID, '24bcfe6b-5c23-5348-a9ee-00e81609d6c7'::UUID, 'grammar-nen-tang-chapter', 'Khái niệm cốt lõi', 'Xây dựng ngôn ngữ cốt lõi của lộ trình.', 1, 'review', '["Phân tích thành phần câu","Chọn cấu trúc theo ý nghĩa"]'::JSONB, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lessons (id, chapter_id, slug, title, description, order_index, xp_reward, status, lesson_type, estimated_minutes, learning_objectives, cultural_note, content_version)
VALUES ('c283fa88-481f-505a-8d25-c6861e2f7d2a'::UUID, '6912ef97-3dcc-5b05-9e6b-663e678c245b'::UUID, 'thanh-phan-cau', '句子成分 — Thành phần câu', 'Nhận diện chủ ngữ, vị ngữ và tân ngữ.', 1, 25, 'review', 'standard', 15, '["Phân tích cấu trúc câu"]'::JSONB, 'Trạng ngữ thường đứng trước động từ vị ngữ.', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('bfcc31b5-7452-5837-a4ad-51c4d64b105c'::UUID, 'grammar:主语', '主语', 'zhǔyǔ', 'chủ ngữ', 'subject', 'upper-intermediate', 'thanh-phan-cau', 'danh từ', '这个句子的主语是“学生”。', 'Zhège jùzi de zhǔyǔ shì “xuésheng”.', 'Chủ ngữ của câu này là “học sinh”.', NULL, 'review', 'c283fa88-481f-505a-8d25-c6861e2f7d2a'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('c8c76433-b2f5-560b-b536-79d2618c5708'::UUID, 'c283fa88-481f-505a-8d25-c6861e2f7d2a'::UUID, 'bfcc31b5-7452-5837-a4ad-51c4d64b105c'::UUID, 1, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('739f8096-eef7-5d39-bf55-eef1322cee45'::UUID, 'grammar:谓语', '谓语', 'wèiyǔ', 'vị ngữ', 'predicate', 'upper-intermediate', 'thanh-phan-cau', 'danh từ', '形容词也可以作谓语。', 'Xíngróngcí yě kěyǐ zuò wèiyǔ.', 'Tính từ cũng có thể làm vị ngữ.', NULL, 'review', 'c283fa88-481f-505a-8d25-c6861e2f7d2a'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('f5f10a8f-adf5-54e6-ade9-0b7b46ad2440'::UUID, 'c283fa88-481f-505a-8d25-c6861e2f7d2a'::UUID, '739f8096-eef7-5d39-bf55-eef1322cee45'::UUID, 2, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('948e642b-21f0-5cef-aa72-bce43ab76992'::UUID, 'grammar:宾语', '宾语', 'bīnyǔ', 'tân ngữ', 'object', 'upper-intermediate', 'thanh-phan-cau', 'danh từ', '“汉语”是动词“学习”的宾语。', '“Hànyǔ” shì dòngcí “xuéxí” de bīnyǔ.', '“Tiếng Trung” là tân ngữ của động từ “học”.', NULL, 'review', 'c283fa88-481f-505a-8d25-c6861e2f7d2a'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('f380f4fa-6e0c-51d7-a8f8-bf5e9e6c960b'::UUID, 'c283fa88-481f-505a-8d25-c6861e2f7d2a'::UUID, '948e642b-21f0-5cef-aa72-bce43ab76992'::UUID, 3, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.grammar_lessons (id, content_key, title, pattern, explanation, example_chinese, example_pinyin, example_meaning, level, status, usage_note, content_version)
VALUES ('1d3cf518-f976-56e4-a2c9-1d09e6913d5f'::UUID, 'grammar:thanh-phan-cau', 'Trật tự câu cơ bản', 'chủ ngữ + vị ngữ + tân ngữ', 'Trật tự cơ bản đặt người thực hiện trước động từ và đối tượng sau động từ.', '学生认真学习汉语。', 'Xuésheng rènzhēn xuéxí Hànyǔ.', 'Học sinh chăm chỉ học tiếng Trung.', 'upper-intermediate', 'review', NULL, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_grammar (id, lesson_id, grammar_lesson_id, order_index, curriculum_role)
VALUES ('3f30f181-bb72-5966-af9f-d56421375605'::UUID, 'c283fa88-481f-505a-8d25-c6861e2f7d2a'::UUID, '1d3cf518-f976-56e4-a2c9-1d09e6913d5f'::UUID, 1, 'introduced')
ON CONFLICT (lesson_id, grammar_lesson_id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('70e0042c-c45d-5e94-a2ae-e3d9be9ce9be'::UUID, 'c283fa88-481f-505a-8d25-c6861e2f7d2a'::UUID, 'vocabulary', 1, 'Từ mới: 主语', NULL, '主语', '主语 (zhǔyǔ) — chủ ngữ. 这个句子的主语是“学生”。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"grammar:主语","chinese":"主语","pinyin":"zhǔyǔ","meaning":"chủ ngữ","part_of_speech":"danh từ","example_chinese":"这个句子的主语是“学生”。","example_pinyin":"Zhège jùzi de zhǔyǔ shì “xuésheng”.","example_meaning_vi":"Chủ ngữ của câu này là “học sinh”."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('19a949fc-0888-5c6c-8ba8-374dcded9812'::UUID, 'c283fa88-481f-505a-8d25-c6861e2f7d2a'::UUID, 'vocabulary', 2, 'Từ mới: 谓语', NULL, '谓语', '谓语 (wèiyǔ) — vị ngữ. 形容词也可以作谓语。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"grammar:谓语","chinese":"谓语","pinyin":"wèiyǔ","meaning":"vị ngữ","part_of_speech":"danh từ","example_chinese":"形容词也可以作谓语。","example_pinyin":"Xíngróngcí yě kěyǐ zuò wèiyǔ.","example_meaning_vi":"Tính từ cũng có thể làm vị ngữ."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('02ca4cca-2591-5470-8dd1-fe8117ef9cb4'::UUID, 'c283fa88-481f-505a-8d25-c6861e2f7d2a'::UUID, 'vocabulary', 3, 'Từ mới: 宾语', NULL, '宾语', '宾语 (bīnyǔ) — tân ngữ. “汉语”是动词“学习”的宾语。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"grammar:宾语","chinese":"宾语","pinyin":"bīnyǔ","meaning":"tân ngữ","part_of_speech":"danh từ","example_chinese":"“汉语”是动词“学习”的宾语。","example_pinyin":"“Hànyǔ” shì dòngcí “xuéxí” de bīnyǔ.","example_meaning_vi":"“Tiếng Trung” là tân ngữ của động từ “học”."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('98df7e38-c821-5e91-8597-fd54590648d7'::UUID, 'c283fa88-481f-505a-8d25-c6861e2f7d2a'::UUID, 'multiple_choice', 4, '“主语” có nghĩa phù hợp nhất là gì?', NULL, 'chủ ngữ', '主语 (zhǔyǔ) nghĩa là “chủ ngữ”.', NULL, 1, '{"activity_type":"chinese_to_vietnamese","vocabulary_key":"grammar:主语"}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('c06967e0-0773-5a68-9a87-a6bca7aba6ef'::UUID, '98df7e38-c821-5e91-8597-fd54590648d7'::UUID, 'tân ngữ', FALSE, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('e9ac1243-55e6-52f1-9f39-bf24d69a6e51'::UUID, '98df7e38-c821-5e91-8597-fd54590648d7'::UUID, 'chủ ngữ', TRUE, 2)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('5cccb937-854e-5f4d-8b49-3507a0a00b4a'::UUID, '98df7e38-c821-5e91-8597-fd54590648d7'::UUID, 'vị ngữ', FALSE, 3)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('7fcda631-038c-5ff2-9108-bb4f25798bd0'::UUID, 'c283fa88-481f-505a-8d25-c6861e2f7d2a'::UUID, 'translation', 5, 'Dịch sang tiếng Trung: “Học sinh chăm chỉ học tiếng Trung.”', NULL, '学生认真学习汉语。', 'Mẫu câu dùng “主语” trong ngữ cảnh của bài.', 'zhǔyǔ', 1, '{"activity_type":"vietnamese_to_chinese","source_lang":"vi","target_lang":"zh","acceptable_answers":["学生认真学习汉语。"]}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('7348d3be-95ac-536c-aa35-c8311e044e79'::UUID, 'c283fa88-481f-505a-8d25-c6861e2f7d2a'::UUID, 'sentence_builder', 6, 'Sắp xếp các thành phần thành câu đúng.', NULL, '学生认真学习汉语。', 'Trật tự đúng tạo thành câu “学生认真学习汉语。”.', NULL, 1, '{"activity_type":"sentence_ordering","words":["学生","认真","学习","汉语","。"],"correct_order":["学生","认真","学习","汉语","。"]}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('6d32f1ec-d80e-5772-9d5b-42c6643f7d7d'::UUID, 'c283fa88-481f-505a-8d25-c6861e2f7d2a'::UUID, 'multiple_choice', 7, 'Câu nào có trật tự cơ bản đúng?', NULL, '学生认真学习汉语。', 'Trật tự cơ bản đặt người thực hiện trước động từ và đối tượng sau động từ.', NULL, 1, '{"activity_type":"grammar_selection","passage":null,"grammar_key":"grammar:thanh-phan-cau"}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('7733a5a1-896b-5c06-b4c6-9b02184097ef'::UUID, '6d32f1ec-d80e-5772-9d5b-42c6643f7d7d'::UUID, '学生认真学习汉语。', TRUE, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('21a6972d-3c55-54a4-b0a1-d6e5489a2735'::UUID, '6d32f1ec-d80e-5772-9d5b-42c6643f7d7d'::UUID, '。汉语学习认真学生', FALSE, 2)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('d3112a69-c753-5740-b58a-31f7968173c2'::UUID, '6d32f1ec-d80e-5772-9d5b-42c6643f7d7d'::UUID, '认真学习汉语。学生', FALSE, 3)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('4fc85b8d-f9be-51d9-b9be-9a06591316f8'::UUID, 'c283fa88-481f-505a-8d25-c6861e2f7d2a'::UUID, 'speaking', 8, 'Đọc thành tiếng: 学生认真学习汉语。', NULL, '学生认真学习汉语。', 'Đọc chậm, giữ đúng thanh điệu và nhịp của cả câu.', NULL, 1, '{"activity_type":"pronunciation","text":"学生认真学习汉语。","pinyin":"Xuésheng rènzhēn xuéxí Hànyǔ."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lessons (id, chapter_id, slug, title, description, order_index, xp_reward, status, lesson_type, estimated_minutes, learning_objectives, cultural_note, content_version)
VALUES ('be9183dc-ddf6-5fde-9e6a-2708fc78cf0f'::UUID, '6912ef97-3dcc-5b05-9e6b-663e678c245b'::UUID, 'dinh-ngu', '复杂定语 — Định ngữ phức', 'Đặt cụm bổ nghĩa trước danh từ với 的.', 2, 25, 'review', 'standard', 15, '["Tạo cụm danh từ dài đúng trật tự"]'::JSONB, 'Danh từ trung tâm luôn đứng sau toàn bộ định ngữ.', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('cb5f0a6d-9b3a-5cad-b6cc-730fdf1f44c1'::UUID, 'grammar:定语', '定语', 'dìngyǔ', 'định ngữ', 'attributive', 'upper-intermediate', 'dinh-ngu', 'danh từ', '定语一般放在名词前面。', 'Dìngyǔ yìbān fàng zài míngcí qiánmiàn.', 'Định ngữ thường đặt trước danh từ.', NULL, 'review', 'be9183dc-ddf6-5fde-9e6a-2708fc78cf0f'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('a7b96539-41a4-5eae-8933-8b02ee2ce053'::UUID, 'be9183dc-ddf6-5fde-9e6a-2708fc78cf0f'::UUID, 'cb5f0a6d-9b3a-5cad-b6cc-730fdf1f44c1'::UUID, 1, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('252819ed-0267-520f-a6e0-6500f948bd86'::UUID, 'grammar:修饰', '修饰', 'xiūshì', 'bổ nghĩa', 'modify', 'upper-intermediate', 'dinh-ngu', 'động từ', '这个短语用来修饰名词。', 'Zhège duǎnyǔ yònglái xiūshì míngcí.', 'Cụm này dùng để bổ nghĩa cho danh từ.', NULL, 'review', 'be9183dc-ddf6-5fde-9e6a-2708fc78cf0f'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('2cf621f3-ef45-51fa-a4e8-5cc70a1e42cf'::UUID, 'be9183dc-ddf6-5fde-9e6a-2708fc78cf0f'::UUID, '252819ed-0267-520f-a6e0-6500f948bd86'::UUID, 2, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('e1093a85-a333-5e9e-9974-76a621c8076c'::UUID, 'grammar:中心语', '中心语', 'zhōngxīnyǔ', 'trung tâm ngữ', 'head word', 'upper-intermediate', 'dinh-ngu', 'danh từ', '“书”是这个名词短语的中心语。', '“Shū” shì zhège míngcí duǎnyǔ de zhōngxīnyǔ.', '“Sách” là trung tâm ngữ của cụm danh từ này.', NULL, 'review', 'be9183dc-ddf6-5fde-9e6a-2708fc78cf0f'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('9e995181-df9d-5dc1-9085-c8cd5522687c'::UUID, 'be9183dc-ddf6-5fde-9e6a-2708fc78cf0f'::UUID, 'e1093a85-a333-5e9e-9974-76a621c8076c'::UUID, 3, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('b3c36d45-b924-5401-b939-cc6ef51325b7'::UUID, 'be9183dc-ddf6-5fde-9e6a-2708fc78cf0f'::UUID, 'bfcc31b5-7452-5837-a4ad-51c4d64b105c'::UUID, 4, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('bddc0025-a581-58c4-8659-c3b21fa4753e'::UUID, 'be9183dc-ddf6-5fde-9e6a-2708fc78cf0f'::UUID, '739f8096-eef7-5d39-bf55-eef1322cee45'::UUID, 5, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('a219fa84-bafd-5514-9628-a0b2099a5d66'::UUID, 'be9183dc-ddf6-5fde-9e6a-2708fc78cf0f'::UUID, '948e642b-21f0-5cef-aa72-bce43ab76992'::UUID, 6, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.grammar_lessons (id, content_key, title, pattern, explanation, example_chinese, example_pinyin, example_meaning, level, status, usage_note, content_version)
VALUES ('cfc01873-6041-5109-b3c4-4065082c0086'::UUID, 'grammar:dinh-ngu', 'Định ngữ với 的', 'cụm bổ nghĩa + 的 + danh từ trung tâm', 'Định ngữ dài hoặc có quan hệ sở hữu thường dùng 的.', '这是我昨天在书店买的书。', 'Zhè shì wǒ zuótiān zài shūdiàn mǎi de shū.', 'Đây là cuốn sách tôi mua ở hiệu sách hôm qua.', 'upper-intermediate', 'review', NULL, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_grammar (id, lesson_id, grammar_lesson_id, order_index, curriculum_role)
VALUES ('3245dc78-0e3c-5fba-8243-29f0ab8dd81d'::UUID, 'be9183dc-ddf6-5fde-9e6a-2708fc78cf0f'::UUID, 'cfc01873-6041-5109-b3c4-4065082c0086'::UUID, 1, 'introduced')
ON CONFLICT (lesson_id, grammar_lesson_id) DO NOTHING;

INSERT INTO public.lesson_grammar (id, lesson_id, grammar_lesson_id, order_index, curriculum_role)
VALUES ('ca62ea9d-590a-5c91-b0a7-5ba45b4c4fa0'::UUID, 'be9183dc-ddf6-5fde-9e6a-2708fc78cf0f'::UUID, '1d3cf518-f976-56e4-a2c9-1d09e6913d5f'::UUID, 2, 'review')
ON CONFLICT (lesson_id, grammar_lesson_id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('85cd124a-f2ad-503d-80f7-223c9d061156'::UUID, 'be9183dc-ddf6-5fde-9e6a-2708fc78cf0f'::UUID, 'vocabulary', 1, 'Từ mới: 定语', NULL, '定语', '定语 (dìngyǔ) — định ngữ. 定语一般放在名词前面。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"grammar:定语","chinese":"定语","pinyin":"dìngyǔ","meaning":"định ngữ","part_of_speech":"danh từ","example_chinese":"定语一般放在名词前面。","example_pinyin":"Dìngyǔ yìbān fàng zài míngcí qiánmiàn.","example_meaning_vi":"Định ngữ thường đặt trước danh từ."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('1f59ddd6-297a-500b-b192-6ff70d87d481'::UUID, 'be9183dc-ddf6-5fde-9e6a-2708fc78cf0f'::UUID, 'vocabulary', 2, 'Từ mới: 修饰', NULL, '修饰', '修饰 (xiūshì) — bổ nghĩa. 这个短语用来修饰名词。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"grammar:修饰","chinese":"修饰","pinyin":"xiūshì","meaning":"bổ nghĩa","part_of_speech":"động từ","example_chinese":"这个短语用来修饰名词。","example_pinyin":"Zhège duǎnyǔ yònglái xiūshì míngcí.","example_meaning_vi":"Cụm này dùng để bổ nghĩa cho danh từ."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('11508d7f-5a0f-51e7-a2b9-2913917ec030'::UUID, 'be9183dc-ddf6-5fde-9e6a-2708fc78cf0f'::UUID, 'vocabulary', 3, 'Từ mới: 中心语', NULL, '中心语', '中心语 (zhōngxīnyǔ) — trung tâm ngữ. “书”是这个名词短语的中心语。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"grammar:中心语","chinese":"中心语","pinyin":"zhōngxīnyǔ","meaning":"trung tâm ngữ","part_of_speech":"danh từ","example_chinese":"“书”是这个名词短语的中心语。","example_pinyin":"“Shū” shì zhège míngcí duǎnyǔ de zhōngxīnyǔ.","example_meaning_vi":"“Sách” là trung tâm ngữ của cụm danh từ này."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('7c3cecec-1ba5-525d-b47e-d672709b1764'::UUID, 'be9183dc-ddf6-5fde-9e6a-2708fc78cf0f'::UUID, 'multiple_choice', 4, '“定语” có nghĩa phù hợp nhất là gì?', NULL, 'định ngữ', '定语 (dìngyǔ) nghĩa là “định ngữ”.', NULL, 1, '{"activity_type":"chinese_to_vietnamese","vocabulary_key":"grammar:定语"}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('2cf0a764-ec58-54d0-a4b2-277301b403a7'::UUID, '7c3cecec-1ba5-525d-b47e-d672709b1764'::UUID, 'trung tâm ngữ', FALSE, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('5b56210d-bac0-5fe8-93e8-5962ff079f39'::UUID, '7c3cecec-1ba5-525d-b47e-d672709b1764'::UUID, 'định ngữ', TRUE, 2)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('f67ae3cf-d53c-5881-b7b5-9dd993a4799d'::UUID, '7c3cecec-1ba5-525d-b47e-d672709b1764'::UUID, 'bổ nghĩa', FALSE, 3)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('ce70395a-3972-52b2-a000-a097d1cc5c3c'::UUID, 'be9183dc-ddf6-5fde-9e6a-2708fc78cf0f'::UUID, 'translation', 5, 'Dịch sang tiếng Trung: “Đây là cuốn sách tôi mua ở hiệu sách hôm qua.”', NULL, '这是我昨天在书店买的书。', 'Mẫu câu dùng “定语” trong ngữ cảnh của bài.', 'dìngyǔ', 1, '{"activity_type":"vietnamese_to_chinese","source_lang":"vi","target_lang":"zh","acceptable_answers":["这是我昨天在书店买的书。"]}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('3b5f3f16-65a3-55fb-9e44-13503aea49b5'::UUID, 'be9183dc-ddf6-5fde-9e6a-2708fc78cf0f'::UUID, 'sentence_builder', 6, 'Sắp xếp các thành phần thành câu đúng.', NULL, '这是我昨天在书店买的书。', 'Trật tự đúng tạo thành câu “这是我昨天在书店买的书。”.', NULL, 1, '{"activity_type":"sentence_ordering","words":["这","是","我","昨天","在","书店","买","的","书","。"],"correct_order":["这","是","我","昨天","在","书店","买","的","书","。"]}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('0aa28b9b-9b47-512a-9efa-bce9704f6834'::UUID, 'be9183dc-ddf6-5fde-9e6a-2708fc78cf0f'::UUID, 'multiple_choice', 7, 'Cụm định ngữ nào đúng trật tự?', NULL, '这是我昨天在书店买的书。', 'Định ngữ dài hoặc có quan hệ sở hữu thường dùng 的.', NULL, 1, '{"activity_type":"grammar_selection","passage":null,"grammar_key":"grammar:dinh-ngu"}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('6cadab1f-f630-5c7a-ba0b-6f428d92696a'::UUID, '0aa28b9b-9b47-512a-9efa-bce9704f6834'::UUID, '这是我昨天在书店买的书。', TRUE, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('60c8ca0b-9345-57c1-94e7-ca12801c615f'::UUID, '0aa28b9b-9b47-512a-9efa-bce9704f6834'::UUID, '。书的买书店在昨天我是这', FALSE, 2)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('d39bbdf4-79d6-5a92-8e50-640a2d5077c3'::UUID, '0aa28b9b-9b47-512a-9efa-bce9704f6834'::UUID, '是我昨天在书店买的书。这', FALSE, 3)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('88e64405-d84f-52cb-9b22-2d3c61da0375'::UUID, 'be9183dc-ddf6-5fde-9e6a-2708fc78cf0f'::UUID, 'speaking', 8, 'Đọc thành tiếng: 这是我昨天在书店买的书。', NULL, '这是我昨天在书店买的书。', 'Đọc chậm, giữ đúng thanh điệu và nhịp của cả câu.', NULL, 1, '{"activity_type":"pronunciation","text":"这是我昨天在书店买的书。","pinyin":"Zhè shì wǒ zuótiān zài shūdiàn mǎi de shū."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.units (id, course_id, slug, title, description, order_index, status, learning_objectives, content_version)
VALUES ('fd0ddcb0-ea4b-5a03-8df7-59361e6581ff'::UUID, '255b8c5e-b8e8-5c7d-ba59-2e4046a33497'::UUID, 'grammar-van-dung', 'Vận dụng', 'Vận dụng mẫu câu trong ngữ cảnh có ý nghĩa.', 2, 'review', '["Chọn cấu trúc theo ý nghĩa","Sửa lỗi trật tự và liên kết"]'::JSONB, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.chapters (id, unit_id, slug, title, description, order_index, status, learning_objectives, content_version)
VALUES ('5a01d086-0a35-5fae-851f-8c7a7d410dc2'::UUID, 'fd0ddcb0-ea4b-5a03-8df7-59361e6581ff'::UUID, 'grammar-van-dung-chapter', 'Ngữ cảnh thực tế', 'Vận dụng mẫu câu trong ngữ cảnh có ý nghĩa.', 1, 'review', '["Chọn cấu trúc theo ý nghĩa","Sửa lỗi trật tự và liên kết"]'::JSONB, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lessons (id, chapter_id, slug, title, description, order_index, xp_reward, status, lesson_type, estimated_minutes, learning_objectives, cultural_note, content_version)
VALUES ('23142d23-d8cb-5d6f-80b7-0a492a9aaeed'::UUID, '5a01d086-0a35-5fae-851f-8c7a7d410dc2'::UUID, 'bo-ngu', '补语系统 — Hệ thống bổ ngữ', 'Phân biệt bổ ngữ kết quả, xu hướng và khả năng.', 1, 25, 'review', 'standard', 15, '["Chọn bổ ngữ theo mục đích diễn đạt"]'::JSONB, 'Không nhầm 看不懂 với 没看懂: một bên là khả năng, một bên là kết quả quá khứ.', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('4288939e-725f-5653-a05c-58006f6d0eb5'::UUID, 'grammar:补语', '补语', 'bǔyǔ', 'bổ ngữ', 'complement', 'upper-intermediate', 'bo-ngu', 'danh từ', '补语说明动作的结果或程度。', 'Bǔyǔ shuōmíng dòngzuò de jiéguǒ huò chéngdù.', 'Bổ ngữ giải thích kết quả hoặc mức độ của hành động.', NULL, 'review', '23142d23-d8cb-5d6f-80b7-0a492a9aaeed'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('3123794c-d9a5-579b-8b79-c297377ff0c6'::UUID, '23142d23-d8cb-5d6f-80b7-0a492a9aaeed'::UUID, '4288939e-725f-5653-a05c-58006f6d0eb5'::UUID, 1, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('102352ce-44c4-5fb9-a2ff-19e64e996e4f'::UUID, 'grammar:程度', '程度', 'chéngdù', 'mức độ', 'degree', 'upper-intermediate', 'bo-ngu', 'danh từ', '这个副词表示程度很高。', 'Zhège fùcí biǎoshì chéngdù hěn gāo.', 'Phó từ này biểu thị mức độ rất cao.', NULL, 'review', '23142d23-d8cb-5d6f-80b7-0a492a9aaeed'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('e9116732-6677-5cf6-99de-c60daf1ee8a5'::UUID, '23142d23-d8cb-5d6f-80b7-0a492a9aaeed'::UUID, '102352ce-44c4-5fb9-a2ff-19e64e996e4f'::UUID, 2, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('67fa3988-a543-545f-9c42-1d777c2b5055'::UUID, 'grammar:可能', '可能', 'kěnéng', 'khả năng; có thể', 'possibility; possible', 'upper-intermediate', 'bo-ngu', 'danh từ/tính từ', '这种情况完全可能发生。', 'Zhè zhǒng qíngkuàng wánquán kěnéng fāshēng.', 'Tình huống này hoàn toàn có thể xảy ra.', NULL, 'review', '23142d23-d8cb-5d6f-80b7-0a492a9aaeed'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('821dcefd-aac7-52cb-8baf-156cdb33aa9d'::UUID, '23142d23-d8cb-5d6f-80b7-0a492a9aaeed'::UUID, '67fa3988-a543-545f-9c42-1d777c2b5055'::UUID, 3, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('bfcdba05-06cb-5988-8b32-15de1d7042be'::UUID, '23142d23-d8cb-5d6f-80b7-0a492a9aaeed'::UUID, 'cb5f0a6d-9b3a-5cad-b6cc-730fdf1f44c1'::UUID, 4, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('936b97cd-a72f-540b-8d50-daf853598c21'::UUID, '23142d23-d8cb-5d6f-80b7-0a492a9aaeed'::UUID, '252819ed-0267-520f-a6e0-6500f948bd86'::UUID, 5, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('9f3376cd-8bc9-5879-a9b2-2cc78483a306'::UUID, '23142d23-d8cb-5d6f-80b7-0a492a9aaeed'::UUID, 'e1093a85-a333-5e9e-9974-76a621c8076c'::UUID, 6, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.grammar_lessons (id, content_key, title, pattern, explanation, example_chinese, example_pinyin, example_meaning, level, status, usage_note, content_version)
VALUES ('652ab026-c9e1-5043-933f-2567b598ca22'::UUID, 'grammar:bo-ngu', 'Bổ ngữ khả năng', 'động từ + 得/不 + bổ ngữ kết quả', '得 cho biết có khả năng đạt kết quả; 不 cho biết không thể.', '这篇文章我看得懂。', 'Zhè piān wénzhāng wǒ kàn de dǒng.', 'Bài này tôi đọc hiểu được.', 'upper-intermediate', 'review', NULL, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_grammar (id, lesson_id, grammar_lesson_id, order_index, curriculum_role)
VALUES ('95fb2a9c-09fa-5708-a11c-98e9034b307e'::UUID, '23142d23-d8cb-5d6f-80b7-0a492a9aaeed'::UUID, '652ab026-c9e1-5043-933f-2567b598ca22'::UUID, 1, 'introduced')
ON CONFLICT (lesson_id, grammar_lesson_id) DO NOTHING;

INSERT INTO public.lesson_grammar (id, lesson_id, grammar_lesson_id, order_index, curriculum_role)
VALUES ('de9cc8f0-100a-5db0-9e9a-8c748ad4773a'::UUID, '23142d23-d8cb-5d6f-80b7-0a492a9aaeed'::UUID, 'cfc01873-6041-5109-b3c4-4065082c0086'::UUID, 2, 'review')
ON CONFLICT (lesson_id, grammar_lesson_id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('0e3b7f50-d5b2-56db-a6dd-73eeb511a080'::UUID, '23142d23-d8cb-5d6f-80b7-0a492a9aaeed'::UUID, 'vocabulary', 1, 'Từ mới: 补语', NULL, '补语', '补语 (bǔyǔ) — bổ ngữ. 补语说明动作的结果或程度。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"grammar:补语","chinese":"补语","pinyin":"bǔyǔ","meaning":"bổ ngữ","part_of_speech":"danh từ","example_chinese":"补语说明动作的结果或程度。","example_pinyin":"Bǔyǔ shuōmíng dòngzuò de jiéguǒ huò chéngdù.","example_meaning_vi":"Bổ ngữ giải thích kết quả hoặc mức độ của hành động."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('5f424902-b3d6-53cb-8503-077291b3d9ff'::UUID, '23142d23-d8cb-5d6f-80b7-0a492a9aaeed'::UUID, 'vocabulary', 2, 'Từ mới: 程度', NULL, '程度', '程度 (chéngdù) — mức độ. 这个副词表示程度很高。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"grammar:程度","chinese":"程度","pinyin":"chéngdù","meaning":"mức độ","part_of_speech":"danh từ","example_chinese":"这个副词表示程度很高。","example_pinyin":"Zhège fùcí biǎoshì chéngdù hěn gāo.","example_meaning_vi":"Phó từ này biểu thị mức độ rất cao."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('a43ef554-d522-5604-97e9-7fc0a6627e9c'::UUID, '23142d23-d8cb-5d6f-80b7-0a492a9aaeed'::UUID, 'vocabulary', 3, 'Từ mới: 可能', NULL, '可能', '可能 (kěnéng) — khả năng; có thể. 这种情况完全可能发生。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"grammar:可能","chinese":"可能","pinyin":"kěnéng","meaning":"khả năng; có thể","part_of_speech":"danh từ/tính từ","example_chinese":"这种情况完全可能发生。","example_pinyin":"Zhè zhǒng qíngkuàng wánquán kěnéng fāshēng.","example_meaning_vi":"Tình huống này hoàn toàn có thể xảy ra."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('a02cb8ac-cc1c-5257-b35f-8b424c7424e2'::UUID, '23142d23-d8cb-5d6f-80b7-0a492a9aaeed'::UUID, 'multiple_choice', 4, '“补语” có nghĩa phù hợp nhất là gì?', NULL, 'bổ ngữ', '补语 (bǔyǔ) nghĩa là “bổ ngữ”.', NULL, 1, '{"activity_type":"chinese_to_vietnamese","vocabulary_key":"grammar:补语"}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('bc2b75c3-8302-5536-a921-de52b5a2c580'::UUID, 'a02cb8ac-cc1c-5257-b35f-8b424c7424e2'::UUID, 'bổ ngữ', TRUE, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('62f19cfe-226f-587a-9731-3101b3787e99'::UUID, 'a02cb8ac-cc1c-5257-b35f-8b424c7424e2'::UUID, 'mức độ', FALSE, 2)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('f28c7a22-247f-51a2-b5a7-5273e1a26f49'::UUID, 'a02cb8ac-cc1c-5257-b35f-8b424c7424e2'::UUID, 'khả năng; có thể', FALSE, 3)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('eee224fd-db9c-5b3b-b5fe-35faddce3cd6'::UUID, '23142d23-d8cb-5d6f-80b7-0a492a9aaeed'::UUID, 'translation', 5, 'Dịch sang tiếng Trung: “Bài này tôi đọc hiểu được.”', NULL, '这篇文章我看得懂。', 'Mẫu câu dùng “补语” trong ngữ cảnh của bài.', 'bǔyǔ', 1, '{"activity_type":"vietnamese_to_chinese","source_lang":"vi","target_lang":"zh","acceptable_answers":["这篇文章我看得懂。"]}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('420b56ae-e0a0-50f8-a541-1dc0aa7078e2'::UUID, '23142d23-d8cb-5d6f-80b7-0a492a9aaeed'::UUID, 'sentence_builder', 6, 'Sắp xếp các thành phần thành câu đúng.', NULL, '这篇文章我看得懂。', 'Trật tự đúng tạo thành câu “这篇文章我看得懂。”.', NULL, 1, '{"activity_type":"sentence_ordering","words":["这","篇","文章","我","看","得","懂","。"],"correct_order":["这","篇","文章","我","看","得","懂","。"]}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('b1e68ac5-5eb6-5a1c-87d2-4119a6d82894'::UUID, '23142d23-d8cb-5d6f-80b7-0a492a9aaeed'::UUID, 'multiple_choice', 7, 'Câu nào dùng bổ ngữ khả năng?', NULL, '这篇文章我看得懂。', '得 cho biết có khả năng đạt kết quả; 不 cho biết không thể.', NULL, 1, '{"activity_type":"grammar_selection","passage":null,"grammar_key":"grammar:bo-ngu"}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('47466d88-f835-59bb-8e76-c320ba1400c9'::UUID, 'b1e68ac5-5eb6-5a1c-87d2-4119a6d82894'::UUID, '这篇文章我看得懂。', TRUE, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('cc58b507-bb7e-5f8d-8900-04c2175e9d4c'::UUID, 'b1e68ac5-5eb6-5a1c-87d2-4119a6d82894'::UUID, '。懂得看我文章篇这', FALSE, 2)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('387a7789-4c65-5c48-a4a0-072cda501bc7'::UUID, 'b1e68ac5-5eb6-5a1c-87d2-4119a6d82894'::UUID, '篇文章我看得懂。这', FALSE, 3)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('eacb1645-4700-57a3-9421-efc726c11c86'::UUID, '23142d23-d8cb-5d6f-80b7-0a492a9aaeed'::UUID, 'speaking', 8, 'Đọc thành tiếng: 这篇文章我看得懂。', NULL, '这篇文章我看得懂。', 'Đọc chậm, giữ đúng thanh điệu và nhịp của cả câu.', NULL, 1, '{"activity_type":"pronunciation","text":"这篇文章我看得懂。","pinyin":"Zhè piān wénzhāng wǒ kàn de dǒng."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lessons (id, chapter_id, slug, title, description, order_index, xp_reward, status, lesson_type, estimated_minutes, learning_objectives, cultural_note, content_version)
VALUES ('a194987f-9e28-5eb5-975f-d933fc1a5ffe'::UUID, '5a01d086-0a35-5fae-851f-8c7a7d410dc2'::UUID, 'lien-ket', '复句关系 — Quan hệ câu phức', 'Chọn cặp liên từ theo logic.', 2, 25, 'review', 'standard', 15, '["Kết nối mệnh đề mạch lạc"]'::JSONB, 'Hai vế nên cùng một chủ đề hoặc đặt chủ ngữ đúng vị trí.', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('dd578726-4ca3-592b-92f9-2a529fcabab7'::UUID, 'grammar:转折', '转折', 'zhuǎnzhé', 'chuyển ý, tương phản', 'contrast', 'upper-intermediate', 'lien-ket', 'danh từ', '这两个分句之间是转折关系。', 'Zhè liǎng ge fēnjù zhījiān shì zhuǎnzhé guānxì.', 'Giữa hai mệnh đề là quan hệ tương phản.', NULL, 'review', 'a194987f-9e28-5eb5-975f-d933fc1a5ffe'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('27b13973-5feb-5440-ada3-8ba0f0c2146f'::UUID, 'a194987f-9e28-5eb5-975f-d933fc1a5ffe'::UUID, 'dd578726-4ca3-592b-92f9-2a529fcabab7'::UUID, 1, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('e06ee525-acf0-50c5-bf5e-87c2268b7049'::UUID, 'grammar:递进', '递进', 'dìjìn', 'tăng tiến', 'progression', 'upper-intermediate', 'lien-ket', 'danh từ', '“不但…而且…”表示递进。', '“Búdàn… érqiě…” biǎoshì dìjìn.', '“Không những… mà còn…” biểu thị tăng tiến.', NULL, 'review', 'a194987f-9e28-5eb5-975f-d933fc1a5ffe'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('b8a192ec-2479-5e72-81d2-83fdca468a56'::UUID, 'a194987f-9e28-5eb5-975f-d933fc1a5ffe'::UUID, 'e06ee525-acf0-50c5-bf5e-87c2268b7049'::UUID, 2, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('363e5596-e45c-5ecf-a428-160a4d11ce1b'::UUID, 'grammar:假设', '假设', 'jiǎshè', 'giả thiết', 'hypothesis', 'upper-intermediate', 'lien-ket', 'danh từ', '“如果”常用来提出假设。', '“Rúguǒ” cháng yònglái tíchū jiǎshè.', '“Nếu” thường dùng để nêu giả thiết.', NULL, 'review', 'a194987f-9e28-5eb5-975f-d933fc1a5ffe'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('0800aecf-ed5d-5587-923d-ef5978a847a7'::UUID, 'a194987f-9e28-5eb5-975f-d933fc1a5ffe'::UUID, '363e5596-e45c-5ecf-a428-160a4d11ce1b'::UUID, 3, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('6bb30339-cc28-5eaa-961d-52f3ea9980b8'::UUID, 'a194987f-9e28-5eb5-975f-d933fc1a5ffe'::UUID, '4288939e-725f-5653-a05c-58006f6d0eb5'::UUID, 4, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('81a50cd1-8f02-5648-af60-c8eac3058ada'::UUID, 'a194987f-9e28-5eb5-975f-d933fc1a5ffe'::UUID, '102352ce-44c4-5fb9-a2ff-19e64e996e4f'::UUID, 5, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('ae9cfeab-7ac6-5b2f-8255-cadad7cc2cfc'::UUID, 'a194987f-9e28-5eb5-975f-d933fc1a5ffe'::UUID, '67fa3988-a543-545f-9c42-1d777c2b5055'::UUID, 6, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.grammar_lessons (id, content_key, title, pattern, explanation, example_chinese, example_pinyin, example_meaning, level, status, usage_note, content_version)
VALUES ('755d1c31-a457-5be9-8164-148f016a343e'::UUID, 'grammar:lien-ket', 'Tăng tiến với 不但', '不但 A，而且 B', 'Vế B bổ sung thông tin mạnh hơn hoặc quan trọng hơn A.', '这个方法不但简单，而且有效。', 'Zhège fāngfǎ búdàn jiǎndān, érqiě yǒuxiào.', 'Phương pháp này không những đơn giản mà còn hiệu quả.', 'upper-intermediate', 'review', NULL, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_grammar (id, lesson_id, grammar_lesson_id, order_index, curriculum_role)
VALUES ('519c6425-2700-5841-8568-2fcc0237d916'::UUID, 'a194987f-9e28-5eb5-975f-d933fc1a5ffe'::UUID, '755d1c31-a457-5be9-8164-148f016a343e'::UUID, 1, 'introduced')
ON CONFLICT (lesson_id, grammar_lesson_id) DO NOTHING;

INSERT INTO public.lesson_grammar (id, lesson_id, grammar_lesson_id, order_index, curriculum_role)
VALUES ('b2414691-f464-59d6-a120-9e3eef261902'::UUID, 'a194987f-9e28-5eb5-975f-d933fc1a5ffe'::UUID, '652ab026-c9e1-5043-933f-2567b598ca22'::UUID, 2, 'review')
ON CONFLICT (lesson_id, grammar_lesson_id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('55f6b962-af92-59b0-998e-760e0a9063f7'::UUID, 'a194987f-9e28-5eb5-975f-d933fc1a5ffe'::UUID, 'vocabulary', 1, 'Từ mới: 转折', NULL, '转折', '转折 (zhuǎnzhé) — chuyển ý, tương phản. 这两个分句之间是转折关系。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"grammar:转折","chinese":"转折","pinyin":"zhuǎnzhé","meaning":"chuyển ý, tương phản","part_of_speech":"danh từ","example_chinese":"这两个分句之间是转折关系。","example_pinyin":"Zhè liǎng ge fēnjù zhījiān shì zhuǎnzhé guānxì.","example_meaning_vi":"Giữa hai mệnh đề là quan hệ tương phản."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('0ad53408-d914-5c5d-bcb7-db702f1a24e3'::UUID, 'a194987f-9e28-5eb5-975f-d933fc1a5ffe'::UUID, 'vocabulary', 2, 'Từ mới: 递进', NULL, '递进', '递进 (dìjìn) — tăng tiến. “不但…而且…”表示递进。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"grammar:递进","chinese":"递进","pinyin":"dìjìn","meaning":"tăng tiến","part_of_speech":"danh từ","example_chinese":"“不但…而且…”表示递进。","example_pinyin":"“Búdàn… érqiě…” biǎoshì dìjìn.","example_meaning_vi":"“Không những… mà còn…” biểu thị tăng tiến."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('f24d9c06-6028-5855-b721-9fb95d13fac2'::UUID, 'a194987f-9e28-5eb5-975f-d933fc1a5ffe'::UUID, 'vocabulary', 3, 'Từ mới: 假设', NULL, '假设', '假设 (jiǎshè) — giả thiết. “如果”常用来提出假设。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"grammar:假设","chinese":"假设","pinyin":"jiǎshè","meaning":"giả thiết","part_of_speech":"danh từ","example_chinese":"“如果”常用来提出假设。","example_pinyin":"“Rúguǒ” cháng yònglái tíchū jiǎshè.","example_meaning_vi":"“Nếu” thường dùng để nêu giả thiết."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('36f79619-834b-5313-85eb-8dc974effefd'::UUID, 'a194987f-9e28-5eb5-975f-d933fc1a5ffe'::UUID, 'multiple_choice', 4, '“转折” có nghĩa phù hợp nhất là gì?', NULL, 'chuyển ý, tương phản', '转折 (zhuǎnzhé) nghĩa là “chuyển ý, tương phản”.', NULL, 1, '{"activity_type":"chinese_to_vietnamese","vocabulary_key":"grammar:转折"}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('1865aa9c-0618-569b-83ba-fbb91ac4c67e'::UUID, '36f79619-834b-5313-85eb-8dc974effefd'::UUID, 'chuyển ý, tương phản', TRUE, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('84c11ca5-4fad-5d5d-8d7b-78c319f8d208'::UUID, '36f79619-834b-5313-85eb-8dc974effefd'::UUID, 'tăng tiến', FALSE, 2)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('8f77ed89-9302-559b-abd3-f80826730f74'::UUID, '36f79619-834b-5313-85eb-8dc974effefd'::UUID, 'giả thiết', FALSE, 3)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('fc96ccf8-4a0b-5789-b94c-7ab3e050427e'::UUID, 'a194987f-9e28-5eb5-975f-d933fc1a5ffe'::UUID, 'translation', 5, 'Dịch sang tiếng Trung: “Phương pháp này không những đơn giản mà còn hiệu quả.”', NULL, '这个方法不但简单，而且有效。', 'Mẫu câu dùng “转折” trong ngữ cảnh của bài.', 'zhuǎnzhé', 1, '{"activity_type":"vietnamese_to_chinese","source_lang":"vi","target_lang":"zh","acceptable_answers":["这个方法不但简单，而且有效。"]}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('c6cb339d-791a-587c-9486-c7ce411f11dd'::UUID, 'a194987f-9e28-5eb5-975f-d933fc1a5ffe'::UUID, 'sentence_builder', 6, 'Sắp xếp các thành phần thành câu đúng.', NULL, '这个方法不但简单，而且有效。', 'Trật tự đúng tạo thành câu “这个方法不但简单，而且有效。”.', NULL, 1, '{"activity_type":"sentence_ordering","words":["这个","方法","不但","简单","，","而且","有效","。"],"correct_order":["这个","方法","不但","简单","，","而且","有效","。"]}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('ea6d9a18-1835-5322-ada9-aa7919af2a86'::UUID, 'a194987f-9e28-5eb5-975f-d933fc1a5ffe'::UUID, 'multiple_choice', 7, 'Câu nào có quan hệ tăng tiến?', NULL, '这个方法不但简单，而且有效。', 'Vế B bổ sung thông tin mạnh hơn hoặc quan trọng hơn A.', NULL, 1, '{"activity_type":"grammar_selection","passage":null,"grammar_key":"grammar:lien-ket"}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('edaddca1-62c7-55b0-aaea-534961f82e07'::UUID, 'ea6d9a18-1835-5322-ada9-aa7919af2a86'::UUID, '这个方法不但简单，而且有效。', TRUE, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('e3d80eaa-02fe-5b06-9479-541b3cdfc37c'::UUID, 'ea6d9a18-1835-5322-ada9-aa7919af2a86'::UUID, '。有效而且，简单不但方法这个', FALSE, 2)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('73000fe0-d721-5e50-a530-2283bf7dcac8'::UUID, 'ea6d9a18-1835-5322-ada9-aa7919af2a86'::UUID, '方法不但简单，而且有效。这个', FALSE, 3)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('7785b344-869d-5f95-b8ac-7a8a1e387c12'::UUID, 'a194987f-9e28-5eb5-975f-d933fc1a5ffe'::UUID, 'speaking', 8, 'Đọc thành tiếng: 这个方法不但简单，而且有效。', NULL, '这个方法不但简单，而且有效。', 'Đọc chậm, giữ đúng thanh điệu và nhịp của cả câu.', NULL, 1, '{"activity_type":"pronunciation","text":"这个方法不但简单，而且有效。","pinyin":"Zhège fāngfǎ búdàn jiǎndān, érqiě yǒuxiào."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.units (id, course_id, slug, title, description, order_index, status, learning_objectives, content_version)
VALUES ('2c47c7c1-3fa4-5351-a356-2147dedbb6e4'::UUID, '255b8c5e-b8e8-5c7d-ba59-2e4046a33497'::UUID, 'grammar-on-tap', 'Ôn tập', 'Kiểm tra và củng cố nội dung đã học.', 3, 'review', '["Ôn từ vựng","Ôn mẫu câu"]'::JSONB, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.chapters (id, unit_id, slug, title, description, order_index, status, learning_objectives, content_version)
VALUES ('10e50730-592f-5567-a128-0a4da8c00876'::UUID, '2c47c7c1-3fa4-5351-a356-2147dedbb6e4'::UUID, 'grammar-on-tap-chapter', 'Củng cố lộ trình', 'Kiểm tra và củng cố nội dung đã học.', 1, 'review', '["Ôn từ vựng","Ôn mẫu câu"]'::JSONB, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lessons (id, chapter_id, slug, title, description, order_index, xp_reward, status, lesson_type, estimated_minutes, learning_objectives, cultural_note, content_version)
VALUES ('1cbc847e-71b1-5362-a21b-69589857100a'::UUID, '10e50730-592f-5567-a128-0a4da8c00876'::UUID, 'grammar-review', 'Ôn tập Chinese Grammar', 'Củng cố từ vựng, mẫu câu và khả năng diễn đạt của toàn khóa.', 1, 30, 'review', 'review', 18, '["Vận dụng lại từ vựng trọng tâm","Tự kiểm tra mẫu câu đã học"]'::JSONB, NULL, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('8065e25c-777e-5ddc-b624-423c2651cf10'::UUID, '1cbc847e-71b1-5362-a21b-69589857100a'::UUID, 'dd578726-4ca3-592b-92f9-2a529fcabab7'::UUID, 1, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('df888d70-57d7-523a-a471-a691bcd01002'::UUID, '1cbc847e-71b1-5362-a21b-69589857100a'::UUID, 'e06ee525-acf0-50c5-bf5e-87c2268b7049'::UUID, 2, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('b5049523-6b77-5389-802a-c1a144d3a5a9'::UUID, '1cbc847e-71b1-5362-a21b-69589857100a'::UUID, '363e5596-e45c-5ecf-a428-160a4d11ce1b'::UUID, 3, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_grammar (id, lesson_id, grammar_lesson_id, order_index, curriculum_role)
VALUES ('fa65ddcb-a867-55c3-aae9-b93c4f204f36'::UUID, '1cbc847e-71b1-5362-a21b-69589857100a'::UUID, '755d1c31-a457-5be9-8164-148f016a343e'::UUID, 1, 'review')
ON CONFLICT (lesson_id, grammar_lesson_id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('e2242ea4-6ad2-5bb1-b196-d1c27a01bac6'::UUID, '1cbc847e-71b1-5362-a21b-69589857100a'::UUID, 'multiple_choice', 1, '“转折” có nghĩa phù hợp nhất là gì?', NULL, 'chuyển ý, tương phản', '转折 (zhuǎnzhé) nghĩa là “chuyển ý, tương phản”.', NULL, 1, '{"activity_type":"chinese_to_vietnamese","vocabulary_key":"grammar:转折"}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('e2237658-a5e8-59f2-a20c-4f20cbeb6a08'::UUID, 'e2242ea4-6ad2-5bb1-b196-d1c27a01bac6'::UUID, 'giả thiết', FALSE, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('83fc7e37-a0da-50bf-a60f-f1c30a416b36'::UUID, 'e2242ea4-6ad2-5bb1-b196-d1c27a01bac6'::UUID, 'chuyển ý, tương phản', TRUE, 2)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('297f1fcf-29cd-5a0a-8d45-c8c6534a8260'::UUID, 'e2242ea4-6ad2-5bb1-b196-d1c27a01bac6'::UUID, 'tăng tiến', FALSE, 3)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('17cdccbd-c8d0-5232-88cf-1969ab7cbb45'::UUID, '1cbc847e-71b1-5362-a21b-69589857100a'::UUID, 'translation', 2, 'Dịch sang tiếng Trung: “Phương pháp này không những đơn giản mà còn hiệu quả.”', NULL, '这个方法不但简单，而且有效。', 'Mẫu câu dùng “转折” trong ngữ cảnh của bài.', 'zhuǎnzhé', 1, '{"activity_type":"vietnamese_to_chinese","source_lang":"vi","target_lang":"zh","acceptable_answers":["这个方法不但简单，而且有效。"]}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('11f5f143-a1a8-52ea-a8c2-8f2b0748ba41'::UUID, '1cbc847e-71b1-5362-a21b-69589857100a'::UUID, 'sentence_builder', 3, 'Sắp xếp các thành phần thành câu đúng.', NULL, '这个方法不但简单，而且有效。', 'Trật tự đúng tạo thành câu “这个方法不但简单，而且有效。”.', NULL, 1, '{"activity_type":"sentence_ordering","words":["这个","方法","不但","简单","，","而且","有效","。"],"correct_order":["这个","方法","不但","简单","，","而且","有效","。"]}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('08e0e7aa-20ec-5e2e-8d17-b69693fb5193'::UUID, '1cbc847e-71b1-5362-a21b-69589857100a'::UUID, 'multiple_choice', 4, 'Câu nào có quan hệ tăng tiến?', NULL, '这个方法不但简单，而且有效。', 'Vế B bổ sung thông tin mạnh hơn hoặc quan trọng hơn A.', NULL, 1, '{"activity_type":"grammar_selection","passage":null,"grammar_key":"grammar:lien-ket"}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('b2c60458-991e-51c7-98f3-4faf01b68399'::UUID, '08e0e7aa-20ec-5e2e-8d17-b69693fb5193'::UUID, '这个方法不但简单，而且有效。', TRUE, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('b2cdd0c9-2dc6-5353-a84e-f676a98805fd'::UUID, '08e0e7aa-20ec-5e2e-8d17-b69693fb5193'::UUID, '。有效而且，简单不但方法这个', FALSE, 2)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('e434f4d2-97f6-5cfa-86b1-bf0128cb8cb8'::UUID, '08e0e7aa-20ec-5e2e-8d17-b69693fb5193'::UUID, '方法不但简单，而且有效。这个', FALSE, 3)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('d978a759-0d45-5406-9b7c-ab0a64f0dbc2'::UUID, '1cbc847e-71b1-5362-a21b-69589857100a'::UUID, 'speaking', 5, 'Đọc thành tiếng: 这个方法不但简单，而且有效。', NULL, '这个方法不但简单，而且有效。', 'Đọc chậm, giữ đúng thanh điệu và nhịp của cả câu.', NULL, 1, '{"activity_type":"pronunciation","text":"这个方法不但简单，而且有效。","pinyin":"Zhège fāngfǎ búdàn jiǎndān, érqiě yǒuxiào."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.content_batches (id, batch_key, version, migration_name, manifest_checksum, expected_counts)
VALUES ('e7ff1978-3caa-54a3-8fc4-f6c0a3e0586d'::UUID, 'batch-11-grammar', 1, '20260729200000_content_batch_11_grammar', '82c564db58db57c0cb05703fb62e375d4bff02047cb821e1bdd004b315977136', '{"courses":1,"units":3,"chapters":3,"lessons":5,"vocabulary":12,"grammar":4,"characters":0,"exercises":37,"options":30}'::JSONB)
ON CONFLICT (batch_key, version) DO NOTHING;

DO $content_validation$
BEGIN
  IF (SELECT COUNT(*) FROM public.courses WHERE id = ANY(ARRAY['255b8c5e-b8e8-5c7d-ba59-2e4046a33497'::UUID]::UUID[])) <> 1 THEN
    RAISE EXCEPTION 'Content batch batch-11-grammar is missing managed courses rows';
  END IF;
  IF (SELECT COUNT(*) FROM public.units WHERE id = ANY(ARRAY['24bcfe6b-5c23-5348-a9ee-00e81609d6c7'::UUID, 'fd0ddcb0-ea4b-5a03-8df7-59361e6581ff'::UUID, '2c47c7c1-3fa4-5351-a356-2147dedbb6e4'::UUID]::UUID[])) <> 3 THEN
    RAISE EXCEPTION 'Content batch batch-11-grammar is missing managed units rows';
  END IF;
  IF (SELECT COUNT(*) FROM public.chapters WHERE id = ANY(ARRAY['6912ef97-3dcc-5b05-9e6b-663e678c245b'::UUID, '5a01d086-0a35-5fae-851f-8c7a7d410dc2'::UUID, '10e50730-592f-5567-a128-0a4da8c00876'::UUID]::UUID[])) <> 3 THEN
    RAISE EXCEPTION 'Content batch batch-11-grammar is missing managed chapters rows';
  END IF;
  IF (SELECT COUNT(*) FROM public.lessons WHERE id = ANY(ARRAY['c283fa88-481f-505a-8d25-c6861e2f7d2a'::UUID, 'be9183dc-ddf6-5fde-9e6a-2708fc78cf0f'::UUID, '23142d23-d8cb-5d6f-80b7-0a492a9aaeed'::UUID, 'a194987f-9e28-5eb5-975f-d933fc1a5ffe'::UUID, '1cbc847e-71b1-5362-a21b-69589857100a'::UUID]::UUID[])) <> 5 THEN
    RAISE EXCEPTION 'Content batch batch-11-grammar is missing managed lessons rows';
  END IF;
  IF (SELECT COUNT(*) FROM public.vocabulary WHERE id = ANY(ARRAY['bfcc31b5-7452-5837-a4ad-51c4d64b105c'::UUID, '739f8096-eef7-5d39-bf55-eef1322cee45'::UUID, '948e642b-21f0-5cef-aa72-bce43ab76992'::UUID, 'cb5f0a6d-9b3a-5cad-b6cc-730fdf1f44c1'::UUID, '252819ed-0267-520f-a6e0-6500f948bd86'::UUID, 'e1093a85-a333-5e9e-9974-76a621c8076c'::UUID, '4288939e-725f-5653-a05c-58006f6d0eb5'::UUID, '102352ce-44c4-5fb9-a2ff-19e64e996e4f'::UUID, '67fa3988-a543-545f-9c42-1d777c2b5055'::UUID, 'dd578726-4ca3-592b-92f9-2a529fcabab7'::UUID, 'e06ee525-acf0-50c5-bf5e-87c2268b7049'::UUID, '363e5596-e45c-5ecf-a428-160a4d11ce1b'::UUID]::UUID[])) <> 12 THEN
    RAISE EXCEPTION 'Content batch batch-11-grammar is missing managed vocabulary rows';
  END IF;
  IF (SELECT COUNT(*) FROM public.grammar_lessons WHERE id = ANY(ARRAY['1d3cf518-f976-56e4-a2c9-1d09e6913d5f'::UUID, 'cfc01873-6041-5109-b3c4-4065082c0086'::UUID, '652ab026-c9e1-5043-933f-2567b598ca22'::UUID, '755d1c31-a457-5be9-8164-148f016a343e'::UUID]::UUID[])) <> 4 THEN
    RAISE EXCEPTION 'Content batch batch-11-grammar is missing managed grammar_lessons rows';
  END IF;
  IF (SELECT COUNT(*) FROM public.exercises WHERE id = ANY(ARRAY['70e0042c-c45d-5e94-a2ae-e3d9be9ce9be'::UUID, '19a949fc-0888-5c6c-8ba8-374dcded9812'::UUID, '02ca4cca-2591-5470-8dd1-fe8117ef9cb4'::UUID, '98df7e38-c821-5e91-8597-fd54590648d7'::UUID, '7fcda631-038c-5ff2-9108-bb4f25798bd0'::UUID, '7348d3be-95ac-536c-aa35-c8311e044e79'::UUID, '6d32f1ec-d80e-5772-9d5b-42c6643f7d7d'::UUID, '4fc85b8d-f9be-51d9-b9be-9a06591316f8'::UUID, '85cd124a-f2ad-503d-80f7-223c9d061156'::UUID, '1f59ddd6-297a-500b-b192-6ff70d87d481'::UUID, '11508d7f-5a0f-51e7-a2b9-2913917ec030'::UUID, '7c3cecec-1ba5-525d-b47e-d672709b1764'::UUID, 'ce70395a-3972-52b2-a000-a097d1cc5c3c'::UUID, '3b5f3f16-65a3-55fb-9e44-13503aea49b5'::UUID, '0aa28b9b-9b47-512a-9efa-bce9704f6834'::UUID, '88e64405-d84f-52cb-9b22-2d3c61da0375'::UUID, '0e3b7f50-d5b2-56db-a6dd-73eeb511a080'::UUID, '5f424902-b3d6-53cb-8503-077291b3d9ff'::UUID, 'a43ef554-d522-5604-97e9-7fc0a6627e9c'::UUID, 'a02cb8ac-cc1c-5257-b35f-8b424c7424e2'::UUID, 'eee224fd-db9c-5b3b-b5fe-35faddce3cd6'::UUID, '420b56ae-e0a0-50f8-a541-1dc0aa7078e2'::UUID, 'b1e68ac5-5eb6-5a1c-87d2-4119a6d82894'::UUID, 'eacb1645-4700-57a3-9421-efc726c11c86'::UUID, '55f6b962-af92-59b0-998e-760e0a9063f7'::UUID, '0ad53408-d914-5c5d-bcb7-db702f1a24e3'::UUID, 'f24d9c06-6028-5855-b721-9fb95d13fac2'::UUID, '36f79619-834b-5313-85eb-8dc974effefd'::UUID, 'fc96ccf8-4a0b-5789-b94c-7ab3e050427e'::UUID, 'c6cb339d-791a-587c-9486-c7ce411f11dd'::UUID, 'ea6d9a18-1835-5322-ada9-aa7919af2a86'::UUID, '7785b344-869d-5f95-b8ac-7a8a1e387c12'::UUID, 'e2242ea4-6ad2-5bb1-b196-d1c27a01bac6'::UUID, '17cdccbd-c8d0-5232-88cf-1969ab7cbb45'::UUID, '11f5f143-a1a8-52ea-a8c2-8f2b0748ba41'::UUID, '08e0e7aa-20ec-5e2e-8d17-b69693fb5193'::UUID, 'd978a759-0d45-5406-9b7c-ab0a64f0dbc2'::UUID]::UUID[])) <> 37 THEN
    RAISE EXCEPTION 'Content batch batch-11-grammar is missing managed exercises rows';
  END IF;
  IF (SELECT COUNT(*) FROM public.exercise_options WHERE id = ANY(ARRAY['c06967e0-0773-5a68-9a87-a6bca7aba6ef'::UUID, 'e9ac1243-55e6-52f1-9f39-bf24d69a6e51'::UUID, '5cccb937-854e-5f4d-8b49-3507a0a00b4a'::UUID, '7733a5a1-896b-5c06-b4c6-9b02184097ef'::UUID, '21a6972d-3c55-54a4-b0a1-d6e5489a2735'::UUID, 'd3112a69-c753-5740-b58a-31f7968173c2'::UUID, '2cf0a764-ec58-54d0-a4b2-277301b403a7'::UUID, '5b56210d-bac0-5fe8-93e8-5962ff079f39'::UUID, 'f67ae3cf-d53c-5881-b7b5-9dd993a4799d'::UUID, '6cadab1f-f630-5c7a-ba0b-6f428d92696a'::UUID, '60c8ca0b-9345-57c1-94e7-ca12801c615f'::UUID, 'd39bbdf4-79d6-5a92-8e50-640a2d5077c3'::UUID, 'bc2b75c3-8302-5536-a921-de52b5a2c580'::UUID, '62f19cfe-226f-587a-9731-3101b3787e99'::UUID, 'f28c7a22-247f-51a2-b5a7-5273e1a26f49'::UUID, '47466d88-f835-59bb-8e76-c320ba1400c9'::UUID, 'cc58b507-bb7e-5f8d-8900-04c2175e9d4c'::UUID, '387a7789-4c65-5c48-a4a0-072cda501bc7'::UUID, '1865aa9c-0618-569b-83ba-fbb91ac4c67e'::UUID, '84c11ca5-4fad-5d5d-8d7b-78c319f8d208'::UUID, '8f77ed89-9302-559b-abd3-f80826730f74'::UUID, 'edaddca1-62c7-55b0-aaea-534961f82e07'::UUID, 'e3d80eaa-02fe-5b06-9479-541b3cdfc37c'::UUID, '73000fe0-d721-5e50-a530-2283bf7dcac8'::UUID, 'e2237658-a5e8-59f2-a20c-4f20cbeb6a08'::UUID, '83fc7e37-a0da-50bf-a60f-f1c30a416b36'::UUID, '297f1fcf-29cd-5a0a-8d45-c8c6534a8260'::UUID, 'b2c60458-991e-51c7-98f3-4faf01b68399'::UUID, 'b2cdd0c9-2dc6-5353-a84e-f676a98805fd'::UUID, 'e434f4d2-97f6-5cfa-86b1-bf0128cb8cb8'::UUID]::UUID[])) <> 30 THEN
    RAISE EXCEPTION 'Content batch batch-11-grammar is missing managed exercise_options rows';
  END IF;
  IF EXISTS (
    SELECT 1 FROM public.lessons AS lesson
    WHERE lesson.id = ANY(ARRAY['c283fa88-481f-505a-8d25-c6861e2f7d2a'::UUID, 'be9183dc-ddf6-5fde-9e6a-2708fc78cf0f'::UUID, '23142d23-d8cb-5d6f-80b7-0a492a9aaeed'::UUID, 'a194987f-9e28-5eb5-975f-d933fc1a5ffe'::UUID, '1cbc847e-71b1-5362-a21b-69589857100a'::UUID]::UUID[])
      AND NOT EXISTS (
        SELECT 1 FROM public.exercises AS exercise
        WHERE exercise.lesson_id = lesson.id
      )
  ) THEN
    RAISE EXCEPTION 'Content batch batch-11-grammar contains a lesson without exercises';
  END IF;
  IF EXISTS (
    SELECT 1
    FROM public.lessons AS lesson
    JOIN public.exercises AS exercise ON exercise.lesson_id = lesson.id
    WHERE lesson.id = ANY(ARRAY['c283fa88-481f-505a-8d25-c6861e2f7d2a'::UUID, 'be9183dc-ddf6-5fde-9e6a-2708fc78cf0f'::UUID, '23142d23-d8cb-5d6f-80b7-0a492a9aaeed'::UUID, 'a194987f-9e28-5eb5-975f-d933fc1a5ffe'::UUID, '1cbc847e-71b1-5362-a21b-69589857100a'::UUID]::UUID[])
      AND lesson.status = 'published'
      AND exercise.exercise_type = 'listening'
      AND NULLIF(BTRIM(exercise.question_audio_url), '') IS NULL
  ) THEN
    RAISE EXCEPTION 'Published listening exercise is missing playable audio';
  END IF;
  IF EXISTS (
    SELECT 1
    FROM public.exercises AS exercise
    WHERE exercise.id = ANY(ARRAY['70e0042c-c45d-5e94-a2ae-e3d9be9ce9be'::UUID, '19a949fc-0888-5c6c-8ba8-374dcded9812'::UUID, '02ca4cca-2591-5470-8dd1-fe8117ef9cb4'::UUID, '98df7e38-c821-5e91-8597-fd54590648d7'::UUID, '7fcda631-038c-5ff2-9108-bb4f25798bd0'::UUID, '7348d3be-95ac-536c-aa35-c8311e044e79'::UUID, '6d32f1ec-d80e-5772-9d5b-42c6643f7d7d'::UUID, '4fc85b8d-f9be-51d9-b9be-9a06591316f8'::UUID, '85cd124a-f2ad-503d-80f7-223c9d061156'::UUID, '1f59ddd6-297a-500b-b192-6ff70d87d481'::UUID, '11508d7f-5a0f-51e7-a2b9-2913917ec030'::UUID, '7c3cecec-1ba5-525d-b47e-d672709b1764'::UUID, 'ce70395a-3972-52b2-a000-a097d1cc5c3c'::UUID, '3b5f3f16-65a3-55fb-9e44-13503aea49b5'::UUID, '0aa28b9b-9b47-512a-9efa-bce9704f6834'::UUID, '88e64405-d84f-52cb-9b22-2d3c61da0375'::UUID, '0e3b7f50-d5b2-56db-a6dd-73eeb511a080'::UUID, '5f424902-b3d6-53cb-8503-077291b3d9ff'::UUID, 'a43ef554-d522-5604-97e9-7fc0a6627e9c'::UUID, 'a02cb8ac-cc1c-5257-b35f-8b424c7424e2'::UUID, 'eee224fd-db9c-5b3b-b5fe-35faddce3cd6'::UUID, '420b56ae-e0a0-50f8-a541-1dc0aa7078e2'::UUID, 'b1e68ac5-5eb6-5a1c-87d2-4119a6d82894'::UUID, 'eacb1645-4700-57a3-9421-efc726c11c86'::UUID, '55f6b962-af92-59b0-998e-760e0a9063f7'::UUID, '0ad53408-d914-5c5d-bcb7-db702f1a24e3'::UUID, 'f24d9c06-6028-5855-b721-9fb95d13fac2'::UUID, '36f79619-834b-5313-85eb-8dc974effefd'::UUID, 'fc96ccf8-4a0b-5789-b94c-7ab3e050427e'::UUID, 'c6cb339d-791a-587c-9486-c7ce411f11dd'::UUID, 'ea6d9a18-1835-5322-ada9-aa7919af2a86'::UUID, '7785b344-869d-5f95-b8ac-7a8a1e387c12'::UUID, 'e2242ea4-6ad2-5bb1-b196-d1c27a01bac6'::UUID, '17cdccbd-c8d0-5232-88cf-1969ab7cbb45'::UUID, '11f5f143-a1a8-52ea-a8c2-8f2b0748ba41'::UUID, '08e0e7aa-20ec-5e2e-8d17-b69693fb5193'::UUID, 'd978a759-0d45-5406-9b7c-ab0a64f0dbc2'::UUID]::UUID[])
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
    WHERE link.lesson_id = ANY(ARRAY['c283fa88-481f-505a-8d25-c6861e2f7d2a'::UUID, 'be9183dc-ddf6-5fde-9e6a-2708fc78cf0f'::UUID, '23142d23-d8cb-5d6f-80b7-0a492a9aaeed'::UUID, 'a194987f-9e28-5eb5-975f-d933fc1a5ffe'::UUID, '1cbc847e-71b1-5362-a21b-69589857100a'::UUID]::UUID[])
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
