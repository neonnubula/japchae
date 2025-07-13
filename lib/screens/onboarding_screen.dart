import 'package:flutter/material.dart';
import 'package:most_important_thing/screens/home_screen.dart';
import 'package:provider/provider.dart';
import 'package:most_important_thing/services/storage_service.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Welcome to Most Important Thing',
                style: Theme.of(context).textTheme.headlineSmall!.copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                '🎯',
                style: TextStyle(fontSize: 48),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 28),
              _buildSection(
                context,
                title: 'The Problem',
                icon: '😵',
                body: 'We over-stuff our days, stall momentum, and end up achieving less over the year.'
              ),
              const SizedBox(height: 20),
              _buildSection(
                context,
                title: 'The Solution',
                icon: '🚀',
                body: 'Commit to ONE Most Important Thing you can realistically finish today. Small wins ➜ daily momentum ➜ big results.'
              ),
              const SizedBox(height: 20),
              _buildSection(
                context,
                title: 'Your Edge',
                icon: '⚡',
                body: 'Smart reminders keep you focused. Turn on notifications so you never miss your daily win.'
              ),
              const SizedBox(height: 28),
              const Text(
                '🔥 Ready to build momentum?',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Provider.of<StorageService>(context, listen: false).setFirstLaunchCompleted();
                  // TODO: Request notification permissions here
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                  );
                },
                child: const Text('🚀 Get Started'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildSection(BuildContext context, {required String title, required String icon, required String body}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          Text(
            icon,
            style: const TextStyle(fontSize: 24),
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
      const SizedBox(height: 8),
      Text(
        body,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    ],
  );
} 