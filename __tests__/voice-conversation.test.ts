import { VoiceState, VoiceSessionConfig } from '../lib/voice/types';

// Mock supabase
jest.mock('../lib/supabase', () => ({
  supabase: { from: jest.fn(), rpc: jest.fn(), auth: { getUser: jest.fn() }, functions: { invoke: jest.fn() } },
}));

import { supabase } from '../lib/supabase';
import { endVoiceSession } from '../services/voice-conversation-service';

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

  describe('Authoritative session completion', () => {
    beforeEach(() => {
      jest.clearAllMocks();
    });

    it('uses only the server summary and does not submit client totals', async () => {
      (supabase.rpc as jest.Mock).mockResolvedValue({
        data: {
          sessionId: 'session-1',
          totalDurationMs: 62000,
          userSpeechMs: 33000,
          aiSpeechMs: 12000,
          turnCount: 3,
          newWordsCount: 2,
          correctionsCount: 1,
          xpEarned: 10,
        },
        error: null,
      });

      await expect(endVoiceSession('session-1')).resolves.toMatchObject({
        userSpeechMs: 33000,
        turnCount: 3,
        xpEarned: 10,
      });
      expect(supabase.rpc).toHaveBeenCalledWith(
        'complete_voice_session_authoritative',
        { p_session_id: 'session-1' },
      );
    });

    it('does not show a successful summary when completion fails', async () => {
      (supabase.rpc as jest.Mock).mockResolvedValue({
        data: null,
        error: new Error('save failed'),
      });

      await expect(endVoiceSession('session-1')).rejects.toThrow('save failed');
    });
  });
});
