import 'package:flutter/material.dart';
import 'package:most_important_thing/screens/history_screen.dart';
import 'package:most_important_thing/screens/streak_screen.dart';
import 'package:most_important_thing/screens/menu_screen.dart'; // Added import for MenuScreen
import 'package:most_important_thing/services/storage_service.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:most_important_thing/widgets/app_header.dart';
import 'package:most_important_thing/widgets/goal_celebration_popup.dart';
import 'package:most_important_thing/widgets/major_goal_completion_popup.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _dailyGoalController = TextEditingController();

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
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(responsivePadding),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildMajorGoalCard(storageService),
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
                                  fontSize: 16,
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
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
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
                                                todayGoal.isCompleted = true;
                                                await storageService.updateGoal(todayGoal);
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

  void _showGoalCelebration(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // User must tap the button to dismiss
      builder: (context) => GoalCelebrationPopup(
        onDismiss: () {
          Navigator.of(context).pop(); // Close the dialog
        },
      ),
    );
  }

  void _showMajorGoalCompletion(BuildContext context, String goalText) {
    showDialog(
      context: context,
      barrierDismissible: false, // User must tap the button to dismiss
      builder: (context) => MajorGoalCompletionPopup(
        goalText: goalText,
        onDismiss: () {
          Navigator.of(context).pop(); // Close the dialog
        },
      ),
    );
  }

  Widget _buildMajorGoalCard(StorageService storageService) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final hasMajorGoal = storageService.northStarGoal.isNotEmpty;
    
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
          Column(
            children: [
              Row(
                children: [
                  const Spacer(),
                  Text(
                    '🎯 YOUR MISSION 🎯',
                    style: TextStyle(
                      color: Colors.purple,
                      fontSize: 14,
                      letterSpacing: 2.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.info_outline, size: 16),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Your Mission'),
                          content: const Text('Your Mission is the overarching objective that guides your daily focus.'),
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
              const SizedBox(height: 4),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                                      onTap: () => _showEditGoalDialog(
                      context,
                      'Your Mission',
                      storageService.northStarGoal,
                    (newValue) async {
                      final wasEmpty = storageService.northStarGoal.isEmpty;
                      await storageService.setNorthStarGoal(newValue);
                      
                      // Show celebration if this is the first time setting a major goal
                      if (wasEmpty && newValue.isNotEmpty && mounted) {
                        _showGoalCelebration(context);
                      }
                    },
                  ),
                  child: Text(
                    hasMajorGoal ? storageService.northStarGoal : 'Tap to set your mission',
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const Icon(Icons.edit, color: Colors.amber, size: 16),
            ],
          ),
          if (hasMajorGoal) ...[
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () async {
                  final confirmed = await _showConfirmationDialog(
                    context,
                    'Mission Accomplished!',
                    'Are you sure you want to mark your mission as completed? This will move it to your history.',
                  );
                  if (confirmed == true) {
                    final goalText = storageService.northStarGoal;
                    await storageService.completeMajorGoal();
                    if (mounted) {
                      _showMajorGoalCompletion(context, goalText);
                    }
                  }
                },
                child: const Text(
                  'Mark as Completed 🏆',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
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

  @override
  void dispose() {
    _dailyGoalController.dispose();
    super.dispose();
  }
} 