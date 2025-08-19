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
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return GradientBackground(
      isDarkMode: isDarkMode,
      child: Scaffold(
        backgroundColor: Colors.transparent, // Let gradient show through

        body: SafeArea(
          child: Consumer<StorageService>(
            builder: (context, storage, _) {
              final streak = storage.getCurrentStreak();
              final allGoals = storage.getAllGoals();
              final completedGoals = allGoals.where((g) => g.isCompleted).toList();
              
              return SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
              child: Column(
                children: [
                  // Main streak display
                  Semantics(
                    label: 'Current streak: $streak days',
                    child: ElevatedGradientCard(
                      isDarkMode: isDarkMode,
                      useGradient: true,
                      elevation: 15.0,
                      borderRadius: 24.0,
                      padding: const EdgeInsets.all(40),
                      margin: const EdgeInsets.symmetric(horizontal: 8),
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
                        child: ElevatedGradientCard(
                          isDarkMode: isDarkMode,
                          useGradient: true,
                          elevation: 12.0,
                          borderRadius: 20.0,
                          padding: const EdgeInsets.all(24),
                          margin: const EdgeInsets.only(right: 8),
                          child: Column(
                            children: [
                              const Icon(Icons.flag, color: Colors.blue, size: 30),
                              const SizedBox(height: 8),
                              Text(
                                '${allGoals.length}',
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                ),
                              ),
                              const Text(
                                'Total Goals',
                                style: TextStyle(fontSize: 14),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedGradientCard(
                          isDarkMode: isDarkMode,
                          useGradient: true,
                          elevation: 12.0,
                          borderRadius: 20.0,
                          padding: const EdgeInsets.all(24),
                          margin: const EdgeInsets.only(left: 8),
                          child: Column(
                            children: [
                              const Icon(Icons.check_circle, color: Colors.green, size: 30),
                              const SizedBox(height: 8),
                              Text(
                                '${completedGoals.length}',
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                              const Text(
                                'Completed',
                                style: TextStyle(fontSize: 14),
                                textAlign: TextAlign.center,
                              ),
                            ],
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
                    ...completedGoals.take(5).map((goal) => ElevatedGradientCard(
                      isDarkMode: isDarkMode,
                      useGradient: false,
                      elevation: 8.0,
                      borderRadius: 16.0,
                      padding: EdgeInsets.zero,
                      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                      child: ListTile(
                        leading: const Icon(Icons.check_circle, color: Colors.green),
                        title: Text(goal.text),
                        subtitle: Text(DateFormat.MMMd().format(goal.date)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      ),
                    )),
                  ],
                ],
              ),
            );
            },
          ),
        ),
      ),
    );
  }
} 