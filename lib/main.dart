import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:most_important_thing/models/goal_model.dart';
import 'package:most_important_thing/screens/home_screen.dart';
import 'package:most_important_thing/screens/onboarding_screen.dart';
import 'package:most_important_thing/services/notification_service.dart';
import 'package:most_important_thing/services/storage_service.dart';
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

    final storageService = StorageService(notificationService);
    await storageService.init();
    final isFirstLaunch = storageService.isFirstLaunch;
    runApp(
      ChangeNotifierProvider(
        create: (context) => storageService,
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
          seedColor: const Color(0xFF0066CC),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF9F7F3),
        inputDecorationTheme: const InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderSide: BorderSide.none),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF9F7F3),
          foregroundColor: Colors.black,
          elevation: 0,
          centerTitle: true,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0066CC),
          brightness: Brightness.dark,
          primary: const Color(0xFF4285F4), // Softer blue for accents
          secondary: const Color(0xFF03DAC6), // Harmonious teal accent
          surface: Colors.grey[850]!,
          background: Colors.grey[900]!,
          error: const Color(0xFFCF6679),
        ),
        scaffoldBackgroundColor: Colors.grey[900],
        cardColor: Colors.grey[850],
        shadowColor: Colors.black.withOpacity(0.3), // Visible shadows in dark mode
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.grey[800],
          border: const OutlineInputBorder(borderSide: BorderSide.none),
          hintStyle: TextStyle(color: Colors.grey[400]),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.grey[900],
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
            backgroundColor: const Color(0xFF4285F4), // Use primary for buttons
            foregroundColor: Colors.white,
          ),
        ),
      ),
      themeMode: ThemeMode.system,
      home: initialRoute,
    );
  }
}
