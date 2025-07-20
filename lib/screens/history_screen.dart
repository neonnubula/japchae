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
        appBar: AppBar(
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Theme.of(context).iconTheme.color),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: const AppHeader(
            fontSize: 20.0,
            padding: EdgeInsets.zero,
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          toolbarHeight: 70.0, // Optimized for text-only header
          actions: [
            IconButton(
              icon: const Icon(Icons.share),
              tooltip: 'Export all goals',
              onPressed: () async {
                try {
                  final storageService = Provider.of<StorageService>(context, listen: false);
                  final exportData = storageService.exportData();
                  await Share.share(
                    exportData,
                    subject: 'My Goals History - Most Important Thing App',
                  );
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error exporting: ${e.toString()}')),
                    );
                  }
                }
              },
            ),
          ],
        ),
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
                  useGradient: false,
                  elevation: 8.0,
                  borderRadius: 16.0,
                  padding: EdgeInsets.zero,
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Semantics(
                    label: 'Goal: ${goal.text}, ${goal.isCompleted ? 'completed' : 'not completed'} on ${DateFormat.yMMMd().format(goal.date)}',
                    child: ListTile(
                      leading: Icon(
                        goal.isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
                        color: goal.isCompleted ? Colors.green : Colors.grey,
                      ),
                      title: Text(
                        goal.text,
                        style: TextStyle(
                          decoration: goal.isCompleted
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                        ),
                      ),
                      subtitle: Text(DateFormat.yMMMd().format(goal.date)),
                      trailing: goal.isCompleted
                          ? IconButton(
                              icon: const Icon(Icons.share),
                              onPressed: () {
                                Share.share('I completed my goal: "${goal.text}" on ${DateFormat.yMMMd().format(goal.date)} using the Most Important Thing app!');
                              },
                            )
                          : IconButton(
                              icon: const Icon(Icons.check),
                              onPressed: () {
                                goal.isCompleted = true;
                                goal.save();
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