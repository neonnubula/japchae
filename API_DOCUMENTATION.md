# Most Important Thing - API Documentation

## Table of Contents

1. [Overview](#overview)
2. [Application Entry Point](#application-entry-point)
3. [Models](#models)
4. [Services](#services)
5. [Screens](#screens)
6. [Dependencies](#dependencies)
7. [Usage Examples](#usage-examples)

## Overview

The "Most Important Thing" is a Flutter application designed to help users focus on their most important daily goals. The app uses a clean architecture with models, services, and screens, following Flutter best practices.

**Key Features:**
- Daily goal setting and tracking
- Streak counting and statistics
- Goal history management
- Push notifications
- Data export functionality
- Dark/light theme support

## Application Entry Point

### `main()` Function

**Location:** `lib/main.dart`

**Purpose:** Application entry point that initializes all services and starts the app.

**Signature:**
```dart
void main() async
```

**Responsibilities:**
- Initializes Flutter bindings
- Sets up global error handling
- Initializes notification service
- Initializes Hive database
- Registers Goal adapter
- Creates and provides StorageService
- Determines initial route (onboarding or home)
- Runs the app with proper error handling

**Usage:**
```dart
// Called automatically when app starts
void main() async {
  // Initialization happens automatically
  // App routes to OnboardingScreen or HomeScreen based on first launch
}
```

### `MostImportantThingApp` Class

**Location:** `lib/main.dart`

**Purpose:** Main application widget that configures themes and routing.

**Constructor:**
```dart
const MostImportantThingApp({super.key, required this.initialRoute})
```

**Properties:**
- `final Widget initialRoute` - The initial screen to display

**Features:**
- Material 3 design system
- Light and dark theme support
- Custom color scheme (primary: #0066CC)
- Responsive design with custom input decorations
- System theme mode detection

**Theme Configuration:**
```dart
// Light theme
colorScheme: ColorScheme.fromSeed(
  seedColor: const Color(0xFF0066CC),
  brightness: Brightness.light,
),
scaffoldBackgroundColor: const Color(0xFFF9F7F3),

// Dark theme
colorScheme: ColorScheme.fromSeed(
  seedColor: const Color(0xFF0066CC),
  brightness: Brightness.dark,
  primary: const Color(0xFF4285F4),
  secondary: const Color(0xFF03DAC6),
),
```

## Models

### `Goal` Class

**Location:** `lib/models/goal_model.dart`

**Purpose:** Data model representing a user's goal with Hive persistence.

**Properties:**
```dart
@HiveField(0)
late String text;        // The goal description

@HiveField(1)
late DateTime date;       // The date the goal was set for

@HiveField(2)
late bool isCompleted;    // Whether the goal was completed
```

**Usage:**
```dart
// Create a new goal
final goal = Goal()
  ..text = "Complete the project proposal"
  ..date = DateTime.now()
  ..isCompleted = false;

// Access goal properties
print(goal.text);           // "Complete the project proposal"
print(goal.date);           // 2024-01-15 10:30:00.000
print(goal.isCompleted);    // false
```

**Hive Integration:**
- Uses `@HiveType(typeId: 0)` for database storage
- Extends `HiveObject` for automatic persistence
- Supports encryption for data security

## Services

### `StorageService` Class

**Location:** `lib/services/storage_service.dart`

**Purpose:** Core service managing data persistence, goal operations, and app settings.

**Constructor:**
```dart
StorageService(this._notificationService)
```

**Dependencies:**
- `NotificationService` - For scheduling notifications

#### Goal Management Methods

##### `Future<void> init()`
**Purpose:** Initializes the storage service and database connections.

**Usage:**
```dart
final storageService = StorageService(notificationService);
await storageService.init();
```

##### `String get northStarGoal`
**Purpose:** Gets the user's major/long-term goal.

**Returns:** `String` - The north star goal text

**Usage:**
```dart
final majorGoal = storageService.northStarGoal;
print(majorGoal); // "Build a successful startup"
```

##### `Future<void> setNorthStarGoal(String goal)`
**Purpose:** Sets the user's major/long-term goal.

**Parameters:**
- `goal` (String) - The goal text to set

**Usage:**
```dart
await storageService.setNorthStarGoal("Build a successful startup");
```

##### `String get multiDayGoal`
**Purpose:** Gets the user's multi-day goal.

**Returns:** `String` - The multi-day goal text

##### `Future<void> setMultiDayGoal(String goal)`
**Purpose:** Sets the user's multi-day goal.

**Parameters:**
- `goal` (String) - The goal text to set

##### `List<Goal> getAllGoals()`
**Purpose:** Retrieves all goals sorted by date (newest first).

**Returns:** `List<Goal>` - All stored goals

**Usage:**
```dart
final allGoals = storageService.getAllGoals();
for (final goal in allGoals) {
  print("${goal.date}: ${goal.text}");
}
```

##### `Future<void> addGoal(Goal goal)`
**Purpose:** Adds a new goal to storage.

**Parameters:**
- `goal` (Goal) - The goal object to add

**Usage:**
```dart
final newGoal = Goal()
  ..text = "Complete the presentation"
  ..date = DateTime.now()
  ..isCompleted = false;

await storageService.addGoal(newGoal);
```

##### `Future<void> updateGoal(Goal goal)`
**Purpose:** Updates an existing goal in storage.

**Parameters:**
- `goal` (Goal) - The goal object to update

**Usage:**
```dart
final goal = storageService.getTodayGoal();
if (goal != null) {
  goal.isCompleted = true;
  await storageService.updateGoal(goal);
}
```

##### `Goal? getTodayGoal()`
**Purpose:** Retrieves today's goal if it exists.

**Returns:** `Goal?` - Today's goal or null if not set

**Usage:**
```dart
final todayGoal = storageService.getTodayGoal();
if (todayGoal != null) {
  print("Today's goal: ${todayGoal.text}");
} else {
  print("No goal set for today");
}
```

##### `Future<void> setTodayGoal(String text)`
**Purpose:** Creates or updates today's goal.

**Parameters:**
- `text` (String) - The goal text

**Usage:**
```dart
await storageService.setTodayGoal("Ship the new feature");
```

#### Settings Management

##### `bool get dailyNotifications`
**Purpose:** Gets whether daily notifications are enabled.

**Returns:** `bool` - True if notifications are enabled

##### `Future<void> setDailyNotifications(bool value)`
**Purpose:** Enables or disables daily notifications.

**Parameters:**
- `value` (bool) - Whether to enable notifications

**Usage:**
```dart
await storageService.setDailyNotifications(true);
```

##### `bool get askAboutYesterday`
**Purpose:** Gets whether to ask about yesterday's goal completion.

**Returns:** `bool` - True if asking about yesterday

##### `Future<void> setAskAboutYesterday(bool value)`
**Purpose:** Sets whether to ask about yesterday's goal completion.

**Parameters:**
- `value` (bool) - Whether to ask about yesterday

##### `TimeOfDay get notificationTime`
**Purpose:** Gets the scheduled notification time.

**Returns:** `TimeOfDay` - The notification time

##### `Future<void> setNotificationTime(TimeOfDay time)`
**Purpose:** Sets the scheduled notification time.

**Parameters:**
- `time` (TimeOfDay) - The time to schedule notifications

**Usage:**
```dart
await storageService.setNotificationTime(TimeOfDay(hour: 18, minute: 30));
```

##### `bool get isFirstLaunch`
**Purpose:** Checks if this is the app's first launch.

**Returns:** `bool` - True if first launch

##### `Future<void> setFirstLaunchCompleted()`
**Purpose:** Marks the first launch as completed.

**Usage:**
```dart
await storageService.setFirstLaunchCompleted();
```

#### Statistics and Analytics

##### `int getCurrentStreak()`
**Purpose:** Calculates the current completion streak.

**Returns:** `int` - Number of consecutive days with completed goals

**Usage:**
```dart
final streak = storageService.getCurrentStreak();
print("Current streak: $streak days");
```

#### Data Export

##### `String exportData()`
**Purpose:** Exports all user data as JSON.

**Returns:** `String` - JSON string containing all goals and settings

**Usage:**
```dart
final exportData = storageService.exportData();
// Share or save the JSON data
```

**Export Format:**
```json
{
  "goals": [
    {
      "text": "Complete the project",
      "date": "2024-01-15T10:30:00.000Z",
      "isCompleted": true
    }
  ],
  "northStarGoal": "Build a successful startup",
  "multiDayGoal": "Launch the MVP",
  "exportDate": "2024-01-15T10:30:00.000Z"
}
```

### `NotificationService` Class

**Location:** `lib/services/notification_service.dart`

**Purpose:** Manages local notifications for goal reminders.

#### Methods

##### `Future<void> init()`
**Purpose:** Initializes the notification service and requests permissions.

**Usage:**
```dart
final notificationService = NotificationService();
await notificationService.init();
```

##### `Future<void> scheduleDailyNotification(tz.TZDateTime scheduledTime)`
**Purpose:** Schedules a daily notification at the specified time.

**Parameters:**
- `scheduledTime` (tz.TZDateTime) - The time to schedule the notification

**Usage:**
```dart
final scheduledTime = tz.TZDateTime.now(tz.local).add(Duration(days: 1));
await notificationService.scheduleDailyNotification(scheduledTime);
```

##### `Future<void> scheduleNotification(int id, String title, String body, tz.TZDateTime scheduledTime)`
**Purpose:** Schedules a custom notification.

**Parameters:**
- `id` (int) - Unique notification ID
- `title` (String) - Notification title
- `body` (String) - Notification body text
- `scheduledTime` (tz.TZDateTime) - When to show the notification

**Usage:**
```dart
await notificationService.scheduleNotification(
  1,
  "Goal Reminder",
  "Don't forget your most important thing today!",
  tz.TZDateTime.now(tz.local).add(Duration(hours: 1))
);
```

##### `Future<void> cancelAllNotifications()`
**Purpose:** Cancels all scheduled notifications.

**Usage:**
```dart
await notificationService.cancelAllNotifications();
```

## Screens

### `HomeScreen` Class

**Location:** `lib/screens/home_screen.dart`

**Purpose:** Main screen displaying today's goal, major goal, and streak information.

**Constructor:**
```dart
const HomeScreen({super.key})
```

**Key Features:**
- Displays major goal (north star goal)
- Shows current streak count
- Allows setting/editing today's goal
- Provides goal completion functionality
- Navigation to other screens

**UI Components:**
- Major goal card (editable)
- Streak counter
- Today's goal input/display
- Completion button
- Bottom navigation

**Usage:**
```dart
Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => const HomeScreen()),
);
```

### `HistoryScreen` Class

**Location:** `lib/screens/history_screen.dart`

**Purpose:** Displays all past goals with completion status and export functionality.

**Constructor:**
```dart
const HistoryScreen({super.key})
```

**Key Features:**
- Lists all goals chronologically
- Shows completion status with checkboxes
- Allows editing completion status
- Share functionality for completed goals
- Export all data functionality

**Usage:**
```dart
Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => const HistoryScreen()),
);
```

### `StreakScreen` Class

**Location:** `lib/screens/streak_screen.dart`

**Purpose:** Displays streak statistics and recent completions.

**Constructor:**
```dart
const StreakScreen({super.key})
```

**Key Features:**
- Large streak counter display
- Total goals and completed goals statistics
- Recent completions list
- Share streak functionality

**Usage:**
```dart
Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => const StreakScreen()),
);
```

### `SettingsScreen` Class

**Location:** `lib/screens/settings_screen.dart`

**Purpose:** Manages app settings and preferences.

**Constructor:**
```dart
const SettingsScreen({super.key})
```

**Key Features:**
- Daily notifications toggle
- Notification time picker
- "Ask about yesterday" toggle
- Data export functionality
- App information

**Usage:**
```dart
Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => const SettingsScreen()),
);
```

### `OnboardingScreen` Class

**Location:** `lib/screens/onboarding_screen.dart`

**Purpose:** Introduces new users to the app concept and functionality.

**Constructor:**
```dart
const OnboardingScreen({super.key})
```

**Key Features:**
- App introduction and value proposition
- Problem/solution explanation
- Get started button
- Marks first launch as completed

**Usage:**
```dart
Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => const OnboardingScreen()),
);
```

### `MenuScreen` Class

**Location:** `lib/screens/menu_screen.dart`

**Purpose:** Provides navigation to different app sections.

**Constructor:**
```dart
const MenuScreen({super.key})
```

**Key Features:**
- Navigation to onboarding
- Navigation to settings

**Usage:**
```dart
Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => const MenuScreen()),
);
```

## Dependencies

### Core Dependencies

**Flutter SDK:** `^3.8.1`

**Key Packages:**
- `hive: ^2.2.3` - Local database storage
- `hive_flutter: ^1.1.0` - Flutter integration for Hive
- `provider: ^6.1.5` - State management
- `flutter_local_notifications: ^19.3.0` - Local notifications
- `timezone: ^0.10.1` - Timezone handling
- `share_plus: ^11.0.0` - Data sharing
- `intl: ^0.20.2` - Internationalization and date formatting
- `flutter_native_timezone: ^2.0.0` - Native timezone detection

### Development Dependencies

- `flutter_lints: ^6.0.0` - Code linting
- `hive_generator: ^2.0.1` - Code generation for Hive
- `build_runner: ^2.4.7` - Build system

## Usage Examples

### Setting Up the App

```dart
// In main.dart
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
      child: MostImportantThingApp(
        initialRoute: storageService.isFirstLaunch 
          ? OnboardingScreen() 
          : HomeScreen()
      ),
    ),
  );
}
```

### Working with Goals

```dart
// Get the storage service
final storageService = Provider.of<StorageService>(context, listen: false);

// Set today's goal
await storageService.setTodayGoal("Complete the project proposal");

// Get today's goal
final todayGoal = storageService.getTodayGoal();
if (todayGoal != null) {
  print("Today's goal: ${todayGoal.text}");
}

// Mark goal as completed
if (todayGoal != null) {
  todayGoal.isCompleted = true;
  await storageService.updateGoal(todayGoal);
}

// Get all goals
final allGoals = storageService.getAllGoals();
for (final goal in allGoals) {
  print("${goal.date}: ${goal.text} - ${goal.isCompleted ? 'Completed' : 'Pending'}");
}
```

### Managing Settings

```dart
// Enable notifications
await storageService.setDailyNotifications(true);

// Set notification time
await storageService.setNotificationTime(TimeOfDay(hour: 18, minute: 30));

// Set major goal
await storageService.setNorthStarGoal("Build a successful startup");

// Check streak
final streak = storageService.getCurrentStreak();
print("Current streak: $streak days");
```

### Scheduling Notifications

```dart
// Initialize notification service
final notificationService = NotificationService();
await notificationService.init();

// Schedule daily notification
final tomorrow = tz.TZDateTime.now(tz.local).add(Duration(days: 1));
await notificationService.scheduleDailyNotification(tomorrow);

// Schedule custom notification
await notificationService.scheduleNotification(
  1,
  "Goal Reminder",
  "Time to check your most important thing!",
  tz.TZDateTime.now(tz.local).add(Duration(hours: 2))
);

// Cancel all notifications
await notificationService.cancelAllNotifications();
```

### Data Export

```dart
// Export all data
final exportData = storageService.exportData();
print(exportData); // JSON string with all goals and settings

// Share exported data
await Share.share(
  exportData,
  subject: 'My Goals Data - Most Important Thing App',
);
```

### Navigation Between Screens

```dart
// Navigate to history screen
Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => const HistoryScreen()),
);

// Navigate to streak screen
Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => const StreakScreen()),
);

// Navigate to settings
Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => const SettingsScreen()),
);
```

## Error Handling

The app includes comprehensive error handling:

```dart
// Example error handling in goal operations
try {
  await storageService.setTodayGoal("Complete the project");
} catch (e) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Error: ${e.toString()}')),
  );
}
```

## Security Features

- Encrypted Hive database storage
- Secure notification handling
- Data validation and sanitization
- Error boundary implementation

## Performance Considerations

- Cached streak calculations
- Efficient goal lookups
- Minimal UI rebuilds with Provider
- Optimized database queries

## Accessibility

- Semantic labels for screen readers
- Proper contrast ratios
- Keyboard navigation support
- VoiceOver/TalkBack compatibility

---

This documentation covers all public APIs, functions, and components of the Most Important Thing Flutter application. For additional support or questions, refer to the Flutter documentation or the project's README file.