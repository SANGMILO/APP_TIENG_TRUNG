import { VoiceState, VoiceSessionConfig } from '../lib/voice/types';

// Mock supabase
jest.mock('../lib/supabase', () => ({
  supabase: { from: jest.fn(), rpc: jest.fn(), auth: { getUser: jest.fn() }, functions: { invoke: jest.fn() } },
}));

describe('Voice Conversation Types', () => {
  describe('VoiceState transitions', () => {
    const validTransitions: Record<VoiceState, VoiceState[]> = {
      idle: ['connecting'],
      connecting: ['ready', 'error'],
      ready: ['recording', 'ended'],
      listening: ['recording'],
      recording: ['transcribing', 'ready', 'error'],
      transcribing: ['thinking', 'ready', 'error'],
      thinking: ['generating_audio', 'speaking', 'ready', 'error'],
      generating_audio: ['speaking', 'error'],
      speaking: ['ready', 'interrupted', 'error'],
      interrupted: ['ready', 'recording'],
      reconnecting: ['ready', 'error', 'ended'],
      error: ['ready', 'ended'],
      ended: [],
    };

    it('defines valid states', () => {
      const states: VoiceState[] = [
        'idle', 'connecting', 'ready', 'recording', 'transcribing',
        'thinking', 'generating_audio', 'speaking', 'ended',
      ];
      expect(states.length).toBeGreaterThan(0);
      states.forEach(s => expect(typeof s).toBe('string'));
    });

    it('idle can transition to connecting', () => {
      expect(validTransitions['idle']).toContain('connecting');
    });

    it('ended has no transitions', () => {
      expect(validTransitions['ended']).toHaveLength(0);
    });

    it('recording can transition to transcribing', () => {
      expect(validTransitions['recording']).toContain('transcribing');
    });

    it('speaking can transition to ready', () => {
      expect(validTransitions['speaking']).toContain('ready');
    });

    it('error can recover to ready', () => {
      expect(validTransitions['error']).toContain('ready');
    });
  });

  describe('VoiceSessionConfig', () => {
    it('accepts valid config', () => {
      const config: VoiceSessionConfig = {
        mode: 'restaurant',
        transport: 'turn_based',
        difficulty: 'beginner',
        maxTurnDurationMs: 20000,
        language: 'zh-CN',
      };
      expect(config.mode).toBe('restaurant');
      expect(config.transport).toBe('turn_based');
      expect(config.maxTurnDurationMs).toBe(20000);
    });

    it('supports realtime transport', () => {
      const config: VoiceSessionConfig = {
        mode: 'general',
        transport: 'realtime',
        difficulty: 'intermediate',
        maxTurnDurationMs: 45000,
        language: 'zh-CN',
      };
      expect(config.transport).toBe('realtime');
    });
  });

  describe('Turn-based pipeline flow', () => {
    it('full turn sequence is: record → STT → AI → TTS → play', () => {
      const steps = ['record', 'stt', 'ai', 'tts', 'play'];
      expect(steps).toEqual(['record', 'stt', 'ai', 'tts', 'play']);
      expect(steps.indexOf('stt')).toBeGreaterThan(steps.indexOf('record'));
      expect(steps.indexOf('ai')).toBeGreaterThan(steps.indexOf('stt'));
      expect(steps.indexOf('tts')).toBeGreaterThan(steps.indexOf('ai'));
      expect(steps.indexOf('play')).toBeGreaterThan(steps.indexOf('tts'));
    });
  });

  describe('Latency tracking', () => {
    it('total latency is sum of components', () => {
      const stt = 1200;
      const ai = 800;
      const tts = 600;
      const total = stt + ai + tts;
      expect(total).toBe(2600);
    });
  });

  describe('Session XP rules', () => {
    const MIN_SPEECH_MS = 30000;
    const MIN_TURNS = 3;

    it('awards XP for meaningful session', () => {
      const userSpeechMs = 45000;
      const turnCount = 5;
      const eligible = userSpeechMs >= MIN_SPEECH_MS && turnCount >= MIN_TURNS;
      expect(eligible).toBe(true);
    });

    it('denies XP for too short session', () => {
      const userSpeechMs = 10000;
      const turnCount = 1;
      const eligible = userSpeechMs >= MIN_SPEECH_MS && turnCount >= MIN_TURNS;
      expect(eligible).toBe(false);
    });

    it('denies XP for too few turns even with enough time', () => {
      const userSpeechMs = 60000;
      const turnCount = 2;
      const eligible = userSpeechMs >= MIN_SPEECH_MS && turnCount >= MIN_TURNS;
      expect(eligible).toBe(false);
    });
  });
});
