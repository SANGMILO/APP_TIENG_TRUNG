export interface Pcm16Chunk {
  data: ArrayBuffer;
  sampleRate: number;
  channels: number;
}

const TARGET_SAMPLE_RATE = 16000;
const WAV_HEADER_BYTES = 44;

function writeAscii(view: DataView, offset: number, value: string): void {
  for (let index = 0; index < value.length; index += 1) {
    view.setUint8(offset + index, value.charCodeAt(index));
  }
}

function readMonoSamples(chunks: Pcm16Chunk[]): {
  samples: Int16Array;
  sampleRate: number;
} {
  if (chunks.length === 0) {
    throw new Error('No PCM audio was captured.');
  }

  const sampleRate = chunks[0].sampleRate;
  const channels = chunks[0].channels;
  if (
    !Number.isInteger(sampleRate)
    || sampleRate <= 0
    || !Number.isInteger(channels)
    || channels <= 0
  ) {
    throw new Error('The PCM stream format is invalid.');
  }

  let frameCount = 0;
  for (const chunk of chunks) {
    if (chunk.sampleRate !== sampleRate || chunk.channels !== channels) {
      throw new Error('The PCM stream format changed while recording.');
    }
    if (chunk.data.byteLength % (channels * 2) !== 0) {
      throw new Error('The PCM stream contains an incomplete audio frame.');
    }
    frameCount += chunk.data.byteLength / (channels * 2);
  }

  const mono = new Int16Array(frameCount);
  let outputFrame = 0;

  for (const chunk of chunks) {
    const view = new DataView(chunk.data);
    const chunkFrames = chunk.data.byteLength / (channels * 2);
    for (let frame = 0; frame < chunkFrames; frame += 1) {
      let sum = 0;
      for (let channel = 0; channel < channels; channel += 1) {
        const byteOffset = (frame * channels + channel) * 2;
        sum += view.getInt16(byteOffset, true);
      }
      mono[outputFrame] = Math.max(
        -32768,
        Math.min(32767, Math.round(sum / channels)),
      );
      outputFrame += 1;
    }
  }

  return { samples: mono, sampleRate };
}

function resamplePcm16(
  input: Int16Array,
  inputSampleRate: number,
  outputSampleRate: number,
): Int16Array {
  if (inputSampleRate === outputSampleRate || input.length === 0) {
    return input;
  }

  const outputLength = Math.max(
    1,
    Math.round(input.length * outputSampleRate / inputSampleRate),
  );
  const output = new Int16Array(outputLength);
  const ratio = inputSampleRate / outputSampleRate;

  for (let index = 0; index < outputLength; index += 1) {
    const sourcePosition = index * ratio;
    const leftIndex = Math.min(input.length - 1, Math.floor(sourcePosition));
    const rightIndex = Math.min(input.length - 1, leftIndex + 1);
    const fraction = sourcePosition - leftIndex;
    output[index] = Math.round(
      input[leftIndex] * (1 - fraction) + input[rightIndex] * fraction,
    );
  }

  return output;
}

export function encodePcm16ChunksAsWav(
  chunks: Pcm16Chunk[],
  targetSampleRate = TARGET_SAMPLE_RATE,
): ArrayBuffer {
  if (!Number.isInteger(targetSampleRate) || targetSampleRate <= 0) {
    throw new Error('The target sample rate is invalid.');
  }

  const { samples, sampleRate } = readMonoSamples(chunks);
  const normalized = resamplePcm16(samples, sampleRate, targetSampleRate);
  const dataBytes = normalized.length * 2;
  const wav = new ArrayBuffer(WAV_HEADER_BYTES + dataBytes);
  const view = new DataView(wav);

  writeAscii(view, 0, 'RIFF');
  view.setUint32(4, WAV_HEADER_BYTES - 8 + dataBytes, true);
  writeAscii(view, 8, 'WAVE');
  writeAscii(view, 12, 'fmt ');
  view.setUint32(16, 16, true);
  view.setUint16(20, 1, true);
  view.setUint16(22, 1, true);
  view.setUint32(24, targetSampleRate, true);
  view.setUint32(28, targetSampleRate * 2, true);
  view.setUint16(32, 2, true);
  view.setUint16(34, 16, true);
  writeAscii(view, 36, 'data');
  view.setUint32(40, dataBytes, true);

  for (let index = 0; index < normalized.length; index += 1) {
    view.setInt16(WAV_HEADER_BYTES + index * 2, normalized[index], true);
  }

  return wav;
}

export function wavArrayBufferToDataUri(wav: ArrayBuffer): string {
  const bytes = new Uint8Array(wav);
  let binary = '';

  for (let offset = 0; offset < bytes.length; offset += 0x8000) {
    const chunk = bytes.subarray(offset, Math.min(offset + 0x8000, bytes.length));
    let text = '';
    for (let index = 0; index < chunk.length; index += 1) {
      text += String.fromCharCode(chunk[index]);
    }
    binary += text;
  }

  return `data:audio/wav;base64,${btoa(binary)}`;
}
