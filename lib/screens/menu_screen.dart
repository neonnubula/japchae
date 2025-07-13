import 'package:flutter/material.dart';
import 'package:most_important_thing/screens/onboarding_screen.dart';
import 'package:most_important_thing/screens/settings_screen.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Onboarding'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const OnboardingScreen()),
              );
            },
          ),
          ListTile(
            title: const Text('Settings'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
} 