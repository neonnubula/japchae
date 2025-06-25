import 'package:flutter/material.dart';
import 'package:japchae/services/storage_service.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class StreakScreen extends StatelessWidget {
  const StreakScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Streak'),
      ),
      body: Consumer<StorageService>(
        builder: (context, storage, _) {
          final streak = storage.getCurrentStreak();
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '$streak',
                  style: const TextStyle(fontSize: 72, fontWeight: FontWeight.bold),
                ),
                const Text(
                  'Day Streak',
                  style: TextStyle(fontSize: 24),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: streak > 0
                      ? () {
                          Share.share('I\'m on a $streak-day goal streak in Japchae! 🚀');
                        }
                      : null,
                  icon: const Icon(Icons.share),
                  label: const Text('Share Streak'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
} 