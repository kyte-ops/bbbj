import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firebase Firestore

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ApiService _apiService = ApiService();
  bool _isLoading = true;
  late Map<String, dynamic> user;
  //authService added
  final authService = AuthService(); // Assuming AuthService is defined elsewhere

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final profileData = await _apiService.getUserProfile();
      setState(() {
        user = profileData;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        user = {
          'name': 'John Doe',
          'email': 'john.doe@example.com',
          'joinedDate': '2023-01-15',
          'completedLessons': 24,
          'totalHoursStudied': 18.5,
          'subjects': ['Submissions', 'Positions', 'Defense'],
          'beltRank': 'Blue Belt',
          'club': 'Bristol BJJ Academy'
        };
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (authService.currentUser?.isInstructor == true)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Instructor Controls',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Manage User Roles:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        decoration: const InputDecoration(
                          labelText: 'User Email',
                          hintText: 'Enter user email to modify role',
                          border: OutlineInputBorder(),
                        ),
                        onSubmitted: (email) async {
                          // Show confirmation dialog
                          final result = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Modify User Role'),
                              content: Text('Do you want to make $email an instructor?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context, false),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  child: const Text('Confirm'),
                                ),
                              ],
                            ),
                          );

                          if (result == true) {
                            try {
                              // Update user role in Firestore
                              final db = FirebaseFirestore.instance;
                              final userQuery = await db.collection('users')
                                  .where('email', isEqualTo: email)
                                  .get();

                              if (userQuery.docs.isNotEmpty) {
                                await userQuery.docs.first.reference.update({
                                  'isInstructor': true,
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('User role updated successfully')),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('User not found')),
                                );
                              }
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Error updating role: $e')),
                              );
                            }
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            Text(
              'Your Profile',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 24),
            Flex(
              direction: Axis.vertical,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.grey.shade200,
                      child: const Icon(
                        Icons.person,
                        size: 40,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user['name'] as String,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.email, size: 16, color: Colors.blue),
                              const SizedBox(width: 4),
                              Text(user['email'] as String),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.calendar_today, size: 16, color: Colors.blue),
                              const SizedBox(width: 4),
                              Text('Joined: ${user['joinedDate']}'),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.sports_martial_arts, size: 16, color: Colors.blue),
                              const SizedBox(width: 4),
                              Text('Rank: ${user['beltRank'] ?? 'White Belt'}'),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.location_on, size: 16, color: Colors.blue),
                              const SizedBox(width: 4),
                              Text('Club: ${user['club'] ?? 'Bristol BJJ Academy'}'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                Text(
                  'Training Statistics',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Card(
                        color: Colors.blue.shade50,
                        elevation: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.school, color: Colors.blue.shade700),
                                  const SizedBox(width: 8),
                                  const Text('Completed Lessons'),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '${user['completedLessons']}',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue.shade700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Card(
                        color: Colors.green.shade50,
                        elevation: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.access_time, color: Colors.green.shade700),
                                  const SizedBox(width: 8),
                                  const Text('Hours Trained'),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '${user['totalHoursStudied']}',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green.shade700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Your Skills',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: (user['subjects'] as List<String>).map((subject) {
                            return Chip(
                              label: Text(subject),
                              backgroundColor: Colors.grey.shade100,
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                Text(
                  'Account Settings',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // Edit profile functionality would go here
                      },
                      child: const Text('Edit Profile'),
                    ),
                    const SizedBox(width: 16),
                    OutlinedButton(
                      onPressed: () {
                        // Change password functionality would go here
                      },
                      child: const Text('Change Password'),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class AuthService {
  // Add currentUser getter with isInstructor property
  User? get currentUser => _currentUser; //Replace _currentUser with your actual implementation


  User? _currentUser; // Replace with your actual user object

  // Add other auth methods as needed

}

class User {
  final String uid;
  final String email;
  final String name;
  final bool isInstructor; // Added isInstructor field

  User({
    required this.uid,
    required this.email,
    required this.name,
    required this.isInstructor,
  });
}