import 'package:hive/hive.dart';
import 'package:most_important_thing/models/goal_model.dart';
import 'package:flutter/material.dart';
import 'package:most_important_thing/services/notification_service.dart';
import 'package:timezone/timezone.dart' as tz;
import 'dart:convert';
import 'dart:typed_data'; // Added for Uint8List

class StorageService with ChangeNotifier {
  final NotificationService _notificationService;

  StorageService(this._notificationService);

  late Box<Goal> _goalsBox;
  late Box _settingsBox;
  int? _cachedStreak;
  final Set<DateTime> _completedDatesCache = {};

  static const String _goalsBoxName = 'goals';
  static const String _settingsBoxName = 'settings';
  static const String _northStarGoalKey = 'northStarGoal';
  static const String _multiDayGoalKey = 'multiDayGoal';
  static const String _dailyNotificationsKey = 'dailyNotifications';
  static const String _askAboutYesterdayKey = 'askAboutYesterday';
  static const String _notificationTimeKey = 'notificationTime';

  Future<void> init() async {
    try {
      // Use a valid 32-byte encryption key (replace with secure storage in production)
      final encryptionKey = Uint8List.fromList([
        1, 2, 3, 4, 5, 6, 7, 8,
        9, 10, 11, 12, 13, 14, 15, 16,
        17, 18, 19, 20, 21, 22, 23, 24,
        25, 26, 27, 28, 29, 30, 31, 32
      ]);
      final encryptionCipher = HiveAesCipher(encryptionKey);
      
      _goalsBox = await Hive.openBox<Goal>(_goalsBoxName, encryptionCipher: encryptionCipher);
      _settingsBox = await Hive.openBox(_settingsBoxName, encryptionCipher: encryptionCipher);
      
      _updateCompletedDatesCache();
      _scheduleInitialNotification();
    } catch (e) {
      debugPrint('Error initializing storage: $e');
      rethrow;
    }
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
    try {
      await _goalsBox.add(goal);
      _updateCompletedDatesCache();
      _cachedStreak = null; // Invalidate cache
      notifyListeners();
    } catch (e) {
      debugPrint('Error adding goal: $e');
      throw Exception('Failed to save goal. Please try again.');
    }
  }

  Future<void> updateGoal(Goal goal) async {
    try {
      await goal.save();
      _updateCompletedDatesCache();
      _cachedStreak = null; // Invalidate cache
      notifyListeners();
    } catch (e) {
      debugPrint('Error updating goal: $e');
      throw Exception('Failed to update goal. Please try again.');
    }
  }

  // Add method to retrieve today's goal
  Goal? getTodayGoal() {
    final now = DateTime.now();
    for (final goal in _goalsBox.values) {
      if (goal.date.year == now.year &&
          goal.date.month == now.month &&
          goal.date.day == now.day) {
        return goal;
      }
    }
    return null;
  }

  // Convenience method to create or update today's goal text
  Future<void> setTodayGoal(String text) async {
    try {
      final trimmedText = text.trim();
      if (trimmedText.isEmpty) {
        throw Exception('Goal cannot be empty');
      }
      
      final existingGoal = getTodayGoal();
      if (existingGoal != null) {
        existingGoal.text = trimmedText;
        await existingGoal.save();
      } else {
        final newGoal = Goal()
          ..text = trimmedText
          ..date = DateTime.now()
          ..isCompleted = false;
        await _goalsBox.add(newGoal);
      }
      _updateCompletedDatesCache();
      _cachedStreak = null; // Invalidate cache
      notifyListeners();
    } catch (e) {
      debugPrint('Error setting today goal: $e');
      rethrow;
    }
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

  // --- Cache management ---
  void _updateCompletedDatesCache() {
    _completedDatesCache.clear();
    for (final g in _goalsBox.values) {
      if (g.isCompleted) {
        _completedDatesCache.add(DateTime(g.date.year, g.date.month, g.date.day));
      }
    }
  }

  // --- Streak logic ---
  int getCurrentStreak() {
    // Return cached value if available
    if (_cachedStreak != null) return _cachedStreak!;

    int streak = 0;
    DateTime day = DateTime.now();

    // If today is not yet in the set, start counting from yesterday so we
    // preserve the existing streak.
    final today = DateTime(day.year, day.month, day.day);
    if (!_completedDatesCache.contains(today)) {
      day = day.subtract(const Duration(days: 1));
    }

    // Use cached set for O(1) lookups
    while (_completedDatesCache.contains(DateTime(day.year, day.month, day.day))) {
      streak += 1;
      day = day.subtract(const Duration(days: 1));
    }

    _cachedStreak = streak;
    return streak;
  }

  // --- Data export ---
  String exportData() {
    try {
      final allGoals = getAllGoals();
      final exportData = {
        'goals': allGoals.map((goal) => {
          'text': goal.text,
          'date': goal.date.toIso8601String(),
          'isCompleted': goal.isCompleted,
        }).toList(),
        'northStarGoal': northStarGoal,
        'multiDayGoal': multiDayGoal,
        'exportDate': DateTime.now().toIso8601String(),
      };
      return jsonEncode(exportData);
    } catch (e) {
      debugPrint('Error exporting data: $e');
      throw Exception('Failed to export data');
    }
  }

  // --- Cleanup ---
  @override
  void dispose() {
    _goalsBox.close();
    _settingsBox.close();
    super.dispose();
  }
} 