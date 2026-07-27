// Analytics Service Abstraction

export type AnalyticsEvent =
  | 'lesson_started'
  | 'lesson_completed'
  | 'exercise_answered'
  | 'pronunciation_attempt'
  | 'pronunciation_started'
  | 'pronunciation_recorded'
  | 'pronunciation_assessed'
  | 'pronunciation_retry'
  | 'pronunciation_passed'
  | 'tone_training_started'
  | 'tone_answered'
  | 'tone_training_completed'
  | 'video_viewed'
  | 'video_started'
  | 'video_paused'
  | 'video_resumed'
  | 'video_seeked'
  | 'video_completed'
  | 'video_question_shown'
  | 'video_question_answered'
  | 'video_word_opened'
  | 'video_word_saved'
  | 'subtitle_mode_changed'
  | 'daily_goal_completed'
  | 'streak_updated'
  | 'ai_tutor_started'
  | 'ai_tutor_opened'
  | 'ai_conversation_created'
  | 'ai_message_sent'
  | 'ai_response_completed'
  | 'ai_response_cancelled'
  | 'ai_correction_viewed'
  | 'ai_word_saved'
  | 'ai_suggested_reply_used'
  | 'ai_feedback_submitted'
  | 'ai_practice_completed'
  | 'achievement_unlocked'
  | 'word_saved'
  | 'review_completed';

export interface AnalyticsProperties {
  [key: string]: string | number | boolean | undefined;
}

export interface IAnalyticsProvider {
  track(event: AnalyticsEvent, properties?: AnalyticsProperties): void;
  identify(userId: string, traits?: AnalyticsProperties): void;
  reset(): void;
}
