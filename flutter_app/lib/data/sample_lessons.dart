import '../models/video_lesson.dart';

class SampleLessons {
  // Get sample video lessons for a specific date
  static List<VideoLesson> getVideoLessons(DateTime date) {
    // Generate "random" but consistent lessons for each date
    final dateSeed = date.day + (date.month * 31);
    
    // Lessons library
    final lessonLibrary = [
      VideoLesson(
        id: 'bjj-101',
        title: 'Armbar from Guard',
        subject: 'Submissions',
        description: 'Learn the basic armbar technique from closed guard position. This fundamental submission is essential for any Jiu Jitsu practitioner.',
        duration: '15 min',
        videoUrl: 'https://sample-videos.com/video123/mp4/720/big_buck_bunny_720p_1mb.mp4',
        date: '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}',
      ),
      VideoLesson(
        id: 'bjj-102',
        title: 'Triangle Choke Fundamentals',
        subject: 'Submissions',
        description: 'Master the triangle choke from guard position. Learn proper angles, control points, and finishing details for a high-percentage submission.',
        duration: '20 min',
        videoUrl: 'https://sample-videos.com/video123/mp4/720/big_buck_bunny_720p_1mb.mp4',
        date: '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}',
      ),
      VideoLesson(
        id: 'bjj-103',
        title: 'Guard Passing Fundamentals',
        subject: 'Positions',
        description: 'Learn essential guard passing techniques including toreando pass, knee slice, and over-under pass to improve your top game.',
        duration: '18 min',
        videoUrl: 'https://sample-videos.com/video123/mp4/720/big_buck_bunny_720p_1mb.mp4',
        date: '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}',
      ),
      VideoLesson(
        id: 'bjj-104',
        title: 'Closed Guard Fundamentals',
        subject: 'Positions',
        description: 'Master the closed guard position with proper hip control, posture breaking, and sweeping techniques for effective bottom game control.',
        duration: '22 min',
        videoUrl: 'https://sample-videos.com/video123/mp4/720/big_buck_bunny_720p_1mb.mp4',
        date: '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}',
      ),
      VideoLesson(
        id: 'bjj-105',
        title: 'Side Control Escapes',
        subject: 'Defense',
        description: 'Learn effective techniques to escape side control, including the elbow escape, frame and shrimp, and the underhook escape.',
        duration: '25 min',
        videoUrl: 'https://sample-videos.com/video123/mp4/720/big_buck_bunny_720p_1mb.mp4',
        date: '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}',
      ),
      VideoLesson(
        id: 'bjj-106',
        title: 'Mount Control & Attacks',
        subject: 'Positions',
        description: 'Master the mount position with proper weight distribution, control points, and effective submission setups including armbar and collar chokes.',
        duration: '30 min',
        videoUrl: 'https://sample-videos.com/video123/mp4/720/big_buck_bunny_720p_1mb.mp4',
        date: '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}',
      ),
      VideoLesson(
        id: 'bjj-107',
        title: 'Kimura Trap System',
        subject: 'Submissions',
        description: 'Learn the versatile kimura grip and how to use it to control your opponent and transition into multiple submissions and sweeps.',
        duration: '17 min',
        videoUrl: 'https://sample-videos.com/video123/mp4/720/big_buck_bunny_720p_1mb.mp4',
        date: '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}',
      ),
      VideoLesson(
        id: 'bjj-108',
        title: 'Half Guard Fundamentals',
        subject: 'Positions',
        description: 'Master the half guard position with proper frames, underhook control, and effective sweeping techniques to improve your bottom game.',
        duration: '24 min',
        videoUrl: 'https://sample-videos.com/video123/mp4/720/big_buck_bunny_720p_1mb.mp4',
        date: '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}',
      ),
    ];
    
    // Determine number of lessons based on day of week
    // Weekend = fewer lessons, weekday = more lessons
    final dayOfWeek = date.weekday; // 1-7 (1 is Monday, 7 is Sunday)
    
    if (dayOfWeek == 6 || dayOfWeek == 7) {
      // Weekend - only return 1-2 lessons
      final startIndex = dateSeed % lessonLibrary.length;
      return [
        lessonLibrary[startIndex],
        lessonLibrary[(startIndex + 3) % lessonLibrary.length],
      ];
    } else {
      // Weekday - return 3-4 lessons
      final startIndex = dateSeed % lessonLibrary.length;
      return [
        lessonLibrary[startIndex],
        lessonLibrary[(startIndex + 2) % lessonLibrary.length],
        lessonLibrary[(startIndex + 4) % lessonLibrary.length],
        lessonLibrary[(startIndex + 6) % lessonLibrary.length],
      ];
    }
  }
  
  // Get a sample user profile
  static Map<String, dynamic> getUserProfile() {
    return {
      'id': 'user123',
      'name': 'John Doe',
      'email': 'john.doe@example.com',
      'joinedDate': '2023-01-15',
      'completedLessons': 24,
      'totalHoursStudied': 18.5,
      'subjects': ['Submissions', 'Positions', 'Defense'],
      'beltRank': 'Blue Belt',
      'club': 'Bristol BJJ Academy'
    };
  }
}