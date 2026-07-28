-- Generated from content/manifests/06_hsk5.json.
-- Do not hand-edit this migration; edit the manifest and regenerate.
-- Additive and idempotent: deterministic IDs plus ON CONFLICT DO NOTHING.

BEGIN;

INSERT INTO public.courses (id, slug, title, title_zh, description, level, status, order_index, learning_objectives, estimated_minutes, content_version)
VALUES ('caa02026-6a78-535a-9498-ce0a91bda3e4'::UUID, 'hsk-5', 'HSK 5', 'HSK 五级', 'Đọc và diễn đạt quan điểm ở mức thượng trung cấp.', 'upper-intermediate', 'review', 6, '["Hiểu văn bản lập luận","Dùng liên kết trang trọng","Diễn đạt sắc thái và đánh giá"]'::JSONB, 78, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.units (id, course_id, slug, title, description, order_index, status, learning_objectives, content_version)
VALUES ('e90d7faa-4bc7-5fd1-87c5-7c81cb9d4d7a'::UUID, 'caa02026-6a78-535a-9498-ce0a91bda3e4'::UUID, 'hsk5-nen-tang', 'Nền tảng', 'Xây dựng ngôn ngữ cốt lõi của lộ trình.', 1, 'review', '["Hiểu văn bản lập luận","Dùng liên kết trang trọng"]'::JSONB, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.chapters (id, unit_id, slug, title, description, order_index, status, learning_objectives, content_version)
VALUES ('fe2d6b00-150b-512d-9dff-dcd1980b6e6a'::UUID, 'e90d7faa-4bc7-5fd1-87c5-7c81cb9d4d7a'::UUID, 'hsk5-nen-tang-chapter', 'Khái niệm cốt lõi', 'Xây dựng ngôn ngữ cốt lõi của lộ trình.', 1, 'review', '["Hiểu văn bản lập luận","Dùng liên kết trang trọng"]'::JSONB, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lessons (id, chapter_id, slug, title, description, order_index, xp_reward, status, lesson_type, estimated_minutes, learning_objectives, cultural_note, content_version)
VALUES ('1b981463-0a1b-54bc-8467-1c3bd7e50bf5'::UUID, 'fe2d6b00-150b-512d-9dff-dcd1980b6e6a'::UUID, 'xu-huong', '随着社会发展 — Xu hướng', 'Mô tả thay đổi đồng thời theo bối cảnh.', 1, 25, 'review', 'standard', 15, '["Phân tích xu hướng"]'::JSONB, '随着 không trực tiếp biểu thị nguyên nhân tuyệt đối.', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('7e3eaf04-b076-5137-9b67-6e227c75d360'::UUID, 'hsk5:趋势', '趋势', 'qūshì', 'xu hướng', 'trend', 'upper-intermediate', 'xu-huong', 'danh từ', '这个行业的发展趋势很明显。', 'Zhège hángyè de fāzhǎn qūshì hěn míngxiǎn.', 'Xu hướng phát triển của ngành này rất rõ.', NULL, 'review', '1b981463-0a1b-54bc-8467-1c3bd7e50bf5'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('738f5508-4626-5559-a4d7-2ee92daa194e'::UUID, '1b981463-0a1b-54bc-8467-1c3bd7e50bf5'::UUID, '7e3eaf04-b076-5137-9b67-6e227c75d360'::UUID, 1, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('ba308b8a-ae69-5ac2-9bad-d37759aab8ac'::UUID, 'hsk5:逐渐', '逐渐', 'zhújiàn', 'dần dần', 'gradually', 'upper-intermediate', 'xu-huong', 'phó từ', '人们逐渐改变了消费习惯。', 'Rénmen zhújiàn gǎibiàn le xiāofèi xíguàn.', 'Mọi người dần thay đổi thói quen tiêu dùng.', NULL, 'review', '1b981463-0a1b-54bc-8467-1c3bd7e50bf5'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('c73a5073-66eb-5768-83b4-65f444f5378a'::UUID, '1b981463-0a1b-54bc-8467-1c3bd7e50bf5'::UUID, 'ba308b8a-ae69-5ac2-9bad-d37759aab8ac'::UUID, 2, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('ac5bf7fa-224a-5613-98e4-4d3bb7e24173'::UUID, 'hsk5:普遍', '普遍', 'pǔbiàn', 'phổ biến', 'widespread', 'upper-intermediate', 'xu-huong', 'tính từ', '移动支付已经十分普遍。', 'Yídòng zhīfù yǐjīng shífēn pǔbiàn.', 'Thanh toán di động đã rất phổ biến.', NULL, 'review', '1b981463-0a1b-54bc-8467-1c3bd7e50bf5'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('fd9e7807-1738-5c8c-a664-13637d1b3da2'::UUID, '1b981463-0a1b-54bc-8467-1c3bd7e50bf5'::UUID, 'ac5bf7fa-224a-5613-98e4-4d3bb7e24173'::UUID, 3, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.grammar_lessons (id, content_key, title, pattern, explanation, example_chinese, example_pinyin, example_meaning, level, status, usage_note, content_version)
VALUES ('2f709891-cc1e-5500-a7c7-c336cc89d226'::UUID, 'hsk5:xu-huong', 'Biến đổi theo bối cảnh', '随着 + danh từ/cụm động từ，mệnh đề thay đổi', '随着 giới thiệu quá trình làm nền cho một thay đổi khác.', '随着技术发展，生活逐渐更方便。', 'Suízhe jìshù fāzhǎn, shēnghuó zhújiàn gèng fāngbiàn.', 'Cùng với công nghệ phát triển, cuộc sống dần tiện hơn.', 'upper-intermediate', 'review', NULL, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_grammar (id, lesson_id, grammar_lesson_id, order_index, curriculum_role)
VALUES ('7d28bbe7-e87a-5334-836b-65fdf15ff337'::UUID, '1b981463-0a1b-54bc-8467-1c3bd7e50bf5'::UUID, '2f709891-cc1e-5500-a7c7-c336cc89d226'::UUID, 1, 'introduced')
ON CONFLICT (lesson_id, grammar_lesson_id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('67cb0df6-1c67-5897-8234-dd91c0cfb822'::UUID, '1b981463-0a1b-54bc-8467-1c3bd7e50bf5'::UUID, 'vocabulary', 1, 'Từ mới: 趋势', NULL, '趋势', '趋势 (qūshì) — xu hướng. 这个行业的发展趋势很明显。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"hsk5:趋势","chinese":"趋势","pinyin":"qūshì","meaning":"xu hướng","part_of_speech":"danh từ","example_chinese":"这个行业的发展趋势很明显。","example_pinyin":"Zhège hángyè de fāzhǎn qūshì hěn míngxiǎn.","example_meaning_vi":"Xu hướng phát triển của ngành này rất rõ."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('aee5bffb-1b2a-5f87-8141-2a3fbd5327b5'::UUID, '1b981463-0a1b-54bc-8467-1c3bd7e50bf5'::UUID, 'vocabulary', 2, 'Từ mới: 逐渐', NULL, '逐渐', '逐渐 (zhújiàn) — dần dần. 人们逐渐改变了消费习惯。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"hsk5:逐渐","chinese":"逐渐","pinyin":"zhújiàn","meaning":"dần dần","part_of_speech":"phó từ","example_chinese":"人们逐渐改变了消费习惯。","example_pinyin":"Rénmen zhújiàn gǎibiàn le xiāofèi xíguàn.","example_meaning_vi":"Mọi người dần thay đổi thói quen tiêu dùng."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('a6372bf1-4dac-553c-b6ac-3c64563ad2d0'::UUID, '1b981463-0a1b-54bc-8467-1c3bd7e50bf5'::UUID, 'vocabulary', 3, 'Từ mới: 普遍', NULL, '普遍', '普遍 (pǔbiàn) — phổ biến. 移动支付已经十分普遍。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"hsk5:普遍","chinese":"普遍","pinyin":"pǔbiàn","meaning":"phổ biến","part_of_speech":"tính từ","example_chinese":"移动支付已经十分普遍。","example_pinyin":"Yídòng zhīfù yǐjīng shífēn pǔbiàn.","example_meaning_vi":"Thanh toán di động đã rất phổ biến."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('cfdfc358-0222-54e9-a1e8-feea5ccbdb74'::UUID, '1b981463-0a1b-54bc-8467-1c3bd7e50bf5'::UUID, 'multiple_choice', 4, '“趋势” có nghĩa phù hợp nhất là gì?', NULL, 'xu hướng', '趋势 (qūshì) nghĩa là “xu hướng”.', NULL, 1, '{"activity_type":"chinese_to_vietnamese","vocabulary_key":"hsk5:趋势"}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('17787c07-8b03-5913-9c84-6c790ef81f82'::UUID, 'cfdfc358-0222-54e9-a1e8-feea5ccbdb74'::UUID, 'phổ biến', FALSE, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('e100e28a-8f79-5867-9ac7-e9c785c0e3f0'::UUID, 'cfdfc358-0222-54e9-a1e8-feea5ccbdb74'::UUID, 'xu hướng', TRUE, 2)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('9a3a7ff8-fc74-5aca-abfb-5aed00072bcb'::UUID, 'cfdfc358-0222-54e9-a1e8-feea5ccbdb74'::UUID, 'dần dần', FALSE, 3)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('9e6efcee-f745-595f-a960-9353a0e32c7e'::UUID, '1b981463-0a1b-54bc-8467-1c3bd7e50bf5'::UUID, 'translation', 5, 'Dịch sang tiếng Trung: “Cùng với công nghệ phát triển, cuộc sống dần tiện hơn.”', NULL, '随着技术发展，生活逐渐更方便。', 'Mẫu câu dùng “趋势” trong ngữ cảnh của bài.', 'qūshì', 1, '{"activity_type":"vietnamese_to_chinese","source_lang":"vi","target_lang":"zh","acceptable_answers":["随着技术发展，生活逐渐更方便。"]}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('71e32731-b3f5-5967-b555-dd102c2c036e'::UUID, '1b981463-0a1b-54bc-8467-1c3bd7e50bf5'::UUID, 'sentence_builder', 6, 'Sắp xếp các thành phần thành câu đúng.', NULL, '随着技术发展，生活逐渐更方便。', 'Trật tự đúng tạo thành câu “随着技术发展，生活逐渐更方便。”.', NULL, 1, '{"activity_type":"sentence_ordering","words":["随着","技术","发展","，","生活","逐渐","更","方便","。"],"correct_order":["随着","技术","发展","，","生活","逐渐","更","方便","。"]}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('c664438b-ce7c-5b20-94b9-e6e052ec4de5'::UUID, '1b981463-0a1b-54bc-8467-1c3bd7e50bf5'::UUID, 'multiple_choice', 7, 'Câu nào mô tả xu hướng đồng thời?', NULL, '随着技术发展，生活逐渐更方便。', '随着 giới thiệu quá trình làm nền cho một thay đổi khác.', NULL, 1, '{"activity_type":"grammar_selection","passage":null,"grammar_key":"hsk5:xu-huong"}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('5d8b746b-f36f-5be2-9800-823b7d187b90'::UUID, 'c664438b-ce7c-5b20-94b9-e6e052ec4de5'::UUID, '随着技术发展，生活逐渐更方便。', TRUE, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('5dd996fa-6722-55cb-9c56-09adce4bd94f'::UUID, 'c664438b-ce7c-5b20-94b9-e6e052ec4de5'::UUID, '。方便更逐渐生活，发展技术随着', FALSE, 2)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('2820f2d7-726b-5a09-8e94-a7dbab0fe24d'::UUID, 'c664438b-ce7c-5b20-94b9-e6e052ec4de5'::UUID, '技术发展，生活逐渐更方便。随着', FALSE, 3)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('403c6f16-1b43-5a16-9a4a-8326ed98402a'::UUID, '1b981463-0a1b-54bc-8467-1c3bd7e50bf5'::UUID, 'speaking', 8, 'Đọc thành tiếng: 随着技术发展，生活逐渐更方便。', NULL, '随着技术发展，生活逐渐更方便。', 'Đọc chậm, giữ đúng thanh điệu và nhịp của cả câu.', NULL, 1, '{"activity_type":"pronunciation","text":"随着技术发展，生活逐渐更方便。","pinyin":"Suízhe jìshù fāzhǎn, shēnghuó zhújiàn gèng fāngbiàn."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lessons (id, chapter_id, slug, title, description, order_index, xp_reward, status, lesson_type, estimated_minutes, learning_objectives, cultural_note, content_version)
VALUES ('b68af30b-2251-5917-bddc-2bea4d849383'::UUID, 'fe2d6b00-150b-512d-9dff-dcd1980b6e6a'::UUID, 'nhuong-bo', '尽管…仍然… — Nhượng bộ', 'Đối chiếu thực tế với kết quả không đổi.', 2, 25, 'review', 'standard', 15, '["Diễn đạt tương phản có sắc thái"]'::JSONB, '还是 thường khẩu ngữ hơn; 仍然 phù hợp văn viết.', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('bc234740-d1f5-547a-b78f-c596a35ac68a'::UUID, 'hsk5:尽管', '尽管', 'jǐnguǎn', 'mặc dù', 'although', 'upper-intermediate', 'nhuong-bo', 'liên từ', '尽管很累，他还是继续工作。', 'Jǐnguǎn hěn lèi, tā háishi jìxù gōngzuò.', 'Mặc dù rất mệt, anh ấy vẫn tiếp tục làm việc.', NULL, 'review', 'b68af30b-2251-5917-bddc-2bea4d849383'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('594eb13a-3f30-5d23-8d63-8f4deb95d538'::UUID, 'b68af30b-2251-5917-bddc-2bea4d849383'::UUID, 'bc234740-d1f5-547a-b78f-c596a35ac68a'::UUID, 1, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('eba0e265-5bb1-59d0-84e6-3728e862ee34'::UUID, 'hsk5:仍然', '仍然', 'réngrán', 'vẫn', 'still', 'upper-intermediate', 'nhuong-bo', 'phó từ', '天气很冷，比赛仍然进行。', 'Tiānqì hěn lěng, bǐsài réngrán jìnxíng.', 'Trời rất lạnh, trận đấu vẫn diễn ra.', NULL, 'review', 'b68af30b-2251-5917-bddc-2bea4d849383'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('ecf1893d-7ab6-5948-a4e5-dd16dd1da2cc'::UUID, 'b68af30b-2251-5917-bddc-2bea4d849383'::UUID, 'eba0e265-5bb1-59d0-84e6-3728e862ee34'::UUID, 2, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('2ae291c3-155d-509a-85fc-969d9b19b501'::UUID, 'hsk5:克服', '克服', 'kèfú', 'khắc phục', 'overcome', 'upper-intermediate', 'nhuong-bo', 'động từ', '我们一起克服了困难。', 'Wǒmen yìqǐ kèfú le kùnnan.', 'Chúng tôi cùng nhau khắc phục khó khăn.', NULL, 'review', 'b68af30b-2251-5917-bddc-2bea4d849383'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('c015d992-c20a-521f-943d-e4a80b5fef9d'::UUID, 'b68af30b-2251-5917-bddc-2bea4d849383'::UUID, '2ae291c3-155d-509a-85fc-969d9b19b501'::UUID, 3, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('fe24eb15-5bbb-5d31-889a-852a33002c50'::UUID, 'b68af30b-2251-5917-bddc-2bea4d849383'::UUID, '7e3eaf04-b076-5137-9b67-6e227c75d360'::UUID, 4, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('48d56b81-5cad-5a8a-b9bf-ef4536118083'::UUID, 'b68af30b-2251-5917-bddc-2bea4d849383'::UUID, 'ba308b8a-ae69-5ac2-9bad-d37759aab8ac'::UUID, 5, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('d2b226a6-8fd6-50cc-a19c-d50a96c12a79'::UUID, 'b68af30b-2251-5917-bddc-2bea4d849383'::UUID, 'ac5bf7fa-224a-5613-98e4-4d3bb7e24173'::UUID, 6, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.grammar_lessons (id, content_key, title, pattern, explanation, example_chinese, example_pinyin, example_meaning, level, status, usage_note, content_version)
VALUES ('739787e6-a7f7-5a13-b1da-405cf9e8cdbf'::UUID, 'hsk5:nhuong-bo', 'Nhượng bộ trang trọng', '尽管 A，仍然 B', 'Kết quả B vẫn tồn tại dù có trở ngại A.', '尽管遇到困难，他仍然没有放弃。', 'Jǐnguǎn yùdào kùnnan, tā réngrán méiyǒu fàngqì.', 'Mặc dù gặp khó khăn, anh ấy vẫn không từ bỏ.', 'upper-intermediate', 'review', NULL, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_grammar (id, lesson_id, grammar_lesson_id, order_index, curriculum_role)
VALUES ('110b3968-aaa2-5330-9e99-89eec1ab10e0'::UUID, 'b68af30b-2251-5917-bddc-2bea4d849383'::UUID, '739787e6-a7f7-5a13-b1da-405cf9e8cdbf'::UUID, 1, 'introduced')
ON CONFLICT (lesson_id, grammar_lesson_id) DO NOTHING;

INSERT INTO public.lesson_grammar (id, lesson_id, grammar_lesson_id, order_index, curriculum_role)
VALUES ('f8878691-d9d4-560d-a004-cda26befa040'::UUID, 'b68af30b-2251-5917-bddc-2bea4d849383'::UUID, '2f709891-cc1e-5500-a7c7-c336cc89d226'::UUID, 2, 'review')
ON CONFLICT (lesson_id, grammar_lesson_id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('50378819-f196-59e6-96ef-8d9539f4663f'::UUID, 'b68af30b-2251-5917-bddc-2bea4d849383'::UUID, 'vocabulary', 1, 'Từ mới: 尽管', NULL, '尽管', '尽管 (jǐnguǎn) — mặc dù. 尽管很累，他还是继续工作。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"hsk5:尽管","chinese":"尽管","pinyin":"jǐnguǎn","meaning":"mặc dù","part_of_speech":"liên từ","example_chinese":"尽管很累，他还是继续工作。","example_pinyin":"Jǐnguǎn hěn lèi, tā háishi jìxù gōngzuò.","example_meaning_vi":"Mặc dù rất mệt, anh ấy vẫn tiếp tục làm việc."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('3a38b341-f811-50fb-89ea-4d10adf49739'::UUID, 'b68af30b-2251-5917-bddc-2bea4d849383'::UUID, 'vocabulary', 2, 'Từ mới: 仍然', NULL, '仍然', '仍然 (réngrán) — vẫn. 天气很冷，比赛仍然进行。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"hsk5:仍然","chinese":"仍然","pinyin":"réngrán","meaning":"vẫn","part_of_speech":"phó từ","example_chinese":"天气很冷，比赛仍然进行。","example_pinyin":"Tiānqì hěn lěng, bǐsài réngrán jìnxíng.","example_meaning_vi":"Trời rất lạnh, trận đấu vẫn diễn ra."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('254ff0b0-9a7a-51ef-8826-6fb1f75cc3df'::UUID, 'b68af30b-2251-5917-bddc-2bea4d849383'::UUID, 'vocabulary', 3, 'Từ mới: 克服', NULL, '克服', '克服 (kèfú) — khắc phục. 我们一起克服了困难。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"hsk5:克服","chinese":"克服","pinyin":"kèfú","meaning":"khắc phục","part_of_speech":"động từ","example_chinese":"我们一起克服了困难。","example_pinyin":"Wǒmen yìqǐ kèfú le kùnnan.","example_meaning_vi":"Chúng tôi cùng nhau khắc phục khó khăn."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('8365c50c-de64-5ce0-a87c-94aae7730035'::UUID, 'b68af30b-2251-5917-bddc-2bea4d849383'::UUID, 'multiple_choice', 4, '“尽管” có nghĩa phù hợp nhất là gì?', NULL, 'mặc dù', '尽管 (jǐnguǎn) nghĩa là “mặc dù”.', NULL, 1, '{"activity_type":"chinese_to_vietnamese","vocabulary_key":"hsk5:尽管"}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('8d663b0e-960c-5d2d-b7e0-1c98a5b433cd'::UUID, '8365c50c-de64-5ce0-a87c-94aae7730035'::UUID, 'khắc phục', FALSE, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('40955861-5aff-54c4-a02a-22161b098b65'::UUID, '8365c50c-de64-5ce0-a87c-94aae7730035'::UUID, 'mặc dù', TRUE, 2)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('1494bc4f-923e-5757-ba01-546e0037fbb0'::UUID, '8365c50c-de64-5ce0-a87c-94aae7730035'::UUID, 'vẫn', FALSE, 3)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('3c4c0acf-57f3-50ec-a9fd-4252483f3ee7'::UUID, 'b68af30b-2251-5917-bddc-2bea4d849383'::UUID, 'translation', 5, 'Dịch sang tiếng Trung: “Mặc dù gặp khó khăn, anh ấy vẫn không từ bỏ.”', NULL, '尽管遇到困难，他仍然没有放弃。', 'Mẫu câu dùng “尽管” trong ngữ cảnh của bài.', 'jǐnguǎn', 1, '{"activity_type":"vietnamese_to_chinese","source_lang":"vi","target_lang":"zh","acceptable_answers":["尽管遇到困难，他仍然没有放弃。"]}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('60b3580b-01d5-5f22-91a1-c9e75c715516'::UUID, 'b68af30b-2251-5917-bddc-2bea4d849383'::UUID, 'sentence_builder', 6, 'Sắp xếp các thành phần thành câu đúng.', NULL, '尽管遇到困难，他仍然没有放弃。', 'Trật tự đúng tạo thành câu “尽管遇到困难，他仍然没有放弃。”.', NULL, 1, '{"activity_type":"sentence_ordering","words":["尽管","遇到","困难","，","他","仍然","没有","放弃","。"],"correct_order":["尽管","遇到","困难","，","他","仍然","没有","放弃","。"]}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('3e922562-aae8-5559-b312-0318e303ec30'::UUID, 'b68af30b-2251-5917-bddc-2bea4d849383'::UUID, 'multiple_choice', 7, 'Câu nào thể hiện quan hệ nhượng bộ?', NULL, '尽管遇到困难，他仍然没有放弃。', 'Kết quả B vẫn tồn tại dù có trở ngại A.', NULL, 1, '{"activity_type":"grammar_selection","passage":null,"grammar_key":"hsk5:nhuong-bo"}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('c0df70a1-ddbb-5bfc-a820-bd8ec8707785'::UUID, '3e922562-aae8-5559-b312-0318e303ec30'::UUID, '尽管遇到困难，他仍然没有放弃。', TRUE, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('4416edc0-2570-56fe-840f-3b2e7ca129bf'::UUID, '3e922562-aae8-5559-b312-0318e303ec30'::UUID, '。放弃没有仍然他，困难遇到尽管', FALSE, 2)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('bbbe6ecf-c985-51d9-b0de-8b7185e1b902'::UUID, '3e922562-aae8-5559-b312-0318e303ec30'::UUID, '遇到困难，他仍然没有放弃。尽管', FALSE, 3)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('3a2a2241-9824-5804-890e-1e1d39b73587'::UUID, 'b68af30b-2251-5917-bddc-2bea4d849383'::UUID, 'speaking', 8, 'Đọc thành tiếng: 尽管遇到困难，他仍然没有放弃。', NULL, '尽管遇到困难，他仍然没有放弃。', 'Đọc chậm, giữ đúng thanh điệu và nhịp của cả câu.', NULL, 1, '{"activity_type":"pronunciation","text":"尽管遇到困难，他仍然没有放弃。","pinyin":"Jǐnguǎn yùdào kùnnan, tā réngrán méiyǒu fàngqì."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.units (id, course_id, slug, title, description, order_index, status, learning_objectives, content_version)
VALUES ('01208325-66c6-54e5-bbcb-9e3d5e9bc6bf'::UUID, 'caa02026-6a78-535a-9498-ce0a91bda3e4'::UUID, 'hsk5-van-dung', 'Vận dụng', 'Vận dụng mẫu câu trong ngữ cảnh có ý nghĩa.', 2, 'review', '["Dùng liên kết trang trọng","Diễn đạt sắc thái và đánh giá"]'::JSONB, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.chapters (id, unit_id, slug, title, description, order_index, status, learning_objectives, content_version)
VALUES ('88e6d5e2-cf15-5db2-972b-aa88164e1e4f'::UUID, '01208325-66c6-54e5-bbcb-9e3d5e9bc6bf'::UUID, 'hsk5-van-dung-chapter', 'Ngữ cảnh thực tế', 'Vận dụng mẫu câu trong ngữ cảnh có ý nghĩa.', 1, 'review', '["Dùng liên kết trang trọng","Diễn đạt sắc thái và đánh giá"]'::JSONB, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lessons (id, chapter_id, slug, title, description, order_index, xp_reward, status, lesson_type, estimated_minutes, learning_objectives, cultural_note, content_version)
VALUES ('40f6f2a4-0d26-5c44-aa75-bc09f1c9600f'::UUID, '88e6d5e2-cf15-5db2-972b-aa88164e1e4f'::UUID, 'danh-gia', '未必如此 — Đánh giá thận trọng', 'Giảm mức khẳng định trong nhận xét.', 1, 25, 'review', 'standard', 15, '["Nêu đánh giá có giới hạn"]'::JSONB, '未必 khác 不: nó để ngỏ khả năng đúng.', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('855e24e7-d343-58c1-a9b0-52074cc8b389'::UUID, 'hsk5:未必', '未必', 'wèibì', 'chưa chắc', 'not necessarily', 'upper-intermediate', 'danh-gia', 'phó từ', '价格高的产品未必最好。', 'Jiàgé gāo de chǎnpǐn wèibì zuì hǎo.', 'Sản phẩm giá cao chưa chắc tốt nhất.', NULL, 'review', '40f6f2a4-0d26-5c44-aa75-bc09f1c9600f'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('fcacc4cb-165f-5141-b54f-889234c101df'::UUID, '40f6f2a4-0d26-5c44-aa75-bc09f1c9600f'::UUID, '855e24e7-d343-58c1-a9b0-52074cc8b389'::UUID, 1, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('e091a360-387e-55cd-bfa1-ffd0e7e27fc1'::UUID, 'hsk5:合理', '合理', 'hélǐ', 'hợp lý', 'reasonable', 'upper-intermediate', 'danh-gia', 'tính từ', '这个安排比较合理。', 'Zhège ānpái bǐjiào hélǐ.', 'Sự sắp xếp này khá hợp lý.', NULL, 'review', '40f6f2a4-0d26-5c44-aa75-bc09f1c9600f'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('4c27a94e-c8b9-5aa9-ae65-aef0f31525bc'::UUID, '40f6f2a4-0d26-5c44-aa75-bc09f1c9600f'::UUID, 'e091a360-387e-55cd-bfa1-ffd0e7e27fc1'::UUID, 2, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('1eb72d6d-b5ce-52ca-8b58-b4aea5b60a34'::UUID, 'hsk5:判断', '判断', 'pànduàn', 'phán đoán', 'judge; judgment', 'upper-intermediate', 'danh-gia', 'động từ/danh từ', '不要只根据外表判断一个人。', 'Búyào zhǐ gēnjù wàibiǎo pànduàn yí ge rén.', 'Đừng chỉ dựa vào vẻ ngoài để đánh giá một người.', NULL, 'review', '40f6f2a4-0d26-5c44-aa75-bc09f1c9600f'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('c52616a4-4789-5e26-858d-8f265b5e6569'::UUID, '40f6f2a4-0d26-5c44-aa75-bc09f1c9600f'::UUID, '1eb72d6d-b5ce-52ca-8b58-b4aea5b60a34'::UUID, 3, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('75a99360-9ee8-57e3-9440-b45a482b8bcf'::UUID, '40f6f2a4-0d26-5c44-aa75-bc09f1c9600f'::UUID, 'bc234740-d1f5-547a-b78f-c596a35ac68a'::UUID, 4, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('4605f5ba-d2e9-5185-8901-4cfb124ef924'::UUID, '40f6f2a4-0d26-5c44-aa75-bc09f1c9600f'::UUID, 'eba0e265-5bb1-59d0-84e6-3728e862ee34'::UUID, 5, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('8f6b6869-6337-53cd-9b1e-e8bf85819c56'::UUID, '40f6f2a4-0d26-5c44-aa75-bc09f1c9600f'::UUID, '2ae291c3-155d-509a-85fc-969d9b19b501'::UUID, 6, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.grammar_lessons (id, content_key, title, pattern, explanation, example_chinese, example_pinyin, example_meaning, level, status, usage_note, content_version)
VALUES ('8b4170e7-1f0a-5d75-bdbf-0598a9ef6db6'::UUID, 'hsk5:danh-gia', 'Phủ định khả năng với 未必', 'chủ ngữ + 未必 + vị ngữ', '未必 bác bỏ suy luận tất yếu nhưng không phủ định hoàn toàn.', '看起来简单，做起来未必容易。', 'Kànqilai jiǎndān, zuòqilai wèibì róngyì.', 'Nhìn có vẻ đơn giản nhưng làm chưa chắc dễ.', 'upper-intermediate', 'review', NULL, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_grammar (id, lesson_id, grammar_lesson_id, order_index, curriculum_role)
VALUES ('2c50136f-2f2c-5796-84de-4bc512569683'::UUID, '40f6f2a4-0d26-5c44-aa75-bc09f1c9600f'::UUID, '8b4170e7-1f0a-5d75-bdbf-0598a9ef6db6'::UUID, 1, 'introduced')
ON CONFLICT (lesson_id, grammar_lesson_id) DO NOTHING;

INSERT INTO public.lesson_grammar (id, lesson_id, grammar_lesson_id, order_index, curriculum_role)
VALUES ('9c6b0de2-419e-5169-8f3b-199f80747824'::UUID, '40f6f2a4-0d26-5c44-aa75-bc09f1c9600f'::UUID, '739787e6-a7f7-5a13-b1da-405cf9e8cdbf'::UUID, 2, 'review')
ON CONFLICT (lesson_id, grammar_lesson_id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('f7481bc8-79dd-5e37-b46b-813ca533db37'::UUID, '40f6f2a4-0d26-5c44-aa75-bc09f1c9600f'::UUID, 'vocabulary', 1, 'Từ mới: 未必', NULL, '未必', '未必 (wèibì) — chưa chắc. 价格高的产品未必最好。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"hsk5:未必","chinese":"未必","pinyin":"wèibì","meaning":"chưa chắc","part_of_speech":"phó từ","example_chinese":"价格高的产品未必最好。","example_pinyin":"Jiàgé gāo de chǎnpǐn wèibì zuì hǎo.","example_meaning_vi":"Sản phẩm giá cao chưa chắc tốt nhất."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('f2af9417-8fbb-5b3e-ba96-afc43d34043d'::UUID, '40f6f2a4-0d26-5c44-aa75-bc09f1c9600f'::UUID, 'vocabulary', 2, 'Từ mới: 合理', NULL, '合理', '合理 (hélǐ) — hợp lý. 这个安排比较合理。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"hsk5:合理","chinese":"合理","pinyin":"hélǐ","meaning":"hợp lý","part_of_speech":"tính từ","example_chinese":"这个安排比较合理。","example_pinyin":"Zhège ānpái bǐjiào hélǐ.","example_meaning_vi":"Sự sắp xếp này khá hợp lý."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('58647351-1d1a-5c59-94aa-ee77c87ddd39'::UUID, '40f6f2a4-0d26-5c44-aa75-bc09f1c9600f'::UUID, 'vocabulary', 3, 'Từ mới: 判断', NULL, '判断', '判断 (pànduàn) — phán đoán. 不要只根据外表判断一个人。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"hsk5:判断","chinese":"判断","pinyin":"pànduàn","meaning":"phán đoán","part_of_speech":"động từ/danh từ","example_chinese":"不要只根据外表判断一个人。","example_pinyin":"Búyào zhǐ gēnjù wàibiǎo pànduàn yí ge rén.","example_meaning_vi":"Đừng chỉ dựa vào vẻ ngoài để đánh giá một người."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('c1fc21b8-e9dc-501a-85f6-f6665367af2f'::UUID, '40f6f2a4-0d26-5c44-aa75-bc09f1c9600f'::UUID, 'multiple_choice', 4, '“未必” có nghĩa phù hợp nhất là gì?', NULL, 'chưa chắc', '未必 (wèibì) nghĩa là “chưa chắc”.', NULL, 1, '{"activity_type":"chinese_to_vietnamese","vocabulary_key":"hsk5:未必"}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('988cf421-e5ae-57e7-be69-cb0b4ed1c6fc'::UUID, 'c1fc21b8-e9dc-501a-85f6-f6665367af2f'::UUID, 'phán đoán', FALSE, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('a42c6e2e-db49-5894-9b00-6034c2e793f0'::UUID, 'c1fc21b8-e9dc-501a-85f6-f6665367af2f'::UUID, 'chưa chắc', TRUE, 2)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('d6fa287d-98de-52ef-9d04-f334a3ee6677'::UUID, 'c1fc21b8-e9dc-501a-85f6-f6665367af2f'::UUID, 'hợp lý', FALSE, 3)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('91ca6838-b249-5221-8950-f1ea57c94466'::UUID, '40f6f2a4-0d26-5c44-aa75-bc09f1c9600f'::UUID, 'translation', 5, 'Dịch sang tiếng Trung: “Nhìn có vẻ đơn giản nhưng làm chưa chắc dễ.”', NULL, '看起来简单，做起来未必容易。', 'Mẫu câu dùng “未必” trong ngữ cảnh của bài.', 'wèibì', 1, '{"activity_type":"vietnamese_to_chinese","source_lang":"vi","target_lang":"zh","acceptable_answers":["看起来简单，做起来未必容易。"]}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('ed5485d2-250d-57da-9b6f-500226665ca7'::UUID, '40f6f2a4-0d26-5c44-aa75-bc09f1c9600f'::UUID, 'sentence_builder', 6, 'Sắp xếp các thành phần thành câu đúng.', NULL, '看起来简单，做起来未必容易。', 'Trật tự đúng tạo thành câu “看起来简单，做起来未必容易。”.', NULL, 1, '{"activity_type":"sentence_ordering","words":["看起来","简单","，","做起来","未必","容易","。"],"correct_order":["看起来","简单","，","做起来","未必","容易","。"]}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('f958dc45-672e-5616-b584-00d5fc0b7046'::UUID, '40f6f2a4-0d26-5c44-aa75-bc09f1c9600f'::UUID, 'multiple_choice', 7, 'Câu nào đưa ra đánh giá thận trọng?', NULL, '看起来简单，做起来未必容易。', '未必 bác bỏ suy luận tất yếu nhưng không phủ định hoàn toàn.', NULL, 1, '{"activity_type":"grammar_selection","passage":null,"grammar_key":"hsk5:danh-gia"}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('8718b059-7d1f-5251-8d3c-4fef249fdadc'::UUID, 'f958dc45-672e-5616-b584-00d5fc0b7046'::UUID, '看起来简单，做起来未必容易。', TRUE, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('c586ab82-9e8d-5377-9c51-a6aa32a7c082'::UUID, 'f958dc45-672e-5616-b584-00d5fc0b7046'::UUID, '。容易未必做起来，简单看起来', FALSE, 2)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('0db01185-3d28-5d86-a705-646243736d6d'::UUID, 'f958dc45-672e-5616-b584-00d5fc0b7046'::UUID, '简单，做起来未必容易。看起来', FALSE, 3)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('dc15c6f4-d730-52e3-a23c-261d1a6d94da'::UUID, '40f6f2a4-0d26-5c44-aa75-bc09f1c9600f'::UUID, 'speaking', 8, 'Đọc thành tiếng: 看起来简单，做起来未必容易。', NULL, '看起来简单，做起来未必容易。', 'Đọc chậm, giữ đúng thanh điệu và nhịp của cả câu.', NULL, 1, '{"activity_type":"pronunciation","text":"看起来简单，做起来未必容易。","pinyin":"Kànqilai jiǎndān, zuòqilai wèibì róngyì."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lessons (id, chapter_id, slug, title, description, order_index, xp_reward, status, lesson_type, estimated_minutes, learning_objectives, cultural_note, content_version)
VALUES ('e2dab045-5b07-5445-948a-e911a40e0764'::UUID, '88e6d5e2-cf15-5db2-972b-aa88164e1e4f'::UUID, 'van-viet', '由此可见 — Kết luận văn viết', 'Dẫn ra kết luận từ bằng chứng trước đó.', 2, 25, 'review', 'standard', 15, '["Viết đoạn kết luận mạch lạc"]'::JSONB, 'Cần có dữ kiện trước 由此可见, không dùng như ý kiến vô căn cứ.', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('7db38f0d-b462-5d89-8780-05d05783a961'::UUID, 'hsk5:证据', '证据', 'zhèngjù', 'chứng cứ', 'evidence', 'upper-intermediate', 'van-viet', 'danh từ', '目前还没有足够的证据。', 'Mùqián hái méiyǒu zúgòu de zhèngjù.', 'Hiện vẫn chưa có đủ bằng chứng.', NULL, 'review', 'e2dab045-5b07-5445-948a-e911a40e0764'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('a4cfe410-f56d-583e-b6ac-49aa146fac24'::UUID, 'e2dab045-5b07-5445-948a-e911a40e0764'::UUID, '7db38f0d-b462-5d89-8780-05d05783a961'::UUID, 1, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('d378fb10-c9ca-5fde-a1a5-a04cf734b44d'::UUID, 'hsk5:结论', '结论', 'jiélùn', 'kết luận', 'conclusion', 'upper-intermediate', 'van-viet', 'danh từ', '现在下结论还太早。', 'Xiànzài xià jiélùn hái tài zǎo.', 'Bây giờ đưa ra kết luận còn quá sớm.', NULL, 'review', 'e2dab045-5b07-5445-948a-e911a40e0764'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('ee900218-d713-587c-86da-64cc98fdba84'::UUID, 'e2dab045-5b07-5445-948a-e911a40e0764'::UUID, 'd378fb10-c9ca-5fde-a1a5-a04cf734b44d'::UUID, 2, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('dc71b55d-3691-5be7-ad84-ab47093ba178'::UUID, 'hsk5:表明', '表明', 'biǎomíng', 'cho thấy', 'indicate', 'upper-intermediate', 'van-viet', 'động từ', '调查结果表明情况有所改善。', 'Diàochá jiéguǒ biǎomíng qíngkuàng yǒusuǒ gǎishàn.', 'Kết quả khảo sát cho thấy tình hình đã cải thiện.', NULL, 'review', 'e2dab045-5b07-5445-948a-e911a40e0764'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('a5f677dd-42a4-51c7-b617-f316199b0401'::UUID, 'e2dab045-5b07-5445-948a-e911a40e0764'::UUID, 'dc71b55d-3691-5be7-ad84-ab47093ba178'::UUID, 3, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('7919934e-0f91-5823-b89b-13e034e2b660'::UUID, 'e2dab045-5b07-5445-948a-e911a40e0764'::UUID, '855e24e7-d343-58c1-a9b0-52074cc8b389'::UUID, 4, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('381b7515-d421-58de-a8d1-b5923fcce90f'::UUID, 'e2dab045-5b07-5445-948a-e911a40e0764'::UUID, 'e091a360-387e-55cd-bfa1-ffd0e7e27fc1'::UUID, 5, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('2cb93af9-b9b2-56cf-9435-ddc517a501df'::UUID, 'e2dab045-5b07-5445-948a-e911a40e0764'::UUID, '1eb72d6d-b5ce-52ca-8b58-b4aea5b60a34'::UUID, 6, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.grammar_lessons (id, content_key, title, pattern, explanation, example_chinese, example_pinyin, example_meaning, level, status, usage_note, content_version)
VALUES ('86b5c36a-98f5-55dc-8453-aeedc9f4f29f'::UUID, 'hsk5:van-viet', 'Dẫn kết luận với 由此可见', 'bằng chứng。由此可见，kết luận', '由此可见 đánh dấu kết luận logic trong văn viết.', '数据持续上升，由此可见需求正在增加。', 'Shùjù chíxù shàngshēng, yóucǐ kějiàn xūqiú zhèngzài zēngjiā.', 'Dữ liệu liên tục tăng; từ đó có thể thấy nhu cầu đang tăng.', 'upper-intermediate', 'review', NULL, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_grammar (id, lesson_id, grammar_lesson_id, order_index, curriculum_role)
VALUES ('92f4fe04-7d4f-5d7a-9cd6-9928e2ea5753'::UUID, 'e2dab045-5b07-5445-948a-e911a40e0764'::UUID, '86b5c36a-98f5-55dc-8453-aeedc9f4f29f'::UUID, 1, 'introduced')
ON CONFLICT (lesson_id, grammar_lesson_id) DO NOTHING;

INSERT INTO public.lesson_grammar (id, lesson_id, grammar_lesson_id, order_index, curriculum_role)
VALUES ('fcf19b76-12e8-5e0d-9d8e-d4557621557d'::UUID, 'e2dab045-5b07-5445-948a-e911a40e0764'::UUID, '8b4170e7-1f0a-5d75-bdbf-0598a9ef6db6'::UUID, 2, 'review')
ON CONFLICT (lesson_id, grammar_lesson_id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('b3cbf283-32d7-5082-8a1f-8cce513b74b6'::UUID, 'e2dab045-5b07-5445-948a-e911a40e0764'::UUID, 'vocabulary', 1, 'Từ mới: 证据', NULL, '证据', '证据 (zhèngjù) — chứng cứ. 目前还没有足够的证据。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"hsk5:证据","chinese":"证据","pinyin":"zhèngjù","meaning":"chứng cứ","part_of_speech":"danh từ","example_chinese":"目前还没有足够的证据。","example_pinyin":"Mùqián hái méiyǒu zúgòu de zhèngjù.","example_meaning_vi":"Hiện vẫn chưa có đủ bằng chứng."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('ff089b1a-85e0-5325-8902-21cf316af1a0'::UUID, 'e2dab045-5b07-5445-948a-e911a40e0764'::UUID, 'vocabulary', 2, 'Từ mới: 结论', NULL, '结论', '结论 (jiélùn) — kết luận. 现在下结论还太早。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"hsk5:结论","chinese":"结论","pinyin":"jiélùn","meaning":"kết luận","part_of_speech":"danh từ","example_chinese":"现在下结论还太早。","example_pinyin":"Xiànzài xià jiélùn hái tài zǎo.","example_meaning_vi":"Bây giờ đưa ra kết luận còn quá sớm."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('30185c45-837e-5c52-82ee-af6b0a08826a'::UUID, 'e2dab045-5b07-5445-948a-e911a40e0764'::UUID, 'vocabulary', 3, 'Từ mới: 表明', NULL, '表明', '表明 (biǎomíng) — cho thấy. 调查结果表明情况有所改善。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"hsk5:表明","chinese":"表明","pinyin":"biǎomíng","meaning":"cho thấy","part_of_speech":"động từ","example_chinese":"调查结果表明情况有所改善。","example_pinyin":"Diàochá jiéguǒ biǎomíng qíngkuàng yǒusuǒ gǎishàn.","example_meaning_vi":"Kết quả khảo sát cho thấy tình hình đã cải thiện."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('882aa697-1840-5363-818c-7eac6777a127'::UUID, 'e2dab045-5b07-5445-948a-e911a40e0764'::UUID, 'multiple_choice', 4, '“证据” có nghĩa phù hợp nhất là gì?', NULL, 'chứng cứ', '证据 (zhèngjù) nghĩa là “chứng cứ”.', NULL, 1, '{"activity_type":"chinese_to_vietnamese","vocabulary_key":"hsk5:证据"}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('0a72754d-cfb0-5ae4-a14c-efa022282de0'::UUID, '882aa697-1840-5363-818c-7eac6777a127'::UUID, 'cho thấy', FALSE, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('551e4f09-5475-5f77-9281-5bb85d8a2701'::UUID, '882aa697-1840-5363-818c-7eac6777a127'::UUID, 'chứng cứ', TRUE, 2)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('ed4f680f-46cc-57b5-8591-48da377d96df'::UUID, '882aa697-1840-5363-818c-7eac6777a127'::UUID, 'kết luận', FALSE, 3)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('bb2e986c-e389-5fb2-b64d-80c00eaa5fa3'::UUID, 'e2dab045-5b07-5445-948a-e911a40e0764'::UUID, 'translation', 5, 'Dịch sang tiếng Trung: “Dữ liệu liên tục tăng; từ đó có thể thấy nhu cầu đang tăng.”', NULL, '数据持续上升，由此可见需求正在增加。', 'Mẫu câu dùng “证据” trong ngữ cảnh của bài.', 'zhèngjù', 1, '{"activity_type":"vietnamese_to_chinese","source_lang":"vi","target_lang":"zh","acceptable_answers":["数据持续上升，由此可见需求正在增加。"]}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('88d90c12-6c44-5790-815c-4a1bd61b3281'::UUID, 'e2dab045-5b07-5445-948a-e911a40e0764'::UUID, 'sentence_builder', 6, 'Sắp xếp các thành phần thành câu đúng.', NULL, '数据持续上升，由此可见需求正在增加。', 'Trật tự đúng tạo thành câu “数据持续上升，由此可见需求正在增加。”.', NULL, 1, '{"activity_type":"sentence_ordering","words":["数据","持续","上升","，","由此可见","需求","正在","增加","。"],"correct_order":["数据","持续","上升","，","由此可见","需求","正在","增加","。"]}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('f8c073ad-4a40-503d-899f-075707135cb1'::UUID, 'e2dab045-5b07-5445-948a-e911a40e0764'::UUID, 'multiple_choice', 7, 'Câu nào dùng dấu hiệu kết luận phù hợp?', NULL, '数据持续上升，由此可见需求正在增加。', '由此可见 đánh dấu kết luận logic trong văn viết.', NULL, 1, '{"activity_type":"grammar_selection","passage":null,"grammar_key":"hsk5:van-viet"}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('276eb2b0-2b65-551d-bf60-01e0325395c7'::UUID, 'f8c073ad-4a40-503d-899f-075707135cb1'::UUID, '数据持续上升，由此可见需求正在增加。', TRUE, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('49bdd0ad-c287-568b-889f-502bb86ed135'::UUID, 'f8c073ad-4a40-503d-899f-075707135cb1'::UUID, '。增加正在需求由此可见，上升持续数据', FALSE, 2)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('7f59329b-e7aa-5260-a79c-2ade5fdbc4c9'::UUID, 'f8c073ad-4a40-503d-899f-075707135cb1'::UUID, '持续上升，由此可见需求正在增加。数据', FALSE, 3)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('537d303e-37ac-510d-a4c9-7294730e8c38'::UUID, 'e2dab045-5b07-5445-948a-e911a40e0764'::UUID, 'speaking', 8, 'Đọc thành tiếng: 数据持续上升，由此可见需求正在增加。', NULL, '数据持续上升，由此可见需求正在增加。', 'Đọc chậm, giữ đúng thanh điệu và nhịp của cả câu.', NULL, 1, '{"activity_type":"pronunciation","text":"数据持续上升，由此可见需求正在增加。","pinyin":"Shùjù chíxù shàngshēng, yóucǐ kějiàn xūqiú zhèngzài zēngjiā."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.units (id, course_id, slug, title, description, order_index, status, learning_objectives, content_version)
VALUES ('63412671-e1c4-53f1-94bd-d2c8c1433ea9'::UUID, 'caa02026-6a78-535a-9498-ce0a91bda3e4'::UUID, 'hsk5-on-tap', 'Ôn tập', 'Kiểm tra và củng cố nội dung đã học.', 3, 'review', '["Ôn từ vựng","Ôn mẫu câu"]'::JSONB, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.chapters (id, unit_id, slug, title, description, order_index, status, learning_objectives, content_version)
VALUES ('2602c627-9ae5-5afc-8e23-c30d2611356e'::UUID, '63412671-e1c4-53f1-94bd-d2c8c1433ea9'::UUID, 'hsk5-on-tap-chapter', 'Củng cố lộ trình', 'Kiểm tra và củng cố nội dung đã học.', 1, 'review', '["Ôn từ vựng","Ôn mẫu câu"]'::JSONB, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lessons (id, chapter_id, slug, title, description, order_index, xp_reward, status, lesson_type, estimated_minutes, learning_objectives, cultural_note, content_version)
VALUES ('5c582f27-eb8b-513d-b8ef-dc22059fe953'::UUID, '2602c627-9ae5-5afc-8e23-c30d2611356e'::UUID, 'hsk5-review', 'Ôn tập HSK 5', 'Củng cố từ vựng, mẫu câu và khả năng diễn đạt của toàn khóa.', 1, 30, 'review', 'review', 18, '["Vận dụng lại từ vựng trọng tâm","Tự kiểm tra mẫu câu đã học"]'::JSONB, NULL, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('9b62970f-140a-5bf2-82a3-e8495895749c'::UUID, '5c582f27-eb8b-513d-b8ef-dc22059fe953'::UUID, '7db38f0d-b462-5d89-8780-05d05783a961'::UUID, 1, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('e9ddbf20-0da9-52c0-8531-856ee040f8cf'::UUID, '5c582f27-eb8b-513d-b8ef-dc22059fe953'::UUID, 'd378fb10-c9ca-5fde-a1a5-a04cf734b44d'::UUID, 2, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('b545f0e0-f604-5ab2-b8b6-ca7f57690f97'::UUID, '5c582f27-eb8b-513d-b8ef-dc22059fe953'::UUID, 'dc71b55d-3691-5be7-ad84-ab47093ba178'::UUID, 3, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_grammar (id, lesson_id, grammar_lesson_id, order_index, curriculum_role)
VALUES ('b9549005-c0c4-5bc8-a26d-23f67a24bed5'::UUID, '5c582f27-eb8b-513d-b8ef-dc22059fe953'::UUID, '86b5c36a-98f5-55dc-8453-aeedc9f4f29f'::UUID, 1, 'review')
ON CONFLICT (lesson_id, grammar_lesson_id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('fc6b2eb1-c0ae-504f-9479-cfdf04a2785a'::UUID, '5c582f27-eb8b-513d-b8ef-dc22059fe953'::UUID, 'multiple_choice', 1, '“证据” có nghĩa phù hợp nhất là gì?', NULL, 'chứng cứ', '证据 (zhèngjù) nghĩa là “chứng cứ”.', NULL, 1, '{"activity_type":"chinese_to_vietnamese","vocabulary_key":"hsk5:证据"}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('2911fa98-53dd-5c7d-b8f5-55d26306fadf'::UUID, 'fc6b2eb1-c0ae-504f-9479-cfdf04a2785a'::UUID, 'chứng cứ', TRUE, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('6177395d-28cb-510c-bbf4-ec574690d30c'::UUID, 'fc6b2eb1-c0ae-504f-9479-cfdf04a2785a'::UUID, 'kết luận', FALSE, 2)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('baa0ee78-e904-5b4d-9a72-8b00e3b1d682'::UUID, 'fc6b2eb1-c0ae-504f-9479-cfdf04a2785a'::UUID, 'cho thấy', FALSE, 3)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('ab7bd505-552a-5913-8128-06b1b5074d7c'::UUID, '5c582f27-eb8b-513d-b8ef-dc22059fe953'::UUID, 'translation', 2, 'Dịch sang tiếng Trung: “Dữ liệu liên tục tăng; từ đó có thể thấy nhu cầu đang tăng.”', NULL, '数据持续上升，由此可见需求正在增加。', 'Mẫu câu dùng “证据” trong ngữ cảnh của bài.', 'zhèngjù', 1, '{"activity_type":"vietnamese_to_chinese","source_lang":"vi","target_lang":"zh","acceptable_answers":["数据持续上升，由此可见需求正在增加。"]}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('9c8f2687-2038-5134-9174-0a65b4d91137'::UUID, '5c582f27-eb8b-513d-b8ef-dc22059fe953'::UUID, 'sentence_builder', 3, 'Sắp xếp các thành phần thành câu đúng.', NULL, '数据持续上升，由此可见需求正在增加。', 'Trật tự đúng tạo thành câu “数据持续上升，由此可见需求正在增加。”.', NULL, 1, '{"activity_type":"sentence_ordering","words":["数据","持续","上升","，","由此可见","需求","正在","增加","。"],"correct_order":["数据","持续","上升","，","由此可见","需求","正在","增加","。"]}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('4e09aabd-07ae-540b-b9f1-2d75f93e1e71'::UUID, '5c582f27-eb8b-513d-b8ef-dc22059fe953'::UUID, 'multiple_choice', 4, 'Câu nào dùng dấu hiệu kết luận phù hợp?', NULL, '数据持续上升，由此可见需求正在增加。', '由此可见 đánh dấu kết luận logic trong văn viết.', NULL, 1, '{"activity_type":"grammar_selection","passage":null,"grammar_key":"hsk5:van-viet"}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('66f02a26-e5ea-5854-a7a4-9fa98aad6715'::UUID, '4e09aabd-07ae-540b-b9f1-2d75f93e1e71'::UUID, '数据持续上升，由此可见需求正在增加。', TRUE, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('65ebaaef-d5b5-51ef-962e-2e3527fc7d5c'::UUID, '4e09aabd-07ae-540b-b9f1-2d75f93e1e71'::UUID, '。增加正在需求由此可见，上升持续数据', FALSE, 2)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('b96344ca-9c22-5525-bd72-0f60ceeff21d'::UUID, '4e09aabd-07ae-540b-b9f1-2d75f93e1e71'::UUID, '持续上升，由此可见需求正在增加。数据', FALSE, 3)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('3dff9012-9820-5294-b4c7-5b59c26d63fb'::UUID, '5c582f27-eb8b-513d-b8ef-dc22059fe953'::UUID, 'speaking', 5, 'Đọc thành tiếng: 数据持续上升，由此可见需求正在增加。', NULL, '数据持续上升，由此可见需求正在增加。', 'Đọc chậm, giữ đúng thanh điệu và nhịp của cả câu.', NULL, 1, '{"activity_type":"pronunciation","text":"数据持续上升，由此可见需求正在增加。","pinyin":"Shùjù chíxù shàngshēng, yóucǐ kějiàn xūqiú zhèngzài zēngjiā."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.content_batches (id, batch_key, version, migration_name, manifest_checksum, expected_counts)
VALUES ('9d8e1371-ac41-5393-9215-7ae4aa149027'::UUID, 'batch-06-hsk5', 1, '20260729150000_content_batch_06_hsk5', '243713e769d90bd3779a41975ab4d7f927b5f2fa3387f0be3fc22e876c47c7b2', '{"courses":1,"units":3,"chapters":3,"lessons":5,"vocabulary":12,"grammar":4,"characters":0,"exercises":37,"options":30}'::JSONB)
ON CONFLICT (batch_key, version) DO NOTHING;

DO $content_validation$
BEGIN
  IF (SELECT COUNT(*) FROM public.courses WHERE id = ANY(ARRAY['caa02026-6a78-535a-9498-ce0a91bda3e4'::UUID]::UUID[])) <> 1 THEN
    RAISE EXCEPTION 'Content batch batch-06-hsk5 is missing managed courses rows';
  END IF;
  IF (SELECT COUNT(*) FROM public.units WHERE id = ANY(ARRAY['e90d7faa-4bc7-5fd1-87c5-7c81cb9d4d7a'::UUID, '01208325-66c6-54e5-bbcb-9e3d5e9bc6bf'::UUID, '63412671-e1c4-53f1-94bd-d2c8c1433ea9'::UUID]::UUID[])) <> 3 THEN
    RAISE EXCEPTION 'Content batch batch-06-hsk5 is missing managed units rows';
  END IF;
  IF (SELECT COUNT(*) FROM public.chapters WHERE id = ANY(ARRAY['fe2d6b00-150b-512d-9dff-dcd1980b6e6a'::UUID, '88e6d5e2-cf15-5db2-972b-aa88164e1e4f'::UUID, '2602c627-9ae5-5afc-8e23-c30d2611356e'::UUID]::UUID[])) <> 3 THEN
    RAISE EXCEPTION 'Content batch batch-06-hsk5 is missing managed chapters rows';
  END IF;
  IF (SELECT COUNT(*) FROM public.lessons WHERE id = ANY(ARRAY['1b981463-0a1b-54bc-8467-1c3bd7e50bf5'::UUID, 'b68af30b-2251-5917-bddc-2bea4d849383'::UUID, '40f6f2a4-0d26-5c44-aa75-bc09f1c9600f'::UUID, 'e2dab045-5b07-5445-948a-e911a40e0764'::UUID, '5c582f27-eb8b-513d-b8ef-dc22059fe953'::UUID]::UUID[])) <> 5 THEN
    RAISE EXCEPTION 'Content batch batch-06-hsk5 is missing managed lessons rows';
  END IF;
  IF (SELECT COUNT(*) FROM public.vocabulary WHERE id = ANY(ARRAY['7e3eaf04-b076-5137-9b67-6e227c75d360'::UUID, 'ba308b8a-ae69-5ac2-9bad-d37759aab8ac'::UUID, 'ac5bf7fa-224a-5613-98e4-4d3bb7e24173'::UUID, 'bc234740-d1f5-547a-b78f-c596a35ac68a'::UUID, 'eba0e265-5bb1-59d0-84e6-3728e862ee34'::UUID, '2ae291c3-155d-509a-85fc-969d9b19b501'::UUID, '855e24e7-d343-58c1-a9b0-52074cc8b389'::UUID, 'e091a360-387e-55cd-bfa1-ffd0e7e27fc1'::UUID, '1eb72d6d-b5ce-52ca-8b58-b4aea5b60a34'::UUID, '7db38f0d-b462-5d89-8780-05d05783a961'::UUID, 'd378fb10-c9ca-5fde-a1a5-a04cf734b44d'::UUID, 'dc71b55d-3691-5be7-ad84-ab47093ba178'::UUID]::UUID[])) <> 12 THEN
    RAISE EXCEPTION 'Content batch batch-06-hsk5 is missing managed vocabulary rows';
  END IF;
  IF (SELECT COUNT(*) FROM public.grammar_lessons WHERE id = ANY(ARRAY['2f709891-cc1e-5500-a7c7-c336cc89d226'::UUID, '739787e6-a7f7-5a13-b1da-405cf9e8cdbf'::UUID, '8b4170e7-1f0a-5d75-bdbf-0598a9ef6db6'::UUID, '86b5c36a-98f5-55dc-8453-aeedc9f4f29f'::UUID]::UUID[])) <> 4 THEN
    RAISE EXCEPTION 'Content batch batch-06-hsk5 is missing managed grammar_lessons rows';
  END IF;
  IF (SELECT COUNT(*) FROM public.exercises WHERE id = ANY(ARRAY['67cb0df6-1c67-5897-8234-dd91c0cfb822'::UUID, 'aee5bffb-1b2a-5f87-8141-2a3fbd5327b5'::UUID, 'a6372bf1-4dac-553c-b6ac-3c64563ad2d0'::UUID, 'cfdfc358-0222-54e9-a1e8-feea5ccbdb74'::UUID, '9e6efcee-f745-595f-a960-9353a0e32c7e'::UUID, '71e32731-b3f5-5967-b555-dd102c2c036e'::UUID, 'c664438b-ce7c-5b20-94b9-e6e052ec4de5'::UUID, '403c6f16-1b43-5a16-9a4a-8326ed98402a'::UUID, '50378819-f196-59e6-96ef-8d9539f4663f'::UUID, '3a38b341-f811-50fb-89ea-4d10adf49739'::UUID, '254ff0b0-9a7a-51ef-8826-6fb1f75cc3df'::UUID, '8365c50c-de64-5ce0-a87c-94aae7730035'::UUID, '3c4c0acf-57f3-50ec-a9fd-4252483f3ee7'::UUID, '60b3580b-01d5-5f22-91a1-c9e75c715516'::UUID, '3e922562-aae8-5559-b312-0318e303ec30'::UUID, '3a2a2241-9824-5804-890e-1e1d39b73587'::UUID, 'f7481bc8-79dd-5e37-b46b-813ca533db37'::UUID, 'f2af9417-8fbb-5b3e-ba96-afc43d34043d'::UUID, '58647351-1d1a-5c59-94aa-ee77c87ddd39'::UUID, 'c1fc21b8-e9dc-501a-85f6-f6665367af2f'::UUID, '91ca6838-b249-5221-8950-f1ea57c94466'::UUID, 'ed5485d2-250d-57da-9b6f-500226665ca7'::UUID, 'f958dc45-672e-5616-b584-00d5fc0b7046'::UUID, 'dc15c6f4-d730-52e3-a23c-261d1a6d94da'::UUID, 'b3cbf283-32d7-5082-8a1f-8cce513b74b6'::UUID, 'ff089b1a-85e0-5325-8902-21cf316af1a0'::UUID, '30185c45-837e-5c52-82ee-af6b0a08826a'::UUID, '882aa697-1840-5363-818c-7eac6777a127'::UUID, 'bb2e986c-e389-5fb2-b64d-80c00eaa5fa3'::UUID, '88d90c12-6c44-5790-815c-4a1bd61b3281'::UUID, 'f8c073ad-4a40-503d-899f-075707135cb1'::UUID, '537d303e-37ac-510d-a4c9-7294730e8c38'::UUID, 'fc6b2eb1-c0ae-504f-9479-cfdf04a2785a'::UUID, 'ab7bd505-552a-5913-8128-06b1b5074d7c'::UUID, '9c8f2687-2038-5134-9174-0a65b4d91137'::UUID, '4e09aabd-07ae-540b-b9f1-2d75f93e1e71'::UUID, '3dff9012-9820-5294-b4c7-5b59c26d63fb'::UUID]::UUID[])) <> 37 THEN
    RAISE EXCEPTION 'Content batch batch-06-hsk5 is missing managed exercises rows';
  END IF;
  IF (SELECT COUNT(*) FROM public.exercise_options WHERE id = ANY(ARRAY['17787c07-8b03-5913-9c84-6c790ef81f82'::UUID, 'e100e28a-8f79-5867-9ac7-e9c785c0e3f0'::UUID, '9a3a7ff8-fc74-5aca-abfb-5aed00072bcb'::UUID, '5d8b746b-f36f-5be2-9800-823b7d187b90'::UUID, '5dd996fa-6722-55cb-9c56-09adce4bd94f'::UUID, '2820f2d7-726b-5a09-8e94-a7dbab0fe24d'::UUID, '8d663b0e-960c-5d2d-b7e0-1c98a5b433cd'::UUID, '40955861-5aff-54c4-a02a-22161b098b65'::UUID, '1494bc4f-923e-5757-ba01-546e0037fbb0'::UUID, 'c0df70a1-ddbb-5bfc-a820-bd8ec8707785'::UUID, '4416edc0-2570-56fe-840f-3b2e7ca129bf'::UUID, 'bbbe6ecf-c985-51d9-b0de-8b7185e1b902'::UUID, '988cf421-e5ae-57e7-be69-cb0b4ed1c6fc'::UUID, 'a42c6e2e-db49-5894-9b00-6034c2e793f0'::UUID, 'd6fa287d-98de-52ef-9d04-f334a3ee6677'::UUID, '8718b059-7d1f-5251-8d3c-4fef249fdadc'::UUID, 'c586ab82-9e8d-5377-9c51-a6aa32a7c082'::UUID, '0db01185-3d28-5d86-a705-646243736d6d'::UUID, '0a72754d-cfb0-5ae4-a14c-efa022282de0'::UUID, '551e4f09-5475-5f77-9281-5bb85d8a2701'::UUID, 'ed4f680f-46cc-57b5-8591-48da377d96df'::UUID, '276eb2b0-2b65-551d-bf60-01e0325395c7'::UUID, '49bdd0ad-c287-568b-889f-502bb86ed135'::UUID, '7f59329b-e7aa-5260-a79c-2ade5fdbc4c9'::UUID, '2911fa98-53dd-5c7d-b8f5-55d26306fadf'::UUID, '6177395d-28cb-510c-bbf4-ec574690d30c'::UUID, 'baa0ee78-e904-5b4d-9a72-8b00e3b1d682'::UUID, '66f02a26-e5ea-5854-a7a4-9fa98aad6715'::UUID, '65ebaaef-d5b5-51ef-962e-2e3527fc7d5c'::UUID, 'b96344ca-9c22-5525-bd72-0f60ceeff21d'::UUID]::UUID[])) <> 30 THEN
    RAISE EXCEPTION 'Content batch batch-06-hsk5 is missing managed exercise_options rows';
  END IF;
  IF EXISTS (
    SELECT 1 FROM public.lessons AS lesson
    WHERE lesson.id = ANY(ARRAY['1b981463-0a1b-54bc-8467-1c3bd7e50bf5'::UUID, 'b68af30b-2251-5917-bddc-2bea4d849383'::UUID, '40f6f2a4-0d26-5c44-aa75-bc09f1c9600f'::UUID, 'e2dab045-5b07-5445-948a-e911a40e0764'::UUID, '5c582f27-eb8b-513d-b8ef-dc22059fe953'::UUID]::UUID[])
      AND NOT EXISTS (
        SELECT 1 FROM public.exercises AS exercise
        WHERE exercise.lesson_id = lesson.id
      )
  ) THEN
    RAISE EXCEPTION 'Content batch batch-06-hsk5 contains a lesson without exercises';
  END IF;
  IF EXISTS (
    SELECT 1
    FROM public.lessons AS lesson
    JOIN public.exercises AS exercise ON exercise.lesson_id = lesson.id
    WHERE lesson.id = ANY(ARRAY['1b981463-0a1b-54bc-8467-1c3bd7e50bf5'::UUID, 'b68af30b-2251-5917-bddc-2bea4d849383'::UUID, '40f6f2a4-0d26-5c44-aa75-bc09f1c9600f'::UUID, 'e2dab045-5b07-5445-948a-e911a40e0764'::UUID, '5c582f27-eb8b-513d-b8ef-dc22059fe953'::UUID]::UUID[])
      AND lesson.status = 'published'
      AND exercise.exercise_type = 'listening'
      AND NULLIF(BTRIM(exercise.question_audio_url), '') IS NULL
  ) THEN
    RAISE EXCEPTION 'Published listening exercise is missing playable audio';
  END IF;
  IF EXISTS (
    SELECT 1
    FROM public.exercises AS exercise
    WHERE exercise.id = ANY(ARRAY['67cb0df6-1c67-5897-8234-dd91c0cfb822'::UUID, 'aee5bffb-1b2a-5f87-8141-2a3fbd5327b5'::UUID, 'a6372bf1-4dac-553c-b6ac-3c64563ad2d0'::UUID, 'cfdfc358-0222-54e9-a1e8-feea5ccbdb74'::UUID, '9e6efcee-f745-595f-a960-9353a0e32c7e'::UUID, '71e32731-b3f5-5967-b555-dd102c2c036e'::UUID, 'c664438b-ce7c-5b20-94b9-e6e052ec4de5'::UUID, '403c6f16-1b43-5a16-9a4a-8326ed98402a'::UUID, '50378819-f196-59e6-96ef-8d9539f4663f'::UUID, '3a38b341-f811-50fb-89ea-4d10adf49739'::UUID, '254ff0b0-9a7a-51ef-8826-6fb1f75cc3df'::UUID, '8365c50c-de64-5ce0-a87c-94aae7730035'::UUID, '3c4c0acf-57f3-50ec-a9fd-4252483f3ee7'::UUID, '60b3580b-01d5-5f22-91a1-c9e75c715516'::UUID, '3e922562-aae8-5559-b312-0318e303ec30'::UUID, '3a2a2241-9824-5804-890e-1e1d39b73587'::UUID, 'f7481bc8-79dd-5e37-b46b-813ca533db37'::UUID, 'f2af9417-8fbb-5b3e-ba96-afc43d34043d'::UUID, '58647351-1d1a-5c59-94aa-ee77c87ddd39'::UUID, 'c1fc21b8-e9dc-501a-85f6-f6665367af2f'::UUID, '91ca6838-b249-5221-8950-f1ea57c94466'::UUID, 'ed5485d2-250d-57da-9b6f-500226665ca7'::UUID, 'f958dc45-672e-5616-b584-00d5fc0b7046'::UUID, 'dc15c6f4-d730-52e3-a23c-261d1a6d94da'::UUID, 'b3cbf283-32d7-5082-8a1f-8cce513b74b6'::UUID, 'ff089b1a-85e0-5325-8902-21cf316af1a0'::UUID, '30185c45-837e-5c52-82ee-af6b0a08826a'::UUID, '882aa697-1840-5363-818c-7eac6777a127'::UUID, 'bb2e986c-e389-5fb2-b64d-80c00eaa5fa3'::UUID, '88d90c12-6c44-5790-815c-4a1bd61b3281'::UUID, 'f8c073ad-4a40-503d-899f-075707135cb1'::UUID, '537d303e-37ac-510d-a4c9-7294730e8c38'::UUID, 'fc6b2eb1-c0ae-504f-9479-cfdf04a2785a'::UUID, 'ab7bd505-552a-5913-8128-06b1b5074d7c'::UUID, '9c8f2687-2038-5134-9174-0a65b4d91137'::UUID, '4e09aabd-07ae-540b-b9f1-2d75f93e1e71'::UUID, '3dff9012-9820-5294-b4c7-5b59c26d63fb'::UUID]::UUID[])
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
    WHERE link.lesson_id = ANY(ARRAY['1b981463-0a1b-54bc-8467-1c3bd7e50bf5'::UUID, 'b68af30b-2251-5917-bddc-2bea4d849383'::UUID, '40f6f2a4-0d26-5c44-aa75-bc09f1c9600f'::UUID, 'e2dab045-5b07-5445-948a-e911a40e0764'::UUID, '5c582f27-eb8b-513d-b8ef-dc22059fe953'::UUID]::UUID[])
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
