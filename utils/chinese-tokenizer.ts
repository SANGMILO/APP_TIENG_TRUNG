/**
 * Chinese Tokenizer - Vocabulary-aware longest match
 * Segments Chinese text into meaningful tokens for interactive subtitles
 * 
 * This is a simple forward maximum matching approach.
 * Can be replaced with jieba/NLP backend in the future.
 */

export interface ChineseToken {
  text: string;
  isWord: boolean;     // true if found in dictionary
  isPunctuation: boolean;
  startIndex: number;
  endIndex: number;
}

const CHINESE_PUNCTUATION = new Set([
  '\uFF0C', '\u3002', '\uFF01', '\uFF1F', '\u3001', '\uFF1B', '\uFF1A',
  '\u201C', '\u201D', '\u2018', '\u2019',
  '\uFF08', '\uFF09', '\u3010', '\u3011', '\u300A', '\u300B',
  '\u2026', '\u2014', '\u00B7', '\uFF5E',
  ',', '.', '!', '?', ';', ':', '"', "'", '(', ')', ' ',
]);

/**
 * Tokenize Chinese text using longest match against a dictionary
 * @param text - Chinese text to tokenize
 * @param dictionary - Set of known words/phrases
 * @param maxWordLength - Maximum word length to check (default 5 characters)
 */
export function tokenizeChinese(
  text: string,
  dictionary: Set<string>,
  maxWordLength: number = 5
): ChineseToken[] {
  const tokens: ChineseToken[] = [];
  let i = 0;

  while (i < text.length) {
    const char = text[i];

    // Handle punctuation
    if (CHINESE_PUNCTUATION.has(char)) {
      tokens.push({
        text: char,
        isWord: false,
        isPunctuation: true,
        startIndex: i,
        endIndex: i + 1,
      });
      i++;
      continue;
    }

    // Forward maximum matching
    let matched = false;
    const maxLen = Math.min(maxWordLength, text.length - i);

    for (let len = maxLen; len > 1; len--) {
      const candidate = text.slice(i, i + len);
      if (dictionary.has(candidate)) {
        tokens.push({
          text: candidate,
          isWord: true,
          isPunctuation: false,
          startIndex: i,
          endIndex: i + len,
        });
        i += len;
        matched = true;
        break;
      }
    }

    // Single character (either in dict or standalone)
    if (!matched) {
      const singleChar = text[i];
      tokens.push({
        text: singleChar,
        isWord: dictionary.has(singleChar),
        isPunctuation: false,
        startIndex: i,
        endIndex: i + 1,
      });
      i++;
    }
  }

  return tokens;
}

/**
 * Create a dictionary set from vocabulary entries
 */
export function buildDictionary(vocabularyEntries: { chinese: string }[]): Set<string> {
  return new Set(vocabularyEntries.map(v => v.chinese));
}
