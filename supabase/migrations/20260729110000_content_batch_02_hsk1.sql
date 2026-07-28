-- Generated from content/manifests/02_hsk1.json.
-- Do not hand-edit this migration; edit the manifest and regenerate.
-- Additive and idempotent: deterministic IDs plus ON CONFLICT DO NOTHING.

BEGIN;

INSERT INTO public.courses (id, slug, title, title_zh, description, level, status, order_index, learning_objectives, estimated_minutes, content_version)
VALUES ('33228bdd-72c2-54f3-b187-0af47cd18790'::UUID, 'hsk-1', 'HSK 1', 'HSK 一级', 'Nền tảng giao tiếp và đọc hiểu ở trình độ HSK 1.', 'beginner', 'review', 2, '["Hiểu và dùng mẫu câu HSK 1 trong tình huống quen thuộc","Đọc, nói và viết các câu ngắn với trật tự từ cơ bản","Chuẩn bị nền tảng chuyển tiếp lên HSK 2"]'::JSONB, 138, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.units (id, course_id, slug, title, description, order_index, status, learning_objectives, content_version)
VALUES ('aeb45b3f-6c10-584a-baa5-1a020b62a9dc'::UUID, '33228bdd-72c2-54f3-b187-0af47cd18790'::UUID, 'hsk1-giao-tiep', 'Giao tiếp ban đầu', 'Xưng hô, làm quen và mô tả người.', 1, 'review', '["Chào hỏi lịch sự","Giới thiệu quan hệ và nghề nghiệp"]'::JSONB, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.chapters (id, unit_id, slug, title, description, order_index, status, learning_objectives, content_version)
VALUES ('f41449ef-08e2-5d4c-a9c1-a7074c794626'::UUID, 'aeb45b3f-6c10-584a-baa5-1a020b62a9dc'::UUID, 'hsk1-giao-tiep-chapter', 'Chào hỏi và con người', 'Xưng hô, làm quen và mô tả người.', 1, 'review', '["Chào hỏi lịch sự","Giới thiệu quan hệ và nghề nghiệp"]'::JSONB, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lessons (id, chapter_id, slug, title, description, order_index, xp_reward, status, lesson_type, estimated_minutes, learning_objectives, cultural_note, content_version)
VALUES ('cd97bc6a-cfbd-5e9e-a2a0-ec9aaf890232'::UUID, 'f41449ef-08e2-5d4c-a9c1-a7074c794626'::UUID, 'xung-ho-lich-su', '您好！— Chào hỏi lịch sự', 'Dùng 您, 请 và cách hỏi họ lịch sự.', 1, 25, 'review', 'standard', 15, '["Chào người lớn tuổi hoặc khách hàng","Hỏi họ và làm quen"]'::JSONB, '贵姓 là cách hỏi họ lịch sự; không dùng để tự nói họ của mình.', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('16302ca3-ea03-5554-8585-1005c2995fd1'::UUID, 'hsk1:您', '您', 'nín', 'ngài, ông/bà (lịch sự)', 'you (polite)', 'beginner', 'xung-ho-lich-su', 'đại từ', '您好，请问您贵姓？', 'Nín hǎo, qǐngwèn nín guìxìng?', 'Xin chào, xin hỏi quý danh của ngài?', NULL, 'review', 'cd97bc6a-cfbd-5e9e-a2a0-ec9aaf890232'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('e695336f-a0d2-5219-9d7c-2f83242a10b4'::UUID, 'cd97bc6a-cfbd-5e9e-a2a0-ec9aaf890232'::UUID, '16302ca3-ea03-5554-8585-1005c2995fd1'::UUID, 1, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('8f30f717-1579-5142-9e2a-a61e4556f7bb'::UUID, 'hsk1:请问', '请问', 'qǐngwèn', 'xin hỏi', 'may I ask', 'beginner', 'xung-ho-lich-su', 'động từ', '请问，地铁站在哪儿？', 'Qǐngwèn, dìtiě zhàn zài nǎr?', 'Xin hỏi, ga tàu điện ngầm ở đâu?', NULL, 'review', 'cd97bc6a-cfbd-5e9e-a2a0-ec9aaf890232'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('330530e7-c427-56ec-99d1-17adc57230b8'::UUID, 'cd97bc6a-cfbd-5e9e-a2a0-ec9aaf890232'::UUID, '8f30f717-1579-5142-9e2a-a61e4556f7bb'::UUID, 2, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('98ace347-6976-5dcf-a254-2baa97ee5361'::UUID, 'hsk1:贵姓', '贵姓', 'guìxìng', 'quý danh, họ của ngài', 'your surname', 'beginner', 'xung-ho-lich-su', 'cụm từ lịch sự', '请问您贵姓？', 'Qǐngwèn nín guìxìng?', 'Xin hỏi quý danh của ngài?', NULL, 'review', 'cd97bc6a-cfbd-5e9e-a2a0-ec9aaf890232'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('ba7ec0e2-43fd-59eb-a323-97237bea6543'::UUID, 'cd97bc6a-cfbd-5e9e-a2a0-ec9aaf890232'::UUID, '98ace347-6976-5dcf-a254-2baa97ee5361'::UUID, 3, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('fc9bbbc2-b0e0-5940-bcd9-0f9e07ac6676'::UUID, 'hsk1:认识', '认识', 'rènshi', 'quen, biết', 'to know; meet', 'beginner', 'xung-ho-lich-su', 'động từ', '很高兴认识您。', 'Hěn gāoxìng rènshi nín.', 'Rất vui được làm quen với ngài.', NULL, 'review', 'cd97bc6a-cfbd-5e9e-a2a0-ec9aaf890232'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('8cd9dc1c-5e36-5ed7-9cbd-bd41410c638b'::UUID, 'cd97bc6a-cfbd-5e9e-a2a0-ec9aaf890232'::UUID, 'fc9bbbc2-b0e0-5940-bcd9-0f9e07ac6676'::UUID, 4, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('0eeb30d5-2c31-5155-9b95-e09e0b9d7b0a'::UUID, 'cd97bc6a-cfbd-5e9e-a2a0-ec9aaf890232'::UUID, 'f0000000-0000-0000-0000-000000000003'::UUID, 5, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('028b6a06-b27e-5d14-978c-5112a7968f3d'::UUID, 'cd97bc6a-cfbd-5e9e-a2a0-ec9aaf890232'::UUID, 'f0000000-0000-0000-0000-000000000008'::UUID, 6, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('a4687306-536d-5399-9ef0-da51964b06ce'::UUID, 'cd97bc6a-cfbd-5e9e-a2a0-ec9aaf890232'::UUID, 'b4532d2f-c0a1-52f0-b907-73fe8bb1c3f8'::UUID, 7, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.grammar_lessons (id, content_key, title, pattern, explanation, example_chinese, example_pinyin, example_meaning, level, status, usage_note, content_version)
VALUES ('1d8cb9b9-2204-516a-904b-3b1d262f6e3b'::UUID, 'hsk1:xung-ho-lich-su', 'Câu hỏi lịch sự với 请问', '请问 + câu hỏi', 'Đặt 请问 trước câu hỏi để mở lời lịch sự.', '请问您贵姓？', 'Qǐngwèn nín guìxìng?', 'Xin hỏi quý danh của ngài?', 'beginner', 'review', NULL, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_grammar (id, lesson_id, grammar_lesson_id, order_index, curriculum_role)
VALUES ('ece8418c-8bba-55b0-af2e-e919d7aebad9'::UUID, 'cd97bc6a-cfbd-5e9e-a2a0-ec9aaf890232'::UUID, '1d8cb9b9-2204-516a-904b-3b1d262f6e3b'::UUID, 1, 'introduced')
ON CONFLICT (lesson_id, grammar_lesson_id) DO NOTHING;

INSERT INTO public.lesson_grammar (id, lesson_id, grammar_lesson_id, order_index, curriculum_role)
VALUES ('95482a7c-4c26-5af6-93e3-8120e202997f'::UUID, 'cd97bc6a-cfbd-5e9e-a2a0-ec9aaf890232'::UUID, 'cc829157-96aa-55c6-823c-ab112447cf96'::UUID, 2, 'review')
ON CONFLICT (lesson_id, grammar_lesson_id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('ac44c5d5-727d-5448-970d-dbbd3f388724'::UUID, 'cd97bc6a-cfbd-5e9e-a2a0-ec9aaf890232'::UUID, 'vocabulary', 1, 'Từ mới: 您', NULL, '您', '您 (nín) — ngài, ông/bà (lịch sự). 您好，请问您贵姓？', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"hsk1:您","chinese":"您","pinyin":"nín","meaning":"ngài, ông/bà (lịch sự)","part_of_speech":"đại từ","example_chinese":"您好，请问您贵姓？","example_pinyin":"Nín hǎo, qǐngwèn nín guìxìng?","example_meaning_vi":"Xin chào, xin hỏi quý danh của ngài?"}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('bc33a069-6780-56dc-9732-e421ebb5878f'::UUID, 'cd97bc6a-cfbd-5e9e-a2a0-ec9aaf890232'::UUID, 'vocabulary', 2, 'Từ mới: 请问', NULL, '请问', '请问 (qǐngwèn) — xin hỏi. 请问，地铁站在哪儿？', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"hsk1:请问","chinese":"请问","pinyin":"qǐngwèn","meaning":"xin hỏi","part_of_speech":"động từ","example_chinese":"请问，地铁站在哪儿？","example_pinyin":"Qǐngwèn, dìtiě zhàn zài nǎr?","example_meaning_vi":"Xin hỏi, ga tàu điện ngầm ở đâu?"}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('de51c512-50e4-5377-a02a-d7f92fee2088'::UUID, 'cd97bc6a-cfbd-5e9e-a2a0-ec9aaf890232'::UUID, 'vocabulary', 3, 'Từ mới: 贵姓', NULL, '贵姓', '贵姓 (guìxìng) — quý danh, họ của ngài. 请问您贵姓？', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"hsk1:贵姓","chinese":"贵姓","pinyin":"guìxìng","meaning":"quý danh, họ của ngài","part_of_speech":"cụm từ lịch sự","example_chinese":"请问您贵姓？","example_pinyin":"Qǐngwèn nín guìxìng?","example_meaning_vi":"Xin hỏi quý danh của ngài?"}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('8da2b124-34eb-54b7-8c19-c08f4e52fad4'::UUID, 'cd97bc6a-cfbd-5e9e-a2a0-ec9aaf890232'::UUID, 'vocabulary', 4, 'Từ mới: 认识', NULL, '认识', '认识 (rènshi) — quen, biết. 很高兴认识您。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"hsk1:认识","chinese":"认识","pinyin":"rènshi","meaning":"quen, biết","part_of_speech":"động từ","example_chinese":"很高兴认识您。","example_pinyin":"Hěn gāoxìng rènshi nín.","example_meaning_vi":"Rất vui được làm quen với ngài."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('dd2add91-b8c9-5905-a143-263b68d3cda7'::UUID, 'cd97bc6a-cfbd-5e9e-a2a0-ec9aaf890232'::UUID, 'multiple_choice', 5, '“您” có nghĩa phù hợp nhất là gì?', NULL, 'ngài, ông/bà (lịch sự)', '您 (nín) nghĩa là “ngài, ông/bà (lịch sự)”.', NULL, 1, '{"activity_type":"chinese_to_vietnamese","vocabulary_key":"hsk1:您"}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('2ed6b824-d6c1-5ddd-ba17-540c35ffded0'::UUID, 'dd2add91-b8c9-5905-a143-263b68d3cda7'::UUID, 'xin hỏi', FALSE, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('c1e4b1a4-7f08-5ddf-b003-832b6ac8030e'::UUID, 'dd2add91-b8c9-5905-a143-263b68d3cda7'::UUID, 'quý danh, họ của ngài', FALSE, 2)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('9c67f9af-83ed-56c4-8c3c-e3f49a8738e4'::UUID, 'dd2add91-b8c9-5905-a143-263b68d3cda7'::UUID, 'quen, biết', FALSE, 3)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('2646b6ad-4307-5be3-8999-2d2c08c6fc8d'::UUID, 'dd2add91-b8c9-5905-a143-263b68d3cda7'::UUID, 'ngài, ông/bà (lịch sự)', TRUE, 4)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('b0b0b7fd-3881-5c35-ab17-f7db482b243d'::UUID, 'cd97bc6a-cfbd-5e9e-a2a0-ec9aaf890232'::UUID, 'translation', 6, 'Dịch sang tiếng Trung: “Xin hỏi quý danh của ngài?”', NULL, '请问您贵姓？', 'Mẫu câu dùng “您” trong ngữ cảnh của bài.', 'nín', 1, '{"activity_type":"vietnamese_to_chinese","source_lang":"vi","target_lang":"zh","acceptable_answers":["请问您贵姓？"]}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('5db90aa7-7e76-5e71-8383-e23aa2cf3bcc'::UUID, 'cd97bc6a-cfbd-5e9e-a2a0-ec9aaf890232'::UUID, 'sentence_builder', 7, 'Sắp xếp các thành phần thành câu đúng.', NULL, '请问您贵姓？', 'Trật tự đúng tạo thành câu “请问您贵姓？”.', NULL, 1, '{"activity_type":"sentence_ordering","words":["请问","您","贵姓","？"],"correct_order":["请问","您","贵姓","？"]}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('bfe5dfb7-e598-51b6-9543-85bc69fcce93'::UUID, 'cd97bc6a-cfbd-5e9e-a2a0-ec9aaf890232'::UUID, 'multiple_choice', 8, 'Câu nào hỏi họ một cách lịch sự?', NULL, '请问您贵姓？', 'Đặt 请问 trước câu hỏi để mở lời lịch sự.', NULL, 1, '{"activity_type":"grammar_selection","passage":null,"grammar_key":"hsk1:xung-ho-lich-su"}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('92286edc-5480-52a4-8d8c-6ed7fd3a0593'::UUID, 'bfe5dfb7-e598-51b6-9543-85bc69fcce93'::UUID, '请问您贵姓？', TRUE, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('1321f10d-c6ac-5acb-b8c3-dfbb72614672'::UUID, 'bfe5dfb7-e598-51b6-9543-85bc69fcce93'::UUID, '您贵姓请问？', FALSE, 2)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('51b7cf2c-0ec1-55af-914b-10e723e0db8d'::UUID, 'bfe5dfb7-e598-51b6-9543-85bc69fcce93'::UUID, '贵姓您不请问。', FALSE, 3)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('fd2909c5-e589-5cfe-93dc-b6f3a0c867bf'::UUID, 'cd97bc6a-cfbd-5e9e-a2a0-ec9aaf890232'::UUID, 'speaking', 9, 'Đọc thành tiếng: 请问您贵姓？', NULL, '请问您贵姓？', 'Đọc chậm, giữ đúng thanh điệu và nhịp của cả câu.', NULL, 1, '{"activity_type":"pronunciation","text":"请问您贵姓？","pinyin":"Qǐngwèn nín guìxìng?"}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lessons (id, chapter_id, slug, title, description, order_index, xp_reward, status, lesson_type, estimated_minutes, learning_objectives, cultural_note, content_version)
VALUES ('9710f45f-7a87-55ee-b54e-856b955194aa'::UUID, 'f41449ef-08e2-5d4c-a9c1-a7074c794626'::UUID, 'ban-be-va-nghe-nghiep', '同学和老师 — Bạn học và giáo viên', 'Giới thiệu quan hệ và nghề nghiệp gần gũi.', 2, 25, 'review', 'standard', 15, '["Nói ai là ai","Dùng 的 để chỉ quan hệ"]'::JSONB, NULL, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('ea61e78e-a574-5237-a177-c50ffc1c0c55'::UUID, 'hsk1:老师', '老师', 'lǎoshī', 'giáo viên', 'teacher', 'beginner', 'ban-be-va-nghe-nghiep', 'danh từ', '王老师教我们汉语。', 'Wáng lǎoshī jiāo wǒmen Hànyǔ.', 'Thầy Vương dạy chúng tôi tiếng Trung.', NULL, 'review', '9710f45f-7a87-55ee-b54e-856b955194aa'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('81a37ada-13b9-5b3e-bf96-5100c961387c'::UUID, '9710f45f-7a87-55ee-b54e-856b955194aa'::UUID, 'ea61e78e-a574-5237-a177-c50ffc1c0c55'::UUID, 1, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('90b68c4e-94bc-5105-b01c-6a4001d2e1cb'::UUID, 'hsk1:同学', '同学', 'tóngxué', 'bạn học', 'classmate', 'beginner', 'ban-be-va-nghe-nghiep', 'danh từ', '她是我的同学。', 'Tā shì wǒ de tóngxué.', 'Cô ấy là bạn học của tôi.', NULL, 'review', '9710f45f-7a87-55ee-b54e-856b955194aa'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('53d9ab2a-1d2c-52fb-b943-cb42d6c01d10'::UUID, '9710f45f-7a87-55ee-b54e-856b955194aa'::UUID, '90b68c4e-94bc-5105-b01c-6a4001d2e1cb'::UUID, 2, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('376c5db5-b63d-5152-964f-c207d2f36d44'::UUID, 'hsk1:先生', '先生', 'xiānsheng', 'ông, ngài', 'Mr.; sir', 'beginner', 'ban-be-va-nghe-nghiep', 'danh từ', '李先生是医生。', 'Lǐ xiānsheng shì yīshēng.', 'Ông Lý là bác sĩ.', NULL, 'review', '9710f45f-7a87-55ee-b54e-856b955194aa'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('d509a0d3-1e4f-536d-ab25-f065b6deda38'::UUID, '9710f45f-7a87-55ee-b54e-856b955194aa'::UUID, '376c5db5-b63d-5152-964f-c207d2f36d44'::UUID, 3, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('44afe437-86b4-5306-896f-e70d2960aeb6'::UUID, 'hsk1:医生', '医生', 'yīshēng', 'bác sĩ', 'doctor', 'beginner', 'ban-be-va-nghe-nghiep', 'danh từ', '我姐姐是医生。', 'Wǒ jiějie shì yīshēng.', 'Chị gái tôi là bác sĩ.', NULL, 'review', '9710f45f-7a87-55ee-b54e-856b955194aa'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('5b3ca50d-ef12-5398-b723-475547a9d8d7'::UUID, '9710f45f-7a87-55ee-b54e-856b955194aa'::UUID, '44afe437-86b4-5306-896f-e70d2960aeb6'::UUID, 4, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('a0dc79cc-aa9a-5980-92ec-f13997486633'::UUID, '9710f45f-7a87-55ee-b54e-856b955194aa'::UUID, '16302ca3-ea03-5554-8585-1005c2995fd1'::UUID, 5, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('322925b8-f562-573f-8359-a10b6b27af5b'::UUID, '9710f45f-7a87-55ee-b54e-856b955194aa'::UUID, '8f30f717-1579-5142-9e2a-a61e4556f7bb'::UUID, 6, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('3c51d120-a6a2-5415-8bdf-98223b11e0a4'::UUID, '9710f45f-7a87-55ee-b54e-856b955194aa'::UUID, '98ace347-6976-5dcf-a254-2baa97ee5361'::UUID, 7, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('bcc0da8d-7ef8-5a28-8413-67b8b504a3fd'::UUID, '9710f45f-7a87-55ee-b54e-856b955194aa'::UUID, 'fc9bbbc2-b0e0-5940-bcd9-0f9e07ac6676'::UUID, 8, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.grammar_lessons (id, content_key, title, pattern, explanation, example_chinese, example_pinyin, example_meaning, level, status, usage_note, content_version)
VALUES ('60d82f9f-4d46-5250-ae8a-6e29d6e2478a'::UUID, 'hsk1:ban-be-va-nghe-nghiep', 'Quan hệ sở hữu với 的', 'A + 的 + B', '的 nối người sở hữu hoặc quan hệ với danh từ đứng sau.', '她是我的同学。', 'Tā shì wǒ de tóngxué.', 'Cô ấy là bạn học của tôi.', 'beginner', 'review', NULL, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_grammar (id, lesson_id, grammar_lesson_id, order_index, curriculum_role)
VALUES ('d9d0a380-74a7-5ed0-b983-3f6961e67016'::UUID, '9710f45f-7a87-55ee-b54e-856b955194aa'::UUID, '60d82f9f-4d46-5250-ae8a-6e29d6e2478a'::UUID, 1, 'introduced')
ON CONFLICT (lesson_id, grammar_lesson_id) DO NOTHING;

INSERT INTO public.lesson_grammar (id, lesson_id, grammar_lesson_id, order_index, curriculum_role)
VALUES ('b33a8545-ac41-5d40-af5b-ca68efacadd6'::UUID, '9710f45f-7a87-55ee-b54e-856b955194aa'::UUID, '1d8cb9b9-2204-516a-904b-3b1d262f6e3b'::UUID, 2, 'review')
ON CONFLICT (lesson_id, grammar_lesson_id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('0a04bcd1-a3d7-5b3d-8be5-964a9ad46116'::UUID, '9710f45f-7a87-55ee-b54e-856b955194aa'::UUID, 'vocabulary', 1, 'Từ mới: 老师', NULL, '老师', '老师 (lǎoshī) — giáo viên. 王老师教我们汉语。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"hsk1:老师","chinese":"老师","pinyin":"lǎoshī","meaning":"giáo viên","part_of_speech":"danh từ","example_chinese":"王老师教我们汉语。","example_pinyin":"Wáng lǎoshī jiāo wǒmen Hànyǔ.","example_meaning_vi":"Thầy Vương dạy chúng tôi tiếng Trung."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('0cda6301-a437-51e4-8939-bb35f36f81de'::UUID, '9710f45f-7a87-55ee-b54e-856b955194aa'::UUID, 'vocabulary', 2, 'Từ mới: 同学', NULL, '同学', '同学 (tóngxué) — bạn học. 她是我的同学。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"hsk1:同学","chinese":"同学","pinyin":"tóngxué","meaning":"bạn học","part_of_speech":"danh từ","example_chinese":"她是我的同学。","example_pinyin":"Tā shì wǒ de tóngxué.","example_meaning_vi":"Cô ấy là bạn học của tôi."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('a585998f-f61f-56b9-9d2b-18bd8491d4ca'::UUID, '9710f45f-7a87-55ee-b54e-856b955194aa'::UUID, 'vocabulary', 3, 'Từ mới: 先生', NULL, '先生', '先生 (xiānsheng) — ông, ngài. 李先生是医生。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"hsk1:先生","chinese":"先生","pinyin":"xiānsheng","meaning":"ông, ngài","part_of_speech":"danh từ","example_chinese":"李先生是医生。","example_pinyin":"Lǐ xiānsheng shì yīshēng.","example_meaning_vi":"Ông Lý là bác sĩ."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('9a8e1068-422c-59e0-be75-d4f76c97dc2b'::UUID, '9710f45f-7a87-55ee-b54e-856b955194aa'::UUID, 'vocabulary', 4, 'Từ mới: 医生', NULL, '医生', '医生 (yīshēng) — bác sĩ. 我姐姐是医生。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"hsk1:医生","chinese":"医生","pinyin":"yīshēng","meaning":"bác sĩ","part_of_speech":"danh từ","example_chinese":"我姐姐是医生。","example_pinyin":"Wǒ jiějie shì yīshēng.","example_meaning_vi":"Chị gái tôi là bác sĩ."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('7231b542-dcbc-56d4-b3a5-458c40fe88cb'::UUID, '9710f45f-7a87-55ee-b54e-856b955194aa'::UUID, 'multiple_choice', 5, '“老师” có nghĩa phù hợp nhất là gì?', NULL, 'giáo viên', '老师 (lǎoshī) nghĩa là “giáo viên”.', NULL, 1, '{"activity_type":"chinese_to_vietnamese","vocabulary_key":"hsk1:老师"}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('e5050d46-2725-5a16-b6f0-4557fc8b1922'::UUID, '7231b542-dcbc-56d4-b3a5-458c40fe88cb'::UUID, 'ông, ngài', FALSE, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('4a432469-cd35-5233-af0b-31f727361602'::UUID, '7231b542-dcbc-56d4-b3a5-458c40fe88cb'::UUID, 'bác sĩ', FALSE, 2)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('fa0710f7-0f2a-55ab-8c8c-38e6f72aa3e1'::UUID, '7231b542-dcbc-56d4-b3a5-458c40fe88cb'::UUID, 'giáo viên', TRUE, 3)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('358c65c3-2b06-5a74-b08f-f797eeb477c2'::UUID, '7231b542-dcbc-56d4-b3a5-458c40fe88cb'::UUID, 'bạn học', FALSE, 4)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('5213cbd1-e2e1-5259-8fe2-3aeecf590845'::UUID, '9710f45f-7a87-55ee-b54e-856b955194aa'::UUID, 'translation', 6, 'Dịch sang tiếng Trung: “Cô ấy là bạn học của tôi.”', NULL, '她是我的同学。', 'Mẫu câu dùng “老师” trong ngữ cảnh của bài.', 'lǎoshī', 1, '{"activity_type":"vietnamese_to_chinese","source_lang":"vi","target_lang":"zh","acceptable_answers":["她是我的同学。"]}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('6ce0e2f1-19b4-5ac3-9e30-5713468bbc54'::UUID, '9710f45f-7a87-55ee-b54e-856b955194aa'::UUID, 'sentence_builder', 7, 'Sắp xếp các thành phần thành câu đúng.', NULL, '她是我的同学。', 'Trật tự đúng tạo thành câu “她是我的同学。”.', NULL, 1, '{"activity_type":"sentence_ordering","words":["她","是","我","的","同学","。"],"correct_order":["她","是","我","的","同学","。"]}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('8aa79b85-f606-5687-afec-8ca6eeae1c42'::UUID, '9710f45f-7a87-55ee-b54e-856b955194aa'::UUID, 'multiple_choice', 8, 'Câu nào nói “Cô ấy là bạn học của tôi”?', NULL, '她是我的同学。', '的 nối người sở hữu hoặc quan hệ với danh từ đứng sau.', NULL, 1, '{"activity_type":"grammar_selection","passage":null,"grammar_key":"hsk1:ban-be-va-nghe-nghiep"}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('c3447268-d70b-5261-9b76-bd3d3c735cc4'::UUID, '8aa79b85-f606-5687-afec-8ca6eeae1c42'::UUID, '她是我的同学。', TRUE, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('68d9fc6e-3913-541a-83a7-d2f8aeb49ce6'::UUID, '8aa79b85-f606-5687-afec-8ca6eeae1c42'::UUID, '她我的同学是。', FALSE, 2)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('c0f115ad-e143-541e-9702-a303dfe3afc5'::UUID, '8aa79b85-f606-5687-afec-8ca6eeae1c42'::UUID, '她是我同学的。', FALSE, 3)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('076ffed1-457b-53e1-be3f-01419b41ef2d'::UUID, '9710f45f-7a87-55ee-b54e-856b955194aa'::UUID, 'speaking', 9, 'Đọc thành tiếng: 她是我的同学。', NULL, '她是我的同学。', 'Đọc chậm, giữ đúng thanh điệu và nhịp của cả câu.', NULL, 1, '{"activity_type":"pronunciation","text":"她是我的同学。","pinyin":"Tā shì wǒ de tóngxué."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lessons (id, chapter_id, slug, title, description, order_index, xp_reward, status, lesson_type, estimated_minutes, learning_objectives, cultural_note, content_version)
VALUES ('c069c208-1e99-52b9-833c-67939fb1fb5d'::UUID, 'f41449ef-08e2-5d4c-a9c1-a7074c794626'::UUID, 'hoi-ai-va-o-dau', '谁在哪儿？— Ai ở đâu?', 'Hỏi người và vị trí bằng 谁, 哪儿.', 3, 25, 'review', 'standard', 15, '["Đặt câu hỏi về người","Nói vị trí với 在"]'::JSONB, NULL, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('14890f3e-8da5-5ba6-9a67-af085c82d012'::UUID, 'hsk1:谁', '谁', 'shéi', 'ai', 'who', 'beginner', 'hoi-ai-va-o-dau', 'đại từ nghi vấn', '门口的人是谁？', 'Ménkǒu de rén shì shéi?', 'Người ở cửa là ai?', NULL, 'review', 'c069c208-1e99-52b9-833c-67939fb1fb5d'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('39770866-41e2-5eb3-bb27-3909ef0221cc'::UUID, 'c069c208-1e99-52b9-833c-67939fb1fb5d'::UUID, '14890f3e-8da5-5ba6-9a67-af085c82d012'::UUID, 1, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('3b16a062-a1c4-549b-bf7d-d4c476c2dae2'::UUID, 'hsk1:哪儿', '哪儿', 'nǎr', 'đâu, nơi nào', 'where', 'beginner', 'hoi-ai-va-o-dau', 'đại từ nghi vấn', '你的学校在哪儿？', 'Nǐ de xuéxiào zài nǎr?', 'Trường của bạn ở đâu?', NULL, 'review', 'c069c208-1e99-52b9-833c-67939fb1fb5d'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('62ac9e50-8eb3-59cd-ac39-b7ceacb59535'::UUID, 'c069c208-1e99-52b9-833c-67939fb1fb5d'::UUID, '3b16a062-a1c4-549b-bf7d-d4c476c2dae2'::UUID, 2, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('861ecff4-5aeb-5b4a-ab9e-33f5d36a3e7d'::UUID, 'hsk1:学校', '学校', 'xuéxiào', 'trường học', 'school', 'beginner', 'hoi-ai-va-o-dau', 'danh từ', '学校离我家很近。', 'Xuéxiào lí wǒ jiā hěn jìn.', 'Trường học rất gần nhà tôi.', NULL, 'review', 'c069c208-1e99-52b9-833c-67939fb1fb5d'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('082c8f4d-7d8c-5098-b188-ca0013706e7a'::UUID, 'c069c208-1e99-52b9-833c-67939fb1fb5d'::UUID, '861ecff4-5aeb-5b4a-ab9e-33f5d36a3e7d'::UUID, 3, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('cb6f55f5-b2d2-5c1a-83fb-6d5127b63758'::UUID, 'hsk1:医院', '医院', 'yīyuàn', 'bệnh viện', 'hospital', 'beginner', 'hoi-ai-va-o-dau', 'danh từ', '医院在银行旁边。', 'Yīyuàn zài yínháng pángbiān.', 'Bệnh viện ở cạnh ngân hàng.', NULL, 'review', 'c069c208-1e99-52b9-833c-67939fb1fb5d'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('22356e33-8c71-5768-b636-315fc7cebdcc'::UUID, 'c069c208-1e99-52b9-833c-67939fb1fb5d'::UUID, 'cb6f55f5-b2d2-5c1a-83fb-6d5127b63758'::UUID, 4, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('3fae4c19-2630-502d-9e8d-55595381f295'::UUID, 'c069c208-1e99-52b9-833c-67939fb1fb5d'::UUID, 'ea61e78e-a574-5237-a177-c50ffc1c0c55'::UUID, 5, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('6e6f6b9e-bbc1-57d1-9baa-d9ea0d292f8a'::UUID, 'c069c208-1e99-52b9-833c-67939fb1fb5d'::UUID, '90b68c4e-94bc-5105-b01c-6a4001d2e1cb'::UUID, 6, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('bc9ddd2b-3374-5a23-83ef-b18346705396'::UUID, 'c069c208-1e99-52b9-833c-67939fb1fb5d'::UUID, '376c5db5-b63d-5152-964f-c207d2f36d44'::UUID, 7, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('dae79e82-860e-5adc-bfc5-43bc64b4d558'::UUID, 'c069c208-1e99-52b9-833c-67939fb1fb5d'::UUID, '44afe437-86b4-5306-896f-e70d2960aeb6'::UUID, 8, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.grammar_lessons (id, content_key, title, pattern, explanation, example_chinese, example_pinyin, example_meaning, level, status, usage_note, content_version)
VALUES ('8ed9f1e5-e93e-5799-b03f-6228e3b641b4'::UUID, 'hsk1:hoi-ai-va-o-dau', 'Vị trí với 在', 'chủ ngữ + 在 + địa điểm', '在 đứng trước địa điểm để nói người hoặc vật đang ở đâu.', '医院在银行旁边。', 'Yīyuàn zài yínháng pángbiān.', 'Bệnh viện ở cạnh ngân hàng.', 'beginner', 'review', NULL, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_grammar (id, lesson_id, grammar_lesson_id, order_index, curriculum_role)
VALUES ('2f90366f-a0d6-5882-b4ca-5ae97f82efab'::UUID, 'c069c208-1e99-52b9-833c-67939fb1fb5d'::UUID, '8ed9f1e5-e93e-5799-b03f-6228e3b641b4'::UUID, 1, 'introduced')
ON CONFLICT (lesson_id, grammar_lesson_id) DO NOTHING;

INSERT INTO public.lesson_grammar (id, lesson_id, grammar_lesson_id, order_index, curriculum_role)
VALUES ('e94f0e97-21db-555e-9e02-a8a0d84b9ed0'::UUID, 'c069c208-1e99-52b9-833c-67939fb1fb5d'::UUID, '60d82f9f-4d46-5250-ae8a-6e29d6e2478a'::UUID, 2, 'review')
ON CONFLICT (lesson_id, grammar_lesson_id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('62ae08e4-b092-55f1-b7e9-800440896d56'::UUID, 'c069c208-1e99-52b9-833c-67939fb1fb5d'::UUID, 'vocabulary', 1, 'Từ mới: 谁', NULL, '谁', '谁 (shéi) — ai. 门口的人是谁？', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"hsk1:谁","chinese":"谁","pinyin":"shéi","meaning":"ai","part_of_speech":"đại từ nghi vấn","example_chinese":"门口的人是谁？","example_pinyin":"Ménkǒu de rén shì shéi?","example_meaning_vi":"Người ở cửa là ai?"}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('4d3c59a1-faaa-504d-ac55-7677a5ac4965'::UUID, 'c069c208-1e99-52b9-833c-67939fb1fb5d'::UUID, 'vocabulary', 2, 'Từ mới: 哪儿', NULL, '哪儿', '哪儿 (nǎr) — đâu, nơi nào. 你的学校在哪儿？', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"hsk1:哪儿","chinese":"哪儿","pinyin":"nǎr","meaning":"đâu, nơi nào","part_of_speech":"đại từ nghi vấn","example_chinese":"你的学校在哪儿？","example_pinyin":"Nǐ de xuéxiào zài nǎr?","example_meaning_vi":"Trường của bạn ở đâu?"}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('8f76bcf1-d185-5628-90e3-8bc51c5953af'::UUID, 'c069c208-1e99-52b9-833c-67939fb1fb5d'::UUID, 'vocabulary', 3, 'Từ mới: 学校', NULL, '学校', '学校 (xuéxiào) — trường học. 学校离我家很近。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"hsk1:学校","chinese":"学校","pinyin":"xuéxiào","meaning":"trường học","part_of_speech":"danh từ","example_chinese":"学校离我家很近。","example_pinyin":"Xuéxiào lí wǒ jiā hěn jìn.","example_meaning_vi":"Trường học rất gần nhà tôi."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('c3266ade-c260-5fc4-aad2-20671c2e8d4c'::UUID, 'c069c208-1e99-52b9-833c-67939fb1fb5d'::UUID, 'vocabulary', 4, 'Từ mới: 医院', NULL, '医院', '医院 (yīyuàn) — bệnh viện. 医院在银行旁边。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"hsk1:医院","chinese":"医院","pinyin":"yīyuàn","meaning":"bệnh viện","part_of_speech":"danh từ","example_chinese":"医院在银行旁边。","example_pinyin":"Yīyuàn zài yínháng pángbiān.","example_meaning_vi":"Bệnh viện ở cạnh ngân hàng."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('7b3c3d6d-deb7-52c4-a1bb-2be91813a602'::UUID, 'c069c208-1e99-52b9-833c-67939fb1fb5d'::UUID, 'multiple_choice', 5, '“谁” có nghĩa phù hợp nhất là gì?', NULL, 'ai', '谁 (shéi) nghĩa là “ai”.', NULL, 1, '{"activity_type":"chinese_to_vietnamese","vocabulary_key":"hsk1:谁"}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('492e9cde-2500-5cb0-ad69-483e44076299'::UUID, '7b3c3d6d-deb7-52c4-a1bb-2be91813a602'::UUID, 'đâu, nơi nào', FALSE, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('0bdad568-0f5e-5ad5-8c77-459767d813a1'::UUID, '7b3c3d6d-deb7-52c4-a1bb-2be91813a602'::UUID, 'trường học', FALSE, 2)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('c42c51ee-48d0-5e7e-bd3f-3200f901b770'::UUID, '7b3c3d6d-deb7-52c4-a1bb-2be91813a602'::UUID, 'bệnh viện', FALSE, 3)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('a035c697-10cc-52de-9f77-2dfd80250c2e'::UUID, '7b3c3d6d-deb7-52c4-a1bb-2be91813a602'::UUID, 'ai', TRUE, 4)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('5ba5c680-cf22-574e-b9f7-419962d1aeef'::UUID, 'c069c208-1e99-52b9-833c-67939fb1fb5d'::UUID, 'translation', 6, 'Dịch sang tiếng Trung: “Bệnh viện ở cạnh ngân hàng.”', NULL, '医院在银行旁边。', 'Mẫu câu dùng “谁” trong ngữ cảnh của bài.', 'shéi', 1, '{"activity_type":"vietnamese_to_chinese","source_lang":"vi","target_lang":"zh","acceptable_answers":["医院在银行旁边。"]}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('c9ba4f26-5b7f-5046-bb79-2a3a029cc1d8'::UUID, 'c069c208-1e99-52b9-833c-67939fb1fb5d'::UUID, 'sentence_builder', 7, 'Sắp xếp các thành phần thành câu đúng.', NULL, '医院在银行旁边。', 'Trật tự đúng tạo thành câu “医院在银行旁边。”.', NULL, 1, '{"activity_type":"sentence_ordering","words":["医院","在","银行","旁边","。"],"correct_order":["医院","在","银行","旁边","。"]}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('8a268934-ac86-5c12-ba73-f572c5e03244'::UUID, 'c069c208-1e99-52b9-833c-67939fb1fb5d'::UUID, 'multiple_choice', 8, 'Câu nào có trật tự vị trí đúng?', NULL, '医院在银行旁边。', '在 đứng trước địa điểm để nói người hoặc vật đang ở đâu.', NULL, 1, '{"activity_type":"grammar_selection","passage":null,"grammar_key":"hsk1:hoi-ai-va-o-dau"}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('230c423b-cec6-549a-98d8-3bdbf87342f2'::UUID, '8a268934-ac86-5c12-ba73-f572c5e03244'::UUID, '医院在银行旁边。', TRUE, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('85d04835-e95a-5d36-9347-42f70933486f'::UUID, '8a268934-ac86-5c12-ba73-f572c5e03244'::UUID, '医院银行在旁边。', FALSE, 2)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('244a507e-37ef-591a-8930-2a95ded0e1f0'::UUID, '8a268934-ac86-5c12-ba73-f572c5e03244'::UUID, '在医院旁边银行。', FALSE, 3)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('410d8aab-ab26-51fc-a961-bbd4929ccd31'::UUID, 'c069c208-1e99-52b9-833c-67939fb1fb5d'::UUID, 'speaking', 9, 'Đọc thành tiếng: 医院在银行旁边。', NULL, '医院在银行旁边。', 'Đọc chậm, giữ đúng thanh điệu và nhịp của cả câu.', NULL, 1, '{"activity_type":"pronunciation","text":"医院在银行旁边。","pinyin":"Yīyuàn zài yínháng pángbiān."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.units (id, course_id, slug, title, description, order_index, status, learning_objectives, content_version)
VALUES ('904f8773-9e13-575a-80a5-7f81e238d630'::UUID, '33228bdd-72c2-54f3-b187-0af47cd18790'::UUID, 'hsk1-so-luong-thoi-gian', 'Số lượng và thời gian', 'Hỏi số lượng, tuổi, ngày giờ và hoạt động.', 2, 'review', '["Dùng số và lượng từ","Nói thời gian và thói quen"]'::JSONB, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.chapters (id, unit_id, slug, title, description, order_index, status, learning_objectives, content_version)
VALUES ('efeef7ce-7455-5f62-b960-2b2a7353ad18'::UUID, '904f8773-9e13-575a-80a5-7f81e238d630'::UUID, 'hsk1-so-luong-thoi-gian-chapter', 'Số, ngày và lịch sinh hoạt', 'Hỏi số lượng, tuổi, ngày giờ và hoạt động.', 1, 'review', '["Dùng số và lượng từ","Nói thời gian và thói quen"]'::JSONB, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lessons (id, chapter_id, slug, title, description, order_index, xp_reward, status, lesson_type, estimated_minutes, learning_objectives, cultural_note, content_version)
VALUES ('9258d179-6e23-5c1d-a5d9-78f1614f899d'::UUID, 'efeef7ce-7455-5f62-b960-2b2a7353ad18'::UUID, 'so-luong-va-tuoi', '几岁？— Số lượng và tuổi', 'Hỏi tuổi và số lượng nhỏ bằng 几.', 1, 25, 'review', 'standard', 15, '["Hỏi tuổi trẻ em","Dùng lượng từ 个"]'::JSONB, NULL, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('e2f93d13-475e-55aa-8cc3-4b8e912ca715'::UUID, 'hsk1:几', '几', 'jǐ', 'mấy, bao nhiêu', 'how many', 'beginner', 'so-luong-va-tuoi', 'đại từ nghi vấn', '你有几个汉语老师？', 'Nǐ yǒu jǐ ge Hànyǔ lǎoshī?', 'Bạn có mấy giáo viên tiếng Trung?', NULL, 'review', '9258d179-6e23-5c1d-a5d9-78f1614f899d'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('eedb4453-b4ef-5a16-b08b-7de2d1198829'::UUID, '9258d179-6e23-5c1d-a5d9-78f1614f899d'::UUID, 'e2f93d13-475e-55aa-8cc3-4b8e912ca715'::UUID, 1, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('3c2c0d8c-c709-573c-bd7a-8364bb5cb121'::UUID, 'hsk1:岁', '岁', 'suì', 'tuổi', 'years old', 'beginner', 'so-luong-va-tuoi', 'lượng từ', '我弟弟八岁。', 'Wǒ dìdi bā suì.', 'Em trai tôi tám tuổi.', NULL, 'review', '9258d179-6e23-5c1d-a5d9-78f1614f899d'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('eafc33e0-25db-5e22-8025-eb51369f058b'::UUID, '9258d179-6e23-5c1d-a5d9-78f1614f899d'::UUID, '3c2c0d8c-c709-573c-bd7a-8364bb5cb121'::UUID, 2, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('2c126f1e-db14-5ab5-9221-49e3cc057505'::UUID, 'hsk1:个', '个', 'gè', 'cái, người (lượng từ chung)', 'general measure word', 'beginner', 'so-luong-va-tuoi', 'lượng từ', '桌上有三个苹果。', 'Zhuō shàng yǒu sān ge píngguǒ.', 'Trên bàn có ba quả táo.', NULL, 'review', '9258d179-6e23-5c1d-a5d9-78f1614f899d'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('585663fa-79ec-56e0-ad83-6dd1708e3deb'::UUID, '9258d179-6e23-5c1d-a5d9-78f1614f899d'::UUID, '2c126f1e-db14-5ab5-9221-49e3cc057505'::UUID, 3, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('b4718490-fa71-522e-ae64-b0790070bb9f'::UUID, 'hsk1:有', '有', 'yǒu', 'có', 'to have; there is', 'beginner', 'so-luong-va-tuoi', 'động từ', '我家有四口人。', 'Wǒ jiā yǒu sì kǒu rén.', 'Nhà tôi có bốn người.', NULL, 'review', '9258d179-6e23-5c1d-a5d9-78f1614f899d'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('f12136c6-2402-520b-bad9-bd25c5ef285f'::UUID, '9258d179-6e23-5c1d-a5d9-78f1614f899d'::UUID, 'b4718490-fa71-522e-ae64-b0790070bb9f'::UUID, 4, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('de8d28be-d3cb-550b-ad52-87832bad058f'::UUID, '9258d179-6e23-5c1d-a5d9-78f1614f899d'::UUID, '14890f3e-8da5-5ba6-9a67-af085c82d012'::UUID, 5, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('a8f58556-0443-5bc3-8ca2-b544e8cb3a4b'::UUID, '9258d179-6e23-5c1d-a5d9-78f1614f899d'::UUID, '3b16a062-a1c4-549b-bf7d-d4c476c2dae2'::UUID, 6, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('14f33b6b-33c3-59bf-8d68-adc221fe517e'::UUID, '9258d179-6e23-5c1d-a5d9-78f1614f899d'::UUID, '861ecff4-5aeb-5b4a-ab9e-33f5d36a3e7d'::UUID, 7, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('fd2140f9-5f59-57de-8581-be5f16e08079'::UUID, '9258d179-6e23-5c1d-a5d9-78f1614f899d'::UUID, 'cb6f55f5-b2d2-5c1a-83fb-6d5127b63758'::UUID, 8, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.grammar_lessons (id, content_key, title, pattern, explanation, example_chinese, example_pinyin, example_meaning, level, status, usage_note, content_version)
VALUES ('21d33358-7263-5d34-b4f4-d587c4ec3600'::UUID, 'hsk1:so-luong-va-tuoi', 'Câu tồn tại và sở hữu với 有', 'chủ ngữ + 有 + số lượng + danh từ', '有 diễn tả sở hữu hoặc sự tồn tại; phủ định là 没有.', '我家有四口人。', 'Wǒ jiā yǒu sì kǒu rén.', 'Nhà tôi có bốn người.', 'beginner', 'review', NULL, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_grammar (id, lesson_id, grammar_lesson_id, order_index, curriculum_role)
VALUES ('4378b9f4-b393-5e43-9566-1dcfc386404d'::UUID, '9258d179-6e23-5c1d-a5d9-78f1614f899d'::UUID, '21d33358-7263-5d34-b4f4-d587c4ec3600'::UUID, 1, 'introduced')
ON CONFLICT (lesson_id, grammar_lesson_id) DO NOTHING;

INSERT INTO public.lesson_grammar (id, lesson_id, grammar_lesson_id, order_index, curriculum_role)
VALUES ('d0dfab9c-efa6-58e2-8656-ae89be39831a'::UUID, '9258d179-6e23-5c1d-a5d9-78f1614f899d'::UUID, '8ed9f1e5-e93e-5799-b03f-6228e3b641b4'::UUID, 2, 'review')
ON CONFLICT (lesson_id, grammar_lesson_id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('db2e66c0-75b6-567e-9210-1368f0819bc1'::UUID, '9258d179-6e23-5c1d-a5d9-78f1614f899d'::UUID, 'vocabulary', 1, 'Từ mới: 几', NULL, '几', '几 (jǐ) — mấy, bao nhiêu. 你有几个汉语老师？', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"hsk1:几","chinese":"几","pinyin":"jǐ","meaning":"mấy, bao nhiêu","part_of_speech":"đại từ nghi vấn","example_chinese":"你有几个汉语老师？","example_pinyin":"Nǐ yǒu jǐ ge Hànyǔ lǎoshī?","example_meaning_vi":"Bạn có mấy giáo viên tiếng Trung?"}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('a19ca4f0-20bd-5c52-b5a3-3e7f20be1c00'::UUID, '9258d179-6e23-5c1d-a5d9-78f1614f899d'::UUID, 'vocabulary', 2, 'Từ mới: 岁', NULL, '岁', '岁 (suì) — tuổi. 我弟弟八岁。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"hsk1:岁","chinese":"岁","pinyin":"suì","meaning":"tuổi","part_of_speech":"lượng từ","example_chinese":"我弟弟八岁。","example_pinyin":"Wǒ dìdi bā suì.","example_meaning_vi":"Em trai tôi tám tuổi."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('d27c66eb-abaf-5813-9b5b-c376f9adc9c7'::UUID, '9258d179-6e23-5c1d-a5d9-78f1614f899d'::UUID, 'vocabulary', 3, 'Từ mới: 个', NULL, '个', '个 (gè) — cái, người (lượng từ chung). 桌上有三个苹果。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"hsk1:个","chinese":"个","pinyin":"gè","meaning":"cái, người (lượng từ chung)","part_of_speech":"lượng từ","example_chinese":"桌上有三个苹果。","example_pinyin":"Zhuō shàng yǒu sān ge píngguǒ.","example_meaning_vi":"Trên bàn có ba quả táo."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('9a50c365-adfa-5e09-bbe8-3d2d686ff948'::UUID, '9258d179-6e23-5c1d-a5d9-78f1614f899d'::UUID, 'vocabulary', 4, 'Từ mới: 有', NULL, '有', '有 (yǒu) — có. 我家有四口人。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"hsk1:有","chinese":"有","pinyin":"yǒu","meaning":"có","part_of_speech":"động từ","example_chinese":"我家有四口人。","example_pinyin":"Wǒ jiā yǒu sì kǒu rén.","example_meaning_vi":"Nhà tôi có bốn người."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('cfa8d5c1-69a4-5835-bcdb-3806a535faee'::UUID, '9258d179-6e23-5c1d-a5d9-78f1614f899d'::UUID, 'multiple_choice', 5, '“几” có nghĩa phù hợp nhất là gì?', NULL, 'mấy, bao nhiêu', '几 (jǐ) nghĩa là “mấy, bao nhiêu”.', NULL, 1, '{"activity_type":"chinese_to_vietnamese","vocabulary_key":"hsk1:几"}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('76915410-aff5-55a7-b455-19b092bada9f'::UUID, 'cfa8d5c1-69a4-5835-bcdb-3806a535faee'::UUID, 'cái, người (lượng từ chung)', FALSE, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('dbee8cc5-64ae-5a9b-9218-0ad29e448b05'::UUID, 'cfa8d5c1-69a4-5835-bcdb-3806a535faee'::UUID, 'có', FALSE, 2)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('010886cf-a701-5594-b1f2-01e45c97d5d3'::UUID, 'cfa8d5c1-69a4-5835-bcdb-3806a535faee'::UUID, 'mấy, bao nhiêu', TRUE, 3)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('1b16dbca-5aff-5af8-973a-19537bbec435'::UUID, 'cfa8d5c1-69a4-5835-bcdb-3806a535faee'::UUID, 'tuổi', FALSE, 4)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('c5a1f15c-92ba-5162-a222-71385ce39375'::UUID, '9258d179-6e23-5c1d-a5d9-78f1614f899d'::UUID, 'translation', 6, 'Dịch sang tiếng Trung: “Nhà tôi có bốn người.”', NULL, '我家有四口人。', 'Mẫu câu dùng “几” trong ngữ cảnh của bài.', 'jǐ', 1, '{"activity_type":"vietnamese_to_chinese","source_lang":"vi","target_lang":"zh","acceptable_answers":["我家有四口人。"]}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('8e444465-71c6-54c5-ba0a-0a45d5c6fc03'::UUID, '9258d179-6e23-5c1d-a5d9-78f1614f899d'::UUID, 'sentence_builder', 7, 'Sắp xếp các thành phần thành câu đúng.', NULL, '我家有四口人。', 'Trật tự đúng tạo thành câu “我家有四口人。”.', NULL, 1, '{"activity_type":"sentence_ordering","words":["我家","有","四","口","人","。"],"correct_order":["我家","有","四","口","人","。"]}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('8623f487-f5cf-586d-8dc3-337d322c4f0f'::UUID, '9258d179-6e23-5c1d-a5d9-78f1614f899d'::UUID, 'multiple_choice', 8, 'Câu nào nói đúng “Nhà tôi có bốn người”?', NULL, '我家有四口人。', '有 diễn tả sở hữu hoặc sự tồn tại; phủ định là 没有.', NULL, 1, '{"activity_type":"grammar_selection","passage":null,"grammar_key":"hsk1:so-luong-va-tuoi"}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('9c40bf6e-f869-50fc-888e-4cfdb8b03b53'::UUID, '8623f487-f5cf-586d-8dc3-337d322c4f0f'::UUID, '我家有四口人。', TRUE, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('a262c423-91d5-528f-9717-4029a343d9b5'::UUID, '8623f487-f5cf-586d-8dc3-337d322c4f0f'::UUID, '我家是四口人有。', FALSE, 2)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('af685a17-ccac-588e-935f-28c93b0276e4'::UUID, '8623f487-f5cf-586d-8dc3-337d322c4f0f'::UUID, '我有家四人不。', FALSE, 3)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('40b54661-bc27-5d77-82fd-2169a05cddd2'::UUID, '9258d179-6e23-5c1d-a5d9-78f1614f899d'::UUID, 'speaking', 9, 'Đọc thành tiếng: 我家有四口人。', NULL, '我家有四口人。', 'Đọc chậm, giữ đúng thanh điệu và nhịp của cả câu.', NULL, 1, '{"activity_type":"pronunciation","text":"我家有四口人。","pinyin":"Wǒ jiā yǒu sì kǒu rén."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lessons (id, chapter_id, slug, title, description, order_index, xp_reward, status, lesson_type, estimated_minutes, learning_objectives, cultural_note, content_version)
VALUES ('b77fab37-7af9-5e46-b7f4-9cadce226a8a'::UUID, 'efeef7ce-7455-5f62-b960-2b2a7353ad18'::UUID, 'ngay-va-thu', '星期几？— Ngày và thứ', 'Nói ngày tháng và thứ trong tuần.', 2, 25, 'review', 'standard', 15, '["Hỏi hôm nay thứ mấy","Nói ngày theo trật tự năm-tháng-ngày"]'::JSONB, NULL, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('b86cff26-6bb1-593c-bef3-ee4982d48252'::UUID, 'hsk1:星期', '星期', 'xīngqī', 'tuần; thứ', 'week; weekday', 'beginner', 'ngay-va-thu', 'danh từ', '今天星期五。', 'Jīntiān xīngqīwǔ.', 'Hôm nay là thứ Sáu.', NULL, 'review', 'b77fab37-7af9-5e46-b7f4-9cadce226a8a'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('ef4b0673-84fc-5db4-8b6b-ec47081dbf4a'::UUID, 'b77fab37-7af9-5e46-b7f4-9cadce226a8a'::UUID, 'b86cff26-6bb1-593c-bef3-ee4982d48252'::UUID, 1, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('f5e5de26-1eaa-5f81-8188-6d807e9b79a3'::UUID, 'hsk1:月', '月', 'yuè', 'tháng', 'month', 'beginner', 'ngay-va-thu', 'danh từ', '我的生日是五月九号。', 'Wǒ de shēngrì shì wǔ yuè jiǔ hào.', 'Sinh nhật tôi là ngày 9 tháng 5.', NULL, 'review', 'b77fab37-7af9-5e46-b7f4-9cadce226a8a'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('7672957e-e4f8-5425-a0dc-6443a20ac769'::UUID, 'b77fab37-7af9-5e46-b7f4-9cadce226a8a'::UUID, 'f5e5de26-1eaa-5f81-8188-6d807e9b79a3'::UUID, 2, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('0461ec91-bd5b-5442-9064-614b156582a9'::UUID, 'hsk1:号', '号', 'hào', 'ngày (khẩu ngữ)', 'day of month', 'beginner', 'ngay-va-thu', 'danh từ', '明天是三月十号。', 'Míngtiān shì sān yuè shí hào.', 'Ngày mai là mùng 10 tháng 3.', NULL, 'review', 'b77fab37-7af9-5e46-b7f4-9cadce226a8a'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('ec975e50-82bd-5adf-8d95-4c21fdf4693f'::UUID, 'b77fab37-7af9-5e46-b7f4-9cadce226a8a'::UUID, '0461ec91-bd5b-5442-9064-614b156582a9'::UUID, 3, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('b5a4e63a-06bc-5632-89db-d7df91e98044'::UUID, 'hsk1:生日', '生日', 'shēngrì', 'sinh nhật', 'birthday', 'beginner', 'ngay-va-thu', 'danh từ', '祝你生日快乐！', 'Zhù nǐ shēngrì kuàilè!', 'Chúc bạn sinh nhật vui vẻ!', NULL, 'review', 'b77fab37-7af9-5e46-b7f4-9cadce226a8a'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('caccacc6-ff21-519b-8967-22007ddf0144'::UUID, 'b77fab37-7af9-5e46-b7f4-9cadce226a8a'::UUID, 'b5a4e63a-06bc-5632-89db-d7df91e98044'::UUID, 4, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('eb367f9e-349a-50e6-bae3-add45ac79ef4'::UUID, 'b77fab37-7af9-5e46-b7f4-9cadce226a8a'::UUID, 'e2f93d13-475e-55aa-8cc3-4b8e912ca715'::UUID, 5, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('fdcd0d6a-9d4f-5cc7-aa07-bc6d40981068'::UUID, 'b77fab37-7af9-5e46-b7f4-9cadce226a8a'::UUID, '3c2c0d8c-c709-573c-bd7a-8364bb5cb121'::UUID, 6, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('7e6ff303-bd7d-5d0e-bee5-b36e4471c635'::UUID, 'b77fab37-7af9-5e46-b7f4-9cadce226a8a'::UUID, '2c126f1e-db14-5ab5-9221-49e3cc057505'::UUID, 7, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('30a6b1ae-0a3b-574a-a988-9b67ce1fd6f9'::UUID, 'b77fab37-7af9-5e46-b7f4-9cadce226a8a'::UUID, 'b4718490-fa71-522e-ae64-b0790070bb9f'::UUID, 8, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.grammar_lessons (id, content_key, title, pattern, explanation, example_chinese, example_pinyin, example_meaning, level, status, usage_note, content_version)
VALUES ('b30c1b87-6c21-56d0-8893-286b5ef12e63'::UUID, 'hsk1:ngay-va-thu', 'Trật tự ngày tháng', 'tháng + 月 + ngày + 号', 'Tiếng Trung nói đơn vị lớn trước đơn vị nhỏ: tháng rồi đến ngày.', '我的生日是五月九号。', 'Wǒ de shēngrì shì wǔ yuè jiǔ hào.', 'Sinh nhật tôi là ngày 9 tháng 5.', 'beginner', 'review', NULL, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_grammar (id, lesson_id, grammar_lesson_id, order_index, curriculum_role)
VALUES ('49a08562-dfea-5173-94e2-4832fa7b5401'::UUID, 'b77fab37-7af9-5e46-b7f4-9cadce226a8a'::UUID, 'b30c1b87-6c21-56d0-8893-286b5ef12e63'::UUID, 1, 'introduced')
ON CONFLICT (lesson_id, grammar_lesson_id) DO NOTHING;

INSERT INTO public.lesson_grammar (id, lesson_id, grammar_lesson_id, order_index, curriculum_role)
VALUES ('102d8a50-2bfc-5766-96f4-3dd9af407830'::UUID, 'b77fab37-7af9-5e46-b7f4-9cadce226a8a'::UUID, '21d33358-7263-5d34-b4f4-d587c4ec3600'::UUID, 2, 'review')
ON CONFLICT (lesson_id, grammar_lesson_id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('1a3869fb-135d-5b8a-9c5b-75e3c8b7a121'::UUID, 'b77fab37-7af9-5e46-b7f4-9cadce226a8a'::UUID, 'vocabulary', 1, 'Từ mới: 星期', NULL, '星期', '星期 (xīngqī) — tuần; thứ. 今天星期五。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"hsk1:星期","chinese":"星期","pinyin":"xīngqī","meaning":"tuần; thứ","part_of_speech":"danh từ","example_chinese":"今天星期五。","example_pinyin":"Jīntiān xīngqīwǔ.","example_meaning_vi":"Hôm nay là thứ Sáu."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('de35bf1b-d098-5b8a-a49d-06e4bbfd5abe'::UUID, 'b77fab37-7af9-5e46-b7f4-9cadce226a8a'::UUID, 'vocabulary', 2, 'Từ mới: 月', NULL, '月', '月 (yuè) — tháng. 我的生日是五月九号。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"hsk1:月","chinese":"月","pinyin":"yuè","meaning":"tháng","part_of_speech":"danh từ","example_chinese":"我的生日是五月九号。","example_pinyin":"Wǒ de shēngrì shì wǔ yuè jiǔ hào.","example_meaning_vi":"Sinh nhật tôi là ngày 9 tháng 5."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('4354e967-7601-510c-92d3-1b97397b2548'::UUID, 'b77fab37-7af9-5e46-b7f4-9cadce226a8a'::UUID, 'vocabulary', 3, 'Từ mới: 号', NULL, '号', '号 (hào) — ngày (khẩu ngữ). 明天是三月十号。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"hsk1:号","chinese":"号","pinyin":"hào","meaning":"ngày (khẩu ngữ)","part_of_speech":"danh từ","example_chinese":"明天是三月十号。","example_pinyin":"Míngtiān shì sān yuè shí hào.","example_meaning_vi":"Ngày mai là mùng 10 tháng 3."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('fbc35034-8d8e-5169-acc8-a422710e1cfb'::UUID, 'b77fab37-7af9-5e46-b7f4-9cadce226a8a'::UUID, 'vocabulary', 4, 'Từ mới: 生日', NULL, '生日', '生日 (shēngrì) — sinh nhật. 祝你生日快乐！', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"hsk1:生日","chinese":"生日","pinyin":"shēngrì","meaning":"sinh nhật","part_of_speech":"danh từ","example_chinese":"祝你生日快乐！","example_pinyin":"Zhù nǐ shēngrì kuàilè!","example_meaning_vi":"Chúc bạn sinh nhật vui vẻ!"}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('98846116-1b3c-5014-bfb4-a70f75569f11'::UUID, 'b77fab37-7af9-5e46-b7f4-9cadce226a8a'::UUID, 'multiple_choice', 5, '“星期” có nghĩa phù hợp nhất là gì?', NULL, 'tuần; thứ', '星期 (xīngqī) nghĩa là “tuần; thứ”.', NULL, 1, '{"activity_type":"chinese_to_vietnamese","vocabulary_key":"hsk1:星期"}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('1ef7c6db-cb7d-5558-8f4a-0df969a961df'::UUID, '98846116-1b3c-5014-bfb4-a70f75569f11'::UUID, 'ngày (khẩu ngữ)', FALSE, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('c368562d-6daa-5615-8eb6-9dcca374bef0'::UUID, '98846116-1b3c-5014-bfb4-a70f75569f11'::UUID, 'sinh nhật', FALSE, 2)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('108c3a96-7749-540d-938a-7dc29d316ad9'::UUID, '98846116-1b3c-5014-bfb4-a70f75569f11'::UUID, 'tuần; thứ', TRUE, 3)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('815785b9-d04b-5ea1-8628-bf8801db8366'::UUID, '98846116-1b3c-5014-bfb4-a70f75569f11'::UUID, 'tháng', FALSE, 4)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('75f516b8-acd6-543f-bb7c-40777988c30c'::UUID, 'b77fab37-7af9-5e46-b7f4-9cadce226a8a'::UUID, 'translation', 6, 'Dịch sang tiếng Trung: “Sinh nhật tôi là ngày 9 tháng 5.”', NULL, '我的生日是五月九号。', 'Mẫu câu dùng “星期” trong ngữ cảnh của bài.', 'xīngqī', 1, '{"activity_type":"vietnamese_to_chinese","source_lang":"vi","target_lang":"zh","acceptable_answers":["我的生日是五月九号。"]}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('521d180a-bc5f-5e5b-ae84-7e5c4d1ce9c5'::UUID, 'b77fab37-7af9-5e46-b7f4-9cadce226a8a'::UUID, 'sentence_builder', 7, 'Sắp xếp các thành phần thành câu đúng.', NULL, '我的生日是五月九号。', 'Trật tự đúng tạo thành câu “我的生日是五月九号。”.', NULL, 1, '{"activity_type":"sentence_ordering","words":["我","的","生日","是","五月","九号","。"],"correct_order":["我","的","生日","是","五月","九号","。"]}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('ffcbae23-c081-583b-aa38-cc11fe1637bd'::UUID, 'b77fab37-7af9-5e46-b7f4-9cadce226a8a'::UUID, 'multiple_choice', 8, 'Câu nào có trật tự ngày tháng đúng?', NULL, '我的生日是五月九号。', 'Tiếng Trung nói đơn vị lớn trước đơn vị nhỏ: tháng rồi đến ngày.', NULL, 1, '{"activity_type":"grammar_selection","passage":null,"grammar_key":"hsk1:ngay-va-thu"}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('92097345-ceac-5e2e-b1f4-712f3d0afa85'::UUID, 'ffcbae23-c081-583b-aa38-cc11fe1637bd'::UUID, '我的生日是五月九号。', TRUE, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('37ad6024-dccb-5a62-82a5-5e158b84c9f0'::UUID, 'ffcbae23-c081-583b-aa38-cc11fe1637bd'::UUID, '我的生日是九号五月。', FALSE, 2)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('ecdc51b6-0ba3-55bf-9b10-65fe67e4d8a1'::UUID, 'ffcbae23-c081-583b-aa38-cc11fe1637bd'::UUID, '五月我的九生日号。', FALSE, 3)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('3bc15bf1-c8e6-526f-a814-e21fe9d1a349'::UUID, 'b77fab37-7af9-5e46-b7f4-9cadce226a8a'::UUID, 'speaking', 9, 'Đọc thành tiếng: 我的生日是五月九号。', NULL, '我的生日是五月九号。', 'Đọc chậm, giữ đúng thanh điệu và nhịp của cả câu.', NULL, 1, '{"activity_type":"pronunciation","text":"我的生日是五月九号。","pinyin":"Wǒ de shēngrì shì wǔ yuè jiǔ hào."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lessons (id, chapter_id, slug, title, description, order_index, xp_reward, status, lesson_type, estimated_minutes, learning_objectives, cultural_note, content_version)
VALUES ('9e581056-541a-564d-91ca-cd74373a20e1'::UUID, 'efeef7ce-7455-5f62-b960-2b2a7353ad18'::UUID, 'kha-nang-va-so-thich', '会不会？— Khả năng và sở thích', 'Nói biết làm gì và thích hoạt động nào.', 3, 25, 'review', 'standard', 15, '["Dùng 会 cho kỹ năng đã học","Dùng 喜欢 cho sở thích"]'::JSONB, NULL, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('b7ef7103-8d4e-5323-87a2-d70f1f2dfaf6'::UUID, 'hsk1:会', '会', 'huì', 'biết, có thể (kỹ năng)', 'can; know how to', 'beginner', 'kha-nang-va-so-thich', 'động từ năng nguyện', '我会说一点儿汉语。', 'Wǒ huì shuō yìdiǎnr Hànyǔ.', 'Tôi biết nói một chút tiếng Trung.', NULL, 'review', '9e581056-541a-564d-91ca-cd74373a20e1'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('540b1b04-f8ae-558a-97a4-c207e9f43949'::UUID, '9e581056-541a-564d-91ca-cd74373a20e1'::UUID, 'b7ef7103-8d4e-5323-87a2-d70f1f2dfaf6'::UUID, 1, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('bbb7463f-b64c-5950-b099-dc9c4cf4956c'::UUID, 'hsk1:说', '说', 'shuō', 'nói', 'to speak; say', 'beginner', 'kha-nang-va-so-thich', 'động từ', '请慢一点儿说。', 'Qǐng màn yìdiǎnr shuō.', 'Xin hãy nói chậm một chút.', NULL, 'review', '9e581056-541a-564d-91ca-cd74373a20e1'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('3630cd3c-a20f-5101-a064-81953bfc7dd0'::UUID, '9e581056-541a-564d-91ca-cd74373a20e1'::UUID, 'bbb7463f-b64c-5950-b099-dc9c4cf4956c'::UUID, 2, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('2efd2b87-af22-53a4-bab5-5811201d6072'::UUID, 'hsk1:喜欢', '喜欢', 'xǐhuan', 'thích', 'to like', 'beginner', 'kha-nang-va-so-thich', 'động từ', '她喜欢看中国电影。', 'Tā xǐhuan kàn Zhōngguó diànyǐng.', 'Cô ấy thích xem phim Trung Quốc.', NULL, 'review', '9e581056-541a-564d-91ca-cd74373a20e1'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('de16f411-3ca3-5d1e-a0c0-593a7650eb84'::UUID, '9e581056-541a-564d-91ca-cd74373a20e1'::UUID, '2efd2b87-af22-53a4-bab5-5811201d6072'::UUID, 3, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('be9be0f1-72ed-590a-88ae-08222750eda6'::UUID, 'hsk1:看', '看', 'kàn', 'xem, nhìn, đọc', 'to look; watch; read', 'beginner', 'kha-nang-va-so-thich', 'động từ', '晚上我看书。', 'Wǎnshang wǒ kàn shū.', 'Buổi tối tôi đọc sách.', NULL, 'review', '9e581056-541a-564d-91ca-cd74373a20e1'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('57260a4d-84fa-5aef-8786-d294dc99332a'::UUID, '9e581056-541a-564d-91ca-cd74373a20e1'::UUID, 'be9be0f1-72ed-590a-88ae-08222750eda6'::UUID, 4, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('6500550f-5e54-525a-9e31-cc38770cde49'::UUID, '9e581056-541a-564d-91ca-cd74373a20e1'::UUID, 'b86cff26-6bb1-593c-bef3-ee4982d48252'::UUID, 5, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('c8db8605-a8ff-5f8a-a1f8-5f8cf5200113'::UUID, '9e581056-541a-564d-91ca-cd74373a20e1'::UUID, 'f5e5de26-1eaa-5f81-8188-6d807e9b79a3'::UUID, 6, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('42e8dfad-4508-53f4-884b-f0b2b6a9e1d0'::UUID, '9e581056-541a-564d-91ca-cd74373a20e1'::UUID, '0461ec91-bd5b-5442-9064-614b156582a9'::UUID, 7, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('5eef13aa-e572-5051-9dbb-38a4efd8e17c'::UUID, '9e581056-541a-564d-91ca-cd74373a20e1'::UUID, 'b5a4e63a-06bc-5632-89db-d7df91e98044'::UUID, 8, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.grammar_lessons (id, content_key, title, pattern, explanation, example_chinese, example_pinyin, example_meaning, level, status, usage_note, content_version)
VALUES ('0a7f8b4d-ae53-5cf0-9b1d-baf481277e3e'::UUID, 'hsk1:kha-nang-va-so-thich', 'Khả năng đã học với 会', 'chủ ngữ + 会 + động từ', '会 đứng trước động từ để nói kỹ năng có được nhờ học tập.', '我会说一点儿汉语。', 'Wǒ huì shuō yìdiǎnr Hànyǔ.', 'Tôi biết nói một chút tiếng Trung.', 'beginner', 'review', NULL, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_grammar (id, lesson_id, grammar_lesson_id, order_index, curriculum_role)
VALUES ('17522f47-5e2e-59df-bb58-efd0ede901a5'::UUID, '9e581056-541a-564d-91ca-cd74373a20e1'::UUID, '0a7f8b4d-ae53-5cf0-9b1d-baf481277e3e'::UUID, 1, 'introduced')
ON CONFLICT (lesson_id, grammar_lesson_id) DO NOTHING;

INSERT INTO public.lesson_grammar (id, lesson_id, grammar_lesson_id, order_index, curriculum_role)
VALUES ('aed56f1d-b23d-5b4a-8e05-994146fd663d'::UUID, '9e581056-541a-564d-91ca-cd74373a20e1'::UUID, 'b30c1b87-6c21-56d0-8893-286b5ef12e63'::UUID, 2, 'review')
ON CONFLICT (lesson_id, grammar_lesson_id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('7d5a6dbb-b3ea-547f-b39b-4ac40f3d0cff'::UUID, '9e581056-541a-564d-91ca-cd74373a20e1'::UUID, 'vocabulary', 1, 'Từ mới: 会', NULL, '会', '会 (huì) — biết, có thể (kỹ năng). 我会说一点儿汉语。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"hsk1:会","chinese":"会","pinyin":"huì","meaning":"biết, có thể (kỹ năng)","part_of_speech":"động từ năng nguyện","example_chinese":"我会说一点儿汉语。","example_pinyin":"Wǒ huì shuō yìdiǎnr Hànyǔ.","example_meaning_vi":"Tôi biết nói một chút tiếng Trung."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('853c605b-6efd-52ac-bf26-b34cb128dee2'::UUID, '9e581056-541a-564d-91ca-cd74373a20e1'::UUID, 'vocabulary', 2, 'Từ mới: 说', NULL, '说', '说 (shuō) — nói. 请慢一点儿说。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"hsk1:说","chinese":"说","pinyin":"shuō","meaning":"nói","part_of_speech":"động từ","example_chinese":"请慢一点儿说。","example_pinyin":"Qǐng màn yìdiǎnr shuō.","example_meaning_vi":"Xin hãy nói chậm một chút."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('ff98833c-d382-59dd-80fe-a2ef0cf8081c'::UUID, '9e581056-541a-564d-91ca-cd74373a20e1'::UUID, 'vocabulary', 3, 'Từ mới: 喜欢', NULL, '喜欢', '喜欢 (xǐhuan) — thích. 她喜欢看中国电影。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"hsk1:喜欢","chinese":"喜欢","pinyin":"xǐhuan","meaning":"thích","part_of_speech":"động từ","example_chinese":"她喜欢看中国电影。","example_pinyin":"Tā xǐhuan kàn Zhōngguó diànyǐng.","example_meaning_vi":"Cô ấy thích xem phim Trung Quốc."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('d8b349e1-d598-5a45-b73a-166bb94461c8'::UUID, '9e581056-541a-564d-91ca-cd74373a20e1'::UUID, 'vocabulary', 4, 'Từ mới: 看', NULL, '看', '看 (kàn) — xem, nhìn, đọc. 晚上我看书。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"hsk1:看","chinese":"看","pinyin":"kàn","meaning":"xem, nhìn, đọc","part_of_speech":"động từ","example_chinese":"晚上我看书。","example_pinyin":"Wǎnshang wǒ kàn shū.","example_meaning_vi":"Buổi tối tôi đọc sách."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('c7e2f40f-0ec5-59e1-a96f-e0ce46d0bb67'::UUID, '9e581056-541a-564d-91ca-cd74373a20e1'::UUID, 'multiple_choice', 5, '“会” có nghĩa phù hợp nhất là gì?', NULL, 'biết, có thể (kỹ năng)', '会 (huì) nghĩa là “biết, có thể (kỹ năng)”.', NULL, 1, '{"activity_type":"chinese_to_vietnamese","vocabulary_key":"hsk1:会"}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('383ed8c6-a047-5546-ba88-29918e1e0d55'::UUID, 'c7e2f40f-0ec5-59e1-a96f-e0ce46d0bb67'::UUID, 'thích', FALSE, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('2e6c169b-e0ae-526a-aa26-38d2fe3b8fb8'::UUID, 'c7e2f40f-0ec5-59e1-a96f-e0ce46d0bb67'::UUID, 'xem, nhìn, đọc', FALSE, 2)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('e9f53985-c7a1-5798-84d5-720e2009c58f'::UUID, 'c7e2f40f-0ec5-59e1-a96f-e0ce46d0bb67'::UUID, 'biết, có thể (kỹ năng)', TRUE, 3)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('f0eb829a-bf97-5db4-b3bf-61aa5cdadcbe'::UUID, 'c7e2f40f-0ec5-59e1-a96f-e0ce46d0bb67'::UUID, 'nói', FALSE, 4)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('5e0f0a4a-d182-5723-910e-a5b7a1c49759'::UUID, '9e581056-541a-564d-91ca-cd74373a20e1'::UUID, 'translation', 6, 'Dịch sang tiếng Trung: “Tôi biết nói một chút tiếng Trung.”', NULL, '我会说一点儿汉语。', 'Mẫu câu dùng “会” trong ngữ cảnh của bài.', 'huì', 1, '{"activity_type":"vietnamese_to_chinese","source_lang":"vi","target_lang":"zh","acceptable_answers":["我会说一点儿汉语。"]}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('d1e5029d-8b12-55ba-8533-f89233af1d37'::UUID, '9e581056-541a-564d-91ca-cd74373a20e1'::UUID, 'sentence_builder', 7, 'Sắp xếp các thành phần thành câu đúng.', NULL, '我会说一点儿汉语。', 'Trật tự đúng tạo thành câu “我会说一点儿汉语。”.', NULL, 1, '{"activity_type":"sentence_ordering","words":["我","会","说","一点儿","汉语","。"],"correct_order":["我","会","说","一点儿","汉语","。"]}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('eb0e130e-d361-5203-be9e-7ee94583db0d'::UUID, '9e581056-541a-564d-91ca-cd74373a20e1'::UUID, 'multiple_choice', 8, 'Câu nào diễn tả kỹ năng nói tiếng Trung?', NULL, '我会说一点儿汉语。', '会 đứng trước động từ để nói kỹ năng có được nhờ học tập.', NULL, 1, '{"activity_type":"grammar_selection","passage":null,"grammar_key":"hsk1:kha-nang-va-so-thich"}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('1268abe5-446f-5bba-a5a0-5dd2a4fead17'::UUID, 'eb0e130e-d361-5203-be9e-7ee94583db0d'::UUID, '我会说一点儿汉语。', TRUE, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('0c22e618-cc21-527d-ac2f-d053ccb83d0d'::UUID, 'eb0e130e-d361-5203-be9e-7ee94583db0d'::UUID, '我说会汉语一点儿。', FALSE, 2)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('a9a31a4e-4a63-5b2f-990b-b1b8495e8d88'::UUID, 'eb0e130e-d361-5203-be9e-7ee94583db0d'::UUID, '会我一点儿说汉语。', FALSE, 3)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('19baf5d3-7060-543d-bcdd-59f81ec301f7'::UUID, '9e581056-541a-564d-91ca-cd74373a20e1'::UUID, 'speaking', 9, 'Đọc thành tiếng: 我会说一点儿汉语。', NULL, '我会说一点儿汉语。', 'Đọc chậm, giữ đúng thanh điệu và nhịp của cả câu.', NULL, 1, '{"activity_type":"pronunciation","text":"我会说一点儿汉语。","pinyin":"Wǒ huì shuō yìdiǎnr Hànyǔ."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.units (id, course_id, slug, title, description, order_index, status, learning_objectives, content_version)
VALUES ('d958341b-8314-533c-add6-79d67cae543b'::UUID, '33228bdd-72c2-54f3-b187-0af47cd18790'::UUID, 'hsk1-doi-song', 'Đời sống thường ngày', 'Xử lý các nhu cầu đời sống cơ bản.', 3, 'review', '["Gọi món và mua hàng","Hỏi vị trí và phương tiện"]'::JSONB, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.chapters (id, unit_id, slug, title, description, order_index, status, learning_objectives, content_version)
VALUES ('8f619c02-fa78-52ea-b892-ce966d24bacb'::UUID, 'd958341b-8314-533c-add6-79d67cae543b'::UUID, 'hsk1-doi-song-chapter', 'Ăn uống, mua sắm và đi lại', 'Xử lý các nhu cầu đời sống cơ bản.', 1, 'review', '["Gọi món và mua hàng","Hỏi vị trí và phương tiện"]'::JSONB, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lessons (id, chapter_id, slug, title, description, order_index, xp_reward, status, lesson_type, estimated_minutes, learning_objectives, cultural_note, content_version)
VALUES ('a34b965d-1f05-5ceb-a797-a3613c08ee88'::UUID, '8f619c02-fa78-52ea-b892-ce966d24bacb'::UUID, 'an-uong-va-mua-sam', '想吃什么？— Ăn uống và mua sắm', 'Nói nhu cầu, gọi món và hỏi giá đơn giản.', 1, 25, 'review', 'standard', 15, '["Dùng 想 để nói mong muốn","Dùng 这/那 chỉ món đồ"]'::JSONB, NULL, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('9fede698-76e6-5906-a9a1-8d86c9b692ef'::UUID, 'hsk1:想', '想', 'xiǎng', 'muốn; nghĩ', 'to want; think', 'beginner', 'an-uong-va-mua-sam', 'động từ năng nguyện', '我想喝一杯热茶。', 'Wǒ xiǎng hē yì bēi rè chá.', 'Tôi muốn uống một cốc trà nóng.', NULL, 'review', 'a34b965d-1f05-5ceb-a797-a3613c08ee88'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('f887dea7-ac7b-5d49-842f-f8bdecd45e9b'::UUID, 'a34b965d-1f05-5ceb-a797-a3613c08ee88'::UUID, '9fede698-76e6-5906-a9a1-8d86c9b692ef'::UUID, 1, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('cc65ac7a-8cae-59ac-8b43-43c17ed3945a'::UUID, 'hsk1:喝', '喝', 'hē', 'uống', 'to drink', 'beginner', 'an-uong-va-mua-sam', 'động từ', '天气热，多喝水。', 'Tiānqì rè, duō hē shuǐ.', 'Trời nóng, hãy uống nhiều nước.', NULL, 'review', 'a34b965d-1f05-5ceb-a797-a3613c08ee88'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('51d339ad-e17d-5e3c-8701-a47af8c0518f'::UUID, 'a34b965d-1f05-5ceb-a797-a3613c08ee88'::UUID, 'cc65ac7a-8cae-59ac-8b43-43c17ed3945a'::UUID, 2, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('796263c4-6f4f-56de-af2d-37814f782717'::UUID, 'hsk1:苹果', '苹果', 'píngguǒ', 'quả táo', 'apple', 'beginner', 'an-uong-va-mua-sam', 'danh từ', '这些苹果很甜。', 'Zhèxiē píngguǒ hěn tián.', 'Những quả táo này rất ngọt.', NULL, 'review', 'a34b965d-1f05-5ceb-a797-a3613c08ee88'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('550b271e-5e28-5c3c-8390-f393a8961795'::UUID, 'a34b965d-1f05-5ceb-a797-a3613c08ee88'::UUID, '796263c4-6f4f-56de-af2d-37814f782717'::UUID, 3, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('a962ac2d-b9b9-5e13-bd16-f3427cdc5aea'::UUID, 'hsk1:块', '块', 'kuài', 'đồng; miếng', 'yuan; piece', 'beginner', 'an-uong-va-mua-sam', 'lượng từ', '这杯咖啡二十块。', 'Zhè bēi kāfēi èrshí kuài.', 'Cốc cà phê này giá hai mươi tệ.', NULL, 'review', 'a34b965d-1f05-5ceb-a797-a3613c08ee88'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('93a45c7d-2f49-5194-b6a6-6699438eba7d'::UUID, 'a34b965d-1f05-5ceb-a797-a3613c08ee88'::UUID, 'a962ac2d-b9b9-5e13-bd16-f3427cdc5aea'::UUID, 4, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('7c06baea-b934-5b76-a468-19ca646c3d0b'::UUID, 'a34b965d-1f05-5ceb-a797-a3613c08ee88'::UUID, 'b7ef7103-8d4e-5323-87a2-d70f1f2dfaf6'::UUID, 5, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('7ff991b9-ed58-56a8-bb04-34bf7ad2a997'::UUID, 'a34b965d-1f05-5ceb-a797-a3613c08ee88'::UUID, 'bbb7463f-b64c-5950-b099-dc9c4cf4956c'::UUID, 6, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('1300bb41-7ac1-5823-9903-aee01be9edda'::UUID, 'a34b965d-1f05-5ceb-a797-a3613c08ee88'::UUID, '2efd2b87-af22-53a4-bab5-5811201d6072'::UUID, 7, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('615c4b56-0268-5fd3-8db9-e9b84404185b'::UUID, 'a34b965d-1f05-5ceb-a797-a3613c08ee88'::UUID, 'be9be0f1-72ed-590a-88ae-08222750eda6'::UUID, 8, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.grammar_lessons (id, content_key, title, pattern, explanation, example_chinese, example_pinyin, example_meaning, level, status, usage_note, content_version)
VALUES ('7d421f77-866c-56f1-8619-002a8309d75d'::UUID, 'hsk1:an-uong-va-mua-sam', 'Mong muốn với 想', 'chủ ngữ + 想 + động từ/tân ngữ', '想 diễn tả mong muốn tương đối nhẹ và lịch sự.', '我想喝一杯热茶。', 'Wǒ xiǎng hē yì bēi rè chá.', 'Tôi muốn uống một cốc trà nóng.', 'beginner', 'review', NULL, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_grammar (id, lesson_id, grammar_lesson_id, order_index, curriculum_role)
VALUES ('4fd3dc88-57b7-5942-8792-db7cfd3c04af'::UUID, 'a34b965d-1f05-5ceb-a797-a3613c08ee88'::UUID, '7d421f77-866c-56f1-8619-002a8309d75d'::UUID, 1, 'introduced')
ON CONFLICT (lesson_id, grammar_lesson_id) DO NOTHING;

INSERT INTO public.lesson_grammar (id, lesson_id, grammar_lesson_id, order_index, curriculum_role)
VALUES ('6964f076-b19e-5330-a455-b9dc4961db4c'::UUID, 'a34b965d-1f05-5ceb-a797-a3613c08ee88'::UUID, '0a7f8b4d-ae53-5cf0-9b1d-baf481277e3e'::UUID, 2, 'review')
ON CONFLICT (lesson_id, grammar_lesson_id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('e376f949-77cd-51f7-94c3-3bbc0e7f49ef'::UUID, 'a34b965d-1f05-5ceb-a797-a3613c08ee88'::UUID, 'vocabulary', 1, 'Từ mới: 想', NULL, '想', '想 (xiǎng) — muốn; nghĩ. 我想喝一杯热茶。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"hsk1:想","chinese":"想","pinyin":"xiǎng","meaning":"muốn; nghĩ","part_of_speech":"động từ năng nguyện","example_chinese":"我想喝一杯热茶。","example_pinyin":"Wǒ xiǎng hē yì bēi rè chá.","example_meaning_vi":"Tôi muốn uống một cốc trà nóng."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('43c0a9c8-a1ee-56dd-8322-df35c487f90f'::UUID, 'a34b965d-1f05-5ceb-a797-a3613c08ee88'::UUID, 'vocabulary', 2, 'Từ mới: 喝', NULL, '喝', '喝 (hē) — uống. 天气热，多喝水。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"hsk1:喝","chinese":"喝","pinyin":"hē","meaning":"uống","part_of_speech":"động từ","example_chinese":"天气热，多喝水。","example_pinyin":"Tiānqì rè, duō hē shuǐ.","example_meaning_vi":"Trời nóng, hãy uống nhiều nước."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('c4ae9407-28c7-5f7d-9328-6991b9d0597a'::UUID, 'a34b965d-1f05-5ceb-a797-a3613c08ee88'::UUID, 'vocabulary', 3, 'Từ mới: 苹果', NULL, '苹果', '苹果 (píngguǒ) — quả táo. 这些苹果很甜。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"hsk1:苹果","chinese":"苹果","pinyin":"píngguǒ","meaning":"quả táo","part_of_speech":"danh từ","example_chinese":"这些苹果很甜。","example_pinyin":"Zhèxiē píngguǒ hěn tián.","example_meaning_vi":"Những quả táo này rất ngọt."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('e711cb00-0dbd-5995-972c-3fdd3149216f'::UUID, 'a34b965d-1f05-5ceb-a797-a3613c08ee88'::UUID, 'vocabulary', 4, 'Từ mới: 块', NULL, '块', '块 (kuài) — đồng; miếng. 这杯咖啡二十块。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"hsk1:块","chinese":"块","pinyin":"kuài","meaning":"đồng; miếng","part_of_speech":"lượng từ","example_chinese":"这杯咖啡二十块。","example_pinyin":"Zhè bēi kāfēi èrshí kuài.","example_meaning_vi":"Cốc cà phê này giá hai mươi tệ."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('10bef37a-4c6d-5a5f-8b5c-2e1506de2d85'::UUID, 'a34b965d-1f05-5ceb-a797-a3613c08ee88'::UUID, 'multiple_choice', 5, '“想” có nghĩa phù hợp nhất là gì?', NULL, 'muốn; nghĩ', '想 (xiǎng) nghĩa là “muốn; nghĩ”.', NULL, 1, '{"activity_type":"chinese_to_vietnamese","vocabulary_key":"hsk1:想"}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('ee52edcb-335f-5b64-91cb-8d31203f67ed'::UUID, '10bef37a-4c6d-5a5f-8b5c-2e1506de2d85'::UUID, 'muốn; nghĩ', TRUE, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('4b057663-6a6a-5673-ab77-f71488310c1a'::UUID, '10bef37a-4c6d-5a5f-8b5c-2e1506de2d85'::UUID, 'uống', FALSE, 2)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('8985a512-cc43-518f-b350-091d58a79f39'::UUID, '10bef37a-4c6d-5a5f-8b5c-2e1506de2d85'::UUID, 'quả táo', FALSE, 3)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('3637cbb4-2359-5746-b93e-8cfb88dbd44b'::UUID, '10bef37a-4c6d-5a5f-8b5c-2e1506de2d85'::UUID, 'đồng; miếng', FALSE, 4)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('54cd8dba-983a-5d83-9a26-f638f271a0c3'::UUID, 'a34b965d-1f05-5ceb-a797-a3613c08ee88'::UUID, 'translation', 6, 'Dịch sang tiếng Trung: “Tôi muốn uống một cốc trà nóng.”', NULL, '我想喝一杯热茶。', 'Mẫu câu dùng “想” trong ngữ cảnh của bài.', 'xiǎng', 1, '{"activity_type":"vietnamese_to_chinese","source_lang":"vi","target_lang":"zh","acceptable_answers":["我想喝一杯热茶。"]}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('cac28d01-e8f4-514c-9e4c-94e124f06bd4'::UUID, 'a34b965d-1f05-5ceb-a797-a3613c08ee88'::UUID, 'sentence_builder', 7, 'Sắp xếp các thành phần thành câu đúng.', NULL, '我想喝一杯热茶。', 'Trật tự đúng tạo thành câu “我想喝一杯热茶。”.', NULL, 1, '{"activity_type":"sentence_ordering","words":["我","想","喝","一杯","热茶","。"],"correct_order":["我","想","喝","一杯","热茶","。"]}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('edef6942-4b5a-5952-94de-1b88f131c1dc'::UUID, 'a34b965d-1f05-5ceb-a797-a3613c08ee88'::UUID, 'multiple_choice', 8, 'Câu nào nói mong muốn uống trà nóng?', NULL, '我想喝一杯热茶。', '想 diễn tả mong muốn tương đối nhẹ và lịch sự.', NULL, 1, '{"activity_type":"grammar_selection","passage":null,"grammar_key":"hsk1:an-uong-va-mua-sam"}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('d9f6c00b-6be2-50bf-a00d-f67c223c3932'::UUID, 'edef6942-4b5a-5952-94de-1b88f131c1dc'::UUID, '我想喝一杯热茶。', TRUE, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('c5993e75-730d-5c7f-8b0e-219ee0960b98'::UUID, 'edef6942-4b5a-5952-94de-1b88f131c1dc'::UUID, '我喝想热茶一杯。', FALSE, 2)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('36b40429-a026-5175-8998-a433cf435635'::UUID, 'edef6942-4b5a-5952-94de-1b88f131c1dc'::UUID, '想我一杯不热茶。', FALSE, 3)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('3e4ef3fc-16b5-5c97-a7d8-9d6252e00d04'::UUID, 'a34b965d-1f05-5ceb-a797-a3613c08ee88'::UUID, 'speaking', 9, 'Đọc thành tiếng: 我想喝一杯热茶。', NULL, '我想喝一杯热茶。', 'Đọc chậm, giữ đúng thanh điệu và nhịp của cả câu.', NULL, 1, '{"activity_type":"pronunciation","text":"我想喝一杯热茶。","pinyin":"Wǒ xiǎng hē yì bēi rè chá."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lessons (id, chapter_id, slug, title, description, order_index, xp_reward, status, lesson_type, estimated_minutes, learning_objectives, cultural_note, content_version)
VALUES ('880b7a2f-d83a-59f3-878b-f1f9a5ff385e'::UUID, '8f619c02-fa78-52ea-b892-ce966d24bacb'::UUID, 'di-lai-va-vi-tri', '怎么去？— Đi lại và vị trí', 'Hỏi cách đi và xác định vị trí gần.', 2, 25, 'review', 'standard', 15, '["Hỏi phương thức bằng 怎么","Nói vị trí với 前面/后面"]'::JSONB, NULL, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('9cbcdd99-075f-5cb3-bd9c-5d9c4322a188'::UUID, 'hsk1:怎么', '怎么', 'zěnme', 'thế nào, bằng cách nào', 'how', 'beginner', 'di-lai-va-vi-tri', 'đại từ nghi vấn', '我们怎么去火车站？', 'Wǒmen zěnme qù huǒchēzhàn?', 'Chúng ta đi ga tàu hỏa bằng cách nào?', NULL, 'review', '880b7a2f-d83a-59f3-878b-f1f9a5ff385e'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('a8808f13-eeae-5312-9202-33e7ff8d0cef'::UUID, '880b7a2f-d83a-59f3-878b-f1f9a5ff385e'::UUID, '9cbcdd99-075f-5cb3-bd9c-5d9c4322a188'::UUID, 1, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('b80b60b4-fc1e-558c-a439-baa930198a96'::UUID, 'hsk1:公共汽车', '公共汽车', 'gōnggòng qìchē', 'xe buýt', 'bus', 'beginner', 'di-lai-va-vi-tri', 'danh từ', '我每天坐公共汽车上班。', 'Wǒ měitiān zuò gōnggòng qìchē shàngbān.', 'Mỗi ngày tôi đi xe buýt đến chỗ làm.', NULL, 'review', '880b7a2f-d83a-59f3-878b-f1f9a5ff385e'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('990de8cf-ca5c-5597-81d7-44d5bd2b9500'::UUID, '880b7a2f-d83a-59f3-878b-f1f9a5ff385e'::UUID, 'b80b60b4-fc1e-558c-a439-baa930198a96'::UUID, 2, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('3497ed6e-d317-5aa9-a4e2-726bd22c16d6'::UUID, 'hsk1:前面', '前面', 'qiánmiàn', 'phía trước', 'in front', 'beginner', 'di-lai-va-vi-tri', 'danh từ phương vị', '超市就在前面。', 'Chāoshì jiù zài qiánmiàn.', 'Siêu thị ở ngay phía trước.', NULL, 'review', '880b7a2f-d83a-59f3-878b-f1f9a5ff385e'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('38bcd1c7-05f1-57d0-a649-4efdea84500d'::UUID, '880b7a2f-d83a-59f3-878b-f1f9a5ff385e'::UUID, '3497ed6e-d317-5aa9-a4e2-726bd22c16d6'::UUID, 3, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('7756d1a3-ab23-5f6a-8cf7-13cf842f7f25'::UUID, 'hsk1:后面', '后面', 'hòumiàn', 'phía sau', 'behind', 'beginner', 'di-lai-va-vi-tri', 'danh từ phương vị', '学校后面有一个公园。', 'Xuéxiào hòumiàn yǒu yí ge gōngyuán.', 'Phía sau trường có một công viên.', NULL, 'review', '880b7a2f-d83a-59f3-878b-f1f9a5ff385e'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('1d84a1fd-b999-5e95-8c20-46fb34c9a887'::UUID, '880b7a2f-d83a-59f3-878b-f1f9a5ff385e'::UUID, '7756d1a3-ab23-5f6a-8cf7-13cf842f7f25'::UUID, 4, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('031611d6-4668-58f8-b44a-f8ed0b9cbc6e'::UUID, '880b7a2f-d83a-59f3-878b-f1f9a5ff385e'::UUID, '9fede698-76e6-5906-a9a1-8d86c9b692ef'::UUID, 5, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('304866de-1a6a-54b3-82db-a3c618913ece'::UUID, '880b7a2f-d83a-59f3-878b-f1f9a5ff385e'::UUID, 'cc65ac7a-8cae-59ac-8b43-43c17ed3945a'::UUID, 6, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('a83e4a03-bb8a-51d3-84e5-2e4781b4324e'::UUID, '880b7a2f-d83a-59f3-878b-f1f9a5ff385e'::UUID, '796263c4-6f4f-56de-af2d-37814f782717'::UUID, 7, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('47f25c5a-b869-5d27-9d5e-8fed9bd60f55'::UUID, '880b7a2f-d83a-59f3-878b-f1f9a5ff385e'::UUID, 'a962ac2d-b9b9-5e13-bd16-f3427cdc5aea'::UUID, 8, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.grammar_lessons (id, content_key, title, pattern, explanation, example_chinese, example_pinyin, example_meaning, level, status, usage_note, content_version)
VALUES ('f61de790-9171-585f-aa67-2004dd26cd0c'::UUID, 'hsk1:di-lai-va-vi-tri', 'Hỏi cách thức bằng 怎么', 'chủ ngữ + 怎么 + động từ', '怎么 đứng trước động từ để hỏi cách thực hiện hành động.', '我们怎么去火车站？', 'Wǒmen zěnme qù huǒchēzhàn?', 'Chúng ta đi ga tàu hỏa bằng cách nào?', 'beginner', 'review', NULL, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_grammar (id, lesson_id, grammar_lesson_id, order_index, curriculum_role)
VALUES ('e0388356-24ff-571e-b0a9-2745a658629c'::UUID, '880b7a2f-d83a-59f3-878b-f1f9a5ff385e'::UUID, 'f61de790-9171-585f-aa67-2004dd26cd0c'::UUID, 1, 'introduced')
ON CONFLICT (lesson_id, grammar_lesson_id) DO NOTHING;

INSERT INTO public.lesson_grammar (id, lesson_id, grammar_lesson_id, order_index, curriculum_role)
VALUES ('ff26a809-806a-5664-97a2-85ddabe3f248'::UUID, '880b7a2f-d83a-59f3-878b-f1f9a5ff385e'::UUID, '7d421f77-866c-56f1-8619-002a8309d75d'::UUID, 2, 'review')
ON CONFLICT (lesson_id, grammar_lesson_id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('64fdba98-3b9b-5cbb-8159-ec1434a777fd'::UUID, '880b7a2f-d83a-59f3-878b-f1f9a5ff385e'::UUID, 'vocabulary', 1, 'Từ mới: 怎么', NULL, '怎么', '怎么 (zěnme) — thế nào, bằng cách nào. 我们怎么去火车站？', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"hsk1:怎么","chinese":"怎么","pinyin":"zěnme","meaning":"thế nào, bằng cách nào","part_of_speech":"đại từ nghi vấn","example_chinese":"我们怎么去火车站？","example_pinyin":"Wǒmen zěnme qù huǒchēzhàn?","example_meaning_vi":"Chúng ta đi ga tàu hỏa bằng cách nào?"}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('1a4dcdbc-55ac-54c5-a666-6a600d33d286'::UUID, '880b7a2f-d83a-59f3-878b-f1f9a5ff385e'::UUID, 'vocabulary', 2, 'Từ mới: 公共汽车', NULL, '公共汽车', '公共汽车 (gōnggòng qìchē) — xe buýt. 我每天坐公共汽车上班。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"hsk1:公共汽车","chinese":"公共汽车","pinyin":"gōnggòng qìchē","meaning":"xe buýt","part_of_speech":"danh từ","example_chinese":"我每天坐公共汽车上班。","example_pinyin":"Wǒ měitiān zuò gōnggòng qìchē shàngbān.","example_meaning_vi":"Mỗi ngày tôi đi xe buýt đến chỗ làm."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('ba1bedb3-9a8b-5d87-8cb5-a33bf449db6f'::UUID, '880b7a2f-d83a-59f3-878b-f1f9a5ff385e'::UUID, 'vocabulary', 3, 'Từ mới: 前面', NULL, '前面', '前面 (qiánmiàn) — phía trước. 超市就在前面。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"hsk1:前面","chinese":"前面","pinyin":"qiánmiàn","meaning":"phía trước","part_of_speech":"danh từ phương vị","example_chinese":"超市就在前面。","example_pinyin":"Chāoshì jiù zài qiánmiàn.","example_meaning_vi":"Siêu thị ở ngay phía trước."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('fdc13724-bce4-5dd3-8658-ee7c8b4b0d2e'::UUID, '880b7a2f-d83a-59f3-878b-f1f9a5ff385e'::UUID, 'vocabulary', 4, 'Từ mới: 后面', NULL, '后面', '后面 (hòumiàn) — phía sau. 学校后面有一个公园。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"hsk1:后面","chinese":"后面","pinyin":"hòumiàn","meaning":"phía sau","part_of_speech":"danh từ phương vị","example_chinese":"学校后面有一个公园。","example_pinyin":"Xuéxiào hòumiàn yǒu yí ge gōngyuán.","example_meaning_vi":"Phía sau trường có một công viên."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('e0a053d7-6cf4-5702-8306-0e3760e63c0c'::UUID, '880b7a2f-d83a-59f3-878b-f1f9a5ff385e'::UUID, 'multiple_choice', 5, '“怎么” có nghĩa phù hợp nhất là gì?', NULL, 'thế nào, bằng cách nào', '怎么 (zěnme) nghĩa là “thế nào, bằng cách nào”.', NULL, 1, '{"activity_type":"chinese_to_vietnamese","vocabulary_key":"hsk1:怎么"}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('59935a72-3612-54e9-8332-77511db9e2c9'::UUID, 'e0a053d7-6cf4-5702-8306-0e3760e63c0c'::UUID, 'xe buýt', FALSE, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('1144ad8f-a9f7-5303-88b6-167864249b86'::UUID, 'e0a053d7-6cf4-5702-8306-0e3760e63c0c'::UUID, 'phía trước', FALSE, 2)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('912e6477-5b0a-5e67-bd76-202383d99d27'::UUID, 'e0a053d7-6cf4-5702-8306-0e3760e63c0c'::UUID, 'phía sau', FALSE, 3)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('fe5b0c90-a6f2-527c-98f5-531bcd0be34a'::UUID, 'e0a053d7-6cf4-5702-8306-0e3760e63c0c'::UUID, 'thế nào, bằng cách nào', TRUE, 4)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('c49d5400-491a-5447-b405-e874b69b89ce'::UUID, '880b7a2f-d83a-59f3-878b-f1f9a5ff385e'::UUID, 'translation', 6, 'Dịch sang tiếng Trung: “Chúng ta đi ga tàu hỏa bằng cách nào?”', NULL, '我们怎么去火车站？', 'Mẫu câu dùng “怎么” trong ngữ cảnh của bài.', 'zěnme', 1, '{"activity_type":"vietnamese_to_chinese","source_lang":"vi","target_lang":"zh","acceptable_answers":["我们怎么去火车站？"]}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('51e59c0b-ad58-5e32-b598-9c0a90b7ff18'::UUID, '880b7a2f-d83a-59f3-878b-f1f9a5ff385e'::UUID, 'sentence_builder', 7, 'Sắp xếp các thành phần thành câu đúng.', NULL, '我们怎么去火车站？', 'Trật tự đúng tạo thành câu “我们怎么去火车站？”.', NULL, 1, '{"activity_type":"sentence_ordering","words":["我们","怎么","去","火车站","？"],"correct_order":["我们","怎么","去","火车站","？"]}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('3541cdb5-16aa-5478-96a7-cf3360cadccc'::UUID, '880b7a2f-d83a-59f3-878b-f1f9a5ff385e'::UUID, 'multiple_choice', 8, 'Câu nào hỏi cách đi đến ga tàu hỏa?', NULL, '我们怎么去火车站？', '怎么 đứng trước động từ để hỏi cách thực hiện hành động.', NULL, 1, '{"activity_type":"grammar_selection","passage":null,"grammar_key":"hsk1:di-lai-va-vi-tri"}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('844a7bb0-1c51-575d-be0b-814f51804d58'::UUID, '3541cdb5-16aa-5478-96a7-cf3360cadccc'::UUID, '我们怎么去火车站？', TRUE, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('13812c6a-3265-5b8a-b6f4-0e14b1241280'::UUID, '3541cdb5-16aa-5478-96a7-cf3360cadccc'::UUID, '我们去怎么火车站？', FALSE, 2)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('dc470374-5eff-53c4-8679-507b107f57b1'::UUID, '3541cdb5-16aa-5478-96a7-cf3360cadccc'::UUID, '怎么火车站我们不去？', FALSE, 3)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('5b742962-0719-5d1e-95ce-6b79761c562e'::UUID, '880b7a2f-d83a-59f3-878b-f1f9a5ff385e'::UUID, 'speaking', 9, 'Đọc thành tiếng: 我们怎么去火车站？', NULL, '我们怎么去火车站？', 'Đọc chậm, giữ đúng thanh điệu và nhịp của cả câu.', NULL, 1, '{"activity_type":"pronunciation","text":"我们怎么去火车站？","pinyin":"Wǒmen zěnme qù huǒchēzhàn?"}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lessons (id, chapter_id, slug, title, description, order_index, xp_reward, status, lesson_type, estimated_minutes, learning_objectives, cultural_note, content_version)
VALUES ('39bde3c1-9cfe-5b7b-9c15-d39dc0d2bc1c'::UUID, '8f619c02-fa78-52ea-b892-ce966d24bacb'::UUID, 'hsk1-review', 'Ôn tập HSK 1', 'Củng cố từ vựng, mẫu câu và khả năng diễn đạt của toàn khóa.', 3, 30, 'review', 'review', 18, '["Vận dụng lại từ vựng trọng tâm","Tự kiểm tra mẫu câu đã học"]'::JSONB, NULL, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('dd2e7b65-3890-5f5e-a846-cf1ab77d1335'::UUID, '39bde3c1-9cfe-5b7b-9c15-d39dc0d2bc1c'::UUID, '9cbcdd99-075f-5cb3-bd9c-5d9c4322a188'::UUID, 1, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('75e5afce-6780-5992-afb8-e8c2f41cebe5'::UUID, '39bde3c1-9cfe-5b7b-9c15-d39dc0d2bc1c'::UUID, 'b80b60b4-fc1e-558c-a439-baa930198a96'::UUID, 2, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('fe013b0f-a87f-5bb9-bcc1-973b2da0efdf'::UUID, '39bde3c1-9cfe-5b7b-9c15-d39dc0d2bc1c'::UUID, '3497ed6e-d317-5aa9-a4e2-726bd22c16d6'::UUID, 3, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('efb5ac70-613a-5db3-8e6d-29c0dcfa4bd4'::UUID, '39bde3c1-9cfe-5b7b-9c15-d39dc0d2bc1c'::UUID, '7756d1a3-ab23-5f6a-8cf7-13cf842f7f25'::UUID, 4, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_grammar (id, lesson_id, grammar_lesson_id, order_index, curriculum_role)
VALUES ('44646471-d189-52a7-86c2-b5b31a42928b'::UUID, '39bde3c1-9cfe-5b7b-9c15-d39dc0d2bc1c'::UUID, 'f61de790-9171-585f-aa67-2004dd26cd0c'::UUID, 1, 'review')
ON CONFLICT (lesson_id, grammar_lesson_id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('1e7092db-3e49-5f7b-8d9e-24519e08f62f'::UUID, '39bde3c1-9cfe-5b7b-9c15-d39dc0d2bc1c'::UUID, 'multiple_choice', 1, '“怎么” có nghĩa phù hợp nhất là gì?', NULL, 'thế nào, bằng cách nào', '怎么 (zěnme) nghĩa là “thế nào, bằng cách nào”.', NULL, 1, '{"activity_type":"chinese_to_vietnamese","vocabulary_key":"hsk1:怎么"}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('170054eb-faa4-5192-855b-267597b5d80f'::UUID, '1e7092db-3e49-5f7b-8d9e-24519e08f62f'::UUID, 'thế nào, bằng cách nào', TRUE, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('41c70557-c9ad-50b8-9269-1fd581fa0cc2'::UUID, '1e7092db-3e49-5f7b-8d9e-24519e08f62f'::UUID, 'xe buýt', FALSE, 2)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('c3f6b17a-cacf-5557-834a-61d600de4f99'::UUID, '1e7092db-3e49-5f7b-8d9e-24519e08f62f'::UUID, 'phía trước', FALSE, 3)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('340168d6-7f9c-5183-8d88-ce2f2883fe24'::UUID, '1e7092db-3e49-5f7b-8d9e-24519e08f62f'::UUID, 'phía sau', FALSE, 4)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('53a0c1d4-d2ec-591a-9890-a473e1432d95'::UUID, '39bde3c1-9cfe-5b7b-9c15-d39dc0d2bc1c'::UUID, 'translation', 2, 'Dịch sang tiếng Trung: “Chúng ta đi ga tàu hỏa bằng cách nào?”', NULL, '我们怎么去火车站？', 'Mẫu câu dùng “怎么” trong ngữ cảnh của bài.', 'zěnme', 1, '{"activity_type":"vietnamese_to_chinese","source_lang":"vi","target_lang":"zh","acceptable_answers":["我们怎么去火车站？"]}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('4cc607fe-27d4-5cbc-ad3d-c46fea4c98d9'::UUID, '39bde3c1-9cfe-5b7b-9c15-d39dc0d2bc1c'::UUID, 'sentence_builder', 3, 'Sắp xếp các thành phần thành câu đúng.', NULL, '我们怎么去火车站？', 'Trật tự đúng tạo thành câu “我们怎么去火车站？”.', NULL, 1, '{"activity_type":"sentence_ordering","words":["我们","怎么","去","火车站","？"],"correct_order":["我们","怎么","去","火车站","？"]}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('4940917c-c3a6-5366-8e97-140a9f02659b'::UUID, '39bde3c1-9cfe-5b7b-9c15-d39dc0d2bc1c'::UUID, 'multiple_choice', 4, 'Câu nào hỏi cách đi đến ga tàu hỏa?', NULL, '我们怎么去火车站？', '怎么 đứng trước động từ để hỏi cách thực hiện hành động.', NULL, 1, '{"activity_type":"grammar_selection","passage":null,"grammar_key":"hsk1:di-lai-va-vi-tri"}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('0a819a36-8416-5b88-9fcb-86a23a48f3d5'::UUID, '4940917c-c3a6-5366-8e97-140a9f02659b'::UUID, '我们怎么去火车站？', TRUE, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('19c1ca78-ddb2-5b7c-bada-25f0bad7426e'::UUID, '4940917c-c3a6-5366-8e97-140a9f02659b'::UUID, '我们去怎么火车站？', FALSE, 2)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('b195c71c-c014-5a89-ae3c-223b5d446497'::UUID, '4940917c-c3a6-5366-8e97-140a9f02659b'::UUID, '怎么火车站我们不去？', FALSE, 3)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('aad7e35b-8778-5bff-8afd-a1153ba12064'::UUID, '39bde3c1-9cfe-5b7b-9c15-d39dc0d2bc1c'::UUID, 'speaking', 5, 'Đọc thành tiếng: 我们怎么去火车站？', NULL, '我们怎么去火车站？', 'Đọc chậm, giữ đúng thanh điệu và nhịp của cả câu.', NULL, 1, '{"activity_type":"pronunciation","text":"我们怎么去火车站？","pinyin":"Wǒmen zěnme qù huǒchēzhàn?"}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.content_batches (id, batch_key, version, migration_name, manifest_checksum, expected_counts)
VALUES ('34a214ce-00a5-5d95-ab5c-9db8eed9b13d'::UUID, 'batch-02-hsk1', 1, '20260729110000_content_batch_02_hsk1', '6e5125b2db33fdd055a266df231bf8048a21dddc51ece6b7041f5eb7233ee338', '{"courses":1,"units":3,"chapters":3,"lessons":9,"vocabulary":32,"grammar":8,"characters":0,"exercises":77,"options":63}'::JSONB)
ON CONFLICT (batch_key, version) DO NOTHING;

DO $content_validation$
BEGIN
  IF (SELECT COUNT(*) FROM public.courses WHERE id = ANY(ARRAY['33228bdd-72c2-54f3-b187-0af47cd18790'::UUID]::UUID[])) <> 1 THEN
    RAISE EXCEPTION 'Content batch batch-02-hsk1 is missing managed courses rows';
  END IF;
  IF (SELECT COUNT(*) FROM public.units WHERE id = ANY(ARRAY['aeb45b3f-6c10-584a-baa5-1a020b62a9dc'::UUID, '904f8773-9e13-575a-80a5-7f81e238d630'::UUID, 'd958341b-8314-533c-add6-79d67cae543b'::UUID]::UUID[])) <> 3 THEN
    RAISE EXCEPTION 'Content batch batch-02-hsk1 is missing managed units rows';
  END IF;
  IF (SELECT COUNT(*) FROM public.chapters WHERE id = ANY(ARRAY['f41449ef-08e2-5d4c-a9c1-a7074c794626'::UUID, 'efeef7ce-7455-5f62-b960-2b2a7353ad18'::UUID, '8f619c02-fa78-52ea-b892-ce966d24bacb'::UUID]::UUID[])) <> 3 THEN
    RAISE EXCEPTION 'Content batch batch-02-hsk1 is missing managed chapters rows';
  END IF;
  IF (SELECT COUNT(*) FROM public.lessons WHERE id = ANY(ARRAY['cd97bc6a-cfbd-5e9e-a2a0-ec9aaf890232'::UUID, '9710f45f-7a87-55ee-b54e-856b955194aa'::UUID, 'c069c208-1e99-52b9-833c-67939fb1fb5d'::UUID, '9258d179-6e23-5c1d-a5d9-78f1614f899d'::UUID, 'b77fab37-7af9-5e46-b7f4-9cadce226a8a'::UUID, '9e581056-541a-564d-91ca-cd74373a20e1'::UUID, 'a34b965d-1f05-5ceb-a797-a3613c08ee88'::UUID, '880b7a2f-d83a-59f3-878b-f1f9a5ff385e'::UUID, '39bde3c1-9cfe-5b7b-9c15-d39dc0d2bc1c'::UUID]::UUID[])) <> 9 THEN
    RAISE EXCEPTION 'Content batch batch-02-hsk1 is missing managed lessons rows';
  END IF;
  IF (SELECT COUNT(*) FROM public.vocabulary WHERE id = ANY(ARRAY['16302ca3-ea03-5554-8585-1005c2995fd1'::UUID, '8f30f717-1579-5142-9e2a-a61e4556f7bb'::UUID, '98ace347-6976-5dcf-a254-2baa97ee5361'::UUID, 'fc9bbbc2-b0e0-5940-bcd9-0f9e07ac6676'::UUID, 'ea61e78e-a574-5237-a177-c50ffc1c0c55'::UUID, '90b68c4e-94bc-5105-b01c-6a4001d2e1cb'::UUID, '376c5db5-b63d-5152-964f-c207d2f36d44'::UUID, '44afe437-86b4-5306-896f-e70d2960aeb6'::UUID, '14890f3e-8da5-5ba6-9a67-af085c82d012'::UUID, '3b16a062-a1c4-549b-bf7d-d4c476c2dae2'::UUID, '861ecff4-5aeb-5b4a-ab9e-33f5d36a3e7d'::UUID, 'cb6f55f5-b2d2-5c1a-83fb-6d5127b63758'::UUID, 'e2f93d13-475e-55aa-8cc3-4b8e912ca715'::UUID, '3c2c0d8c-c709-573c-bd7a-8364bb5cb121'::UUID, '2c126f1e-db14-5ab5-9221-49e3cc057505'::UUID, 'b4718490-fa71-522e-ae64-b0790070bb9f'::UUID, 'b86cff26-6bb1-593c-bef3-ee4982d48252'::UUID, 'f5e5de26-1eaa-5f81-8188-6d807e9b79a3'::UUID, '0461ec91-bd5b-5442-9064-614b156582a9'::UUID, 'b5a4e63a-06bc-5632-89db-d7df91e98044'::UUID, 'b7ef7103-8d4e-5323-87a2-d70f1f2dfaf6'::UUID, 'bbb7463f-b64c-5950-b099-dc9c4cf4956c'::UUID, '2efd2b87-af22-53a4-bab5-5811201d6072'::UUID, 'be9be0f1-72ed-590a-88ae-08222750eda6'::UUID, '9fede698-76e6-5906-a9a1-8d86c9b692ef'::UUID, 'cc65ac7a-8cae-59ac-8b43-43c17ed3945a'::UUID, '796263c4-6f4f-56de-af2d-37814f782717'::UUID, 'a962ac2d-b9b9-5e13-bd16-f3427cdc5aea'::UUID, '9cbcdd99-075f-5cb3-bd9c-5d9c4322a188'::UUID, 'b80b60b4-fc1e-558c-a439-baa930198a96'::UUID, '3497ed6e-d317-5aa9-a4e2-726bd22c16d6'::UUID, '7756d1a3-ab23-5f6a-8cf7-13cf842f7f25'::UUID]::UUID[])) <> 32 THEN
    RAISE EXCEPTION 'Content batch batch-02-hsk1 is missing managed vocabulary rows';
  END IF;
  IF (SELECT COUNT(*) FROM public.grammar_lessons WHERE id = ANY(ARRAY['1d8cb9b9-2204-516a-904b-3b1d262f6e3b'::UUID, '60d82f9f-4d46-5250-ae8a-6e29d6e2478a'::UUID, '8ed9f1e5-e93e-5799-b03f-6228e3b641b4'::UUID, '21d33358-7263-5d34-b4f4-d587c4ec3600'::UUID, 'b30c1b87-6c21-56d0-8893-286b5ef12e63'::UUID, '0a7f8b4d-ae53-5cf0-9b1d-baf481277e3e'::UUID, '7d421f77-866c-56f1-8619-002a8309d75d'::UUID, 'f61de790-9171-585f-aa67-2004dd26cd0c'::UUID]::UUID[])) <> 8 THEN
    RAISE EXCEPTION 'Content batch batch-02-hsk1 is missing managed grammar_lessons rows';
  END IF;
  IF (SELECT COUNT(*) FROM public.exercises WHERE id = ANY(ARRAY['ac44c5d5-727d-5448-970d-dbbd3f388724'::UUID, 'bc33a069-6780-56dc-9732-e421ebb5878f'::UUID, 'de51c512-50e4-5377-a02a-d7f92fee2088'::UUID, '8da2b124-34eb-54b7-8c19-c08f4e52fad4'::UUID, 'dd2add91-b8c9-5905-a143-263b68d3cda7'::UUID, 'b0b0b7fd-3881-5c35-ab17-f7db482b243d'::UUID, '5db90aa7-7e76-5e71-8383-e23aa2cf3bcc'::UUID, 'bfe5dfb7-e598-51b6-9543-85bc69fcce93'::UUID, 'fd2909c5-e589-5cfe-93dc-b6f3a0c867bf'::UUID, '0a04bcd1-a3d7-5b3d-8be5-964a9ad46116'::UUID, '0cda6301-a437-51e4-8939-bb35f36f81de'::UUID, 'a585998f-f61f-56b9-9d2b-18bd8491d4ca'::UUID, '9a8e1068-422c-59e0-be75-d4f76c97dc2b'::UUID, '7231b542-dcbc-56d4-b3a5-458c40fe88cb'::UUID, '5213cbd1-e2e1-5259-8fe2-3aeecf590845'::UUID, '6ce0e2f1-19b4-5ac3-9e30-5713468bbc54'::UUID, '8aa79b85-f606-5687-afec-8ca6eeae1c42'::UUID, '076ffed1-457b-53e1-be3f-01419b41ef2d'::UUID, '62ae08e4-b092-55f1-b7e9-800440896d56'::UUID, '4d3c59a1-faaa-504d-ac55-7677a5ac4965'::UUID, '8f76bcf1-d185-5628-90e3-8bc51c5953af'::UUID, 'c3266ade-c260-5fc4-aad2-20671c2e8d4c'::UUID, '7b3c3d6d-deb7-52c4-a1bb-2be91813a602'::UUID, '5ba5c680-cf22-574e-b9f7-419962d1aeef'::UUID, 'c9ba4f26-5b7f-5046-bb79-2a3a029cc1d8'::UUID, '8a268934-ac86-5c12-ba73-f572c5e03244'::UUID, '410d8aab-ab26-51fc-a961-bbd4929ccd31'::UUID, 'db2e66c0-75b6-567e-9210-1368f0819bc1'::UUID, 'a19ca4f0-20bd-5c52-b5a3-3e7f20be1c00'::UUID, 'd27c66eb-abaf-5813-9b5b-c376f9adc9c7'::UUID, '9a50c365-adfa-5e09-bbe8-3d2d686ff948'::UUID, 'cfa8d5c1-69a4-5835-bcdb-3806a535faee'::UUID, 'c5a1f15c-92ba-5162-a222-71385ce39375'::UUID, '8e444465-71c6-54c5-ba0a-0a45d5c6fc03'::UUID, '8623f487-f5cf-586d-8dc3-337d322c4f0f'::UUID, '40b54661-bc27-5d77-82fd-2169a05cddd2'::UUID, '1a3869fb-135d-5b8a-9c5b-75e3c8b7a121'::UUID, 'de35bf1b-d098-5b8a-a49d-06e4bbfd5abe'::UUID, '4354e967-7601-510c-92d3-1b97397b2548'::UUID, 'fbc35034-8d8e-5169-acc8-a422710e1cfb'::UUID, '98846116-1b3c-5014-bfb4-a70f75569f11'::UUID, '75f516b8-acd6-543f-bb7c-40777988c30c'::UUID, '521d180a-bc5f-5e5b-ae84-7e5c4d1ce9c5'::UUID, 'ffcbae23-c081-583b-aa38-cc11fe1637bd'::UUID, '3bc15bf1-c8e6-526f-a814-e21fe9d1a349'::UUID, '7d5a6dbb-b3ea-547f-b39b-4ac40f3d0cff'::UUID, '853c605b-6efd-52ac-bf26-b34cb128dee2'::UUID, 'ff98833c-d382-59dd-80fe-a2ef0cf8081c'::UUID, 'd8b349e1-d598-5a45-b73a-166bb94461c8'::UUID, 'c7e2f40f-0ec5-59e1-a96f-e0ce46d0bb67'::UUID, '5e0f0a4a-d182-5723-910e-a5b7a1c49759'::UUID, 'd1e5029d-8b12-55ba-8533-f89233af1d37'::UUID, 'eb0e130e-d361-5203-be9e-7ee94583db0d'::UUID, '19baf5d3-7060-543d-bcdd-59f81ec301f7'::UUID, 'e376f949-77cd-51f7-94c3-3bbc0e7f49ef'::UUID, '43c0a9c8-a1ee-56dd-8322-df35c487f90f'::UUID, 'c4ae9407-28c7-5f7d-9328-6991b9d0597a'::UUID, 'e711cb00-0dbd-5995-972c-3fdd3149216f'::UUID, '10bef37a-4c6d-5a5f-8b5c-2e1506de2d85'::UUID, '54cd8dba-983a-5d83-9a26-f638f271a0c3'::UUID, 'cac28d01-e8f4-514c-9e4c-94e124f06bd4'::UUID, 'edef6942-4b5a-5952-94de-1b88f131c1dc'::UUID, '3e4ef3fc-16b5-5c97-a7d8-9d6252e00d04'::UUID, '64fdba98-3b9b-5cbb-8159-ec1434a777fd'::UUID, '1a4dcdbc-55ac-54c5-a666-6a600d33d286'::UUID, 'ba1bedb3-9a8b-5d87-8cb5-a33bf449db6f'::UUID, 'fdc13724-bce4-5dd3-8658-ee7c8b4b0d2e'::UUID, 'e0a053d7-6cf4-5702-8306-0e3760e63c0c'::UUID, 'c49d5400-491a-5447-b405-e874b69b89ce'::UUID, '51e59c0b-ad58-5e32-b598-9c0a90b7ff18'::UUID, '3541cdb5-16aa-5478-96a7-cf3360cadccc'::UUID, '5b742962-0719-5d1e-95ce-6b79761c562e'::UUID, '1e7092db-3e49-5f7b-8d9e-24519e08f62f'::UUID, '53a0c1d4-d2ec-591a-9890-a473e1432d95'::UUID, '4cc607fe-27d4-5cbc-ad3d-c46fea4c98d9'::UUID, '4940917c-c3a6-5366-8e97-140a9f02659b'::UUID, 'aad7e35b-8778-5bff-8afd-a1153ba12064'::UUID]::UUID[])) <> 77 THEN
    RAISE EXCEPTION 'Content batch batch-02-hsk1 is missing managed exercises rows';
  END IF;
  IF (SELECT COUNT(*) FROM public.exercise_options WHERE id = ANY(ARRAY['2ed6b824-d6c1-5ddd-ba17-540c35ffded0'::UUID, 'c1e4b1a4-7f08-5ddf-b003-832b6ac8030e'::UUID, '9c67f9af-83ed-56c4-8c3c-e3f49a8738e4'::UUID, '2646b6ad-4307-5be3-8999-2d2c08c6fc8d'::UUID, '92286edc-5480-52a4-8d8c-6ed7fd3a0593'::UUID, '1321f10d-c6ac-5acb-b8c3-dfbb72614672'::UUID, '51b7cf2c-0ec1-55af-914b-10e723e0db8d'::UUID, 'e5050d46-2725-5a16-b6f0-4557fc8b1922'::UUID, '4a432469-cd35-5233-af0b-31f727361602'::UUID, 'fa0710f7-0f2a-55ab-8c8c-38e6f72aa3e1'::UUID, '358c65c3-2b06-5a74-b08f-f797eeb477c2'::UUID, 'c3447268-d70b-5261-9b76-bd3d3c735cc4'::UUID, '68d9fc6e-3913-541a-83a7-d2f8aeb49ce6'::UUID, 'c0f115ad-e143-541e-9702-a303dfe3afc5'::UUID, '492e9cde-2500-5cb0-ad69-483e44076299'::UUID, '0bdad568-0f5e-5ad5-8c77-459767d813a1'::UUID, 'c42c51ee-48d0-5e7e-bd3f-3200f901b770'::UUID, 'a035c697-10cc-52de-9f77-2dfd80250c2e'::UUID, '230c423b-cec6-549a-98d8-3bdbf87342f2'::UUID, '85d04835-e95a-5d36-9347-42f70933486f'::UUID, '244a507e-37ef-591a-8930-2a95ded0e1f0'::UUID, '76915410-aff5-55a7-b455-19b092bada9f'::UUID, 'dbee8cc5-64ae-5a9b-9218-0ad29e448b05'::UUID, '010886cf-a701-5594-b1f2-01e45c97d5d3'::UUID, '1b16dbca-5aff-5af8-973a-19537bbec435'::UUID, '9c40bf6e-f869-50fc-888e-4cfdb8b03b53'::UUID, 'a262c423-91d5-528f-9717-4029a343d9b5'::UUID, 'af685a17-ccac-588e-935f-28c93b0276e4'::UUID, '1ef7c6db-cb7d-5558-8f4a-0df969a961df'::UUID, 'c368562d-6daa-5615-8eb6-9dcca374bef0'::UUID, '108c3a96-7749-540d-938a-7dc29d316ad9'::UUID, '815785b9-d04b-5ea1-8628-bf8801db8366'::UUID, '92097345-ceac-5e2e-b1f4-712f3d0afa85'::UUID, '37ad6024-dccb-5a62-82a5-5e158b84c9f0'::UUID, 'ecdc51b6-0ba3-55bf-9b10-65fe67e4d8a1'::UUID, '383ed8c6-a047-5546-ba88-29918e1e0d55'::UUID, '2e6c169b-e0ae-526a-aa26-38d2fe3b8fb8'::UUID, 'e9f53985-c7a1-5798-84d5-720e2009c58f'::UUID, 'f0eb829a-bf97-5db4-b3bf-61aa5cdadcbe'::UUID, '1268abe5-446f-5bba-a5a0-5dd2a4fead17'::UUID, '0c22e618-cc21-527d-ac2f-d053ccb83d0d'::UUID, 'a9a31a4e-4a63-5b2f-990b-b1b8495e8d88'::UUID, 'ee52edcb-335f-5b64-91cb-8d31203f67ed'::UUID, '4b057663-6a6a-5673-ab77-f71488310c1a'::UUID, '8985a512-cc43-518f-b350-091d58a79f39'::UUID, '3637cbb4-2359-5746-b93e-8cfb88dbd44b'::UUID, 'd9f6c00b-6be2-50bf-a00d-f67c223c3932'::UUID, 'c5993e75-730d-5c7f-8b0e-219ee0960b98'::UUID, '36b40429-a026-5175-8998-a433cf435635'::UUID, '59935a72-3612-54e9-8332-77511db9e2c9'::UUID, '1144ad8f-a9f7-5303-88b6-167864249b86'::UUID, '912e6477-5b0a-5e67-bd76-202383d99d27'::UUID, 'fe5b0c90-a6f2-527c-98f5-531bcd0be34a'::UUID, '844a7bb0-1c51-575d-be0b-814f51804d58'::UUID, '13812c6a-3265-5b8a-b6f4-0e14b1241280'::UUID, 'dc470374-5eff-53c4-8679-507b107f57b1'::UUID, '170054eb-faa4-5192-855b-267597b5d80f'::UUID, '41c70557-c9ad-50b8-9269-1fd581fa0cc2'::UUID, 'c3f6b17a-cacf-5557-834a-61d600de4f99'::UUID, '340168d6-7f9c-5183-8d88-ce2f2883fe24'::UUID, '0a819a36-8416-5b88-9fcb-86a23a48f3d5'::UUID, '19c1ca78-ddb2-5b7c-bada-25f0bad7426e'::UUID, 'b195c71c-c014-5a89-ae3c-223b5d446497'::UUID]::UUID[])) <> 63 THEN
    RAISE EXCEPTION 'Content batch batch-02-hsk1 is missing managed exercise_options rows';
  END IF;
  IF EXISTS (
    SELECT 1 FROM public.lessons AS lesson
    WHERE lesson.id = ANY(ARRAY['cd97bc6a-cfbd-5e9e-a2a0-ec9aaf890232'::UUID, '9710f45f-7a87-55ee-b54e-856b955194aa'::UUID, 'c069c208-1e99-52b9-833c-67939fb1fb5d'::UUID, '9258d179-6e23-5c1d-a5d9-78f1614f899d'::UUID, 'b77fab37-7af9-5e46-b7f4-9cadce226a8a'::UUID, '9e581056-541a-564d-91ca-cd74373a20e1'::UUID, 'a34b965d-1f05-5ceb-a797-a3613c08ee88'::UUID, '880b7a2f-d83a-59f3-878b-f1f9a5ff385e'::UUID, '39bde3c1-9cfe-5b7b-9c15-d39dc0d2bc1c'::UUID]::UUID[])
      AND NOT EXISTS (
        SELECT 1 FROM public.exercises AS exercise
        WHERE exercise.lesson_id = lesson.id
      )
  ) THEN
    RAISE EXCEPTION 'Content batch batch-02-hsk1 contains a lesson without exercises';
  END IF;
  IF EXISTS (
    SELECT 1
    FROM public.lessons AS lesson
    JOIN public.exercises AS exercise ON exercise.lesson_id = lesson.id
    WHERE lesson.id = ANY(ARRAY['cd97bc6a-cfbd-5e9e-a2a0-ec9aaf890232'::UUID, '9710f45f-7a87-55ee-b54e-856b955194aa'::UUID, 'c069c208-1e99-52b9-833c-67939fb1fb5d'::UUID, '9258d179-6e23-5c1d-a5d9-78f1614f899d'::UUID, 'b77fab37-7af9-5e46-b7f4-9cadce226a8a'::UUID, '9e581056-541a-564d-91ca-cd74373a20e1'::UUID, 'a34b965d-1f05-5ceb-a797-a3613c08ee88'::UUID, '880b7a2f-d83a-59f3-878b-f1f9a5ff385e'::UUID, '39bde3c1-9cfe-5b7b-9c15-d39dc0d2bc1c'::UUID]::UUID[])
      AND lesson.status = 'published'
      AND exercise.exercise_type = 'listening'
      AND NULLIF(BTRIM(exercise.question_audio_url), '') IS NULL
  ) THEN
    RAISE EXCEPTION 'Published listening exercise is missing playable audio';
  END IF;
  IF EXISTS (
    SELECT 1
    FROM public.exercises AS exercise
    WHERE exercise.id = ANY(ARRAY['ac44c5d5-727d-5448-970d-dbbd3f388724'::UUID, 'bc33a069-6780-56dc-9732-e421ebb5878f'::UUID, 'de51c512-50e4-5377-a02a-d7f92fee2088'::UUID, '8da2b124-34eb-54b7-8c19-c08f4e52fad4'::UUID, 'dd2add91-b8c9-5905-a143-263b68d3cda7'::UUID, 'b0b0b7fd-3881-5c35-ab17-f7db482b243d'::UUID, '5db90aa7-7e76-5e71-8383-e23aa2cf3bcc'::UUID, 'bfe5dfb7-e598-51b6-9543-85bc69fcce93'::UUID, 'fd2909c5-e589-5cfe-93dc-b6f3a0c867bf'::UUID, '0a04bcd1-a3d7-5b3d-8be5-964a9ad46116'::UUID, '0cda6301-a437-51e4-8939-bb35f36f81de'::UUID, 'a585998f-f61f-56b9-9d2b-18bd8491d4ca'::UUID, '9a8e1068-422c-59e0-be75-d4f76c97dc2b'::UUID, '7231b542-dcbc-56d4-b3a5-458c40fe88cb'::UUID, '5213cbd1-e2e1-5259-8fe2-3aeecf590845'::UUID, '6ce0e2f1-19b4-5ac3-9e30-5713468bbc54'::UUID, '8aa79b85-f606-5687-afec-8ca6eeae1c42'::UUID, '076ffed1-457b-53e1-be3f-01419b41ef2d'::UUID, '62ae08e4-b092-55f1-b7e9-800440896d56'::UUID, '4d3c59a1-faaa-504d-ac55-7677a5ac4965'::UUID, '8f76bcf1-d185-5628-90e3-8bc51c5953af'::UUID, 'c3266ade-c260-5fc4-aad2-20671c2e8d4c'::UUID, '7b3c3d6d-deb7-52c4-a1bb-2be91813a602'::UUID, '5ba5c680-cf22-574e-b9f7-419962d1aeef'::UUID, 'c9ba4f26-5b7f-5046-bb79-2a3a029cc1d8'::UUID, '8a268934-ac86-5c12-ba73-f572c5e03244'::UUID, '410d8aab-ab26-51fc-a961-bbd4929ccd31'::UUID, 'db2e66c0-75b6-567e-9210-1368f0819bc1'::UUID, 'a19ca4f0-20bd-5c52-b5a3-3e7f20be1c00'::UUID, 'd27c66eb-abaf-5813-9b5b-c376f9adc9c7'::UUID, '9a50c365-adfa-5e09-bbe8-3d2d686ff948'::UUID, 'cfa8d5c1-69a4-5835-bcdb-3806a535faee'::UUID, 'c5a1f15c-92ba-5162-a222-71385ce39375'::UUID, '8e444465-71c6-54c5-ba0a-0a45d5c6fc03'::UUID, '8623f487-f5cf-586d-8dc3-337d322c4f0f'::UUID, '40b54661-bc27-5d77-82fd-2169a05cddd2'::UUID, '1a3869fb-135d-5b8a-9c5b-75e3c8b7a121'::UUID, 'de35bf1b-d098-5b8a-a49d-06e4bbfd5abe'::UUID, '4354e967-7601-510c-92d3-1b97397b2548'::UUID, 'fbc35034-8d8e-5169-acc8-a422710e1cfb'::UUID, '98846116-1b3c-5014-bfb4-a70f75569f11'::UUID, '75f516b8-acd6-543f-bb7c-40777988c30c'::UUID, '521d180a-bc5f-5e5b-ae84-7e5c4d1ce9c5'::UUID, 'ffcbae23-c081-583b-aa38-cc11fe1637bd'::UUID, '3bc15bf1-c8e6-526f-a814-e21fe9d1a349'::UUID, '7d5a6dbb-b3ea-547f-b39b-4ac40f3d0cff'::UUID, '853c605b-6efd-52ac-bf26-b34cb128dee2'::UUID, 'ff98833c-d382-59dd-80fe-a2ef0cf8081c'::UUID, 'd8b349e1-d598-5a45-b73a-166bb94461c8'::UUID, 'c7e2f40f-0ec5-59e1-a96f-e0ce46d0bb67'::UUID, '5e0f0a4a-d182-5723-910e-a5b7a1c49759'::UUID, 'd1e5029d-8b12-55ba-8533-f89233af1d37'::UUID, 'eb0e130e-d361-5203-be9e-7ee94583db0d'::UUID, '19baf5d3-7060-543d-bcdd-59f81ec301f7'::UUID, 'e376f949-77cd-51f7-94c3-3bbc0e7f49ef'::UUID, '43c0a9c8-a1ee-56dd-8322-df35c487f90f'::UUID, 'c4ae9407-28c7-5f7d-9328-6991b9d0597a'::UUID, 'e711cb00-0dbd-5995-972c-3fdd3149216f'::UUID, '10bef37a-4c6d-5a5f-8b5c-2e1506de2d85'::UUID, '54cd8dba-983a-5d83-9a26-f638f271a0c3'::UUID, 'cac28d01-e8f4-514c-9e4c-94e124f06bd4'::UUID, 'edef6942-4b5a-5952-94de-1b88f131c1dc'::UUID, '3e4ef3fc-16b5-5c97-a7d8-9d6252e00d04'::UUID, '64fdba98-3b9b-5cbb-8159-ec1434a777fd'::UUID, '1a4dcdbc-55ac-54c5-a666-6a600d33d286'::UUID, 'ba1bedb3-9a8b-5d87-8cb5-a33bf449db6f'::UUID, 'fdc13724-bce4-5dd3-8658-ee7c8b4b0d2e'::UUID, 'e0a053d7-6cf4-5702-8306-0e3760e63c0c'::UUID, 'c49d5400-491a-5447-b405-e874b69b89ce'::UUID, '51e59c0b-ad58-5e32-b598-9c0a90b7ff18'::UUID, '3541cdb5-16aa-5478-96a7-cf3360cadccc'::UUID, '5b742962-0719-5d1e-95ce-6b79761c562e'::UUID, '1e7092db-3e49-5f7b-8d9e-24519e08f62f'::UUID, '53a0c1d4-d2ec-591a-9890-a473e1432d95'::UUID, '4cc607fe-27d4-5cbc-ad3d-c46fea4c98d9'::UUID, '4940917c-c3a6-5366-8e97-140a9f02659b'::UUID, 'aad7e35b-8778-5bff-8afd-a1153ba12064'::UUID]::UUID[])
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
    WHERE link.lesson_id = ANY(ARRAY['cd97bc6a-cfbd-5e9e-a2a0-ec9aaf890232'::UUID, '9710f45f-7a87-55ee-b54e-856b955194aa'::UUID, 'c069c208-1e99-52b9-833c-67939fb1fb5d'::UUID, '9258d179-6e23-5c1d-a5d9-78f1614f899d'::UUID, 'b77fab37-7af9-5e46-b7f4-9cadce226a8a'::UUID, '9e581056-541a-564d-91ca-cd74373a20e1'::UUID, 'a34b965d-1f05-5ceb-a797-a3613c08ee88'::UUID, '880b7a2f-d83a-59f3-878b-f1f9a5ff385e'::UUID, '39bde3c1-9cfe-5b7b-9c15-d39dc0d2bc1c'::UUID]::UUID[])
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
