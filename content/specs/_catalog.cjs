function makeCourse({
  number,
  key,
  slug,
  title,
  titleZh,
  level,
  orderIndex,
  descriptionVi,
  objectives,
  topics,
}) {
  const stamp = String(9 + number).padStart(2, '0');
  return {
    fileName: `${String(number).padStart(2, '0')}_${key}`,
    batchKey: `batch-${String(number).padStart(2, '0')}-${key}`,
    migrationName: `20260729${stamp}0000_content_batch_${String(number).padStart(2, '0')}_${key}`,
    courseKey: key,
    slug,
    title,
    titleZh,
    description: `${title} core curriculum; review-stage pending qualified linguistic approval.`,
    descriptionVi,
    level,
    orderIndex,
    status: 'review',
    lessonsPerUnit: 2,
    objectives,
    units: [
      { slug: `${key}-nen-tang`, title: 'Nền tảng', chapterTitle: 'Khái niệm cốt lõi', descriptionVi: 'Xây dựng ngôn ngữ cốt lõi của lộ trình.', objectives: objectives.slice(0, 2) },
      { slug: `${key}-van-dung`, title: 'Vận dụng', chapterTitle: 'Ngữ cảnh thực tế', descriptionVi: 'Vận dụng mẫu câu trong ngữ cảnh có ý nghĩa.', objectives: objectives.slice(-2) },
      { slug: `${key}-on-tap`, title: 'Ôn tập', chapterTitle: 'Củng cố lộ trình', descriptionVi: 'Kiểm tra và củng cố nội dung đã học.', objectives: ['Ôn từ vựng', 'Ôn mẫu câu'] },
    ],
    lessons: topics.map((topic) => {
      const [topicSlug, topicTitle, topicDescription, topicObjective, words, grammar, characters] = topic;
      return {
        slug: topicSlug,
        title: topicTitle,
        descriptionVi: topicDescription,
        objectives: [topicObjective],
        culturalNote: grammar[7],
        words,
        grammar: {
          title: grammar[0],
          pattern: grammar[1],
          explanationVi: grammar[2],
          correct: grammar[3],
          pinyin: grammar[4],
          meaningVi: grammar[5],
          question: grammar[6],
        },
        characters,
        tokens: grammar[8],
      };
    }),
  };
}

const courses = {};

courses.hsk2 = makeCourse({
  number: 3, key: 'hsk2', slug: 'hsk-2', title: 'HSK 2', titleZh: 'HSK 二级',
  level: 'elementary', orderIndex: 3,
  descriptionVi: 'Mở rộng giao tiếp hằng ngày và các cấu trúc HSK 2.',
  objectives: ['Kể sự việc gần gũi', 'Diễn đạt mức độ và so sánh', 'Nói kế hoạch và trải nghiệm'],
  topics: [
    ['thoi-tiet', '天气怎么样？— Thời tiết', 'Mô tả thời tiết và mức độ.', 'Nói về thời tiết hôm nay', [
      ['天气', 'tiānqì', 'thời tiết', 'weather', 'danh từ', '今天天气很暖和。', 'Jīntiān tiānqì hěn nuǎnhuo.', 'Hôm nay thời tiết ấm áp.'],
      ['晴', 'qíng', 'trời quang', 'sunny', 'tính từ', '明天是晴天。', 'Míngtiān shì qíngtiān.', 'Ngày mai trời nắng.'],
      ['阴', 'yīn', 'âm u, nhiều mây', 'overcast', 'tính từ', '下午可能阴天。', 'Xiàwǔ kěnéng yīntiān.', 'Buổi chiều có thể trời âm u.'],
    ], ['Hỏi trạng thái với 怎么样', 'danh từ + 怎么样', '怎么样 hỏi nhận xét hoặc tình trạng.', '今天天气怎么样？', 'Jīntiān tiānqì zěnmeyàng?', 'Hôm nay thời tiết thế nào?', 'Câu nào hỏi đúng về thời tiết?', '暖和 thường dùng cho thời tiết dễ chịu, không dùng cho đồ ăn nóng.', ['今天', '天气', '怎么样', '？']]],
    ['dang-lam-gi', '正在做什么？— Hành động đang diễn ra', 'Dùng 正在 và 呢 cho hành động hiện tại.', 'Mô tả việc đang diễn ra', [
      ['正在', 'zhèngzài', 'đang', 'in the process of', 'phó từ', '我正在准备晚饭。', 'Wǒ zhèngzài zhǔnbèi wǎnfàn.', 'Tôi đang chuẩn bị bữa tối.'],
      ['等', 'děng', 'đợi', 'to wait', 'động từ', '请在门口等我。', 'Qǐng zài ménkǒu děng wǒ.', 'Hãy đợi tôi ở cửa.'],
      ['事情', 'shìqing', 'sự việc, việc', 'matter; affair', 'danh từ', '我有一件重要的事情。', 'Wǒ yǒu yí jiàn zhòngyào de shìqing.', 'Tôi có một việc quan trọng.'],
    ], ['Đang diễn ra với 正在', '正在 + động từ + 呢', '正在 nhấn mạnh hành động đang diễn ra; 呢 có thể đặt cuối câu.', '我正在等朋友呢。', 'Wǒ zhèngzài děng péngyou ne.', 'Tôi đang đợi bạn.', 'Câu nào diễn tả hành động đang diễn ra?', 'Có thể lược 正 hoặc 在 trong khẩu ngữ tùy ngữ cảnh.', ['我', '正在', '等', '朋友', '呢', '。']]],
    ['so-sanh', '比以前更好 — So sánh', 'So sánh hai đối tượng bằng 比.', 'Nói khác biệt rõ ràng', [
      ['比', 'bǐ', 'so với', 'than; compare', 'giới từ', '今天比昨天暖和。', 'Jīntiān bǐ zuótiān nuǎnhuo.', 'Hôm nay ấm hơn hôm qua.'],
      ['更', 'gèng', 'càng, hơn nữa', 'even more', 'phó từ', '这个办法更简单。', 'Zhège bànfǎ gèng jiǎndān.', 'Cách này đơn giản hơn.'],
      ['一样', 'yíyàng', 'giống nhau', 'the same', 'tính từ', '这两本书一样厚。', 'Zhè liǎng běn shū yíyàng hòu.', 'Hai cuốn sách này dày như nhau.'],
    ], ['So sánh với 比', 'A + 比 + B + tính từ', '比 đặt trước đối tượng làm mốc; không thêm 很 trước tính từ.', '今天比昨天暖和。', 'Jīntiān bǐ zuótiān nuǎnhuo.', 'Hôm nay ấm hơn hôm qua.', 'Câu so sánh nào đúng?', 'Muốn nói bằng nhau dùng A 跟 B 一样 + tính từ.', ['今天', '比', '昨天', '暖和', '。']]],
    ['kinh-nghiem', '去过北京 — Trải nghiệm', 'Nói trải nghiệm đã từng có bằng 过.', 'Hỏi và kể trải nghiệm', [
      ['过', 'guo', 'đã từng (trợ từ)', 'experiential aspect', 'trợ từ', '我去过上海两次。', 'Wǒ qùguo Shànghǎi liǎng cì.', 'Tôi đã từng đến Thượng Hải hai lần.', { neutralTone: true }],
      ['次', 'cì', 'lần', 'time; occurrence', 'lượng từ', '这是我第一次来中国。', 'Zhè shì wǒ dì-yī cì lái Zhōngguó.', 'Đây là lần đầu tôi đến Trung Quốc.'],
      ['以前', 'yǐqián', 'trước đây', 'before; formerly', 'danh từ thời gian', '我以前住在河内。', 'Wǒ yǐqián zhù zài Hénèi.', 'Trước đây tôi sống ở Hà Nội.'],
    ], ['Trải nghiệm với 过', 'động từ + 过 + tân ngữ', '过 cho biết hành động từng xảy ra ít nhất một lần.', '我以前去过北京。', 'Wǒ yǐqián qùguo Běijīng.', 'Trước đây tôi từng đến Bắc Kinh.', 'Câu nào kể một trải nghiệm?', 'Phủ định trải nghiệm dùng 没(有) + động từ + 过.', ['我', '以前', '去过', '北京', '。']]],
  ],
});

courses.hsk3 = makeCourse({
  number: 4, key: 'hsk3', slug: 'hsk-3', title: 'HSK 3', titleZh: 'HSK 三级',
  level: 'intermediate', orderIndex: 4, descriptionVi: 'Phát triển kể chuyện, kết quả và quan hệ nguyên nhân.',
  objectives: ['Kể lại sự việc có trình tự', 'Dùng bổ ngữ kết quả', 'Giải thích nguyên nhân và lựa chọn'],
  topics: [
    ['ket-qua', '听懂了 — Bổ ngữ kết quả', 'Diễn đạt kết quả đạt được sau hành động.', 'Phân biệt hành động và kết quả', [
      ['完成', 'wánchéng', 'hoàn thành', 'complete', 'động từ', '我已经完成作业了。', 'Wǒ yǐjīng wánchéng zuòyè le.', 'Tôi đã hoàn thành bài tập.'],
      ['清楚', 'qīngchu', 'rõ ràng', 'clear', 'tính từ', '老师讲得很清楚。', 'Lǎoshī jiǎng de hěn qīngchu.', 'Giáo viên giảng rất rõ.'],
      ['发现', 'fāxiàn', 'phát hiện', 'discover', 'động từ', '我发现钥匙在包里。', 'Wǒ fāxiàn yàoshi zài bāo lǐ.', 'Tôi phát hiện chìa khóa ở trong túi.'],
    ], ['Bổ ngữ kết quả 懂', 'động từ + 懂', '懂 sau động từ cho biết đã hiểu được nội dung.', '老师的话我听懂了。', 'Lǎoshī de huà wǒ tīngdǒng le.', 'Tôi đã nghe hiểu lời của giáo viên.', 'Câu nào nhấn mạnh kết quả nghe hiểu?', '听了 chỉ việc đã nghe; 听懂了 mới xác nhận đã hiểu.', ['老师', '的', '话', '我', '听懂', '了', '。']]],
    ['nguyen-nhan', '因为…所以… — Nguyên nhân', 'Nối nguyên nhân và kết quả.', 'Giải thích quyết định', [
      ['原因', 'yuányīn', 'nguyên nhân', 'reason', 'danh từ', '我们正在调查原因。', 'Wǒmen zhèngzài diàochá yuányīn.', 'Chúng tôi đang tìm hiểu nguyên nhân.'],
      ['决定', 'juédìng', 'quyết định', 'decide; decision', 'động từ/danh từ', '她决定明年留学。', 'Tā juédìng míngnián liúxué.', 'Cô ấy quyết định năm sau đi du học.'],
      ['所以', 'suǒyǐ', 'vì vậy', 'therefore', 'liên từ', '路上很堵，所以我迟到了。', 'Lùshang hěn dǔ, suǒyǐ wǒ chídào le.', 'Đường tắc nên tôi đến muộn.'],
    ], ['Nguyên nhân–kết quả', '因为 + nguyên nhân，所以 + kết quả', '因为 giới thiệu lý do; 所以 giới thiệu hệ quả.', '因为下雨，所以比赛取消了。', 'Yīnwèi xiàyǔ, suǒyǐ bǐsài qǔxiāo le.', 'Vì trời mưa nên trận đấu bị hủy.', 'Câu nào nối nguyên nhân và kết quả đúng?', 'Trong khẩu ngữ có thể lược một vế nối khi quan hệ đã rõ.', ['因为', '下雨', '，', '所以', '比赛', '取消', '了', '。']]],
    ['huong-di', '走进去 — Bổ ngữ xu hướng', 'Mô tả hướng di chuyển tương đối với người nói.', 'Dùng 来 và 去 sau động từ', [
      ['进去', 'jìnqu', 'đi vào', 'go in', 'bổ ngữ xu hướng', '请进教室去。', 'Qǐng jìn jiàoshì qu.', 'Mời đi vào lớp học.'],
      ['出来', 'chūlai', 'đi ra đây', 'come out', 'bổ ngữ xu hướng', '孩子们从教室里跑出来。', 'Háizimen cóng jiàoshì lǐ pǎo chūlai.', 'Bọn trẻ chạy từ lớp ra đây.'],
      ['楼上', 'lóushàng', 'tầng trên', 'upstairs', 'danh từ phương vị', '会议室在楼上。', 'Huìyìshì zài lóushàng.', 'Phòng họp ở tầng trên.'],
    ], ['Bổ ngữ xu hướng kép', 'động từ + hướng + 来/去', '来 hướng về người nói; 去 hướng xa người nói.', '他拿着书走进去了。', 'Tā názhe shū zǒu jìnqu le.', 'Anh ấy cầm sách đi vào trong.', 'Câu nào có hướng đi xa người nói?', 'Chọn 来 hay 去 theo vị trí quan sát, không chỉ theo nghĩa động từ.', ['他', '拿着', '书', '走', '进去', '了', '。']]],
    ['lua-chon', '除了…以外… — Bổ sung', 'Nêu ngoại lệ và phần bổ sung.', 'Mở rộng câu bằng quan hệ bao gồm', [
      ['除了', 'chúle', 'ngoài, trừ', 'besides; except', 'giới từ', '除了周日，我每天都上班。', 'Chúle Zhōurì, wǒ měitiān dōu shàngbān.', 'Ngoài Chủ nhật, ngày nào tôi cũng đi làm.'],
      ['以外', 'yǐwài', 'ngoài ra', 'beyond; besides', 'danh từ phương vị', '工作以外，他也喜欢摄影。', 'Gōngzuò yǐwài, tā yě xǐhuan shèyǐng.', 'Ngoài công việc, anh ấy còn thích nhiếp ảnh.'],
      ['还', 'hái', 'còn, vẫn', 'also; still', 'phó từ', '她会英语，还会汉语。', 'Tā huì Yīngyǔ, hái huì Hànyǔ.', 'Cô ấy biết tiếng Anh, còn biết tiếng Trung.'],
    ], ['Bổ sung với 除了', '除了 A 以外，还/也 B', 'Cấu trúc nêu A rồi bổ sung thêm B.', '除了汉语以外，他还会日语。', 'Chúle Hànyǔ yǐwài, tā hái huì Rìyǔ.', 'Ngoài tiếng Trung, anh ấy còn biết tiếng Nhật.', 'Câu nào diễn đạt ý bổ sung đúng?', 'Khi mang nghĩa loại trừ thường đi với 都 ở mệnh đề sau.', ['除了', '汉语', '以外', '，', '他', '还会', '日语', '。']]],
  ],
});

courses.hsk4 = makeCourse({
  number: 5, key: 'hsk4', slug: 'hsk-4', title: 'HSK 4', titleZh: 'HSK 四级',
  level: 'intermediate', orderIndex: 5, descriptionVi: 'Rèn diễn đạt có tổ chức, câu 把/被 và lập luận.',
  objectives: ['Dùng câu 把 và 被', 'Trình bày điều kiện', 'Tóm tắt ý kiến có liên kết'],
  topics: [
    ['cau-ba', '把文件放好 — Câu 把', 'Đưa tân ngữ xác định lên trước động từ.', 'Mô tả xử lý đồ vật', [
      ['整理', 'zhěnglǐ', 'sắp xếp, chỉnh lý', 'organize', 'động từ', '我先整理桌上的文件。', 'Wǒ xiān zhěnglǐ zhuō shàng de wénjiàn.', 'Tôi sắp xếp tài liệu trên bàn trước.'],
      ['材料', 'cáiliào', 'tài liệu, vật liệu', 'material', 'danh từ', '请把申请材料发给我。', 'Qǐng bǎ shēnqǐng cáiliào fā gěi wǒ.', 'Hãy gửi tài liệu đăng ký cho tôi.'],
      ['位置', 'wèizhi', 'vị trí', 'position', 'danh từ', '我把椅子放回原来的位置。', 'Wǒ bǎ yǐzi fàng huí yuánlái de wèizhi.', 'Tôi đặt ghế về vị trí cũ.'],
    ], ['Câu xử lý 把', 'chủ ngữ + 把 + tân ngữ xác định + động từ + kết quả', '把 nhấn mạnh đối tượng được xử lý và kết quả của hành động.', '请把这些材料整理好。', 'Qǐng bǎ zhèxiē cáiliào zhěnglǐ hǎo.', 'Hãy sắp xếp tốt những tài liệu này.', 'Câu 把 nào đầy đủ kết quả?', 'Sau động từ thường cần kết quả, hướng, số lượng hoặc nơi chốn.', ['请', '把', '这些', '材料', '整理', '好', '。']]],
    ['cau-bi', '航班被取消了 — Câu 被', 'Diễn đạt bị động và tác nhân.', 'Dùng 被 khi tác động quan trọng', [
      ['通知', 'tōngzhī', 'thông báo', 'notify; notice', 'động từ/danh từ', '公司通知我们明天开会。', 'Gōngsī tōngzhī wǒmen míngtiān kāihuì.', 'Công ty thông báo ngày mai họp.'],
      ['取消', 'qǔxiāo', 'hủy bỏ', 'cancel', 'động từ', '因为大雪，航班取消了。', 'Yīnwèi dàxuě, hángbān qǔxiāo le.', 'Do tuyết lớn, chuyến bay bị hủy.'],
      ['影响', 'yǐngxiǎng', 'ảnh hưởng', 'influence', 'động từ/danh từ', '睡眠不足会影响工作。', 'Shuìmián bùzú huì yǐngxiǎng gōngzuò.', 'Thiếu ngủ sẽ ảnh hưởng công việc.'],
    ], ['Câu bị động với 被', 'đối tượng + 被 + tác nhân + động từ + kết quả', '被 đưa đối tượng chịu tác động lên làm chủ đề.', '航班被航空公司取消了。', 'Hángbān bèi hángkōng gōngsī qǔxiāo le.', 'Chuyến bay đã bị hãng hàng không hủy.', 'Câu bị động nào đúng?', 'Tác nhân có thể lược khi không rõ hoặc không quan trọng.', ['航班', '被', '航空公司', '取消', '了', '。']]],
    ['dieu-kien', '只要…就… — Điều kiện đủ', 'Nêu điều kiện đủ để có kết quả.', 'Trình bày điều kiện và hệ quả', [
      ['条件', 'tiáojiàn', 'điều kiện', 'condition', 'danh từ', '这个工作条件很不错。', 'Zhège gōngzuò tiáojiàn hěn búcuò.', 'Điều kiện công việc này khá tốt.'],
      ['坚持', 'jiānchí', 'kiên trì', 'persist', 'động từ', '只要坚持练习，就会进步。', 'Zhǐyào jiānchí liànxí, jiù huì jìnbù.', 'Chỉ cần kiên trì luyện tập thì sẽ tiến bộ.'],
      ['成功', 'chénggōng', 'thành công', 'succeed; success', 'động từ/danh từ', '团队终于成功完成任务。', 'Tuánduì zhōngyú chénggōng wánchéng rènwu.', 'Nhóm cuối cùng đã hoàn thành nhiệm vụ thành công.'],
    ], ['Điều kiện với 只要', '只要 + điều kiện，就 + kết quả', '只要 nhấn mạnh điều kiện tối thiểu đủ để kết quả xảy ra.', '只要认真准备，就能成功。', 'Zhǐyào rènzhēn zhǔnbèi, jiù néng chénggōng.', 'Chỉ cần chuẩn bị nghiêm túc thì có thể thành công.', 'Câu nào nêu điều kiện đủ?', '只有…才… diễn tả điều kiện cần và có sắc thái chặt hơn.', ['只要', '认真', '准备', '，', '就', '能', '成功', '。']]],
    ['lap-luan', '一方面…另一方面… — Hai mặt', 'Tổ chức ý kiến theo hai phương diện.', 'Trình bày quan điểm cân bằng', [
      ['方面', 'fāngmiàn', 'phương diện', 'aspect', 'danh từ', '我们需要从两个方面考虑。', 'Wǒmen xūyào cóng liǎng ge fāngmiàn kǎolǜ.', 'Chúng ta cần cân nhắc từ hai phương diện.'],
      ['优点', 'yōudiǎn', 'ưu điểm', 'advantage', 'danh từ', '这个方案的优点很明显。', 'Zhège fāngàn de yōudiǎn hěn míngxiǎn.', 'Ưu điểm của phương án này rất rõ.'],
      ['缺点', 'quēdiǎn', 'khuyết điểm', 'disadvantage', 'danh từ', '我们也要看到它的缺点。', 'Wǒmen yě yào kàndào tā de quēdiǎn.', 'Chúng ta cũng cần thấy khuyết điểm của nó.'],
    ], ['Hai phương diện', '一方面 A，另一方面 B', 'Cặp nối tổ chức hai khía cạnh song song hoặc đối lập.', '一方面很方便，另一方面成本较高。', 'Yì fāngmiàn hěn fāngbiàn, lìng yì fāngmiàn chéngběn jiào gāo.', 'Một mặt rất tiện, mặt khác chi phí khá cao.', 'Câu nào trình bày hai mặt của vấn đề?', 'Hai vế nên cùng bàn về một chủ đề và cân xứng về ý.', ['一方面', '很', '方便', '，', '另一方面', '成本', '较高', '。']]],
  ],
});

courses.hsk5 = makeCourse({
  number: 6, key: 'hsk5', slug: 'hsk-5', title: 'HSK 5', titleZh: 'HSK 五级',
  level: 'upper-intermediate', orderIndex: 6, descriptionVi: 'Đọc và diễn đạt quan điểm ở mức thượng trung cấp.',
  objectives: ['Hiểu văn bản lập luận', 'Dùng liên kết trang trọng', 'Diễn đạt sắc thái và đánh giá'],
  topics: [
    ['xu-huong', '随着社会发展 — Xu hướng', 'Mô tả thay đổi đồng thời theo bối cảnh.', 'Phân tích xu hướng', [
      ['趋势', 'qūshì', 'xu hướng', 'trend', 'danh từ', '这个行业的发展趋势很明显。', 'Zhège hángyè de fāzhǎn qūshì hěn míngxiǎn.', 'Xu hướng phát triển của ngành này rất rõ.'],
      ['逐渐', 'zhújiàn', 'dần dần', 'gradually', 'phó từ', '人们逐渐改变了消费习惯。', 'Rénmen zhújiàn gǎibiàn le xiāofèi xíguàn.', 'Mọi người dần thay đổi thói quen tiêu dùng.'],
      ['普遍', 'pǔbiàn', 'phổ biến', 'widespread', 'tính từ', '移动支付已经十分普遍。', 'Yídòng zhīfù yǐjīng shífēn pǔbiàn.', 'Thanh toán di động đã rất phổ biến.'],
    ], ['Biến đổi theo bối cảnh', '随着 + danh từ/cụm động từ，mệnh đề thay đổi', '随着 giới thiệu quá trình làm nền cho một thay đổi khác.', '随着技术发展，生活逐渐更方便。', 'Suízhe jìshù fāzhǎn, shēnghuó zhújiàn gèng fāngbiàn.', 'Cùng với công nghệ phát triển, cuộc sống dần tiện hơn.', 'Câu nào mô tả xu hướng đồng thời?', '随着 không trực tiếp biểu thị nguyên nhân tuyệt đối.', ['随着', '技术', '发展', '，', '生活', '逐渐', '更', '方便', '。']]],
    ['nhuong-bo', '尽管…仍然… — Nhượng bộ', 'Đối chiếu thực tế với kết quả không đổi.', 'Diễn đạt tương phản có sắc thái', [
      ['尽管', 'jǐnguǎn', 'mặc dù', 'although', 'liên từ', '尽管很累，他还是继续工作。', 'Jǐnguǎn hěn lèi, tā háishi jìxù gōngzuò.', 'Mặc dù rất mệt, anh ấy vẫn tiếp tục làm việc.'],
      ['仍然', 'réngrán', 'vẫn', 'still', 'phó từ', '天气很冷，比赛仍然进行。', 'Tiānqì hěn lěng, bǐsài réngrán jìnxíng.', 'Trời rất lạnh, trận đấu vẫn diễn ra.'],
      ['克服', 'kèfú', 'khắc phục', 'overcome', 'động từ', '我们一起克服了困难。', 'Wǒmen yìqǐ kèfú le kùnnan.', 'Chúng tôi cùng nhau khắc phục khó khăn.'],
    ], ['Nhượng bộ trang trọng', '尽管 A，仍然 B', 'Kết quả B vẫn tồn tại dù có trở ngại A.', '尽管遇到困难，他仍然没有放弃。', 'Jǐnguǎn yùdào kùnnan, tā réngrán méiyǒu fàngqì.', 'Mặc dù gặp khó khăn, anh ấy vẫn không từ bỏ.', 'Câu nào thể hiện quan hệ nhượng bộ?', '还是 thường khẩu ngữ hơn; 仍然 phù hợp văn viết.', ['尽管', '遇到', '困难', '，', '他', '仍然', '没有', '放弃', '。']]],
    ['danh-gia', '未必如此 — Đánh giá thận trọng', 'Giảm mức khẳng định trong nhận xét.', 'Nêu đánh giá có giới hạn', [
      ['未必', 'wèibì', 'chưa chắc', 'not necessarily', 'phó từ', '价格高的产品未必最好。', 'Jiàgé gāo de chǎnpǐn wèibì zuì hǎo.', 'Sản phẩm giá cao chưa chắc tốt nhất.'],
      ['合理', 'hélǐ', 'hợp lý', 'reasonable', 'tính từ', '这个安排比较合理。', 'Zhège ānpái bǐjiào hélǐ.', 'Sự sắp xếp này khá hợp lý.'],
      ['判断', 'pànduàn', 'phán đoán', 'judge; judgment', 'động từ/danh từ', '不要只根据外表判断一个人。', 'Búyào zhǐ gēnjù wàibiǎo pànduàn yí ge rén.', 'Đừng chỉ dựa vào vẻ ngoài để đánh giá một người.'],
    ], ['Phủ định khả năng với 未必', 'chủ ngữ + 未必 + vị ngữ', '未必 bác bỏ suy luận tất yếu nhưng không phủ định hoàn toàn.', '看起来简单，做起来未必容易。', 'Kànqilai jiǎndān, zuòqilai wèibì róngyì.', 'Nhìn có vẻ đơn giản nhưng làm chưa chắc dễ.', 'Câu nào đưa ra đánh giá thận trọng?', '未必 khác 不: nó để ngỏ khả năng đúng.', ['看起来', '简单', '，', '做起来', '未必', '容易', '。']]],
    ['van-viet', '由此可见 — Kết luận văn viết', 'Dẫn ra kết luận từ bằng chứng trước đó.', 'Viết đoạn kết luận mạch lạc', [
      ['证据', 'zhèngjù', 'chứng cứ', 'evidence', 'danh từ', '目前还没有足够的证据。', 'Mùqián hái méiyǒu zúgòu de zhèngjù.', 'Hiện vẫn chưa có đủ bằng chứng.'],
      ['结论', 'jiélùn', 'kết luận', 'conclusion', 'danh từ', '现在下结论还太早。', 'Xiànzài xià jiélùn hái tài zǎo.', 'Bây giờ đưa ra kết luận còn quá sớm.'],
      ['表明', 'biǎomíng', 'cho thấy', 'indicate', 'động từ', '调查结果表明情况有所改善。', 'Diàochá jiéguǒ biǎomíng qíngkuàng yǒusuǒ gǎishàn.', 'Kết quả khảo sát cho thấy tình hình đã cải thiện.'],
    ], ['Dẫn kết luận với 由此可见', 'bằng chứng。由此可见，kết luận', '由此可见 đánh dấu kết luận logic trong văn viết.', '数据持续上升，由此可见需求正在增加。', 'Shùjù chíxù shàngshēng, yóucǐ kějiàn xūqiú zhèngzài zēngjiā.', 'Dữ liệu liên tục tăng; từ đó có thể thấy nhu cầu đang tăng.', 'Câu nào dùng dấu hiệu kết luận phù hợp?', 'Cần có dữ kiện trước 由此可见, không dùng như ý kiến vô căn cứ.', ['数据', '持续', '上升', '，', '由此可见', '需求', '正在', '增加', '。']]],
  ],
});

courses.hsk6 = makeCourse({
  number: 7, key: 'hsk6', slug: 'hsk-6', title: 'HSK 6', titleZh: 'HSK 六级',
  level: 'advanced', orderIndex: 7, descriptionVi: 'Diễn đạt học thuật, hàm ý và lập luận ở mức nâng cao.',
  objectives: ['Đọc hiểu lập luận trừu tượng', 'Dùng kết cấu văn viết nâng cao', 'Diễn đạt hàm ý chính xác'],
  topics: [
    ['ham-y', '言外之意 — Hàm ý', 'Nhận biết ý ngoài lời và sắc thái.', 'Suy luận hàm ý trong ngữ cảnh', [
      ['暗示', 'ànshì', 'ám chỉ', 'imply', 'động từ/danh từ', '他的回答暗示计划可能改变。', 'Tā de huídá ànshì jìhuà kěnéng gǎibiàn.', 'Câu trả lời của anh ấy ám chỉ kế hoạch có thể thay đổi.'],
      ['含义', 'hányì', 'hàm nghĩa', 'implication; meaning', 'danh từ', '这句话有很深的含义。', 'Zhè jù huà yǒu hěn shēn de hányì.', 'Câu này có hàm nghĩa rất sâu.'],
      ['揣摩', 'chuǎimó', 'suy ngẫm, đoán ý', 'ponder; infer', 'động từ', '读者需要揣摩作者的语气。', 'Dúzhě xūyào chuǎimó zuòzhě de yǔqì.', 'Người đọc cần suy ngẫm giọng điệu của tác giả.'],
    ], ['Hàm ý với 无非', '无非是 + phạm vi được quy về', '无非 thu hẹp một hiện tượng vào nguyên nhân hoặc bản chất mà người nói cho là rõ.', '他的言外之意无非是希望我们让步。', 'Tā de yánwàizhīyì wúfēi shì xīwàng wǒmen ràngbù.', 'Hàm ý của anh ấy chẳng qua là mong chúng ta nhượng bộ.', 'Câu nào diễn giải hàm ý?', '无非 thường có sắc thái đánh giá và không hoàn toàn trung tính.', ['他', '的', '言外之意', '无非', '是', '希望', '我们', '让步', '。']]],
    ['lap-luan-phuc', '固然…然而… — Thừa nhận rồi phản biện', 'Thừa nhận một mặt trước khi nêu trọng tâm đối lập.', 'Xây dựng phản biện cân bằng', [
      ['固然', 'gùrán', 'dĩ nhiên, đúng là', 'admittedly', 'liên từ', '经验固然重要，方法也不能忽视。', 'Jīngyàn gùrán zhòngyào, fāngfǎ yě bù néng hūshì.', 'Kinh nghiệm dĩ nhiên quan trọng, phương pháp cũng không thể xem nhẹ.'],
      ['然而', 'rán ér', 'tuy nhiên', 'however', 'liên từ', '条件有限，然而团队没有退缩。', 'Tiáojiàn yǒuxiàn, rán ér tuánduì méiyǒu tuìsuō.', 'Điều kiện hạn chế, tuy nhiên nhóm không lùi bước.'],
      ['权衡', 'quánhéng', 'cân nhắc', 'weigh; balance', 'động từ', '决策前要权衡利弊。', 'Juécè qián yào quánhéng lìbì.', 'Trước khi quyết định cần cân nhắc lợi hại.'],
    ], ['Thừa nhận–chuyển hướng', 'A 固然…，然而 B…', '固然 thừa nhận A, còn 然而 đưa ra ý B mà người viết muốn nhấn mạnh.', '效率固然重要，然而公平也不容忽视。', 'Xiàolǜ gùrán zhòngyào, rán ér gōngpíng yě bùróng hūshì.', 'Hiệu quả dĩ nhiên quan trọng, nhưng công bằng cũng không thể xem nhẹ.', 'Câu nào có lập luận thừa nhận rồi chuyển hướng?', 'Vế sau thường mang trọng tâm lập luận.', ['效率', '固然', '重要', '，', '然而', '公平', '也', '不容', '忽视', '。']]],
    ['hoc-thuat', '就…而言 — Giới hạn phạm vi', 'Khoanh vùng bình diện đánh giá.', 'Trình bày nhận định học thuật chính xác', [
      ['范畴', 'fànchóu', 'phạm trù', 'category; domain', 'danh từ', '这个问题属于社会学范畴。', 'Zhège wèntí shǔyú shèhuìxué fànchóu.', 'Vấn đề này thuộc phạm trù xã hội học.'],
      ['前提', 'qiántí', 'tiền đề', 'premise', 'danh từ', '结论成立需要一个前提。', 'Jiélùn chénglì xūyào yí ge qiántí.', 'Để kết luận đứng vững cần một tiền đề.'],
      ['阐述', 'chǎnshù', 'trình bày, luận giải', 'expound', 'động từ', '作者详细阐述了核心观点。', 'Zuòzhě xiángxì chǎnshù le héxīn guāndiǎn.', 'Tác giả trình bày chi tiết quan điểm cốt lõi.'],
    ], ['Giới hạn bình diện', '就 + phạm vi + 而言', 'Kết cấu văn viết xác định phương diện mà nhận định có hiệu lực.', '就研究方法而言，这个设计仍有改进空间。', 'Jiù yánjiū fāngfǎ ér yán, zhège shèjì réng yǒu gǎijìn kōngjiān.', 'Xét về phương pháp nghiên cứu, thiết kế này vẫn còn chỗ cải thiện.', 'Câu nào giới hạn rõ phạm vi đánh giá?', 'Có thể thay 就 bằng 对…来说 trong văn phong ít trang trọng hơn.', ['就', '研究', '方法', '而言', '，', '这个', '设计', '仍', '有', '改进', '空间', '。']]],
    ['thanh-ngu', '实事求是 — Thành ngữ trong văn cảnh', 'Dùng thành ngữ theo đúng sắc thái.', 'Hiểu và vận dụng thành ngữ phổ biến', [
      ['实事求是', 'shíshì qiúshì', 'tôn trọng sự thật', 'seek truth from facts', 'thành ngữ', '分析问题应该实事求是。', 'Fēnxī wèntí yīnggāi shíshì qiúshì.', 'Phân tích vấn đề nên tôn trọng sự thật.'],
      ['因地制宜', 'yīndì zhìyí', 'tùy nơi mà áp dụng phù hợp', 'adapt to local conditions', 'thành ngữ', '各地应该因地制宜发展产业。', 'Gèdì yīnggāi yīndì zhìyí fāzhǎn chǎnyè.', 'Các nơi nên phát triển ngành nghề phù hợp điều kiện địa phương.'],
      ['循序渐进', 'xúnxù jiànjìn', 'tiến dần theo trình tự', 'advance step by step', 'thành ngữ', '学习语言需要循序渐进。', 'Xuéxí yǔyán xūyào xúnxù jiànjìn.', 'Học ngôn ngữ cần tiến dần từng bước.'],
    ], ['Cách dùng thành ngữ làm vị ngữ', 'chủ ngữ + 应该/需要 + thành ngữ', 'Nhiều thành ngữ bốn chữ có thể làm vị ngữ hoặc trạng ngữ theo ngữ cảnh.', '制定方案时应该实事求是、因地制宜。', 'Zhìdìng fāngàn shí yīnggāi shíshì qiúshì, yīndì zhìyí.', 'Khi lập phương án nên tôn trọng thực tế và phù hợp điều kiện địa phương.', 'Câu nào dùng thành ngữ phù hợp ngữ cảnh?', 'Không ghép thành ngữ chỉ vì cùng nghĩa gần; cần kiểm tra chức năng cú pháp.', ['制定', '方案', '时', '应该', '实事求是', '、', '因地制宜', '。']]],
  ],
});

courses.practical = makeCourse({
  number: 8, key: 'practical', slug: 'practical-conversation', title: 'Practical Chinese Conversation', titleZh: '实用汉语会话',
  level: 'beginner', orderIndex: 8, descriptionVi: 'Hội thoại thực dụng cho các tình huống hằng ngày.',
  objectives: ['Mở và duy trì hội thoại', 'Xử lý yêu cầu thường ngày', 'Phản hồi lịch sự và tự nhiên'],
  topics: [
    ['hen-gap', '约时间 — Hẹn gặp', 'Thống nhất thời gian và địa điểm.', 'Hẹn gặp rõ ràng', [
      ['方便', 'fāngbiàn', 'tiện', 'convenient', 'tính từ', '你明天下午方便吗？', 'Nǐ míngtiān xiàwǔ fāngbiàn ma?', 'Chiều mai bạn có tiện không?'],
      ['见面', 'jiànmiàn', 'gặp mặt', 'meet', 'động từ', '我们周末见面吧。', 'Wǒmen zhōumò jiànmiàn ba.', 'Cuối tuần chúng ta gặp nhau nhé.'],
      ['确定', 'quèdìng', 'xác định', 'confirm', 'động từ', '时间确定以后告诉我。', 'Shíjiān quèdìng yǐhòu gàosu wǒ.', 'Sau khi chốt thời gian hãy báo tôi.'],
    ], ['Đề nghị với 吧', 'câu đề nghị + 吧', '吧 làm đề nghị mềm và thân thiện.', '我们下午三点见面吧。', 'Wǒmen xiàwǔ sān diǎn jiànmiàn ba.', 'Chúng ta gặp nhau lúc ba giờ chiều nhé.', 'Câu nào là một lời đề nghị tự nhiên?', '吧 không dùng khi cần mệnh lệnh dứt khoát.', ['我们', '下午', '三点', '见面', '吧', '。']]],
    ['goi-dien', '打电话 — Gọi điện', 'Mở đầu và chuyển cuộc gọi.', 'Xác nhận người nghe qua điện thoại', [
      ['接', 'jiē', 'nghe, nhận', 'answer; receive', 'động từ', '他现在不能接电话。', 'Tā xiànzài bù néng jiē diànhuà.', 'Bây giờ anh ấy không thể nghe điện thoại.'],
      ['稍等', 'shāoděng', 'xin chờ một chút', 'wait a moment', 'động từ', '请稍等，我帮您转接。', 'Qǐng shāoděng, wǒ bāng nín zhuǎnjiē.', 'Xin chờ một chút, tôi sẽ chuyển máy.'],
      ['留言', 'liúyán', 'để lại lời nhắn', 'leave a message', 'động từ/danh từ', '您需要留言吗？', 'Nín xūyào liúyán ma?', 'Ngài có cần để lại lời nhắn không?'],
    ], ['Cách tự giới thiệu qua điện thoại', '喂，您好，我是…', 'Nêu tên sau lời chào để người nghe nhanh chóng xác định người gọi.', '喂，您好，我是小林。', 'Wéi, nín hǎo, wǒ shì Xiǎolín.', 'A lô, xin chào, tôi là Tiểu Lâm.', 'Câu mở đầu điện thoại nào tự nhiên?', '喂 trong cuộc gọi đọc wéi thanh 2.', ['喂，', '您好，', '我', '是', '小林', '。']]],
    ['nho-giup', '能帮个忙吗？— Nhờ giúp', 'Đưa ra yêu cầu lịch sự.', 'Nhờ giúp và cảm ơn', [
      ['帮忙', 'bāngmáng', 'giúp đỡ', 'help', 'động từ', '你能帮我一个忙吗？', 'Nǐ néng bāng wǒ yí ge máng ma?', 'Bạn có thể giúp tôi một việc không?'],
      ['麻烦', 'máfan', 'phiền; làm phiền', 'trouble', 'động từ/tính từ', '麻烦你再说一遍。', 'Máfan nǐ zài shuō yí biàn.', 'Phiền bạn nói lại một lần.'],
      ['当然', 'dāngrán', 'tất nhiên', 'of course', 'phó từ', '当然可以，没问题。', 'Dāngrán kěyǐ, méi wèntí.', 'Tất nhiên được, không vấn đề.'],
    ], ['Yêu cầu lịch sự với 能…吗', '能 + động từ + 吗', 'Dạng câu hỏi khả năng làm yêu cầu bớt trực tiếp.', '你能帮我拿一下吗？', 'Nǐ néng bāng wǒ ná yíxià ma?', 'Bạn có thể giúp tôi cầm một chút không?', 'Câu nhờ giúp nào lịch sự?', 'Thêm 一下 làm hành động nghe nhẹ hơn.', ['你', '能', '帮', '我', '拿', '一下', '吗', '？']]],
    ['xu-ly-hieu-lam', '不好意思，我没听清 — Hiểu lầm', 'Yêu cầu làm rõ mà không gây căng thẳng.', 'Sửa hiểu lầm lịch sự', [
      ['听清', 'tīngqīng', 'nghe rõ', 'hear clearly', 'động từ', '刚才我没听清地址。', 'Gāngcái wǒ méi tīngqīng dìzhǐ.', 'Lúc nãy tôi không nghe rõ địa chỉ.'],
      ['误会', 'wùhuì', 'hiểu lầm', 'misunderstand', 'động từ/danh từ', '对不起，这是一个误会。', 'Duìbuqǐ, zhè shì yí ge wùhuì.', 'Xin lỗi, đây là một sự hiểu lầm.'],
      ['解释', 'jiěshì', 'giải thích', 'explain', 'động từ', '请让我解释一下。', 'Qǐng ràng wǒ jiěshì yíxià.', 'Xin hãy để tôi giải thích một chút.'],
    ], ['Phủ định kết quả với 没', '没 + động từ + bổ ngữ kết quả', '没 phủ định việc đạt được kết quả trong quá khứ.', '不好意思，我没听清。', 'Bù hǎoyìsi, wǒ méi tīngqīng.', 'Xin lỗi, tôi chưa nghe rõ.', 'Câu nào nói chưa nghe rõ?', 'Không dùng 不听清 để phủ định một kết quả đã xảy ra.', ['不好意思', '，', '我', '没', '听清', '。']]],
  ],
});

courses.travel = makeCourse({
  number: 9, key: 'travel', slug: 'chinese-for-travel', title: 'Chinese for Travel', titleZh: '旅游汉语',
  level: 'elementary', orderIndex: 13, descriptionVi: 'Tiếng Trung thiết yếu cho hành trình, khách sạn và sự cố.',
  objectives: ['Làm thủ tục di chuyển', 'Giao tiếp tại nơi lưu trú', 'Xử lý thay đổi và sự cố'],
  topics: [
    ['san-bay', '办理登机 — Làm thủ tục bay', 'Hỏi quầy và làm thủ tục.', 'Hoàn thành thủ tục sân bay', [
      ['登机牌', 'dēngjīpái', 'thẻ lên máy bay', 'boarding pass', 'danh từ', '请收好您的登机牌。', 'Qǐng shōuhǎo nín de dēngjīpái.', 'Xin giữ cẩn thận thẻ lên máy bay.'],
      ['行李', 'xíngli', 'hành lý', 'luggage', 'danh từ', '这件行李需要托运。', 'Zhè jiàn xíngli xūyào tuōyùn.', 'Kiện hành lý này cần ký gửi.'],
      ['护照', 'hùzhào', 'hộ chiếu', 'passport', 'danh từ', '办理手续时请出示护照。', 'Bànlǐ shǒuxù shí qǐng chūshì hùzhào.', 'Khi làm thủ tục xin xuất trình hộ chiếu.'],
    ], ['Yêu cầu xuất trình với 请', '请 + động từ + tân ngữ', '请 trước động từ tạo yêu cầu lịch sự.', '办理登机时请出示护照。', 'Bànlǐ dēngjī shí qǐng chūshì hùzhào.', 'Khi làm thủ tục lên máy bay xin xuất trình hộ chiếu.', 'Câu hướng dẫn nào lịch sự?', '出示 dùng cho giấy tờ cần đưa ra kiểm tra.', ['办理', '登机', '时', '请', '出示', '护照', '。']]],
    ['khach-san', '预订房间 — Khách sạn', 'Đặt phòng và xác nhận dịch vụ.', 'Nhận phòng bằng thông tin đặt chỗ', [
      ['预订', 'yùdìng', 'đặt trước', 'reserve', 'động từ', '我在网上预订了房间。', 'Wǒ zài wǎngshang yùdìng le fángjiān.', 'Tôi đã đặt phòng trên mạng.'],
      ['前台', 'qiántái', 'quầy lễ tân', 'front desk', 'danh từ', '请到前台办理入住。', 'Qǐng dào qiántái bànlǐ rùzhù.', 'Xin đến quầy lễ tân làm thủ tục nhận phòng.'],
      ['退房', 'tuìfáng', 'trả phòng', 'check out', 'động từ', '酒店要求中午十二点前退房。', 'Jiǔdiàn yāoqiú zhōngwǔ shí’èr diǎn qián tuìfáng.', 'Khách sạn yêu cầu trả phòng trước 12 giờ trưa.'],
    ], ['Đã hoàn tất với 了', 'động từ + 了 + tân ngữ', '了 sau động từ đánh dấu hành động đã hoàn tất.', '我已经预订了一个双人间。', 'Wǒ yǐjīng yùdìng le yí ge shuāngrénjiān.', 'Tôi đã đặt một phòng đôi.', 'Câu nào xác nhận đã đặt phòng?', '已经 thường đi cùng 了 để nhấn mạnh trạng thái hoàn tất.', ['我', '已经', '预订', '了', '一个', '双人间', '。']]],
    ['hoi-duong', '换乘地铁 — Đổi tuyến', 'Hỏi đường và đổi phương tiện.', 'Hiểu chỉ dẫn nhiều chặng', [
      ['换乘', 'huànchéng', 'chuyển tuyến', 'transfer', 'động từ', '在中心站换乘二号线。', 'Zài Zhōngxīn Zhàn huànchéng èr hào xiàn.', 'Chuyển sang tuyến số 2 tại ga Trung Tâm.'],
      ['出口', 'chūkǒu', 'lối ra', 'exit', 'danh từ', '博物馆离三号出口最近。', 'Bówùguǎn lí sān hào chūkǒu zuì jìn.', 'Bảo tàng gần lối ra số 3 nhất.'],
      ['直走', 'zhízǒu', 'đi thẳng', 'go straight', 'động từ', '从这里直走五百米。', 'Cóng zhèlǐ zhízǒu wǔbǎi mǐ.', 'Từ đây đi thẳng 500 mét.'],
    ], ['Chỉ lộ trình với 先…再…', '先 + bước 1，再 + bước 2', 'Cặp nối sắp xếp hai bước theo thời gian.', '先坐一号线，再换乘二号线。', 'Xiān zuò yī hào xiàn, zài huànchéng èr hào xiàn.', 'Đi tuyến số 1 trước, rồi chuyển tuyến số 2.', 'Câu nào chỉ đúng trình tự đổi tuyến?', '再 trong cấu trúc này chỉ bước tiếp theo.', ['先', '坐', '一号线', '，', '再', '换乘', '二号线', '。']]],
    ['su-co', '航班延误 — Sự cố hành trình', 'Báo mất đồ và xử lý chuyến bị chậm.', 'Yêu cầu hỗ trợ khi có sự cố', [
      ['延误', 'yánwù', 'chậm trễ', 'delay', 'động từ/danh từ', '航班因为天气延误了。', 'Hángbān yīnwèi tiānqì yánwù le.', 'Chuyến bay bị chậm do thời tiết.'],
      ['丢失', 'diūshī', 'thất lạc', 'lose; be missing', 'động từ', '我的行李在途中丢失了。', 'Wǒ de xíngli zài túzhōng diūshī le.', 'Hành lý của tôi bị thất lạc trên đường.'],
      ['改签', 'gǎiqiān', 'đổi vé', 'rebook', 'động từ', '我想把机票改签到明天。', 'Wǒ xiǎng bǎ jīpiào gǎiqiān dào míngtiān.', 'Tôi muốn đổi vé máy bay sang ngày mai.'],
    ], ['Yêu cầu xử lý với 可以…吗', '可以 + động từ + 吗', 'Câu hỏi xin phép hoặc hỏi khả năng dịch vụ.', '这个航班可以免费改签吗？', 'Zhège hángbān kěyǐ miǎnfèi gǎiqiān ma?', 'Chuyến bay này có thể đổi vé miễn phí không?', 'Câu nào hỏi đúng về đổi vé?', 'Nêu rõ đối tượng trước 可以 để tránh mơ hồ.', ['这个', '航班', '可以', '免费', '改签', '吗', '？']]],
  ],
});

courses.work = makeCourse({
  number: 10, key: 'work', slug: 'chinese-for-work-business', title: 'Chinese for Work and Business', titleZh: '商务汉语',
  level: 'intermediate', orderIndex: 14, descriptionVi: 'Giao tiếp công sở, họp, thương lượng và tuyển dụng.',
  objectives: ['Trao đổi công việc rõ ràng', 'Tham gia họp và thương lượng', 'Dùng văn phong nghề nghiệp phù hợp'],
  topics: [
    ['email', '确认邮件 — Email công việc', 'Xác nhận và phản hồi nhiệm vụ.', 'Viết phản hồi ngắn, rõ', [
      ['附件', 'fùjiàn', 'tệp đính kèm', 'attachment', 'danh từ', '报价单请见邮件附件。', 'Bàojiàdān qǐng jiàn yóujiàn fùjiàn.', 'Xin xem báo giá trong tệp đính kèm email.'],
      ['确认', 'quèrèn', 'xác nhận', 'confirm', 'động từ', '请确认会议时间是否合适。', 'Qǐng quèrèn huìyì shíjiān shìfǒu héshì.', 'Xin xác nhận thời gian họp có phù hợp không.'],
      ['回复', 'huífù', 'phản hồi', 'reply', 'động từ/danh từ', '我会在今天下班前回复。', 'Wǒ huì zài jīntiān xiàbān qián huífù.', 'Tôi sẽ phản hồi trước khi tan làm hôm nay.'],
    ], ['Hỏi xác nhận với 是否', 'động từ + 是否 + tính từ/động từ', '是否 là dạng văn viết, trang trọng hơn “是不是”.', '请确认附件是否完整。', 'Qǐng quèrèn fùjiàn shìfǒu wánzhěng.', 'Xin xác nhận tệp đính kèm có đầy đủ không.', 'Câu email nào yêu cầu xác nhận?', '是否 phù hợp email; hội thoại thường dùng …吗 hoặc 是不是.', ['请', '确认', '附件', '是否', '完整', '。']]],
    ['hop', '汇报进度 — Cuộc họp', 'Báo cáo tiến độ và nêu vấn đề.', 'Cập nhật dự án trong cuộc họp', [
      ['进度', 'jìndù', 'tiến độ', 'progress', 'danh từ', '项目进度符合原来的计划。', 'Xiàngmù jìndù fúhé yuánlái de jìhuà.', 'Tiến độ dự án phù hợp kế hoạch ban đầu.'],
      ['汇报', 'huìbào', 'báo cáo', 'report', 'động từ/danh từ', '我先汇报本周的工作。', 'Wǒ xiān huìbào běn zhōu de gōngzuò.', 'Tôi báo cáo công việc tuần này trước.'],
      ['议程', 'yìchéng', 'chương trình nghị sự', 'agenda', 'danh từ', '今天的议程有三个部分。', 'Jīntiān de yìchéng yǒu sān ge bùfen.', 'Chương trình hôm nay có ba phần.'],
    ], ['Mở đầu báo cáo với 先', '我先 + động từ + nội dung', '先 giúp báo hiệu bước đầu trong trình tự cuộc họp.', '我先汇报一下项目进度。', 'Wǒ xiān huìbào yíxià xiàngmù jìndù.', 'Tôi xin báo cáo sơ qua tiến độ dự án trước.', 'Câu nào mở đầu báo cáo tự nhiên?', '一下 làm giọng điệu bớt cứng nhưng vẫn chuyên nghiệp.', ['我', '先', '汇报', '一下', '项目', '进度', '。']]],
    ['thuong-luong', '达成协议 — Thương lượng', 'Nêu điều kiện và tìm phương án chung.', 'Thương lượng điều khoản cơ bản', [
      ['报价', 'bàojià', 'báo giá', 'quote; quotation', 'động từ/danh từ', '这个报价包括运输费用。', 'Zhège bàojià bāokuò yùnshū fèiyòng.', 'Báo giá này bao gồm phí vận chuyển.'],
      ['让步', 'ràngbù', 'nhượng bộ', 'make a concession', 'động từ', '双方都需要作出适当让步。', 'Shuāngfāng dōu xūyào zuòchū shìdàng ràngbù.', 'Hai bên đều cần có nhượng bộ phù hợp.'],
      ['协议', 'xiéyì', 'thỏa thuận', 'agreement', 'danh từ', '双方终于达成了协议。', 'Shuāngfāng zhōngyú dáchéng le xiéyì.', 'Hai bên cuối cùng đã đạt được thỏa thuận.'],
    ], ['Điều kiện thương lượng', '如果 A，我们可以 B', '如果 nêu điều kiện; vế sau đưa ra phương án tương ứng.', '如果增加数量，我们可以调整报价。', 'Rúguǒ zēngjiā shùliàng, wǒmen kěyǐ tiáozhěng bàojià.', 'Nếu tăng số lượng, chúng tôi có thể điều chỉnh báo giá.', 'Câu nào đưa ra điều kiện thương lượng?', 'Dùng 可以 thay cho 会 khi nói khả năng thương lượng.', ['如果', '增加', '数量', '，', '我们', '可以', '调整', '报价', '。']]],
    ['phong-van', '应聘职位 — Phỏng vấn', 'Trình bày kinh nghiệm và năng lực.', 'Tự giới thiệu trong phỏng vấn', [
      ['应聘', 'yìngpìn', 'ứng tuyển', 'apply for a job', 'động từ', '我来应聘市场经理这个职位。', 'Wǒ lái yìngpìn shìchǎng jīnglǐ zhège zhíwèi.', 'Tôi đến ứng tuyển vị trí giám đốc tiếp thị.'],
      ['经验', 'jīngyàn', 'kinh nghiệm', 'experience', 'danh từ', '我有三年项目管理经验。', 'Wǒ yǒu sān nián xiàngmù guǎnlǐ jīngyàn.', 'Tôi có ba năm kinh nghiệm quản lý dự án.'],
      ['负责', 'fùzé', 'phụ trách', 'be responsible for', 'động từ', '我曾经负责海外客户服务。', 'Wǒ céngjīng fùzé hǎiwài kèhù fúwù.', 'Tôi từng phụ trách dịch vụ khách hàng nước ngoài.'],
    ], ['Kinh nghiệm với 曾经', 'chủ ngữ + 曾经 + động từ', '曾经 nêu trải nghiệm quá khứ có liên quan đến hiện tại.', '我曾经负责一个国际项目。', 'Wǒ céngjīng fùzé yí ge guójì xiàngmù.', 'Tôi từng phụ trách một dự án quốc tế.', 'Câu nào trình bày kinh nghiệm làm việc?', '曾经 thường đi với 过 hoặc bối cảnh quá khứ rõ.', ['我', '曾经', '负责', '一个', '国际', '项目', '。']]],
  ],
});

courses.grammar = makeCourse({
  number: 11, key: 'grammar', slug: 'chinese-grammar', title: 'Chinese Grammar', titleZh: '汉语语法',
  level: 'upper-intermediate', orderIndex: 10, descriptionVi: 'Hệ thống hóa cấu trúc câu từ cơ bản đến phức hợp.',
  objectives: ['Phân tích thành phần câu', 'Chọn cấu trúc theo ý nghĩa', 'Sửa lỗi trật tự và liên kết'],
  topics: [
    ['thanh-phan-cau', '句子成分 — Thành phần câu', 'Nhận diện chủ ngữ, vị ngữ và tân ngữ.', 'Phân tích cấu trúc câu', [
      ['主语', 'zhǔyǔ', 'chủ ngữ', 'subject', 'danh từ', '这个句子的主语是“学生”。', 'Zhège jùzi de zhǔyǔ shì “xuésheng”.', 'Chủ ngữ của câu này là “học sinh”.'],
      ['谓语', 'wèiyǔ', 'vị ngữ', 'predicate', 'danh từ', '形容词也可以作谓语。', 'Xíngróngcí yě kěyǐ zuò wèiyǔ.', 'Tính từ cũng có thể làm vị ngữ.'],
      ['宾语', 'bīnyǔ', 'tân ngữ', 'object', 'danh từ', '“汉语”是动词“学习”的宾语。', '“Hànyǔ” shì dòngcí “xuéxí” de bīnyǔ.', '“Tiếng Trung” là tân ngữ của động từ “học”.'],
    ], ['Trật tự câu cơ bản', 'chủ ngữ + vị ngữ + tân ngữ', 'Trật tự cơ bản đặt người thực hiện trước động từ và đối tượng sau động từ.', '学生认真学习汉语。', 'Xuésheng rènzhēn xuéxí Hànyǔ.', 'Học sinh chăm chỉ học tiếng Trung.', 'Câu nào có trật tự cơ bản đúng?', 'Trạng ngữ thường đứng trước động từ vị ngữ.', ['学生', '认真', '学习', '汉语', '。']]],
    ['dinh-ngu', '复杂定语 — Định ngữ phức', 'Đặt cụm bổ nghĩa trước danh từ với 的.', 'Tạo cụm danh từ dài đúng trật tự', [
      ['定语', 'dìngyǔ', 'định ngữ', 'attributive', 'danh từ', '定语一般放在名词前面。', 'Dìngyǔ yìbān fàng zài míngcí qiánmiàn.', 'Định ngữ thường đặt trước danh từ.'],
      ['修饰', 'xiūshì', 'bổ nghĩa', 'modify', 'động từ', '这个短语用来修饰名词。', 'Zhège duǎnyǔ yònglái xiūshì míngcí.', 'Cụm này dùng để bổ nghĩa cho danh từ.'],
      ['中心语', 'zhōngxīnyǔ', 'trung tâm ngữ', 'head word', 'danh từ', '“书”是这个名词短语的中心语。', '“Shū” shì zhège míngcí duǎnyǔ de zhōngxīnyǔ.', '“Sách” là trung tâm ngữ của cụm danh từ này.'],
    ], ['Định ngữ với 的', 'cụm bổ nghĩa + 的 + danh từ trung tâm', 'Định ngữ dài hoặc có quan hệ sở hữu thường dùng 的.', '这是我昨天在书店买的书。', 'Zhè shì wǒ zuótiān zài shūdiàn mǎi de shū.', 'Đây là cuốn sách tôi mua ở hiệu sách hôm qua.', 'Cụm định ngữ nào đúng trật tự?', 'Danh từ trung tâm luôn đứng sau toàn bộ định ngữ.', ['这', '是', '我', '昨天', '在', '书店', '买', '的', '书', '。']]],
    ['bo-ngu', '补语系统 — Hệ thống bổ ngữ', 'Phân biệt bổ ngữ kết quả, xu hướng và khả năng.', 'Chọn bổ ngữ theo mục đích diễn đạt', [
      ['补语', 'bǔyǔ', 'bổ ngữ', 'complement', 'danh từ', '补语说明动作的结果或程度。', 'Bǔyǔ shuōmíng dòngzuò de jiéguǒ huò chéngdù.', 'Bổ ngữ giải thích kết quả hoặc mức độ của hành động.'],
      ['程度', 'chéngdù', 'mức độ', 'degree', 'danh từ', '这个副词表示程度很高。', 'Zhège fùcí biǎoshì chéngdù hěn gāo.', 'Phó từ này biểu thị mức độ rất cao.'],
      ['可能', 'kěnéng', 'khả năng; có thể', 'possibility; possible', 'danh từ/tính từ', '这种情况完全可能发生。', 'Zhè zhǒng qíngkuàng wánquán kěnéng fāshēng.', 'Tình huống này hoàn toàn có thể xảy ra.'],
    ], ['Bổ ngữ khả năng', 'động từ + 得/不 + bổ ngữ kết quả', '得 cho biết có khả năng đạt kết quả; 不 cho biết không thể.', '这篇文章我看得懂。', 'Zhè piān wénzhāng wǒ kàn de dǒng.', 'Bài này tôi đọc hiểu được.', 'Câu nào dùng bổ ngữ khả năng?', 'Không nhầm 看不懂 với 没看懂: một bên là khả năng, một bên là kết quả quá khứ.', ['这', '篇', '文章', '我', '看', '得', '懂', '。']]],
    ['lien-ket', '复句关系 — Quan hệ câu phức', 'Chọn cặp liên từ theo logic.', 'Kết nối mệnh đề mạch lạc', [
      ['转折', 'zhuǎnzhé', 'chuyển ý, tương phản', 'contrast', 'danh từ', '这两个分句之间是转折关系。', 'Zhè liǎng ge fēnjù zhījiān shì zhuǎnzhé guānxì.', 'Giữa hai mệnh đề là quan hệ tương phản.'],
      ['递进', 'dìjìn', 'tăng tiến', 'progression', 'danh từ', '“不但…而且…”表示递进。', '“Búdàn… érqiě…” biǎoshì dìjìn.', '“Không những… mà còn…” biểu thị tăng tiến.'],
      ['假设', 'jiǎshè', 'giả thiết', 'hypothesis', 'danh từ', '“如果”常用来提出假设。', '“Rúguǒ” cháng yònglái tíchū jiǎshè.', '“Nếu” thường dùng để nêu giả thiết.'],
    ], ['Tăng tiến với 不但', '不但 A，而且 B', 'Vế B bổ sung thông tin mạnh hơn hoặc quan trọng hơn A.', '这个方法不但简单，而且有效。', 'Zhège fāngfǎ búdàn jiǎndān, érqiě yǒuxiào.', 'Phương pháp này không những đơn giản mà còn hiệu quả.', 'Câu nào có quan hệ tăng tiến?', 'Hai vế nên cùng một chủ đề hoặc đặt chủ ngữ đúng vị trí.', ['这个', '方法', '不但', '简单', '，', '而且', '有效', '。']]],
  ],
});

courses.writing = makeCourse({
  number: 12, key: 'writing', slug: 'chinese-characters-writing', title: 'Chinese Characters and Writing', titleZh: '汉字书写',
  level: 'starter', orderIndex: 11, descriptionVi: 'Nền tảng cấu tạo, bộ thủ và quy tắc viết chữ Hán.',
  objectives: ['Nhận biết nét và bộ thủ', 'Phân tích cấu tạo chữ', 'Viết theo thứ tự nét chuẩn'],
  topics: [
    ['net-co-ban', '基本笔画 — Nét cơ bản', 'Nhận biết các nét thường gặp.', 'Gọi tên và phân biệt nét', [
      ['横', 'héng', 'nét ngang', 'horizontal stroke', 'danh từ', '写“一”时只有一个横。', 'Xiě “yī” shí zhǐ yǒu yí ge héng.', 'Khi viết “一” chỉ có một nét ngang.'],
      ['竖', 'shù', 'nét sổ', 'vertical stroke', 'danh từ', '“十”有一横一竖。', '“Shí” yǒu yì héng yí shù.', 'Chữ “十” có một nét ngang và một nét sổ.'],
      ['捺', 'nà', 'nét mác', 'right-falling stroke', 'danh từ', '“人”的第二笔是捺。', '“Rén” de dì-èr bǐ shì nà.', 'Nét thứ hai của chữ “人” là nét mác.'],
    ], ['Đếm nét với 有', 'chữ + 有 + số + lượng từ 笔', '笔 là lượng từ dùng để đếm nét chữ.', '“十”有两笔。', '“Shí” yǒu liǎng bǐ.', 'Chữ “十” có hai nét.', 'Câu nào đếm đúng số nét của 十?', 'Không có tài sản thứ tự nét giả; bài chỉ dạy quy tắc văn bản.', ['“十”', '有', '两', '笔', '。']], [
      { key: 'character:木', character: '木', pinyin: 'mù', meaningVi: 'cây, gỗ', radical: '木', strokeCount: 4, level: 'starter', status: 'review', componentBreakdown: { note: 'Chữ độc thể, cũng dùng làm bộ Mộc.' }, commonWords: ['木头', '树木'] },
    ]],
    ['thu-tu-net', '笔顺规则 — Thứ tự nét', 'Học trên-trước-dưới-sau và trái-trước-phải-sau.', 'Áp dụng quy tắc nét cơ bản', [
      ['笔顺', 'bǐshùn', 'thứ tự nét', 'stroke order', 'danh từ', '正确的笔顺有助于写好汉字。', 'Zhèngquè de bǐshùn yǒuzhùyú xiě hǎo Hànzì.', 'Thứ tự nét đúng giúp viết chữ Hán đẹp.'],
      ['先', 'xiān', 'trước', 'first', 'phó từ', '写“二”时先写上面的横。', 'Xiě “èr” shí xiān xiě shàngmiàn de héng.', 'Khi viết “二”, viết nét ngang trên trước.'],
      ['后', 'hòu', 'sau', 'after', 'danh từ/phó từ', '一般先写左边，后写右边。', 'Yìbān xiān xiě zuǒbian, hòu xiě yòubian.', 'Thông thường viết bên trái trước, bên phải sau.'],
    ], ['Trình tự với 先…后…', '先 + bước 1，后 + bước 2', 'Cấu trúc mô tả thứ tự hai thao tác.', '写“木”时先横后竖。', 'Xiě “mù” shí xiān héng hòu shù.', 'Khi viết “木”, nét ngang trước, nét sổ sau.', 'Câu nào mô tả đúng trình tự?', 'Quy tắc chung có ngoại lệ; cần đối chiếu từ điển nét chuẩn khi xuất bản.', ['写', '“木”', '时', '先', '横', '后', '竖', '。']], [
      { key: 'character:明', character: '明', pinyin: 'míng', meaningVi: 'sáng, rõ', radical: '日', strokeCount: 8, level: 'starter', status: 'review', componentBreakdown: { left: '日 (mặt trời)', right: '月 (mặt trăng)' }, commonWords: ['明天', '明白'] },
    ]],
    ['bo-thu', '常见部首 — Bộ thủ', 'Nhận biết bộ liên quan nghĩa.', 'Dùng bộ thủ để đoán trường nghĩa', [
      ['部首', 'bùshǒu', 'bộ thủ', 'radical', 'danh từ', '部首可以帮助我们查字典。', 'Bùshǒu kěyǐ bāngzhù wǒmen chá zìdiǎn.', 'Bộ thủ có thể giúp chúng ta tra từ điển.'],
      ['三点水', 'sāndiǎnshuǐ', 'bộ ba chấm thủy', 'water radical', 'danh từ', '“河”和“海”都有三点水。', '“Hé” hé “hǎi” dōu yǒu sāndiǎnshuǐ.', '“河” và “海” đều có bộ ba chấm thủy.'],
      ['提手旁', 'tíshǒupáng', 'bộ thủ', 'hand radical', 'danh từ', '“打”的左边是提手旁。', '“Dǎ” de zuǒbian shì tíshǒupáng.', 'Bên trái chữ “打” là bộ thủ.'],
    ], ['Cấu tạo với 由…组成', 'chữ + 由 + thành phần + 组成', '由…组成 dùng để giải thích các bộ phận cấu tạo.', '“休”由单人旁和“木”组成。', '“Xiū” yóu dānrénpáng hé “mù” zǔchéng.', 'Chữ “休” gồm bộ nhân đứng và chữ “木”.', 'Câu nào phân tích cấu tạo chữ?', 'Phân tích thành phần không thay thế dữ liệu lịch sử tự nguyên.', ['“休”', '由', '单人旁', '和', '“木”', '组成', '。']], [
      { key: 'character:休', character: '休', pinyin: 'xiū', meaningVi: 'nghỉ', radical: '亻', strokeCount: 6, level: 'starter', status: 'review', componentBreakdown: { left: '亻 (người)', right: '木 (cây)' }, commonWords: ['休息', '休假'] },
    ]],
    ['ket-cau', '汉字结构 — Kết cấu chữ', 'Phân biệt kết cấu trái-phải và trên-dưới.', 'Phân tích bố cục chữ', [
      ['结构', 'jiégòu', 'kết cấu', 'structure', 'danh từ', '“好”是左右结构。', '“Hǎo” shì zuǒyòu jiégòu.', 'Chữ “好” có kết cấu trái-phải.'],
      ['左右', 'zuǒyòu', 'trái-phải', 'left-right', 'danh từ phương vị', '左右两部分要写得紧凑。', 'Zuǒyòu liǎng bùfen yào xiě de jǐncòu.', 'Hai phần trái-phải cần viết cân gọn.'],
      ['上下', 'shàngxià', 'trên-dưới', 'top-bottom', 'danh từ phương vị', '“字”是上下结构。', '“Zì” shì shàngxià jiégòu.', 'Chữ “字” có kết cấu trên-dưới.'],
    ], ['Phân loại với 是', 'chữ + 是 + loại kết cấu', 'Dùng 是 để xác định loại bố cục của chữ.', '“明”是左右结构。', '“Míng” shì zuǒyòu jiégòu.', 'Chữ “明” có kết cấu trái-phải.', 'Câu nào xác định kết cấu của 明?', 'Bố cục cần được kiểm tra trực quan khi QA trên thiết bị.', ['“明”', '是', '左右', '结构', '。']], [
      { key: 'character:河', character: '河', pinyin: 'hé', meaningVi: 'sông', radical: '氵', strokeCount: 8, level: 'starter', status: 'review', componentBreakdown: { left: '氵 (nước)', right: '可 (gợi âm)' }, commonWords: ['河水', '黄河'] },
    ]],
  ],
});

courses.listening = makeCourse({
  number: 13, key: 'listening', slug: 'chinese-listening-practice', title: 'Chinese Listening Practice', titleZh: '汉语听力训练',
  level: 'elementary', orderIndex: 12, descriptionVi: 'Chiến lược nghe hiểu; bài nghe thật chờ tài sản âm thanh được duyệt.',
  objectives: ['Nghe từ khóa và số liệu', 'Theo dõi ý chính', 'Suy luận thái độ từ ngữ cảnh'],
  topics: [
    ['tu-khoa', '抓住关键词 — Từ khóa', 'Xác định từ mang thông tin chính.', 'Nghe và ghi lại từ khóa', [
      ['关键词', 'guānjiàncí', 'từ khóa', 'keyword', 'danh từ', '先找出对话里的关键词。', 'Xiān zhǎochū duìhuà lǐ de guānjiàncí.', 'Trước tiên tìm từ khóa trong hội thoại.'],
      ['重点', 'zhòngdiǎn', 'trọng điểm', 'key point', 'danh từ', '老师重复了今天的重点。', 'Lǎoshī chóngfù le jīntiān de zhòngdiǎn.', 'Giáo viên lặp lại trọng điểm hôm nay.'],
      ['记录', 'jìlù', 'ghi chép', 'record', 'động từ/danh từ', '听的时候记录时间和地点。', 'Tīng de shíhou jìlù shíjiān hé dìdiǎn.', 'Khi nghe hãy ghi thời gian và địa điểm.'],
    ], ['Chiến lược với 先', '先 + hành động ưu tiên', '先 đánh dấu bước nghe cần làm trước.', '听对话时先记录关键词。', 'Tīng duìhuà shí xiān jìlù guānjiàncí.', 'Khi nghe hội thoại hãy ghi từ khóa trước.', 'Câu nào nêu chiến lược nghe?', 'Khóa chưa xuất bản bài listening cho đến khi có audio thật.', ['听', '对话', '时', '先', '记录', '关键词', '。']]],
    ['so-lieu', '听清数字 — Số liệu', 'Phân biệt thời gian, giá và số điện thoại.', 'Kiểm tra lại số liệu nghe được', [
      ['数字', 'shùzì', 'con số', 'number', 'danh từ', '请把听到的数字写下来。', 'Qǐng bǎ tīngdào de shùzì xiě xiàlai.', 'Hãy viết lại con số nghe được.'],
      ['重复', 'chóngfù', 'lặp lại', 'repeat', 'động từ', '这个号码请重复一遍。', 'Zhège hàomǎ qǐng chóngfù yí biàn.', 'Xin lặp lại số này một lần.'],
      ['核对', 'héduì', 'đối chiếu', 'verify', 'động từ', '订票前请核对日期。', 'Dìngpiào qián qǐng héduì rìqī.', 'Trước khi đặt vé hãy đối chiếu ngày.'],
    ], ['Số lần với 遍', 'động từ + 一遍', '遍 đếm một lượt trọn vẹn của hành động.', '麻烦您把号码再说一遍。', 'Máfan nín bǎ hàomǎ zài shuō yí biàn.', 'Phiền ngài nói lại số một lần nữa.', 'Câu nào yêu cầu lặp lại trọn vẹn?', 'Không tạo bài nghe khi tệp âm thanh chưa sẵn sàng.', ['麻烦', '您', '把', '号码', '再', '说', '一遍', '。']]],
    ['y-chinh', '概括大意 — Ý chính', 'Theo dõi chủ đề và kết luận.', 'Tóm tắt nội dung nghe', [
      ['大意', 'dàyì', 'đại ý', 'main idea', 'danh từ', '听完以后请概括大意。', 'Tīngwán yǐhòu qǐng gàikuò dàyì.', 'Sau khi nghe xong hãy khái quát đại ý.'],
      ['主题', 'zhǔtí', 'chủ đề', 'theme', 'danh từ', '这段谈话的主题是健康。', 'Zhè duàn tánhuà de zhǔtí shì jiànkāng.', 'Chủ đề đoạn hội thoại này là sức khỏe.'],
      ['概括', 'gàikuò', 'khái quát', 'summarize', 'động từ', '请用一句话概括主要内容。', 'Qǐng yòng yí jù huà gàikuò zhǔyào nèiróng.', 'Hãy dùng một câu khái quát nội dung chính.'],
    ], ['Sau khi hoàn tất với 以后', 'động từ + 完 + 以后，…', '完 đánh dấu hoàn tất; 以后 dẫn bước tiếp theo.', '听完以后再概括主要内容。', 'Tīngwán yǐhòu zài gàikuò zhǔyào nèiróng.', 'Sau khi nghe xong hãy khái quát nội dung chính.', 'Câu nào có trình tự nghe rồi tóm tắt?', 'Chỉ bài tập đọc/thực hành chiến lược được sinh khi audio còn pending.', ['听', '完', '以后', '再', '概括', '主要', '内容', '。']]],
    ['thai-do', '判断语气 — Thái độ', 'Suy luận thái độ qua từ ngữ và ngữ điệu.', 'Nhận biết thái độ người nói', [
      ['语气', 'yǔqì', 'ngữ khí, giọng điệu', 'tone of voice', 'danh từ', '她的语气听起来很轻松。', 'Tā de yǔqì tīngqilai hěn qīngsōng.', 'Giọng điệu của cô ấy nghe rất thoải mái.'],
      ['态度', 'tàidu', 'thái độ', 'attitude', 'danh từ', '他说话的态度很诚恳。', 'Tā shuōhuà de tàidu hěn chéngkěn.', 'Thái độ nói chuyện của anh ấy rất chân thành.'],
      ['推测', 'tuīcè', 'suy đoán', 'infer', 'động từ', '我们可以从语气推测他的态度。', 'Wǒmen kěyǐ cóng yǔqì tuīcè tā de tàidu.', 'Chúng ta có thể suy đoán thái độ của anh ấy từ giọng điệu.'],
    ], ['Nguồn suy luận với 从', '从 + căn cứ + 推测 + kết luận', '从 giới thiệu căn cứ dùng để suy luận.', '我们从语气推测说话人的态度。', 'Wǒmen cóng yǔqì tuīcè shuōhuàrén de tàidu.', 'Chúng ta suy đoán thái độ người nói từ giọng điệu.', 'Câu nào nêu căn cứ suy luận?', 'Suy luận thái độ cần audio thật; hiện được giữ ở trạng thái review.', ['我们', '从', '语气', '推测', '说话人', '的', '态度', '。']]],
  ],
});

module.exports = courses;
