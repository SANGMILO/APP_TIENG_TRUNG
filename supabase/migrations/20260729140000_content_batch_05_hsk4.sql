-- Generated from content/manifests/05_hsk4.json.
-- Do not hand-edit this migration; edit the manifest and regenerate.
-- Additive and idempotent: deterministic IDs plus ON CONFLICT DO NOTHING.

BEGIN;

INSERT INTO public.courses (id, slug, title, title_zh, description, level, status, order_index, learning_objectives, estimated_minutes, content_version)
VALUES ('0803c46d-4027-5447-800b-5752f93da380'::UUID, 'hsk-4', 'HSK 4', 'HSK 四级', 'Rèn diễn đạt có tổ chức, câu 把/被 và lập luận.', 'intermediate', 'review', 5, '["Dùng câu 把 và 被","Trình bày điều kiện","Tóm tắt ý kiến có liên kết"]'::JSONB, 78, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.units (id, course_id, slug, title, description, order_index, status, learning_objectives, content_version)
VALUES ('9c974d5d-b12f-5ab6-973c-c2694a338b5a'::UUID, '0803c46d-4027-5447-800b-5752f93da380'::UUID, 'hsk4-nen-tang', 'Nền tảng', 'Xây dựng ngôn ngữ cốt lõi của lộ trình.', 1, 'review', '["Dùng câu 把 và 被","Trình bày điều kiện"]'::JSONB, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.chapters (id, unit_id, slug, title, description, order_index, status, learning_objectives, content_version)
VALUES ('6b3e3d82-4032-56d6-b420-5e29a2136869'::UUID, '9c974d5d-b12f-5ab6-973c-c2694a338b5a'::UUID, 'hsk4-nen-tang-chapter', 'Khái niệm cốt lõi', 'Xây dựng ngôn ngữ cốt lõi của lộ trình.', 1, 'review', '["Dùng câu 把 và 被","Trình bày điều kiện"]'::JSONB, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lessons (id, chapter_id, slug, title, description, order_index, xp_reward, status, lesson_type, estimated_minutes, learning_objectives, cultural_note, content_version)
VALUES ('d8ccc0bb-980a-57d4-bffe-4c28a6f88a32'::UUID, '6b3e3d82-4032-56d6-b420-5e29a2136869'::UUID, 'cau-ba', '把文件放好 — Câu 把', 'Đưa tân ngữ xác định lên trước động từ.', 1, 25, 'review', 'standard', 15, '["Mô tả xử lý đồ vật"]'::JSONB, 'Sau động từ thường cần kết quả, hướng, số lượng hoặc nơi chốn.', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('c309de57-77b5-5cda-b111-1fa00e28c9a0'::UUID, 'hsk4:整理', '整理', 'zhěnglǐ', 'sắp xếp, chỉnh lý', 'organize', 'intermediate', 'cau-ba', 'động từ', '我先整理桌上的文件。', 'Wǒ xiān zhěnglǐ zhuō shàng de wénjiàn.', 'Tôi sắp xếp tài liệu trên bàn trước.', NULL, 'review', 'd8ccc0bb-980a-57d4-bffe-4c28a6f88a32'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('2eb1b320-13ae-5607-8c1e-39d9d04d2366'::UUID, 'd8ccc0bb-980a-57d4-bffe-4c28a6f88a32'::UUID, 'c309de57-77b5-5cda-b111-1fa00e28c9a0'::UUID, 1, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('198a6013-5077-586d-b9b1-086db756c7b5'::UUID, 'hsk4:材料', '材料', 'cáiliào', 'tài liệu, vật liệu', 'material', 'intermediate', 'cau-ba', 'danh từ', '请把申请材料发给我。', 'Qǐng bǎ shēnqǐng cáiliào fā gěi wǒ.', 'Hãy gửi tài liệu đăng ký cho tôi.', NULL, 'review', 'd8ccc0bb-980a-57d4-bffe-4c28a6f88a32'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('70cad501-9603-5348-b789-9b9eec801c73'::UUID, 'd8ccc0bb-980a-57d4-bffe-4c28a6f88a32'::UUID, '198a6013-5077-586d-b9b1-086db756c7b5'::UUID, 2, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('195b5432-3d99-5e5b-8662-d9eb13c909b2'::UUID, 'hsk4:位置', '位置', 'wèizhi', 'vị trí', 'position', 'intermediate', 'cau-ba', 'danh từ', '我把椅子放回原来的位置。', 'Wǒ bǎ yǐzi fàng huí yuánlái de wèizhi.', 'Tôi đặt ghế về vị trí cũ.', NULL, 'review', 'd8ccc0bb-980a-57d4-bffe-4c28a6f88a32'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('5bb4f9e9-44e2-5e91-a081-2dc2231032a4'::UUID, 'd8ccc0bb-980a-57d4-bffe-4c28a6f88a32'::UUID, '195b5432-3d99-5e5b-8662-d9eb13c909b2'::UUID, 3, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.grammar_lessons (id, content_key, title, pattern, explanation, example_chinese, example_pinyin, example_meaning, level, status, usage_note, content_version)
VALUES ('0007a8f0-0569-5dd8-831b-fce9aa39e785'::UUID, 'hsk4:cau-ba', 'Câu xử lý 把', 'chủ ngữ + 把 + tân ngữ xác định + động từ + kết quả', '把 nhấn mạnh đối tượng được xử lý và kết quả của hành động.', '请把这些材料整理好。', 'Qǐng bǎ zhèxiē cáiliào zhěnglǐ hǎo.', 'Hãy sắp xếp tốt những tài liệu này.', 'intermediate', 'review', NULL, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_grammar (id, lesson_id, grammar_lesson_id, order_index, curriculum_role)
VALUES ('42101e7b-d1e2-51ab-82f9-42b14ff461b4'::UUID, 'd8ccc0bb-980a-57d4-bffe-4c28a6f88a32'::UUID, '0007a8f0-0569-5dd8-831b-fce9aa39e785'::UUID, 1, 'introduced')
ON CONFLICT (lesson_id, grammar_lesson_id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('8b24602a-08ea-5204-a4c9-6addc3edb576'::UUID, 'd8ccc0bb-980a-57d4-bffe-4c28a6f88a32'::UUID, 'vocabulary', 1, 'Từ mới: 整理', NULL, '整理', '整理 (zhěnglǐ) — sắp xếp, chỉnh lý. 我先整理桌上的文件。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"hsk4:整理","chinese":"整理","pinyin":"zhěnglǐ","meaning":"sắp xếp, chỉnh lý","part_of_speech":"động từ","example_chinese":"我先整理桌上的文件。","example_pinyin":"Wǒ xiān zhěnglǐ zhuō shàng de wénjiàn.","example_meaning_vi":"Tôi sắp xếp tài liệu trên bàn trước."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('c14f1b89-649f-5ff3-9696-9588dfc5783b'::UUID, 'd8ccc0bb-980a-57d4-bffe-4c28a6f88a32'::UUID, 'vocabulary', 2, 'Từ mới: 材料', NULL, '材料', '材料 (cáiliào) — tài liệu, vật liệu. 请把申请材料发给我。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"hsk4:材料","chinese":"材料","pinyin":"cáiliào","meaning":"tài liệu, vật liệu","part_of_speech":"danh từ","example_chinese":"请把申请材料发给我。","example_pinyin":"Qǐng bǎ shēnqǐng cáiliào fā gěi wǒ.","example_meaning_vi":"Hãy gửi tài liệu đăng ký cho tôi."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('92f957d4-c7c6-5e2a-babb-184633a20e70'::UUID, 'd8ccc0bb-980a-57d4-bffe-4c28a6f88a32'::UUID, 'vocabulary', 3, 'Từ mới: 位置', NULL, '位置', '位置 (wèizhi) — vị trí. 我把椅子放回原来的位置。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"hsk4:位置","chinese":"位置","pinyin":"wèizhi","meaning":"vị trí","part_of_speech":"danh từ","example_chinese":"我把椅子放回原来的位置。","example_pinyin":"Wǒ bǎ yǐzi fàng huí yuánlái de wèizhi.","example_meaning_vi":"Tôi đặt ghế về vị trí cũ."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('51e37ba3-555a-5ed0-9fc6-0f0400e65d7e'::UUID, 'd8ccc0bb-980a-57d4-bffe-4c28a6f88a32'::UUID, 'multiple_choice', 4, '“整理” có nghĩa phù hợp nhất là gì?', NULL, 'sắp xếp, chỉnh lý', '整理 (zhěnglǐ) nghĩa là “sắp xếp, chỉnh lý”.', NULL, 1, '{"activity_type":"chinese_to_vietnamese","vocabulary_key":"hsk4:整理"}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('3d75aa92-cdb9-5468-82cb-a1d80bd381b6'::UUID, '51e37ba3-555a-5ed0-9fc6-0f0400e65d7e'::UUID, 'vị trí', FALSE, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('c5e89432-369a-5229-96b3-afcb89333b3b'::UUID, '51e37ba3-555a-5ed0-9fc6-0f0400e65d7e'::UUID, 'sắp xếp, chỉnh lý', TRUE, 2)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('419c1cd2-b276-5f44-b40e-4f92c0235213'::UUID, '51e37ba3-555a-5ed0-9fc6-0f0400e65d7e'::UUID, 'tài liệu, vật liệu', FALSE, 3)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('d1bc4bb8-3f9b-5d54-a2b7-8c3479b9981d'::UUID, 'd8ccc0bb-980a-57d4-bffe-4c28a6f88a32'::UUID, 'translation', 5, 'Dịch sang tiếng Trung: “Hãy sắp xếp tốt những tài liệu này.”', NULL, '请把这些材料整理好。', 'Mẫu câu dùng “整理” trong ngữ cảnh của bài.', 'zhěnglǐ', 1, '{"activity_type":"vietnamese_to_chinese","source_lang":"vi","target_lang":"zh","acceptable_answers":["请把这些材料整理好。"]}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('e4f9538b-1a2e-5023-8272-2ed3a6a67b6d'::UUID, 'd8ccc0bb-980a-57d4-bffe-4c28a6f88a32'::UUID, 'sentence_builder', 6, 'Sắp xếp các thành phần thành câu đúng.', NULL, '请把这些材料整理好。', 'Trật tự đúng tạo thành câu “请把这些材料整理好。”.', NULL, 1, '{"activity_type":"sentence_ordering","words":["请","把","这些","材料","整理","好","。"],"correct_order":["请","把","这些","材料","整理","好","。"]}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('c7df0de2-4180-5de3-9436-8b2294614f48'::UUID, 'd8ccc0bb-980a-57d4-bffe-4c28a6f88a32'::UUID, 'multiple_choice', 7, 'Câu 把 nào đầy đủ kết quả?', NULL, '请把这些材料整理好。', '把 nhấn mạnh đối tượng được xử lý và kết quả của hành động.', NULL, 1, '{"activity_type":"grammar_selection","passage":null,"grammar_key":"hsk4:cau-ba"}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('1c42cc49-93c3-5a61-b685-f6fc48ac7b0c'::UUID, 'c7df0de2-4180-5de3-9436-8b2294614f48'::UUID, '请把这些材料整理好。', TRUE, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('8afb2bce-048e-5868-88c4-b3bf18ad8872'::UUID, 'c7df0de2-4180-5de3-9436-8b2294614f48'::UUID, '。好整理材料这些把请', FALSE, 2)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('bdfc9e80-9976-5976-8abf-d65952476d82'::UUID, 'c7df0de2-4180-5de3-9436-8b2294614f48'::UUID, '把这些材料整理好。请', FALSE, 3)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('a86fc367-b691-5fd9-bb9b-e9ec8944edb9'::UUID, 'd8ccc0bb-980a-57d4-bffe-4c28a6f88a32'::UUID, 'speaking', 8, 'Đọc thành tiếng: 请把这些材料整理好。', NULL, '请把这些材料整理好。', 'Đọc chậm, giữ đúng thanh điệu và nhịp của cả câu.', NULL, 1, '{"activity_type":"pronunciation","text":"请把这些材料整理好。","pinyin":"Qǐng bǎ zhèxiē cáiliào zhěnglǐ hǎo."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lessons (id, chapter_id, slug, title, description, order_index, xp_reward, status, lesson_type, estimated_minutes, learning_objectives, cultural_note, content_version)
VALUES ('b9a022a9-aebd-56f2-97f6-083936532394'::UUID, '6b3e3d82-4032-56d6-b420-5e29a2136869'::UUID, 'cau-bi', '航班被取消了 — Câu 被', 'Diễn đạt bị động và tác nhân.', 2, 25, 'review', 'standard', 15, '["Dùng 被 khi tác động quan trọng"]'::JSONB, 'Tác nhân có thể lược khi không rõ hoặc không quan trọng.', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('37fe3216-c55e-59d5-8054-5984af8598e0'::UUID, 'hsk4:通知', '通知', 'tōngzhī', 'thông báo', 'notify; notice', 'intermediate', 'cau-bi', 'động từ/danh từ', '公司通知我们明天开会。', 'Gōngsī tōngzhī wǒmen míngtiān kāihuì.', 'Công ty thông báo ngày mai họp.', NULL, 'review', 'b9a022a9-aebd-56f2-97f6-083936532394'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('69779ed9-d8b1-587f-9851-6cc1a068930e'::UUID, 'b9a022a9-aebd-56f2-97f6-083936532394'::UUID, '37fe3216-c55e-59d5-8054-5984af8598e0'::UUID, 1, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('02269fe7-64d7-5b0a-9d64-7f57fa42b469'::UUID, 'hsk4:取消', '取消', 'qǔxiāo', 'hủy bỏ', 'cancel', 'intermediate', 'cau-bi', 'động từ', '因为大雪，航班取消了。', 'Yīnwèi dàxuě, hángbān qǔxiāo le.', 'Do tuyết lớn, chuyến bay bị hủy.', NULL, 'review', 'b9a022a9-aebd-56f2-97f6-083936532394'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('94fce4af-4e6e-5018-9575-78778ceb2f20'::UUID, 'b9a022a9-aebd-56f2-97f6-083936532394'::UUID, '02269fe7-64d7-5b0a-9d64-7f57fa42b469'::UUID, 2, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('2e0c0e22-8407-58ed-bff5-553b995aef48'::UUID, 'hsk4:影响', '影响', 'yǐngxiǎng', 'ảnh hưởng', 'influence', 'intermediate', 'cau-bi', 'động từ/danh từ', '睡眠不足会影响工作。', 'Shuìmián bùzú huì yǐngxiǎng gōngzuò.', 'Thiếu ngủ sẽ ảnh hưởng công việc.', NULL, 'review', 'b9a022a9-aebd-56f2-97f6-083936532394'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('6b59f49e-c937-5ba2-b058-9afaee35680f'::UUID, 'b9a022a9-aebd-56f2-97f6-083936532394'::UUID, '2e0c0e22-8407-58ed-bff5-553b995aef48'::UUID, 3, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('2ceb949b-f9ce-5eb4-8c19-684e1ba6d2c4'::UUID, 'b9a022a9-aebd-56f2-97f6-083936532394'::UUID, 'c309de57-77b5-5cda-b111-1fa00e28c9a0'::UUID, 4, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('a041721c-b03c-590c-a8b9-7325553b7109'::UUID, 'b9a022a9-aebd-56f2-97f6-083936532394'::UUID, '198a6013-5077-586d-b9b1-086db756c7b5'::UUID, 5, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('abeab6fb-7b80-5346-9cc1-948fdbbb12a5'::UUID, 'b9a022a9-aebd-56f2-97f6-083936532394'::UUID, '195b5432-3d99-5e5b-8662-d9eb13c909b2'::UUID, 6, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.grammar_lessons (id, content_key, title, pattern, explanation, example_chinese, example_pinyin, example_meaning, level, status, usage_note, content_version)
VALUES ('90bcf40a-480f-5a79-a4ae-f2280f294f36'::UUID, 'hsk4:cau-bi', 'Câu bị động với 被', 'đối tượng + 被 + tác nhân + động từ + kết quả', '被 đưa đối tượng chịu tác động lên làm chủ đề.', '航班被航空公司取消了。', 'Hángbān bèi hángkōng gōngsī qǔxiāo le.', 'Chuyến bay đã bị hãng hàng không hủy.', 'intermediate', 'review', NULL, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_grammar (id, lesson_id, grammar_lesson_id, order_index, curriculum_role)
VALUES ('c40a8c57-8b93-5469-b9e5-6c1e15b02705'::UUID, 'b9a022a9-aebd-56f2-97f6-083936532394'::UUID, '90bcf40a-480f-5a79-a4ae-f2280f294f36'::UUID, 1, 'introduced')
ON CONFLICT (lesson_id, grammar_lesson_id) DO NOTHING;

INSERT INTO public.lesson_grammar (id, lesson_id, grammar_lesson_id, order_index, curriculum_role)
VALUES ('88deb19f-00d6-596d-bd00-90819ce59191'::UUID, 'b9a022a9-aebd-56f2-97f6-083936532394'::UUID, '0007a8f0-0569-5dd8-831b-fce9aa39e785'::UUID, 2, 'review')
ON CONFLICT (lesson_id, grammar_lesson_id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('651844f2-69c1-5fec-9701-9bfebc788606'::UUID, 'b9a022a9-aebd-56f2-97f6-083936532394'::UUID, 'vocabulary', 1, 'Từ mới: 通知', NULL, '通知', '通知 (tōngzhī) — thông báo. 公司通知我们明天开会。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"hsk4:通知","chinese":"通知","pinyin":"tōngzhī","meaning":"thông báo","part_of_speech":"động từ/danh từ","example_chinese":"公司通知我们明天开会。","example_pinyin":"Gōngsī tōngzhī wǒmen míngtiān kāihuì.","example_meaning_vi":"Công ty thông báo ngày mai họp."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('a889f2ac-7c77-5337-aae4-5ce507116eb2'::UUID, 'b9a022a9-aebd-56f2-97f6-083936532394'::UUID, 'vocabulary', 2, 'Từ mới: 取消', NULL, '取消', '取消 (qǔxiāo) — hủy bỏ. 因为大雪，航班取消了。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"hsk4:取消","chinese":"取消","pinyin":"qǔxiāo","meaning":"hủy bỏ","part_of_speech":"động từ","example_chinese":"因为大雪，航班取消了。","example_pinyin":"Yīnwèi dàxuě, hángbān qǔxiāo le.","example_meaning_vi":"Do tuyết lớn, chuyến bay bị hủy."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('c261f520-41a8-5eac-8c6e-c012d93858cb'::UUID, 'b9a022a9-aebd-56f2-97f6-083936532394'::UUID, 'vocabulary', 3, 'Từ mới: 影响', NULL, '影响', '影响 (yǐngxiǎng) — ảnh hưởng. 睡眠不足会影响工作。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"hsk4:影响","chinese":"影响","pinyin":"yǐngxiǎng","meaning":"ảnh hưởng","part_of_speech":"động từ/danh từ","example_chinese":"睡眠不足会影响工作。","example_pinyin":"Shuìmián bùzú huì yǐngxiǎng gōngzuò.","example_meaning_vi":"Thiếu ngủ sẽ ảnh hưởng công việc."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('7d56b00a-4c2b-5001-900d-003192accb8f'::UUID, 'b9a022a9-aebd-56f2-97f6-083936532394'::UUID, 'multiple_choice', 4, '“通知” có nghĩa phù hợp nhất là gì?', NULL, 'thông báo', '通知 (tōngzhī) nghĩa là “thông báo”.', NULL, 1, '{"activity_type":"chinese_to_vietnamese","vocabulary_key":"hsk4:通知"}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('f779ab7c-c1d9-583a-8ccc-fb8f829b1e20'::UUID, '7d56b00a-4c2b-5001-900d-003192accb8f'::UUID, 'hủy bỏ', FALSE, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('abe61db4-8f92-5e94-a595-ed8f6046671e'::UUID, '7d56b00a-4c2b-5001-900d-003192accb8f'::UUID, 'ảnh hưởng', FALSE, 2)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('383f50ea-49bf-5eb6-a54e-1b96e9e8d113'::UUID, '7d56b00a-4c2b-5001-900d-003192accb8f'::UUID, 'thông báo', TRUE, 3)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('a301671c-67ec-5f5b-937c-84fd71ac37d6'::UUID, 'b9a022a9-aebd-56f2-97f6-083936532394'::UUID, 'translation', 5, 'Dịch sang tiếng Trung: “Chuyến bay đã bị hãng hàng không hủy.”', NULL, '航班被航空公司取消了。', 'Mẫu câu dùng “通知” trong ngữ cảnh của bài.', 'tōngzhī', 1, '{"activity_type":"vietnamese_to_chinese","source_lang":"vi","target_lang":"zh","acceptable_answers":["航班被航空公司取消了。"]}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('bb458243-892e-5fca-b483-5d6831ef71a1'::UUID, 'b9a022a9-aebd-56f2-97f6-083936532394'::UUID, 'sentence_builder', 6, 'Sắp xếp các thành phần thành câu đúng.', NULL, '航班被航空公司取消了。', 'Trật tự đúng tạo thành câu “航班被航空公司取消了。”.', NULL, 1, '{"activity_type":"sentence_ordering","words":["航班","被","航空公司","取消","了","。"],"correct_order":["航班","被","航空公司","取消","了","。"]}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('5f44a2c3-e4d0-51c2-ae2c-b65bb9225349'::UUID, 'b9a022a9-aebd-56f2-97f6-083936532394'::UUID, 'multiple_choice', 7, 'Câu bị động nào đúng?', NULL, '航班被航空公司取消了。', '被 đưa đối tượng chịu tác động lên làm chủ đề.', NULL, 1, '{"activity_type":"grammar_selection","passage":null,"grammar_key":"hsk4:cau-bi"}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('a53ad5ee-deb6-5bc4-93ec-1edc5cdf020a'::UUID, '5f44a2c3-e4d0-51c2-ae2c-b65bb9225349'::UUID, '航班被航空公司取消了。', TRUE, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('6d091f97-5d41-5d88-bec0-2bb30dc5dd21'::UUID, '5f44a2c3-e4d0-51c2-ae2c-b65bb9225349'::UUID, '。了取消航空公司被航班', FALSE, 2)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('0ecfe6f7-0812-5d42-84e5-46ff872574af'::UUID, '5f44a2c3-e4d0-51c2-ae2c-b65bb9225349'::UUID, '被航空公司取消了。航班', FALSE, 3)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('516bb678-616e-523c-b4ed-dff97bc2cf19'::UUID, 'b9a022a9-aebd-56f2-97f6-083936532394'::UUID, 'speaking', 8, 'Đọc thành tiếng: 航班被航空公司取消了。', NULL, '航班被航空公司取消了。', 'Đọc chậm, giữ đúng thanh điệu và nhịp của cả câu.', NULL, 1, '{"activity_type":"pronunciation","text":"航班被航空公司取消了。","pinyin":"Hángbān bèi hángkōng gōngsī qǔxiāo le."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.units (id, course_id, slug, title, description, order_index, status, learning_objectives, content_version)
VALUES ('f26924a8-e2e5-5163-b218-abeb81b8c56f'::UUID, '0803c46d-4027-5447-800b-5752f93da380'::UUID, 'hsk4-van-dung', 'Vận dụng', 'Vận dụng mẫu câu trong ngữ cảnh có ý nghĩa.', 2, 'review', '["Trình bày điều kiện","Tóm tắt ý kiến có liên kết"]'::JSONB, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.chapters (id, unit_id, slug, title, description, order_index, status, learning_objectives, content_version)
VALUES ('acc4dce5-2d08-5c6a-bc5a-b65c81457e0f'::UUID, 'f26924a8-e2e5-5163-b218-abeb81b8c56f'::UUID, 'hsk4-van-dung-chapter', 'Ngữ cảnh thực tế', 'Vận dụng mẫu câu trong ngữ cảnh có ý nghĩa.', 1, 'review', '["Trình bày điều kiện","Tóm tắt ý kiến có liên kết"]'::JSONB, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lessons (id, chapter_id, slug, title, description, order_index, xp_reward, status, lesson_type, estimated_minutes, learning_objectives, cultural_note, content_version)
VALUES ('f4a1283d-bf92-5caa-9afe-67fc37114948'::UUID, 'acc4dce5-2d08-5c6a-bc5a-b65c81457e0f'::UUID, 'dieu-kien', '只要…就… — Điều kiện đủ', 'Nêu điều kiện đủ để có kết quả.', 1, 25, 'review', 'standard', 15, '["Trình bày điều kiện và hệ quả"]'::JSONB, '只有…才… diễn tả điều kiện cần và có sắc thái chặt hơn.', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('83e455d8-1ddb-503c-8cf9-297829c530cf'::UUID, 'hsk4:条件', '条件', 'tiáojiàn', 'điều kiện', 'condition', 'intermediate', 'dieu-kien', 'danh từ', '这个工作条件很不错。', 'Zhège gōngzuò tiáojiàn hěn búcuò.', 'Điều kiện công việc này khá tốt.', NULL, 'review', 'f4a1283d-bf92-5caa-9afe-67fc37114948'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('5348e961-d083-5879-abcb-efe3790d2367'::UUID, 'f4a1283d-bf92-5caa-9afe-67fc37114948'::UUID, '83e455d8-1ddb-503c-8cf9-297829c530cf'::UUID, 1, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('bfa10e75-9c1c-5ce8-9823-1f8c8b1e5e85'::UUID, 'hsk4:坚持', '坚持', 'jiānchí', 'kiên trì', 'persist', 'intermediate', 'dieu-kien', 'động từ', '只要坚持练习，就会进步。', 'Zhǐyào jiānchí liànxí, jiù huì jìnbù.', 'Chỉ cần kiên trì luyện tập thì sẽ tiến bộ.', NULL, 'review', 'f4a1283d-bf92-5caa-9afe-67fc37114948'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('b4ac8634-12a3-5e13-a3ff-b6b4f453a30b'::UUID, 'f4a1283d-bf92-5caa-9afe-67fc37114948'::UUID, 'bfa10e75-9c1c-5ce8-9823-1f8c8b1e5e85'::UUID, 2, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('4ca7228a-f6bd-51ba-a098-b6889c4af04c'::UUID, 'hsk4:成功', '成功', 'chénggōng', 'thành công', 'succeed; success', 'intermediate', 'dieu-kien', 'động từ/danh từ', '团队终于成功完成任务。', 'Tuánduì zhōngyú chénggōng wánchéng rènwu.', 'Nhóm cuối cùng đã hoàn thành nhiệm vụ thành công.', NULL, 'review', 'f4a1283d-bf92-5caa-9afe-67fc37114948'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('90a365b0-be1a-5016-8ae7-1475971d56f5'::UUID, 'f4a1283d-bf92-5caa-9afe-67fc37114948'::UUID, '4ca7228a-f6bd-51ba-a098-b6889c4af04c'::UUID, 3, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('bed87d5f-8b28-5ec7-ab5f-5ce6e47579d9'::UUID, 'f4a1283d-bf92-5caa-9afe-67fc37114948'::UUID, '37fe3216-c55e-59d5-8054-5984af8598e0'::UUID, 4, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('a627b407-3013-52dc-b1d4-4960a02cc6a4'::UUID, 'f4a1283d-bf92-5caa-9afe-67fc37114948'::UUID, '02269fe7-64d7-5b0a-9d64-7f57fa42b469'::UUID, 5, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('f6fd8a68-224c-532c-8e11-7afe43acebf6'::UUID, 'f4a1283d-bf92-5caa-9afe-67fc37114948'::UUID, '2e0c0e22-8407-58ed-bff5-553b995aef48'::UUID, 6, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.grammar_lessons (id, content_key, title, pattern, explanation, example_chinese, example_pinyin, example_meaning, level, status, usage_note, content_version)
VALUES ('46a8cd98-4047-50b7-a1a2-624d927552db'::UUID, 'hsk4:dieu-kien', 'Điều kiện với 只要', '只要 + điều kiện，就 + kết quả', '只要 nhấn mạnh điều kiện tối thiểu đủ để kết quả xảy ra.', '只要认真准备，就能成功。', 'Zhǐyào rènzhēn zhǔnbèi, jiù néng chénggōng.', 'Chỉ cần chuẩn bị nghiêm túc thì có thể thành công.', 'intermediate', 'review', NULL, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_grammar (id, lesson_id, grammar_lesson_id, order_index, curriculum_role)
VALUES ('aff142bf-1b03-5b66-83c4-c78eb6156a8c'::UUID, 'f4a1283d-bf92-5caa-9afe-67fc37114948'::UUID, '46a8cd98-4047-50b7-a1a2-624d927552db'::UUID, 1, 'introduced')
ON CONFLICT (lesson_id, grammar_lesson_id) DO NOTHING;

INSERT INTO public.lesson_grammar (id, lesson_id, grammar_lesson_id, order_index, curriculum_role)
VALUES ('95cbff13-0ddb-5d06-a083-3480032f33ce'::UUID, 'f4a1283d-bf92-5caa-9afe-67fc37114948'::UUID, '90bcf40a-480f-5a79-a4ae-f2280f294f36'::UUID, 2, 'review')
ON CONFLICT (lesson_id, grammar_lesson_id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('56db7be9-d32b-57a5-8afb-2fbc0195bff8'::UUID, 'f4a1283d-bf92-5caa-9afe-67fc37114948'::UUID, 'vocabulary', 1, 'Từ mới: 条件', NULL, '条件', '条件 (tiáojiàn) — điều kiện. 这个工作条件很不错。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"hsk4:条件","chinese":"条件","pinyin":"tiáojiàn","meaning":"điều kiện","part_of_speech":"danh từ","example_chinese":"这个工作条件很不错。","example_pinyin":"Zhège gōngzuò tiáojiàn hěn búcuò.","example_meaning_vi":"Điều kiện công việc này khá tốt."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('29f7e400-caef-58c3-b645-1d0423d9e1cf'::UUID, 'f4a1283d-bf92-5caa-9afe-67fc37114948'::UUID, 'vocabulary', 2, 'Từ mới: 坚持', NULL, '坚持', '坚持 (jiānchí) — kiên trì. 只要坚持练习，就会进步。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"hsk4:坚持","chinese":"坚持","pinyin":"jiānchí","meaning":"kiên trì","part_of_speech":"động từ","example_chinese":"只要坚持练习，就会进步。","example_pinyin":"Zhǐyào jiānchí liànxí, jiù huì jìnbù.","example_meaning_vi":"Chỉ cần kiên trì luyện tập thì sẽ tiến bộ."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('a5128d53-2954-5f02-b839-3ffaf010f1f8'::UUID, 'f4a1283d-bf92-5caa-9afe-67fc37114948'::UUID, 'vocabulary', 3, 'Từ mới: 成功', NULL, '成功', '成功 (chénggōng) — thành công. 团队终于成功完成任务。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"hsk4:成功","chinese":"成功","pinyin":"chénggōng","meaning":"thành công","part_of_speech":"động từ/danh từ","example_chinese":"团队终于成功完成任务。","example_pinyin":"Tuánduì zhōngyú chénggōng wánchéng rènwu.","example_meaning_vi":"Nhóm cuối cùng đã hoàn thành nhiệm vụ thành công."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('2a57fef9-6296-52a8-8da8-469695eab494'::UUID, 'f4a1283d-bf92-5caa-9afe-67fc37114948'::UUID, 'multiple_choice', 4, '“条件” có nghĩa phù hợp nhất là gì?', NULL, 'điều kiện', '条件 (tiáojiàn) nghĩa là “điều kiện”.', NULL, 1, '{"activity_type":"chinese_to_vietnamese","vocabulary_key":"hsk4:条件"}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('176ee88f-4c2e-50c3-a4dd-0efbab88d3a1'::UUID, '2a57fef9-6296-52a8-8da8-469695eab494'::UUID, 'điều kiện', TRUE, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('f47b51c3-cf88-5e69-ae94-a5d5c3b45688'::UUID, '2a57fef9-6296-52a8-8da8-469695eab494'::UUID, 'kiên trì', FALSE, 2)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('7be69d72-4d69-5d81-9c70-2ebf8f44d1c5'::UUID, '2a57fef9-6296-52a8-8da8-469695eab494'::UUID, 'thành công', FALSE, 3)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('27b887e4-f359-59ab-a50e-61a202d2e505'::UUID, 'f4a1283d-bf92-5caa-9afe-67fc37114948'::UUID, 'translation', 5, 'Dịch sang tiếng Trung: “Chỉ cần chuẩn bị nghiêm túc thì có thể thành công.”', NULL, '只要认真准备，就能成功。', 'Mẫu câu dùng “条件” trong ngữ cảnh của bài.', 'tiáojiàn', 1, '{"activity_type":"vietnamese_to_chinese","source_lang":"vi","target_lang":"zh","acceptable_answers":["只要认真准备，就能成功。"]}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('1a71084f-5c8a-57a4-8344-76b95c9b5a6b'::UUID, 'f4a1283d-bf92-5caa-9afe-67fc37114948'::UUID, 'sentence_builder', 6, 'Sắp xếp các thành phần thành câu đúng.', NULL, '只要认真准备，就能成功。', 'Trật tự đúng tạo thành câu “只要认真准备，就能成功。”.', NULL, 1, '{"activity_type":"sentence_ordering","words":["只要","认真","准备","，","就","能","成功","。"],"correct_order":["只要","认真","准备","，","就","能","成功","。"]}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('77908581-9e5c-5be3-ac55-90f22b4bf1a6'::UUID, 'f4a1283d-bf92-5caa-9afe-67fc37114948'::UUID, 'multiple_choice', 7, 'Câu nào nêu điều kiện đủ?', NULL, '只要认真准备，就能成功。', '只要 nhấn mạnh điều kiện tối thiểu đủ để kết quả xảy ra.', NULL, 1, '{"activity_type":"grammar_selection","passage":null,"grammar_key":"hsk4:dieu-kien"}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('8087d71d-af86-59c1-b494-469cff1a7f88'::UUID, '77908581-9e5c-5be3-ac55-90f22b4bf1a6'::UUID, '只要认真准备，就能成功。', TRUE, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('21f11003-d340-5300-8053-cbb42fa0e5b3'::UUID, '77908581-9e5c-5be3-ac55-90f22b4bf1a6'::UUID, '。成功能就，准备认真只要', FALSE, 2)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('6a565c30-b95a-534a-bfda-da8576542e94'::UUID, '77908581-9e5c-5be3-ac55-90f22b4bf1a6'::UUID, '认真准备，就能成功。只要', FALSE, 3)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('e7041c7e-4c33-50d3-8371-42b7a73d16be'::UUID, 'f4a1283d-bf92-5caa-9afe-67fc37114948'::UUID, 'speaking', 8, 'Đọc thành tiếng: 只要认真准备，就能成功。', NULL, '只要认真准备，就能成功。', 'Đọc chậm, giữ đúng thanh điệu và nhịp của cả câu.', NULL, 1, '{"activity_type":"pronunciation","text":"只要认真准备，就能成功。","pinyin":"Zhǐyào rènzhēn zhǔnbèi, jiù néng chénggōng."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lessons (id, chapter_id, slug, title, description, order_index, xp_reward, status, lesson_type, estimated_minutes, learning_objectives, cultural_note, content_version)
VALUES ('7c70e966-a465-55d7-9c5e-0fa590e04f49'::UUID, 'acc4dce5-2d08-5c6a-bc5a-b65c81457e0f'::UUID, 'lap-luan', '一方面…另一方面… — Hai mặt', 'Tổ chức ý kiến theo hai phương diện.', 2, 25, 'review', 'standard', 15, '["Trình bày quan điểm cân bằng"]'::JSONB, 'Hai vế nên cùng bàn về một chủ đề và cân xứng về ý.', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('3fb27431-090f-54ae-8862-5dd089aea393'::UUID, 'hsk4:方面', '方面', 'fāngmiàn', 'phương diện', 'aspect', 'intermediate', 'lap-luan', 'danh từ', '我们需要从两个方面考虑。', 'Wǒmen xūyào cóng liǎng ge fāngmiàn kǎolǜ.', 'Chúng ta cần cân nhắc từ hai phương diện.', NULL, 'review', '7c70e966-a465-55d7-9c5e-0fa590e04f49'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('2c98203f-79d5-5169-9dc6-265b5c3f8947'::UUID, '7c70e966-a465-55d7-9c5e-0fa590e04f49'::UUID, '3fb27431-090f-54ae-8862-5dd089aea393'::UUID, 1, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('a35ebfb2-eab5-5c1c-b1d7-c1f84fc7e69b'::UUID, 'hsk4:优点', '优点', 'yōudiǎn', 'ưu điểm', 'advantage', 'intermediate', 'lap-luan', 'danh từ', '这个方案的优点很明显。', 'Zhège fāngàn de yōudiǎn hěn míngxiǎn.', 'Ưu điểm của phương án này rất rõ.', NULL, 'review', '7c70e966-a465-55d7-9c5e-0fa590e04f49'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('9327c222-f070-5aed-826e-e90fdc7cb5fa'::UUID, '7c70e966-a465-55d7-9c5e-0fa590e04f49'::UUID, 'a35ebfb2-eab5-5c1c-b1d7-c1f84fc7e69b'::UUID, 2, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('7eab32f8-d2dd-5b81-b616-650b07a35861'::UUID, 'hsk4:缺点', '缺点', 'quēdiǎn', 'khuyết điểm', 'disadvantage', 'intermediate', 'lap-luan', 'danh từ', '我们也要看到它的缺点。', 'Wǒmen yě yào kàndào tā de quēdiǎn.', 'Chúng ta cũng cần thấy khuyết điểm của nó.', NULL, 'review', '7c70e966-a465-55d7-9c5e-0fa590e04f49'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('c75e3836-984d-5d06-8896-4460a87ef36d'::UUID, '7c70e966-a465-55d7-9c5e-0fa590e04f49'::UUID, '7eab32f8-d2dd-5b81-b616-650b07a35861'::UUID, 3, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('b53bd608-b005-5968-ba54-ffb3c1358abc'::UUID, '7c70e966-a465-55d7-9c5e-0fa590e04f49'::UUID, '83e455d8-1ddb-503c-8cf9-297829c530cf'::UUID, 4, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('1413062c-0c63-54ee-961b-64b1ac1cbc27'::UUID, '7c70e966-a465-55d7-9c5e-0fa590e04f49'::UUID, 'bfa10e75-9c1c-5ce8-9823-1f8c8b1e5e85'::UUID, 5, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('bafb593f-917a-5676-b902-7a852af9b436'::UUID, '7c70e966-a465-55d7-9c5e-0fa590e04f49'::UUID, '4ca7228a-f6bd-51ba-a098-b6889c4af04c'::UUID, 6, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.grammar_lessons (id, content_key, title, pattern, explanation, example_chinese, example_pinyin, example_meaning, level, status, usage_note, content_version)
VALUES ('cc1d354e-efe8-5f1f-96d7-abf5658c829f'::UUID, 'hsk4:lap-luan', 'Hai phương diện', '一方面 A，另一方面 B', 'Cặp nối tổ chức hai khía cạnh song song hoặc đối lập.', '一方面很方便，另一方面成本较高。', 'Yì fāngmiàn hěn fāngbiàn, lìng yì fāngmiàn chéngběn jiào gāo.', 'Một mặt rất tiện, mặt khác chi phí khá cao.', 'intermediate', 'review', NULL, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_grammar (id, lesson_id, grammar_lesson_id, order_index, curriculum_role)
VALUES ('b8fdf6d4-c314-5ac7-b633-4de8301473b6'::UUID, '7c70e966-a465-55d7-9c5e-0fa590e04f49'::UUID, 'cc1d354e-efe8-5f1f-96d7-abf5658c829f'::UUID, 1, 'introduced')
ON CONFLICT (lesson_id, grammar_lesson_id) DO NOTHING;

INSERT INTO public.lesson_grammar (id, lesson_id, grammar_lesson_id, order_index, curriculum_role)
VALUES ('6bf0f8e1-cb9c-5bb5-aad1-b9b01639f507'::UUID, '7c70e966-a465-55d7-9c5e-0fa590e04f49'::UUID, '46a8cd98-4047-50b7-a1a2-624d927552db'::UUID, 2, 'review')
ON CONFLICT (lesson_id, grammar_lesson_id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('4786f6af-8be7-5a0e-b9d9-07f4713da7f2'::UUID, '7c70e966-a465-55d7-9c5e-0fa590e04f49'::UUID, 'vocabulary', 1, 'Từ mới: 方面', NULL, '方面', '方面 (fāngmiàn) — phương diện. 我们需要从两个方面考虑。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"hsk4:方面","chinese":"方面","pinyin":"fāngmiàn","meaning":"phương diện","part_of_speech":"danh từ","example_chinese":"我们需要从两个方面考虑。","example_pinyin":"Wǒmen xūyào cóng liǎng ge fāngmiàn kǎolǜ.","example_meaning_vi":"Chúng ta cần cân nhắc từ hai phương diện."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('227d0912-af01-57ca-a1c0-529abb946e77'::UUID, '7c70e966-a465-55d7-9c5e-0fa590e04f49'::UUID, 'vocabulary', 2, 'Từ mới: 优点', NULL, '优点', '优点 (yōudiǎn) — ưu điểm. 这个方案的优点很明显。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"hsk4:优点","chinese":"优点","pinyin":"yōudiǎn","meaning":"ưu điểm","part_of_speech":"danh từ","example_chinese":"这个方案的优点很明显。","example_pinyin":"Zhège fāngàn de yōudiǎn hěn míngxiǎn.","example_meaning_vi":"Ưu điểm của phương án này rất rõ."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('025eb801-b4a8-589f-b10c-136cbde00e59'::UUID, '7c70e966-a465-55d7-9c5e-0fa590e04f49'::UUID, 'vocabulary', 3, 'Từ mới: 缺点', NULL, '缺点', '缺点 (quēdiǎn) — khuyết điểm. 我们也要看到它的缺点。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"hsk4:缺点","chinese":"缺点","pinyin":"quēdiǎn","meaning":"khuyết điểm","part_of_speech":"danh từ","example_chinese":"我们也要看到它的缺点。","example_pinyin":"Wǒmen yě yào kàndào tā de quēdiǎn.","example_meaning_vi":"Chúng ta cũng cần thấy khuyết điểm của nó."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('0c5270d8-4ac3-559f-b7d3-7c8f09cfebfe'::UUID, '7c70e966-a465-55d7-9c5e-0fa590e04f49'::UUID, 'multiple_choice', 4, '“方面” có nghĩa phù hợp nhất là gì?', NULL, 'phương diện', '方面 (fāngmiàn) nghĩa là “phương diện”.', NULL, 1, '{"activity_type":"chinese_to_vietnamese","vocabulary_key":"hsk4:方面"}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('a1988e71-8c50-5003-8533-e50d41f4eb57'::UUID, '0c5270d8-4ac3-559f-b7d3-7c8f09cfebfe'::UUID, 'khuyết điểm', FALSE, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('e871b970-e018-5e15-bfca-4247ef25c133'::UUID, '0c5270d8-4ac3-559f-b7d3-7c8f09cfebfe'::UUID, 'phương diện', TRUE, 2)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('808ab505-6969-5511-811d-9bf71dda26aa'::UUID, '0c5270d8-4ac3-559f-b7d3-7c8f09cfebfe'::UUID, 'ưu điểm', FALSE, 3)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('8897cdfe-f73f-53b3-923a-ea6918e8fc9d'::UUID, '7c70e966-a465-55d7-9c5e-0fa590e04f49'::UUID, 'translation', 5, 'Dịch sang tiếng Trung: “Một mặt rất tiện, mặt khác chi phí khá cao.”', NULL, '一方面很方便，另一方面成本较高。', 'Mẫu câu dùng “方面” trong ngữ cảnh của bài.', 'fāngmiàn', 1, '{"activity_type":"vietnamese_to_chinese","source_lang":"vi","target_lang":"zh","acceptable_answers":["一方面很方便，另一方面成本较高。"]}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('6db0c05c-ba13-5172-ba40-fd6268100642'::UUID, '7c70e966-a465-55d7-9c5e-0fa590e04f49'::UUID, 'sentence_builder', 6, 'Sắp xếp các thành phần thành câu đúng.', NULL, '一方面很方便，另一方面成本较高。', 'Trật tự đúng tạo thành câu “一方面很方便，另一方面成本较高。”.', NULL, 1, '{"activity_type":"sentence_ordering","words":["一方面","很","方便","，","另一方面","成本","较高","。"],"correct_order":["一方面","很","方便","，","另一方面","成本","较高","。"]}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('b049e63c-feb7-5e5f-83ee-2be207e4a2d4'::UUID, '7c70e966-a465-55d7-9c5e-0fa590e04f49'::UUID, 'multiple_choice', 7, 'Câu nào trình bày hai mặt của vấn đề?', NULL, '一方面很方便，另一方面成本较高。', 'Cặp nối tổ chức hai khía cạnh song song hoặc đối lập.', NULL, 1, '{"activity_type":"grammar_selection","passage":null,"grammar_key":"hsk4:lap-luan"}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('56870ebc-3150-54ae-8101-d85832715e0f'::UUID, 'b049e63c-feb7-5e5f-83ee-2be207e4a2d4'::UUID, '一方面很方便，另一方面成本较高。', TRUE, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('df652054-344d-51b6-bc7c-a6063cd298ef'::UUID, 'b049e63c-feb7-5e5f-83ee-2be207e4a2d4'::UUID, '。较高成本另一方面，方便很一方面', FALSE, 2)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('e7793888-0052-5516-8223-2137feff0c5c'::UUID, 'b049e63c-feb7-5e5f-83ee-2be207e4a2d4'::UUID, '很方便，另一方面成本较高。一方面', FALSE, 3)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('3f822c18-7e00-5ada-836f-cb9ae2410145'::UUID, '7c70e966-a465-55d7-9c5e-0fa590e04f49'::UUID, 'speaking', 8, 'Đọc thành tiếng: 一方面很方便，另一方面成本较高。', NULL, '一方面很方便，另一方面成本较高。', 'Đọc chậm, giữ đúng thanh điệu và nhịp của cả câu.', NULL, 1, '{"activity_type":"pronunciation","text":"一方面很方便，另一方面成本较高。","pinyin":"Yì fāngmiàn hěn fāngbiàn, lìng yì fāngmiàn chéngběn jiào gāo."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.units (id, course_id, slug, title, description, order_index, status, learning_objectives, content_version)
VALUES ('e01ee95d-1b7e-528a-8d74-e64d1c541dfc'::UUID, '0803c46d-4027-5447-800b-5752f93da380'::UUID, 'hsk4-on-tap', 'Ôn tập', 'Kiểm tra và củng cố nội dung đã học.', 3, 'review', '["Ôn từ vựng","Ôn mẫu câu"]'::JSONB, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.chapters (id, unit_id, slug, title, description, order_index, status, learning_objectives, content_version)
VALUES ('47e39b16-6c6c-5d62-afc2-3f01b8c71a12'::UUID, 'e01ee95d-1b7e-528a-8d74-e64d1c541dfc'::UUID, 'hsk4-on-tap-chapter', 'Củng cố lộ trình', 'Kiểm tra và củng cố nội dung đã học.', 1, 'review', '["Ôn từ vựng","Ôn mẫu câu"]'::JSONB, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lessons (id, chapter_id, slug, title, description, order_index, xp_reward, status, lesson_type, estimated_minutes, learning_objectives, cultural_note, content_version)
VALUES ('c7b17e03-d992-55d2-9371-8146821db1d1'::UUID, '47e39b16-6c6c-5d62-afc2-3f01b8c71a12'::UUID, 'hsk4-review', 'Ôn tập HSK 4', 'Củng cố từ vựng, mẫu câu và khả năng diễn đạt của toàn khóa.', 1, 30, 'review', 'review', 18, '["Vận dụng lại từ vựng trọng tâm","Tự kiểm tra mẫu câu đã học"]'::JSONB, NULL, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('d4c1ad52-52c2-5a0e-8647-7e3c6eda2cb3'::UUID, 'c7b17e03-d992-55d2-9371-8146821db1d1'::UUID, '3fb27431-090f-54ae-8862-5dd089aea393'::UUID, 1, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('d12f48f9-c3d0-58bf-a13c-42217723d91d'::UUID, 'c7b17e03-d992-55d2-9371-8146821db1d1'::UUID, 'a35ebfb2-eab5-5c1c-b1d7-c1f84fc7e69b'::UUID, 2, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('eb282b5d-caae-50a5-9f19-531070dda9c8'::UUID, 'c7b17e03-d992-55d2-9371-8146821db1d1'::UUID, '7eab32f8-d2dd-5b81-b616-650b07a35861'::UUID, 3, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_grammar (id, lesson_id, grammar_lesson_id, order_index, curriculum_role)
VALUES ('5789df4e-706e-59d5-a62f-7db201156d4a'::UUID, 'c7b17e03-d992-55d2-9371-8146821db1d1'::UUID, 'cc1d354e-efe8-5f1f-96d7-abf5658c829f'::UUID, 1, 'review')
ON CONFLICT (lesson_id, grammar_lesson_id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('bce78945-6855-592a-a0a7-c62d5b1dac13'::UUID, 'c7b17e03-d992-55d2-9371-8146821db1d1'::UUID, 'multiple_choice', 1, '“方面” có nghĩa phù hợp nhất là gì?', NULL, 'phương diện', '方面 (fāngmiàn) nghĩa là “phương diện”.', NULL, 1, '{"activity_type":"chinese_to_vietnamese","vocabulary_key":"hsk4:方面"}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('1230700c-85b5-5124-baf6-913f7211fac1'::UUID, 'bce78945-6855-592a-a0a7-c62d5b1dac13'::UUID, 'phương diện', TRUE, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('0ccfc268-aad9-5270-b881-2c06f257f395'::UUID, 'bce78945-6855-592a-a0a7-c62d5b1dac13'::UUID, 'ưu điểm', FALSE, 2)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('8783a038-3cdf-5a61-b246-a7485a2ed07e'::UUID, 'bce78945-6855-592a-a0a7-c62d5b1dac13'::UUID, 'khuyết điểm', FALSE, 3)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('8f16686e-4180-534b-8413-fbb2f65b02e9'::UUID, 'c7b17e03-d992-55d2-9371-8146821db1d1'::UUID, 'translation', 2, 'Dịch sang tiếng Trung: “Một mặt rất tiện, mặt khác chi phí khá cao.”', NULL, '一方面很方便，另一方面成本较高。', 'Mẫu câu dùng “方面” trong ngữ cảnh của bài.', 'fāngmiàn', 1, '{"activity_type":"vietnamese_to_chinese","source_lang":"vi","target_lang":"zh","acceptable_answers":["一方面很方便，另一方面成本较高。"]}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('d85b2913-c2fc-553c-8e72-8313d523ddbe'::UUID, 'c7b17e03-d992-55d2-9371-8146821db1d1'::UUID, 'sentence_builder', 3, 'Sắp xếp các thành phần thành câu đúng.', NULL, '一方面很方便，另一方面成本较高。', 'Trật tự đúng tạo thành câu “一方面很方便，另一方面成本较高。”.', NULL, 1, '{"activity_type":"sentence_ordering","words":["一方面","很","方便","，","另一方面","成本","较高","。"],"correct_order":["一方面","很","方便","，","另一方面","成本","较高","。"]}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('9a49bbf7-f4a0-5440-b8be-242ee4705d8d'::UUID, 'c7b17e03-d992-55d2-9371-8146821db1d1'::UUID, 'multiple_choice', 4, 'Câu nào trình bày hai mặt của vấn đề?', NULL, '一方面很方便，另一方面成本较高。', 'Cặp nối tổ chức hai khía cạnh song song hoặc đối lập.', NULL, 1, '{"activity_type":"grammar_selection","passage":null,"grammar_key":"hsk4:lap-luan"}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('016e492e-8e15-5fa0-ad28-b06314ec389c'::UUID, '9a49bbf7-f4a0-5440-b8be-242ee4705d8d'::UUID, '一方面很方便，另一方面成本较高。', TRUE, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('9f5d7b02-eeca-5c22-a95d-be91aa8da397'::UUID, '9a49bbf7-f4a0-5440-b8be-242ee4705d8d'::UUID, '。较高成本另一方面，方便很一方面', FALSE, 2)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('3cefda4a-a537-59eb-8b21-cedf8e61a83d'::UUID, '9a49bbf7-f4a0-5440-b8be-242ee4705d8d'::UUID, '很方便，另一方面成本较高。一方面', FALSE, 3)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('e4535b20-3581-595c-8091-031eea6afa0c'::UUID, 'c7b17e03-d992-55d2-9371-8146821db1d1'::UUID, 'speaking', 5, 'Đọc thành tiếng: 一方面很方便，另一方面成本较高。', NULL, '一方面很方便，另一方面成本较高。', 'Đọc chậm, giữ đúng thanh điệu và nhịp của cả câu.', NULL, 1, '{"activity_type":"pronunciation","text":"一方面很方便，另一方面成本较高。","pinyin":"Yì fāngmiàn hěn fāngbiàn, lìng yì fāngmiàn chéngběn jiào gāo."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.content_batches (id, batch_key, version, migration_name, manifest_checksum, expected_counts)
VALUES ('d1136971-a57a-5bd4-ac61-f6456a49cd44'::UUID, 'batch-05-hsk4', 1, '20260729140000_content_batch_05_hsk4', 'eae8982f2e9949f206b1c24beda2909e9c9945ab7522d1338b3579c7a5af66e4', '{"courses":1,"units":3,"chapters":3,"lessons":5,"vocabulary":12,"grammar":4,"characters":0,"exercises":37,"options":30}'::JSONB)
ON CONFLICT (batch_key, version) DO NOTHING;

DO $content_validation$
BEGIN
  IF (SELECT COUNT(*) FROM public.courses WHERE id = ANY(ARRAY['0803c46d-4027-5447-800b-5752f93da380'::UUID]::UUID[])) <> 1 THEN
    RAISE EXCEPTION 'Content batch batch-05-hsk4 is missing managed courses rows';
  END IF;
  IF (SELECT COUNT(*) FROM public.units WHERE id = ANY(ARRAY['9c974d5d-b12f-5ab6-973c-c2694a338b5a'::UUID, 'f26924a8-e2e5-5163-b218-abeb81b8c56f'::UUID, 'e01ee95d-1b7e-528a-8d74-e64d1c541dfc'::UUID]::UUID[])) <> 3 THEN
    RAISE EXCEPTION 'Content batch batch-05-hsk4 is missing managed units rows';
  END IF;
  IF (SELECT COUNT(*) FROM public.chapters WHERE id = ANY(ARRAY['6b3e3d82-4032-56d6-b420-5e29a2136869'::UUID, 'acc4dce5-2d08-5c6a-bc5a-b65c81457e0f'::UUID, '47e39b16-6c6c-5d62-afc2-3f01b8c71a12'::UUID]::UUID[])) <> 3 THEN
    RAISE EXCEPTION 'Content batch batch-05-hsk4 is missing managed chapters rows';
  END IF;
  IF (SELECT COUNT(*) FROM public.lessons WHERE id = ANY(ARRAY['d8ccc0bb-980a-57d4-bffe-4c28a6f88a32'::UUID, 'b9a022a9-aebd-56f2-97f6-083936532394'::UUID, 'f4a1283d-bf92-5caa-9afe-67fc37114948'::UUID, '7c70e966-a465-55d7-9c5e-0fa590e04f49'::UUID, 'c7b17e03-d992-55d2-9371-8146821db1d1'::UUID]::UUID[])) <> 5 THEN
    RAISE EXCEPTION 'Content batch batch-05-hsk4 is missing managed lessons rows';
  END IF;
  IF (SELECT COUNT(*) FROM public.vocabulary WHERE id = ANY(ARRAY['c309de57-77b5-5cda-b111-1fa00e28c9a0'::UUID, '198a6013-5077-586d-b9b1-086db756c7b5'::UUID, '195b5432-3d99-5e5b-8662-d9eb13c909b2'::UUID, '37fe3216-c55e-59d5-8054-5984af8598e0'::UUID, '02269fe7-64d7-5b0a-9d64-7f57fa42b469'::UUID, '2e0c0e22-8407-58ed-bff5-553b995aef48'::UUID, '83e455d8-1ddb-503c-8cf9-297829c530cf'::UUID, 'bfa10e75-9c1c-5ce8-9823-1f8c8b1e5e85'::UUID, '4ca7228a-f6bd-51ba-a098-b6889c4af04c'::UUID, '3fb27431-090f-54ae-8862-5dd089aea393'::UUID, 'a35ebfb2-eab5-5c1c-b1d7-c1f84fc7e69b'::UUID, '7eab32f8-d2dd-5b81-b616-650b07a35861'::UUID]::UUID[])) <> 12 THEN
    RAISE EXCEPTION 'Content batch batch-05-hsk4 is missing managed vocabulary rows';
  END IF;
  IF (SELECT COUNT(*) FROM public.grammar_lessons WHERE id = ANY(ARRAY['0007a8f0-0569-5dd8-831b-fce9aa39e785'::UUID, '90bcf40a-480f-5a79-a4ae-f2280f294f36'::UUID, '46a8cd98-4047-50b7-a1a2-624d927552db'::UUID, 'cc1d354e-efe8-5f1f-96d7-abf5658c829f'::UUID]::UUID[])) <> 4 THEN
    RAISE EXCEPTION 'Content batch batch-05-hsk4 is missing managed grammar_lessons rows';
  END IF;
  IF (SELECT COUNT(*) FROM public.exercises WHERE id = ANY(ARRAY['8b24602a-08ea-5204-a4c9-6addc3edb576'::UUID, 'c14f1b89-649f-5ff3-9696-9588dfc5783b'::UUID, '92f957d4-c7c6-5e2a-babb-184633a20e70'::UUID, '51e37ba3-555a-5ed0-9fc6-0f0400e65d7e'::UUID, 'd1bc4bb8-3f9b-5d54-a2b7-8c3479b9981d'::UUID, 'e4f9538b-1a2e-5023-8272-2ed3a6a67b6d'::UUID, 'c7df0de2-4180-5de3-9436-8b2294614f48'::UUID, 'a86fc367-b691-5fd9-bb9b-e9ec8944edb9'::UUID, '651844f2-69c1-5fec-9701-9bfebc788606'::UUID, 'a889f2ac-7c77-5337-aae4-5ce507116eb2'::UUID, 'c261f520-41a8-5eac-8c6e-c012d93858cb'::UUID, '7d56b00a-4c2b-5001-900d-003192accb8f'::UUID, 'a301671c-67ec-5f5b-937c-84fd71ac37d6'::UUID, 'bb458243-892e-5fca-b483-5d6831ef71a1'::UUID, '5f44a2c3-e4d0-51c2-ae2c-b65bb9225349'::UUID, '516bb678-616e-523c-b4ed-dff97bc2cf19'::UUID, '56db7be9-d32b-57a5-8afb-2fbc0195bff8'::UUID, '29f7e400-caef-58c3-b645-1d0423d9e1cf'::UUID, 'a5128d53-2954-5f02-b839-3ffaf010f1f8'::UUID, '2a57fef9-6296-52a8-8da8-469695eab494'::UUID, '27b887e4-f359-59ab-a50e-61a202d2e505'::UUID, '1a71084f-5c8a-57a4-8344-76b95c9b5a6b'::UUID, '77908581-9e5c-5be3-ac55-90f22b4bf1a6'::UUID, 'e7041c7e-4c33-50d3-8371-42b7a73d16be'::UUID, '4786f6af-8be7-5a0e-b9d9-07f4713da7f2'::UUID, '227d0912-af01-57ca-a1c0-529abb946e77'::UUID, '025eb801-b4a8-589f-b10c-136cbde00e59'::UUID, '0c5270d8-4ac3-559f-b7d3-7c8f09cfebfe'::UUID, '8897cdfe-f73f-53b3-923a-ea6918e8fc9d'::UUID, '6db0c05c-ba13-5172-ba40-fd6268100642'::UUID, 'b049e63c-feb7-5e5f-83ee-2be207e4a2d4'::UUID, '3f822c18-7e00-5ada-836f-cb9ae2410145'::UUID, 'bce78945-6855-592a-a0a7-c62d5b1dac13'::UUID, '8f16686e-4180-534b-8413-fbb2f65b02e9'::UUID, 'd85b2913-c2fc-553c-8e72-8313d523ddbe'::UUID, '9a49bbf7-f4a0-5440-b8be-242ee4705d8d'::UUID, 'e4535b20-3581-595c-8091-031eea6afa0c'::UUID]::UUID[])) <> 37 THEN
    RAISE EXCEPTION 'Content batch batch-05-hsk4 is missing managed exercises rows';
  END IF;
  IF (SELECT COUNT(*) FROM public.exercise_options WHERE id = ANY(ARRAY['3d75aa92-cdb9-5468-82cb-a1d80bd381b6'::UUID, 'c5e89432-369a-5229-96b3-afcb89333b3b'::UUID, '419c1cd2-b276-5f44-b40e-4f92c0235213'::UUID, '1c42cc49-93c3-5a61-b685-f6fc48ac7b0c'::UUID, '8afb2bce-048e-5868-88c4-b3bf18ad8872'::UUID, 'bdfc9e80-9976-5976-8abf-d65952476d82'::UUID, 'f779ab7c-c1d9-583a-8ccc-fb8f829b1e20'::UUID, 'abe61db4-8f92-5e94-a595-ed8f6046671e'::UUID, '383f50ea-49bf-5eb6-a54e-1b96e9e8d113'::UUID, 'a53ad5ee-deb6-5bc4-93ec-1edc5cdf020a'::UUID, '6d091f97-5d41-5d88-bec0-2bb30dc5dd21'::UUID, '0ecfe6f7-0812-5d42-84e5-46ff872574af'::UUID, '176ee88f-4c2e-50c3-a4dd-0efbab88d3a1'::UUID, 'f47b51c3-cf88-5e69-ae94-a5d5c3b45688'::UUID, '7be69d72-4d69-5d81-9c70-2ebf8f44d1c5'::UUID, '8087d71d-af86-59c1-b494-469cff1a7f88'::UUID, '21f11003-d340-5300-8053-cbb42fa0e5b3'::UUID, '6a565c30-b95a-534a-bfda-da8576542e94'::UUID, 'a1988e71-8c50-5003-8533-e50d41f4eb57'::UUID, 'e871b970-e018-5e15-bfca-4247ef25c133'::UUID, '808ab505-6969-5511-811d-9bf71dda26aa'::UUID, '56870ebc-3150-54ae-8101-d85832715e0f'::UUID, 'df652054-344d-51b6-bc7c-a6063cd298ef'::UUID, 'e7793888-0052-5516-8223-2137feff0c5c'::UUID, '1230700c-85b5-5124-baf6-913f7211fac1'::UUID, '0ccfc268-aad9-5270-b881-2c06f257f395'::UUID, '8783a038-3cdf-5a61-b246-a7485a2ed07e'::UUID, '016e492e-8e15-5fa0-ad28-b06314ec389c'::UUID, '9f5d7b02-eeca-5c22-a95d-be91aa8da397'::UUID, '3cefda4a-a537-59eb-8b21-cedf8e61a83d'::UUID]::UUID[])) <> 30 THEN
    RAISE EXCEPTION 'Content batch batch-05-hsk4 is missing managed exercise_options rows';
  END IF;
  IF EXISTS (
    SELECT 1 FROM public.lessons AS lesson
    WHERE lesson.id = ANY(ARRAY['d8ccc0bb-980a-57d4-bffe-4c28a6f88a32'::UUID, 'b9a022a9-aebd-56f2-97f6-083936532394'::UUID, 'f4a1283d-bf92-5caa-9afe-67fc37114948'::UUID, '7c70e966-a465-55d7-9c5e-0fa590e04f49'::UUID, 'c7b17e03-d992-55d2-9371-8146821db1d1'::UUID]::UUID[])
      AND NOT EXISTS (
        SELECT 1 FROM public.exercises AS exercise
        WHERE exercise.lesson_id = lesson.id
      )
  ) THEN
    RAISE EXCEPTION 'Content batch batch-05-hsk4 contains a lesson without exercises';
  END IF;
  IF EXISTS (
    SELECT 1
    FROM public.lessons AS lesson
    JOIN public.exercises AS exercise ON exercise.lesson_id = lesson.id
    WHERE lesson.id = ANY(ARRAY['d8ccc0bb-980a-57d4-bffe-4c28a6f88a32'::UUID, 'b9a022a9-aebd-56f2-97f6-083936532394'::UUID, 'f4a1283d-bf92-5caa-9afe-67fc37114948'::UUID, '7c70e966-a465-55d7-9c5e-0fa590e04f49'::UUID, 'c7b17e03-d992-55d2-9371-8146821db1d1'::UUID]::UUID[])
      AND lesson.status = 'published'
      AND exercise.exercise_type = 'listening'
      AND NULLIF(BTRIM(exercise.question_audio_url), '') IS NULL
  ) THEN
    RAISE EXCEPTION 'Published listening exercise is missing playable audio';
  END IF;
  IF EXISTS (
    SELECT 1
    FROM public.exercises AS exercise
    WHERE exercise.id = ANY(ARRAY['8b24602a-08ea-5204-a4c9-6addc3edb576'::UUID, 'c14f1b89-649f-5ff3-9696-9588dfc5783b'::UUID, '92f957d4-c7c6-5e2a-babb-184633a20e70'::UUID, '51e37ba3-555a-5ed0-9fc6-0f0400e65d7e'::UUID, 'd1bc4bb8-3f9b-5d54-a2b7-8c3479b9981d'::UUID, 'e4f9538b-1a2e-5023-8272-2ed3a6a67b6d'::UUID, 'c7df0de2-4180-5de3-9436-8b2294614f48'::UUID, 'a86fc367-b691-5fd9-bb9b-e9ec8944edb9'::UUID, '651844f2-69c1-5fec-9701-9bfebc788606'::UUID, 'a889f2ac-7c77-5337-aae4-5ce507116eb2'::UUID, 'c261f520-41a8-5eac-8c6e-c012d93858cb'::UUID, '7d56b00a-4c2b-5001-900d-003192accb8f'::UUID, 'a301671c-67ec-5f5b-937c-84fd71ac37d6'::UUID, 'bb458243-892e-5fca-b483-5d6831ef71a1'::UUID, '5f44a2c3-e4d0-51c2-ae2c-b65bb9225349'::UUID, '516bb678-616e-523c-b4ed-dff97bc2cf19'::UUID, '56db7be9-d32b-57a5-8afb-2fbc0195bff8'::UUID, '29f7e400-caef-58c3-b645-1d0423d9e1cf'::UUID, 'a5128d53-2954-5f02-b839-3ffaf010f1f8'::UUID, '2a57fef9-6296-52a8-8da8-469695eab494'::UUID, '27b887e4-f359-59ab-a50e-61a202d2e505'::UUID, '1a71084f-5c8a-57a4-8344-76b95c9b5a6b'::UUID, '77908581-9e5c-5be3-ac55-90f22b4bf1a6'::UUID, 'e7041c7e-4c33-50d3-8371-42b7a73d16be'::UUID, '4786f6af-8be7-5a0e-b9d9-07f4713da7f2'::UUID, '227d0912-af01-57ca-a1c0-529abb946e77'::UUID, '025eb801-b4a8-589f-b10c-136cbde00e59'::UUID, '0c5270d8-4ac3-559f-b7d3-7c8f09cfebfe'::UUID, '8897cdfe-f73f-53b3-923a-ea6918e8fc9d'::UUID, '6db0c05c-ba13-5172-ba40-fd6268100642'::UUID, 'b049e63c-feb7-5e5f-83ee-2be207e4a2d4'::UUID, '3f822c18-7e00-5ada-836f-cb9ae2410145'::UUID, 'bce78945-6855-592a-a0a7-c62d5b1dac13'::UUID, '8f16686e-4180-534b-8413-fbb2f65b02e9'::UUID, 'd85b2913-c2fc-553c-8e72-8313d523ddbe'::UUID, '9a49bbf7-f4a0-5440-b8be-242ee4705d8d'::UUID, 'e4535b20-3581-595c-8091-031eea6afa0c'::UUID]::UUID[])
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
    WHERE link.lesson_id = ANY(ARRAY['d8ccc0bb-980a-57d4-bffe-4c28a6f88a32'::UUID, 'b9a022a9-aebd-56f2-97f6-083936532394'::UUID, 'f4a1283d-bf92-5caa-9afe-67fc37114948'::UUID, '7c70e966-a465-55d7-9c5e-0fa590e04f49'::UUID, 'c7b17e03-d992-55d2-9371-8146821db1d1'::UUID]::UUID[])
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
