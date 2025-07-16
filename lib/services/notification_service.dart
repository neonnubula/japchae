import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/foundation.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'dart:io';

class NotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) async {
        // Handle notification tap
      },
    );

    // Request permission on Android
    final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
        flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>();
    await androidImplementation?.requestNotificationsPermission();

    tz.initializeTimeZones();
    // Set local timezone based on device timezone offset
    final DateTime now = DateTime.now();
    final int offsetHours = now.timeZoneOffset.inHours;
    
    // Map common timezone offsets to timezone names
    String timezoneName = 'UTC';
    if (offsetHours == 0) {
      timezoneName = 'UTC';
    } else if (offsetHours == -5) {
      timezoneName = 'America/New_York';
    } else if (offsetHours == -6) {
      timezoneName = 'America/Chicago';
    } else if (offsetHours == -7) {
      timezoneName = 'America/Denver';
    } else if (offsetHours == -8) {
      timezoneName = 'America/Los_Angeles';
    } else if (offsetHours == 1) {
      timezoneName = 'Europe/London';
    } else if (offsetHours == 2) {
      timezoneName = 'Europe/Paris';
    } else if (offsetHours == 8) {
      timezoneName = 'Asia/Shanghai';
    } else if (offsetHours == 9) {
      timezoneName = 'Asia/Tokyo';
    } else if (offsetHours == 10) {
      timezoneName = 'Australia/Sydney';
    } else if (offsetHours == 11) {
      timezoneName = 'Australia/Melbourne';
    } else if (offsetHours == -3) {
      timezoneName = 'America/Sao_Paulo';
    } else if (offsetHours == 5) {
      timezoneName = 'Asia/Kolkata';
    } else if (offsetHours == 7) {
      timezoneName = 'Asia/Bangkok';
    }
    
    try {
      tz.setLocalLocation(tz.getLocation(timezoneName));
      debugPrint('Set timezone to: $timezoneName (offset: $offsetHours hours)');
    } catch (e) {
      debugPrint('Failed to set timezone $timezoneName, using UTC: $e');
      tz.setLocalLocation(tz.getLocation('UTC'));
    }
  }

  Future<void> scheduleDailyNotification(tz.TZDateTime scheduledTime) async {
    // Cancel any existing notifications first
    await cancelAllNotifications();
    
    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'Most Important Thing',
      'What is the most important thing to achieve today?',
      scheduledTime,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'daily_notification_channel_id',
          'Daily Notifications',
          channelDescription: 'Channel for daily goal reminders',
          importance: Importance.max,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  Future<void> scheduleNotification(int id, String title, String body, tz.TZDateTime scheduledTime) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      scheduledTime,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'daily_notification_channel_id',
          'Daily Notifications',
          channelDescription: 'Channel for daily goal reminders',
          importance: Importance.max,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }
} 