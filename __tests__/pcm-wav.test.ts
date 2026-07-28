import {
  encodePcm16ChunksAsWav,
  wavArrayBufferToDataUri,
} from '../utils/pcm-wav';

function pcmChunk(
  samples: number[],
  sampleRate = 16000,
  channels = 1,
) {
  const data = new ArrayBuffer(samples.length * 2);
  const view = new DataView(data);
  samples.forEach((sample, index) => {
    view.setInt16(index * 2, sample, true);
  });
  return { data, sampleRate, channels };
}

describe('native PCM WAV encoding', () => {
  it('writes a valid 16 kHz mono PCM WAV header and samples', () => {
    const wav = encodePcm16ChunksAsWav([
      pcmChunk([0, 1200]),
      pcmChunk([-1200, 32767]),
    ]);
    const view = new DataView(wav);
    const ascii = (offset: number, length: number) => String.fromCharCode(
      ...new Uint8Array(wav, offset, length),
    );

    expect(ascii(0, 4)).toBe('RIFF');
    expect(ascii(8, 4)).toBe('WAVE');
    expect(ascii(36, 4)).toBe('data');
    expect(view.getUint16(20, true)).toBe(1);
    expect(view.getUint16(22, true)).toBe(1);
    expect(view.getUint32(24, true)).toBe(16000);
    expect(view.getUint16(34, true)).toBe(16);
    expect(view.getUint32(40, true)).toBe(8);
    expect(view.getInt16(46, true)).toBe(1200);
    expect(view.getInt16(48, true)).toBe(-1200);
  });

  it('downmixes stereo and resamples device PCM to 16 kHz', () => {
    const wav = encodePcm16ChunksAsWav([
      pcmChunk([
        1000, -1000,
        3000, 1000,
        -3000, -1000,
        2000, 0,
      ], 32000, 2),
    ]);
    const view = new DataView(wav);

    expect(view.getUint32(24, true)).toBe(16000);
    expect(view.getUint16(22, true)).toBe(1);
    expect(view.getUint32(40, true)).toBe(4);
    expect(view.getInt16(44, true)).toBe(0);
    expect(view.getInt16(46, true)).toBe(-2000);
  });

  it('creates a fetchable WAV data URI', async () => {
    const wav = encodePcm16ChunksAsWav([pcmChunk([0, 100, -100])]);
    const uri = wavArrayBufferToDataUri(wav);
    const response = await fetch(uri);
    const decoded = await response.arrayBuffer();

    expect(uri).toMatch(/^data:audio\/wav;base64,/);
    expect(new Uint8Array(decoded)).toEqual(new Uint8Array(wav));
  });

  it('rejects empty or inconsistent PCM streams', () => {
    expect(() => encodePcm16ChunksAsWav([])).toThrow('No PCM audio');
    expect(() => encodePcm16ChunksAsWav([
      pcmChunk([1], 16000),
      pcmChunk([1], 48000),
    ])).toThrow('format changed');
  });
});
