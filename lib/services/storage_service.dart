import 'package:hive/hive.dart';
import 'package:japchae/models/goal_model.dart';
import 'package:flutter/material.dart';
import 'package:japchae/services/notification_service.dart';
import 'package:timezone/timezone.dart' as tz;

class StorageService with ChangeNotifier {
  final NotificationService _notificationService;

  StorageService(this._notificationService);

  late Box<Goal> _goalsBox;
  late Box _settingsBox;

  static const String _goalsBoxName = 'goals';
  static const String _settingsBoxName = 'settings';
  static const String _northStarGoalKey = 'northStarGoal';
  static const String _multiDayGoalKey = 'multiDayGoal';
  static const String _dailyNotificationsKey = 'dailyNotifications';
  static const String _askAboutYesterdayKey = 'askAboutYesterday';
  static const String _notificationTimeKey = 'notificationTime';

  Future<void> init() async {
    _goalsBox = await Hive.openBox<Goal>(_goalsBoxName);
    _settingsBox = await Hive.openBox(_settingsBoxName);
    _scheduleInitialNotification();
  }

  // --- Goals ---

  String get northStarGoal => _settingsBox.get(_northStarGoalKey, defaultValue: '') as String;
  String get multiDayGoal => _settingsBox.get(_multiDayGoalKey, defaultValue: '') as String;

  Future<void> setNorthStarGoal(String goal) async {
    await _settingsBox.put(_northStarGoalKey, goal);
    notifyListeners();
  }

  Future<void> setMultiDayGoal(String goal) async {
    await _settingsBox.put(_multiDayGoalKey, goal);
    notifyListeners();
  }

  List<Goal> getAllGoals() {
    return _goalsBox.values.toList()..sort((a, b) => b.date.compareTo(a.date));
  }

  Future<void> addGoal(Goal goal) async {
    await _goalsBox.add(goal);
    notifyListeners();
  }

  Future<void> updateGoal(Goal goal) async {
    await goal.save();
    notifyListeners();
  }

  // --- Settings ---

  bool get dailyNotifications => _settingsBox.get(_dailyNotificationsKey, defaultValue: true) as bool;
  bool get askAboutYesterday => _settingsBox.get(_askAboutYesterdayKey, defaultValue: true) as bool;

  TimeOfDay get notificationTime {
    final timeString = _settingsBox.get(_notificationTimeKey, defaultValue: '18:25') as String;
    final parts = timeString.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  Future<void> setDailyNotifications(bool value) async {
    await _settingsBox.put(_dailyNotificationsKey, value);
    if (value) {
      _scheduleNotification();
    } else {
      await _notificationService.cancelAllNotifications();
    }
    notifyListeners();
  }

  Future<void> setAskAboutYesterday(bool value) async {
    await _settingsBox.put(_askAboutYesterdayKey, value);
    notifyListeners();
  }

  Future<void> setNotificationTime(TimeOfDay time) async {
    await _settingsBox.put(_notificationTimeKey, '${time.hour}:${time.minute}');
    if (dailyNotifications) {
      _scheduleNotification();
    }
    notifyListeners();
  }

  void _scheduleInitialNotification() {
    if (dailyNotifications) {
      _scheduleNotification();
    }
  }

  void _scheduleNotification() {
    final now = tz.TZDateTime.now(tz.local);
    final time = notificationTime;
    var scheduledDate =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, time.hour, time.minute);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    _notificationService.scheduleDailyNotification(scheduledDate);
  }
} 