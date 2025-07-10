import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:most_important_thing/models/goal_model.dart';
import 'package:most_important_thing/screens/home_screen.dart';
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

    runApp(
      ChangeNotifierProvider(
        create: (context) => storageService,
        child: const MostImportantThingApp(),
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
  const MostImportantThingApp({super.key});

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
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.grey[800],
          border: const OutlineInputBorder(borderSide: BorderSide.none),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.grey[900],
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
        ),
      ),
      themeMode: ThemeMode.system,
      home: const HomeScreen(),
    );
  }
}
