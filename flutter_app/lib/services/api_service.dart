import '../models/video_lesson.dart';
import '../data/sample_lessons.dart';

class ApiService {
  /// Get video lessons for a specific date
  Future<List<VideoLesson>> getVideoLessons(DateTime date) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));
    
    try {
      // Use local data instead of server
      return SampleLessons.getVideoLessons(date);
    } catch (e) {
      throw Exception('Error loading video lessons: $e');
    }
  }

  /// Get user profile data
  Future<Map<String, dynamic>> getUserProfile() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));
    
    try {
      // Use local data instead of server
      return SampleLessons.getUserProfile();
    } catch (e) {
      throw Exception('Error loading user profile: $e');
    }
  }

  /// Mark a video lesson as completed
  Future<bool> markLessonCompleted(String lessonId) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));
    
    try {
      // In a real app, this would update a database
      print('Marking lesson $lessonId as completed');
      return true;
    } catch (e) {
      throw Exception('Failed to mark lesson as completed: $e');
    }
  }

  /// Upload a new video lesson
  Future<void> uploadVideoLesson({
    required String title,
    required String description,
    required String videoFile,
    required String date,
  }) async {
    try {
      final storage = FirebaseStorage.instance;
      final videoRef = storage.ref().child('videos/${DateTime.now().millisecondsSinceEpoch}_$title');
      
      // Upload video file
      final uploadTask = await videoRef.putFile(File(videoFile));
      final videoUrl = await uploadTask.ref.getDownloadURL();
      
      // Save lesson metadata to Firestore
      final db = FirebaseFirestore.instance;
      final newLesson = VideoLesson(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title,
        description: description,
        videoUrl: videoUrl,
        duration: '10 min',
        subject: 'New Lesson',
        date: date,
        uploadDate: DateTime.now().toIso8601String(),
      );
      
      await db.collection('lessons').add(newLesson.toJson());
    } catch (e) {
      throw Exception('Failed to upload video lesson: $e');
    }
  }
}