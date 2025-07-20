import 'package:flutter/material.dart';
import 'package:most_important_thing/services/storage_service.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:most_important_thing/widgets/app_header.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const AppHeader(
          fontSize: 20.0,
          padding: EdgeInsets.zero,
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        toolbarHeight: 70.0, // Optimized for text-only header
      ),
      body: Consumer<StorageService>(
        builder: (context, storageService, child) {
          return ListView(
            children: [
              _buildSettingsTile(
                title: 'Enable Daily Notifications',
                trailing: Switch(
                  value: storageService.dailyNotifications,
                  onChanged: (value) {
                    storageService.setDailyNotifications(value);
                  },
                  activeColor: const Color(0xFF0066CC),
                ),
              ),
              if (storageService.dailyNotifications)
                _buildSettingsTile(
                  title: 'Notification Time',
                  subtitle: storageService.notificationTime.format(context),
                  onTap: () => _pickTime(context, storageService),
                ),
              const Divider(color: Colors.grey),
              _buildSettingsTile(
                title: 'Ask about yesterday\'s goal',
                subtitle:
                    'At the start of each day, prompt to mark the previous day\'s goal as complete.',
                trailing: Switch(
                  value: storageService.askAboutYesterday,
                  onChanged: (value) {
                    storageService.setAskAboutYesterday(value);
                  },
                  activeColor: const Color(0xFF0066CC),
                ),
                isThreeLine: true,
              ),
              const Divider(color: Colors.grey),
              _buildSettingsTile(
                title: 'Export Data',
                subtitle: 'Share your goals history and settings',
                trailing: const Icon(Icons.share),
                onTap: () async {
                  try {
                    final exportData = storageService.exportData();
                    await Share.share(
                      exportData,
                      subject: 'My Goals Data - Most Important Thing App',
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
              _buildSettingsTile(
                title: 'App Info',
                subtitle: 'Version 1.0.1 - Focus on what matters most',
                trailing: const Icon(Icons.info),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Most Important Thing'),
                      content: const Text(
                        'Focus on what matters most. Set and track your daily most important goals.\n\nVersion 1.0.1\n\nMade with ❤️ for productivity',
                      ),
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
          );
        },
      ),
    );
  }

  Future<void> _pickTime(
      BuildContext context, StorageService storageService) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: storageService.notificationTime,
    );
    if (picked != null) {
      storageService.setNotificationTime(picked);
    }
  }

  Widget _buildSettingsTile({
    required String title,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
    bool isThreeLine = false,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        title: Text(title),
        subtitle: subtitle != null
            ? Text(subtitle, style: TextStyle(color: Colors.grey[600]))
            : null,
        trailing: trailing,
        onTap: onTap,
        isThreeLine: isThreeLine,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      ),
    );
  }
} 