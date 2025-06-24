import 'package:flutter/material.dart';
import 'package:japchae/services/storage_service.dart';
import 'package:provider/provider.dart';

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
        title: const Text('Settings'),
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
    return ListTile(
      title: Text(title),
      subtitle: subtitle != null
          ? Text(subtitle, style: TextStyle(color: Colors.grey[600]))
          : null,
      trailing: trailing,
      onTap: onTap,
      isThreeLine: isThreeLine,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
    );
  }
} 