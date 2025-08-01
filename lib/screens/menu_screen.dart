import 'package:flutter/material.dart';
import 'package:most_important_thing/screens/onboarding_screen.dart';
import 'package:most_important_thing/screens/settings_screen.dart';
import 'package:most_important_thing/widgets/app_header.dart';
import 'package:url_launcher/url_launcher.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          toolbarHeight: 70.0, // Optimized for text-only header
        ),
        body: Column(
          children: [
            const SizedBox(height: 20),
            ElevatedGradientCard(
              isDarkMode: isDarkMode,
              useGradient: true,
              elevation: 10.0,
              borderRadius: 18.0,
              padding: EdgeInsets.zero,
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ListTile(
                leading: const Icon(Icons.ondemand_video, size: 28),
                title: const Text('Onboarding', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const OnboardingScreen()),
                  );
                },
              ),
            ),
            ElevatedGradientCard(
              isDarkMode: isDarkMode,
              useGradient: true,
              elevation: 10.0,
              borderRadius: 18.0,
              padding: EdgeInsets.zero,
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ListTile(
                leading: const Icon(Icons.settings, size: 28),
                title: const Text('Settings', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SettingsScreen()),
                  );
                },
              ),
            ),
            ElevatedGradientCard(
              isDarkMode: isDarkMode,
              useGradient: true,
              elevation: 10.0,
              borderRadius: 18.0,
              padding: EdgeInsets.zero,
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ListTile(
                leading: const Icon(Icons.support_agent, size: 28),
                title: const Text('Support', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                subtitle: const Text('neonnubula@proton.me', style: TextStyle(fontSize: 12)),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                onTap: () async {
                  final Uri url = Uri.parse('https://mit-app.com/support.html');
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url, mode: LaunchMode.externalApplication);
                  }
                },
              ),
            ),
            ElevatedGradientCard(
              isDarkMode: isDarkMode,
              useGradient: true,
              elevation: 10.0,
              borderRadius: 18.0,
              padding: EdgeInsets.zero,
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ListTile(
                leading: const Icon(Icons.privacy_tip, size: 28),
                title: const Text('Privacy Policy', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                onTap: () async {
                  final Uri url = Uri.parse('https://mit-app.com/privacy.html');
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url, mode: LaunchMode.externalApplication);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
} 