
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/video_lesson.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';
import '../widgets/video_player_widget.dart';

class StudyScreen extends StatefulWidget {
  const StudyScreen({Key? key}) : super(key: key);

  @override
  _StudyScreenState createState() => _StudyScreenState();
}

class _StudyScreenState extends State<StudyScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _videoUrlController = TextEditingController();
  final ApiService _apiService = ApiService();
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;
  List<VideoLesson> _videoLessons = [];
  VideoLesson? _selectedVideo;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadVideoLessons();
  }

  Future<void> _loadVideoLessons() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final lessons = await _apiService.getVideoLessons(_selectedDay);
      setState(() {
        _videoLessons = lessons;
        _selectedVideo = null;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load video lessons. Please try again later.';
        _videoLessons = [];
        _isLoading = false;
      });
    }
  }

  Future<void> _showUploadDialog(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Upload Video Lesson'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  hintText: 'Enter video title',
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  hintText: 'Enter video description',
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _videoUrlController,
                decoration: const InputDecoration(
                  labelText: 'Video URL',
                  hintText: 'Enter video URL',
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Selected Date: ${DateFormat('MMMM d, yyyy').format(_selectedDay)}',
                style: const TextStyle(fontStyle: FontStyle.italic),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _clearInputs();
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                await _apiService.uploadVideoLesson(
                  title: _titleController.text,
                  description: _descriptionController.text,
                  videoUrl: _videoUrlController.text,
                  date: DateFormat('yyyy-MM-dd').format(_selectedDay),
                );
                
                if (mounted) {
                  Navigator.of(context).pop();
                  _loadVideoLessons();
                  _clearInputs();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Video lesson uploaded successfully')),
                  );
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error uploading video: $e')),
                  );
                }
              }
            },
            child: const Text('Upload'),
          ),
        ],
      ),
    );
  }

  void _clearInputs() {
    _titleController.clear();
    _descriptionController.clear();
    _videoUrlController.clear();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _videoUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isToday = DateTime.now().year == _selectedDay.year &&
                   DateTime.now().month == _selectedDay.month &&
                   DateTime.now().day == _selectedDay.day;
    
    final lessonsTitle = isToday
        ? "Today's Lessons"
        : 'Video Lessons for ${DateFormat('MMMM d, yyyy').format(_selectedDay)}';
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Training Videos',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                lessonsTitle,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Consumer<AuthService>(
                builder: (ctx, authService, _) {
                  if (authService.currentUser?.isInstructor ?? false) {
                    return ElevatedButton.icon(
                      onPressed: () => _showUploadDialog(context),
                      icon: const Icon(Icons.upload),
                      label: const Text('Upload Video'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(),
            )
          else if (_error != null)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.error_outline, color: Colors.red.shade700),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _error!,
                      style: TextStyle(color: Colors.red.shade700),
                    ),
                  ),
                ],
              ),
            )
          else if (_videoLessons.isEmpty)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: const Center(
                child: Text('No video lessons available for this date.'),
              ),
            )
          else
            Column(
              children: _videoLessons.map((video) {
                final isSelected = _selectedVideo?.id == video.id;
                return InkWell(
                  onTap: () {
                    setState(() {
                      _selectedVideo = video;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.blue.shade50 : Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected ? Colors.blue.shade200 : Colors.grey.shade300,
                      ),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.blue.shade100,
                        child: const Icon(Icons.play_arrow, color: Colors.blue),
                      ),
                      title: Text(video.title),
                      subtitle: Text('${video.duration} • ${video.subject}'),
                      selected: isSelected,
                    ),
                  ),
                );
              }).toList(),
            ),
            
          if (_selectedVideo != null) ...[
            const SizedBox(height: 24),
            Text(
              _selectedVideo!.title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            VideoPlayerWidget(videoUrl: _selectedVideo!.videoUrl),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Description',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(_selectedVideo!.description),
                ],
              ),
            ),
          ],
          
          const SizedBox(height: 24),
          
          Text(
            'Change Date',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Card(
            elevation: 2,
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TableCalendar(
                    firstDay: DateTime.utc(2020, 1, 1),
                    lastDay: DateTime.utc(2050, 12, 31),
                    focusedDay: _focusedDay,
                    calendarFormat: _calendarFormat,
                    selectedDayPredicate: (day) {
                      return isSameDay(_selectedDay, day);
                    },
                    onDaySelected: (selectedDay, focusedDay) {
                      setState(() {
                        _selectedDay = selectedDay;
                        _focusedDay = focusedDay;
                      });
                      _loadVideoLessons();
                    },
                    onFormatChanged: (format) {
                      setState(() {
                        _calendarFormat = format;
                      });
                    },
                    calendarStyle: const CalendarStyle(
                      todayDecoration: BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                      ),
                      selectedDecoration: BoxDecoration(
                        color: Colors.deepPurple,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Selected: ${DateFormat('MMMM d, yyyy').format(_selectedDay)}',
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
