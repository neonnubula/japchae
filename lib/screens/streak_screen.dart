import 'package:flutter/material.dart';
import 'package:most_important_thing/services/storage_service.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:intl/intl.dart';
import 'package:most_important_thing/widgets/app_header.dart';

class StreakScreen extends StatelessWidget {
  const StreakScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AppHeader(
          fontSize: 20.0,
          padding: EdgeInsets.zero,
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 70.0, // Optimized for text-only header
      ),
      body: Consumer<StorageService>(
        builder: (context, storage, _) {
          final streak = storage.getCurrentStreak();
          final allGoals = storage.getAllGoals();
          final completedGoals = allGoals.where((g) => g.isCompleted).toList();
          
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Main streak display
                Semantics(
                  label: 'Current streak: $streak days',
                  child: Container(
                    padding: const EdgeInsets.all(40),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.local_fire_department,
                          size: 60,
                          color: Colors.orange,
                        ),
                        const SizedBox(height: 16),
                Text(
                  '$streak',
                  style: const TextStyle(fontSize: 72, fontWeight: FontWeight.bold),
                ),
                        Text(
                          streak == 1 ? 'Day Streak' : 'Days Streak',
                          style: const TextStyle(fontSize: 24),
                ),
                        if (streak > 0) ...[
                          const SizedBox(height: 20),
                ElevatedButton.icon(
                            onPressed: () {
                              Share.share('I\'ve got a $streak day streak by completing my most important goals! Join me on the Most Important Thing app! 🔥');
                            },
                  icon: const Icon(Icons.share),
                  label: const Text('Share Streak'),
                ),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                
                // Stats
                Row(
                  children: [
                    Expanded(
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            children: [
                              Icon(Icons.flag, color: Colors.blue, size: 30),
                              const SizedBox(height: 8),
                              Text(
                                '${allGoals.length}',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                ),
                              ),
                              Text(
                                'Total Goals',
                                style: const TextStyle(fontSize: 14),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            children: [
                              Icon(Icons.check_circle, color: Colors.green, size: 30),
                              const SizedBox(height: 8),
                              Text(
                                '${completedGoals.length}',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                              Text(
                                'Completed',
                                style: const TextStyle(fontSize: 14),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                
                if (completedGoals.isNotEmpty) ...[
                  const SizedBox(height: 30),
                  Text(
                    'Recent Completions',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 16),
                  ...completedGoals.take(5).map((goal) => Card(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    elevation: 2,
                    child: ListTile(
                      leading: const Icon(Icons.check_circle, color: Colors.green),
                      title: Text(goal.text),
                      subtitle: Text(DateFormat.MMMd().format(goal.date)),
                    ),
                  )),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 30),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: const TextStyle(fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
} 