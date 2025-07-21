import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:most_important_thing/models/goal_model.dart';
import 'package:most_important_thing/models/badge_model.dart';
import 'package:most_important_thing/screens/home_screen.dart';
import 'package:most_important_thing/screens/onboarding_screen.dart';
import 'package:most_important_thing/services/notification_service.dart';
import 'package:most_important_thing/services/storage_service.dart';
import 'package:most_important_thing/services/gamification_service.dart';
import 'package:most_important_thing/widgets/app_header.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Global error handling
  FlutterError.onError = (FlutterErrorDetails details) {
    debugPrint('Flutter error: ${details.exception}');
    debugPrint('Stack trace: ${details.stack}');
  };

  try {
    final notificationService = NotificationService();
    await notificationService.init();

    await Hive.initFlutter();
    Hive.registerAdapter(GoalAdapter());
    Hive.registerAdapter(BadgeAdapter());
    Hive.registerAdapter(BadgeProgressAdapter());
    Hive.registerAdapter(BadgeCategoryAdapter());
    Hive.registerAdapter(BadgeRarityAdapter());
    Hive.registerAdapter(UserLevelAdapter());
    Hive.registerAdapter(GamificationDataAdapter());

    final storageService = StorageService(notificationService);
    await storageService.init();
    
    final gamificationService = GamificationService(storageService);
    
    // Set up gamification callback
    storageService.setGamificationCallback((currentStreak, maxStreak, totalCompleted) async {
      // Award XP for completing a goal
      await gamificationService.awardXP(50, reason: 'Goal completed');
      
      // Check for badges
      await gamificationService.checkAndAwardBadges(
        currentStreak: currentStreak,
        maxStreak: maxStreak,
        totalCompletedGoals: totalCompleted,
      );
    });
    
    final isFirstLaunch = storageService.isFirstLaunch;
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => storageService),
          ChangeNotifierProvider(create: (context) => gamificationService),
        ],
        child: MostImportantThingApp(initialRoute: isFirstLaunch ? OnboardingScreen() : HomeScreen()),
      ),
    );
  } catch (e) {
    debugPrint('Error during app initialization: $e');
    runApp(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: Text('Error starting app: $e'),
          ),
        ),
      ),
    );
  }
}

class MostImportantThingApp extends StatelessWidget {
  final Widget initialRoute;
  const MostImportantThingApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Most Important Thing',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF32CD32), // Using header's lime green as seed
          brightness: Brightness.light,
          primary: const Color(0xFF20B2AA), // Light sea green from header
          secondary: const Color(0xFFFFD700), // Golden yellow from header
          surface: const Color(0xFFFFFBF0), // Warm white surface
        ),
        scaffoldBackgroundColor: Colors.transparent, // Let gradient show through
        inputDecorationTheme: const InputDecorationTheme(
          filled: true,
          fillColor: Color(0xFFFFFEFA), // Slightly warmer white for inputs
          border: OutlineInputBorder(borderSide: BorderSide.none),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent, // Transparent to show gradient
          foregroundColor: Colors.black87,
          elevation: 0,
          centerTitle: true,
        ),
        cardTheme: CardThemeData(
          color: const Color(0xFFFFFEFA).withValues(alpha: 0.8), // Semi-transparent cards
          elevation: 2,
          shadowColor: Colors.black.withValues(alpha: 0.1),
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF32CD32), // Using header's lime green as seed
          brightness: Brightness.dark,
          primary: const Color(0xFF20B2AA), // Light sea green from header
          secondary: const Color(0xFFFFD700), // Golden yellow from header
          surface: const Color(0xFF1E1E1E), // Dark surface
          onSurface: Colors.white,
        ),
        scaffoldBackgroundColor: Colors.transparent, // Let gradient show through
        cardColor: const Color(0xFF1E1E1E).withValues(alpha: 0.8), // Semi-transparent dark cards
        shadowColor: Colors.black.withValues(alpha: 0.3),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFF2A2A2A).withValues(alpha: 0.8), // Semi-transparent dark inputs
          border: const OutlineInputBorder(borderSide: BorderSide.none),
          hintStyle: TextStyle(color: Colors.grey[400]),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent, // Transparent to show gradient
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          scrolledUnderElevation: 0,
          surfaceTintColor: Colors.transparent,
        ),
        textTheme: TextTheme(
          headlineSmall: const TextStyle(color: Colors.white),
          titleMedium: const TextStyle(color: Colors.white),
          bodyLarge: const TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.grey[300]),
          labelSmall: TextStyle(color: Colors.grey[400]),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF20B2AA), // Use header sea green for buttons
            foregroundColor: Colors.white,
          ),
        ),
        cardTheme: CardThemeData(
          color: const Color(0xFF1E1E1E).withValues(alpha: 0.8), // Semi-transparent cards
          elevation: 2,
          shadowColor: Colors.black.withValues(alpha: 0.3),
        ),
      ),
      themeMode: ThemeMode.system,
      home: Builder(
        builder: (context) {
          final isDarkMode = Theme.of(context).brightness == Brightness.dark;
          return GradientBackground(
            isDarkMode: isDarkMode,
            child: initialRoute,
          );
        },
      ),
    );
  }
}
