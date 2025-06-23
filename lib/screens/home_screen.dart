import 'package:flutter/material.dart';
import 'package:japchae/models/goal_model.dart';
import 'package:japchae/screens/history_screen.dart';
import 'package:japchae/screens/settings_screen.dart';
import 'package:japchae/services/storage_service.dart';
import 'package:provider/provider.dart';

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
      backgroundColor: const Color(0xFF0A0A0A),
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
                    'North Star Goal',
                    storageService.northStarGoal,
                    (newValue) => storageService.setNorthStarGoal(newValue),
                  ),
                  child: _buildGoalCard(
                    'NORTH STAR GOAL',
                    storageService.northStarGoal.isEmpty
                        ? 'Tap to set your goal'
                        : storageService.northStarGoal,
                  ),
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () => _showEditGoalDialog(
                    context,
                    'Multi-Day Goal',
                    storageService.multiDayGoal,
                    (newValue) => storageService.setMultiDayGoal(newValue),
                  ),
                  child: _buildGoalCard(
                    'MULTI-DAY GOAL',
                    storageService.multiDayGoal.isEmpty
                        ? 'Tap to set your goal'
                        : storageService.multiDayGoal,
                  ),
                ),
                const SizedBox(height: 60),
                const Text(
                  'What is the most important thing to achieve today to advance your goals?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: _dailyGoalController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'E.g., Ship the new landing page...',
                    hintStyle: TextStyle(color: Colors.grey[600]),
                    filled: true,
                    fillColor: const Color(0xFF1A1A1A),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    if (_dailyGoalController.text.isNotEmpty) {
                      final newGoal = Goal()
                        ..text = _dailyGoalController.text
                        ..date = DateTime.now()
                        ..isCompleted = false;
                      storageService.addGoal(newGoal);
                      _dailyGoalController.clear();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Goal for today set!')),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF003D7C),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Set Today's Goal",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: const Color(0xFF0A0A0A),
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
              icon: const Icon(Icons.history, color: Colors.white),
              label: const Text('See History', style: TextStyle(color: Colors.white)),
            ),
            TextButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingsScreen()),
                );
              },
              icon: const Icon(Icons.settings, color: Colors.white),
              label: const Text('Settings', style: TextStyle(color: Colors.white)),
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
          backgroundColor: const Color(0xFF1A1A1A),
          title: Text('Edit $title', style: const TextStyle(color: Colors.white)),
          content: TextField(
            controller: controller,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              hintText: 'Enter your goal',
              hintStyle: TextStyle(color: Colors.grey),
            ),
            autofocus: true,
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel', style: TextStyle(color: Colors.white)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Save', style: TextStyle(color: Colors.white)),
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

  Widget _buildGoalCard(String title, String text) {
    return Card(
      color: const Color(0xFF1A1A1A),
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
                    color: Colors.grey[400],
                    fontSize: 12,
                    letterSpacing: 1.5,
                  ),
                ),
                const Spacer(),
                const Icon(Icons.info_outline, color: Colors.grey, size: 16),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Text(
                    text,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
                const Icon(Icons.edit, color: Colors.yellow, size: 16),
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