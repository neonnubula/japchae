import 'package:flutter/material.dart';
import 'package:japchae/screens/history_screen.dart';
import 'package:japchae/screens/settings_screen.dart';
import 'package:japchae/screens/streak_screen.dart';
import 'package:japchae/services/storage_service.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

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

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
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
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.local_fire_department, color: Colors.orange),
                      const SizedBox(width: 8),
                      Text(
                        '${storageService.getCurrentStreak()} day streak',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
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
                      return Column(
                        children: [
                          const Text(
                            'What is the most important thing to achieve today to advance your goals?',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 24),
                          TextField(
                            controller: _dailyGoalController,
                            style: const TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                              hintText: 'E.g., Ship the new landing page...',
                              hintStyle: TextStyle(color: Colors.grey[600]),
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            maxLines: 3,
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                if (_dailyGoalController.text.isNotEmpty) {
                                  storageService.setTodayGoal(_dailyGoalController.text);
                                  _dailyGoalController.clear();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Goal for today set!')),
                                  );
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
                        ],
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
                              color: Colors.black,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 24),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    todayGoal.text,
                                    style: const TextStyle(color: Colors.black87, fontSize: 18),
                                  ),
                                ),
                                if (todayGoal.isCompleted)
                                  IconButton(
                                    icon: const Icon(Icons.share, color: Colors.black54),
                                    onPressed: () {
                                      Share.share('I just finished my goal for today: "${todayGoal.text}"!');
                                    },
                                  )
                                else
                                  IconButton(
                                    icon: const Icon(Icons.edit, color: Colors.amber),
                                    onPressed: () {
                                      _showEditGoalDialog(
                                        context,
                                        "Today's Goal",
                                        todayGoal.text,
                                        (newValue) {
                                          storageService.setTodayGoal(newValue);
                                        },
                                      );
                                    },
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
        color: Colors.white,
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
              icon: const Icon(Icons.history, color: Colors.black87),
              label: const Text('History', style: TextStyle(color: Colors.black87)),
            ),
            TextButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const StreakScreen()),
                );
              },
              icon: const Icon(Icons.local_fire_department, color: Colors.orange),
              label: const Text('Streak', style: TextStyle(color: Colors.black87)),
            ),
            TextButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingsScreen()),
                );
              },
              icon: const Icon(Icons.settings, color: Colors.black87),
              label: const Text('Settings', style: TextStyle(color: Colors.black87)),
            ),
          ],
        ),
      ),
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
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.grey[800],
                    fontSize: 12,
                    letterSpacing: 1.5,
                  ),
                ),
                const Spacer(),
                if (infoDescription != null)
                  IconButton(
                    icon: const Icon(Icons.info_outline, color: Colors.grey, size: 16),
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
                    style: const TextStyle(color: Colors.black87, fontSize: 16),
                  ),
                ),
                const Icon(Icons.edit, color: Colors.amber, size: 16),
              ],
            )
          ],
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