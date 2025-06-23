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
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const HomeScreen(),
    );
  }
}
