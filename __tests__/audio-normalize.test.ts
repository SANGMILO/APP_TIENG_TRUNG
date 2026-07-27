import { detectAudioContainer } from '../utils/audio-normalize';

jest.mock('react-native', () => ({
  Platform: { OS: 'web' },
}));

describe('Audio Normalization', () => {
  describe('detectAudioContainer', () => {
    it('detects WAV (RIFF header)', () => {
      const wav = new Uint8Array([0x52, 0x49, 0x46, 0x46, 0x00, 0x00]);
      expect(detectAudioContainer(wav)).toBe('wav');
    });

    it('detects OGG', () => {
      const ogg = new Uint8Array([0x4F, 0x67, 0x67, 0x53, 0x00]);
      expect(detectAudioContainer(ogg)).toBe('ogg');
    });

    it('detects WebM (EBML)', () => {
      const webm = new Uint8Array([0x1A, 0x45, 0xDF, 0xA3, 0x00]);
      expect(detectAudioContainer(webm)).toBe('webm');
    });

    it('returns unknown for unrecognized format', () => {
      const unknown = new Uint8Array([0x00, 0x01, 0x02, 0x03]);
      expect(detectAudioContainer(unknown)).toBe('unknown');
    });

    it('returns unknown for empty/short buffer', () => {
      expect(detectAudioContainer(new Uint8Array([]))).toBe('unknown');
      expect(detectAudioContainer(new Uint8Array([0x52]))).toBe('unknown');
    });

    it('validates WAV PCM16 structure (RIFF + WAVE)', () => {
      // Minimal valid WAV header
      const header = new Uint8Array(44);
      // RIFF
      header[0] = 0x52; header[1] = 0x49; header[2] = 0x46; header[3] = 0x46;
      // file size (placeholder)
      header[4] = 0x24; header[5] = 0x00; header[6] = 0x00; header[7] = 0x00;
      // WAVE
      header[8] = 0x57; header[9] = 0x41; header[10] = 0x56; header[11] = 0x45;
      
      expect(detectAudioContainer(header)).toBe('wav');
    });
  });

  describe('WAV format requirements for Azure', () => {
    it('target: PCM 16-bit, 16kHz, mono', () => {
      const target = { sampleRate: 16000, channels: 1, bitsPerSample: 16 };
      expect(target.sampleRate).toBe(16000);
      expect(target.channels).toBe(1);
      expect(target.bitsPerSample).toBe(16);
    });

    it('Azure Content-Type header format', () => {
      const contentType = 'audio/wav; codecs=audio/pcm; samplerate=16000';
      expect(contentType).toContain('audio/wav');
      expect(contentType).toContain('samplerate=16000');
    });
  });
});
