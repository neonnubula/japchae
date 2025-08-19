import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:most_important_thing/services/storage_service.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:most_important_thing/widgets/app_header.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return GradientBackground(
      isDarkMode: isDarkMode,
      child: Scaffold(
        backgroundColor: Colors.transparent, // Let gradient show through

        body: Consumer<StorageService>(
          builder: (context, storageService, child) {
            final goals = storageService.getAllGoals();
            if (goals.isEmpty) {
              return const Center(
                child: Text('No history yet.'),
              );
            }
            return ListView.builder(
              itemCount: goals.length,
              itemBuilder: (context, index) {
                final goal = goals[index];
                final isDarkMode = Theme.of(context).brightness == Brightness.dark;
                
                return ElevatedGradientCard(
                  isDarkMode: isDarkMode,
                  useGradient: goal.isMajorGoal, // Use gradient for major goals
                  elevation: goal.isMajorGoal ? 12.0 : 8.0, // Higher elevation for major goals
                  borderRadius: 16.0,
                  padding: EdgeInsets.zero,
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Semantics(
                    label: '${goal.isMajorGoal ? 'Major Goal' : 'Goal'}: ${goal.text}, ${goal.isCompleted ? 'completed' : 'not completed'} on ${DateFormat.yMMMd().format(goal.date)}',
                    child: ListTile(
                      leading: Icon(
                        goal.isMajorGoal 
                            ? Icons.emoji_events // Trophy icon for major goals
                            : (goal.isCompleted ? Icons.check_circle : Icons.radio_button_unchecked),
                        color: goal.isMajorGoal 
                            ? Colors.orange // Orange for major goals
                            : (goal.isCompleted ? Colors.green : Colors.grey),
                        size: goal.isMajorGoal ? 28 : 24, // Larger icon for major goals
                      ),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (goal.isMajorGoal) ...[
                            Text(
                              'MAJOR GOAL',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Colors.orange,
                                letterSpacing: 1.0,
                              ),
                            ),
                            const SizedBox(height: 4),
                          ],
                          Text(
                            goal.text,
                            style: TextStyle(
                              fontSize: goal.isMajorGoal ? 16 : 14,
                              fontWeight: goal.isMajorGoal ? FontWeight.bold : FontWeight.normal,
                              decoration: goal.isCompleted
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                            ),
                          ),
                        ],
                      ),
                      subtitle: Text(
                        DateFormat.yMMMd().format(goal.date),
                        style: TextStyle(
                          fontWeight: goal.isMajorGoal ? FontWeight.w600 : FontWeight.normal,
                        ),
                      ),
                      trailing: goal.isCompleted
                          ? IconButton(
                              icon: const Icon(Icons.share),
                              onPressed: () {
                                final goalType = goal.isMajorGoal ? 'major goal' : 'goal';
                                Share.share('I completed my $goalType: "${goal.text}" on ${DateFormat.yMMMd().format(goal.date)} using the Most Important Thing app!');
                              },
                            )
                          : IconButton(
                              icon: const Icon(Icons.check),
                              onPressed: () async {
                                final storageService = Provider.of<StorageService>(context, listen: false);
                                goal.isCompleted = true;
                                await storageService.updateGoal(goal);
                              },
                            ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
} 