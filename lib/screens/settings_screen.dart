import 'package:flutter/material.dart';
import 'package:most_important_thing/services/storage_service.dart';
import 'package:most_important_thing/services/gamification_service.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:most_important_thing/widgets/app_header.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

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
        ),
        body: Consumer2<StorageService, GamificationService>(
          builder: (context, storageService, gamificationService, child) {
            return ListView(
              children: [
                // XP and Level Display
                Container(
                  margin: const EdgeInsets.all(20),
                  child: ElevatedGradientCard(
                    isDarkMode: isDarkMode,
                    useGradient: true,
                    elevation: 12.0,
                    borderRadius: 20.0,
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.amber.withValues(alpha: 0.8),
                                    Colors.orange.withValues(alpha: 0.8),
                                  ],
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  '${gamificationService.currentLevel.level}',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    gamificationService.currentLevel.name,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    gamificationService.currentLevel.description,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '${gamificationService.gamificationData.totalXP} XP',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF0066CC),
                                  ),
                                ),
                                if (gamificationService.nextLevel != null)
                                  Text(
                                    '${gamificationService.xpToNextLevel} to next level',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                        if (gamificationService.nextLevel != null) ...[
                          const SizedBox(height: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Level ${gamificationService.currentLevel.level}',
                                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                                  ),
                                  Text(
                                    'Level ${gamificationService.nextLevel!.level}',
                                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              LinearProgressIndicator(
                                value: gamificationService.levelProgress,
                                backgroundColor: Colors.grey[300],
                                valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF0066CC)),
                                minHeight: 8,
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                              _buildSettingsTile(
                context,
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
                  context,
                  title: 'Notification Time',
                    subtitle: storageService.notificationTime.format(context),
                    onTap: () => _pickTime(context, storageService),
                  ),
                const Divider(color: Colors.grey),
                              _buildSettingsTile(
                context,
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
                  context,
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
                  context,
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

  Widget _buildSettingsTile(
    BuildContext context, {
    required String title,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
    bool isThreeLine = false,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return ElevatedGradientCard(
      isDarkMode: isDarkMode,
      useGradient: true,
      elevation: 10.0,
      borderRadius: 18.0,
      padding: EdgeInsets.zero,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: ListTile(
        title: Text(title),
        subtitle: subtitle != null
            ? Text(subtitle, style: TextStyle(color: Colors.grey[600]))
            : null,
        trailing: trailing,
        onTap: onTap,
        isThreeLine: isThreeLine,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
        ),
      ),
    );
  }
} 