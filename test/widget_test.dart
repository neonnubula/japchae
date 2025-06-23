// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:japchae/main.dart';
import 'package:japchae/services/notification_service.dart';
import 'package:japchae/services/storage_service.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() {
  testWidgets('App builds and shows home screen', (WidgetTester tester) async {
    // We need to initialize Hive for testing.
    await Hive.initFlutter();

    final notificationService = NotificationService();
    await notificationService.init();
    final storageService = StorageService(notificationService);
    await storageService.init();

    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (context) => storageService,
        child: const JapchaeApp(),
      ),
    );

    // Verify that the home screen is shown.
    expect(find.text('NORTH STAR GOAL'), findsOneWidget);
    expect(find.text("Set Today's Goal"), findsOneWidget);
  });
}
