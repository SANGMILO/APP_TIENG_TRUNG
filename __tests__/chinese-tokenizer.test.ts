import { tokenizeChinese, buildDictionary } from '../utils/chinese-tokenizer';

describe('Chinese Tokenizer', () => {
  const vocab = [
    { chinese: '北京' },
    { chinese: '今天' },
    { chinese: '想' },
    { chinese: '去' },
    { chinese: '我' },
    { chinese: '你好' },
    { chinese: '学生' },
  ];
  const dictionary = buildDictionary(vocab);

  it('tokenizes with longest match', () => {
    const tokens = tokenizeChinese('我今天想去北京', dictionary);
    const words = tokens.map(t => t.text);
    expect(words).toEqual(['我', '今天', '想', '去', '北京']);
  });

  it('marks dictionary words as isWord', () => {
    const tokens = tokenizeChinese('我今天', dictionary);
    expect(tokens[0].isWord).toBe(true); // 我
    expect(tokens[1].isWord).toBe(true); // 今天
  });

  it('handles punctuation', () => {
    const tokens = tokenizeChinese('你好！', dictionary);
    expect(tokens[0].text).toBe('你好');
    expect(tokens[0].isWord).toBe(true);
    expect(tokens[1].text).toBe('！');
    expect(tokens[1].isPunctuation).toBe(true);
  });

  it('handles unknown characters', () => {
    const tokens = tokenizeChinese('吃饭', dictionary);
    expect(tokens[0].text).toBe('吃');
    expect(tokens[0].isWord).toBe(false);
    expect(tokens[1].text).toBe('饭');
    expect(tokens[1].isWord).toBe(false);
  });

  it('handles mixed known and unknown', () => {
    const tokens = tokenizeChinese('我是学生', dictionary);
    const texts = tokens.map(t => t.text);
    expect(texts).toEqual(['我', '是', '学生']);
    expect(tokens[0].isWord).toBe(true);  // 我 in dict
    expect(tokens[1].isWord).toBe(false); // 是 not in dict
    expect(tokens[2].isWord).toBe(true);  // 学生 in dict
  });

  it('handles empty string', () => {
    expect(tokenizeChinese('', dictionary)).toEqual([]);
  });

  it('provides correct indices', () => {
    const tokens = tokenizeChinese('你好世界', dictionary);
    expect(tokens[0].startIndex).toBe(0);
    expect(tokens[0].endIndex).toBe(2); // 你好 is 2 chars
    expect(tokens[1].startIndex).toBe(2);
  });

  describe('buildDictionary', () => {
    it('creates a Set from vocabulary', () => {
      const dict = buildDictionary([{ chinese: '学生' }, { chinese: '老师' }]);
      expect(dict.has('学生')).toBe(true);
      expect(dict.has('老师')).toBe(true);
      expect(dict.has('同学')).toBe(false);
    });
  });
});
