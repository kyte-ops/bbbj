class VideoLesson {
  final String id;
  final String title;
  final String description;
  final String videoUrl;
  final String duration;
  final String subject;
  final String date;
  final bool isCompleted;

  VideoLesson({
    required this.id,
    required this.title,
    required this.description,
    required this.videoUrl,
    required this.duration,
    required this.subject,
    required this.date,
    this.isCompleted = false,
  });

  factory VideoLesson.fromJson(Map<String, dynamic> json) {
    return VideoLesson(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      videoUrl: json['videoUrl'],
      duration: json['duration'],
      subject: json['subject'],
      date: json['date'],
      isCompleted: json['isCompleted'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'videoUrl': videoUrl,
      'duration': duration,
      'subject': subject,
      'date': date,
      'isCompleted': isCompleted,
    };
  }
}