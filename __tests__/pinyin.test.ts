import { parsePinyin, toneNumberToMark, toneMarkToNumber, stripTone, getTone, normalizePinyin } from '../utils/pinyin';

describe('Pinyin Utils', () => {
  describe('parsePinyin', () => {
    it('parses tone mark format', () => {
      expect(parsePinyin('nǐ')).toEqual({ base: 'ni', tone: 3 });
      expect(parsePinyin('hǎo')).toEqual({ base: 'hao', tone: 3 });
      expect(parsePinyin('mā')).toEqual({ base: 'ma', tone: 1 });
    });

    it('parses tone number format', () => {
      expect(parsePinyin('ni3')).toEqual({ base: 'ni', tone: 3 });
      expect(parsePinyin('hao3')).toEqual({ base: 'hao', tone: 3 });
      expect(parsePinyin('ma1')).toEqual({ base: 'ma', tone: 1 });
    });

    it('handles neutral tone', () => {
      expect(parsePinyin('ma5')).toEqual({ base: 'ma', tone: 5 });
      expect(parsePinyin('ma')).toEqual({ base: 'ma', tone: 5 });
    });

    it('handles ü', () => {
      expect(parsePinyin('lv4')).toEqual({ base: 'lü', tone: 4 });
      expect(parsePinyin('nǚ')).toEqual({ base: 'nü', tone: 3 });
    });
  });

  describe('toneNumberToMark', () => {
    it('converts basic syllables', () => {
      expect(toneNumberToMark('ni3')).toBe('nǐ');
      expect(toneNumberToMark('hao3')).toBe('hǎo');
      expect(toneNumberToMark('ma1')).toBe('mā');
      expect(toneNumberToMark('shi4')).toBe('shì');
    });

    it('handles tone 5 (neutral)', () => {
      expect(toneNumberToMark('ma5')).toBe('ma');
    });

    it('places mark on correct vowel (a/e rule)', () => {
      expect(toneNumberToMark('bai2')).toBe('bái');
      expect(toneNumberToMark('mei2')).toBe('méi');
    });

    it('already marked input passes through', () => {
      expect(toneNumberToMark('nǐ')).toBe('nǐ');
    });
  });

  describe('toneMarkToNumber', () => {
    it('converts mark format to number', () => {
      expect(toneMarkToNumber('nǐ')).toBe('ni3');
      expect(toneMarkToNumber('hǎo')).toBe('hao3');
      expect(toneMarkToNumber('mā')).toBe('ma1');
    });

    it('neutral tone has no number', () => {
      expect(toneMarkToNumber('ma')).toBe('ma');
    });
  });

  describe('stripTone', () => {
    it('removes tone from marked pinyin', () => {
      expect(stripTone('nǐ')).toBe('ni');
      expect(stripTone('hǎo')).toBe('hao');
    });

    it('removes number from numbered pinyin', () => {
      expect(stripTone('ni3')).toBe('ni');
    });
  });

  describe('getTone', () => {
    it('extracts tone number', () => {
      expect(getTone('nǐ')).toBe(3);
      expect(getTone('mā')).toBe(1);
      expect(getTone('shì')).toBe(4);
      expect(getTone('ma')).toBe(5);
    });
  });

  describe('normalizePinyin', () => {
    it('converts number format to mark format', () => {
      expect(normalizePinyin('ni3 hao3')).toBe('nǐ hǎo');
    });

    it('passes through already marked pinyin', () => {
      expect(normalizePinyin('nǐ hǎo')).toBe('nǐ hǎo');
    });

    it('handles mixed input', () => {
      expect(normalizePinyin('ni3 hǎo')).toBe('nǐ hǎo');
    });
  });
});
