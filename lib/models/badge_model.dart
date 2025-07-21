import 'package:hive/hive.dart';

part 'badge_model.g.dart';

@HiveType(typeId: 2)
class Badge {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String name;
  
  @HiveField(2)
  final String description;
  
  @HiveField(3)
  final int xpValue;
  
  @HiveField(4)
  final BadgeCategory category;
  
  @HiveField(5)
  final BadgeRarity rarity;
  
  @HiveField(6)
  final int requirement;
  
  @HiveField(7)
  final int maxEarnings;
  
  @HiveField(8)
  final String icon;

  Badge({
    required this.id,
    required this.name,
    required this.description,
    required this.xpValue,
    required this.category,
    required this.rarity,
    required this.requirement,
    this.maxEarnings = 1,
    required this.icon,
  });
}

@HiveType(typeId: 3)
class BadgeProgress {
  @HiveField(0)
  bool earned;
  
  @HiveField(1)
  DateTime? earnedDate;
  
  @HiveField(2)
  int timesEarned;
  
  @HiveField(3)
  int progress;
  
  @HiveField(4)
  final int maxEarnings;

  BadgeProgress({
    this.earned = false,
    this.earnedDate,
    this.timesEarned = 0,
    this.progress = 0,
    this.maxEarnings = 1,
  });
  
  bool get canEarnMore => timesEarned < maxEarnings;
  double get progressPercentage => progress / 100.0;
}

@HiveType(typeId: 4)
enum BadgeCategory {
  @HiveField(0)
  streak,
  @HiveField(1)
  totalGoals,
  @HiveField(2)
  special,
}

@HiveType(typeId: 5)
enum BadgeRarity {
  @HiveField(0)
  common,
  @HiveField(1)
  rare,
  @HiveField(2)
  epic,
  @HiveField(3)
  legendary,
}

@HiveType(typeId: 6)
class UserLevel {
  @HiveField(0)
  final int level;
  
  @HiveField(1)
  final String name;
  
  @HiveField(2)
  final String description;
  
  @HiveField(3)
  final int minXP;
  
  @HiveField(4)
  final int maxXP;

  UserLevel({
    required this.level,
    required this.name,
    required this.description,
    required this.minXP,
    required this.maxXP,
  });
}

@HiveType(typeId: 7)
class GamificationData {
  @HiveField(0)
  int totalXP;
  
  @HiveField(1)
  int currentLevel;
  
  @HiveField(2)
  Map<String, BadgeProgress> badges;
  
  @HiveField(3)
  Map<String, int> allTimeStats;
  
  @HiveField(4)
  DateTime lastUpdated;

  GamificationData({
    this.totalXP = 0,
    this.currentLevel = 1,
    Map<String, BadgeProgress>? badges,
    Map<String, int>? allTimeStats,
    DateTime? lastUpdated,
  }) : badges = badges ?? {},
       allTimeStats = allTimeStats ?? {},
       lastUpdated = lastUpdated ?? DateTime.now();
} 