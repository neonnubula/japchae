import 'package:flutter/material.dart';
import 'package:most_important_thing/services/storage_service.dart';
import 'package:most_important_thing/screens/badges_screen.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:intl/intl.dart';
import 'package:most_important_thing/widgets/app_header.dart';

class StreakScreen extends StatefulWidget {
  const StreakScreen({super.key});

  @override
  State<StreakScreen> createState() => _StreakScreenState();
}

class _StreakScreenState extends State<StreakScreen> {
  bool _showingStats = true;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return GradientBackground(
      isDarkMode: isDarkMode,
      child: Scaffold(
        backgroundColor: Colors.transparent, // Let gradient show through
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
        body: Column(
          children: [
            // Toggle between Stats and Badges
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _showingStats = true),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: _showingStats ? const Color(0xFF0066CC) : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.analytics,
                                color: _showingStats ? Colors.white : Theme.of(context).iconTheme.color,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Stats',
                                style: TextStyle(
                                  color: _showingStats ? Colors.white : Theme.of(context).textTheme.bodyMedium?.color,
                                  fontWeight: _showingStats ? FontWeight.w600 : FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _showingStats = false),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: !_showingStats ? const Color(0xFF0066CC) : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.emoji_events,
                                color: !_showingStats ? Colors.white : Theme.of(context).iconTheme.color,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Badges',
                                style: TextStyle(
                                  color: !_showingStats ? Colors.white : Theme.of(context).textTheme.bodyMedium?.color,
                                  fontWeight: !_showingStats ? FontWeight.w600 : FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Content
            Expanded(
              child: _showingStats ? _buildStatsView() : _buildBadgesView(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsView() {
    return Consumer<StorageService>(
      builder: (context, storage, _) {
        final isDarkMode = Theme.of(context).brightness == Brightness.dark;
        final streak = storage.getCurrentStreak();
        final allGoals = storage.getAllGoals();
        final completedGoals = allGoals.where((g) => g.isCompleted).toList();
        
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
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
      );
    }

    Widget _buildBadgesView() {
      return const BadgesScreen();
    }
  } 