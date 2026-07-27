import { useQuery } from '@tanstack/react-query';
import { supabase } from '@/lib/supabase';
import { Course, Unit, Chapter, Lesson } from '@/types';

export function useCourses() {
  return useQuery({
    queryKey: ['courses'],
    queryFn: async () => {
      const { data, error } = await supabase
        .from('courses')
        .select('*')
        .eq('status', 'published')
        .order('order_index');

      if (error) throw error;
      return data as Course[];
    },
  });
}

export function useCourseUnits(courseId: string) {
  return useQuery({
    queryKey: ['units', courseId],
    queryFn: async () => {
      const { data, error } = await supabase
        .from('units')
        .select('*')
        .eq('course_id', courseId)
        .eq('status', 'published')
        .order('order_index');

      if (error) throw error;
      return data as Unit[];
    },
    enabled: !!courseId,
  });
}

export function useChapterLessons(chapterId: string) {
  return useQuery({
    queryKey: ['lessons', chapterId],
    queryFn: async () => {
      const { data, error } = await supabase
        .from('lessons')
        .select('*')
        .eq('chapter_id', chapterId)
        .eq('status', 'published')
        .order('order_index');

      if (error) throw error;
      return data as Lesson[];
    },
    enabled: !!chapterId,
  });
}

export function useLessonExercises(lessonId: string) {
  return useQuery({
    queryKey: ['exercises', lessonId],
    queryFn: async () => {
      const { data, error } = await supabase
        .from('exercises')
        .select(`
          *,
          exercise_options (*)
        `)
        .eq('lesson_id', lessonId)
        .order('order_index');

      if (error) throw error;
      return data;
    },
    enabled: !!lessonId,
  });
}
