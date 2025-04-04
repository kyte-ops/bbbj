
import 'package:flutter/material.dart';
import 'dart:html' as html;
import 'dart:ui' as ui;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Register the iframe view
    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(
      'calendar-iframe',
      (int viewId) => html.IFrameElement()
        ..src = 'https://bristoljiujitsu.net/schedule/'
        ..style.border = 'none'
        ..style.width = '100%'
        ..style.height = '600px'
        ..style.overflow = 'hidden',
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome to Your Learning Journey',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          Text(
            'Track your progress, access your daily lessons, and improve your skills with our comprehensive learning platform.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              DefaultTabController.of(context)?.animateTo(1);
            },
            child: const Text('Go to Today\'s Lessons'),
          ),
          const SizedBox(height: 24),
          GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: const [
              FeatureCard(
                icon: Icons.calendar_today,
                title: 'Daily Schedule',
                description: 'Access your personalized learning schedule for consistent progress.',
              ),
              FeatureCard(
                icon: Icons.emoji_events,
                title: 'Achievements',
                description: 'Track your completed lessons and unlock achievements.',
              ),
              FeatureCard(
                icon: Icons.book,
                title: 'Learning Resources',
                description: 'Access additional materials to supplement your video lessons.',
              ),
              FeatureCard(
                icon: Icons.trending_up,
                title: 'Progress Tracking',
                description: 'Visualize your learning journey and identify areas for improvement.',
              ),
            ],
          ),
          const SizedBox(height: 24),
          Container(
            height: 600,
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            clipBehavior: Clip.antiAlias,
            child: const HtmlElementView(
              viewType: 'calendar-iframe',
            ),
          ),
          const SizedBox(height: 16),
          const Center(
            child: Text(
              'Need help? Contact our support team.',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const FeatureCard({
    Key? key,
    required this.icon,
    required this.title,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              color: Theme.of(context).primaryColor,
              size: 24,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            Expanded(
              child: Text(
                description,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
