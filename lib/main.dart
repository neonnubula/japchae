import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:japchae/models/goal_model.dart';
import 'package:japchae/screens/home_screen.dart';
import 'package:japchae/services/notification_service.dart';
import 'package:japchae/services/storage_service.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final notificationService = NotificationService();
  await notificationService.init();

  await Hive.initFlutter();
  Hive.registerAdapter(GoalAdapter());

  final storageService = StorageService(notificationService);
  await storageService.init();

  runApp(
    ChangeNotifierProvider(
      create: (context) => storageService,
      child: const JapchaeApp(),
    ),
  );
}

class JapchaeApp extends StatelessWidget {
  const JapchaeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Japchae',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0066CC),
          brightness: Brightness.light,
          background: const Color(0xFFF9F7F3), // cream
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
      home: const HomeScreen(),
    );
  }
}
