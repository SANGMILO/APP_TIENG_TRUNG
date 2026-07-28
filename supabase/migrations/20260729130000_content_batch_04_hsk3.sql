-- Generated from content/manifests/04_hsk3.json.
-- Do not hand-edit this migration; edit the manifest and regenerate.
-- Additive and idempotent: deterministic IDs plus ON CONFLICT DO NOTHING.

BEGIN;

INSERT INTO public.courses (id, slug, title, title_zh, description, level, status, order_index, learning_objectives, estimated_minutes, content_version)
VALUES ('56553c03-c566-5e1a-8cd4-d6364302cca9'::UUID, 'hsk-3', 'HSK 3', 'HSK 三级', 'Phát triển kể chuyện, kết quả và quan hệ nguyên nhân.', 'intermediate', 'review', 4, '["Kể lại sự việc có trình tự","Dùng bổ ngữ kết quả","Giải thích nguyên nhân và lựa chọn"]'::JSONB, 78, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.units (id, course_id, slug, title, description, order_index, status, learning_objectives, content_version)
VALUES ('d13fc56d-93ec-5986-bb8d-7002592db167'::UUID, '56553c03-c566-5e1a-8cd4-d6364302cca9'::UUID, 'hsk3-nen-tang', 'Nền tảng', 'Xây dựng ngôn ngữ cốt lõi của lộ trình.', 1, 'review', '["Kể lại sự việc có trình tự","Dùng bổ ngữ kết quả"]'::JSONB, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.chapters (id, unit_id, slug, title, description, order_index, status, learning_objectives, content_version)
VALUES ('3b4744d2-71f5-543f-8529-2156db38a5f6'::UUID, 'd13fc56d-93ec-5986-bb8d-7002592db167'::UUID, 'hsk3-nen-tang-chapter', 'Khái niệm cốt lõi', 'Xây dựng ngôn ngữ cốt lõi của lộ trình.', 1, 'review', '["Kể lại sự việc có trình tự","Dùng bổ ngữ kết quả"]'::JSONB, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lessons (id, chapter_id, slug, title, description, order_index, xp_reward, status, lesson_type, estimated_minutes, learning_objectives, cultural_note, content_version)
VALUES ('b0494aea-58d9-5ac9-a62c-c371d24f7bf6'::UUID, '3b4744d2-71f5-543f-8529-2156db38a5f6'::UUID, 'ket-qua', '听懂了 — Bổ ngữ kết quả', 'Diễn đạt kết quả đạt được sau hành động.', 1, 25, 'review', 'standard', 15, '["Phân biệt hành động và kết quả"]'::JSONB, '听了 chỉ việc đã nghe; 听懂了 mới xác nhận đã hiểu.', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('893fbf6b-c66a-51fe-93a8-50acc4b9bad6'::UUID, 'hsk3:完成', '完成', 'wánchéng', 'hoàn thành', 'complete', 'intermediate', 'ket-qua', 'động từ', '我已经完成作业了。', 'Wǒ yǐjīng wánchéng zuòyè le.', 'Tôi đã hoàn thành bài tập.', NULL, 'review', 'b0494aea-58d9-5ac9-a62c-c371d24f7bf6'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('2b1caba4-5f71-5012-bd99-bcce3f2843fa'::UUID, 'b0494aea-58d9-5ac9-a62c-c371d24f7bf6'::UUID, '893fbf6b-c66a-51fe-93a8-50acc4b9bad6'::UUID, 1, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('e4a1b95a-b638-5521-8788-f91c81ac76f6'::UUID, 'hsk3:清楚', '清楚', 'qīngchu', 'rõ ràng', 'clear', 'intermediate', 'ket-qua', 'tính từ', '老师讲得很清楚。', 'Lǎoshī jiǎng de hěn qīngchu.', 'Giáo viên giảng rất rõ.', NULL, 'review', 'b0494aea-58d9-5ac9-a62c-c371d24f7bf6'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('3072e5aa-42f7-5157-9c33-3a8f0b1b13d6'::UUID, 'b0494aea-58d9-5ac9-a62c-c371d24f7bf6'::UUID, 'e4a1b95a-b638-5521-8788-f91c81ac76f6'::UUID, 2, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('7576e95c-57ab-50c6-b0d1-01cdda9d5a94'::UUID, 'hsk3:发现', '发现', 'fāxiàn', 'phát hiện', 'discover', 'intermediate', 'ket-qua', 'động từ', '我发现钥匙在包里。', 'Wǒ fāxiàn yàoshi zài bāo lǐ.', 'Tôi phát hiện chìa khóa ở trong túi.', NULL, 'review', 'b0494aea-58d9-5ac9-a62c-c371d24f7bf6'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('2b1ed95c-22fe-529a-9d29-2f56cc4ad948'::UUID, 'b0494aea-58d9-5ac9-a62c-c371d24f7bf6'::UUID, '7576e95c-57ab-50c6-b0d1-01cdda9d5a94'::UUID, 3, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.grammar_lessons (id, content_key, title, pattern, explanation, example_chinese, example_pinyin, example_meaning, level, status, usage_note, content_version)
VALUES ('631171d6-56be-5e8f-9a6c-7f629a148b21'::UUID, 'hsk3:ket-qua', 'Bổ ngữ kết quả 懂', 'động từ + 懂', '懂 sau động từ cho biết đã hiểu được nội dung.', '老师的话我听懂了。', 'Lǎoshī de huà wǒ tīngdǒng le.', 'Tôi đã nghe hiểu lời của giáo viên.', 'intermediate', 'review', NULL, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_grammar (id, lesson_id, grammar_lesson_id, order_index, curriculum_role)
VALUES ('2a2fd74f-c4bf-543e-b182-1fb9cebfcca6'::UUID, 'b0494aea-58d9-5ac9-a62c-c371d24f7bf6'::UUID, '631171d6-56be-5e8f-9a6c-7f629a148b21'::UUID, 1, 'introduced')
ON CONFLICT (lesson_id, grammar_lesson_id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('7599d655-f0f5-5080-bdf6-bbd330e7052c'::UUID, 'b0494aea-58d9-5ac9-a62c-c371d24f7bf6'::UUID, 'vocabulary', 1, 'Từ mới: 完成', NULL, '完成', '完成 (wánchéng) — hoàn thành. 我已经完成作业了。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"hsk3:完成","chinese":"完成","pinyin":"wánchéng","meaning":"hoàn thành","part_of_speech":"động từ","example_chinese":"我已经完成作业了。","example_pinyin":"Wǒ yǐjīng wánchéng zuòyè le.","example_meaning_vi":"Tôi đã hoàn thành bài tập."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('56653638-089e-5e1a-8daa-345889b1ee9d'::UUID, 'b0494aea-58d9-5ac9-a62c-c371d24f7bf6'::UUID, 'vocabulary', 2, 'Từ mới: 清楚', NULL, '清楚', '清楚 (qīngchu) — rõ ràng. 老师讲得很清楚。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"hsk3:清楚","chinese":"清楚","pinyin":"qīngchu","meaning":"rõ ràng","part_of_speech":"tính từ","example_chinese":"老师讲得很清楚。","example_pinyin":"Lǎoshī jiǎng de hěn qīngchu.","example_meaning_vi":"Giáo viên giảng rất rõ."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('ff57124c-f601-52cc-b397-8904cc41ead5'::UUID, 'b0494aea-58d9-5ac9-a62c-c371d24f7bf6'::UUID, 'vocabulary', 3, 'Từ mới: 发现', NULL, '发现', '发现 (fāxiàn) — phát hiện. 我发现钥匙在包里。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"hsk3:发现","chinese":"发现","pinyin":"fāxiàn","meaning":"phát hiện","part_of_speech":"động từ","example_chinese":"我发现钥匙在包里。","example_pinyin":"Wǒ fāxiàn yàoshi zài bāo lǐ.","example_meaning_vi":"Tôi phát hiện chìa khóa ở trong túi."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('027bbc06-f34a-5648-aea4-dc68613cf957'::UUID, 'b0494aea-58d9-5ac9-a62c-c371d24f7bf6'::UUID, 'multiple_choice', 4, '“完成” có nghĩa phù hợp nhất là gì?', NULL, 'hoàn thành', '完成 (wánchéng) nghĩa là “hoàn thành”.', NULL, 1, '{"activity_type":"chinese_to_vietnamese","vocabulary_key":"hsk3:完成"}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('e4ff2fb4-7ff3-5253-af9e-b993bb1b32ba'::UUID, '027bbc06-f34a-5648-aea4-dc68613cf957'::UUID, 'rõ ràng', FALSE, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('05904581-ffa3-52c2-935b-83b6c94e823a'::UUID, '027bbc06-f34a-5648-aea4-dc68613cf957'::UUID, 'phát hiện', FALSE, 2)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('e6e56f0a-9c1a-593a-a806-b5d966f7eead'::UUID, '027bbc06-f34a-5648-aea4-dc68613cf957'::UUID, 'hoàn thành', TRUE, 3)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('df8baf12-3976-5857-8473-ca74c4c35070'::UUID, 'b0494aea-58d9-5ac9-a62c-c371d24f7bf6'::UUID, 'translation', 5, 'Dịch sang tiếng Trung: “Tôi đã nghe hiểu lời của giáo viên.”', NULL, '老师的话我听懂了。', 'Mẫu câu dùng “完成” trong ngữ cảnh của bài.', 'wánchéng', 1, '{"activity_type":"vietnamese_to_chinese","source_lang":"vi","target_lang":"zh","acceptable_answers":["老师的话我听懂了。"]}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('c81a44d4-01dc-56d4-a95d-3fec89bf3755'::UUID, 'b0494aea-58d9-5ac9-a62c-c371d24f7bf6'::UUID, 'sentence_builder', 6, 'Sắp xếp các thành phần thành câu đúng.', NULL, '老师的话我听懂了。', 'Trật tự đúng tạo thành câu “老师的话我听懂了。”.', NULL, 1, '{"activity_type":"sentence_ordering","words":["老师","的","话","我","听懂","了","。"],"correct_order":["老师","的","话","我","听懂","了","。"]}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('2ad13705-8aef-52e6-bd06-32f2f0d3f993'::UUID, 'b0494aea-58d9-5ac9-a62c-c371d24f7bf6'::UUID, 'multiple_choice', 7, 'Câu nào nhấn mạnh kết quả nghe hiểu?', NULL, '老师的话我听懂了。', '懂 sau động từ cho biết đã hiểu được nội dung.', NULL, 1, '{"activity_type":"grammar_selection","passage":null,"grammar_key":"hsk3:ket-qua"}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('135c2e52-5e48-532a-9ed4-dad0d3bf61e6'::UUID, '2ad13705-8aef-52e6-bd06-32f2f0d3f993'::UUID, '老师的话我听懂了。', TRUE, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('ad8bb110-767e-51e8-9c6d-7a1d5e0a568e'::UUID, '2ad13705-8aef-52e6-bd06-32f2f0d3f993'::UUID, '。了听懂我话的老师', FALSE, 2)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('084c2ee5-8a8a-57e1-9f66-463474095d97'::UUID, '2ad13705-8aef-52e6-bd06-32f2f0d3f993'::UUID, '的话我听懂了。老师', FALSE, 3)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('82df1330-3929-559e-8404-3cd20cf40d55'::UUID, 'b0494aea-58d9-5ac9-a62c-c371d24f7bf6'::UUID, 'speaking', 8, 'Đọc thành tiếng: 老师的话我听懂了。', NULL, '老师的话我听懂了。', 'Đọc chậm, giữ đúng thanh điệu và nhịp của cả câu.', NULL, 1, '{"activity_type":"pronunciation","text":"老师的话我听懂了。","pinyin":"Lǎoshī de huà wǒ tīngdǒng le."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lessons (id, chapter_id, slug, title, description, order_index, xp_reward, status, lesson_type, estimated_minutes, learning_objectives, cultural_note, content_version)
VALUES ('1958b3c8-38d0-5ce8-8206-e177270eb99b'::UUID, '3b4744d2-71f5-543f-8529-2156db38a5f6'::UUID, 'nguyen-nhan', '因为…所以… — Nguyên nhân', 'Nối nguyên nhân và kết quả.', 2, 25, 'review', 'standard', 15, '["Giải thích quyết định"]'::JSONB, 'Trong khẩu ngữ có thể lược một vế nối khi quan hệ đã rõ.', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('304167e7-e82b-5ed8-b836-0f0b72ce8683'::UUID, 'hsk3:原因', '原因', 'yuányīn', 'nguyên nhân', 'reason', 'intermediate', 'nguyen-nhan', 'danh từ', '我们正在调查原因。', 'Wǒmen zhèngzài diàochá yuányīn.', 'Chúng tôi đang tìm hiểu nguyên nhân.', NULL, 'review', '1958b3c8-38d0-5ce8-8206-e177270eb99b'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('8a16cbcf-d391-5e95-8dc4-6d26da6802fa'::UUID, '1958b3c8-38d0-5ce8-8206-e177270eb99b'::UUID, '304167e7-e82b-5ed8-b836-0f0b72ce8683'::UUID, 1, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('52f4e440-03fd-5cda-864b-c82f4720d53c'::UUID, 'hsk3:决定', '决定', 'juédìng', 'quyết định', 'decide; decision', 'intermediate', 'nguyen-nhan', 'động từ/danh từ', '她决定明年留学。', 'Tā juédìng míngnián liúxué.', 'Cô ấy quyết định năm sau đi du học.', NULL, 'review', '1958b3c8-38d0-5ce8-8206-e177270eb99b'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('4ad000cd-c596-55c5-ab69-1c74b0debaa6'::UUID, '1958b3c8-38d0-5ce8-8206-e177270eb99b'::UUID, '52f4e440-03fd-5cda-864b-c82f4720d53c'::UUID, 2, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('19f00d51-4b18-59e9-b794-004932f04d15'::UUID, 'hsk3:所以', '所以', 'suǒyǐ', 'vì vậy', 'therefore', 'intermediate', 'nguyen-nhan', 'liên từ', '路上很堵，所以我迟到了。', 'Lùshang hěn dǔ, suǒyǐ wǒ chídào le.', 'Đường tắc nên tôi đến muộn.', NULL, 'review', '1958b3c8-38d0-5ce8-8206-e177270eb99b'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('20076c3b-5ac1-5119-ba14-c709d34fa789'::UUID, '1958b3c8-38d0-5ce8-8206-e177270eb99b'::UUID, '19f00d51-4b18-59e9-b794-004932f04d15'::UUID, 3, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('33c6deff-0e15-5781-8911-2e1a72795d47'::UUID, '1958b3c8-38d0-5ce8-8206-e177270eb99b'::UUID, '893fbf6b-c66a-51fe-93a8-50acc4b9bad6'::UUID, 4, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('484d8819-6205-582b-b3b0-a2eefe02b11b'::UUID, '1958b3c8-38d0-5ce8-8206-e177270eb99b'::UUID, 'e4a1b95a-b638-5521-8788-f91c81ac76f6'::UUID, 5, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('696d2847-458d-5d4c-a714-358699ad0a87'::UUID, '1958b3c8-38d0-5ce8-8206-e177270eb99b'::UUID, '7576e95c-57ab-50c6-b0d1-01cdda9d5a94'::UUID, 6, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.grammar_lessons (id, content_key, title, pattern, explanation, example_chinese, example_pinyin, example_meaning, level, status, usage_note, content_version)
VALUES ('a9d0064c-c9af-5f6d-92cf-2ce9f2c7b5ff'::UUID, 'hsk3:nguyen-nhan', 'Nguyên nhân–kết quả', '因为 + nguyên nhân，所以 + kết quả', '因为 giới thiệu lý do; 所以 giới thiệu hệ quả.', '因为下雨，所以比赛取消了。', 'Yīnwèi xiàyǔ, suǒyǐ bǐsài qǔxiāo le.', 'Vì trời mưa nên trận đấu bị hủy.', 'intermediate', 'review', NULL, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_grammar (id, lesson_id, grammar_lesson_id, order_index, curriculum_role)
VALUES ('adc24936-11ad-5dcd-992e-6208748d3ed5'::UUID, '1958b3c8-38d0-5ce8-8206-e177270eb99b'::UUID, 'a9d0064c-c9af-5f6d-92cf-2ce9f2c7b5ff'::UUID, 1, 'introduced')
ON CONFLICT (lesson_id, grammar_lesson_id) DO NOTHING;

INSERT INTO public.lesson_grammar (id, lesson_id, grammar_lesson_id, order_index, curriculum_role)
VALUES ('55562d1d-7e2e-5823-bd47-dfb866fe0d20'::UUID, '1958b3c8-38d0-5ce8-8206-e177270eb99b'::UUID, '631171d6-56be-5e8f-9a6c-7f629a148b21'::UUID, 2, 'review')
ON CONFLICT (lesson_id, grammar_lesson_id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('dc865520-5590-5ce7-b78e-052dd5157f46'::UUID, '1958b3c8-38d0-5ce8-8206-e177270eb99b'::UUID, 'vocabulary', 1, 'Từ mới: 原因', NULL, '原因', '原因 (yuányīn) — nguyên nhân. 我们正在调查原因。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"hsk3:原因","chinese":"原因","pinyin":"yuányīn","meaning":"nguyên nhân","part_of_speech":"danh từ","example_chinese":"我们正在调查原因。","example_pinyin":"Wǒmen zhèngzài diàochá yuányīn.","example_meaning_vi":"Chúng tôi đang tìm hiểu nguyên nhân."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('4b3d3878-cc47-54bc-8628-be9b9985977b'::UUID, '1958b3c8-38d0-5ce8-8206-e177270eb99b'::UUID, 'vocabulary', 2, 'Từ mới: 决定', NULL, '决定', '决定 (juédìng) — quyết định. 她决定明年留学。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"hsk3:决定","chinese":"决定","pinyin":"juédìng","meaning":"quyết định","part_of_speech":"động từ/danh từ","example_chinese":"她决定明年留学。","example_pinyin":"Tā juédìng míngnián liúxué.","example_meaning_vi":"Cô ấy quyết định năm sau đi du học."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('e1df1aab-2037-5ee2-b566-d46849154468'::UUID, '1958b3c8-38d0-5ce8-8206-e177270eb99b'::UUID, 'vocabulary', 3, 'Từ mới: 所以', NULL, '所以', '所以 (suǒyǐ) — vì vậy. 路上很堵，所以我迟到了。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"hsk3:所以","chinese":"所以","pinyin":"suǒyǐ","meaning":"vì vậy","part_of_speech":"liên từ","example_chinese":"路上很堵，所以我迟到了。","example_pinyin":"Lùshang hěn dǔ, suǒyǐ wǒ chídào le.","example_meaning_vi":"Đường tắc nên tôi đến muộn."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('0e4b0305-2438-51be-846d-376782c2bcda'::UUID, '1958b3c8-38d0-5ce8-8206-e177270eb99b'::UUID, 'multiple_choice', 4, '“原因” có nghĩa phù hợp nhất là gì?', NULL, 'nguyên nhân', '原因 (yuányīn) nghĩa là “nguyên nhân”.', NULL, 1, '{"activity_type":"chinese_to_vietnamese","vocabulary_key":"hsk3:原因"}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('2d245309-eb7a-5b10-9963-26520d87c6ed'::UUID, '0e4b0305-2438-51be-846d-376782c2bcda'::UUID, 'nguyên nhân', TRUE, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('7dda8e9f-27de-5153-b6fc-b523f1d79770'::UUID, '0e4b0305-2438-51be-846d-376782c2bcda'::UUID, 'quyết định', FALSE, 2)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('be4301b5-821a-5a4a-827e-f64220c6214a'::UUID, '0e4b0305-2438-51be-846d-376782c2bcda'::UUID, 'vì vậy', FALSE, 3)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('0a902184-d144-5a8d-bd7f-2d19cf3edece'::UUID, '1958b3c8-38d0-5ce8-8206-e177270eb99b'::UUID, 'translation', 5, 'Dịch sang tiếng Trung: “Vì trời mưa nên trận đấu bị hủy.”', NULL, '因为下雨，所以比赛取消了。', 'Mẫu câu dùng “原因” trong ngữ cảnh của bài.', 'yuányīn', 1, '{"activity_type":"vietnamese_to_chinese","source_lang":"vi","target_lang":"zh","acceptable_answers":["因为下雨，所以比赛取消了。"]}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('4385caf1-f9aa-55d9-a03b-509a8c9a2fd8'::UUID, '1958b3c8-38d0-5ce8-8206-e177270eb99b'::UUID, 'sentence_builder', 6, 'Sắp xếp các thành phần thành câu đúng.', NULL, '因为下雨，所以比赛取消了。', 'Trật tự đúng tạo thành câu “因为下雨，所以比赛取消了。”.', NULL, 1, '{"activity_type":"sentence_ordering","words":["因为","下雨","，","所以","比赛","取消","了","。"],"correct_order":["因为","下雨","，","所以","比赛","取消","了","。"]}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('eeddb2f1-2156-5f0c-9e38-f3113f5d60ff'::UUID, '1958b3c8-38d0-5ce8-8206-e177270eb99b'::UUID, 'multiple_choice', 7, 'Câu nào nối nguyên nhân và kết quả đúng?', NULL, '因为下雨，所以比赛取消了。', '因为 giới thiệu lý do; 所以 giới thiệu hệ quả.', NULL, 1, '{"activity_type":"grammar_selection","passage":null,"grammar_key":"hsk3:nguyen-nhan"}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('81d62fd9-f126-55f0-9880-dea875955f66'::UUID, 'eeddb2f1-2156-5f0c-9e38-f3113f5d60ff'::UUID, '因为下雨，所以比赛取消了。', TRUE, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('37cc2ada-e18d-5453-a0db-2bb30690dc31'::UUID, 'eeddb2f1-2156-5f0c-9e38-f3113f5d60ff'::UUID, '。了取消比赛所以，下雨因为', FALSE, 2)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('f3f564a6-0144-5349-8846-493f21e53b5d'::UUID, 'eeddb2f1-2156-5f0c-9e38-f3113f5d60ff'::UUID, '下雨，所以比赛取消了。因为', FALSE, 3)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('b4ea6197-d3c8-5cf3-9dfd-9bbbb05f08d4'::UUID, '1958b3c8-38d0-5ce8-8206-e177270eb99b'::UUID, 'speaking', 8, 'Đọc thành tiếng: 因为下雨，所以比赛取消了。', NULL, '因为下雨，所以比赛取消了。', 'Đọc chậm, giữ đúng thanh điệu và nhịp của cả câu.', NULL, 1, '{"activity_type":"pronunciation","text":"因为下雨，所以比赛取消了。","pinyin":"Yīnwèi xiàyǔ, suǒyǐ bǐsài qǔxiāo le."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.units (id, course_id, slug, title, description, order_index, status, learning_objectives, content_version)
VALUES ('99c9bc93-3a64-5879-bbbf-467061d088e3'::UUID, '56553c03-c566-5e1a-8cd4-d6364302cca9'::UUID, 'hsk3-van-dung', 'Vận dụng', 'Vận dụng mẫu câu trong ngữ cảnh có ý nghĩa.', 2, 'review', '["Dùng bổ ngữ kết quả","Giải thích nguyên nhân và lựa chọn"]'::JSONB, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.chapters (id, unit_id, slug, title, description, order_index, status, learning_objectives, content_version)
VALUES ('93a1f562-6f34-516b-b681-2e291f464f1c'::UUID, '99c9bc93-3a64-5879-bbbf-467061d088e3'::UUID, 'hsk3-van-dung-chapter', 'Ngữ cảnh thực tế', 'Vận dụng mẫu câu trong ngữ cảnh có ý nghĩa.', 1, 'review', '["Dùng bổ ngữ kết quả","Giải thích nguyên nhân và lựa chọn"]'::JSONB, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lessons (id, chapter_id, slug, title, description, order_index, xp_reward, status, lesson_type, estimated_minutes, learning_objectives, cultural_note, content_version)
VALUES ('13ffd3bc-d55d-55f0-902f-3590bb158c3b'::UUID, '93a1f562-6f34-516b-b681-2e291f464f1c'::UUID, 'huong-di', '走进去 — Bổ ngữ xu hướng', 'Mô tả hướng di chuyển tương đối với người nói.', 1, 25, 'review', 'standard', 15, '["Dùng 来 và 去 sau động từ"]'::JSONB, 'Chọn 来 hay 去 theo vị trí quan sát, không chỉ theo nghĩa động từ.', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('3b89fccc-0385-5c7c-bfba-dbcc70a995ea'::UUID, 'hsk3:进去', '进去', 'jìnqu', 'đi vào', 'go in', 'intermediate', 'huong-di', 'bổ ngữ xu hướng', '请进教室去。', 'Qǐng jìn jiàoshì qu.', 'Mời đi vào lớp học.', NULL, 'review', '13ffd3bc-d55d-55f0-902f-3590bb158c3b'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('04974013-1e72-5475-a1a0-c6f96ca50d60'::UUID, '13ffd3bc-d55d-55f0-902f-3590bb158c3b'::UUID, '3b89fccc-0385-5c7c-bfba-dbcc70a995ea'::UUID, 1, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('670c5c55-0365-5857-91fd-e5b99b516a93'::UUID, 'hsk3:出来', '出来', 'chūlai', 'đi ra đây', 'come out', 'intermediate', 'huong-di', 'bổ ngữ xu hướng', '孩子们从教室里跑出来。', 'Háizimen cóng jiàoshì lǐ pǎo chūlai.', 'Bọn trẻ chạy từ lớp ra đây.', NULL, 'review', '13ffd3bc-d55d-55f0-902f-3590bb158c3b'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('8e92c677-3907-51fd-8430-27b6a1798cd0'::UUID, '13ffd3bc-d55d-55f0-902f-3590bb158c3b'::UUID, '670c5c55-0365-5857-91fd-e5b99b516a93'::UUID, 2, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('be4c52d9-37d9-5785-a6e9-5740ca8923f3'::UUID, 'hsk3:楼上', '楼上', 'lóushàng', 'tầng trên', 'upstairs', 'intermediate', 'huong-di', 'danh từ phương vị', '会议室在楼上。', 'Huìyìshì zài lóushàng.', 'Phòng họp ở tầng trên.', NULL, 'review', '13ffd3bc-d55d-55f0-902f-3590bb158c3b'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('b8181af7-13b5-55ae-9d9f-6d29ed4c822e'::UUID, '13ffd3bc-d55d-55f0-902f-3590bb158c3b'::UUID, 'be4c52d9-37d9-5785-a6e9-5740ca8923f3'::UUID, 3, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('4d52cd4c-0d21-5dea-be8e-aee8ca9e7f18'::UUID, '13ffd3bc-d55d-55f0-902f-3590bb158c3b'::UUID, '304167e7-e82b-5ed8-b836-0f0b72ce8683'::UUID, 4, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('c3972d32-f3e6-599e-983a-3c4b926fb8b0'::UUID, '13ffd3bc-d55d-55f0-902f-3590bb158c3b'::UUID, '52f4e440-03fd-5cda-864b-c82f4720d53c'::UUID, 5, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('645573f9-3f95-579c-b378-2e6a39e25c03'::UUID, '13ffd3bc-d55d-55f0-902f-3590bb158c3b'::UUID, '19f00d51-4b18-59e9-b794-004932f04d15'::UUID, 6, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.grammar_lessons (id, content_key, title, pattern, explanation, example_chinese, example_pinyin, example_meaning, level, status, usage_note, content_version)
VALUES ('c5aec599-7627-58db-bd1b-07844e0ec50c'::UUID, 'hsk3:huong-di', 'Bổ ngữ xu hướng kép', 'động từ + hướng + 来/去', '来 hướng về người nói; 去 hướng xa người nói.', '他拿着书走进去了。', 'Tā názhe shū zǒu jìnqu le.', 'Anh ấy cầm sách đi vào trong.', 'intermediate', 'review', NULL, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_grammar (id, lesson_id, grammar_lesson_id, order_index, curriculum_role)
VALUES ('642b7c5b-df07-5ec7-9f74-47b9dda4201f'::UUID, '13ffd3bc-d55d-55f0-902f-3590bb158c3b'::UUID, 'c5aec599-7627-58db-bd1b-07844e0ec50c'::UUID, 1, 'introduced')
ON CONFLICT (lesson_id, grammar_lesson_id) DO NOTHING;

INSERT INTO public.lesson_grammar (id, lesson_id, grammar_lesson_id, order_index, curriculum_role)
VALUES ('ae588f66-9bde-517c-94ae-d12ee4069d97'::UUID, '13ffd3bc-d55d-55f0-902f-3590bb158c3b'::UUID, 'a9d0064c-c9af-5f6d-92cf-2ce9f2c7b5ff'::UUID, 2, 'review')
ON CONFLICT (lesson_id, grammar_lesson_id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('676831cf-bd7c-5d99-941c-7247d9a9a4b9'::UUID, '13ffd3bc-d55d-55f0-902f-3590bb158c3b'::UUID, 'vocabulary', 1, 'Từ mới: 进去', NULL, '进去', '进去 (jìnqu) — đi vào. 请进教室去。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"hsk3:进去","chinese":"进去","pinyin":"jìnqu","meaning":"đi vào","part_of_speech":"bổ ngữ xu hướng","example_chinese":"请进教室去。","example_pinyin":"Qǐng jìn jiàoshì qu.","example_meaning_vi":"Mời đi vào lớp học."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('afbf8afc-cdcc-5a9c-b228-2fdde8e2d9e4'::UUID, '13ffd3bc-d55d-55f0-902f-3590bb158c3b'::UUID, 'vocabulary', 2, 'Từ mới: 出来', NULL, '出来', '出来 (chūlai) — đi ra đây. 孩子们从教室里跑出来。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"hsk3:出来","chinese":"出来","pinyin":"chūlai","meaning":"đi ra đây","part_of_speech":"bổ ngữ xu hướng","example_chinese":"孩子们从教室里跑出来。","example_pinyin":"Háizimen cóng jiàoshì lǐ pǎo chūlai.","example_meaning_vi":"Bọn trẻ chạy từ lớp ra đây."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('27456fd0-7734-59fa-9ebd-901472f4b4ca'::UUID, '13ffd3bc-d55d-55f0-902f-3590bb158c3b'::UUID, 'vocabulary', 3, 'Từ mới: 楼上', NULL, '楼上', '楼上 (lóushàng) — tầng trên. 会议室在楼上。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"hsk3:楼上","chinese":"楼上","pinyin":"lóushàng","meaning":"tầng trên","part_of_speech":"danh từ phương vị","example_chinese":"会议室在楼上。","example_pinyin":"Huìyìshì zài lóushàng.","example_meaning_vi":"Phòng họp ở tầng trên."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('aac11eea-2dec-5ba2-b541-1324841f0c00'::UUID, '13ffd3bc-d55d-55f0-902f-3590bb158c3b'::UUID, 'multiple_choice', 4, '“进去” có nghĩa phù hợp nhất là gì?', NULL, 'đi vào', '进去 (jìnqu) nghĩa là “đi vào”.', NULL, 1, '{"activity_type":"chinese_to_vietnamese","vocabulary_key":"hsk3:进去"}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('d24bd137-c4b9-5f6c-9aaf-04ee788e5cd2'::UUID, 'aac11eea-2dec-5ba2-b541-1324841f0c00'::UUID, 'tầng trên', FALSE, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('ada73ca5-aaa3-5d7e-98d4-68580507308a'::UUID, 'aac11eea-2dec-5ba2-b541-1324841f0c00'::UUID, 'đi vào', TRUE, 2)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('a1842519-2502-5a14-919b-7c04c8f30c04'::UUID, 'aac11eea-2dec-5ba2-b541-1324841f0c00'::UUID, 'đi ra đây', FALSE, 3)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('ef97616e-7936-56c9-84b6-c8ff12848962'::UUID, '13ffd3bc-d55d-55f0-902f-3590bb158c3b'::UUID, 'translation', 5, 'Dịch sang tiếng Trung: “Anh ấy cầm sách đi vào trong.”', NULL, '他拿着书走进去了。', 'Mẫu câu dùng “进去” trong ngữ cảnh của bài.', 'jìnqu', 1, '{"activity_type":"vietnamese_to_chinese","source_lang":"vi","target_lang":"zh","acceptable_answers":["他拿着书走进去了。"]}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('c9217b3d-d628-589c-9bbd-ed705e5eebdb'::UUID, '13ffd3bc-d55d-55f0-902f-3590bb158c3b'::UUID, 'sentence_builder', 6, 'Sắp xếp các thành phần thành câu đúng.', NULL, '他拿着书走进去了。', 'Trật tự đúng tạo thành câu “他拿着书走进去了。”.', NULL, 1, '{"activity_type":"sentence_ordering","words":["他","拿着","书","走","进去","了","。"],"correct_order":["他","拿着","书","走","进去","了","。"]}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('00025ef1-21a0-5abc-a863-f22ca163fb9b'::UUID, '13ffd3bc-d55d-55f0-902f-3590bb158c3b'::UUID, 'multiple_choice', 7, 'Câu nào có hướng đi xa người nói?', NULL, '他拿着书走进去了。', '来 hướng về người nói; 去 hướng xa người nói.', NULL, 1, '{"activity_type":"grammar_selection","passage":null,"grammar_key":"hsk3:huong-di"}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('1e708a46-cf77-5efb-8bb8-5749bbed0627'::UUID, '00025ef1-21a0-5abc-a863-f22ca163fb9b'::UUID, '他拿着书走进去了。', TRUE, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('69f96d8f-cdb3-5e93-bef6-e1c1bc857762'::UUID, '00025ef1-21a0-5abc-a863-f22ca163fb9b'::UUID, '。了进去走书拿着他', FALSE, 2)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('4c45f1db-e954-5a17-b34a-062b070894e6'::UUID, '00025ef1-21a0-5abc-a863-f22ca163fb9b'::UUID, '拿着书走进去了。他', FALSE, 3)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('73712eaa-bc1d-5b63-a081-b1deae6781c2'::UUID, '13ffd3bc-d55d-55f0-902f-3590bb158c3b'::UUID, 'speaking', 8, 'Đọc thành tiếng: 他拿着书走进去了。', NULL, '他拿着书走进去了。', 'Đọc chậm, giữ đúng thanh điệu và nhịp của cả câu.', NULL, 1, '{"activity_type":"pronunciation","text":"他拿着书走进去了。","pinyin":"Tā názhe shū zǒu jìnqu le."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lessons (id, chapter_id, slug, title, description, order_index, xp_reward, status, lesson_type, estimated_minutes, learning_objectives, cultural_note, content_version)
VALUES ('60e56a80-35f4-5fc2-aa12-3c6ea47ac253'::UUID, '93a1f562-6f34-516b-b681-2e291f464f1c'::UUID, 'lua-chon', '除了…以外… — Bổ sung', 'Nêu ngoại lệ và phần bổ sung.', 2, 25, 'review', 'standard', 15, '["Mở rộng câu bằng quan hệ bao gồm"]'::JSONB, 'Khi mang nghĩa loại trừ thường đi với 都 ở mệnh đề sau.', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('811776c0-bfab-5bb7-8cc4-8ec41bf477b4'::UUID, 'hsk3:除了', '除了', 'chúle', 'ngoài, trừ', 'besides; except', 'intermediate', 'lua-chon', 'giới từ', '除了周日，我每天都上班。', 'Chúle Zhōurì, wǒ měitiān dōu shàngbān.', 'Ngoài Chủ nhật, ngày nào tôi cũng đi làm.', NULL, 'review', '60e56a80-35f4-5fc2-aa12-3c6ea47ac253'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('1b2fca68-0e4b-5ffc-84ff-c998c7135bf1'::UUID, '60e56a80-35f4-5fc2-aa12-3c6ea47ac253'::UUID, '811776c0-bfab-5bb7-8cc4-8ec41bf477b4'::UUID, 1, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('245ca443-aad6-598a-b345-ad77aedda75d'::UUID, 'hsk3:以外', '以外', 'yǐwài', 'ngoài ra', 'beyond; besides', 'intermediate', 'lua-chon', 'danh từ phương vị', '工作以外，他也喜欢摄影。', 'Gōngzuò yǐwài, tā yě xǐhuan shèyǐng.', 'Ngoài công việc, anh ấy còn thích nhiếp ảnh.', NULL, 'review', '60e56a80-35f4-5fc2-aa12-3c6ea47ac253'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('91e5e758-2f94-5f66-b254-4efbfd671cc4'::UUID, '60e56a80-35f4-5fc2-aa12-3c6ea47ac253'::UUID, '245ca443-aad6-598a-b345-ad77aedda75d'::UUID, 2, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('45e3993e-78a1-558f-8e56-df53368830cc'::UUID, 'hsk3:还', '还', 'hái', 'còn, vẫn', 'also; still', 'intermediate', 'lua-chon', 'phó từ', '她会英语，还会汉语。', 'Tā huì Yīngyǔ, hái huì Hànyǔ.', 'Cô ấy biết tiếng Anh, còn biết tiếng Trung.', NULL, 'review', '60e56a80-35f4-5fc2-aa12-3c6ea47ac253'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('1e95c239-bae4-51f3-9f5e-cbf2ac693250'::UUID, '60e56a80-35f4-5fc2-aa12-3c6ea47ac253'::UUID, '45e3993e-78a1-558f-8e56-df53368830cc'::UUID, 3, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('d46e605d-b312-5680-b134-f1832a546168'::UUID, '60e56a80-35f4-5fc2-aa12-3c6ea47ac253'::UUID, '3b89fccc-0385-5c7c-bfba-dbcc70a995ea'::UUID, 4, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('95d4fd30-f0b6-5d43-a617-6ac96f4425d3'::UUID, '60e56a80-35f4-5fc2-aa12-3c6ea47ac253'::UUID, '670c5c55-0365-5857-91fd-e5b99b516a93'::UUID, 5, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('015fbaf2-1a50-5b05-beed-b45e65fab05c'::UUID, '60e56a80-35f4-5fc2-aa12-3c6ea47ac253'::UUID, 'be4c52d9-37d9-5785-a6e9-5740ca8923f3'::UUID, 6, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.grammar_lessons (id, content_key, title, pattern, explanation, example_chinese, example_pinyin, example_meaning, level, status, usage_note, content_version)
VALUES ('983ee87b-aff6-503a-ad89-dff794fc0e66'::UUID, 'hsk3:lua-chon', 'Bổ sung với 除了', '除了 A 以外，还/也 B', 'Cấu trúc nêu A rồi bổ sung thêm B.', '除了汉语以外，他还会日语。', 'Chúle Hànyǔ yǐwài, tā hái huì Rìyǔ.', 'Ngoài tiếng Trung, anh ấy còn biết tiếng Nhật.', 'intermediate', 'review', NULL, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_grammar (id, lesson_id, grammar_lesson_id, order_index, curriculum_role)
VALUES ('a1aae1dd-4d18-566e-be31-d37a1b8e0bfe'::UUID, '60e56a80-35f4-5fc2-aa12-3c6ea47ac253'::UUID, '983ee87b-aff6-503a-ad89-dff794fc0e66'::UUID, 1, 'introduced')
ON CONFLICT (lesson_id, grammar_lesson_id) DO NOTHING;

INSERT INTO public.lesson_grammar (id, lesson_id, grammar_lesson_id, order_index, curriculum_role)
VALUES ('e0ac103d-e2b1-52f4-ab43-d33987e2ce73'::UUID, '60e56a80-35f4-5fc2-aa12-3c6ea47ac253'::UUID, 'c5aec599-7627-58db-bd1b-07844e0ec50c'::UUID, 2, 'review')
ON CONFLICT (lesson_id, grammar_lesson_id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('ebdc4a59-be90-5693-83df-87ec91f3023a'::UUID, '60e56a80-35f4-5fc2-aa12-3c6ea47ac253'::UUID, 'vocabulary', 1, 'Từ mới: 除了', NULL, '除了', '除了 (chúle) — ngoài, trừ. 除了周日，我每天都上班。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"hsk3:除了","chinese":"除了","pinyin":"chúle","meaning":"ngoài, trừ","part_of_speech":"giới từ","example_chinese":"除了周日，我每天都上班。","example_pinyin":"Chúle Zhōurì, wǒ měitiān dōu shàngbān.","example_meaning_vi":"Ngoài Chủ nhật, ngày nào tôi cũng đi làm."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('d9c36209-d0aa-5fe2-9d14-d39ef2925f47'::UUID, '60e56a80-35f4-5fc2-aa12-3c6ea47ac253'::UUID, 'vocabulary', 2, 'Từ mới: 以外', NULL, '以外', '以外 (yǐwài) — ngoài ra. 工作以外，他也喜欢摄影。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"hsk3:以外","chinese":"以外","pinyin":"yǐwài","meaning":"ngoài ra","part_of_speech":"danh từ phương vị","example_chinese":"工作以外，他也喜欢摄影。","example_pinyin":"Gōngzuò yǐwài, tā yě xǐhuan shèyǐng.","example_meaning_vi":"Ngoài công việc, anh ấy còn thích nhiếp ảnh."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('2685cf53-dc1e-564e-aba5-7f4c60138cc7'::UUID, '60e56a80-35f4-5fc2-aa12-3c6ea47ac253'::UUID, 'vocabulary', 3, 'Từ mới: 还', NULL, '还', '还 (hái) — còn, vẫn. 她会英语，还会汉语。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"hsk3:还","chinese":"还","pinyin":"hái","meaning":"còn, vẫn","part_of_speech":"phó từ","example_chinese":"她会英语，还会汉语。","example_pinyin":"Tā huì Yīngyǔ, hái huì Hànyǔ.","example_meaning_vi":"Cô ấy biết tiếng Anh, còn biết tiếng Trung."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('6586565a-c567-528b-83be-ba930fe2ffc5'::UUID, '60e56a80-35f4-5fc2-aa12-3c6ea47ac253'::UUID, 'multiple_choice', 4, '“除了” có nghĩa phù hợp nhất là gì?', NULL, 'ngoài, trừ', '除了 (chúle) nghĩa là “ngoài, trừ”.', NULL, 1, '{"activity_type":"chinese_to_vietnamese","vocabulary_key":"hsk3:除了"}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('2148173f-112c-53e7-88d5-0bfe8a05dd66'::UUID, '6586565a-c567-528b-83be-ba930fe2ffc5'::UUID, 'còn, vẫn', FALSE, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('703345b5-706b-5eec-9127-3f8371041c8f'::UUID, '6586565a-c567-528b-83be-ba930fe2ffc5'::UUID, 'ngoài, trừ', TRUE, 2)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('d3b3975e-8e70-5983-b41d-313318f94556'::UUID, '6586565a-c567-528b-83be-ba930fe2ffc5'::UUID, 'ngoài ra', FALSE, 3)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('c1987c34-7dd8-51e0-820f-de492090ebca'::UUID, '60e56a80-35f4-5fc2-aa12-3c6ea47ac253'::UUID, 'translation', 5, 'Dịch sang tiếng Trung: “Ngoài tiếng Trung, anh ấy còn biết tiếng Nhật.”', NULL, '除了汉语以外，他还会日语。', 'Mẫu câu dùng “除了” trong ngữ cảnh của bài.', 'chúle', 1, '{"activity_type":"vietnamese_to_chinese","source_lang":"vi","target_lang":"zh","acceptable_answers":["除了汉语以外，他还会日语。"]}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('ff1ebb65-be88-51b5-a0a2-e23b28c3a0c2'::UUID, '60e56a80-35f4-5fc2-aa12-3c6ea47ac253'::UUID, 'sentence_builder', 6, 'Sắp xếp các thành phần thành câu đúng.', NULL, '除了汉语以外，他还会日语。', 'Trật tự đúng tạo thành câu “除了汉语以外，他还会日语。”.', NULL, 1, '{"activity_type":"sentence_ordering","words":["除了","汉语","以外","，","他","还会","日语","。"],"correct_order":["除了","汉语","以外","，","他","还会","日语","。"]}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('e4b565c5-d9d5-555b-a697-915193071bc5'::UUID, '60e56a80-35f4-5fc2-aa12-3c6ea47ac253'::UUID, 'multiple_choice', 7, 'Câu nào diễn đạt ý bổ sung đúng?', NULL, '除了汉语以外，他还会日语。', 'Cấu trúc nêu A rồi bổ sung thêm B.', NULL, 1, '{"activity_type":"grammar_selection","passage":null,"grammar_key":"hsk3:lua-chon"}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('94a4edcc-9e46-58fa-8c6d-bb0e11994fa8'::UUID, 'e4b565c5-d9d5-555b-a697-915193071bc5'::UUID, '除了汉语以外，他还会日语。', TRUE, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('69ed4631-f86f-56b4-ba62-134a737d687b'::UUID, 'e4b565c5-d9d5-555b-a697-915193071bc5'::UUID, '。日语还会他，以外汉语除了', FALSE, 2)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('150e9ea7-ac9b-59d6-b28d-be882362f2eb'::UUID, 'e4b565c5-d9d5-555b-a697-915193071bc5'::UUID, '汉语以外，他还会日语。除了', FALSE, 3)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('68fe78eb-d98c-54e4-b2d6-9606727a8229'::UUID, '60e56a80-35f4-5fc2-aa12-3c6ea47ac253'::UUID, 'speaking', 8, 'Đọc thành tiếng: 除了汉语以外，他还会日语。', NULL, '除了汉语以外，他还会日语。', 'Đọc chậm, giữ đúng thanh điệu và nhịp của cả câu.', NULL, 1, '{"activity_type":"pronunciation","text":"除了汉语以外，他还会日语。","pinyin":"Chúle Hànyǔ yǐwài, tā hái huì Rìyǔ."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.units (id, course_id, slug, title, description, order_index, status, learning_objectives, content_version)
VALUES ('e26bc7bf-b8d5-5270-ad8b-b0dafccb7696'::UUID, '56553c03-c566-5e1a-8cd4-d6364302cca9'::UUID, 'hsk3-on-tap', 'Ôn tập', 'Kiểm tra và củng cố nội dung đã học.', 3, 'review', '["Ôn từ vựng","Ôn mẫu câu"]'::JSONB, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.chapters (id, unit_id, slug, title, description, order_index, status, learning_objectives, content_version)
VALUES ('9f91123b-4bfd-590d-90b3-663b7e0646a9'::UUID, 'e26bc7bf-b8d5-5270-ad8b-b0dafccb7696'::UUID, 'hsk3-on-tap-chapter', 'Củng cố lộ trình', 'Kiểm tra và củng cố nội dung đã học.', 1, 'review', '["Ôn từ vựng","Ôn mẫu câu"]'::JSONB, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lessons (id, chapter_id, slug, title, description, order_index, xp_reward, status, lesson_type, estimated_minutes, learning_objectives, cultural_note, content_version)
VALUES ('cd071a71-79b2-51f5-b3b1-ebf1f0ccee5d'::UUID, '9f91123b-4bfd-590d-90b3-663b7e0646a9'::UUID, 'hsk3-review', 'Ôn tập HSK 3', 'Củng cố từ vựng, mẫu câu và khả năng diễn đạt của toàn khóa.', 1, 30, 'review', 'review', 18, '["Vận dụng lại từ vựng trọng tâm","Tự kiểm tra mẫu câu đã học"]'::JSONB, NULL, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('e0e47e49-805c-5c7f-b8e7-107ec4ad78ac'::UUID, 'cd071a71-79b2-51f5-b3b1-ebf1f0ccee5d'::UUID, '811776c0-bfab-5bb7-8cc4-8ec41bf477b4'::UUID, 1, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('e6147135-9885-5055-ac0e-5423030082c5'::UUID, 'cd071a71-79b2-51f5-b3b1-ebf1f0ccee5d'::UUID, '245ca443-aad6-598a-b345-ad77aedda75d'::UUID, 2, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('da7daa45-5050-525e-9663-1ffb099c5941'::UUID, 'cd071a71-79b2-51f5-b3b1-ebf1f0ccee5d'::UUID, '45e3993e-78a1-558f-8e56-df53368830cc'::UUID, 3, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_grammar (id, lesson_id, grammar_lesson_id, order_index, curriculum_role)
VALUES ('4109956c-43bd-5bfd-af14-f41450e65f1e'::UUID, 'cd071a71-79b2-51f5-b3b1-ebf1f0ccee5d'::UUID, '983ee87b-aff6-503a-ad89-dff794fc0e66'::UUID, 1, 'review')
ON CONFLICT (lesson_id, grammar_lesson_id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('bde0cf35-9301-59df-8860-c0e23563bea1'::UUID, 'cd071a71-79b2-51f5-b3b1-ebf1f0ccee5d'::UUID, 'multiple_choice', 1, '“除了” có nghĩa phù hợp nhất là gì?', NULL, 'ngoài, trừ', '除了 (chúle) nghĩa là “ngoài, trừ”.', NULL, 1, '{"activity_type":"chinese_to_vietnamese","vocabulary_key":"hsk3:除了"}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('c02afe98-2bbd-57fb-98e1-186a126f8a03'::UUID, 'bde0cf35-9301-59df-8860-c0e23563bea1'::UUID, 'còn, vẫn', FALSE, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('bdd5e8b5-a715-516d-96ed-abb233410402'::UUID, 'bde0cf35-9301-59df-8860-c0e23563bea1'::UUID, 'ngoài, trừ', TRUE, 2)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('eae95af5-ea09-526f-9f92-2545c07c48e3'::UUID, 'bde0cf35-9301-59df-8860-c0e23563bea1'::UUID, 'ngoài ra', FALSE, 3)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('9fa449e2-81fe-551e-85f7-e35a99b187b2'::UUID, 'cd071a71-79b2-51f5-b3b1-ebf1f0ccee5d'::UUID, 'translation', 2, 'Dịch sang tiếng Trung: “Ngoài tiếng Trung, anh ấy còn biết tiếng Nhật.”', NULL, '除了汉语以外，他还会日语。', 'Mẫu câu dùng “除了” trong ngữ cảnh của bài.', 'chúle', 1, '{"activity_type":"vietnamese_to_chinese","source_lang":"vi","target_lang":"zh","acceptable_answers":["除了汉语以外，他还会日语。"]}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('467927e2-7d26-5ce0-8e2c-98edcd0cf557'::UUID, 'cd071a71-79b2-51f5-b3b1-ebf1f0ccee5d'::UUID, 'sentence_builder', 3, 'Sắp xếp các thành phần thành câu đúng.', NULL, '除了汉语以外，他还会日语。', 'Trật tự đúng tạo thành câu “除了汉语以外，他还会日语。”.', NULL, 1, '{"activity_type":"sentence_ordering","words":["除了","汉语","以外","，","他","还会","日语","。"],"correct_order":["除了","汉语","以外","，","他","还会","日语","。"]}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('123ed5f0-2188-558a-abf0-d93d03df292a'::UUID, 'cd071a71-79b2-51f5-b3b1-ebf1f0ccee5d'::UUID, 'multiple_choice', 4, 'Câu nào diễn đạt ý bổ sung đúng?', NULL, '除了汉语以外，他还会日语。', 'Cấu trúc nêu A rồi bổ sung thêm B.', NULL, 1, '{"activity_type":"grammar_selection","passage":null,"grammar_key":"hsk3:lua-chon"}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('87d75fcc-4ff0-502e-ad80-e720e55b116f'::UUID, '123ed5f0-2188-558a-abf0-d93d03df292a'::UUID, '除了汉语以外，他还会日语。', TRUE, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('0b55d0e6-8281-57ba-9574-2964760facf3'::UUID, '123ed5f0-2188-558a-abf0-d93d03df292a'::UUID, '。日语还会他，以外汉语除了', FALSE, 2)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('a7cc9a21-6e70-5a26-8c59-29c2ac25e034'::UUID, '123ed5f0-2188-558a-abf0-d93d03df292a'::UUID, '汉语以外，他还会日语。除了', FALSE, 3)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('27f4db13-b161-56e0-8003-a6324fc0aaa5'::UUID, 'cd071a71-79b2-51f5-b3b1-ebf1f0ccee5d'::UUID, 'speaking', 5, 'Đọc thành tiếng: 除了汉语以外，他还会日语。', NULL, '除了汉语以外，他还会日语。', 'Đọc chậm, giữ đúng thanh điệu và nhịp của cả câu.', NULL, 1, '{"activity_type":"pronunciation","text":"除了汉语以外，他还会日语。","pinyin":"Chúle Hànyǔ yǐwài, tā hái huì Rìyǔ."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.content_batches (id, batch_key, version, migration_name, manifest_checksum, expected_counts)
VALUES ('8d9fa317-7102-5e67-a4c6-c8e7e3ff6b16'::UUID, 'batch-04-hsk3', 1, '20260729130000_content_batch_04_hsk3', '56b905f05085b592cb6a188fdc54d8e7551506a166f54d3fc810c8acf201e0e8', '{"courses":1,"units":3,"chapters":3,"lessons":5,"vocabulary":12,"grammar":4,"characters":0,"exercises":37,"options":30}'::JSONB)
ON CONFLICT (batch_key, version) DO NOTHING;

DO $content_validation$
BEGIN
  IF (SELECT COUNT(*) FROM public.courses WHERE id = ANY(ARRAY['56553c03-c566-5e1a-8cd4-d6364302cca9'::UUID]::UUID[])) <> 1 THEN
    RAISE EXCEPTION 'Content batch batch-04-hsk3 is missing managed courses rows';
  END IF;
  IF (SELECT COUNT(*) FROM public.units WHERE id = ANY(ARRAY['d13fc56d-93ec-5986-bb8d-7002592db167'::UUID, '99c9bc93-3a64-5879-bbbf-467061d088e3'::UUID, 'e26bc7bf-b8d5-5270-ad8b-b0dafccb7696'::UUID]::UUID[])) <> 3 THEN
    RAISE EXCEPTION 'Content batch batch-04-hsk3 is missing managed units rows';
  END IF;
  IF (SELECT COUNT(*) FROM public.chapters WHERE id = ANY(ARRAY['3b4744d2-71f5-543f-8529-2156db38a5f6'::UUID, '93a1f562-6f34-516b-b681-2e291f464f1c'::UUID, '9f91123b-4bfd-590d-90b3-663b7e0646a9'::UUID]::UUID[])) <> 3 THEN
    RAISE EXCEPTION 'Content batch batch-04-hsk3 is missing managed chapters rows';
  END IF;
  IF (SELECT COUNT(*) FROM public.lessons WHERE id = ANY(ARRAY['b0494aea-58d9-5ac9-a62c-c371d24f7bf6'::UUID, '1958b3c8-38d0-5ce8-8206-e177270eb99b'::UUID, '13ffd3bc-d55d-55f0-902f-3590bb158c3b'::UUID, '60e56a80-35f4-5fc2-aa12-3c6ea47ac253'::UUID, 'cd071a71-79b2-51f5-b3b1-ebf1f0ccee5d'::UUID]::UUID[])) <> 5 THEN
    RAISE EXCEPTION 'Content batch batch-04-hsk3 is missing managed lessons rows';
  END IF;
  IF (SELECT COUNT(*) FROM public.vocabulary WHERE id = ANY(ARRAY['893fbf6b-c66a-51fe-93a8-50acc4b9bad6'::UUID, 'e4a1b95a-b638-5521-8788-f91c81ac76f6'::UUID, '7576e95c-57ab-50c6-b0d1-01cdda9d5a94'::UUID, '304167e7-e82b-5ed8-b836-0f0b72ce8683'::UUID, '52f4e440-03fd-5cda-864b-c82f4720d53c'::UUID, '19f00d51-4b18-59e9-b794-004932f04d15'::UUID, '3b89fccc-0385-5c7c-bfba-dbcc70a995ea'::UUID, '670c5c55-0365-5857-91fd-e5b99b516a93'::UUID, 'be4c52d9-37d9-5785-a6e9-5740ca8923f3'::UUID, '811776c0-bfab-5bb7-8cc4-8ec41bf477b4'::UUID, '245ca443-aad6-598a-b345-ad77aedda75d'::UUID, '45e3993e-78a1-558f-8e56-df53368830cc'::UUID]::UUID[])) <> 12 THEN
    RAISE EXCEPTION 'Content batch batch-04-hsk3 is missing managed vocabulary rows';
  END IF;
  IF (SELECT COUNT(*) FROM public.grammar_lessons WHERE id = ANY(ARRAY['631171d6-56be-5e8f-9a6c-7f629a148b21'::UUID, 'a9d0064c-c9af-5f6d-92cf-2ce9f2c7b5ff'::UUID, 'c5aec599-7627-58db-bd1b-07844e0ec50c'::UUID, '983ee87b-aff6-503a-ad89-dff794fc0e66'::UUID]::UUID[])) <> 4 THEN
    RAISE EXCEPTION 'Content batch batch-04-hsk3 is missing managed grammar_lessons rows';
  END IF;
  IF (SELECT COUNT(*) FROM public.exercises WHERE id = ANY(ARRAY['7599d655-f0f5-5080-bdf6-bbd330e7052c'::UUID, '56653638-089e-5e1a-8daa-345889b1ee9d'::UUID, 'ff57124c-f601-52cc-b397-8904cc41ead5'::UUID, '027bbc06-f34a-5648-aea4-dc68613cf957'::UUID, 'df8baf12-3976-5857-8473-ca74c4c35070'::UUID, 'c81a44d4-01dc-56d4-a95d-3fec89bf3755'::UUID, '2ad13705-8aef-52e6-bd06-32f2f0d3f993'::UUID, '82df1330-3929-559e-8404-3cd20cf40d55'::UUID, 'dc865520-5590-5ce7-b78e-052dd5157f46'::UUID, '4b3d3878-cc47-54bc-8628-be9b9985977b'::UUID, 'e1df1aab-2037-5ee2-b566-d46849154468'::UUID, '0e4b0305-2438-51be-846d-376782c2bcda'::UUID, '0a902184-d144-5a8d-bd7f-2d19cf3edece'::UUID, '4385caf1-f9aa-55d9-a03b-509a8c9a2fd8'::UUID, 'eeddb2f1-2156-5f0c-9e38-f3113f5d60ff'::UUID, 'b4ea6197-d3c8-5cf3-9dfd-9bbbb05f08d4'::UUID, '676831cf-bd7c-5d99-941c-7247d9a9a4b9'::UUID, 'afbf8afc-cdcc-5a9c-b228-2fdde8e2d9e4'::UUID, '27456fd0-7734-59fa-9ebd-901472f4b4ca'::UUID, 'aac11eea-2dec-5ba2-b541-1324841f0c00'::UUID, 'ef97616e-7936-56c9-84b6-c8ff12848962'::UUID, 'c9217b3d-d628-589c-9bbd-ed705e5eebdb'::UUID, '00025ef1-21a0-5abc-a863-f22ca163fb9b'::UUID, '73712eaa-bc1d-5b63-a081-b1deae6781c2'::UUID, 'ebdc4a59-be90-5693-83df-87ec91f3023a'::UUID, 'd9c36209-d0aa-5fe2-9d14-d39ef2925f47'::UUID, '2685cf53-dc1e-564e-aba5-7f4c60138cc7'::UUID, '6586565a-c567-528b-83be-ba930fe2ffc5'::UUID, 'c1987c34-7dd8-51e0-820f-de492090ebca'::UUID, 'ff1ebb65-be88-51b5-a0a2-e23b28c3a0c2'::UUID, 'e4b565c5-d9d5-555b-a697-915193071bc5'::UUID, '68fe78eb-d98c-54e4-b2d6-9606727a8229'::UUID, 'bde0cf35-9301-59df-8860-c0e23563bea1'::UUID, '9fa449e2-81fe-551e-85f7-e35a99b187b2'::UUID, '467927e2-7d26-5ce0-8e2c-98edcd0cf557'::UUID, '123ed5f0-2188-558a-abf0-d93d03df292a'::UUID, '27f4db13-b161-56e0-8003-a6324fc0aaa5'::UUID]::UUID[])) <> 37 THEN
    RAISE EXCEPTION 'Content batch batch-04-hsk3 is missing managed exercises rows';
  END IF;
  IF (SELECT COUNT(*) FROM public.exercise_options WHERE id = ANY(ARRAY['e4ff2fb4-7ff3-5253-af9e-b993bb1b32ba'::UUID, '05904581-ffa3-52c2-935b-83b6c94e823a'::UUID, 'e6e56f0a-9c1a-593a-a806-b5d966f7eead'::UUID, '135c2e52-5e48-532a-9ed4-dad0d3bf61e6'::UUID, 'ad8bb110-767e-51e8-9c6d-7a1d5e0a568e'::UUID, '084c2ee5-8a8a-57e1-9f66-463474095d97'::UUID, '2d245309-eb7a-5b10-9963-26520d87c6ed'::UUID, '7dda8e9f-27de-5153-b6fc-b523f1d79770'::UUID, 'be4301b5-821a-5a4a-827e-f64220c6214a'::UUID, '81d62fd9-f126-55f0-9880-dea875955f66'::UUID, '37cc2ada-e18d-5453-a0db-2bb30690dc31'::UUID, 'f3f564a6-0144-5349-8846-493f21e53b5d'::UUID, 'd24bd137-c4b9-5f6c-9aaf-04ee788e5cd2'::UUID, 'ada73ca5-aaa3-5d7e-98d4-68580507308a'::UUID, 'a1842519-2502-5a14-919b-7c04c8f30c04'::UUID, '1e708a46-cf77-5efb-8bb8-5749bbed0627'::UUID, '69f96d8f-cdb3-5e93-bef6-e1c1bc857762'::UUID, '4c45f1db-e954-5a17-b34a-062b070894e6'::UUID, '2148173f-112c-53e7-88d5-0bfe8a05dd66'::UUID, '703345b5-706b-5eec-9127-3f8371041c8f'::UUID, 'd3b3975e-8e70-5983-b41d-313318f94556'::UUID, '94a4edcc-9e46-58fa-8c6d-bb0e11994fa8'::UUID, '69ed4631-f86f-56b4-ba62-134a737d687b'::UUID, '150e9ea7-ac9b-59d6-b28d-be882362f2eb'::UUID, 'c02afe98-2bbd-57fb-98e1-186a126f8a03'::UUID, 'bdd5e8b5-a715-516d-96ed-abb233410402'::UUID, 'eae95af5-ea09-526f-9f92-2545c07c48e3'::UUID, '87d75fcc-4ff0-502e-ad80-e720e55b116f'::UUID, '0b55d0e6-8281-57ba-9574-2964760facf3'::UUID, 'a7cc9a21-6e70-5a26-8c59-29c2ac25e034'::UUID]::UUID[])) <> 30 THEN
    RAISE EXCEPTION 'Content batch batch-04-hsk3 is missing managed exercise_options rows';
  END IF;
  IF EXISTS (
    SELECT 1 FROM public.lessons AS lesson
    WHERE lesson.id = ANY(ARRAY['b0494aea-58d9-5ac9-a62c-c371d24f7bf6'::UUID, '1958b3c8-38d0-5ce8-8206-e177270eb99b'::UUID, '13ffd3bc-d55d-55f0-902f-3590bb158c3b'::UUID, '60e56a80-35f4-5fc2-aa12-3c6ea47ac253'::UUID, 'cd071a71-79b2-51f5-b3b1-ebf1f0ccee5d'::UUID]::UUID[])
      AND NOT EXISTS (
        SELECT 1 FROM public.exercises AS exercise
        WHERE exercise.lesson_id = lesson.id
      )
  ) THEN
    RAISE EXCEPTION 'Content batch batch-04-hsk3 contains a lesson without exercises';
  END IF;
  IF EXISTS (
    SELECT 1
    FROM public.lessons AS lesson
    JOIN public.exercises AS exercise ON exercise.lesson_id = lesson.id
    WHERE lesson.id = ANY(ARRAY['b0494aea-58d9-5ac9-a62c-c371d24f7bf6'::UUID, '1958b3c8-38d0-5ce8-8206-e177270eb99b'::UUID, '13ffd3bc-d55d-55f0-902f-3590bb158c3b'::UUID, '60e56a80-35f4-5fc2-aa12-3c6ea47ac253'::UUID, 'cd071a71-79b2-51f5-b3b1-ebf1f0ccee5d'::UUID]::UUID[])
      AND lesson.status = 'published'
      AND exercise.exercise_type = 'listening'
      AND NULLIF(BTRIM(exercise.question_audio_url), '') IS NULL
  ) THEN
    RAISE EXCEPTION 'Published listening exercise is missing playable audio';
  END IF;
  IF EXISTS (
    SELECT 1
    FROM public.exercises AS exercise
    WHERE exercise.id = ANY(ARRAY['7599d655-f0f5-5080-bdf6-bbd330e7052c'::UUID, '56653638-089e-5e1a-8daa-345889b1ee9d'::UUID, 'ff57124c-f601-52cc-b397-8904cc41ead5'::UUID, '027bbc06-f34a-5648-aea4-dc68613cf957'::UUID, 'df8baf12-3976-5857-8473-ca74c4c35070'::UUID, 'c81a44d4-01dc-56d4-a95d-3fec89bf3755'::UUID, '2ad13705-8aef-52e6-bd06-32f2f0d3f993'::UUID, '82df1330-3929-559e-8404-3cd20cf40d55'::UUID, 'dc865520-5590-5ce7-b78e-052dd5157f46'::UUID, '4b3d3878-cc47-54bc-8628-be9b9985977b'::UUID, 'e1df1aab-2037-5ee2-b566-d46849154468'::UUID, '0e4b0305-2438-51be-846d-376782c2bcda'::UUID, '0a902184-d144-5a8d-bd7f-2d19cf3edece'::UUID, '4385caf1-f9aa-55d9-a03b-509a8c9a2fd8'::UUID, 'eeddb2f1-2156-5f0c-9e38-f3113f5d60ff'::UUID, 'b4ea6197-d3c8-5cf3-9dfd-9bbbb05f08d4'::UUID, '676831cf-bd7c-5d99-941c-7247d9a9a4b9'::UUID, 'afbf8afc-cdcc-5a9c-b228-2fdde8e2d9e4'::UUID, '27456fd0-7734-59fa-9ebd-901472f4b4ca'::UUID, 'aac11eea-2dec-5ba2-b541-1324841f0c00'::UUID, 'ef97616e-7936-56c9-84b6-c8ff12848962'::UUID, 'c9217b3d-d628-589c-9bbd-ed705e5eebdb'::UUID, '00025ef1-21a0-5abc-a863-f22ca163fb9b'::UUID, '73712eaa-bc1d-5b63-a081-b1deae6781c2'::UUID, 'ebdc4a59-be90-5693-83df-87ec91f3023a'::UUID, 'd9c36209-d0aa-5fe2-9d14-d39ef2925f47'::UUID, '2685cf53-dc1e-564e-aba5-7f4c60138cc7'::UUID, '6586565a-c567-528b-83be-ba930fe2ffc5'::UUID, 'c1987c34-7dd8-51e0-820f-de492090ebca'::UUID, 'ff1ebb65-be88-51b5-a0a2-e23b28c3a0c2'::UUID, 'e4b565c5-d9d5-555b-a697-915193071bc5'::UUID, '68fe78eb-d98c-54e4-b2d6-9606727a8229'::UUID, 'bde0cf35-9301-59df-8860-c0e23563bea1'::UUID, '9fa449e2-81fe-551e-85f7-e35a99b187b2'::UUID, '467927e2-7d26-5ce0-8e2c-98edcd0cf557'::UUID, '123ed5f0-2188-558a-abf0-d93d03df292a'::UUID, '27f4db13-b161-56e0-8003-a6324fc0aaa5'::UUID]::UUID[])
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
    WHERE link.lesson_id = ANY(ARRAY['b0494aea-58d9-5ac9-a62c-c371d24f7bf6'::UUID, '1958b3c8-38d0-5ce8-8206-e177270eb99b'::UUID, '13ffd3bc-d55d-55f0-902f-3590bb158c3b'::UUID, '60e56a80-35f4-5fc2-aa12-3c6ea47ac253'::UUID, 'cd071a71-79b2-51f5-b3b1-ebf1f0ccee5d'::UUID]::UUID[])
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
