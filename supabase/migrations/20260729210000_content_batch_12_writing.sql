-- Generated from content/manifests/12_writing.json.
-- Do not hand-edit this migration; edit the manifest and regenerate.
-- Additive and idempotent: deterministic IDs plus ON CONFLICT DO NOTHING.

BEGIN;

INSERT INTO public.courses (id, slug, title, title_zh, description, level, status, order_index, learning_objectives, estimated_minutes, content_version)
VALUES ('2b6c3582-f92d-53e5-984d-0b29ad76be52'::UUID, 'chinese-characters-writing', 'Chinese Characters and Writing', '汉字书写', 'Nền tảng cấu tạo, bộ thủ và quy tắc viết chữ Hán.', 'starter', 'review', 11, '["Nhận biết nét và bộ thủ","Phân tích cấu tạo chữ","Viết theo thứ tự nét chuẩn"]'::JSONB, 78, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.units (id, course_id, slug, title, description, order_index, status, learning_objectives, content_version)
VALUES ('f509e18b-d0bf-5a9a-9bbf-0d9a40c4b3b0'::UUID, '2b6c3582-f92d-53e5-984d-0b29ad76be52'::UUID, 'writing-nen-tang', 'Nền tảng', 'Xây dựng ngôn ngữ cốt lõi của lộ trình.', 1, 'review', '["Nhận biết nét và bộ thủ","Phân tích cấu tạo chữ"]'::JSONB, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.chapters (id, unit_id, slug, title, description, order_index, status, learning_objectives, content_version)
VALUES ('1cf17875-7391-597f-bd21-3ebfe0077fb4'::UUID, 'f509e18b-d0bf-5a9a-9bbf-0d9a40c4b3b0'::UUID, 'writing-nen-tang-chapter', 'Khái niệm cốt lõi', 'Xây dựng ngôn ngữ cốt lõi của lộ trình.', 1, 'review', '["Nhận biết nét và bộ thủ","Phân tích cấu tạo chữ"]'::JSONB, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lessons (id, chapter_id, slug, title, description, order_index, xp_reward, status, lesson_type, estimated_minutes, learning_objectives, cultural_note, content_version)
VALUES ('179452a8-cc0b-519a-9249-9aa9a853ad58'::UUID, '1cf17875-7391-597f-bd21-3ebfe0077fb4'::UUID, 'net-co-ban', '基本笔画 — Nét cơ bản', 'Nhận biết các nét thường gặp.', 1, 25, 'review', 'standard', 15, '["Gọi tên và phân biệt nét"]'::JSONB, 'Không có tài sản thứ tự nét giả; bài chỉ dạy quy tắc văn bản.', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('e231bc5b-6edc-57d2-952d-426692330865'::UUID, 'writing:横', '横', 'héng', 'nét ngang', 'horizontal stroke', 'starter', 'net-co-ban', 'danh từ', '写“一”时只有一个横。', 'Xiě “yī” shí zhǐ yǒu yí ge héng.', 'Khi viết “一” chỉ có một nét ngang.', NULL, 'review', '179452a8-cc0b-519a-9249-9aa9a853ad58'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('1b870e06-0709-5108-b21c-9e3922bf1fd6'::UUID, '179452a8-cc0b-519a-9249-9aa9a853ad58'::UUID, 'e231bc5b-6edc-57d2-952d-426692330865'::UUID, 1, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('e1f96a99-fec7-5ec5-920e-cb466e390eef'::UUID, 'writing:竖', '竖', 'shù', 'nét sổ', 'vertical stroke', 'starter', 'net-co-ban', 'danh từ', '“十”有一横一竖。', '“Shí” yǒu yì héng yí shù.', 'Chữ “十” có một nét ngang và một nét sổ.', NULL, 'review', '179452a8-cc0b-519a-9249-9aa9a853ad58'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('e94a31da-0af9-53f9-935c-8e85e4abc0d6'::UUID, '179452a8-cc0b-519a-9249-9aa9a853ad58'::UUID, 'e1f96a99-fec7-5ec5-920e-cb466e390eef'::UUID, 2, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('037034d0-80dd-5c33-86b2-fee2384f6939'::UUID, 'writing:捺', '捺', 'nà', 'nét mác', 'right-falling stroke', 'starter', 'net-co-ban', 'danh từ', '“人”的第二笔是捺。', '“Rén” de dì-èr bǐ shì nà.', 'Nét thứ hai của chữ “人” là nét mác.', NULL, 'review', '179452a8-cc0b-519a-9249-9aa9a853ad58'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('a75f8869-9be6-5c1c-87e5-5763b7383eba'::UUID, '179452a8-cc0b-519a-9249-9aa9a853ad58'::UUID, '037034d0-80dd-5c33-86b2-fee2384f6939'::UUID, 3, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.grammar_lessons (id, content_key, title, pattern, explanation, example_chinese, example_pinyin, example_meaning, level, status, usage_note, content_version)
VALUES ('65a50b64-e9c5-5f11-b4f6-3cb906cc0b45'::UUID, 'writing:net-co-ban', 'Đếm nét với 有', 'chữ + 有 + số + lượng từ 笔', '笔 là lượng từ dùng để đếm nét chữ.', '“十”有两笔。', '“Shí” yǒu liǎng bǐ.', 'Chữ “十” có hai nét.', 'starter', 'review', NULL, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_grammar (id, lesson_id, grammar_lesson_id, order_index, curriculum_role)
VALUES ('c1985974-74e5-5fb0-a6fb-778a7d751099'::UUID, '179452a8-cc0b-519a-9249-9aa9a853ad58'::UUID, '65a50b64-e9c5-5f11-b4f6-3cb906cc0b45'::UUID, 1, 'introduced')
ON CONFLICT (lesson_id, grammar_lesson_id) DO NOTHING;

INSERT INTO public.characters (id, character, pinyin, meaning_vi, radical, stroke_count, stroke_order, level, status, component_breakdown, common_words, content_version)
VALUES ('1a1deac2-d007-5b94-8cf0-bed5cc3cae14'::UUID, '木', 'mù', 'cây, gỗ', '木', 4, NULL, 'starter', 'review', '{"note":"Chữ độc thể, cũng dùng làm bộ Mộc."}'::JSONB, '["木头","树木"]'::JSONB, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_characters (id, lesson_id, character_id, order_index, curriculum_role)
VALUES ('d64d198f-36e6-5f3c-9f02-476419ed3c08'::UUID, '179452a8-cc0b-519a-9249-9aa9a853ad58'::UUID, '1a1deac2-d007-5b94-8cf0-bed5cc3cae14'::UUID, 1, 'introduced')
ON CONFLICT (lesson_id, character_id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('48f3ec26-769c-5054-884d-e6939c052097'::UUID, '179452a8-cc0b-519a-9249-9aa9a853ad58'::UUID, 'vocabulary', 1, 'Từ mới: 横', NULL, '横', '横 (héng) — nét ngang. 写“一”时只有一个横。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"writing:横","chinese":"横","pinyin":"héng","meaning":"nét ngang","part_of_speech":"danh từ","example_chinese":"写“一”时只有一个横。","example_pinyin":"Xiě “yī” shí zhǐ yǒu yí ge héng.","example_meaning_vi":"Khi viết “一” chỉ có một nét ngang."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('6231a215-487f-5c6c-9b9d-8cc30dd490fb'::UUID, '179452a8-cc0b-519a-9249-9aa9a853ad58'::UUID, 'vocabulary', 2, 'Từ mới: 竖', NULL, '竖', '竖 (shù) — nét sổ. “十”有一横一竖。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"writing:竖","chinese":"竖","pinyin":"shù","meaning":"nét sổ","part_of_speech":"danh từ","example_chinese":"“十”有一横一竖。","example_pinyin":"“Shí” yǒu yì héng yí shù.","example_meaning_vi":"Chữ “十” có một nét ngang và một nét sổ."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('f5281d2f-1b43-5cf7-9d70-1e09e9fb75f2'::UUID, '179452a8-cc0b-519a-9249-9aa9a853ad58'::UUID, 'vocabulary', 3, 'Từ mới: 捺', NULL, '捺', '捺 (nà) — nét mác. “人”的第二笔是捺。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"writing:捺","chinese":"捺","pinyin":"nà","meaning":"nét mác","part_of_speech":"danh từ","example_chinese":"“人”的第二笔是捺。","example_pinyin":"“Rén” de dì-èr bǐ shì nà.","example_meaning_vi":"Nét thứ hai của chữ “人” là nét mác."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('7d6c3afd-a884-5bb4-bfa8-656ef51d96a5'::UUID, '179452a8-cc0b-519a-9249-9aa9a853ad58'::UUID, 'multiple_choice', 4, '“横” có nghĩa phù hợp nhất là gì?', NULL, 'nét ngang', '横 (héng) nghĩa là “nét ngang”.', NULL, 1, '{"activity_type":"chinese_to_vietnamese","vocabulary_key":"writing:横"}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('6417cbf0-3511-59cb-9fcc-dbe53fe44b9e'::UUID, '7d6c3afd-a884-5bb4-bfa8-656ef51d96a5'::UUID, 'nét ngang', TRUE, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('43b5c577-2070-5c2b-b728-d7d3aff1e943'::UUID, '7d6c3afd-a884-5bb4-bfa8-656ef51d96a5'::UUID, 'nét sổ', FALSE, 2)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('900593bb-ee8a-5adb-93f9-5c74d7ea2bd3'::UUID, '7d6c3afd-a884-5bb4-bfa8-656ef51d96a5'::UUID, 'nét mác', FALSE, 3)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('71ab321e-bb34-5103-bd8f-c0c0f4f5c3bb'::UUID, '179452a8-cc0b-519a-9249-9aa9a853ad58'::UUID, 'translation', 5, 'Dịch sang tiếng Trung: “Chữ “十” có hai nét.”', NULL, '“十”有两笔。', 'Mẫu câu dùng “横” trong ngữ cảnh của bài.', 'héng', 1, '{"activity_type":"vietnamese_to_chinese","source_lang":"vi","target_lang":"zh","acceptable_answers":["“十”有两笔。"]}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('87a390bf-ce88-5ad9-840f-63bfcd67c31b'::UUID, '179452a8-cc0b-519a-9249-9aa9a853ad58'::UUID, 'sentence_builder', 6, 'Sắp xếp các thành phần thành câu đúng.', NULL, '“十”有两笔。', 'Trật tự đúng tạo thành câu ““十”有两笔。”.', NULL, 1, '{"activity_type":"sentence_ordering","words":["“十”","有","两","笔","。"],"correct_order":["“十”","有","两","笔","。"]}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('9bbd315c-5986-5ab5-a2f7-1935e1b72f4a'::UUID, '179452a8-cc0b-519a-9249-9aa9a853ad58'::UUID, 'multiple_choice', 7, 'Câu nào đếm đúng số nét của 十?', NULL, '“十”有两笔。', '笔 là lượng từ dùng để đếm nét chữ.', NULL, 1, '{"activity_type":"grammar_selection","passage":null,"grammar_key":"writing:net-co-ban"}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('c6fc2368-0736-57bd-84e7-f84da9fd7f39'::UUID, '9bbd315c-5986-5ab5-a2f7-1935e1b72f4a'::UUID, '“十”有两笔。', TRUE, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('ff8f054e-e540-5c94-86c0-900c0c6f99bf'::UUID, '9bbd315c-5986-5ab5-a2f7-1935e1b72f4a'::UUID, '。笔两有“十”', FALSE, 2)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('ceb3db12-74e5-51d9-bcb0-faad7af603fe'::UUID, '9bbd315c-5986-5ab5-a2f7-1935e1b72f4a'::UUID, '有两笔。“十”', FALSE, 3)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('2d3cffa4-0246-5c81-aed6-acd4c27100f9'::UUID, '179452a8-cc0b-519a-9249-9aa9a853ad58'::UUID, 'speaking', 8, 'Đọc thành tiếng: “十”有两笔。', NULL, '“十”有两笔。', 'Đọc chậm, giữ đúng thanh điệu và nhịp của cả câu.', NULL, 1, '{"activity_type":"pronunciation","text":"“十”有两笔。","pinyin":"“Shí” yǒu liǎng bǐ."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lessons (id, chapter_id, slug, title, description, order_index, xp_reward, status, lesson_type, estimated_minutes, learning_objectives, cultural_note, content_version)
VALUES ('e7252496-0f1f-563e-a5d5-b2b12193c76f'::UUID, '1cf17875-7391-597f-bd21-3ebfe0077fb4'::UUID, 'thu-tu-net', '笔顺规则 — Thứ tự nét', 'Học trên-trước-dưới-sau và trái-trước-phải-sau.', 2, 25, 'review', 'standard', 15, '["Áp dụng quy tắc nét cơ bản"]'::JSONB, 'Quy tắc chung có ngoại lệ; cần đối chiếu từ điển nét chuẩn khi xuất bản.', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('cbf18eb3-1969-5017-a2c3-78ed21d0ab89'::UUID, 'writing:笔顺', '笔顺', 'bǐshùn', 'thứ tự nét', 'stroke order', 'starter', 'thu-tu-net', 'danh từ', '正确的笔顺有助于写好汉字。', 'Zhèngquè de bǐshùn yǒuzhùyú xiě hǎo Hànzì.', 'Thứ tự nét đúng giúp viết chữ Hán đẹp.', NULL, 'review', 'e7252496-0f1f-563e-a5d5-b2b12193c76f'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('5889bdb3-3c9b-5a3d-9507-63803921c28c'::UUID, 'e7252496-0f1f-563e-a5d5-b2b12193c76f'::UUID, 'cbf18eb3-1969-5017-a2c3-78ed21d0ab89'::UUID, 1, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('946845cd-d026-58fe-874a-7f4768bdffbf'::UUID, 'writing:先', '先', 'xiān', 'trước', 'first', 'starter', 'thu-tu-net', 'phó từ', '写“二”时先写上面的横。', 'Xiě “èr” shí xiān xiě shàngmiàn de héng.', 'Khi viết “二”, viết nét ngang trên trước.', NULL, 'review', 'e7252496-0f1f-563e-a5d5-b2b12193c76f'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('80425fa0-1476-589c-9431-5eea06ee0fa0'::UUID, 'e7252496-0f1f-563e-a5d5-b2b12193c76f'::UUID, '946845cd-d026-58fe-874a-7f4768bdffbf'::UUID, 2, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('7e72e026-e0cd-5890-9139-4e3bb022b8a8'::UUID, 'writing:后', '后', 'hòu', 'sau', 'after', 'starter', 'thu-tu-net', 'danh từ/phó từ', '一般先写左边，后写右边。', 'Yìbān xiān xiě zuǒbian, hòu xiě yòubian.', 'Thông thường viết bên trái trước, bên phải sau.', NULL, 'review', 'e7252496-0f1f-563e-a5d5-b2b12193c76f'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('f26c1c48-bf43-5ee8-9371-f7660803bfd6'::UUID, 'e7252496-0f1f-563e-a5d5-b2b12193c76f'::UUID, '7e72e026-e0cd-5890-9139-4e3bb022b8a8'::UUID, 3, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('e115fa99-6563-5d29-abdf-fc25aef77f78'::UUID, 'e7252496-0f1f-563e-a5d5-b2b12193c76f'::UUID, 'e231bc5b-6edc-57d2-952d-426692330865'::UUID, 4, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('2e29da2e-446d-5bd3-a0b1-b37144d17246'::UUID, 'e7252496-0f1f-563e-a5d5-b2b12193c76f'::UUID, 'e1f96a99-fec7-5ec5-920e-cb466e390eef'::UUID, 5, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('f02f1010-b402-581c-8947-044cf045b5ff'::UUID, 'e7252496-0f1f-563e-a5d5-b2b12193c76f'::UUID, '037034d0-80dd-5c33-86b2-fee2384f6939'::UUID, 6, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.grammar_lessons (id, content_key, title, pattern, explanation, example_chinese, example_pinyin, example_meaning, level, status, usage_note, content_version)
VALUES ('b5ba8e6b-8f37-506a-8b3c-8a7b39aee0f6'::UUID, 'writing:thu-tu-net', 'Trình tự với 先…后…', '先 + bước 1，后 + bước 2', 'Cấu trúc mô tả thứ tự hai thao tác.', '写“木”时先横后竖。', 'Xiě “mù” shí xiān héng hòu shù.', 'Khi viết “木”, nét ngang trước, nét sổ sau.', 'starter', 'review', NULL, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_grammar (id, lesson_id, grammar_lesson_id, order_index, curriculum_role)
VALUES ('241b8a71-389f-58e7-8893-cfed9392967a'::UUID, 'e7252496-0f1f-563e-a5d5-b2b12193c76f'::UUID, 'b5ba8e6b-8f37-506a-8b3c-8a7b39aee0f6'::UUID, 1, 'introduced')
ON CONFLICT (lesson_id, grammar_lesson_id) DO NOTHING;

INSERT INTO public.lesson_grammar (id, lesson_id, grammar_lesson_id, order_index, curriculum_role)
VALUES ('066e14fb-f14e-5663-96d0-ad87510649f5'::UUID, 'e7252496-0f1f-563e-a5d5-b2b12193c76f'::UUID, '65a50b64-e9c5-5f11-b4f6-3cb906cc0b45'::UUID, 2, 'review')
ON CONFLICT (lesson_id, grammar_lesson_id) DO NOTHING;

INSERT INTO public.characters (id, character, pinyin, meaning_vi, radical, stroke_count, stroke_order, level, status, component_breakdown, common_words, content_version)
VALUES ('f72a323a-756a-5c91-a96b-0bb41c1d3fc5'::UUID, '明', 'míng', 'sáng, rõ', '日', 8, NULL, 'starter', 'review', '{"left":"日 (mặt trời)","right":"月 (mặt trăng)"}'::JSONB, '["明天","明白"]'::JSONB, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_characters (id, lesson_id, character_id, order_index, curriculum_role)
VALUES ('d353bbc3-4610-541c-940c-1d1d03eab803'::UUID, 'e7252496-0f1f-563e-a5d5-b2b12193c76f'::UUID, 'f72a323a-756a-5c91-a96b-0bb41c1d3fc5'::UUID, 1, 'introduced')
ON CONFLICT (lesson_id, character_id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('8e51fc47-961c-5d2a-b1aa-4091a21190ee'::UUID, 'e7252496-0f1f-563e-a5d5-b2b12193c76f'::UUID, 'vocabulary', 1, 'Từ mới: 笔顺', NULL, '笔顺', '笔顺 (bǐshùn) — thứ tự nét. 正确的笔顺有助于写好汉字。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"writing:笔顺","chinese":"笔顺","pinyin":"bǐshùn","meaning":"thứ tự nét","part_of_speech":"danh từ","example_chinese":"正确的笔顺有助于写好汉字。","example_pinyin":"Zhèngquè de bǐshùn yǒuzhùyú xiě hǎo Hànzì.","example_meaning_vi":"Thứ tự nét đúng giúp viết chữ Hán đẹp."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('cbe0f7f4-64d3-55b3-8c84-9b8407baed20'::UUID, 'e7252496-0f1f-563e-a5d5-b2b12193c76f'::UUID, 'vocabulary', 2, 'Từ mới: 先', NULL, '先', '先 (xiān) — trước. 写“二”时先写上面的横。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"writing:先","chinese":"先","pinyin":"xiān","meaning":"trước","part_of_speech":"phó từ","example_chinese":"写“二”时先写上面的横。","example_pinyin":"Xiě “èr” shí xiān xiě shàngmiàn de héng.","example_meaning_vi":"Khi viết “二”, viết nét ngang trên trước."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('f74a71a3-aa2b-5f48-8701-9b787d732408'::UUID, 'e7252496-0f1f-563e-a5d5-b2b12193c76f'::UUID, 'vocabulary', 3, 'Từ mới: 后', NULL, '后', '后 (hòu) — sau. 一般先写左边，后写右边。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"writing:后","chinese":"后","pinyin":"hòu","meaning":"sau","part_of_speech":"danh từ/phó từ","example_chinese":"一般先写左边，后写右边。","example_pinyin":"Yìbān xiān xiě zuǒbian, hòu xiě yòubian.","example_meaning_vi":"Thông thường viết bên trái trước, bên phải sau."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('58ea8d53-16db-510f-a634-67760fde249a'::UUID, 'e7252496-0f1f-563e-a5d5-b2b12193c76f'::UUID, 'multiple_choice', 4, '“笔顺” có nghĩa phù hợp nhất là gì?', NULL, 'thứ tự nét', '笔顺 (bǐshùn) nghĩa là “thứ tự nét”.', NULL, 1, '{"activity_type":"chinese_to_vietnamese","vocabulary_key":"writing:笔顺"}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('5b274db0-4da6-52e5-b540-cdf7104e50d4'::UUID, '58ea8d53-16db-510f-a634-67760fde249a'::UUID, 'trước', FALSE, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('f3f90ceb-b758-542c-8f37-baaaf3448375'::UUID, '58ea8d53-16db-510f-a634-67760fde249a'::UUID, 'sau', FALSE, 2)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('7b7a1b12-f0a8-5041-9c67-a2b0f95f6450'::UUID, '58ea8d53-16db-510f-a634-67760fde249a'::UUID, 'thứ tự nét', TRUE, 3)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('004bc4d4-9cfc-5b6c-92b8-15cb9614c6ad'::UUID, 'e7252496-0f1f-563e-a5d5-b2b12193c76f'::UUID, 'translation', 5, 'Dịch sang tiếng Trung: “Khi viết “木”, nét ngang trước, nét sổ sau.”', NULL, '写“木”时先横后竖。', 'Mẫu câu dùng “笔顺” trong ngữ cảnh của bài.', 'bǐshùn', 1, '{"activity_type":"vietnamese_to_chinese","source_lang":"vi","target_lang":"zh","acceptable_answers":["写“木”时先横后竖。"]}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('762327b6-a3d7-5586-809c-4c70c38e8d98'::UUID, 'e7252496-0f1f-563e-a5d5-b2b12193c76f'::UUID, 'sentence_builder', 6, 'Sắp xếp các thành phần thành câu đúng.', NULL, '写“木”时先横后竖。', 'Trật tự đúng tạo thành câu “写“木”时先横后竖。”.', NULL, 1, '{"activity_type":"sentence_ordering","words":["写","“木”","时","先","横","后","竖","。"],"correct_order":["写","“木”","时","先","横","后","竖","。"]}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('3a56532b-ce8d-534b-a5c6-233d61438e16'::UUID, 'e7252496-0f1f-563e-a5d5-b2b12193c76f'::UUID, 'multiple_choice', 7, 'Câu nào mô tả đúng trình tự?', NULL, '写“木”时先横后竖。', 'Cấu trúc mô tả thứ tự hai thao tác.', NULL, 1, '{"activity_type":"grammar_selection","passage":null,"grammar_key":"writing:thu-tu-net"}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('b1fabe71-89e1-5bd9-be8f-bd22825804c8'::UUID, '3a56532b-ce8d-534b-a5c6-233d61438e16'::UUID, '写“木”时先横后竖。', TRUE, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('b8f9b5bf-ab73-57d4-b5fb-3f84e0f6023b'::UUID, '3a56532b-ce8d-534b-a5c6-233d61438e16'::UUID, '。竖后横先时“木”写', FALSE, 2)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('81fe08ee-7fae-540e-ac7c-65c5d338ad30'::UUID, '3a56532b-ce8d-534b-a5c6-233d61438e16'::UUID, '“木”时先横后竖。写', FALSE, 3)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('4b44c658-9a1a-5c90-b74d-a218ed714987'::UUID, 'e7252496-0f1f-563e-a5d5-b2b12193c76f'::UUID, 'speaking', 8, 'Đọc thành tiếng: 写“木”时先横后竖。', NULL, '写“木”时先横后竖。', 'Đọc chậm, giữ đúng thanh điệu và nhịp của cả câu.', NULL, 1, '{"activity_type":"pronunciation","text":"写“木”时先横后竖。","pinyin":"Xiě “mù” shí xiān héng hòu shù."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.units (id, course_id, slug, title, description, order_index, status, learning_objectives, content_version)
VALUES ('ac2107e5-6178-57f3-9f1d-506e22582974'::UUID, '2b6c3582-f92d-53e5-984d-0b29ad76be52'::UUID, 'writing-van-dung', 'Vận dụng', 'Vận dụng mẫu câu trong ngữ cảnh có ý nghĩa.', 2, 'review', '["Phân tích cấu tạo chữ","Viết theo thứ tự nét chuẩn"]'::JSONB, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.chapters (id, unit_id, slug, title, description, order_index, status, learning_objectives, content_version)
VALUES ('a17fd9ef-dec4-5d6d-b888-04e1dca73c5c'::UUID, 'ac2107e5-6178-57f3-9f1d-506e22582974'::UUID, 'writing-van-dung-chapter', 'Ngữ cảnh thực tế', 'Vận dụng mẫu câu trong ngữ cảnh có ý nghĩa.', 1, 'review', '["Phân tích cấu tạo chữ","Viết theo thứ tự nét chuẩn"]'::JSONB, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lessons (id, chapter_id, slug, title, description, order_index, xp_reward, status, lesson_type, estimated_minutes, learning_objectives, cultural_note, content_version)
VALUES ('f8d5b904-1b1d-55b4-bfc2-093b5b9bf22b'::UUID, 'a17fd9ef-dec4-5d6d-b888-04e1dca73c5c'::UUID, 'bo-thu', '常见部首 — Bộ thủ', 'Nhận biết bộ liên quan nghĩa.', 1, 25, 'review', 'standard', 15, '["Dùng bộ thủ để đoán trường nghĩa"]'::JSONB, 'Phân tích thành phần không thay thế dữ liệu lịch sử tự nguyên.', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('19996f52-065a-5689-a1d6-2b63a95b9b09'::UUID, 'writing:部首', '部首', 'bùshǒu', 'bộ thủ', 'radical', 'starter', 'bo-thu', 'danh từ', '部首可以帮助我们查字典。', 'Bùshǒu kěyǐ bāngzhù wǒmen chá zìdiǎn.', 'Bộ thủ có thể giúp chúng ta tra từ điển.', NULL, 'review', 'f8d5b904-1b1d-55b4-bfc2-093b5b9bf22b'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('4472ca8f-7719-5ded-8f66-fca968fe8956'::UUID, 'f8d5b904-1b1d-55b4-bfc2-093b5b9bf22b'::UUID, '19996f52-065a-5689-a1d6-2b63a95b9b09'::UUID, 1, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('6c880bc2-6401-5070-9f7e-f0ea799ffc54'::UUID, 'writing:三点水', '三点水', 'sāndiǎnshuǐ', 'bộ ba chấm thủy', 'water radical', 'starter', 'bo-thu', 'danh từ', '“河”和“海”都有三点水。', '“Hé” hé “hǎi” dōu yǒu sāndiǎnshuǐ.', '“河” và “海” đều có bộ ba chấm thủy.', NULL, 'review', 'f8d5b904-1b1d-55b4-bfc2-093b5b9bf22b'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('54085714-1616-500e-83df-721ee30f3858'::UUID, 'f8d5b904-1b1d-55b4-bfc2-093b5b9bf22b'::UUID, '6c880bc2-6401-5070-9f7e-f0ea799ffc54'::UUID, 2, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('46c701f1-c3e8-5a77-ba2b-3b8f73548e0b'::UUID, 'writing:提手旁', '提手旁', 'tíshǒupáng', 'bộ thủ', 'hand radical', 'starter', 'bo-thu', 'danh từ', '“打”的左边是提手旁。', '“Dǎ” de zuǒbian shì tíshǒupáng.', 'Bên trái chữ “打” là bộ thủ.', NULL, 'review', 'f8d5b904-1b1d-55b4-bfc2-093b5b9bf22b'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('2e646bf5-bdb1-529e-a6e0-933e1338642e'::UUID, 'f8d5b904-1b1d-55b4-bfc2-093b5b9bf22b'::UUID, '46c701f1-c3e8-5a77-ba2b-3b8f73548e0b'::UUID, 3, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('89fc5691-326d-5b73-a35e-0b64a4c9c767'::UUID, 'f8d5b904-1b1d-55b4-bfc2-093b5b9bf22b'::UUID, 'cbf18eb3-1969-5017-a2c3-78ed21d0ab89'::UUID, 4, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('e086bee7-5c40-5ae8-96a4-f2f1c868b7d0'::UUID, 'f8d5b904-1b1d-55b4-bfc2-093b5b9bf22b'::UUID, '946845cd-d026-58fe-874a-7f4768bdffbf'::UUID, 5, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('9f4c76b9-0c96-556d-8209-166b5c6587a4'::UUID, 'f8d5b904-1b1d-55b4-bfc2-093b5b9bf22b'::UUID, '7e72e026-e0cd-5890-9139-4e3bb022b8a8'::UUID, 6, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.grammar_lessons (id, content_key, title, pattern, explanation, example_chinese, example_pinyin, example_meaning, level, status, usage_note, content_version)
VALUES ('6b043b91-5322-5817-ac8b-a956f6323a6d'::UUID, 'writing:bo-thu', 'Cấu tạo với 由…组成', 'chữ + 由 + thành phần + 组成', '由…组成 dùng để giải thích các bộ phận cấu tạo.', '“休”由单人旁和“木”组成。', '“Xiū” yóu dānrénpáng hé “mù” zǔchéng.', 'Chữ “休” gồm bộ nhân đứng và chữ “木”.', 'starter', 'review', NULL, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_grammar (id, lesson_id, grammar_lesson_id, order_index, curriculum_role)
VALUES ('3e8224f2-33e1-566b-8580-6177311e1994'::UUID, 'f8d5b904-1b1d-55b4-bfc2-093b5b9bf22b'::UUID, '6b043b91-5322-5817-ac8b-a956f6323a6d'::UUID, 1, 'introduced')
ON CONFLICT (lesson_id, grammar_lesson_id) DO NOTHING;

INSERT INTO public.lesson_grammar (id, lesson_id, grammar_lesson_id, order_index, curriculum_role)
VALUES ('c27abc7b-535b-54bf-aee6-c45f0f8e4fc7'::UUID, 'f8d5b904-1b1d-55b4-bfc2-093b5b9bf22b'::UUID, 'b5ba8e6b-8f37-506a-8b3c-8a7b39aee0f6'::UUID, 2, 'review')
ON CONFLICT (lesson_id, grammar_lesson_id) DO NOTHING;

INSERT INTO public.characters (id, character, pinyin, meaning_vi, radical, stroke_count, stroke_order, level, status, component_breakdown, common_words, content_version)
VALUES ('755b35e4-7ad9-5a5f-a09e-d45d3f389781'::UUID, '休', 'xiū', 'nghỉ', '亻', 6, NULL, 'starter', 'review', '{"left":"亻 (người)","right":"木 (cây)"}'::JSONB, '["休息","休假"]'::JSONB, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_characters (id, lesson_id, character_id, order_index, curriculum_role)
VALUES ('86b2e8ab-89c8-50e5-a0bf-cc693f2ff364'::UUID, 'f8d5b904-1b1d-55b4-bfc2-093b5b9bf22b'::UUID, '755b35e4-7ad9-5a5f-a09e-d45d3f389781'::UUID, 1, 'introduced')
ON CONFLICT (lesson_id, character_id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('5771af8f-16d7-58ff-a408-28ab4e1a142a'::UUID, 'f8d5b904-1b1d-55b4-bfc2-093b5b9bf22b'::UUID, 'vocabulary', 1, 'Từ mới: 部首', NULL, '部首', '部首 (bùshǒu) — bộ thủ. 部首可以帮助我们查字典。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"writing:部首","chinese":"部首","pinyin":"bùshǒu","meaning":"bộ thủ","part_of_speech":"danh từ","example_chinese":"部首可以帮助我们查字典。","example_pinyin":"Bùshǒu kěyǐ bāngzhù wǒmen chá zìdiǎn.","example_meaning_vi":"Bộ thủ có thể giúp chúng ta tra từ điển."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('240a9602-22e9-5643-9ea9-ffeb1f8c065e'::UUID, 'f8d5b904-1b1d-55b4-bfc2-093b5b9bf22b'::UUID, 'vocabulary', 2, 'Từ mới: 三点水', NULL, '三点水', '三点水 (sāndiǎnshuǐ) — bộ ba chấm thủy. “河”和“海”都有三点水。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"writing:三点水","chinese":"三点水","pinyin":"sāndiǎnshuǐ","meaning":"bộ ba chấm thủy","part_of_speech":"danh từ","example_chinese":"“河”和“海”都有三点水。","example_pinyin":"“Hé” hé “hǎi” dōu yǒu sāndiǎnshuǐ.","example_meaning_vi":"“河” và “海” đều có bộ ba chấm thủy."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('15c2ded7-3585-5b9f-87f0-a5cd220bb6e6'::UUID, 'f8d5b904-1b1d-55b4-bfc2-093b5b9bf22b'::UUID, 'vocabulary', 3, 'Từ mới: 提手旁', NULL, '提手旁', '提手旁 (tíshǒupáng) — bộ thủ. “打”的左边是提手旁。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"writing:提手旁","chinese":"提手旁","pinyin":"tíshǒupáng","meaning":"bộ thủ","part_of_speech":"danh từ","example_chinese":"“打”的左边是提手旁。","example_pinyin":"“Dǎ” de zuǒbian shì tíshǒupáng.","example_meaning_vi":"Bên trái chữ “打” là bộ thủ."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('7771c376-c252-5655-a952-f12d1cf816ef'::UUID, 'f8d5b904-1b1d-55b4-bfc2-093b5b9bf22b'::UUID, 'multiple_choice', 4, '“部首” có nghĩa phù hợp nhất là gì?', NULL, 'bộ thủ', '部首 (bùshǒu) nghĩa là “bộ thủ”.', NULL, 1, '{"activity_type":"chinese_to_vietnamese","vocabulary_key":"writing:部首"}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('5e3d015f-6480-5227-adaf-35002c025edc'::UUID, '7771c376-c252-5655-a952-f12d1cf816ef'::UUID, 'bộ ba chấm thủy', FALSE, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('b09730cf-6a68-56d8-bc19-f2569672d5c9'::UUID, '7771c376-c252-5655-a952-f12d1cf816ef'::UUID, 'bộ thủ', FALSE, 2)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('2aa3fcd3-4408-5c2a-9922-afb3ecb55579'::UUID, '7771c376-c252-5655-a952-f12d1cf816ef'::UUID, 'bộ thủ', TRUE, 3)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('a1144041-4fec-587b-9ecb-2dfd387a65ee'::UUID, 'f8d5b904-1b1d-55b4-bfc2-093b5b9bf22b'::UUID, 'translation', 5, 'Dịch sang tiếng Trung: “Chữ “休” gồm bộ nhân đứng và chữ “木”.”', NULL, '“休”由单人旁和“木”组成。', 'Mẫu câu dùng “部首” trong ngữ cảnh của bài.', 'bùshǒu', 1, '{"activity_type":"vietnamese_to_chinese","source_lang":"vi","target_lang":"zh","acceptable_answers":["“休”由单人旁和“木”组成。"]}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('cf5ab98e-cc33-521f-908e-b40d0d6b60e1'::UUID, 'f8d5b904-1b1d-55b4-bfc2-093b5b9bf22b'::UUID, 'sentence_builder', 6, 'Sắp xếp các thành phần thành câu đúng.', NULL, '“休”由单人旁和“木”组成。', 'Trật tự đúng tạo thành câu ““休”由单人旁和“木”组成。”.', NULL, 1, '{"activity_type":"sentence_ordering","words":["“休”","由","单人旁","和","“木”","组成","。"],"correct_order":["“休”","由","单人旁","和","“木”","组成","。"]}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('a643ec04-aace-5faa-a7e7-da3d963b42a8'::UUID, 'f8d5b904-1b1d-55b4-bfc2-093b5b9bf22b'::UUID, 'multiple_choice', 7, 'Câu nào phân tích cấu tạo chữ?', NULL, '“休”由单人旁和“木”组成。', '由…组成 dùng để giải thích các bộ phận cấu tạo.', NULL, 1, '{"activity_type":"grammar_selection","passage":null,"grammar_key":"writing:bo-thu"}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('85da46f2-854f-5594-84e6-58ebf945f00b'::UUID, 'a643ec04-aace-5faa-a7e7-da3d963b42a8'::UUID, '“休”由单人旁和“木”组成。', TRUE, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('73dce0ac-ff29-5171-afb3-53daf2b12bb1'::UUID, 'a643ec04-aace-5faa-a7e7-da3d963b42a8'::UUID, '。组成“木”和单人旁由“休”', FALSE, 2)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('fc8fe8b6-7054-5f76-b240-54dd97ada6b6'::UUID, 'a643ec04-aace-5faa-a7e7-da3d963b42a8'::UUID, '由单人旁和“木”组成。“休”', FALSE, 3)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('de9f5ce2-0883-5eb0-9658-ca61e1c2d7e4'::UUID, 'f8d5b904-1b1d-55b4-bfc2-093b5b9bf22b'::UUID, 'speaking', 8, 'Đọc thành tiếng: “休”由单人旁和“木”组成。', NULL, '“休”由单人旁和“木”组成。', 'Đọc chậm, giữ đúng thanh điệu và nhịp của cả câu.', NULL, 1, '{"activity_type":"pronunciation","text":"“休”由单人旁和“木”组成。","pinyin":"“Xiū” yóu dānrénpáng hé “mù” zǔchéng."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lessons (id, chapter_id, slug, title, description, order_index, xp_reward, status, lesson_type, estimated_minutes, learning_objectives, cultural_note, content_version)
VALUES ('f0824746-fa70-5d13-bd71-396727b7d4ae'::UUID, 'a17fd9ef-dec4-5d6d-b888-04e1dca73c5c'::UUID, 'ket-cau', '汉字结构 — Kết cấu chữ', 'Phân biệt kết cấu trái-phải và trên-dưới.', 2, 25, 'review', 'standard', 15, '["Phân tích bố cục chữ"]'::JSONB, 'Bố cục cần được kiểm tra trực quan khi QA trên thiết bị.', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('8dc7005e-a5a1-5156-9a52-1120bf25428e'::UUID, 'writing:结构', '结构', 'jiégòu', 'kết cấu', 'structure', 'starter', 'ket-cau', 'danh từ', '“好”是左右结构。', '“Hǎo” shì zuǒyòu jiégòu.', 'Chữ “好” có kết cấu trái-phải.', NULL, 'review', 'f0824746-fa70-5d13-bd71-396727b7d4ae'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('c0c103da-691f-5eff-920d-6f1550633782'::UUID, 'f0824746-fa70-5d13-bd71-396727b7d4ae'::UUID, '8dc7005e-a5a1-5156-9a52-1120bf25428e'::UUID, 1, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('369a4c18-5b1d-5d50-80d9-5b7bbfaa9653'::UUID, 'writing:左右', '左右', 'zuǒyòu', 'trái-phải', 'left-right', 'starter', 'ket-cau', 'danh từ phương vị', '左右两部分要写得紧凑。', 'Zuǒyòu liǎng bùfen yào xiě de jǐncòu.', 'Hai phần trái-phải cần viết cân gọn.', NULL, 'review', 'f0824746-fa70-5d13-bd71-396727b7d4ae'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('29a8fcdb-91ee-56af-a008-326bc5ae1573'::UUID, 'f0824746-fa70-5d13-bd71-396727b7d4ae'::UUID, '369a4c18-5b1d-5d50-80d9-5b7bbfaa9653'::UUID, 2, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.vocabulary (id, content_key, chinese, pinyin, meaning_vi, meaning_en, level, category, part_of_speech, example_sentence, example_pinyin, example_meaning, hsk_level, status, first_introduced_lesson_id, source_note, content_version)
VALUES ('17dcd915-2b13-585e-b61d-a097712dd272'::UUID, 'writing:上下', '上下', 'shàngxià', 'trên-dưới', 'top-bottom', 'starter', 'ket-cau', 'danh từ phương vị', '“字”是上下结构。', '“Zì” shì shàngxià jiégòu.', 'Chữ “字” có kết cấu trên-dưới.', NULL, 'review', 'f0824746-fa70-5d13-bd71-396727b7d4ae'::UUID, 'Mandarin Master original curriculum', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('3a773591-d2e7-5fba-abff-da18defc541d'::UUID, 'f0824746-fa70-5d13-bd71-396727b7d4ae'::UUID, '17dcd915-2b13-585e-b61d-a097712dd272'::UUID, 3, 'introduced')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('b91906e4-8034-559c-996c-fa5176538bf1'::UUID, 'f0824746-fa70-5d13-bd71-396727b7d4ae'::UUID, '19996f52-065a-5689-a1d6-2b63a95b9b09'::UUID, 4, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('6d2f3238-4a86-56a2-b2fd-0ce31599a956'::UUID, 'f0824746-fa70-5d13-bd71-396727b7d4ae'::UUID, '6c880bc2-6401-5070-9f7e-f0ea799ffc54'::UUID, 5, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('7e8545bf-d7fd-5384-8450-8f07d520cdc2'::UUID, 'f0824746-fa70-5d13-bd71-396727b7d4ae'::UUID, '46c701f1-c3e8-5a77-ba2b-3b8f73548e0b'::UUID, 6, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.grammar_lessons (id, content_key, title, pattern, explanation, example_chinese, example_pinyin, example_meaning, level, status, usage_note, content_version)
VALUES ('56654608-117f-5e4d-978f-78991c0addb5'::UUID, 'writing:ket-cau', 'Phân loại với 是', 'chữ + 是 + loại kết cấu', 'Dùng 是 để xác định loại bố cục của chữ.', '“明”是左右结构。', '“Míng” shì zuǒyòu jiégòu.', 'Chữ “明” có kết cấu trái-phải.', 'starter', 'review', NULL, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_grammar (id, lesson_id, grammar_lesson_id, order_index, curriculum_role)
VALUES ('85256b11-4a9d-5d1c-a318-51fc18d8790a'::UUID, 'f0824746-fa70-5d13-bd71-396727b7d4ae'::UUID, '56654608-117f-5e4d-978f-78991c0addb5'::UUID, 1, 'introduced')
ON CONFLICT (lesson_id, grammar_lesson_id) DO NOTHING;

INSERT INTO public.lesson_grammar (id, lesson_id, grammar_lesson_id, order_index, curriculum_role)
VALUES ('7c7c3bab-af3e-553d-98c7-0f0e7f107b92'::UUID, 'f0824746-fa70-5d13-bd71-396727b7d4ae'::UUID, '6b043b91-5322-5817-ac8b-a956f6323a6d'::UUID, 2, 'review')
ON CONFLICT (lesson_id, grammar_lesson_id) DO NOTHING;

INSERT INTO public.characters (id, character, pinyin, meaning_vi, radical, stroke_count, stroke_order, level, status, component_breakdown, common_words, content_version)
VALUES ('0d5a23b0-e3c3-5b0b-9823-bee93a8d6286'::UUID, '河', 'hé', 'sông', '氵', 8, NULL, 'starter', 'review', '{"left":"氵 (nước)","right":"可 (gợi âm)"}'::JSONB, '["河水","黄河"]'::JSONB, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_characters (id, lesson_id, character_id, order_index, curriculum_role)
VALUES ('b30219fa-8f3a-5520-9b81-81e853bc3b6f'::UUID, 'f0824746-fa70-5d13-bd71-396727b7d4ae'::UUID, '0d5a23b0-e3c3-5b0b-9823-bee93a8d6286'::UUID, 1, 'introduced')
ON CONFLICT (lesson_id, character_id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('c5a7a38d-0c3e-5796-8b1e-30073c05aad5'::UUID, 'f0824746-fa70-5d13-bd71-396727b7d4ae'::UUID, 'vocabulary', 1, 'Từ mới: 结构', NULL, '结构', '结构 (jiégòu) — kết cấu. “好”是左右结构。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"writing:结构","chinese":"结构","pinyin":"jiégòu","meaning":"kết cấu","part_of_speech":"danh từ","example_chinese":"“好”是左右结构。","example_pinyin":"“Hǎo” shì zuǒyòu jiégòu.","example_meaning_vi":"Chữ “好” có kết cấu trái-phải."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('52b2347f-287d-563e-bbf3-f9d0a78c5a7d'::UUID, 'f0824746-fa70-5d13-bd71-396727b7d4ae'::UUID, 'vocabulary', 2, 'Từ mới: 左右', NULL, '左右', '左右 (zuǒyòu) — trái-phải. 左右两部分要写得紧凑。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"writing:左右","chinese":"左右","pinyin":"zuǒyòu","meaning":"trái-phải","part_of_speech":"danh từ phương vị","example_chinese":"左右两部分要写得紧凑。","example_pinyin":"Zuǒyòu liǎng bùfen yào xiě de jǐncòu.","example_meaning_vi":"Hai phần trái-phải cần viết cân gọn."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('f082d118-7f76-5187-a785-f421dea3e723'::UUID, 'f0824746-fa70-5d13-bd71-396727b7d4ae'::UUID, 'vocabulary', 3, 'Từ mới: 上下', NULL, '上下', '上下 (shàngxià) — trên-dưới. “字”是上下结构。', NULL, 1, '{"activity_type":"vocabulary_introduction","vocabulary_key":"writing:上下","chinese":"上下","pinyin":"shàngxià","meaning":"trên-dưới","part_of_speech":"danh từ phương vị","example_chinese":"“字”是上下结构。","example_pinyin":"“Zì” shì shàngxià jiégòu.","example_meaning_vi":"Chữ “字” có kết cấu trên-dưới."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('cf431ddd-5c1c-5be5-9e62-b6aaa92da902'::UUID, 'f0824746-fa70-5d13-bd71-396727b7d4ae'::UUID, 'multiple_choice', 4, '“结构” có nghĩa phù hợp nhất là gì?', NULL, 'kết cấu', '结构 (jiégòu) nghĩa là “kết cấu”.', NULL, 1, '{"activity_type":"chinese_to_vietnamese","vocabulary_key":"writing:结构"}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('26827b27-4794-5d28-8e5f-11a3aea76c5a'::UUID, 'cf431ddd-5c1c-5be5-9e62-b6aaa92da902'::UUID, 'trái-phải', FALSE, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('89302b8a-0120-584f-9a9d-9865fd9d04a3'::UUID, 'cf431ddd-5c1c-5be5-9e62-b6aaa92da902'::UUID, 'trên-dưới', FALSE, 2)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('d701a74b-4c1d-565c-ac4f-90329cd5335d'::UUID, 'cf431ddd-5c1c-5be5-9e62-b6aaa92da902'::UUID, 'kết cấu', TRUE, 3)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('67b7aca1-0e1f-56cf-912f-e2682d64d78c'::UUID, 'f0824746-fa70-5d13-bd71-396727b7d4ae'::UUID, 'translation', 5, 'Dịch sang tiếng Trung: “Chữ “明” có kết cấu trái-phải.”', NULL, '“明”是左右结构。', 'Mẫu câu dùng “结构” trong ngữ cảnh của bài.', 'jiégòu', 1, '{"activity_type":"vietnamese_to_chinese","source_lang":"vi","target_lang":"zh","acceptable_answers":["“明”是左右结构。"]}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('85857b9a-0dee-53b5-b5b4-92bb462b8262'::UUID, 'f0824746-fa70-5d13-bd71-396727b7d4ae'::UUID, 'sentence_builder', 6, 'Sắp xếp các thành phần thành câu đúng.', NULL, '“明”是左右结构。', 'Trật tự đúng tạo thành câu ““明”是左右结构。”.', NULL, 1, '{"activity_type":"sentence_ordering","words":["“明”","是","左右","结构","。"],"correct_order":["“明”","是","左右","结构","。"]}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('0f4fac78-2288-54af-b123-50a9ad349207'::UUID, 'f0824746-fa70-5d13-bd71-396727b7d4ae'::UUID, 'multiple_choice', 7, 'Câu nào xác định kết cấu của 明?', NULL, '“明”是左右结构。', 'Dùng 是 để xác định loại bố cục của chữ.', NULL, 1, '{"activity_type":"grammar_selection","passage":null,"grammar_key":"writing:ket-cau"}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('f6e93076-b855-5ce9-9292-c4e713ffa05d'::UUID, '0f4fac78-2288-54af-b123-50a9ad349207'::UUID, '“明”是左右结构。', TRUE, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('c05c476e-05e1-5cb4-aa67-b18dd799906c'::UUID, '0f4fac78-2288-54af-b123-50a9ad349207'::UUID, '。结构左右是“明”', FALSE, 2)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('1dafd4fa-13e1-597e-914a-6c0619ec5815'::UUID, '0f4fac78-2288-54af-b123-50a9ad349207'::UUID, '是左右结构。“明”', FALSE, 3)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('a2702522-4746-59ed-a5a8-44cdc9477dd4'::UUID, 'f0824746-fa70-5d13-bd71-396727b7d4ae'::UUID, 'speaking', 8, 'Đọc thành tiếng: “明”是左右结构。', NULL, '“明”是左右结构。', 'Đọc chậm, giữ đúng thanh điệu và nhịp của cả câu.', NULL, 1, '{"activity_type":"pronunciation","text":"“明”是左右结构。","pinyin":"“Míng” shì zuǒyòu jiégòu."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.units (id, course_id, slug, title, description, order_index, status, learning_objectives, content_version)
VALUES ('51659fca-f081-5ab9-a53a-59377248a98a'::UUID, '2b6c3582-f92d-53e5-984d-0b29ad76be52'::UUID, 'writing-on-tap', 'Ôn tập', 'Kiểm tra và củng cố nội dung đã học.', 3, 'review', '["Ôn từ vựng","Ôn mẫu câu"]'::JSONB, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.chapters (id, unit_id, slug, title, description, order_index, status, learning_objectives, content_version)
VALUES ('440a5c38-0433-5008-91d0-fbd5fa642b62'::UUID, '51659fca-f081-5ab9-a53a-59377248a98a'::UUID, 'writing-on-tap-chapter', 'Củng cố lộ trình', 'Kiểm tra và củng cố nội dung đã học.', 1, 'review', '["Ôn từ vựng","Ôn mẫu câu"]'::JSONB, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lessons (id, chapter_id, slug, title, description, order_index, xp_reward, status, lesson_type, estimated_minutes, learning_objectives, cultural_note, content_version)
VALUES ('ad65430d-586e-5fb5-a87a-baadd5630c39'::UUID, '440a5c38-0433-5008-91d0-fbd5fa642b62'::UUID, 'writing-review', 'Ôn tập Chinese Characters and Writing', 'Củng cố từ vựng, mẫu câu và khả năng diễn đạt của toàn khóa.', 1, 30, 'review', 'review', 18, '["Vận dụng lại từ vựng trọng tâm","Tự kiểm tra mẫu câu đã học"]'::JSONB, NULL, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('1af2c5e5-06e8-592e-91e9-923b9fdd862f'::UUID, 'ad65430d-586e-5fb5-a87a-baadd5630c39'::UUID, '8dc7005e-a5a1-5156-9a52-1120bf25428e'::UUID, 1, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('8ba197f2-dc4e-5647-aa92-9233960be31a'::UUID, 'ad65430d-586e-5fb5-a87a-baadd5630c39'::UUID, '369a4c18-5b1d-5d50-80d9-5b7bbfaa9653'::UUID, 2, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_vocabulary (id, lesson_id, vocabulary_id, order_index, curriculum_role)
VALUES ('f3768db5-069c-54b0-b4b3-77e2d0a8a7a7'::UUID, 'ad65430d-586e-5fb5-a87a-baadd5630c39'::UUID, '17dcd915-2b13-585e-b61d-a097712dd272'::UUID, 3, 'review')
ON CONFLICT (lesson_id, vocabulary_id) DO NOTHING;

INSERT INTO public.lesson_grammar (id, lesson_id, grammar_lesson_id, order_index, curriculum_role)
VALUES ('6f3ad61c-d506-50f6-98ff-d537e09fb3bd'::UUID, 'ad65430d-586e-5fb5-a87a-baadd5630c39'::UUID, '56654608-117f-5e4d-978f-78991c0addb5'::UUID, 1, 'review')
ON CONFLICT (lesson_id, grammar_lesson_id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('a7550065-32fe-5cb3-be6a-7f4b9c70e606'::UUID, 'ad65430d-586e-5fb5-a87a-baadd5630c39'::UUID, 'multiple_choice', 1, '“结构” có nghĩa phù hợp nhất là gì?', NULL, 'kết cấu', '结构 (jiégòu) nghĩa là “kết cấu”.', NULL, 1, '{"activity_type":"chinese_to_vietnamese","vocabulary_key":"writing:结构"}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('6d529c1a-db2e-5b63-8436-e2a703d8f588'::UUID, 'a7550065-32fe-5cb3-be6a-7f4b9c70e606'::UUID, 'kết cấu', TRUE, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('55e6f80a-6bba-5be1-990e-02450720d9bc'::UUID, 'a7550065-32fe-5cb3-be6a-7f4b9c70e606'::UUID, 'trái-phải', FALSE, 2)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('c673b182-8fa2-568b-a985-62d6676331aa'::UUID, 'a7550065-32fe-5cb3-be6a-7f4b9c70e606'::UUID, 'trên-dưới', FALSE, 3)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('1b27209b-04a6-559b-9575-d252371c3e0a'::UUID, 'ad65430d-586e-5fb5-a87a-baadd5630c39'::UUID, 'translation', 2, 'Dịch sang tiếng Trung: “Chữ “明” có kết cấu trái-phải.”', NULL, '“明”是左右结构。', 'Mẫu câu dùng “结构” trong ngữ cảnh của bài.', 'jiégòu', 1, '{"activity_type":"vietnamese_to_chinese","source_lang":"vi","target_lang":"zh","acceptable_answers":["“明”是左右结构。"]}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('022dd14e-c77e-5268-b22a-566d0d342689'::UUID, 'ad65430d-586e-5fb5-a87a-baadd5630c39'::UUID, 'sentence_builder', 3, 'Sắp xếp các thành phần thành câu đúng.', NULL, '“明”是左右结构。', 'Trật tự đúng tạo thành câu ““明”是左右结构。”.', NULL, 1, '{"activity_type":"sentence_ordering","words":["“明”","是","左右","结构","。"],"correct_order":["“明”","是","左右","结构","。"]}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('4b54af96-76e0-547a-9bbe-3273b3fc2a87'::UUID, 'ad65430d-586e-5fb5-a87a-baadd5630c39'::UUID, 'multiple_choice', 4, 'Câu nào xác định kết cấu của 明?', NULL, '“明”是左右结构。', 'Dùng 是 để xác định loại bố cục của chữ.', NULL, 1, '{"activity_type":"grammar_selection","passage":null,"grammar_key":"writing:ket-cau"}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('1076f700-f708-5be0-acf9-250a6c0ba716'::UUID, '4b54af96-76e0-547a-9bbe-3273b3fc2a87'::UUID, '“明”是左右结构。', TRUE, 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('5ab88492-deb5-5a31-9c1b-bb7d17923439'::UUID, '4b54af96-76e0-547a-9bbe-3273b3fc2a87'::UUID, '。结构左右是“明”', FALSE, 2)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercise_options (id, exercise_id, text, is_correct, order_index)
VALUES ('7c61edce-1850-5ca1-9ac9-40df7913f80a'::UUID, '4b54af96-76e0-547a-9bbe-3273b3fc2a87'::UUID, '是左右结构。“明”', FALSE, 3)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.exercises (id, lesson_id, exercise_type, order_index, question, question_audio_url, correct_answer, explanation, hint, points, data)
VALUES ('1765e861-32b6-5250-a186-401976aba3be'::UUID, 'ad65430d-586e-5fb5-a87a-baadd5630c39'::UUID, 'speaking', 5, 'Đọc thành tiếng: “明”是左右结构。', NULL, '“明”是左右结构。', 'Đọc chậm, giữ đúng thanh điệu và nhịp của cả câu.', NULL, 1, '{"activity_type":"pronunciation","text":"“明”是左右结构。","pinyin":"“Míng” shì zuǒyòu jiégòu."}'::JSONB)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.content_batches (id, batch_key, version, migration_name, manifest_checksum, expected_counts)
VALUES ('8a3d5076-29e2-5b2f-9828-d3da0209a787'::UUID, 'batch-12-writing', 1, '20260729210000_content_batch_12_writing', '9e0b73577904331386002cd54680765c4da6767d0338fbf6b4adabe1074cc084', '{"courses":1,"units":3,"chapters":3,"lessons":5,"vocabulary":12,"grammar":4,"characters":4,"exercises":37,"options":30}'::JSONB)
ON CONFLICT (batch_key, version) DO NOTHING;

DO $content_validation$
BEGIN
  IF (SELECT COUNT(*) FROM public.courses WHERE id = ANY(ARRAY['2b6c3582-f92d-53e5-984d-0b29ad76be52'::UUID]::UUID[])) <> 1 THEN
    RAISE EXCEPTION 'Content batch batch-12-writing is missing managed courses rows';
  END IF;
  IF (SELECT COUNT(*) FROM public.units WHERE id = ANY(ARRAY['f509e18b-d0bf-5a9a-9bbf-0d9a40c4b3b0'::UUID, 'ac2107e5-6178-57f3-9f1d-506e22582974'::UUID, '51659fca-f081-5ab9-a53a-59377248a98a'::UUID]::UUID[])) <> 3 THEN
    RAISE EXCEPTION 'Content batch batch-12-writing is missing managed units rows';
  END IF;
  IF (SELECT COUNT(*) FROM public.chapters WHERE id = ANY(ARRAY['1cf17875-7391-597f-bd21-3ebfe0077fb4'::UUID, 'a17fd9ef-dec4-5d6d-b888-04e1dca73c5c'::UUID, '440a5c38-0433-5008-91d0-fbd5fa642b62'::UUID]::UUID[])) <> 3 THEN
    RAISE EXCEPTION 'Content batch batch-12-writing is missing managed chapters rows';
  END IF;
  IF (SELECT COUNT(*) FROM public.lessons WHERE id = ANY(ARRAY['179452a8-cc0b-519a-9249-9aa9a853ad58'::UUID, 'e7252496-0f1f-563e-a5d5-b2b12193c76f'::UUID, 'f8d5b904-1b1d-55b4-bfc2-093b5b9bf22b'::UUID, 'f0824746-fa70-5d13-bd71-396727b7d4ae'::UUID, 'ad65430d-586e-5fb5-a87a-baadd5630c39'::UUID]::UUID[])) <> 5 THEN
    RAISE EXCEPTION 'Content batch batch-12-writing is missing managed lessons rows';
  END IF;
  IF (SELECT COUNT(*) FROM public.vocabulary WHERE id = ANY(ARRAY['e231bc5b-6edc-57d2-952d-426692330865'::UUID, 'e1f96a99-fec7-5ec5-920e-cb466e390eef'::UUID, '037034d0-80dd-5c33-86b2-fee2384f6939'::UUID, 'cbf18eb3-1969-5017-a2c3-78ed21d0ab89'::UUID, '946845cd-d026-58fe-874a-7f4768bdffbf'::UUID, '7e72e026-e0cd-5890-9139-4e3bb022b8a8'::UUID, '19996f52-065a-5689-a1d6-2b63a95b9b09'::UUID, '6c880bc2-6401-5070-9f7e-f0ea799ffc54'::UUID, '46c701f1-c3e8-5a77-ba2b-3b8f73548e0b'::UUID, '8dc7005e-a5a1-5156-9a52-1120bf25428e'::UUID, '369a4c18-5b1d-5d50-80d9-5b7bbfaa9653'::UUID, '17dcd915-2b13-585e-b61d-a097712dd272'::UUID]::UUID[])) <> 12 THEN
    RAISE EXCEPTION 'Content batch batch-12-writing is missing managed vocabulary rows';
  END IF;
  IF (SELECT COUNT(*) FROM public.grammar_lessons WHERE id = ANY(ARRAY['65a50b64-e9c5-5f11-b4f6-3cb906cc0b45'::UUID, 'b5ba8e6b-8f37-506a-8b3c-8a7b39aee0f6'::UUID, '6b043b91-5322-5817-ac8b-a956f6323a6d'::UUID, '56654608-117f-5e4d-978f-78991c0addb5'::UUID]::UUID[])) <> 4 THEN
    RAISE EXCEPTION 'Content batch batch-12-writing is missing managed grammar_lessons rows';
  END IF;
  IF (SELECT COUNT(*) FROM public.characters WHERE id = ANY(ARRAY['1a1deac2-d007-5b94-8cf0-bed5cc3cae14'::UUID, 'f72a323a-756a-5c91-a96b-0bb41c1d3fc5'::UUID, '755b35e4-7ad9-5a5f-a09e-d45d3f389781'::UUID, '0d5a23b0-e3c3-5b0b-9823-bee93a8d6286'::UUID]::UUID[])) <> 4 THEN
    RAISE EXCEPTION 'Content batch batch-12-writing is missing managed characters rows';
  END IF;
  IF (SELECT COUNT(*) FROM public.exercises WHERE id = ANY(ARRAY['48f3ec26-769c-5054-884d-e6939c052097'::UUID, '6231a215-487f-5c6c-9b9d-8cc30dd490fb'::UUID, 'f5281d2f-1b43-5cf7-9d70-1e09e9fb75f2'::UUID, '7d6c3afd-a884-5bb4-bfa8-656ef51d96a5'::UUID, '71ab321e-bb34-5103-bd8f-c0c0f4f5c3bb'::UUID, '87a390bf-ce88-5ad9-840f-63bfcd67c31b'::UUID, '9bbd315c-5986-5ab5-a2f7-1935e1b72f4a'::UUID, '2d3cffa4-0246-5c81-aed6-acd4c27100f9'::UUID, '8e51fc47-961c-5d2a-b1aa-4091a21190ee'::UUID, 'cbe0f7f4-64d3-55b3-8c84-9b8407baed20'::UUID, 'f74a71a3-aa2b-5f48-8701-9b787d732408'::UUID, '58ea8d53-16db-510f-a634-67760fde249a'::UUID, '004bc4d4-9cfc-5b6c-92b8-15cb9614c6ad'::UUID, '762327b6-a3d7-5586-809c-4c70c38e8d98'::UUID, '3a56532b-ce8d-534b-a5c6-233d61438e16'::UUID, '4b44c658-9a1a-5c90-b74d-a218ed714987'::UUID, '5771af8f-16d7-58ff-a408-28ab4e1a142a'::UUID, '240a9602-22e9-5643-9ea9-ffeb1f8c065e'::UUID, '15c2ded7-3585-5b9f-87f0-a5cd220bb6e6'::UUID, '7771c376-c252-5655-a952-f12d1cf816ef'::UUID, 'a1144041-4fec-587b-9ecb-2dfd387a65ee'::UUID, 'cf5ab98e-cc33-521f-908e-b40d0d6b60e1'::UUID, 'a643ec04-aace-5faa-a7e7-da3d963b42a8'::UUID, 'de9f5ce2-0883-5eb0-9658-ca61e1c2d7e4'::UUID, 'c5a7a38d-0c3e-5796-8b1e-30073c05aad5'::UUID, '52b2347f-287d-563e-bbf3-f9d0a78c5a7d'::UUID, 'f082d118-7f76-5187-a785-f421dea3e723'::UUID, 'cf431ddd-5c1c-5be5-9e62-b6aaa92da902'::UUID, '67b7aca1-0e1f-56cf-912f-e2682d64d78c'::UUID, '85857b9a-0dee-53b5-b5b4-92bb462b8262'::UUID, '0f4fac78-2288-54af-b123-50a9ad349207'::UUID, 'a2702522-4746-59ed-a5a8-44cdc9477dd4'::UUID, 'a7550065-32fe-5cb3-be6a-7f4b9c70e606'::UUID, '1b27209b-04a6-559b-9575-d252371c3e0a'::UUID, '022dd14e-c77e-5268-b22a-566d0d342689'::UUID, '4b54af96-76e0-547a-9bbe-3273b3fc2a87'::UUID, '1765e861-32b6-5250-a186-401976aba3be'::UUID]::UUID[])) <> 37 THEN
    RAISE EXCEPTION 'Content batch batch-12-writing is missing managed exercises rows';
  END IF;
  IF (SELECT COUNT(*) FROM public.exercise_options WHERE id = ANY(ARRAY['6417cbf0-3511-59cb-9fcc-dbe53fe44b9e'::UUID, '43b5c577-2070-5c2b-b728-d7d3aff1e943'::UUID, '900593bb-ee8a-5adb-93f9-5c74d7ea2bd3'::UUID, 'c6fc2368-0736-57bd-84e7-f84da9fd7f39'::UUID, 'ff8f054e-e540-5c94-86c0-900c0c6f99bf'::UUID, 'ceb3db12-74e5-51d9-bcb0-faad7af603fe'::UUID, '5b274db0-4da6-52e5-b540-cdf7104e50d4'::UUID, 'f3f90ceb-b758-542c-8f37-baaaf3448375'::UUID, '7b7a1b12-f0a8-5041-9c67-a2b0f95f6450'::UUID, 'b1fabe71-89e1-5bd9-be8f-bd22825804c8'::UUID, 'b8f9b5bf-ab73-57d4-b5fb-3f84e0f6023b'::UUID, '81fe08ee-7fae-540e-ac7c-65c5d338ad30'::UUID, '5e3d015f-6480-5227-adaf-35002c025edc'::UUID, 'b09730cf-6a68-56d8-bc19-f2569672d5c9'::UUID, '2aa3fcd3-4408-5c2a-9922-afb3ecb55579'::UUID, '85da46f2-854f-5594-84e6-58ebf945f00b'::UUID, '73dce0ac-ff29-5171-afb3-53daf2b12bb1'::UUID, 'fc8fe8b6-7054-5f76-b240-54dd97ada6b6'::UUID, '26827b27-4794-5d28-8e5f-11a3aea76c5a'::UUID, '89302b8a-0120-584f-9a9d-9865fd9d04a3'::UUID, 'd701a74b-4c1d-565c-ac4f-90329cd5335d'::UUID, 'f6e93076-b855-5ce9-9292-c4e713ffa05d'::UUID, 'c05c476e-05e1-5cb4-aa67-b18dd799906c'::UUID, '1dafd4fa-13e1-597e-914a-6c0619ec5815'::UUID, '6d529c1a-db2e-5b63-8436-e2a703d8f588'::UUID, '55e6f80a-6bba-5be1-990e-02450720d9bc'::UUID, 'c673b182-8fa2-568b-a985-62d6676331aa'::UUID, '1076f700-f708-5be0-acf9-250a6c0ba716'::UUID, '5ab88492-deb5-5a31-9c1b-bb7d17923439'::UUID, '7c61edce-1850-5ca1-9ac9-40df7913f80a'::UUID]::UUID[])) <> 30 THEN
    RAISE EXCEPTION 'Content batch batch-12-writing is missing managed exercise_options rows';
  END IF;
  IF EXISTS (
    SELECT 1 FROM public.lessons AS lesson
    WHERE lesson.id = ANY(ARRAY['179452a8-cc0b-519a-9249-9aa9a853ad58'::UUID, 'e7252496-0f1f-563e-a5d5-b2b12193c76f'::UUID, 'f8d5b904-1b1d-55b4-bfc2-093b5b9bf22b'::UUID, 'f0824746-fa70-5d13-bd71-396727b7d4ae'::UUID, 'ad65430d-586e-5fb5-a87a-baadd5630c39'::UUID]::UUID[])
      AND NOT EXISTS (
        SELECT 1 FROM public.exercises AS exercise
        WHERE exercise.lesson_id = lesson.id
      )
  ) THEN
    RAISE EXCEPTION 'Content batch batch-12-writing contains a lesson without exercises';
  END IF;
  IF EXISTS (
    SELECT 1
    FROM public.lessons AS lesson
    JOIN public.exercises AS exercise ON exercise.lesson_id = lesson.id
    WHERE lesson.id = ANY(ARRAY['179452a8-cc0b-519a-9249-9aa9a853ad58'::UUID, 'e7252496-0f1f-563e-a5d5-b2b12193c76f'::UUID, 'f8d5b904-1b1d-55b4-bfc2-093b5b9bf22b'::UUID, 'f0824746-fa70-5d13-bd71-396727b7d4ae'::UUID, 'ad65430d-586e-5fb5-a87a-baadd5630c39'::UUID]::UUID[])
      AND lesson.status = 'published'
      AND exercise.exercise_type = 'listening'
      AND NULLIF(BTRIM(exercise.question_audio_url), '') IS NULL
  ) THEN
    RAISE EXCEPTION 'Published listening exercise is missing playable audio';
  END IF;
  IF EXISTS (
    SELECT 1
    FROM public.exercises AS exercise
    WHERE exercise.id = ANY(ARRAY['48f3ec26-769c-5054-884d-e6939c052097'::UUID, '6231a215-487f-5c6c-9b9d-8cc30dd490fb'::UUID, 'f5281d2f-1b43-5cf7-9d70-1e09e9fb75f2'::UUID, '7d6c3afd-a884-5bb4-bfa8-656ef51d96a5'::UUID, '71ab321e-bb34-5103-bd8f-c0c0f4f5c3bb'::UUID, '87a390bf-ce88-5ad9-840f-63bfcd67c31b'::UUID, '9bbd315c-5986-5ab5-a2f7-1935e1b72f4a'::UUID, '2d3cffa4-0246-5c81-aed6-acd4c27100f9'::UUID, '8e51fc47-961c-5d2a-b1aa-4091a21190ee'::UUID, 'cbe0f7f4-64d3-55b3-8c84-9b8407baed20'::UUID, 'f74a71a3-aa2b-5f48-8701-9b787d732408'::UUID, '58ea8d53-16db-510f-a634-67760fde249a'::UUID, '004bc4d4-9cfc-5b6c-92b8-15cb9614c6ad'::UUID, '762327b6-a3d7-5586-809c-4c70c38e8d98'::UUID, '3a56532b-ce8d-534b-a5c6-233d61438e16'::UUID, '4b44c658-9a1a-5c90-b74d-a218ed714987'::UUID, '5771af8f-16d7-58ff-a408-28ab4e1a142a'::UUID, '240a9602-22e9-5643-9ea9-ffeb1f8c065e'::UUID, '15c2ded7-3585-5b9f-87f0-a5cd220bb6e6'::UUID, '7771c376-c252-5655-a952-f12d1cf816ef'::UUID, 'a1144041-4fec-587b-9ecb-2dfd387a65ee'::UUID, 'cf5ab98e-cc33-521f-908e-b40d0d6b60e1'::UUID, 'a643ec04-aace-5faa-a7e7-da3d963b42a8'::UUID, 'de9f5ce2-0883-5eb0-9658-ca61e1c2d7e4'::UUID, 'c5a7a38d-0c3e-5796-8b1e-30073c05aad5'::UUID, '52b2347f-287d-563e-bbf3-f9d0a78c5a7d'::UUID, 'f082d118-7f76-5187-a785-f421dea3e723'::UUID, 'cf431ddd-5c1c-5be5-9e62-b6aaa92da902'::UUID, '67b7aca1-0e1f-56cf-912f-e2682d64d78c'::UUID, '85857b9a-0dee-53b5-b5b4-92bb462b8262'::UUID, '0f4fac78-2288-54af-b123-50a9ad349207'::UUID, 'a2702522-4746-59ed-a5a8-44cdc9477dd4'::UUID, 'a7550065-32fe-5cb3-be6a-7f4b9c70e606'::UUID, '1b27209b-04a6-559b-9575-d252371c3e0a'::UUID, '022dd14e-c77e-5268-b22a-566d0d342689'::UUID, '4b54af96-76e0-547a-9bbe-3273b3fc2a87'::UUID, '1765e861-32b6-5250-a186-401976aba3be'::UUID]::UUID[])
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
    WHERE link.lesson_id = ANY(ARRAY['179452a8-cc0b-519a-9249-9aa9a853ad58'::UUID, 'e7252496-0f1f-563e-a5d5-b2b12193c76f'::UUID, 'f8d5b904-1b1d-55b4-bfc2-093b5b9bf22b'::UUID, 'f0824746-fa70-5d13-bd71-396727b7d4ae'::UUID, 'ad65430d-586e-5fb5-a87a-baadd5630c39'::UUID]::UUID[])
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
