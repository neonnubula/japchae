import 'package:flutter/material.dart';
import 'package:most_important_thing/screens/history_screen.dart';
import 'package:most_important_thing/screens/streak_screen.dart';
import 'package:most_important_thing/screens/settings_screen.dart';
import 'package:most_important_thing/services/storage_service.dart';
import 'package:most_important_thing/services/gamification_service.dart';
import 'package:provider/provider.dart';
import 'package:most_important_thing/widgets/app_header.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _dailyGoalController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Set up badge earned celebration callback
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final gamificationService = Provider.of<GamificationService>(context, listen: false);
      gamificationService.onBadgeEarned = _showBadgeEarnedCelebration;
    });
  }

  @override
  Widget build(BuildContext context) {
    final storageService = Provider.of<StorageService>(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final responsivePadding = screenWidth * 0.05;
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
          elevation: 0,
          centerTitle: true,
          backgroundColor: Colors.transparent,
          toolbarHeight: 70.0, // Optimized for text-only header
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(responsivePadding),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  GestureDetector(
                    onTap: () => _showEditGoalDialog(
                      context,
                      'Major Goal',
                      storageService.northStarGoal,
                      (newValue) => storageService.setNorthStarGoal(newValue),
                    ),
                    child: _buildGoalCard(
                      'MAJOR GOAL',
                      storageService.northStarGoal.isEmpty
                          ? 'Tap to set your goal'
                          : storageService.northStarGoal,
                      infoDescription:
                          'Your Major Goal is the overarching objective that guides your daily focus.'
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Streak counter
                  ElevatedGradientCard(
                    isDarkMode: isDarkMode,
                    useGradient: true,
                    elevation: 10.0,
                    borderRadius: 18.0,
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.local_fire_department, color: Colors.orange, size: 24),
                        const SizedBox(width: 12),
                        Text(
                          '${storageService.getCurrentStreak()} day streak',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  Builder(
                    builder: (context) {
                      final todayGoal = storageService.getTodayGoal();
                      if (todayGoal == null) {
                        // Show input to set today's goal
                        return ElevatedGradientCard(
                          isDarkMode: isDarkMode,
                          useGradient: true,
                          elevation: 12.0,
                          borderRadius: 20.0,
                          padding: const EdgeInsets.all(24),
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          child: Column(
                            children: [
                              const Text(
                                'What is the most important thing to achieve today to advance your goals?',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 24),
                              TextField(
                                controller: _dailyGoalController,
                                decoration: InputDecoration(
                                  hintText: 'E.g., Ship the new landing page...',
                                  hintStyle: TextStyle(color: Colors.grey[600]),
                                  filled: true,
                                  fillColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                                maxLines: 3,
                              ),
                              const SizedBox(height: 24),
                              Semantics(
                                label: 'Set today\'s most important goal',
                                child: SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      final text = _dailyGoalController.text.trim();
                                      if (text.isEmpty) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text('Please enter a goal')),
                                        );
                                        return;
                                      }
                                      
                                      try {
                                        await storageService.setTodayGoal(text);
                                        _dailyGoalController.clear();
                                        if (mounted) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(content: Text('Goal for today set!')),
                                          );
                                        }
                                      } catch (e) {
                                        if (mounted) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(content: Text('Error: ${e.toString()}')),
                                          );
                                        }
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF004C9F),
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 24),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                    ),
                                    child: const Text(
                                      "Set Today's Goal",
                                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      } else {
                        // Show today's goal with edit option
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Text(
                              "Today's Focus",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 24),
                            ElevatedGradientCard(
                              isDarkMode: isDarkMode,
                              useGradient: true,
                              elevation: 12.0,
                              borderRadius: 20.0,
                              padding: const EdgeInsets.all(24),
                              margin: const EdgeInsets.symmetric(horizontal: 8),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          todayGoal.text,
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                            decoration: todayGoal.isCompleted
                                                ? TextDecoration.lineThrough
                                                : TextDecoration.none,
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.edit, size: 20),
                                        onPressed: () => _showEditGoalDialog(
                                          context,
                                          "Today's Goal",
                                          todayGoal.text,
                                          (newValue) {
                                            storageService.setTodayGoal(newValue);
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (!todayGoal.isCompleted)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 12),
                                      child: SizedBox(
                                        width: double.infinity,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: const Color(0xFF006E1C), // green
                                            foregroundColor: Colors.white,
                                            padding: const EdgeInsets.symmetric(vertical: 14),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                          ),
                                          onPressed: () async {
                                            final confirmed = await _showConfirmationDialog(
                                              context,
                                              'Complete Goal',
                                              'Mark today\'s goal as completed?',
                                            );
                                            if (confirmed == true) {
                                              try {
                                                await storageService.completeGoal(todayGoal);
                                                if (mounted) {
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    const SnackBar(content: Text('Goal completed! 🎉')),
                                                  );
                                                }
                                              } catch (e) {
                                                if (mounted) {
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    SnackBar(content: Text('Error: ${e.toString()}')),
                                                  );
                                                }
                                              }
                                            }
                                          },
                                          child: const Text('Mark as Completed'),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          color: Theme.of(context).cardColor,
          elevation: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const HistoryScreen()),
                  );
                },
                icon: Icon(Icons.history, color: Theme.of(context).iconTheme.color),
                label: Text('Goal History', style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color)),
              ),
              TextButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const StreakScreen()),
                  );
                },
                icon: const Icon(Icons.local_fire_department, color: Colors.orange),
                label: Text('Stats', style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color)),
              ),
              TextButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SettingsScreen()),
                  );
                },
                icon: Icon(Icons.settings, color: Theme.of(context).iconTheme.color),
                label: Text('Settings', style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool?> _showConfirmationDialog(
    BuildContext context,
    String title,
    String message,
  ) async {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0066CC),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('Confirm'),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showEditGoalDialog(
    BuildContext context,
    String title,
    String currentValue,
    Function(String) onSave,
  ) async {
    final TextEditingController controller =
        TextEditingController(text: currentValue);
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          backgroundColor: Colors.white,
          title: Text(
            'Edit $title',
            style: const TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: TextField(
            controller: controller,
            style: const TextStyle(color: Colors.black),
            decoration: InputDecoration(
              hintText: 'Enter your goal',
              hintStyle: TextStyle(color: Colors.grey[500]),
              filled: true,
              fillColor: Colors.grey[100],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
            autofocus: true,
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0066CC),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('Save'),
              onPressed: () {
                onSave(controller.text);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildGoalCard(String title, String text, {String? infoDescription}) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return ElevatedGradientCard(
      isDarkMode: isDarkMode,
      useGradient: true,
      elevation: 12.0,
      borderRadius: 20.0,
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Theme.of(context).textTheme.labelSmall?.color,
                  fontSize: 12,
                  letterSpacing: 1.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              if (infoDescription != null)
                IconButton(
                  icon: const Icon(Icons.info_outline, size: 16),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text(title),
                        content: Text(infoDescription),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('Close'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Text(
                  text,
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                    fontSize: 16,
                  ),
                ),
              ),
              const Icon(Icons.edit, color: Colors.amber, size: 16),
            ],
          )
        ],
      ),
    );
  }

  void _showBadgeEarnedCelebration(String badgeName) {
    if (!mounted) return;
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Colors.white,
        content: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [Colors.amber, Colors.orange],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.amber.withValues(alpha: 0.3),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.emoji_events,
                  size: 40,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                '🎉 Badge Earned! 🎉',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                badgeName,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF0066CC),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0066CC),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Awesome!'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _dailyGoalController.dispose();
    super.dispose();
  }
} 