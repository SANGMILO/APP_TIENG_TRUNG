/**
 * Test UTF-8 to Base64 encoding for Azure Pronunciation Assessment header
 * Verifies Chinese characters survive encode → decode round-trip
 */

// Replicate the exact function from the Edge Function
function utf8ToBase64(value: string): string {
  const bytes = new TextEncoder().encode(value);
  let binary = '';
  const chunkSize = 0x8000;
  for (let i = 0; i < bytes.length; i += chunkSize) {
    binary += String.fromCharCode(...bytes.subarray(i, i + chunkSize));
  }
  return btoa(binary);
}

function base64ToUtf8(base64: string): string {
  const binary = atob(base64);
  const bytes = new Uint8Array(binary.length);
  for (let i = 0; i < binary.length; i++) {
    bytes[i] = binary.charCodeAt(i);
  }
  return new TextDecoder().decode(bytes);
}

describe('UTF-8 Base64 Encoding (Azure Pronunciation Header)', () => {
  const testCases = [
    { input: '你好', desc: 'Basic Chinese greeting' },
    { input: '谢谢', desc: 'Thank you' },
    { input: '我是越南人', desc: 'I am Vietnamese' },
    { input: '我想喝咖啡', desc: 'I want coffee' },
    { input: 'Hello', desc: 'ASCII only' },
    { input: '你好世界 Hello World 123', desc: 'Mixed Chinese + ASCII' },
  ];

  testCases.forEach(({ input, desc }) => {
    it(`round-trips: ${desc} (${input})`, () => {
      const config = JSON.stringify({
        ReferenceText: input,
        GradingSystem: 'HundredMark',
        Granularity: 'Word',
        Dimension: 'Comprehensive',
        EnableMiscue: true,
      });

      // Encode
      const encoded = utf8ToBase64(config);
      expect(typeof encoded).toBe('string');
      expect(encoded.length).toBeGreaterThan(0);

      // Decode back
      const decoded = base64ToUtf8(encoded);
      const parsed = JSON.parse(decoded);

      // Verify round-trip
      expect(parsed.ReferenceText).toBe(input);
      expect(parsed.GradingSystem).toBe('HundredMark');
    });
  });

  it('does NOT throw on Chinese characters (unlike raw btoa)', () => {
    expect(() => utf8ToBase64('你好')).not.toThrow();
  });

  it('raw btoa WOULD throw on Chinese (proving the bug)', () => {
    expect(() => btoa('你好')).toThrow();
  });
});
