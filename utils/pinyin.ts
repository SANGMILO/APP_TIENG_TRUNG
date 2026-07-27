/**
 * Pinyin utilities for Mandarin Master
 * Handles conversion between tone number and tone mark formats
 */

// Tone mark mappings for vowels
const TONE_MARKS: Record<string, string[]> = {
  'a': ['ā', 'á', 'ǎ', 'à', 'a'],
  'e': ['ē', 'é', 'ě', 'è', 'e'],
  'i': ['ī', 'í', 'ǐ', 'ì', 'i'],
  'o': ['ō', 'ó', 'ǒ', 'ò', 'o'],
  'u': ['ū', 'ú', 'ǔ', 'ù', 'u'],
  'ü': ['ǖ', 'ǘ', 'ǚ', 'ǜ', 'ü'],
};

// Reverse mapping: marked vowel → [base, tone]
const MARK_TO_TONE: Record<string, [string, number]> = {};
for (const [base, marks] of Object.entries(TONE_MARKS)) {
  marks.forEach((mark, i) => {
    if (mark !== base) {
      MARK_TO_TONE[mark] = [base, i + 1];
    }
  });
}

/**
 * Parse a pinyin syllable into base and tone number
 * Examples: "nǐ" → { base: "ni", tone: 3 }, "hao3" → { base: "hao", tone: 3 }
 */
export function parsePinyin(pinyin: string): { base: string; tone: number } {
  const trimmed = pinyin.trim().toLowerCase();

  // Check if ends with tone number (1-5)
  const lastChar = trimmed[trimmed.length - 1];
  if (/[1-5]/.test(lastChar)) {
    return {
      base: trimmed.slice(0, -1).replace(/v/g, 'ü'),
      tone: parseInt(lastChar),
    };
  }

  // Check for tone marks
  let base = '';
  let tone = 5; // neutral/no tone
  for (const char of trimmed) {
    if (MARK_TO_TONE[char]) {
      const [baseChar, toneNum] = MARK_TO_TONE[char];
      base += baseChar;
      tone = toneNum;
    } else {
      base += char;
    }
  }

  // Handle v/ü
  base = base.replace(/v/g, 'ü');

  return { base, tone };
}

/**
 * Convert tone number format to tone mark format
 * Example: "ni3" → "nǐ", "hao3" → "hǎo"
 */
export function toneNumberToMark(pinyin: string): string {
  const trimmed = pinyin.trim().toLowerCase();
  const lastChar = trimmed[trimmed.length - 1];

  if (!/[1-5]/.test(lastChar)) {
    return trimmed; // Already has marks or no tone
  }

  const tone = parseInt(lastChar);
  const base = trimmed.slice(0, -1).replace(/v/g, 'ü');

  if (tone === 5) return base; // Neutral tone, no mark

  // Find the vowel to put the mark on (rule: a/e get it, otherwise last vowel in ou/ao etc.)
  const vowelIndex = findToneVowelIndex(base);
  if (vowelIndex === -1) return base;

  const vowel = base[vowelIndex];
  const marks = TONE_MARKS[vowel];
  if (!marks) return base;

  return base.slice(0, vowelIndex) + marks[tone - 1] + base.slice(vowelIndex + 1);
}

/**
 * Convert tone mark format to tone number format
 * Example: "nǐ" → "ni3", "hǎo" → "hao3"
 */
export function toneMarkToNumber(pinyin: string): string {
  const { base, tone } = parsePinyin(pinyin);
  return tone === 5 ? base : `${base}${tone}`;
}

/**
 * Remove tone from pinyin (return base syllable)
 */
export function stripTone(pinyin: string): string {
  return parsePinyin(pinyin).base;
}

/**
 * Get tone number from pinyin
 */
export function getTone(pinyin: string): number {
  return parsePinyin(pinyin).tone;
}

/**
 * Normalize pinyin to canonical display format (tone marks)
 * Handles: "ni3 hao3" → "nǐ hǎo", "nǐ hǎo" → "nǐ hǎo"
 */
export function normalizePinyin(pinyin: string): string {
  return pinyin
    .trim()
    .split(/\s+/)
    .map(syllable => {
      // If has number suffix, convert to mark
      const last = syllable[syllable.length - 1];
      if (/[1-5]/.test(last)) {
        return toneNumberToMark(syllable);
      }
      return syllable;
    })
    .join(' ');
}

/**
 * Find the index of the vowel that should receive the tone mark
 * Rules:
 * 1. "a" and "e" always get the mark
 * 2. In "ou", the "o" gets it
 * 3. Otherwise, the second vowel gets it
 */
function findToneVowelIndex(syllable: string): number {
  const vowels = 'aeiouü';

  // Rule 1: a and e always get the mark
  const aIdx = syllable.indexOf('a');
  if (aIdx !== -1) return aIdx;
  const eIdx = syllable.indexOf('e');
  if (eIdx !== -1) return eIdx;

  // Rule 2: ou → o gets it
  const ouIdx = syllable.indexOf('ou');
  if (ouIdx !== -1) return ouIdx;

  // Rule 3: last vowel
  let lastVowelIdx = -1;
  for (let i = 0; i < syllable.length; i++) {
    if (vowels.includes(syllable[i])) {
      lastVowelIdx = i;
    }
  }
  return lastVowelIdx;
}
