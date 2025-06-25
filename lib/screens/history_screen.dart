import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:japchae/services/storage_service.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('History'),
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
              return ListTile(
                title: Text(goal.text),
                subtitle: Text(
                  DateFormat.yMMMd().format(goal.date),
                  style: TextStyle(color: Colors.grey[600]),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Checkbox(
                      value: goal.isCompleted,
                      onChanged: (bool? value) {
                        goal.isCompleted = value ?? false;
                        storageService.updateGoal(goal);
                      },
                      activeColor: const Color(0xFF0066CC),
                      side: const BorderSide(color: Colors.grey),
                    ),
                    if (goal.isCompleted)
                      IconButton(
                        icon: const Icon(Icons.share, color: Colors.black54),
                        onPressed: () {
                          Share.share('I completed my goal "${goal.text}" today in Japchae!');
                        },
                      ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
} 