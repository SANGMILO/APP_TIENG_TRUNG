-- Generated from content/manifests/03_hsk2.json.
-- Do not hand-edit this migration; edit the manifest and regenerate.
-- Additive and idempotent: deterministic IDs plus ON CONFLICT DO NOTHING.

BEGIN;

INSERT INTO public.courses (id, slug, title, title_zh, description, level, status, order_index, learning_objectives, estimated_minutes, content_version)
VALUES ('f8004ee7-af0d-59a3-abae-19e17034005e'::UUID, 'hsk-2', 'HSK 2', 'HSK 二级', 'Mở rộng giao tiếp hằng ngày và các cấu trúc HSK 2.', 'elementary', 'review', 3, '["Kể sự việc gần gũi","Diễn đạt mức độ và so sánh","Nói kế hoạch và trải nghiệm"]'::JSONB, 78, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.units (id, course_id, slug, title, description, order_index, status, learning_objectives, content_version)
VALUES ('3165f66c-69ef-5280-bc64-c69ce3f43e17'::UUID, 'f8004ee7-af0d-59a3-abae-19e17034005e'::UUID, 'hsk2-nen-tang', 'Nền tảng', 'Xây dựng ngôn ngữ cốt lõi của lộ trình.', 1, 'review', '["Kể sự việc gần gũi","Diễn đạt mức độ và so sánh"]'::JSONB, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.chapters (id, unit_id, slug, title, description, order_index, status, learning_objectives, content_version)
VALUES ('2301bed6-d4c8-5ad4-9c85-fb6eb2338cb8'::UUID, '3165f66c-69ef-5280-bc64-c69ce3f43e17'::UUID, 'hsk2-nen-tang-chapter', 'Khái niệm cốt lõi', 'Xây dựng ngôn ngữ cốt lõi của lộ trình.', 1, 'review', '["Kể sự việc gần gũi","Diễn đạt mức độ và so sánh"]'::JSONB, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lessons (id, chapter_id, slug, title, description, order_index, xp_reward, status, lesson_type, estimated_minutes, learning_objectives, cultural_note, content_version)
VALUES ('1f7cc17b-b285-54ef-a7e7-42c311ad2d0d'::UUID, '2301bed6-d4c8-5ad4-9c85-fb6eb2338cb8'::UUID, 'thoi-tiet', '天气怎么样？— Thời tiết', 'Mô tả thời tiết và mức độ.', 1, 25, 'review', 'standard', 15, '["Nói về thời tiết hôm nay"]'::JSONB, '暖和 thường dùng cho thời tiết dễ chịu, không dùng cho đồ ăn nóng.', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('ccda7368-3f45-55aa-8ee9-1b7e05fc778a'::UUID, 'hsk2:天气', '天气', 'tiānqì', 'thời tiết', 'weather', 'elementary', 'thoi-tiet', 'danh từ', '今天天气很暖和。', 'Jīntiān tiānqì hěn nuǎnhuo.', 'Hôm nay thời tiết ấm áp.', NULL, 'review', '1f7cc17b-b285-54ef-a7e7-42c311ad2d0d'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('1e8117e8-fbcf-568e-ae38-1a10512067b3'::UUID, '1f7cc17b-b285-54ef-a7e7-42c311ad2d0d'::UUID, 'ccda7368-3f45-55aa-8ee9-1b7e05fc778a'::UUID, 1, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('3f622e4f-0b4d-50b6-bbf3-237163fa09f7'::UUID, 'hsk2:晴', '晴', 'qíng', 'trời quang', 'sunny', 'elementary', 'thoi-tiet', 'tính từ', '明天是晴天。', 'Míngtiān shì qíngtiān.', 'Ngày mai trời nắng.', NULL, 'review', '1f7cc17b-b285-54ef-a7e7-42c311ad2d0d'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('8a456575-15af-5ea2-936a-daf2ff47d4fa'::UUID, '1f7cc17b-b285-54ef-a7e7-42c311ad2d0d'::UUID, '3f622e4f-0b4d-50b6-bbf3-237163fa09f7'::UUID, 2, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('7fa9e077-00c0-59ef-be56-cbf2e5837a39'::UUID, 'hsk2:阴', '阴', 'yīn', 'âm u, nhiều mây', 'overcast', 'elementary', 'thoi-tiet', 'tính từ', '下午可能阴天。', 'Xiàwǔ kěnéng yīntiān.', 'Buổi chiều có thể trời âm u.', NULL, 'review', '1f7cc17b-b285-54ef-a7e7-42c311ad2d0d'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('cd2ba41c-9b46-5244-aea6-06518930d27b'::UUID, '1f7cc17b-b285-54ef-a7e7-42c311ad2d0d'::UUID, '7fa9e077-00c0-59ef-be56-cbf2e5837a39'::UUID, 3, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.grammar_lessons (id, content_key, title, pattern, explanation, example_chinese, example_pinyin, example_meaning, level, status, usage_note, content_version)
VALUES ('c51a3559-cf53-5d31-bb97-16cd2963f6e6'::UUID, 'hsk2:thoi-tiet', 'Hỏi trạng thái với 怎么样', 'danh từ + 怎么样', '怎么样 hỏi nhận xét hoặc tình trạng.', '今天天气怎么样？', 'Jīntiān tiānqì zěnmeyàng?', 'Hôm nay thời tiết thế nào?', 'elementary', 'review', NULL, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_grammar (id, lesson_id, grammar_lesson_id, order_index, curriculum_role)
VALUES ('4932e642-f7df-595e-9d76-cfe71fc3dff0'::UUID, '1f7cc17b-b285-54ef-a7e7-42c311ad2d0d'::UUID, 'c51a3559-cf53-5d31-bb97-16cd2963f6e6'::UUID, 1, 'introduced')
ON CONFLICT (lesson_id, grammar_lesson_id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('fa0b7bd9-90d4-50f1-aa61-766c19de6be6'::UUID, '1f7cc17b-b285-54ef-a7e7-42c311ad2d0d'::UUID, 'vocabulary', 1, 'Từ mới: 天气', NULL, '天气', '天气 (tiānqì) — thời tiết. 今天天气很暖和。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"hsk2:天气","chinese":"天气","pinyin":"tiānqì","meaning":"thời tiết","part_of_speech":"danh từ","example_chinese":"今天天气很暖和。","example_pinyin":"Jīntiān tiānqì hěn nuǎnhuo.","example_meaning_vi":"Hôm nay thời tiết ấm áp."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('8945524d-b9c7-59c2-826e-349921fbafcc'::UUID, '1f7cc17b-b285-54ef-a7e7-42c311ad2d0d'::UUID, 'vocabulary', 2, 'Từ mới: 晴', NULL, '晴', '晴 (qíng) — trời quang. 明天是晴天。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"hsk2:晴","chinese":"晴","pinyin":"qíng","meaning":"trời quang","part_of_speech":"tính từ","example_chinese":"明天是晴天。","example_pinyin":"Míngtiān shì qíngtiān.","example_meaning_vi":"Ngày mai trời nắng."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('a283e6d9-21da-564b-bad8-5a359dbdfff5'::UUID, '1f7cc17b-b285-54ef-a7e7-42c311ad2d0d'::UUID, 'vocabulary', 3, 'Từ mới: 阴', NULL, '阴', '阴 (yīn) — âm u, nhiều mây. 下午可能阴天。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"hsk2:阴","chinese":"阴","pinyin":"yīn","meaning":"âm u, nhiều mây","part_of_speech":"tính từ","example_chinese":"下午可能阴天。","example_pinyin":"Xiàwǔ kěnéng yīntiān.","example_meaning_vi":"Buổi chiều có thể trời âm u."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('f2805704-2ad1-5c19-bfd1-76cb77a7e988'::UUID, '1f7cc17b-b285-54ef-a7e7-42c311ad2d0d'::UUID, 'multiple_choice', 4, '“天气” có nghĩa phù hợp nhất là gì?', NULL, 'thời tiết', '天气 (tiānqì) nghĩa là “thời tiết”.', NULL, 1, '{"activity_type":"chinese_to_vietnamese","vocabulary_key":"hsk2:天气"}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('ae98b58e-a09d-50af-bb9b-e2abcc507443'::UUID, 'f2805704-2ad1-5c19-bfd1-76cb77a7e988'::UUID, 'thời tiết', TRUE, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('d30c1b1f-e0cc-56f5-936d-651feeb89f8a'::UUID, 'f2805704-2ad1-5c19-bfd1-76cb77a7e988'::UUID, 'trời quang', FALSE, 2)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('a80870e2-435d-53a4-ac72-9c00bfaa18e7'::UUID, 'f2805704-2ad1-5c19-bfd1-76cb77a7e988'::UUID, 'âm u, nhiều mây', FALSE, 3)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('6a7b047c-cad0-5713-8a09-d6ccc9c1df3c'::UUID, '1f7cc17b-b285-54ef-a7e7-42c311ad2d0d'::UUID, 'translation', 5, 'Dịch sang tiếng Trung: “Hôm nay thời tiết thế nào?”', NULL, '今天天气怎么样？', 'Mẫu câu dùng “天气” trong ngữ cảnh của bài.', 'tiānqì', 1, '{"activity_type":"vietnamese_to_chinese","source_lang":"vi","target_lang":"zh","acceptable_answers":["今天天气怎么样？"]}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('c9a2463a-94b6-57b0-bee3-875987503dbd'::UUID, '1f7cc17b-b285-54ef-a7e7-42c311ad2d0d'::UUID, 'sentence_builder', 6, 'Sắp xếp các thành phần thành câu đúng.', NULL, '今天天气怎么样？', 'Trật tự đúng tạo thành câu “今天天气怎么样？”.', NULL, 1, '{"activity_type":"sentence_ordering","words":["今天","天气","怎么样","？"],"correct_order":["今天","天气","怎么样","？"]}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('6ad5662c-e34c-5013-82b2-550cc9752e83'::UUID, '1f7cc17b-b285-54ef-a7e7-42c311ad2d0d'::UUID, 'multiple_choice', 7, 'Câu nào hỏi đúng về thời tiết?', NULL, '今天天气怎么样？', '怎么样 hỏi nhận xét hoặc tình trạng.', NULL, 1, '{"activity_type":"grammar_selection","passage":null,"grammar_key":"hsk2:thoi-tiet"}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('d4eba427-7732-5518-8199-bd694678db86'::UUID, '6ad5662c-e34c-5013-82b2-550cc9752e83'::UUID, '今天天气怎么样？', TRUE, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('56e3c350-7ea9-548a-bd4e-a4662550cc32'::UUID, '6ad5662c-e34c-5013-82b2-550cc9752e83'::UUID, '？怎么样天气今天', FALSE, 2)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('ad9d0984-2a44-5325-999f-e4ac8197b782'::UUID, '6ad5662c-e34c-5013-82b2-550cc9752e83'::UUID, '天气怎么样？今天', FALSE, 3)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('9bf6f745-01d2-5147-b36f-3324c1abac46'::UUID, '1f7cc17b-b285-54ef-a7e7-42c311ad2d0d'::UUID, 'speaking', 8, 'Đọc thành tiếng: 今天天气怎么样？', NULL, '今天天气怎么样？', 'Đọc chậm, giữ đúng thanh điệu và nhịp của cả câu.', NULL, 1, '{"activity_type":"pronunciation","text":"今天天气怎么样？","pinyin":"Jīntiān tiānqì zěnmeyàng?"}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lessons (id, chapter_id, slug, title, description, order_index, xp_reward, status, lesson_type, estimated_minutes, learning_objectives, cultural_note, content_version)
VALUES ('d5596545-fb2f-520a-8615-97e8a1166a68'::UUID, '2301bed6-d4c8-5ad4-9c85-fb6eb2338cb8'::UUID, 'dang-lam-gi', '正在做什么？— Hành động đang diễn ra', 'Dùng 正在 và 呢 cho hành động hiện tại.', 2, 25, 'review', 'standard', 15, '["Mô tả việc đang diễn ra"]'::JSONB, 'Có thể lược 正 hoặc 在 trong khẩu ngữ tùy ngữ cảnh.', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('55a5d0c1-6a48-5778-9b4b-0593be2643e2'::UUID, 'hsk2:正在', '正在', 'zhèngzài', 'đang', 'in the process of', 'elementary', 'dang-lam-gi', 'phó từ', '我正在准备晚饭。', 'Wǒ zhèngzài zhǔnbèi wǎnfàn.', 'Tôi đang chuẩn bị bữa tối.', NULL, 'review', 'd5596545-fb2f-520a-8615-97e8a1166a68'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('9b6eabfb-d5a5-57a3-aa39-b184006a4551'::UUID, 'd5596545-fb2f-520a-8615-97e8a1166a68'::UUID, '55a5d0c1-6a48-5778-9b4b-0593be2643e2'::UUID, 1, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('750340d7-a995-5797-b340-2ee02a3c16c3'::UUID, 'hsk2:等', '等', 'děng', 'đợi', 'to wait', 'elementary', 'dang-lam-gi', 'động từ', '请在门口等我。', 'Qǐng zài ménkǒu děng wǒ.', 'Hãy đợi tôi ở cửa.', NULL, 'review', 'd5596545-fb2f-520a-8615-97e8a1166a68'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('09f91cdd-ae03-576a-90e4-999b8fffcd80'::UUID, 'd5596545-fb2f-520a-8615-97e8a1166a68'::UUID, '750340d7-a995-5797-b340-2ee02a3c16c3'::UUID, 2, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('5ec7ad7b-583c-5831-9f5a-2e2baa9d68ef'::UUID, 'hsk2:事情', '事情', 'shìqing', 'sự việc, việc', 'matter; affair', 'elementary', 'dang-lam-gi', 'danh từ', '我有一件重要的事情。', 'Wǒ yǒu yí jiàn zhòngyào de shìqing.', 'Tôi có một việc quan trọng.', NULL, 'review', 'd5596545-fb2f-520a-8615-97e8a1166a68'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('e3861911-6072-5e27-bbba-c6a1dbfe87a7'::UUID, 'd5596545-fb2f-520a-8615-97e8a1166a68'::UUID, '5ec7ad7b-583c-5831-9f5a-2e2baa9d68ef'::UUID, 3, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('04549715-2bfa-5bd6-86b6-296593ae0a96'::UUID, 'd5596545-fb2f-520a-8615-97e8a1166a68'::UUID, 'ccda7368-3f45-55aa-8ee9-1b7e05fc778a'::UUID, 4, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('41302a16-bdcd-59b8-b0ab-3b7b46d1f2a6'::UUID, 'd5596545-fb2f-520a-8615-97e8a1166a68'::UUID, '3f622e4f-0b4d-50b6-bbf3-237163fa09f7'::UUID, 5, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('c6aaeec1-27e3-5575-bcb0-04d9148a588d'::UUID, 'd5596545-fb2f-520a-8615-97e8a1166a68'::UUID, '7fa9e077-00c0-59ef-be56-cbf2e5837a39'::UUID, 6, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.grammar_lessons (id, content_key, title, pattern, explanation, example_chinese, example_pinyin, example_meaning, level, status, usage_note, content_version)
VALUES ('b1e4303e-0918-5d3c-ad51-17fb1fe42a69'::UUID, 'hsk2:dang-lam-gi', 'Đang diễn ra với 正在', '正在 + động từ + 呢', '正在 nhấn mạnh hành động đang diễn ra; 呢 có thể đặt cuối câu.', '我正在等朋友呢。', 'Wǒ zhèngzài děng péngyou ne.', 'Tôi đang đợi bạn.', 'elementary', 'review', NULL, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_grammar (id, lesson_id, grammar_lesson_id, order_index, curriculum_role)
VALUES ('45322054-0d3d-5667-9bf3-2f69a7829822'::UUID, 'd5596545-fb2f-520a-8615-97e8a1166a68'::UUID, 'b1e4303e-0918-5d3c-ad51-17fb1fe42a69'::UUID, 1, 'introduced')
ON CONFLICT (lesson_id, grammar_lesson_id) DO NOTHING;

INSERT INTO public.lesson_grammar (id, lesson_id, grammar_lesson_id, order_index, curriculum_role)
VALUES ('6c46a059-4989-5bb6-854a-2ec654369934'::UUID, 'd5596545-fb2f-520a-8615-97e8a1166a68'::UUID, 'c51a3559-cf53-5d31-bb97-16cd2963f6e6'::UUID, 2, 'review')
ON CONFLICT (lesson_id, grammar_lesson_id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('d62f4e85-d000-5af3-8731-a63d62189c3e'::UUID, 'd5596545-fb2f-520a-8615-97e8a1166a68'::UUID, 'vocabulary', 1, 'Từ mới: 正在', NULL, '正在', '正在 (zhèngzài) — đang. 我正在准备晚饭。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"hsk2:正在","chinese":"正在","pinyin":"zhèngzài","meaning":"đang","part_of_speech":"phó từ","example_chinese":"我正在准备晚饭。","example_pinyin":"Wǒ zhèngzài zhǔnbèi wǎnfàn.","example_meaning_vi":"Tôi đang chuẩn bị bữa tối."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('ad3bfde1-89da-52d4-8fc5-c1f66db6d71d'::UUID, 'd5596545-fb2f-520a-8615-97e8a1166a68'::UUID, 'vocabulary', 2, 'Từ mới: 等', NULL, '等', '等 (děng) — đợi. 请在门口等我。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"hsk2:等","chinese":"等","pinyin":"děng","meaning":"đợi","part_of_speech":"động từ","example_chinese":"请在门口等我。","example_pinyin":"Qǐng zài ménkǒu děng wǒ.","example_meaning_vi":"Hãy đợi tôi ở cửa."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('e13644ee-af9d-5e02-a428-269aa6e45b94'::UUID, 'd5596545-fb2f-520a-8615-97e8a1166a68'::UUID, 'vocabulary', 3, 'Từ mới: 事情', NULL, '事情', '事情 (shìqing) — sự việc, việc. 我有一件重要的事情。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"hsk2:事情","chinese":"事情","pinyin":"shìqing","meaning":"sự việc, việc","part_of_speech":"danh từ","example_chinese":"我有一件重要的事情。","example_pinyin":"Wǒ yǒu yí jiàn zhòngyào de shìqing.","example_meaning_vi":"Tôi có một việc quan trọng."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('adbe1d71-0c31-5e6e-8fe5-8028496ddb35'::UUID, 'd5596545-fb2f-520a-8615-97e8a1166a68'::UUID, 'multiple_choice', 4, '“正在” có nghĩa phù hợp nhất là gì?', NULL, 'đang', '正在 (zhèngzài) nghĩa là “đang”.', NULL, 1, '{"activity_type":"chinese_to_vietnamese","vocabulary_key":"hsk2:正在"}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('338f9b94-a6e9-586b-9b12-ed0dbcd36f4b'::UUID, 'adbe1d71-0c31-5e6e-8fe5-8028496ddb35'::UUID, 'sự việc, việc', FALSE, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('5b135faa-725a-5216-8edd-5f1ffa941e24'::UUID, 'adbe1d71-0c31-5e6e-8fe5-8028496ddb35'::UUID, 'đang', TRUE, 2)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('f9f1813e-6eb2-5154-98b1-85162940a685'::UUID, 'adbe1d71-0c31-5e6e-8fe5-8028496ddb35'::UUID, 'đợi', FALSE, 3)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('a5d88f11-6815-5c43-b11b-8b2201ab11b6'::UUID, 'd5596545-fb2f-520a-8615-97e8a1166a68'::UUID, 'translation', 5, 'Dịch sang tiếng Trung: “Tôi đang đợi bạn.”', NULL, '我正在等朋友呢。', 'Mẫu câu dùng “正在” trong ngữ cảnh của bài.', 'zhèngzài', 1, '{"activity_type":"vietnamese_to_chinese","source_lang":"vi","target_lang":"zh","acceptable_answers":["我正在等朋友呢。"]}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('d630e972-6c8e-5bb4-97d4-e5c7d835101e'::UUID, 'd5596545-fb2f-520a-8615-97e8a1166a68'::UUID, 'sentence_builder', 6, 'Sắp xếp các thành phần thành câu đúng.', NULL, '我正在等朋友呢。', 'Trật tự đúng tạo thành câu “我正在等朋友呢。”.', NULL, 1, '{"activity_type":"sentence_ordering","words":["我","正在","等","朋友","呢","。"],"correct_order":["我","正在","等","朋友","呢","。"]}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('dafab879-8a02-5ad2-b4a3-48b18ea6be47'::UUID, 'd5596545-fb2f-520a-8615-97e8a1166a68'::UUID, 'multiple_choice', 7, 'Câu nào diễn tả hành động đang diễn ra?', NULL, '我正在等朋友呢。', '正在 nhấn mạnh hành động đang diễn ra; 呢 có thể đặt cuối câu.', NULL, 1, '{"activity_type":"grammar_selection","passage":null,"grammar_key":"hsk2:dang-lam-gi"}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('b4626abb-b0cc-5622-b79b-a2f360a67d00'::UUID, 'dafab879-8a02-5ad2-b4a3-48b18ea6be47'::UUID, '我正在等朋友呢。', TRUE, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('7bd3de8a-0d8c-5568-a301-af0117a46907'::UUID, 'dafab879-8a02-5ad2-b4a3-48b18ea6be47'::UUID, '。呢朋友等正在我', FALSE, 2)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('4df4c8cb-84b0-5b31-86ea-ccec6976e40c'::UUID, 'dafab879-8a02-5ad2-b4a3-48b18ea6be47'::UUID, '正在等朋友呢。我', FALSE, 3)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('16b9abf6-d356-5153-8e06-d650826d27d6'::UUID, 'd5596545-fb2f-520a-8615-97e8a1166a68'::UUID, 'speaking', 8, 'Đọc thành tiếng: 我正在等朋友呢。', NULL, '我正在等朋友呢。', 'Đọc chậm, giữ đúng thanh điệu và nhịp của cả câu.', NULL, 1, '{"activity_type":"pronunciation","text":"我正在等朋友呢。","pinyin":"Wǒ zhèngzài děng péngyou ne."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.units (id, course_id, slug, title, description, order_index, status, learning_objectives, content_version)
VALUES ('5cb08c7b-fddd-5eb1-9e92-9c02d3650d66'::UUID, 'f8004ee7-af0d-59a3-abae-19e17034005e'::UUID, 'hsk2-van-dung', 'Vận dụng', 'Vận dụng mẫu câu trong ngữ cảnh có ý nghĩa.', 2, 'review', '["Diễn đạt mức độ và so sánh","Nói kế hoạch và trải nghiệm"]'::JSONB, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.chapters (id, unit_id, slug, title, description, order_index, status, learning_objectives, content_version)
VALUES ('d10f0446-949f-5ec7-b8b9-063049cf5f9f'::UUID, '5cb08c7b-fddd-5eb1-9e92-9c02d3650d66'::UUID, 'hsk2-van-dung-chapter', 'Ngữ cảnh thực tế', 'Vận dụng mẫu câu trong ngữ cảnh có ý nghĩa.', 1, 'review', '["Diễn đạt mức độ và so sánh","Nói kế hoạch và trải nghiệm"]'::JSONB, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lessons (id, chapter_id, slug, title, description, order_index, xp_reward, status, lesson_type, estimated_minutes, learning_objectives, cultural_note, content_version)
VALUES ('ef88f931-69bd-5578-ba49-3320abdbec2f'::UUID, 'd10f0446-949f-5ec7-b8b9-063049cf5f9f'::UUID, 'so-sanh', '比以前更好 — So sánh', 'So sánh hai đối tượng bằng 比.', 1, 25, 'review', 'standard', 15, '["Nói khác biệt rõ ràng"]'::JSONB, 'Muốn nói bằng nhau dùng A 跟 B 一样 + tính từ.', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('ac393974-ecd1-57e6-9181-5a91c5689c7b'::UUID, 'hsk2:比', '比', 'bǐ', 'so với', 'than; compare', 'elementary', 'so-sanh', 'giới từ', '今天比昨天暖和。', 'Jīntiān bǐ zuótiān nuǎnhuo.', 'Hôm nay ấm hơn hôm qua.', NULL, 'review', 'ef88f931-69bd-5578-ba49-3320abdbec2f'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('db3cf5e7-78af-576c-a180-fe9c192713a0'::UUID, 'ef88f931-69bd-5578-ba49-3320abdbec2f'::UUID, 'ac393974-ecd1-57e6-9181-5a91c5689c7b'::UUID, 1, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('85a93400-d896-59b8-aaaf-e7c6fbbec466'::UUID, 'hsk2:更', '更', 'gèng', 'càng, hơn nữa', 'even more', 'elementary', 'so-sanh', 'phó từ', '这个办法更简单。', 'Zhège bànfǎ gèng jiǎndān.', 'Cách này đơn giản hơn.', NULL, 'review', 'ef88f931-69bd-5578-ba49-3320abdbec2f'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('5ee028ae-02f6-5435-82cc-e39569f49336'::UUID, 'ef88f931-69bd-5578-ba49-3320abdbec2f'::UUID, '85a93400-d896-59b8-aaaf-e7c6fbbec466'::UUID, 2, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('52360e08-9bd9-526f-8d53-6f361f6bab14'::UUID, 'hsk2:一样', '一样', 'yíyàng', 'giống nhau', 'the same', 'elementary', 'so-sanh', 'tính từ', '这两本书一样厚。', 'Zhè liǎng běn shū yíyàng hòu.', 'Hai cuốn sách này dày như nhau.', NULL, 'review', 'ef88f931-69bd-5578-ba49-3320abdbec2f'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('7e685850-6fe6-5b19-9eec-96f1df9aac28'::UUID, 'ef88f931-69bd-5578-ba49-3320abdbec2f'::UUID, '52360e08-9bd9-526f-8d53-6f361f6bab14'::UUID, 3, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('c49dccf2-236a-501b-a677-4fcff09eff1d'::UUID, 'ef88f931-69bd-5578-ba49-3320abdbec2f'::UUID, '55a5d0c1-6a48-5778-9b4b-0593be2643e2'::UUID, 4, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('5dc0145c-c919-5c07-b83d-fa79cd091403'::UUID, 'ef88f931-69bd-5578-ba49-3320abdbec2f'::UUID, '750340d7-a995-5797-b340-2ee02a3c16c3'::UUID, 5, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('03cf41c3-858c-5e63-85a4-43a34458ad14'::UUID, 'ef88f931-69bd-5578-ba49-3320abdbec2f'::UUID, '5ec7ad7b-583c-5831-9f5a-2e2baa9d68ef'::UUID, 6, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.grammar_lessons (id, content_key, title, pattern, explanation, example_chinese, example_pinyin, example_meaning, level, status, usage_note, content_version)
VALUES ('f00563cf-2314-52b8-a342-6a543644e2a6'::UUID, 'hsk2:so-sanh', 'So sánh với 比', 'A + 比 + B + tính từ', '比 đặt trước đối tượng làm mốc; không thêm 很 trước tính từ.', '今天比昨天暖和。', 'Jīntiān bǐ zuótiān nuǎnhuo.', 'Hôm nay ấm hơn hôm qua.', 'elementary', 'review', NULL, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_grammar (id, lesson_id, grammar_lesson_id, order_index, curriculum_role)
VALUES ('171ead12-6c3b-56fa-a82a-7ab20f0f22e5'::UUID, 'ef88f931-69bd-5578-ba49-3320abdbec2f'::UUID, 'f00563cf-2314-52b8-a342-6a543644e2a6'::UUID, 1, 'introduced')
ON CONFLICT (lesson_id, grammar_lesson_id) DO NOTHING;

INSERT INTO public.lesson_grammar (id, lesson_id, grammar_lesson_id, order_index, curriculum_role)
VALUES ('9d461187-7184-560c-8af6-d90f0e20c3a3'::UUID, 'ef88f931-69bd-5578-ba49-3320abdbec2f'::UUID, 'b1e4303e-0918-5d3c-ad51-17fb1fe42a69'::UUID, 2, 'review')
ON CONFLICT (lesson_id, grammar_lesson_id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('8eb65b6a-9d69-5639-8fc4-643103cadc5b'::UUID, 'ef88f931-69bd-5578-ba49-3320abdbec2f'::UUID, 'vocabulary', 1, 'Từ mới: 比', NULL, '比', '比 (bǐ) — so với. 今天比昨天暖和。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"hsk2:比","chinese":"比","pinyin":"bǐ","meaning":"so với","part_of_speech":"giới từ","example_chinese":"今天比昨天暖和。","example_pinyin":"Jīntiān bǐ zuótiān nuǎnhuo.","example_meaning_vi":"Hôm nay ấm hơn hôm qua."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('611acb8f-7ac9-540e-ae06-2294a919177b'::UUID, 'ef88f931-69bd-5578-ba49-3320abdbec2f'::UUID, 'vocabulary', 2, 'Từ mới: 更', NULL, '更', '更 (gèng) — càng, hơn nữa. 这个办法更简单。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"hsk2:更","chinese":"更","pinyin":"gèng","meaning":"càng, hơn nữa","part_of_speech":"phó từ","example_chinese":"这个办法更简单。","example_pinyin":"Zhège bànfǎ gèng jiǎndān.","example_meaning_vi":"Cách này đơn giản hơn."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('06d026c9-3f90-5bde-9d4a-5cf68328791a'::UUID, 'ef88f931-69bd-5578-ba49-3320abdbec2f'::UUID, 'vocabulary', 3, 'Từ mới: 一样', NULL, '一样', '一样 (yíyàng) — giống nhau. 这两本书一样厚。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"hsk2:一样","chinese":"一样","pinyin":"yíyàng","meaning":"giống nhau","part_of_speech":"tính từ","example_chinese":"这两本书一样厚。","example_pinyin":"Zhè liǎng běn shū yíyàng hòu.","example_meaning_vi":"Hai cuốn sách này dày như nhau."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('9c5e4bfc-4d05-5239-a0ab-9afca811e97c'::UUID, 'ef88f931-69bd-5578-ba49-3320abdbec2f'::UUID, 'multiple_choice', 4, '“比” có nghĩa phù hợp nhất là gì?', NULL, 'so với', '比 (bǐ) nghĩa là “so với”.', NULL, 1, '{"activity_type":"chinese_to_vietnamese","vocabulary_key":"hsk2:比"}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('7a1b6aee-1088-5bfc-b07a-7b80572c4af7'::UUID, '9c5e4bfc-4d05-5239-a0ab-9afca811e97c'::UUID, 'càng, hơn nữa', FALSE, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('1cb8c3f6-b0ae-52bf-a013-7ee08c37710c'::UUID, '9c5e4bfc-4d05-5239-a0ab-9afca811e97c'::UUID, 'giống nhau', FALSE, 2)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('9917dd63-2ee7-565b-a0bd-cdfb89d38539'::UUID, '9c5e4bfc-4d05-5239-a0ab-9afca811e97c'::UUID, 'so với', TRUE, 3)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('1ecc0af3-6c51-54fa-a001-bc2bb14e630f'::UUID, 'ef88f931-69bd-5578-ba49-3320abdbec2f'::UUID, 'translation', 5, 'Dịch sang tiếng Trung: “Hôm nay ấm hơn hôm qua.”', NULL, '今天比昨天暖和。', 'Mẫu câu dùng “比” trong ngữ cảnh của bài.', 'bǐ', 1, '{"activity_type":"vietnamese_to_chinese","source_lang":"vi","target_lang":"zh","acceptable_answers":["今天比昨天暖和。"]}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('68e0a11e-2188-54b1-9e1c-a6e28ef50d95'::UUID, 'ef88f931-69bd-5578-ba49-3320abdbec2f'::UUID, 'sentence_builder', 6, 'Sắp xếp các thành phần thành câu đúng.', NULL, '今天比昨天暖和。', 'Trật tự đúng tạo thành câu “今天比昨天暖和。”.', NULL, 1, '{"activity_type":"sentence_ordering","words":["今天","比","昨天","暖和","。"],"correct_order":["今天","比","昨天","暖和","。"]}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('be32db94-2992-531a-8707-808797a10bad'::UUID, 'ef88f931-69bd-5578-ba49-3320abdbec2f'::UUID, 'multiple_choice', 7, 'Câu so sánh nào đúng?', NULL, '今天比昨天暖和。', '比 đặt trước đối tượng làm mốc; không thêm 很 trước tính từ.', NULL, 1, '{"activity_type":"grammar_selection","passage":null,"grammar_key":"hsk2:so-sanh"}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('2104f02c-5032-5f9a-a210-6397134d8b73'::UUID, 'be32db94-2992-531a-8707-808797a10bad'::UUID, '今天比昨天暖和。', TRUE, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('d9d65d90-5596-5adb-98bc-7ba441fd3fd8'::UUID, 'be32db94-2992-531a-8707-808797a10bad'::UUID, '。暖和昨天比今天', FALSE, 2)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('2fb8a3e9-e881-5d1a-ba21-e6ef798e1d5f'::UUID, 'be32db94-2992-531a-8707-808797a10bad'::UUID, '比昨天暖和。今天', FALSE, 3)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('75699a7f-3923-58c7-b97e-d0ce66125af8'::UUID, 'ef88f931-69bd-5578-ba49-3320abdbec2f'::UUID, 'speaking', 8, 'Đọc thành tiếng: 今天比昨天暖和。', NULL, '今天比昨天暖和。', 'Đọc chậm, giữ đúng thanh điệu và nhịp của cả câu.', NULL, 1, '{"activity_type":"pronunciation","text":"今天比昨天暖和。","pinyin":"Jīntiān bǐ zuótiān nuǎnhuo."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lessons (id, chapter_id, slug, title, description, order_index, xp_reward, status, lesson_type, estimated_minutes, learning_objectives, cultural_note, content_version)
VALUES ('6561a915-c6f4-5898-9c8a-9cba9a1bf3cc'::UUID, 'd10f0446-949f-5ec7-b8b9-063049cf5f9f'::UUID, 'kinh-nghiem', '去过北京 — Trải nghiệm', 'Nói trải nghiệm đã từng có bằng 过.', 2, 25, 'review', 'standard', 15, '["Hỏi và kể trải nghiệm"]'::JSONB, 'Phủ định trải nghiệm dùng 没(有) + động từ + 过.', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('49e8e986-a2b6-5ea0-a866-77c1a04c173c'::UUID, 'hsk2:过', '过', 'guo', 'đã từng (trợ từ)', 'experiential aspect', 'elementary', 'kinh-nghiem', 'trợ từ', '我去过上海两次。', 'Wǒ qùguo Shànghǎi liǎng cì.', 'Tôi đã từng đến Thượng Hải hai lần.', NULL, 'review', '6561a915-c6f4-5898-9c8a-9cba9a1bf3cc'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('19a12aa9-4bd6-594b-b0ff-a8518e991886'::UUID, '6561a915-c6f4-5898-9c8a-9cba9a1bf3cc'::UUID, '49e8e986-a2b6-5ea0-a866-77c1a04c173c'::UUID, 1, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('c9d0e5ed-ade3-5749-bf2d-169285a4546d'::UUID, 'hsk2:次', '次', 'cì', 'lần', 'time; occurrence', 'elementary', 'kinh-nghiem', 'lượng từ', '这是我第一次来中国。', 'Zhè shì wǒ dì-yī cì lái Zhōngguó.', 'Đây là lần đầu tôi đến Trung Quốc.', NULL, 'review', '6561a915-c6f4-5898-9c8a-9cba9a1bf3cc'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('bcb9dae6-f341-590a-93ff-7272e1f4d054'::UUID, '6561a915-c6f4-5898-9c8a-9cba9a1bf3cc'::UUID, 'c9d0e5ed-ade3-5749-bf2d-169285a4546d'::UUID, 2, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('6b626f58-fa26-5e34-966a-140c4d177e85'::UUID, 'hsk2:以前', '以前', 'yǐqián', 'trước đây', 'before; formerly', 'elementary', 'kinh-nghiem', 'danh từ thời gian', '我以前住在河内。', 'Wǒ yǐqián zhù zài Hénèi.', 'Trước đây tôi sống ở Hà Nội.', NULL, 'review', '6561a915-c6f4-5898-9c8a-9cba9a1bf3cc'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('c7c802b6-f7e6-5660-9114-4eade78f858b'::UUID, '6561a915-c6f4-5898-9c8a-9cba9a1bf3cc'::UUID, '6b626f58-fa26-5e34-966a-140c4d177e85'::UUID, 3, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('dce4092b-c08e-5479-8909-99a04764f2c2'::UUID, '6561a915-c6f4-5898-9c8a-9cba9a1bf3cc'::UUID, 'ac393974-ecd1-57e6-9181-5a91c5689c7b'::UUID, 4, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('08c3884d-b237-5e81-9b6c-db98a55c78fb'::UUID, '6561a915-c6f4-5898-9c8a-9cba9a1bf3cc'::UUID, '85a93400-d896-59b8-aaaf-e7c6fbbec466'::UUID, 5, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('d3ecd457-3658-5acc-82d9-6038ed10a3ed'::UUID, '6561a915-c6f4-5898-9c8a-9cba9a1bf3cc'::UUID, '52360e08-9bd9-526f-8d53-6f361f6bab14'::UUID, 6, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.grammar_lessons (id, content_key, title, pattern, explanation, example_chinese, example_pinyin, example_meaning, level, status, usage_note, content_version)
VALUES ('b9d861f8-83ba-57ce-9d08-a1bbac6e02d2'::UUID, 'hsk2:kinh-nghiem', 'Trải nghiệm với 过', 'động từ + 过 + tân ngữ', '过 cho biết hành động từng xảy ra ít nhất một lần.', '我以前去过北京。', 'Wǒ yǐqián qùguo Běijīng.', 'Trước đây tôi từng đến Bắc Kinh.', 'elementary', 'review', NULL, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_grammar (id, lesson_id, grammar_lesson_id, order_index, curriculum_role)
VALUES ('b4592c81-2b9e-50a0-a88f-5c99ef3dd612'::UUID, '6561a915-c6f4-5898-9c8a-9cba9a1bf3cc'::UUID, 'b9d861f8-83ba-57ce-9d08-a1bbac6e02d2'::UUID, 1, 'introduced')
ON CONFLICT (lesson_id, grammar_lesson_id) DO NOTHING;

INSERT INTO public.lesson_grammar (id, lesson_id, grammar_lesson_id, order_index, curriculum_role)
VALUES ('2a23ad39-9cc4-5bef-ae87-b00beb0f181c'::UUID, '6561a915-c6f4-5898-9c8a-9cba9a1bf3cc'::UUID, 'f00563cf-2314-52b8-a342-6a543644e2a6'::UUID, 2, 'review')
ON CONFLICT (lesson_id, grammar_lesson_id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('51eae484-64b8-5add-a992-3d98b02018e5'::UUID, '6561a915-c6f4-5898-9c8a-9cba9a1bf3cc'::UUID, 'vocabulary', 1, 'Từ mới: 过', NULL, '过', '过 (guo) — đã từng (trợ từ). 我去过上海两次。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"hsk2:过","chinese":"过","pinyin":"guo","meaning":"đã từng (trợ từ)","part_of_speech":"trợ từ","example_chinese":"我去过上海两次。","example_pinyin":"Wǒ qùguo Shànghǎi liǎng cì.","example_meaning_vi":"Tôi đã từng đến Thượng Hải hai lần."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('997b4418-917c-5868-b334-321ad18c33ac'::UUID, '6561a915-c6f4-5898-9c8a-9cba9a1bf3cc'::UUID, 'vocabulary', 2, 'Từ mới: 次', NULL, '次', '次 (cì) — lần. 这是我第一次来中国。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"hsk2:次","chinese":"次","pinyin":"cì","meaning":"lần","part_of_speech":"lượng từ","example_chinese":"这是我第一次来中国。","example_pinyin":"Zhè shì wǒ dì-yī cì lái Zhōngguó.","example_meaning_vi":"Đây là lần đầu tôi đến Trung Quốc."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('b073dd8f-f18e-5ec4-ae22-3d7323e00275'::UUID, '6561a915-c6f4-5898-9c8a-9cba9a1bf3cc'::UUID, 'vocabulary', 3, 'Từ mới: 以前', NULL, '以前', '以前 (yǐqián) — trước đây. 我以前住在河内。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"hsk2:以前","chinese":"以前","pinyin":"yǐqián","meaning":"trước đây","part_of_speech":"danh từ thời gian","example_chinese":"我以前住在河内。","example_pinyin":"Wǒ yǐqián zhù zài Hénèi.","example_meaning_vi":"Trước đây tôi sống ở Hà Nội."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('780546cd-fa67-5ad9-bd26-40448c171cb4'::UUID, '6561a915-c6f4-5898-9c8a-9cba9a1bf3cc'::UUID, 'multiple_choice', 4, '“过” có nghĩa phù hợp nhất là gì?', NULL, 'đã từng (trợ từ)', '过 (guo) nghĩa là “đã từng (trợ từ)”.', NULL, 1, '{"activity_type":"chinese_to_vietnamese","vocabulary_key":"hsk2:过"}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('bee9380d-4e41-5b5a-ae9f-27e20bdb3718'::UUID, '780546cd-fa67-5ad9-bd26-40448c171cb4'::UUID, 'đã từng (trợ từ)', TRUE, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('be7065fe-457e-5bdc-b594-80ada784a172'::UUID, '780546cd-fa67-5ad9-bd26-40448c171cb4'::UUID, 'lần', FALSE, 2)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('83f612c6-32a4-5228-a830-80c466ed2296'::UUID, '780546cd-fa67-5ad9-bd26-40448c171cb4'::UUID, 'trước đây', FALSE, 3)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('0528c209-918f-501a-a05c-ec6e3c053e38'::UUID, '6561a915-c6f4-5898-9c8a-9cba9a1bf3cc'::UUID, 'translation', 5, 'Dịch sang tiếng Trung: “Trước đây tôi từng đến Bắc Kinh.”', NULL, '我以前去过北京。', 'Mẫu câu dùng “过” trong ngữ cảnh của bài.', 'guo', 1, '{"activity_type":"vietnamese_to_chinese","source_lang":"vi","target_lang":"zh","acceptable_answers":["我以前去过北京。"]}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('c2de7c65-b247-5b9b-b732-17df32a6c13d'::UUID, '6561a915-c6f4-5898-9c8a-9cba9a1bf3cc'::UUID, 'sentence_builder', 6, 'Sắp xếp các thành phần thành câu đúng.', NULL, '我以前去过北京。', 'Trật tự đúng tạo thành câu “我以前去过北京。”.', NULL, 1, '{"activity_type":"sentence_ordering","words":["我","以前","去过","北京","。"],"correct_order":["我","以前","去过","北京","。"]}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('7a52bede-b7a6-5236-b3f4-edab4f077df8'::UUID, '6561a915-c6f4-5898-9c8a-9cba9a1bf3cc'::UUID, 'multiple_choice', 7, 'Câu nào kể một trải nghiệm?', NULL, '我以前去过北京。', '过 cho biết hành động từng xảy ra ít nhất một lần.', NULL, 1, '{"activity_type":"grammar_selection","passage":null,"grammar_key":"hsk2:kinh-nghiem"}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('69026442-ec1a-5a44-873b-f093be00bacf'::UUID, '7a52bede-b7a6-5236-b3f4-edab4f077df8'::UUID, '我以前去过北京。', TRUE, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('ca9ec75f-3ccf-51be-9b4c-612616f00d88'::UUID, '7a52bede-b7a6-5236-b3f4-edab4f077df8'::UUID, '。北京去过以前我', FALSE, 2)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('59a849f2-a162-503c-9f76-75c1c65009c6'::UUID, '7a52bede-b7a6-5236-b3f4-edab4f077df8'::UUID, '以前去过北京。我', FALSE, 3)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('7c87ef54-8a92-55f5-901b-eb1556829c88'::UUID, '6561a915-c6f4-5898-9c8a-9cba9a1bf3cc'::UUID, 'speaking', 8, 'Đọc thành tiếng: 我以前去过北京。', NULL, '我以前去过北京。', 'Đọc chậm, giữ đúng thanh điệu và nhịp của cả câu.', NULL, 1, '{"activity_type":"pronunciation","text":"我以前去过北京。","pinyin":"Wǒ yǐqián qùguo Běijīng."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.units (id, course_id, slug, title, description, order_index, status, learning_objectives, content_version)
VALUES ('f2625193-af7f-5b0d-88fe-5ba9201ef641'::UUID, 'f8004ee7-af0d-59a3-abae-19e17034005e'::UUID, 'hsk2-on-tap', 'Ôn tập', 'Kiểm tra và củng cố nội dung đã học.', 3, 'review', '["Ôn từ vựng","Ôn mẫu câu"]'::JSONB, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.chapters (id, unit_id, slug, title, description, order_index, status, learning_objectives, content_version)
VALUES ('b21f37d6-43d5-5bd3-b7e5-c23d833a6b81'::UUID, 'f2625193-af7f-5b0d-88fe-5ba9201ef641'::UUID, 'hsk2-on-tap-chapter', 'Củng cố lộ trình', 'Kiểm tra và củng cố nội dung đã học.', 1, 'review', '["Ôn từ vựng","Ôn mẫu câu"]'::JSONB, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lessons (id, chapter_id, slug, title, description, order_index, xp_reward, status, lesson_type, estimated_minutes, learning_objectives, cultural_note, content_version)
VALUES ('8cb9204b-e0c3-567b-a245-e5a35a459d2c'::UUID, 'b21f37d6-43d5-5bd3-b7e5-c23d833a6b81'::UUID, 'hsk2-review', 'Ôn tập HSK 2', 'Củng cố từ vựng, mẫu câu và khả năng diễn đạt của toàn khóa.', 1, 30, 'review', 'review', 18, '["Vận dụng lại từ vựng trọng tâm","Tự kiểm tra mẫu câu đã học"]'::JSONB, NULL, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('4d28d713-a8e2-5cf7-b1b6-b33231ab2c9f'::UUID, '8cb9204b-e0c3-567b-a245-e5a35a459d2c'::UUID, '49e8e986-a2b6-5ea0-a866-77c1a04c173c'::UUID, 1, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('33695e6a-b57d-5c0e-a4aa-e7e07577f5b6'::UUID, '8cb9204b-e0c3-567b-a245-e5a35a459d2c'::UUID, 'c9d0e5ed-ade3-5749-bf2d-169285a4546d'::UUID, 2, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('acb37af0-a069-546f-81bf-b5a0e418a1dd'::UUID, '8cb9204b-e0c3-567b-a245-e5a35a459d2c'::UUID, '6b626f58-fa26-5e34-966a-140c4d177e85'::UUID, 3, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_grammar (id, lesson_id, grammar_lesson_id, order_index, curriculum_role)
VALUES ('32c51401-7c3c-53ee-96af-1dfd8f1c1425'::UUID, '8cb9204b-e0c3-567b-a245-e5a35a459d2c'::UUID, 'b9d861f8-83ba-57ce-9d08-a1bbac6e02d2'::UUID, 1, 'review')
ON CONFLICT (lesson_id, grammar_lesson_id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('a0562518-d5ef-5722-b965-672201572d2f'::UUID, '8cb9204b-e0c3-567b-a245-e5a35a459d2c'::UUID, 'multiple_choice', 1, '“过” có nghĩa phù hợp nhất là gì?', NULL, 'đã từng (trợ từ)', '过 (guo) nghĩa là “đã từng (trợ từ)”.', NULL, 1, '{"activity_type":"chinese_to_vietnamese","vocabulary_key":"hsk2:过"}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('8035e6ba-85ba-5b1e-8b3f-09e8046bbe72'::UUID, 'a0562518-d5ef-5722-b965-672201572d2f'::UUID, 'trước đây', FALSE, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('00d7f996-3b3f-5f1a-8f42-22d6be0b9a49'::UUID, 'a0562518-d5ef-5722-b965-672201572d2f'::UUID, 'đã từng (trợ từ)', TRUE, 2)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('66cdf5bf-bef7-5ff6-809c-653b4c6ceb43'::UUID, 'a0562518-d5ef-5722-b965-672201572d2f'::UUID, 'lần', FALSE, 3)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('bc8d1d1c-6318-5606-854e-c845fd5de6e0'::UUID, '8cb9204b-e0c3-567b-a245-e5a35a459d2c'::UUID, 'translation', 2, 'Dịch sang tiếng Trung: “Trước đây tôi từng đến Bắc Kinh.”', NULL, '我以前去过北京。', 'Mẫu câu dùng “过” trong ngữ cảnh của bài.', 'guo', 1, '{"activity_type":"vietnamese_to_chinese","source_lang":"vi","target_lang":"zh","acceptable_answers":["我以前去过北京。"]}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('dae75bb3-fd97-56f9-80f2-cdf37f31a04c'::UUID, '8cb9204b-e0c3-567b-a245-e5a35a459d2c'::UUID, 'sentence_builder', 3, 'Sắp xếp các thành phần thành câu đúng.', NULL, '我以前去过北京。', 'Trật tự đúng tạo thành câu “我以前去过北京。”.', NULL, 1, '{"activity_type":"sentence_ordering","words":["我","以前","去过","北京","。"],"correct_order":["我","以前","去过","北京","。"]}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('cba229cc-ad9f-5d1c-9d25-e69aa3d5036e'::UUID, '8cb9204b-e0c3-567b-a245-e5a35a459d2c'::UUID, 'multiple_choice', 4, 'Câu nào kể một trải nghiệm?', NULL, '我以前去过北京。', '过 cho biết hành động từng xảy ra ít nhất một lần.', NULL, 1, '{"activity_type":"grammar_selection","passage":null,"grammar_key":"hsk2:kinh-nghiem"}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('8a487c6f-5644-543e-a5df-a9ec06226af1'::UUID, 'cba229cc-ad9f-5d1c-9d25-e69aa3d5036e'::UUID, '我以前去过北京。', TRUE, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('01bbb95b-eb99-5b09-b195-94dd53e18641'::UUID, 'cba229cc-ad9f-5d1c-9d25-e69aa3d5036e'::UUID, '。北京去过以前我', FALSE, 2)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('8d3a9f87-031d-5327-b5cd-669d3d08a082'::UUID, 'cba229cc-ad9f-5d1c-9d25-e69aa3d5036e'::UUID, '以前去过北京。我', FALSE, 3)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('89c1423e-62ff-53eb-8e00-87480d94ad25'::UUID, '8cb9204b-e0c3-567b-a245-e5a35a459d2c'::UUID, 'speaking', 5, 'Đọc thành tiếng: 我以前去过北京。', NULL, '我以前去过北京。', 'Đọc chậm, giữ đúng thanh điệu và nhịp của cả câu.', NULL, 1, '{"activity_type":"pronunciation","text":"我以前去过北京。","pinyin":"Wǒ yǐqián qùguo Běijīng."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.content_batches (id, batch_key, version, migration_name, manifest_checksum, expected_counts)
VALUES ('7bce30a6-8303-512f-8922-087ee28b1409'::UUID, 'batch-03-hsk2', 1, '20260729120000_content_batch_03_hsk2', 'dd68faa3a62a86e1b9fe40153613e50d7c83256f1fc7211552016820d7e2026b', '{"courses":1,"units":3,"chapters":3,"lessons":5,"vocabulary":12,"grammar":4,"characters":0,"exercises":37,"options":30}'::JSONB)
ON CONFLICT (batch_key, version) DO NOTHING;

DO $content_validation$
BEGIN
  IF (SELECT COUNT(*) FROM public.courses WHERE id = ANY(ARRAY['f8004ee7-af0d-59a3-abae-19e17034005e'::UUID]::UUID[])) <> 1 THEN
    RAISE EXCEPTION 'Content batch batch-03-hsk2 is missing managed courses rows';
  END IF;
  IF (SELECT COUNT(*) FROM public.units WHERE id = ANY(ARRAY['3165f66c-69ef-5280-bc64-c69ce3f43e17'::UUID, '5cb08c7b-fddd-5eb1-9e92-9c02d3650d66'::UUID, 'f2625193-af7f-5b0d-88fe-5ba9201ef641'::UUID]::UUID[])) <> 3 THEN
    RAISE EXCEPTION 'Content batch batch-03-hsk2 is missing managed units rows';
  END IF;
  IF (SELECT COUNT(*) FROM public.chapters WHERE id = ANY(ARRAY['2301bed6-d4c8-5ad4-9c85-fb6eb2338cb8'::UUID, 'd10f0446-949f-5ec7-b8b9-063049cf5f9f'::UUID, 'b21f37d6-43d5-5bd3-b7e5-c23d833a6b81'::UUID]::UUID[])) <> 3 THEN
    RAISE EXCEPTION 'Content batch batch-03-hsk2 is missing managed chapters rows';
  END IF;
  IF (SELECT COUNT(*) FROM public.lessons WHERE id = ANY(ARRAY['1f7cc17b-b285-54ef-a7e7-42c311ad2d0d'::UUID, 'd5596545-fb2f-520a-8615-97e8a1166a68'::UUID, 'ef88f931-69bd-5578-ba49-3320abdbec2f'::UUID, '6561a915-c6f4-5898-9c8a-9cba9a1bf3cc'::UUID, '8cb9204b-e0c3-567b-a245-e5a35a459d2c'::UUID]::UUID[])) <> 5 THEN
    RAISE EXCEPTION 'Content batch batch-03-hsk2 is missing managed lessons rows';
  END IF;
  IF (SELECT COUNT(*) FROM public.vocabulary WHERE id = ANY(ARRAY['ccda7368-3f45-55aa-8ee9-1b7e05fc778a'::UUID, '3f622e4f-0b4d-50b6-bbf3-237163fa09f7'::UUID, '7fa9e077-00c0-59ef-be56-cbf2e5837a39'::UUID, '55a5d0c1-6a48-5778-9b4b-0593be2643e2'::UUID, '750340d7-a995-5797-b340-2ee02a3c16c3'::UUID, '5ec7ad7b-583c-5831-9f5a-2e2baa9d68ef'::UUID, 'ac393974-ecd1-57e6-9181-5a91c5689c7b'::UUID, '85a93400-d896-59b8-aaaf-e7c6fbbec466'::UUID, '52360e08-9bd9-526f-8d53-6f361f6bab14'::UUID, '49e8e986-a2b6-5ea0-a866-77c1a04c173c'::UUID, 'c9d0e5ed-ade3-5749-bf2d-169285a4546d'::UUID, '6b626f58-fa26-5e34-966a-140c4d177e85'::UUID]::UUID[])) <> 12 THEN
    RAISE EXCEPTION 'Content batch batch-03-hsk2 is missing managed vocabulary rows';
  END IF;
  IF (SELECT COUNT(*) FROM public.grammar_lessons WHERE id = ANY(ARRAY['c51a3559-cf53-5d31-bb97-16cd2963f6e6'::UUID, 'b1e4303e-0918-5d3c-ad51-17fb1fe42a69'::UUID, 'f00563cf-2314-52b8-a342-6a543644e2a6'::UUID, 'b9d861f8-83ba-57ce-9d08-a1bbac6e02d2'::UUID]::UUID[])) <> 4 THEN
    RAISE EXCEPTION 'Content batch batch-03-hsk2 is missing managed grammar_lessons rows';
  END IF;
  IF (SELECT COUNT(*) FROM public.exercises WHERE id = ANY(ARRAY['fa0b7bd9-90d4-50f1-aa61-766c19de6be6'::UUID, '8945524d-b9c7-59c2-826e-349921fbafcc'::UUID, 'a283e6d9-21da-564b-bad8-5a359dbdfff5'::UUID, 'f2805704-2ad1-5c19-bfd1-76cb77a7e988'::UUID, '6a7b047c-cad0-5713-8a09-d6ccc9c1df3c'::UUID, 'c9a2463a-94b6-57b0-bee3-875987503dbd'::UUID, '6ad5662c-e34c-5013-82b2-550cc9752e83'::UUID, '9bf6f745-01d2-5147-b36f-3324c1abac46'::UUID, 'd62f4e85-d000-5af3-8731-a63d62189c3e'::UUID, 'ad3bfde1-89da-52d4-8fc5-c1f66db6d71d'::UUID, 'e13644ee-af9d-5e02-a428-269aa6e45b94'::UUID, 'adbe1d71-0c31-5e6e-8fe5-8028496ddb35'::UUID, 'a5d88f11-6815-5c43-b11b-8b2201ab11b6'::UUID, 'd630e972-6c8e-5bb4-97d4-e5c7d835101e'::UUID, 'dafab879-8a02-5ad2-b4a3-48b18ea6be47'::UUID, '16b9abf6-d356-5153-8e06-d650826d27d6'::UUID, '8eb65b6a-9d69-5639-8fc4-643103cadc5b'::UUID, '611acb8f-7ac9-540e-ae06-2294a919177b'::UUID, '06d026c9-3f90-5bde-9d4a-5cf68328791a'::UUID, '9c5e4bfc-4d05-5239-a0ab-9afca811e97c'::UUID, '1ecc0af3-6c51-54fa-a001-bc2bb14e630f'::UUID, '68e0a11e-2188-54b1-9e1c-a6e28ef50d95'::UUID, 'be32db94-2992-531a-8707-808797a10bad'::UUID, '75699a7f-3923-58c7-b97e-d0ce66125af8'::UUID, '51eae484-64b8-5add-a992-3d98b02018e5'::UUID, '997b4418-917c-5868-b334-321ad18c33ac'::UUID, 'b073dd8f-f18e-5ec4-ae22-3d7323e00275'::UUID, '780546cd-fa67-5ad9-bd26-40448c171cb4'::UUID, '0528c209-918f-501a-a05c-ec6e3c053e38'::UUID, 'c2de7c65-b247-5b9b-b732-17df32a6c13d'::UUID, '7a52bede-b7a6-5236-b3f4-edab4f077df8'::UUID, '7c87ef54-8a92-55f5-901b-eb1556829c88'::UUID, 'a0562518-d5ef-5722-b965-672201572d2f'::UUID, 'bc8d1d1c-6318-5606-854e-c845fd5de6e0'::UUID, 'dae75bb3-fd97-56f9-80f2-cdf37f31a04c'::UUID, 'cba229cc-ad9f-5d1c-9d25-e69aa3d5036e'::UUID, '89c1423e-62ff-53eb-8e00-87480d94ad25'::UUID]::UUID[])) <> 37 THEN
    RAISE EXCEPTION 'Content batch batch-03-hsk2 is missing managed exercises rows';
  END IF;
  IF (SELECT COUNT(*) FROM public.exercise_options WHERE id = ANY(ARRAY['ae98b58e-a09d-50af-bb9b-e2abcc507443'::UUID, 'd30c1b1f-e0cc-56f5-936d-651feeb89f8a'::UUID, 'a80870e2-435d-53a4-ac72-9c00bfaa18e7'::UUID, 'd4eba427-7732-5518-8199-bd694678db86'::UUID, '56e3c350-7ea9-548a-bd4e-a4662550cc32'::UUID, 'ad9d0984-2a44-5325-999f-e4ac8197b782'::UUID, '338f9b94-a6e9-586b-9b12-ed0dbcd36f4b'::UUID, '5b135faa-725a-5216-8edd-5f1ffa941e24'::UUID, 'f9f1813e-6eb2-5154-98b1-85162940a685'::UUID, 'b4626abb-b0cc-5622-b79b-a2f360a67d00'::UUID, '7bd3de8a-0d8c-5568-a301-af0117a46907'::UUID, '4df4c8cb-84b0-5b31-86ea-ccec6976e40c'::UUID, '7a1b6aee-1088-5bfc-b07a-7b80572c4af7'::UUID, '1cb8c3f6-b0ae-52bf-a013-7ee08c37710c'::UUID, '9917dd63-2ee7-565b-a0bd-cdfb89d38539'::UUID, '2104f02c-5032-5f9a-a210-6397134d8b73'::UUID, 'd9d65d90-5596-5adb-98bc-7ba441fd3fd8'::UUID, '2fb8a3e9-e881-5d1a-ba21-e6ef798e1d5f'::UUID, 'bee9380d-4e41-5b5a-ae9f-27e20bdb3718'::UUID, 'be7065fe-457e-5bdc-b594-80ada784a172'::UUID, '83f612c6-32a4-5228-a830-80c466ed2296'::UUID, '69026442-ec1a-5a44-873b-f093be00bacf'::UUID, 'ca9ec75f-3ccf-51be-9b4c-612616f00d88'::UUID, '59a849f2-a162-503c-9f76-75c1c65009c6'::UUID, '8035e6ba-85ba-5b1e-8b3f-09e8046bbe72'::UUID, '00d7f996-3b3f-5f1a-8f42-22d6be0b9a49'::UUID, '66cdf5bf-bef7-5ff6-809c-653b4c6ceb43'::UUID, '8a487c6f-5644-543e-a5df-a9ec06226af1'::UUID, '01bbb95b-eb99-5b09-b195-94dd53e18641'::UUID, '8d3a9f87-031d-5327-b5cd-669d3d08a082'::UUID]::UUID[])) <> 30 THEN
    RAISE EXCEPTION 'Content batch batch-03-hsk2 is missing managed exercise_options rows';
  END IF;
  IF EXISTS (
    SELECT 1 FROM public.lessons AS lesson
    WHERE lesson.id = ANY(ARRAY['1f7cc17b-b285-54ef-a7e7-42c311ad2d0d'::UUID, 'd5596545-fb2f-520a-8615-97e8a1166a68'::UUID, 'ef88f931-69bd-5578-ba49-3320abdbec2f'::UUID, '6561a915-c6f4-5898-9c8a-9cba9a1bf3cc'::UUID, '8cb9204b-e0c3-567b-a245-e5a35a459d2c'::UUID]::UUID[])
      AND NOT EXISTS (
        SELECT 1 FROM public.exercises AS exercise
        WHERE exercise.lesson_id = lesson.id
      )
  ) THEN
    RAISE EXCEPTION 'Content batch batch-03-hsk2 contains a lesson without exercises';
  END IF;
  IF EXISTS (
    SELECT 1
    FROM public.lessons AS lesson
    JOIN public.exercises AS exercise ON exercise.lesson_id = lesson.id
    WHERE lesson.id = ANY(ARRAY['1f7cc17b-b285-54ef-a7e7-42c311ad2d0d'::UUID, 'd5596545-fb2f-520a-8615-97e8a1166a68'::UUID, 'ef88f931-69bd-5578-ba49-3320abdbec2f'::UUID, '6561a915-c6f4-5898-9c8a-9cba9a1bf3cc'::UUID, '8cb9204b-e0c3-567b-a245-e5a35a459d2c'::UUID]::UUID[])
      AND lesson.status = 'published'
      AND exercise.exercise_type = 'listening'
      AND NULLIF(BTRIM(exercise.question_audio_url), '') IS NULL
  ) THEN
    RAISE EXCEPTION 'Published listening exercise is missing playable audio';
  END IF;
  IF EXISTS (
    SELECT 1
    FROM public.exercises AS exercise
    WHERE exercise.id = ANY(ARRAY['fa0b7bd9-90d4-50f1-aa61-766c19de6be6'::UUID, '8945524d-b9c7-59c2-826e-349921fbafcc'::UUID, 'a283e6d9-21da-564b-bad8-5a359dbdfff5'::UUID, 'f2805704-2ad1-5c19-bfd1-76cb77a7e988'::UUID, '6a7b047c-cad0-5713-8a09-d6ccc9c1df3c'::UUID, 'c9a2463a-94b6-57b0-bee3-875987503dbd'::UUID, '6ad5662c-e34c-5013-82b2-550cc9752e83'::UUID, '9bf6f745-01d2-5147-b36f-3324c1abac46'::UUID, 'd62f4e85-d000-5af3-8731-a63d62189c3e'::UUID, 'ad3bfde1-89da-52d4-8fc5-c1f66db6d71d'::UUID, 'e13644ee-af9d-5e02-a428-269aa6e45b94'::UUID, 'adbe1d71-0c31-5e6e-8fe5-8028496ddb35'::UUID, 'a5d88f11-6815-5c43-b11b-8b2201ab11b6'::UUID, 'd630e972-6c8e-5bb4-97d4-e5c7d835101e'::UUID, 'dafab879-8a02-5ad2-b4a3-48b18ea6be47'::UUID, '16b9abf6-d356-5153-8e06-d650826d27d6'::UUID, '8eb65b6a-9d69-5639-8fc4-643103cadc5b'::UUID, '611acb8f-7ac9-540e-ae06-2294a919177b'::UUID, '06d026c9-3f90-5bde-9d4a-5cf68328791a'::UUID, '9c5e4bfc-4d05-5239-a0ab-9afca811e97c'::UUID, '1ecc0af3-6c51-54fa-a001-bc2bb14e630f'::UUID, '68e0a11e-2188-54b1-9e1c-a6e28ef50d95'::UUID, 'be32db94-2992-531a-8707-808797a10bad'::UUID, '75699a7f-3923-58c7-b97e-d0ce66125af8'::UUID, '51eae484-64b8-5add-a992-3d98b02018e5'::UUID, '997b4418-917c-5868-b334-321ad18c33ac'::UUID, 'b073dd8f-f18e-5ec4-ae22-3d7323e00275'::UUID, '780546cd-fa67-5ad9-bd26-40448c171cb4'::UUID, '0528c209-918f-501a-a05c-ec6e3c053e38'::UUID, 'c2de7c65-b247-5b9b-b732-17df32a6c13d'::UUID, '7a52bede-b7a6-5236-b3f4-edab4f077df8'::UUID, '7c87ef54-8a92-55f5-901b-eb1556829c88'::UUID, 'a0562518-d5ef-5722-b965-672201572d2f'::UUID, 'bc8d1d1c-6318-5606-854e-c845fd5de6e0'::UUID, 'dae75bb3-fd97-56f9-80f2-cdf37f31a04c'::UUID, 'cba229cc-ad9f-5d1c-9d25-e69aa3d5036e'::UUID, '89c1423e-62ff-53eb-8e00-87480d94ad25'::UUID]::UUID[])
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
    WHERE link.lesson_id = ANY(ARRAY['1f7cc17b-b285-54ef-a7e7-42c311ad2d0d'::UUID, 'd5596545-fb2f-520a-8615-97e8a1166a68'::UUID, 'ef88f931-69bd-5578-ba49-3320abdbec2f'::UUID, '6561a915-c6f4-5898-9c8a-9cba9a1bf3cc'::UUID, '8cb9204b-e0c3-567b-a245-e5a35a459d2c'::UUID]::UUID[])
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
