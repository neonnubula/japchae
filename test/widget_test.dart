// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:most_important_thing/main.dart';
import 'package:most_important_thing/models/goal_model.dart';
import 'package:most_important_thing/screens/home_screen.dart';
import 'package:most_important_thing/services/notification_service.dart';
import 'package:most_important_thing/services/storage_service.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Initialize Hive for testing
    await Hive.initFlutter();
    Hive.registerAdapter(GoalAdapter());

    // Create mock services
    final notificationService = NotificationService();
    await notificationService.init();
    final storageService = StorageService(notificationService);
    await storageService.init();

    // Build our app and trigger a frame.
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (context) => storageService,
        child: const MostImportantThingApp(initialRoute: HomeScreen()),
      ),
    );

    // Verify that our app loads
    expect(find.text('Most Important Thing'), findsOneWidget);
  });
}
