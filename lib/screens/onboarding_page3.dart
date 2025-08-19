import 'package:flutter/material.dart';
import 'package:most_important_thing/screens/home_screen.dart';
import 'package:provider/provider.dart';
import 'package:most_important_thing/services/storage_service.dart';
import 'package:most_important_thing/widgets/app_header.dart';

class OnboardingPage3 extends StatelessWidget {
  const OnboardingPage3({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return GradientBackground(
      isDarkMode: isDarkMode,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Compact header
                const AppHeader(
                  fontSize: 20.0,
                  padding: EdgeInsets.only(top: 12.0, bottom: 16.0),
                ),

                // Case Study Header
                Text(
                  'CASE STUDY 2',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.purple,
                    fontSize: 16,
                    letterSpacing: 2,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),

                // Ray's emoji
                const Text(
                  '🍔',
                  style: TextStyle(fontSize: 50),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),

                // Ray's name
                Text(
                  'RAY KROC',
                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),

                // His job
                Text(
                  'Milkshake machine salesman at age 52',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    fontSize: 16,
                    color: Colors.grey,
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),

                // The story card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.purple.withOpacity(0.3),
                      width: 1.5,
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Every day after selling machines, he chipped away at his dream:',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Building the world\'s biggest restaurant chain',
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.purple,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // The result
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.orange.withOpacity(0.2), Colors.red.withOpacity(0.2)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        '🏆',
                        style: TextStyle(fontSize: 32),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'MCDONALD\'S: WORLD\'S LARGEST',
                        style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '38,000+ restaurants worldwide',
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Key message
                Text(
                  'Age doesn\'t matter. Daily progress does. Start today, chip away every day.',
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),

                // Navigation buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.purple,
                          side: const BorderSide(color: Colors.purple),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          '← Back',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // TODO: Navigate to next onboarding page
                          Provider.of<StorageService>(context, listen: false).setFirstLaunchCompleted();
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => const HomeScreen()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 4,
                        ),
                        child: const Text(
                          'How This Works →',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
