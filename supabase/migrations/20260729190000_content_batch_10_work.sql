-- Generated from content/manifests/10_work.json.
-- Do not hand-edit this migration; edit the manifest and regenerate.
-- Additive and idempotent: deterministic IDs plus ON CONFLICT DO NOTHING.

BEGIN;

INSERT INTO public.courses (id, slug, title, title_zh, description, level, status, order_index, learning_objectives, estimated_minutes, content_version)
VALUES ('8e73eac6-debe-5f16-95cd-fef89f0e5b42'::UUID, 'chinese-for-work-business', 'Chinese for Work and Business', '商务汉语', 'Giao tiếp công sở, họp, thương lượng và tuyển dụng.', 'intermediate', 'review', 14, '["Trao đổi công việc rõ ràng","Tham gia họp và thương lượng","Dùng văn phong nghề nghiệp phù hợp"]'::JSONB, 78, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.units (id, course_id, slug, title, description, order_index, status, learning_objectives, content_version)
VALUES ('08f25255-1249-50a0-a4f5-4e25e57cd701'::UUID, '8e73eac6-debe-5f16-95cd-fef89f0e5b42'::UUID, 'work-nen-tang', 'Nền tảng', 'Xây dựng ngôn ngữ cốt lõi của lộ trình.', 1, 'review', '["Trao đổi công việc rõ ràng","Tham gia họp và thương lượng"]'::JSONB, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.chapters (id, unit_id, slug, title, description, order_index, status, learning_objectives, content_version)
VALUES ('bcf84665-74ce-5193-a0e6-d80ec8aaadc1'::UUID, '08f25255-1249-50a0-a4f5-4e25e57cd701'::UUID, 'work-nen-tang-chapter', 'Khái niệm cốt lõi', 'Xây dựng ngôn ngữ cốt lõi của lộ trình.', 1, 'review', '["Trao đổi công việc rõ ràng","Tham gia họp và thương lượng"]'::JSONB, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lessons (id, chapter_id, slug, title, description, order_index, xp_reward, status, lesson_type, estimated_minutes, learning_objectives, cultural_note, content_version)
VALUES ('b69bbb7b-52c5-502e-943f-3f51c3611352'::UUID, 'bcf84665-74ce-5193-a0e6-d80ec8aaadc1'::UUID, 'email', '确认邮件 — Email công việc', 'Xác nhận và phản hồi nhiệm vụ.', 1, 25, 'review', 'standard', 15, '["Viết phản hồi ngắn, rõ"]'::JSONB, '是否 phù hợp email; hội thoại thường dùng …吗 hoặc 是不是.', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('769f98bc-221e-5cca-b66a-5481a5b63dd4'::UUID, 'work:附件', '附件', 'fùjiàn', 'tệp đính kèm', 'attachment', 'intermediate', 'email', 'danh từ', '报价单请见邮件附件。', 'Bàojiàdān qǐng jiàn yóujiàn fùjiàn.', 'Xin xem báo giá trong tệp đính kèm email.', NULL, 'review', 'b69bbb7b-52c5-502e-943f-3f51c3611352'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('980741e8-4dbd-5e3e-a310-ce24e02354cf'::UUID, 'b69bbb7b-52c5-502e-943f-3f51c3611352'::UUID, '769f98bc-221e-5cca-b66a-5481a5b63dd4'::UUID, 1, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('a5dae4a3-1c7a-5184-b1dc-16a0a1dc5c7b'::UUID, 'work:确认', '确认', 'quèrèn', 'xác nhận', 'confirm', 'intermediate', 'email', 'động từ', '请确认会议时间是否合适。', 'Qǐng quèrèn huìyì shíjiān shìfǒu héshì.', 'Xin xác nhận thời gian họp có phù hợp không.', NULL, 'review', 'b69bbb7b-52c5-502e-943f-3f51c3611352'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('31662a6a-642a-5bd7-a3ed-72812e931fe8'::UUID, 'b69bbb7b-52c5-502e-943f-3f51c3611352'::UUID, 'a5dae4a3-1c7a-5184-b1dc-16a0a1dc5c7b'::UUID, 2, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('7746c27f-829a-5491-a47c-efe2c24c47df'::UUID, 'work:回复', '回复', 'huífù', 'phản hồi', 'reply', 'intermediate', 'email', 'động từ/danh từ', '我会在今天下班前回复。', 'Wǒ huì zài jīntiān xiàbān qián huífù.', 'Tôi sẽ phản hồi trước khi tan làm hôm nay.', NULL, 'review', 'b69bbb7b-52c5-502e-943f-3f51c3611352'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('91db255a-71c7-5b84-a639-18efa369dfce'::UUID, 'b69bbb7b-52c5-502e-943f-3f51c3611352'::UUID, '7746c27f-829a-5491-a47c-efe2c24c47df'::UUID, 3, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.grammar_lessons (id, content_key, title, pattern, explanation, example_chinese, example_pinyin, example_meaning, level, status, usage_note, content_version)
VALUES ('b373cfa7-87cd-5c8e-a0fb-df468c0567df'::UUID, 'work:email', 'Hỏi xác nhận với 是否', 'động từ + 是否 + tính từ/động từ', '是否 là dạng văn viết, trang trọng hơn “是不是”.', '请确认附件是否完整。', 'Qǐng quèrèn fùjiàn shìfǒu wánzhěng.', 'Xin xác nhận tệp đính kèm có đầy đủ không.', 'intermediate', 'review', NULL, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_grammar (id, lesson_id, grammar_lesson_id, order_index, curriculum_role)
VALUES ('9da8515f-d694-5bca-938e-5e0f28fd9d6b'::UUID, 'b69bbb7b-52c5-502e-943f-3f51c3611352'::UUID, 'b373cfa7-87cd-5c8e-a0fb-df468c0567df'::UUID, 1, 'introduced')
ON CONFLICT (lesson_id, grammar_lesson_id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('3663b6b7-834e-59e0-b613-c94b02157dd3'::UUID, 'b69bbb7b-52c5-502e-943f-3f51c3611352'::UUID, 'vocabulary', 1, 'Từ mới: 附件', NULL, '附件', '附件 (fùjiàn) — tệp đính kèm. 报价单请见邮件附件。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"work:附件","chinese":"附件","pinyin":"fùjiàn","meaning":"tệp đính kèm","part_of_speech":"danh từ","example_chinese":"报价单请见邮件附件。","example_pinyin":"Bàojiàdān qǐng jiàn yóujiàn fùjiàn.","example_meaning_vi":"Xin xem báo giá trong tệp đính kèm email."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('2ac29970-f197-569b-93fc-548d10a1edbf'::UUID, 'b69bbb7b-52c5-502e-943f-3f51c3611352'::UUID, 'vocabulary', 2, 'Từ mới: 确认', NULL, '确认', '确认 (quèrèn) — xác nhận. 请确认会议时间是否合适。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"work:确认","chinese":"确认","pinyin":"quèrèn","meaning":"xác nhận","part_of_speech":"động từ","example_chinese":"请确认会议时间是否合适。","example_pinyin":"Qǐng quèrèn huìyì shíjiān shìfǒu héshì.","example_meaning_vi":"Xin xác nhận thời gian họp có phù hợp không."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('287a9d70-df24-598f-ae4c-93f00dd82d37'::UUID, 'b69bbb7b-52c5-502e-943f-3f51c3611352'::UUID, 'vocabulary', 3, 'Từ mới: 回复', NULL, '回复', '回复 (huífù) — phản hồi. 我会在今天下班前回复。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"work:回复","chinese":"回复","pinyin":"huífù","meaning":"phản hồi","part_of_speech":"động từ/danh từ","example_chinese":"我会在今天下班前回复。","example_pinyin":"Wǒ huì zài jīntiān xiàbān qián huífù.","example_meaning_vi":"Tôi sẽ phản hồi trước khi tan làm hôm nay."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('1c3ec426-2ebd-5469-be5b-9b1ee05782cf'::UUID, 'b69bbb7b-52c5-502e-943f-3f51c3611352'::UUID, 'multiple_choice', 4, '“附件” có nghĩa phù hợp nhất là gì?', NULL, 'tệp đính kèm', '附件 (fùjiàn) nghĩa là “tệp đính kèm”.', NULL, 1, '{"activity_type":"chinese_to_vietnamese","vocabulary_key":"work:附件"}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('5a8ad4ea-832f-552a-815d-2838b5b659b0'::UUID, '1c3ec426-2ebd-5469-be5b-9b1ee05782cf'::UUID, 'phản hồi', FALSE, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('18a5e67d-831f-5795-871f-5536dd30d2ac'::UUID, '1c3ec426-2ebd-5469-be5b-9b1ee05782cf'::UUID, 'tệp đính kèm', TRUE, 2)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('77f21532-df1f-588c-ac30-ef398424480e'::UUID, '1c3ec426-2ebd-5469-be5b-9b1ee05782cf'::UUID, 'xác nhận', FALSE, 3)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('62cbab69-1183-5722-807c-a8d7363d9787'::UUID, 'b69bbb7b-52c5-502e-943f-3f51c3611352'::UUID, 'translation', 5, 'Dịch sang tiếng Trung: “Xin xác nhận tệp đính kèm có đầy đủ không.”', NULL, '请确认附件是否完整。', 'Mẫu câu dùng “附件” trong ngữ cảnh của bài.', 'fùjiàn', 1, '{"activity_type":"vietnamese_to_chinese","source_lang":"vi","target_lang":"zh","acceptable_answers":["请确认附件是否完整。"]}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('e9b4cb57-2a6e-5322-a50e-bc9d1863b308'::UUID, 'b69bbb7b-52c5-502e-943f-3f51c3611352'::UUID, 'sentence_builder', 6, 'Sắp xếp các thành phần thành câu đúng.', NULL, '请确认附件是否完整。', 'Trật tự đúng tạo thành câu “请确认附件是否完整。”.', NULL, 1, '{"activity_type":"sentence_ordering","words":["请","确认","附件","是否","完整","。"],"correct_order":["请","确认","附件","是否","完整","。"]}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('a6170994-c7dc-5047-9754-0a7b857b0ba6'::UUID, 'b69bbb7b-52c5-502e-943f-3f51c3611352'::UUID, 'multiple_choice', 7, 'Câu email nào yêu cầu xác nhận?', NULL, '请确认附件是否完整。', '是否 là dạng văn viết, trang trọng hơn “是不是”.', NULL, 1, '{"activity_type":"grammar_selection","passage":null,"grammar_key":"work:email"}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('e834256b-8375-5c33-8059-c559f93abc00'::UUID, 'a6170994-c7dc-5047-9754-0a7b857b0ba6'::UUID, '请确认附件是否完整。', TRUE, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('6c9f37a8-6281-5350-abd6-48e61a298ee1'::UUID, 'a6170994-c7dc-5047-9754-0a7b857b0ba6'::UUID, '。完整是否附件确认请', FALSE, 2)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('0b4daf5d-4157-535c-8321-3027778c3e87'::UUID, 'a6170994-c7dc-5047-9754-0a7b857b0ba6'::UUID, '确认附件是否完整。请', FALSE, 3)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('59e3fc45-1a32-5f6d-a571-af759d4c6e19'::UUID, 'b69bbb7b-52c5-502e-943f-3f51c3611352'::UUID, 'speaking', 8, 'Đọc thành tiếng: 请确认附件是否完整。', NULL, '请确认附件是否完整。', 'Đọc chậm, giữ đúng thanh điệu và nhịp của cả câu.', NULL, 1, '{"activity_type":"pronunciation","text":"请确认附件是否完整。","pinyin":"Qǐng quèrèn fùjiàn shìfǒu wánzhěng."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lessons (id, chapter_id, slug, title, description, order_index, xp_reward, status, lesson_type, estimated_minutes, learning_objectives, cultural_note, content_version)
VALUES ('c8548ffe-c898-585c-8a0f-147d7f14f36d'::UUID, 'bcf84665-74ce-5193-a0e6-d80ec8aaadc1'::UUID, 'hop', '汇报进度 — Cuộc họp', 'Báo cáo tiến độ và nêu vấn đề.', 2, 25, 'review', 'standard', 15, '["Cập nhật dự án trong cuộc họp"]'::JSONB, '一下 làm giọng điệu bớt cứng nhưng vẫn chuyên nghiệp.', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('b5e16d0e-7910-5070-b599-c0408b5713ae'::UUID, 'work:进度', '进度', 'jìndù', 'tiến độ', 'progress', 'intermediate', 'hop', 'danh từ', '项目进度符合原来的计划。', 'Xiàngmù jìndù fúhé yuánlái de jìhuà.', 'Tiến độ dự án phù hợp kế hoạch ban đầu.', NULL, 'review', 'c8548ffe-c898-585c-8a0f-147d7f14f36d'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('5fe0af07-b4b6-5a91-8ff2-5ea4e77a1c87'::UUID, 'c8548ffe-c898-585c-8a0f-147d7f14f36d'::UUID, 'b5e16d0e-7910-5070-b599-c0408b5713ae'::UUID, 1, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('d72ac7f1-2de0-558e-9c32-e4c0467ffd27'::UUID, 'work:汇报', '汇报', 'huìbào', 'báo cáo', 'report', 'intermediate', 'hop', 'động từ/danh từ', '我先汇报本周的工作。', 'Wǒ xiān huìbào běn zhōu de gōngzuò.', 'Tôi báo cáo công việc tuần này trước.', NULL, 'review', 'c8548ffe-c898-585c-8a0f-147d7f14f36d'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('4e3ffd5f-697e-55bf-8270-e18c613bb08f'::UUID, 'c8548ffe-c898-585c-8a0f-147d7f14f36d'::UUID, 'd72ac7f1-2de0-558e-9c32-e4c0467ffd27'::UUID, 2, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('1f71e877-e387-5760-b14f-6a98db3c9832'::UUID, 'work:议程', '议程', 'yìchéng', 'chương trình nghị sự', 'agenda', 'intermediate', 'hop', 'danh từ', '今天的议程有三个部分。', 'Jīntiān de yìchéng yǒu sān ge bùfen.', 'Chương trình hôm nay có ba phần.', NULL, 'review', 'c8548ffe-c898-585c-8a0f-147d7f14f36d'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('f0bbb4f7-14ce-577d-8483-1b03494d4d42'::UUID, 'c8548ffe-c898-585c-8a0f-147d7f14f36d'::UUID, '1f71e877-e387-5760-b14f-6a98db3c9832'::UUID, 3, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('374d167b-f343-5957-ba46-597c48b38307'::UUID, 'c8548ffe-c898-585c-8a0f-147d7f14f36d'::UUID, '769f98bc-221e-5cca-b66a-5481a5b63dd4'::UUID, 4, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('2828402f-6da2-5f56-b29f-845e56a367e8'::UUID, 'c8548ffe-c898-585c-8a0f-147d7f14f36d'::UUID, 'a5dae4a3-1c7a-5184-b1dc-16a0a1dc5c7b'::UUID, 5, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('364afb1d-65bc-56d8-9c3b-083ef2df3f3e'::UUID, 'c8548ffe-c898-585c-8a0f-147d7f14f36d'::UUID, '7746c27f-829a-5491-a47c-efe2c24c47df'::UUID, 6, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.grammar_lessons (id, content_key, title, pattern, explanation, example_chinese, example_pinyin, example_meaning, level, status, usage_note, content_version)
VALUES ('fa5197b6-c481-59f3-97ae-0ab897a6f608'::UUID, 'work:hop', 'Mở đầu báo cáo với 先', '我先 + động từ + nội dung', '先 giúp báo hiệu bước đầu trong trình tự cuộc họp.', '我先汇报一下项目进度。', 'Wǒ xiān huìbào yíxià xiàngmù jìndù.', 'Tôi xin báo cáo sơ qua tiến độ dự án trước.', 'intermediate', 'review', NULL, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_grammar (id, lesson_id, grammar_lesson_id, order_index, curriculum_role)
VALUES ('7b756112-4721-54b4-afad-0ee5de44d131'::UUID, 'c8548ffe-c898-585c-8a0f-147d7f14f36d'::UUID, 'fa5197b6-c481-59f3-97ae-0ab897a6f608'::UUID, 1, 'introduced')
ON CONFLICT (lesson_id, grammar_lesson_id) DO NOTHING;

INSERT INTO public.lesson_grammar (id, lesson_id, grammar_lesson_id, order_index, curriculum_role)
VALUES ('1b4dae45-4637-55e9-887c-69190f18e7e0'::UUID, 'c8548ffe-c898-585c-8a0f-147d7f14f36d'::UUID, 'b373cfa7-87cd-5c8e-a0fb-df468c0567df'::UUID, 2, 'review')
ON CONFLICT (lesson_id, grammar_lesson_id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('e5455b08-9449-5502-b376-94aed5019164'::UUID, 'c8548ffe-c898-585c-8a0f-147d7f14f36d'::UUID, 'vocabulary', 1, 'Từ mới: 进度', NULL, '进度', '进度 (jìndù) — tiến độ. 项目进度符合原来的计划。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"work:进度","chinese":"进度","pinyin":"jìndù","meaning":"tiến độ","part_of_speech":"danh từ","example_chinese":"项目进度符合原来的计划。","example_pinyin":"Xiàngmù jìndù fúhé yuánlái de jìhuà.","example_meaning_vi":"Tiến độ dự án phù hợp kế hoạch ban đầu."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('5d101dbf-bb67-54e6-a026-1d6f3249cefb'::UUID, 'c8548ffe-c898-585c-8a0f-147d7f14f36d'::UUID, 'vocabulary', 2, 'Từ mới: 汇报', NULL, '汇报', '汇报 (huìbào) — báo cáo. 我先汇报本周的工作。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"work:汇报","chinese":"汇报","pinyin":"huìbào","meaning":"báo cáo","part_of_speech":"động từ/danh từ","example_chinese":"我先汇报本周的工作。","example_pinyin":"Wǒ xiān huìbào běn zhōu de gōngzuò.","example_meaning_vi":"Tôi báo cáo công việc tuần này trước."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('abfd30f8-0f28-5f21-a954-d585f211abe6'::UUID, 'c8548ffe-c898-585c-8a0f-147d7f14f36d'::UUID, 'vocabulary', 3, 'Từ mới: 议程', NULL, '议程', '议程 (yìchéng) — chương trình nghị sự. 今天的议程有三个部分。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"work:议程","chinese":"议程","pinyin":"yìchéng","meaning":"chương trình nghị sự","part_of_speech":"danh từ","example_chinese":"今天的议程有三个部分。","example_pinyin":"Jīntiān de yìchéng yǒu sān ge bùfen.","example_meaning_vi":"Chương trình hôm nay có ba phần."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('a38f836c-48e1-5fb0-b077-eee5af39a106'::UUID, 'c8548ffe-c898-585c-8a0f-147d7f14f36d'::UUID, 'multiple_choice', 4, '“进度” có nghĩa phù hợp nhất là gì?', NULL, 'tiến độ', '进度 (jìndù) nghĩa là “tiến độ”.', NULL, 1, '{"activity_type":"chinese_to_vietnamese","vocabulary_key":"work:进度"}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('d55f9830-d54e-5754-8c24-4cf4965a477f'::UUID, 'a38f836c-48e1-5fb0-b077-eee5af39a106'::UUID, 'tiến độ', TRUE, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('836e8bb7-671c-5f4d-ba7a-d98a284e4b39'::UUID, 'a38f836c-48e1-5fb0-b077-eee5af39a106'::UUID, 'báo cáo', FALSE, 2)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('aa10bc99-82ad-5027-8816-5d8520fdddda'::UUID, 'a38f836c-48e1-5fb0-b077-eee5af39a106'::UUID, 'chương trình nghị sự', FALSE, 3)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('ec1579ca-f4f1-56ea-97df-1e7e354d87ee'::UUID, 'c8548ffe-c898-585c-8a0f-147d7f14f36d'::UUID, 'translation', 5, 'Dịch sang tiếng Trung: “Tôi xin báo cáo sơ qua tiến độ dự án trước.”', NULL, '我先汇报一下项目进度。', 'Mẫu câu dùng “进度” trong ngữ cảnh của bài.', 'jìndù', 1, '{"activity_type":"vietnamese_to_chinese","source_lang":"vi","target_lang":"zh","acceptable_answers":["我先汇报一下项目进度。"]}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('e436a0f4-df18-542b-99d6-7cf390736337'::UUID, 'c8548ffe-c898-585c-8a0f-147d7f14f36d'::UUID, 'sentence_builder', 6, 'Sắp xếp các thành phần thành câu đúng.', NULL, '我先汇报一下项目进度。', 'Trật tự đúng tạo thành câu “我先汇报一下项目进度。”.', NULL, 1, '{"activity_type":"sentence_ordering","words":["我","先","汇报","一下","项目","进度","。"],"correct_order":["我","先","汇报","一下","项目","进度","。"]}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('186f20bb-619f-553f-a3b8-07ed78284b86'::UUID, 'c8548ffe-c898-585c-8a0f-147d7f14f36d'::UUID, 'multiple_choice', 7, 'Câu nào mở đầu báo cáo tự nhiên?', NULL, '我先汇报一下项目进度。', '先 giúp báo hiệu bước đầu trong trình tự cuộc họp.', NULL, 1, '{"activity_type":"grammar_selection","passage":null,"grammar_key":"work:hop"}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('7554fac4-e9c5-5573-a719-a604a6d58e3c'::UUID, '186f20bb-619f-553f-a3b8-07ed78284b86'::UUID, '我先汇报一下项目进度。', TRUE, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('c8923bee-33e4-5ad9-828a-2b5d250b7b09'::UUID, '186f20bb-619f-553f-a3b8-07ed78284b86'::UUID, '。进度项目一下汇报先我', FALSE, 2)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('1f1a141f-bed0-5d4e-8749-4daba7b938e3'::UUID, '186f20bb-619f-553f-a3b8-07ed78284b86'::UUID, '先汇报一下项目进度。我', FALSE, 3)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('8ac9b51f-531b-53b2-a501-d20b416f0a69'::UUID, 'c8548ffe-c898-585c-8a0f-147d7f14f36d'::UUID, 'speaking', 8, 'Đọc thành tiếng: 我先汇报一下项目进度。', NULL, '我先汇报一下项目进度。', 'Đọc chậm, giữ đúng thanh điệu và nhịp của cả câu.', NULL, 1, '{"activity_type":"pronunciation","text":"我先汇报一下项目进度。","pinyin":"Wǒ xiān huìbào yíxià xiàngmù jìndù."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.units (id, course_id, slug, title, description, order_index, status, learning_objectives, content_version)
VALUES ('29fc6e3b-fd41-5df5-a088-d9fdebf4e962'::UUID, '8e73eac6-debe-5f16-95cd-fef89f0e5b42'::UUID, 'work-van-dung', 'Vận dụng', 'Vận dụng mẫu câu trong ngữ cảnh có ý nghĩa.', 2, 'review', '["Tham gia họp và thương lượng","Dùng văn phong nghề nghiệp phù hợp"]'::JSONB, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.chapters (id, unit_id, slug, title, description, order_index, status, learning_objectives, content_version)
VALUES ('a1d16458-4278-5f1e-a0a9-e388961a66ce'::UUID, '29fc6e3b-fd41-5df5-a088-d9fdebf4e962'::UUID, 'work-van-dung-chapter', 'Ngữ cảnh thực tế', 'Vận dụng mẫu câu trong ngữ cảnh có ý nghĩa.', 1, 'review', '["Tham gia họp và thương lượng","Dùng văn phong nghề nghiệp phù hợp"]'::JSONB, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lessons (id, chapter_id, slug, title, description, order_index, xp_reward, status, lesson_type, estimated_minutes, learning_objectives, cultural_note, content_version)
VALUES ('7829ceaa-e647-53b2-9f68-b9daa8f58c24'::UUID, 'a1d16458-4278-5f1e-a0a9-e388961a66ce'::UUID, 'thuong-luong', '达成协议 — Thương lượng', 'Nêu điều kiện và tìm phương án chung.', 1, 25, 'review', 'standard', 15, '["Thương lượng điều khoản cơ bản"]'::JSONB, 'Dùng 可以 thay cho 会 khi nói khả năng thương lượng.', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('69e3ecd7-789e-5c98-ac37-5a8a975b5945'::UUID, 'work:报价', '报价', 'bàojià', 'báo giá', 'quote; quotation', 'intermediate', 'thuong-luong', 'động từ/danh từ', '这个报价包括运输费用。', 'Zhège bàojià bāokuò yùnshū fèiyòng.', 'Báo giá này bao gồm phí vận chuyển.', NULL, 'review', '7829ceaa-e647-53b2-9f68-b9daa8f58c24'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('3480f0a5-af38-58d8-be21-39213c29b826'::UUID, '7829ceaa-e647-53b2-9f68-b9daa8f58c24'::UUID, '69e3ecd7-789e-5c98-ac37-5a8a975b5945'::UUID, 1, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('37663815-0d2b-5873-b6ec-3051a1bd8279'::UUID, 'work:让步', '让步', 'ràngbù', 'nhượng bộ', 'make a concession', 'intermediate', 'thuong-luong', 'động từ', '双方都需要作出适当让步。', 'Shuāngfāng dōu xūyào zuòchū shìdàng ràngbù.', 'Hai bên đều cần có nhượng bộ phù hợp.', NULL, 'review', '7829ceaa-e647-53b2-9f68-b9daa8f58c24'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('63762456-7f96-5629-a3fc-fc985943dc7c'::UUID, '7829ceaa-e647-53b2-9f68-b9daa8f58c24'::UUID, '37663815-0d2b-5873-b6ec-3051a1bd8279'::UUID, 2, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('474922b4-1a42-519a-b98f-84eedb605627'::UUID, 'work:协议', '协议', 'xiéyì', 'thỏa thuận', 'agreement', 'intermediate', 'thuong-luong', 'danh từ', '双方终于达成了协议。', 'Shuāngfāng zhōngyú dáchéng le xiéyì.', 'Hai bên cuối cùng đã đạt được thỏa thuận.', NULL, 'review', '7829ceaa-e647-53b2-9f68-b9daa8f58c24'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('37f09807-f9bc-5897-988f-8df7ac7bdf70'::UUID, '7829ceaa-e647-53b2-9f68-b9daa8f58c24'::UUID, '474922b4-1a42-519a-b98f-84eedb605627'::UUID, 3, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('b3afe7ef-a8bb-5dc7-ac61-24902cf78060'::UUID, '7829ceaa-e647-53b2-9f68-b9daa8f58c24'::UUID, 'b5e16d0e-7910-5070-b599-c0408b5713ae'::UUID, 4, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('5662bd4e-c0fd-5b5c-888d-1a73322ef9f4'::UUID, '7829ceaa-e647-53b2-9f68-b9daa8f58c24'::UUID, 'd72ac7f1-2de0-558e-9c32-e4c0467ffd27'::UUID, 5, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('060f0fd4-6f8b-5cc2-bf81-40c38b9464ed'::UUID, '7829ceaa-e647-53b2-9f68-b9daa8f58c24'::UUID, '1f71e877-e387-5760-b14f-6a98db3c9832'::UUID, 6, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.grammar_lessons (id, content_key, title, pattern, explanation, example_chinese, example_pinyin, example_meaning, level, status, usage_note, content_version)
VALUES ('5d7eab18-d7ee-56d0-9fb6-2206009f5eff'::UUID, 'work:thuong-luong', 'Điều kiện thương lượng', '如果 A，我们可以 B', '如果 nêu điều kiện; vế sau đưa ra phương án tương ứng.', '如果增加数量，我们可以调整报价。', 'Rúguǒ zēngjiā shùliàng, wǒmen kěyǐ tiáozhěng bàojià.', 'Nếu tăng số lượng, chúng tôi có thể điều chỉnh báo giá.', 'intermediate', 'review', NULL, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_grammar (id, lesson_id, grammar_lesson_id, order_index, curriculum_role)
VALUES ('f6245020-29ae-55bf-83e9-f9fe31f19bfe'::UUID, '7829ceaa-e647-53b2-9f68-b9daa8f58c24'::UUID, '5d7eab18-d7ee-56d0-9fb6-2206009f5eff'::UUID, 1, 'introduced')
ON CONFLICT (lesson_id, grammar_lesson_id) DO NOTHING;

INSERT INTO public.lesson_grammar (id, lesson_id, grammar_lesson_id, order_index, curriculum_role)
VALUES ('2baa5299-1d60-5c57-976c-355dceb0013a'::UUID, '7829ceaa-e647-53b2-9f68-b9daa8f58c24'::UUID, 'fa5197b6-c481-59f3-97ae-0ab897a6f608'::UUID, 2, 'review')
ON CONFLICT (lesson_id, grammar_lesson_id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('95ccdaad-4822-5fc6-8b3e-0765ce26d465'::UUID, '7829ceaa-e647-53b2-9f68-b9daa8f58c24'::UUID, 'vocabulary', 1, 'Từ mới: 报价', NULL, '报价', '报价 (bàojià) — báo giá. 这个报价包括运输费用。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"work:报价","chinese":"报价","pinyin":"bàojià","meaning":"báo giá","part_of_speech":"động từ/danh từ","example_chinese":"这个报价包括运输费用。","example_pinyin":"Zhège bàojià bāokuò yùnshū fèiyòng.","example_meaning_vi":"Báo giá này bao gồm phí vận chuyển."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('53d2dad5-b3e1-5688-9b13-0624a62b2c9c'::UUID, '7829ceaa-e647-53b2-9f68-b9daa8f58c24'::UUID, 'vocabulary', 2, 'Từ mới: 让步', NULL, '让步', '让步 (ràngbù) — nhượng bộ. 双方都需要作出适当让步。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"work:让步","chinese":"让步","pinyin":"ràngbù","meaning":"nhượng bộ","part_of_speech":"động từ","example_chinese":"双方都需要作出适当让步。","example_pinyin":"Shuāngfāng dōu xūyào zuòchū shìdàng ràngbù.","example_meaning_vi":"Hai bên đều cần có nhượng bộ phù hợp."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('4c94b228-e406-5e48-b056-9cdfb3bd2ad4'::UUID, '7829ceaa-e647-53b2-9f68-b9daa8f58c24'::UUID, 'vocabulary', 3, 'Từ mới: 协议', NULL, '协议', '协议 (xiéyì) — thỏa thuận. 双方终于达成了协议。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"work:协议","chinese":"协议","pinyin":"xiéyì","meaning":"thỏa thuận","part_of_speech":"danh từ","example_chinese":"双方终于达成了协议。","example_pinyin":"Shuāngfāng zhōngyú dáchéng le xiéyì.","example_meaning_vi":"Hai bên cuối cùng đã đạt được thỏa thuận."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('c92570e7-5a2e-5215-b683-43a19fbf7819'::UUID, '7829ceaa-e647-53b2-9f68-b9daa8f58c24'::UUID, 'multiple_choice', 4, '“报价” có nghĩa phù hợp nhất là gì?', NULL, 'báo giá', '报价 (bàojià) nghĩa là “báo giá”.', NULL, 1, '{"activity_type":"chinese_to_vietnamese","vocabulary_key":"work:报价"}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('cb70d7fd-293a-5ccb-97f9-d954ba5629d9'::UUID, 'c92570e7-5a2e-5215-b683-43a19fbf7819'::UUID, 'thỏa thuận', FALSE, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('cc2eded1-a60b-571f-abc7-bd922e97fc4a'::UUID, 'c92570e7-5a2e-5215-b683-43a19fbf7819'::UUID, 'báo giá', TRUE, 2)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('7a232f57-70e0-5d6b-8cbe-deacaddbcc3c'::UUID, 'c92570e7-5a2e-5215-b683-43a19fbf7819'::UUID, 'nhượng bộ', FALSE, 3)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('952c8102-8983-596a-a00d-633adb1405e5'::UUID, '7829ceaa-e647-53b2-9f68-b9daa8f58c24'::UUID, 'translation', 5, 'Dịch sang tiếng Trung: “Nếu tăng số lượng, chúng tôi có thể điều chỉnh báo giá.”', NULL, '如果增加数量，我们可以调整报价。', 'Mẫu câu dùng “报价” trong ngữ cảnh của bài.', 'bàojià', 1, '{"activity_type":"vietnamese_to_chinese","source_lang":"vi","target_lang":"zh","acceptable_answers":["如果增加数量，我们可以调整报价。"]}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('9f263364-e690-5217-a3ba-39778b838113'::UUID, '7829ceaa-e647-53b2-9f68-b9daa8f58c24'::UUID, 'sentence_builder', 6, 'Sắp xếp các thành phần thành câu đúng.', NULL, '如果增加数量，我们可以调整报价。', 'Trật tự đúng tạo thành câu “如果增加数量，我们可以调整报价。”.', NULL, 1, '{"activity_type":"sentence_ordering","words":["如果","增加","数量","，","我们","可以","调整","报价","。"],"correct_order":["如果","增加","数量","，","我们","可以","调整","报价","。"]}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('1cbdcafc-5ab6-5d37-ad20-5a7615234f55'::UUID, '7829ceaa-e647-53b2-9f68-b9daa8f58c24'::UUID, 'multiple_choice', 7, 'Câu nào đưa ra điều kiện thương lượng?', NULL, '如果增加数量，我们可以调整报价。', '如果 nêu điều kiện; vế sau đưa ra phương án tương ứng.', NULL, 1, '{"activity_type":"grammar_selection","passage":null,"grammar_key":"work:thuong-luong"}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('a3c8d351-b952-5d4c-807e-ace740f83dad'::UUID, '1cbdcafc-5ab6-5d37-ad20-5a7615234f55'::UUID, '如果增加数量，我们可以调整报价。', TRUE, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('a24fdf26-ed82-5c32-8f91-d3774844852f'::UUID, '1cbdcafc-5ab6-5d37-ad20-5a7615234f55'::UUID, '。报价调整可以我们，数量增加如果', FALSE, 2)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('7907ba70-2c5c-54d6-980c-8a90864f6a59'::UUID, '1cbdcafc-5ab6-5d37-ad20-5a7615234f55'::UUID, '增加数量，我们可以调整报价。如果', FALSE, 3)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('b0856878-d6ad-5c47-89c4-283e3de6b254'::UUID, '7829ceaa-e647-53b2-9f68-b9daa8f58c24'::UUID, 'speaking', 8, 'Đọc thành tiếng: 如果增加数量，我们可以调整报价。', NULL, '如果增加数量，我们可以调整报价。', 'Đọc chậm, giữ đúng thanh điệu và nhịp của cả câu.', NULL, 1, '{"activity_type":"pronunciation","text":"如果增加数量，我们可以调整报价。","pinyin":"Rúguǒ zēngjiā shùliàng, wǒmen kěyǐ tiáozhěng bàojià."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lessons (id, chapter_id, slug, title, description, order_index, xp_reward, status, lesson_type, estimated_minutes, learning_objectives, cultural_note, content_version)
VALUES ('d798fffc-427c-5eed-9368-1aa5ea1d58d6'::UUID, 'a1d16458-4278-5f1e-a0a9-e388961a66ce'::UUID, 'phong-van', '应聘职位 — Phỏng vấn', 'Trình bày kinh nghiệm và năng lực.', 2, 25, 'review', 'standard', 15, '["Tự giới thiệu trong phỏng vấn"]'::JSONB, '曾经 thường đi với 过 hoặc bối cảnh quá khứ rõ.', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('15ebca8c-ae0d-5937-b485-613391da39f0'::UUID, 'work:应聘', '应聘', 'yìngpìn', 'ứng tuyển', 'apply for a job', 'intermediate', 'phong-van', 'động từ', '我来应聘市场经理这个职位。', 'Wǒ lái yìngpìn shìchǎng jīnglǐ zhège zhíwèi.', 'Tôi đến ứng tuyển vị trí giám đốc tiếp thị.', NULL, 'review', 'd798fffc-427c-5eed-9368-1aa5ea1d58d6'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('faf1e5b6-1f25-5fae-bf7d-e558215402e2'::UUID, 'd798fffc-427c-5eed-9368-1aa5ea1d58d6'::UUID, '15ebca8c-ae0d-5937-b485-613391da39f0'::UUID, 1, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('b5ad5779-9490-5b5f-9ce9-34897ae4401e'::UUID, 'work:经验', '经验', 'jīngyàn', 'kinh nghiệm', 'experience', 'intermediate', 'phong-van', 'danh từ', '我有三年项目管理经验。', 'Wǒ yǒu sān nián xiàngmù guǎnlǐ jīngyàn.', 'Tôi có ba năm kinh nghiệm quản lý dự án.', NULL, 'review', 'd798fffc-427c-5eed-9368-1aa5ea1d58d6'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('869e19b2-cfaa-5ce7-acb2-a319cc3fcdfd'::UUID, 'd798fffc-427c-5eed-9368-1aa5ea1d58d6'::UUID, 'b5ad5779-9490-5b5f-9ce9-34897ae4401e'::UUID, 2, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('d4896340-cbcf-5163-94f2-e93bb3936b61'::UUID, 'work:负责', '负责', 'fùzé', 'phụ trách', 'be responsible for', 'intermediate', 'phong-van', 'động từ', '我曾经负责海外客户服务。', 'Wǒ céngjīng fùzé hǎiwài kèhù fúwù.', 'Tôi từng phụ trách dịch vụ khách hàng nước ngoài.', NULL, 'review', 'd798fffc-427c-5eed-9368-1aa5ea1d58d6'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('ac4c2d78-3dfa-527b-8fe4-5a4e29ac460c'::UUID, 'd798fffc-427c-5eed-9368-1aa5ea1d58d6'::UUID, 'd4896340-cbcf-5163-94f2-e93bb3936b61'::UUID, 3, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('c9ddbd1f-a5a1-59cd-aea6-a65515d6dbf9'::UUID, 'd798fffc-427c-5eed-9368-1aa5ea1d58d6'::UUID, '69e3ecd7-789e-5c98-ac37-5a8a975b5945'::UUID, 4, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('4e450c65-4566-584e-a1d4-a6b2aefb9df4'::UUID, 'd798fffc-427c-5eed-9368-1aa5ea1d58d6'::UUID, '37663815-0d2b-5873-b6ec-3051a1bd8279'::UUID, 5, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('336fcffd-36e8-5ab9-b866-9052d2d1653a'::UUID, 'd798fffc-427c-5eed-9368-1aa5ea1d58d6'::UUID, '474922b4-1a42-519a-b98f-84eedb605627'::UUID, 6, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.grammar_lessons (id, content_key, title, pattern, explanation, example_chinese, example_pinyin, example_meaning, level, status, usage_note, content_version)
VALUES ('20fd145c-5f17-50ab-a215-d3368872752c'::UUID, 'work:phong-van', 'Kinh nghiệm với 曾经', 'chủ ngữ + 曾经 + động từ', '曾经 nêu trải nghiệm quá khứ có liên quan đến hiện tại.', '我曾经负责一个国际项目。', 'Wǒ céngjīng fùzé yí ge guójì xiàngmù.', 'Tôi từng phụ trách một dự án quốc tế.', 'intermediate', 'review', NULL, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_grammar (id, lesson_id, grammar_lesson_id, order_index, curriculum_role)
VALUES ('09b4016f-c975-556b-a372-012ec67e2709'::UUID, 'd798fffc-427c-5eed-9368-1aa5ea1d58d6'::UUID, '20fd145c-5f17-50ab-a215-d3368872752c'::UUID, 1, 'introduced')
ON CONFLICT (lesson_id, grammar_lesson_id) DO NOTHING;

INSERT INTO public.lesson_grammar (id, lesson_id, grammar_lesson_id, order_index, curriculum_role)
VALUES ('3e98a82a-65b0-5767-a615-e590939668a3'::UUID, 'd798fffc-427c-5eed-9368-1aa5ea1d58d6'::UUID, '5d7eab18-d7ee-56d0-9fb6-2206009f5eff'::UUID, 2, 'review')
ON CONFLICT (lesson_id, grammar_lesson_id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('c55f62cb-6de3-584a-868e-b49a89158d8a'::UUID, 'd798fffc-427c-5eed-9368-1aa5ea1d58d6'::UUID, 'vocabulary', 1, 'Từ mới: 应聘', NULL, '应聘', '应聘 (yìngpìn) — ứng tuyển. 我来应聘市场经理这个职位。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"work:应聘","chinese":"应聘","pinyin":"yìngpìn","meaning":"ứng tuyển","part_of_speech":"động từ","example_chinese":"我来应聘市场经理这个职位。","example_pinyin":"Wǒ lái yìngpìn shìchǎng jīnglǐ zhège zhíwèi.","example_meaning_vi":"Tôi đến ứng tuyển vị trí giám đốc tiếp thị."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('719002ab-11aa-5a29-bb83-75f139b4aee4'::UUID, 'd798fffc-427c-5eed-9368-1aa5ea1d58d6'::UUID, 'vocabulary', 2, 'Từ mới: 经验', NULL, '经验', '经验 (jīngyàn) — kinh nghiệm. 我有三年项目管理经验。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"work:经验","chinese":"经验","pinyin":"jīngyàn","meaning":"kinh nghiệm","part_of_speech":"danh từ","example_chinese":"我有三年项目管理经验。","example_pinyin":"Wǒ yǒu sān nián xiàngmù guǎnlǐ jīngyàn.","example_meaning_vi":"Tôi có ba năm kinh nghiệm quản lý dự án."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('8107f520-55a3-5643-bec4-091de23c8e17'::UUID, 'd798fffc-427c-5eed-9368-1aa5ea1d58d6'::UUID, 'vocabulary', 3, 'Từ mới: 负责', NULL, '负责', '负责 (fùzé) — phụ trách. 我曾经负责海外客户服务。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"work:负责","chinese":"负责","pinyin":"fùzé","meaning":"phụ trách","part_of_speech":"động từ","example_chinese":"我曾经负责海外客户服务。","example_pinyin":"Wǒ céngjīng fùzé hǎiwài kèhù fúwù.","example_meaning_vi":"Tôi từng phụ trách dịch vụ khách hàng nước ngoài."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('c763b2de-8baa-503d-8f11-bcc6f6669063'::UUID, 'd798fffc-427c-5eed-9368-1aa5ea1d58d6'::UUID, 'multiple_choice', 4, '“应聘” có nghĩa phù hợp nhất là gì?', NULL, 'ứng tuyển', '应聘 (yìngpìn) nghĩa là “ứng tuyển”.', NULL, 1, '{"activity_type":"chinese_to_vietnamese","vocabulary_key":"work:应聘"}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('bce39112-74fe-55de-88ff-594c3aa54f85'::UUID, 'c763b2de-8baa-503d-8f11-bcc6f6669063'::UUID, 'kinh nghiệm', FALSE, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('7aded1cc-fbcc-5d0e-90ee-e1cc2aae1777'::UUID, 'c763b2de-8baa-503d-8f11-bcc6f6669063'::UUID, 'phụ trách', FALSE, 2)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('0e339b23-a45a-5f0c-a95c-e3cecb39dd12'::UUID, 'c763b2de-8baa-503d-8f11-bcc6f6669063'::UUID, 'ứng tuyển', TRUE, 3)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('e0e11308-1351-5be3-a4cb-f7f6063b918b'::UUID, 'd798fffc-427c-5eed-9368-1aa5ea1d58d6'::UUID, 'translation', 5, 'Dịch sang tiếng Trung: “Tôi từng phụ trách một dự án quốc tế.”', NULL, '我曾经负责一个国际项目。', 'Mẫu câu dùng “应聘” trong ngữ cảnh của bài.', 'yìngpìn', 1, '{"activity_type":"vietnamese_to_chinese","source_lang":"vi","target_lang":"zh","acceptable_answers":["我曾经负责一个国际项目。"]}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('2617c59b-4573-5c53-9d96-0e0e6bb1ccdf'::UUID, 'd798fffc-427c-5eed-9368-1aa5ea1d58d6'::UUID, 'sentence_builder', 6, 'Sắp xếp các thành phần thành câu đúng.', NULL, '我曾经负责一个国际项目。', 'Trật tự đúng tạo thành câu “我曾经负责一个国际项目。”.', NULL, 1, '{"activity_type":"sentence_ordering","words":["我","曾经","负责","一个","国际","项目","。"],"correct_order":["我","曾经","负责","一个","国际","项目","。"]}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('4c19a357-1630-5b65-ae22-0351d2a5b90f'::UUID, 'd798fffc-427c-5eed-9368-1aa5ea1d58d6'::UUID, 'multiple_choice', 7, 'Câu nào trình bày kinh nghiệm làm việc?', NULL, '我曾经负责一个国际项目。', '曾经 nêu trải nghiệm quá khứ có liên quan đến hiện tại.', NULL, 1, '{"activity_type":"grammar_selection","passage":null,"grammar_key":"work:phong-van"}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('e21190cc-d01c-5e64-a92a-01b306f49f83'::UUID, '4c19a357-1630-5b65-ae22-0351d2a5b90f'::UUID, '我曾经负责一个国际项目。', TRUE, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('b85995bd-591b-5664-87f3-fc127d3dbd75'::UUID, '4c19a357-1630-5b65-ae22-0351d2a5b90f'::UUID, '。项目国际一个负责曾经我', FALSE, 2)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('d33b7120-ea4f-5b0e-83c8-cb517ff64804'::UUID, '4c19a357-1630-5b65-ae22-0351d2a5b90f'::UUID, '曾经负责一个国际项目。我', FALSE, 3)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('83e44603-c526-52b0-92d1-af01b037da23'::UUID, 'd798fffc-427c-5eed-9368-1aa5ea1d58d6'::UUID, 'speaking', 8, 'Đọc thành tiếng: 我曾经负责一个国际项目。', NULL, '我曾经负责一个国际项目。', 'Đọc chậm, giữ đúng thanh điệu và nhịp của cả câu.', NULL, 1, '{"activity_type":"pronunciation","text":"我曾经负责一个国际项目。","pinyin":"Wǒ céngjīng fùzé yí ge guójì xiàngmù."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.units (id, course_id, slug, title, description, order_index, status, learning_objectives, content_version)
VALUES ('f18bff77-a8be-56ed-b2dc-650d3de7c608'::UUID, '8e73eac6-debe-5f16-95cd-fef89f0e5b42'::UUID, 'work-on-tap', 'Ôn tập', 'Kiểm tra và củng cố nội dung đã học.', 3, 'review', '["Ôn từ vựng","Ôn mẫu câu"]'::JSONB, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.chapters (id, unit_id, slug, title, description, order_index, status, learning_objectives, content_version)
VALUES ('53e4373a-0300-58e1-9019-d6c9b9bbe139'::UUID, 'f18bff77-a8be-56ed-b2dc-650d3de7c608'::UUID, 'work-on-tap-chapter', 'Củng cố lộ trình', 'Kiểm tra và củng cố nội dung đã học.', 1, 'review', '["Ôn từ vựng","Ôn mẫu câu"]'::JSONB, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lessons (id, chapter_id, slug, title, description, order_index, xp_reward, status, lesson_type, estimated_minutes, learning_objectives, cultural_note, content_version)
VALUES ('e034c7a5-5e6a-54da-b509-af7fe6b60bb1'::UUID, '53e4373a-0300-58e1-9019-d6c9b9bbe139'::UUID, 'work-review', 'Ôn tập Chinese for Work and Business', 'Củng cố từ vựng, mẫu câu và khả năng diễn đạt của toàn khóa.', 1, 30, 'review', 'review', 18, '["Vận dụng lại từ vựng trọng tâm","Tự kiểm tra mẫu câu đã học"]'::JSONB, NULL, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('17af7b90-9389-5ed7-a465-7829393078f3'::UUID, 'e034c7a5-5e6a-54da-b509-af7fe6b60bb1'::UUID, '15ebca8c-ae0d-5937-b485-613391da39f0'::UUID, 1, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('94c9f1f3-4840-5509-bbb3-a88a0424a4f3'::UUID, 'e034c7a5-5e6a-54da-b509-af7fe6b60bb1'::UUID, 'b5ad5779-9490-5b5f-9ce9-34897ae4401e'::UUID, 2, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('0e4a924d-95b0-5458-90de-e59fae3e09e7'::UUID, 'e034c7a5-5e6a-54da-b509-af7fe6b60bb1'::UUID, 'd4896340-cbcf-5163-94f2-e93bb3936b61'::UUID, 3, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_grammar (id, lesson_id, grammar_lesson_id, order_index, curriculum_role)
VALUES ('d9fbf8dc-4363-533c-8fa4-c09955de187a'::UUID, 'e034c7a5-5e6a-54da-b509-af7fe6b60bb1'::UUID, '20fd145c-5f17-50ab-a215-d3368872752c'::UUID, 1, 'review')
ON CONFLICT (lesson_id, grammar_lesson_id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('0a1e83ec-58c6-580b-b8c7-9b8103393dd9'::UUID, 'e034c7a5-5e6a-54da-b509-af7fe6b60bb1'::UUID, 'multiple_choice', 1, '“应聘” có nghĩa phù hợp nhất là gì?', NULL, 'ứng tuyển', '应聘 (yìngpìn) nghĩa là “ứng tuyển”.', NULL, 1, '{"activity_type":"chinese_to_vietnamese","vocabulary_key":"work:应聘"}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('daee8ec2-2cad-5688-a230-b9fbfc66c42a'::UUID, '0a1e83ec-58c6-580b-b8c7-9b8103393dd9'::UUID, 'ứng tuyển', TRUE, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('75eb1d64-f87d-577d-9e3f-43a112b52e42'::UUID, '0a1e83ec-58c6-580b-b8c7-9b8103393dd9'::UUID, 'kinh nghiệm', FALSE, 2)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('dd7d118d-2a55-5bae-ac7a-56a2aed0ecef'::UUID, '0a1e83ec-58c6-580b-b8c7-9b8103393dd9'::UUID, 'phụ trách', FALSE, 3)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('31655565-4218-5957-812e-f6f5c8cf09f7'::UUID, 'e034c7a5-5e6a-54da-b509-af7fe6b60bb1'::UUID, 'translation', 2, 'Dịch sang tiếng Trung: “Tôi từng phụ trách một dự án quốc tế.”', NULL, '我曾经负责一个国际项目。', 'Mẫu câu dùng “应聘” trong ngữ cảnh của bài.', 'yìngpìn', 1, '{"activity_type":"vietnamese_to_chinese","source_lang":"vi","target_lang":"zh","acceptable_answers":["我曾经负责一个国际项目。"]}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('374bf68d-f27a-5212-8d95-5d35bbc79d59'::UUID, 'e034c7a5-5e6a-54da-b509-af7fe6b60bb1'::UUID, 'sentence_builder', 3, 'Sắp xếp các thành phần thành câu đúng.', NULL, '我曾经负责一个国际项目。', 'Trật tự đúng tạo thành câu “我曾经负责一个国际项目。”.', NULL, 1, '{"activity_type":"sentence_ordering","words":["我","曾经","负责","一个","国际","项目","。"],"correct_order":["我","曾经","负责","一个","国际","项目","。"]}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('64a74e45-f205-5c8a-bab6-5b0d7a6037e3'::UUID, 'e034c7a5-5e6a-54da-b509-af7fe6b60bb1'::UUID, 'multiple_choice', 4, 'Câu nào trình bày kinh nghiệm làm việc?', NULL, '我曾经负责一个国际项目。', '曾经 nêu trải nghiệm quá khứ có liên quan đến hiện tại.', NULL, 1, '{"activity_type":"grammar_selection","passage":null,"grammar_key":"work:phong-van"}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('a05cd9a6-fc1d-5922-8547-b22c79265c4c'::UUID, '64a74e45-f205-5c8a-bab6-5b0d7a6037e3'::UUID, '我曾经负责一个国际项目。', TRUE, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('52936e3f-172e-590a-8eb0-a4080466beac'::UUID, '64a74e45-f205-5c8a-bab6-5b0d7a6037e3'::UUID, '。项目国际一个负责曾经我', FALSE, 2)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('0c42c093-36e9-5733-b673-62bff7432082'::UUID, '64a74e45-f205-5c8a-bab6-5b0d7a6037e3'::UUID, '曾经负责一个国际项目。我', FALSE, 3)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('e3b29d04-3679-5667-ae85-c94e7a9b5cb5'::UUID, 'e034c7a5-5e6a-54da-b509-af7fe6b60bb1'::UUID, 'speaking', 5, 'Đọc thành tiếng: 我曾经负责一个国际项目。', NULL, '我曾经负责一个国际项目。', 'Đọc chậm, giữ đúng thanh điệu và nhịp của cả câu.', NULL, 1, '{"activity_type":"pronunciation","text":"我曾经负责一个国际项目。","pinyin":"Wǒ céngjīng fùzé yí ge guójì xiàngmù."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.content_batches (id, batch_key, version, migration_name, manifest_checksum, expected_counts)
VALUES ('8e442195-ffe1-57c7-8892-a54126b55561'::UUID, 'batch-10-work', 1, '20260729190000_content_batch_10_work', '2abae6b89b9e2394080f0b40b6d4a352ff7b013f84ccdccb1d63383be216e3b5', '{"courses":1,"units":3,"chapters":3,"lessons":5,"vocabulary":12,"grammar":4,"characters":0,"exercises":37,"options":30}'::JSONB)
ON CONFLICT (batch_key, version) DO NOTHING;

DO $content_validation$
BEGIN
  IF (SELECT COUNT(*) FROM public.courses WHERE id = ANY(ARRAY['8e73eac6-debe-5f16-95cd-fef89f0e5b42'::UUID]::UUID[])) <> 1 THEN
    RAISE EXCEPTION 'Content batch batch-10-work is missing managed courses rows';
  END IF;
  IF (SELECT COUNT(*) FROM public.units WHERE id = ANY(ARRAY['08f25255-1249-50a0-a4f5-4e25e57cd701'::UUID, '29fc6e3b-fd41-5df5-a088-d9fdebf4e962'::UUID, 'f18bff77-a8be-56ed-b2dc-650d3de7c608'::UUID]::UUID[])) <> 3 THEN
    RAISE EXCEPTION 'Content batch batch-10-work is missing managed units rows';
  END IF;
  IF (SELECT COUNT(*) FROM public.chapters WHERE id = ANY(ARRAY['bcf84665-74ce-5193-a0e6-d80ec8aaadc1'::UUID, 'a1d16458-4278-5f1e-a0a9-e388961a66ce'::UUID, '53e4373a-0300-58e1-9019-d6c9b9bbe139'::UUID]::UUID[])) <> 3 THEN
    RAISE EXCEPTION 'Content batch batch-10-work is missing managed chapters rows';
  END IF;
  IF (SELECT COUNT(*) FROM public.lessons WHERE id = ANY(ARRAY['b69bbb7b-52c5-502e-943f-3f51c3611352'::UUID, 'c8548ffe-c898-585c-8a0f-147d7f14f36d'::UUID, '7829ceaa-e647-53b2-9f68-b9daa8f58c24'::UUID, 'd798fffc-427c-5eed-9368-1aa5ea1d58d6'::UUID, 'e034c7a5-5e6a-54da-b509-af7fe6b60bb1'::UUID]::UUID[])) <> 5 THEN
    RAISE EXCEPTION 'Content batch batch-10-work is missing managed lessons rows';
  END IF;
  IF (SELECT COUNT(*) FROM public.vocabulary WHERE id = ANY(ARRAY['769f98bc-221e-5cca-b66a-5481a5b63dd4'::UUID, 'a5dae4a3-1c7a-5184-b1dc-16a0a1dc5c7b'::UUID, '7746c27f-829a-5491-a47c-efe2c24c47df'::UUID, 'b5e16d0e-7910-5070-b599-c0408b5713ae'::UUID, 'd72ac7f1-2de0-558e-9c32-e4c0467ffd27'::UUID, '1f71e877-e387-5760-b14f-6a98db3c9832'::UUID, '69e3ecd7-789e-5c98-ac37-5a8a975b5945'::UUID, '37663815-0d2b-5873-b6ec-3051a1bd8279'::UUID, '474922b4-1a42-519a-b98f-84eedb605627'::UUID, '15ebca8c-ae0d-5937-b485-613391da39f0'::UUID, 'b5ad5779-9490-5b5f-9ce9-34897ae4401e'::UUID, 'd4896340-cbcf-5163-94f2-e93bb3936b61'::UUID]::UUID[])) <> 12 THEN
    RAISE EXCEPTION 'Content batch batch-10-work is missing managed vocabulary rows';
  END IF;
  IF (SELECT COUNT(*) FROM public.grammar_lessons WHERE id = ANY(ARRAY['b373cfa7-87cd-5c8e-a0fb-df468c0567df'::UUID, 'fa5197b6-c481-59f3-97ae-0ab897a6f608'::UUID, '5d7eab18-d7ee-56d0-9fb6-2206009f5eff'::UUID, '20fd145c-5f17-50ab-a215-d3368872752c'::UUID]::UUID[])) <> 4 THEN
    RAISE EXCEPTION 'Content batch batch-10-work is missing managed grammar_lessons rows';
  END IF;
  IF (SELECT COUNT(*) FROM public.exercises WHERE id = ANY(ARRAY['3663b6b7-834e-59e0-b613-c94b02157dd3'::UUID, '2ac29970-f197-569b-93fc-548d10a1edbf'::UUID, '287a9d70-df24-598f-ae4c-93f00dd82d37'::UUID, '1c3ec426-2ebd-5469-be5b-9b1ee05782cf'::UUID, '62cbab69-1183-5722-807c-a8d7363d9787'::UUID, 'e9b4cb57-2a6e-5322-a50e-bc9d1863b308'::UUID, 'a6170994-c7dc-5047-9754-0a7b857b0ba6'::UUID, '59e3fc45-1a32-5f6d-a571-af759d4c6e19'::UUID, 'e5455b08-9449-5502-b376-94aed5019164'::UUID, '5d101dbf-bb67-54e6-a026-1d6f3249cefb'::UUID, 'abfd30f8-0f28-5f21-a954-d585f211abe6'::UUID, 'a38f836c-48e1-5fb0-b077-eee5af39a106'::UUID, 'ec1579ca-f4f1-56ea-97df-1e7e354d87ee'::UUID, 'e436a0f4-df18-542b-99d6-7cf390736337'::UUID, '186f20bb-619f-553f-a3b8-07ed78284b86'::UUID, '8ac9b51f-531b-53b2-a501-d20b416f0a69'::UUID, '95ccdaad-4822-5fc6-8b3e-0765ce26d465'::UUID, '53d2dad5-b3e1-5688-9b13-0624a62b2c9c'::UUID, '4c94b228-e406-5e48-b056-9cdfb3bd2ad4'::UUID, 'c92570e7-5a2e-5215-b683-43a19fbf7819'::UUID, '952c8102-8983-596a-a00d-633adb1405e5'::UUID, '9f263364-e690-5217-a3ba-39778b838113'::UUID, '1cbdcafc-5ab6-5d37-ad20-5a7615234f55'::UUID, 'b0856878-d6ad-5c47-89c4-283e3de6b254'::UUID, 'c55f62cb-6de3-584a-868e-b49a89158d8a'::UUID, '719002ab-11aa-5a29-bb83-75f139b4aee4'::UUID, '8107f520-55a3-5643-bec4-091de23c8e17'::UUID, 'c763b2de-8baa-503d-8f11-bcc6f6669063'::UUID, 'e0e11308-1351-5be3-a4cb-f7f6063b918b'::UUID, '2617c59b-4573-5c53-9d96-0e0e6bb1ccdf'::UUID, '4c19a357-1630-5b65-ae22-0351d2a5b90f'::UUID, '83e44603-c526-52b0-92d1-af01b037da23'::UUID, '0a1e83ec-58c6-580b-b8c7-9b8103393dd9'::UUID, '31655565-4218-5957-812e-f6f5c8cf09f7'::UUID, '374bf68d-f27a-5212-8d95-5d35bbc79d59'::UUID, '64a74e45-f205-5c8a-bab6-5b0d7a6037e3'::UUID, 'e3b29d04-3679-5667-ae85-c94e7a9b5cb5'::UUID]::UUID[])) <> 37 THEN
    RAISE EXCEPTION 'Content batch batch-10-work is missing managed exercises rows';
  END IF;
  IF (SELECT COUNT(*) FROM public.exercise_options WHERE id = ANY(ARRAY['5a8ad4ea-832f-552a-815d-2838b5b659b0'::UUID, '18a5e67d-831f-5795-871f-5536dd30d2ac'::UUID, '77f21532-df1f-588c-ac30-ef398424480e'::UUID, 'e834256b-8375-5c33-8059-c559f93abc00'::UUID, '6c9f37a8-6281-5350-abd6-48e61a298ee1'::UUID, '0b4daf5d-4157-535c-8321-3027778c3e87'::UUID, 'd55f9830-d54e-5754-8c24-4cf4965a477f'::UUID, '836e8bb7-671c-5f4d-ba7a-d98a284e4b39'::UUID, 'aa10bc99-82ad-5027-8816-5d8520fdddda'::UUID, '7554fac4-e9c5-5573-a719-a604a6d58e3c'::UUID, 'c8923bee-33e4-5ad9-828a-2b5d250b7b09'::UUID, '1f1a141f-bed0-5d4e-8749-4daba7b938e3'::UUID, 'cb70d7fd-293a-5ccb-97f9-d954ba5629d9'::UUID, 'cc2eded1-a60b-571f-abc7-bd922e97fc4a'::UUID, '7a232f57-70e0-5d6b-8cbe-deacaddbcc3c'::UUID, 'a3c8d351-b952-5d4c-807e-ace740f83dad'::UUID, 'a24fdf26-ed82-5c32-8f91-d3774844852f'::UUID, '7907ba70-2c5c-54d6-980c-8a90864f6a59'::UUID, 'bce39112-74fe-55de-88ff-594c3aa54f85'::UUID, '7aded1cc-fbcc-5d0e-90ee-e1cc2aae1777'::UUID, '0e339b23-a45a-5f0c-a95c-e3cecb39dd12'::UUID, 'e21190cc-d01c-5e64-a92a-01b306f49f83'::UUID, 'b85995bd-591b-5664-87f3-fc127d3dbd75'::UUID, 'd33b7120-ea4f-5b0e-83c8-cb517ff64804'::UUID, 'daee8ec2-2cad-5688-a230-b9fbfc66c42a'::UUID, '75eb1d64-f87d-577d-9e3f-43a112b52e42'::UUID, 'dd7d118d-2a55-5bae-ac7a-56a2aed0ecef'::UUID, 'a05cd9a6-fc1d-5922-8547-b22c79265c4c'::UUID, '52936e3f-172e-590a-8eb0-a4080466beac'::UUID, '0c42c093-36e9-5733-b673-62bff7432082'::UUID]::UUID[])) <> 30 THEN
    RAISE EXCEPTION 'Content batch batch-10-work is missing managed exercise_options rows';
  END IF;
  IF EXISTS (
    SELECT 1 FROM public.lessons AS lesson
    WHERE lesson.id = ANY(ARRAY['b69bbb7b-52c5-502e-943f-3f51c3611352'::UUID, 'c8548ffe-c898-585c-8a0f-147d7f14f36d'::UUID, '7829ceaa-e647-53b2-9f68-b9daa8f58c24'::UUID, 'd798fffc-427c-5eed-9368-1aa5ea1d58d6'::UUID, 'e034c7a5-5e6a-54da-b509-af7fe6b60bb1'::UUID]::UUID[])
      AND NOT EXISTS (
        SELECT 1 FROM public.exercises AS exercise
        WHERE exercise.lesson_id = lesson.id
      )
  ) THEN
    RAISE EXCEPTION 'Content batch batch-10-work contains a lesson without exercises';
  END IF;
  IF EXISTS (
    SELECT 1
    FROM public.lessons AS lesson
    JOIN public.exercises AS exercise ON exercise.lesson_id = lesson.id
    WHERE lesson.id = ANY(ARRAY['b69bbb7b-52c5-502e-943f-3f51c3611352'::UUID, 'c8548ffe-c898-585c-8a0f-147d7f14f36d'::UUID, '7829ceaa-e647-53b2-9f68-b9daa8f58c24'::UUID, 'd798fffc-427c-5eed-9368-1aa5ea1d58d6'::UUID, 'e034c7a5-5e6a-54da-b509-af7fe6b60bb1'::UUID]::UUID[])
      AND lesson.status = 'published'
      AND exercise.exercise_type = 'listening'
      AND NULLIF(BTRIM(exercise.question_audio_url), '') IS NULL
  ) THEN
    RAISE EXCEPTION 'Published listening exercise is missing playable audio';
  END IF;
  IF EXISTS (
    SELECT 1
    FROM public.exercises AS exercise
    WHERE exercise.id = ANY(ARRAY['3663b6b7-834e-59e0-b613-c94b02157dd3'::UUID, '2ac29970-f197-569b-93fc-548d10a1edbf'::UUID, '287a9d70-df24-598f-ae4c-93f00dd82d37'::UUID, '1c3ec426-2ebd-5469-be5b-9b1ee05782cf'::UUID, '62cbab69-1183-5722-807c-a8d7363d9787'::UUID, 'e9b4cb57-2a6e-5322-a50e-bc9d1863b308'::UUID, 'a6170994-c7dc-5047-9754-0a7b857b0ba6'::UUID, '59e3fc45-1a32-5f6d-a571-af759d4c6e19'::UUID, 'e5455b08-9449-5502-b376-94aed5019164'::UUID, '5d101dbf-bb67-54e6-a026-1d6f3249cefb'::UUID, 'abfd30f8-0f28-5f21-a954-d585f211abe6'::UUID, 'a38f836c-48e1-5fb0-b077-eee5af39a106'::UUID, 'ec1579ca-f4f1-56ea-97df-1e7e354d87ee'::UUID, 'e436a0f4-df18-542b-99d6-7cf390736337'::UUID, '186f20bb-619f-553f-a3b8-07ed78284b86'::UUID, '8ac9b51f-531b-53b2-a501-d20b416f0a69'::UUID, '95ccdaad-4822-5fc6-8b3e-0765ce26d465'::UUID, '53d2dad5-b3e1-5688-9b13-0624a62b2c9c'::UUID, '4c94b228-e406-5e48-b056-9cdfb3bd2ad4'::UUID, 'c92570e7-5a2e-5215-b683-43a19fbf7819'::UUID, '952c8102-8983-596a-a00d-633adb1405e5'::UUID, '9f263364-e690-5217-a3ba-39778b838113'::UUID, '1cbdcafc-5ab6-5d37-ad20-5a7615234f55'::UUID, 'b0856878-d6ad-5c47-89c4-283e3de6b254'::UUID, 'c55f62cb-6de3-584a-868e-b49a89158d8a'::UUID, '719002ab-11aa-5a29-bb83-75f139b4aee4'::UUID, '8107f520-55a3-5643-bec4-091de23c8e17'::UUID, 'c763b2de-8baa-503d-8f11-bcc6f6669063'::UUID, 'e0e11308-1351-5be3-a4cb-f7f6063b918b'::UUID, '2617c59b-4573-5c53-9d96-0e0e6bb1ccdf'::UUID, '4c19a357-1630-5b65-ae22-0351d2a5b90f'::UUID, '83e44603-c526-52b0-92d1-af01b037da23'::UUID, '0a1e83ec-58c6-580b-b8c7-9b8103393dd9'::UUID, '31655565-4218-5957-812e-f6f5c8cf09f7'::UUID, '374bf68d-f27a-5212-8d95-5d35bbc79d59'::UUID, '64a74e45-f205-5c8a-bab6-5b0d7a6037e3'::UUID, 'e3b29d04-3679-5667-ae85-c94e7a9b5cb5'::UUID]::UUID[])
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
    WHERE link.lesson_id = ANY(ARRAY['b69bbb7b-52c5-502e-943f-3f51c3611352'::UUID, 'c8548ffe-c898-585c-8a0f-147d7f14f36d'::UUID, '7829ceaa-e647-53b2-9f68-b9daa8f58c24'::UUID, 'd798fffc-427c-5eed-9368-1aa5ea1d58d6'::UUID, 'e034c7a5-5e6a-54da-b509-af7fe6b60bb1'::UUID]::UUID[])
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
