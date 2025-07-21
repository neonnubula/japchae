import 'package:flutter/foundation.dart';
import 'package:most_important_thing/models/badge_model.dart';
import 'package:most_important_thing/services/storage_service.dart';

class GamificationService extends ChangeNotifier {
  final StorageService _storageService;
  GamificationData _gamificationData = GamificationData();
  
  // Callback for badge earned celebrations
  Function(String badgeName)? onBadgeEarned;
  
  // Level definitions
  static final List<UserLevel> _levels = [
    UserLevel(level: 1, name: 'Beginner', description: 'Just starting the journey', minXP: 0, maxXP: 249),
    UserLevel(level: 2, name: 'Focused', description: 'Building habits', minXP: 250, maxXP: 749),
    UserLevel(level: 3, name: 'Committed', description: 'Showing dedication', minXP: 750, maxXP: 1749),
    UserLevel(level: 4, name: 'Achiever', description: 'Consistent performer', minXP: 1750, maxXP: 3999),
    UserLevel(level: 5, name: 'Master', description: 'Goal mastery achieved', minXP: 4000, maxXP: 999999),
  ];

  // Badge definitions
  static final List<Badge> _allBadges = [
    // Streak badges - First time only
    Badge(id: 'day_one', name: 'Day One', description: 'Your journey begins!', xpValue: 25, category: BadgeCategory.streak, rarity: BadgeRarity.common, requirement: 1, icon: '🌱'),
    Badge(id: 'getting_started', name: 'Getting Started', description: 'Momentum building', xpValue: 30, category: BadgeCategory.streak, rarity: BadgeRarity.common, requirement: 2, icon: '⚡'),
    Badge(id: 'threes_company', name: "Three's Company", description: 'Forming habits', xpValue: 35, category: BadgeCategory.streak, rarity: BadgeRarity.common, requirement: 3, icon: '🔥'),
    Badge(id: 'high_five', name: 'High Five', description: 'Consistency pays off', xpValue: 50, category: BadgeCategory.streak, rarity: BadgeRarity.common, requirement: 5, icon: '✋'),
    Badge(id: 'lucky_seven', name: 'Lucky Seven', description: 'One week strong!', xpValue: 75, category: BadgeCategory.streak, rarity: BadgeRarity.rare, requirement: 7, icon: '🍀'),
    Badge(id: 'perfect_ten', name: 'Perfect Ten', description: 'Double digits!', xpValue: 100, category: BadgeCategory.streak, rarity: BadgeRarity.rare, requirement: 10, icon: '💯'),
    Badge(id: 'two_weeks', name: 'Two Weeks', description: 'Fortnight achiever', xpValue: 150, category: BadgeCategory.streak, rarity: BadgeRarity.rare, requirement: 14, icon: '📅'),
    Badge(id: 'three_weeks', name: 'Three Weeks', description: 'Habit formed', xpValue: 200, category: BadgeCategory.streak, rarity: BadgeRarity.epic, requirement: 21, icon: '🏆'),
    Badge(id: 'four_weeks', name: 'Four Weeks', description: 'Monthly master', xpValue: 250, category: BadgeCategory.streak, rarity: BadgeRarity.epic, requirement: 28, icon: '👑'),
    Badge(id: 'fifty_days', name: '50 Day Hero', description: 'Incredible dedication', xpValue: 400, category: BadgeCategory.streak, rarity: BadgeRarity.epic, requirement: 50, icon: '🦸'),
    Badge(id: 'century_streak', name: 'Century Club', description: 'Legendary streak', xpValue: 750, category: BadgeCategory.streak, rarity: BadgeRarity.legendary, requirement: 100, icon: '💎'),
    
    // Repeatable streak badges
    Badge(id: 'weekly_warrior', name: 'Weekly Warrior', description: '7+ day streaks', xpValue: 50, category: BadgeCategory.streak, rarity: BadgeRarity.rare, requirement: 7, maxEarnings: 10, icon: '⚔️'),
    Badge(id: 'monthly_champion', name: 'Monthly Champion', description: '30+ day streaks', xpValue: 200, category: BadgeCategory.streak, rarity: BadgeRarity.epic, requirement: 30, maxEarnings: 5, icon: '🏅'),
    Badge(id: 'quarterly_legend', name: 'Quarterly Legend', description: '90+ day streaks', xpValue: 500, category: BadgeCategory.streak, rarity: BadgeRarity.legendary, requirement: 90, maxEarnings: 3, icon: '🌟'),
    
    // Total goals badges
    Badge(id: 'first_steps', name: 'First Steps', description: 'Every journey starts with one step', xpValue: 50, category: BadgeCategory.totalGoals, rarity: BadgeRarity.common, requirement: 5, icon: '👶'),
    Badge(id: 'ten_strong', name: 'Ten Strong', description: 'Building momentum', xpValue: 75, category: BadgeCategory.totalGoals, rarity: BadgeRarity.common, requirement: 10, icon: '💪'),
    Badge(id: 'quarter_century', name: 'Quarter Century', description: 'Consistent achiever', xpValue: 125, category: BadgeCategory.totalGoals, rarity: BadgeRarity.rare, requirement: 25, icon: '🎯'),
    Badge(id: 'half_century', name: 'Half Century', description: 'Halfway to greatness', xpValue: 200, category: BadgeCategory.totalGoals, rarity: BadgeRarity.rare, requirement: 50, icon: '🏃'),
    Badge(id: 'century_goals', name: 'Century Club', description: 'Goal completion master', xpValue: 350, category: BadgeCategory.totalGoals, rarity: BadgeRarity.epic, requirement: 100, icon: '🏛️'),
    Badge(id: 'double_century', name: 'Double Century', description: 'Exceptional dedication', xpValue: 500, category: BadgeCategory.totalGoals, rarity: BadgeRarity.epic, requirement: 200, icon: '🚀'),
    Badge(id: 'triple_century', name: 'Triple Century', description: 'Goal achievement legend', xpValue: 750, category: BadgeCategory.totalGoals, rarity: BadgeRarity.legendary, requirement: 300, icon: '🌠'),
    Badge(id: 'goal_titan', name: 'Goal Titan', description: 'Ultimate achievement', xpValue: 1000, category: BadgeCategory.totalGoals, rarity: BadgeRarity.legendary, requirement: 500, icon: '🗿'),
    
    // Special badges
    Badge(id: 'perfectionist', name: 'Perfectionist', description: '100% completion rate for 30+ goals', xpValue: 300, category: BadgeCategory.special, rarity: BadgeRarity.epic, requirement: 30, icon: '✨'),
    Badge(id: 'comeback_kid', name: 'Comeback Kid', description: 'Restart after 7+ day gap, then 14+ day streak', xpValue: 150, category: BadgeCategory.special, rarity: BadgeRarity.rare, requirement: 14, icon: '🔄'),
    Badge(id: 'marathon_runner', name: 'Marathon Runner', description: '365 goals in a year', xpValue: 1000, category: BadgeCategory.special, rarity: BadgeRarity.legendary, requirement: 365, icon: '🏃‍♂️'),
  ];

  GamificationService(this._storageService) {
    _loadGamificationData();
  }

  // Getters
  GamificationData get gamificationData => _gamificationData;
  List<Badge> get allBadges => _allBadges;
  UserLevel get currentLevel => _levels.firstWhere((level) => level.level == _gamificationData.currentLevel);
  UserLevel? get nextLevel => _gamificationData.currentLevel < 5 ? _levels[_gamificationData.currentLevel] : null;
  int get xpToNextLevel => nextLevel != null ? nextLevel!.minXP - _gamificationData.totalXP : 0;
  double get levelProgress => nextLevel != null ? (_gamificationData.totalXP - currentLevel.minXP) / (nextLevel!.minXP - currentLevel.minXP) : 1.0;

  void _loadGamificationData() {
    // Load from storage or create new
    final stored = _storageService.getGamificationData();
    print('DEBUG: Loading gamification data: $stored');
    _gamificationData = stored ?? GamificationData();
    print('DEBUG: Loaded gamification data - XP: ${_gamificationData.totalXP}, Level: ${_gamificationData.currentLevel}');
    _initializeBadges();
    notifyListeners();
  }

  void _initializeBadges() {
    // Initialize badge progress for all badges if not already present
    print('DEBUG: Initializing badges. Current badges in data: ${_gamificationData.badges.keys.length}');
    for (final badge in _allBadges) {
      if (!_gamificationData.badges.containsKey(badge.id)) {
        _gamificationData.badges[badge.id] = BadgeProgress(maxEarnings: badge.maxEarnings);
        print('DEBUG: Initialized badge: ${badge.id} - ${badge.name}');
      }
    }
    print('DEBUG: Total badges after initialization: ${_gamificationData.badges.keys.length}');
  }

  Future<List<String>> awardXP(int xp, {String? reason}) async {
    print('DEBUG: Awarding $xp XP for reason: $reason');
    final oldLevel = _gamificationData.currentLevel;
    _gamificationData.totalXP += xp;
    print('DEBUG: New total XP: ${_gamificationData.totalXP}');
    
    // Check for level up
    final newLevel = _calculateLevel(_gamificationData.totalXP);
    final leveledUp = newLevel > oldLevel;
    _gamificationData.currentLevel = newLevel;
    
    await _saveGamificationData();
    
    List<String> notifications = [];
    if (leveledUp) {
      notifications.add('Level up! You are now ${currentLevel.name}!');
      print('DEBUG: Level up! New level: ${currentLevel.name}');
    }
    
    notifyListeners();
    return notifications;
  }

  int _calculateLevel(int totalXP) {
    for (int i = _levels.length - 1; i >= 0; i--) {
      if (totalXP >= _levels[i].minXP) {
        return _levels[i].level;
      }
    }
    return 1;
  }

  Future<List<String>> checkAndAwardBadges({
    int? currentStreak,
    int? maxStreak,
    int? totalCompletedGoals,
    bool? hasGap,
  }) async {
    print('DEBUG: Checking badges - Streak: $currentStreak, Max: $maxStreak, Total: $totalCompletedGoals');
    List<String> earnedBadges = [];
    
    // Check streak badges
    if (currentStreak != null) {
      earnedBadges.addAll(await _checkStreakBadges(currentStreak, maxStreak ?? 0));
    }
    
    // Check total goals badges
    if (totalCompletedGoals != null) {
      earnedBadges.addAll(await _checkTotalGoalsBadges(totalCompletedGoals));
    }
    
    // Check special badges
    earnedBadges.addAll(await _checkSpecialBadges(currentStreak ?? 0, totalCompletedGoals ?? 0, hasGap ?? false));
    
    print('DEBUG: Earned badges: $earnedBadges');
    
    await _saveGamificationData();
    notifyListeners();
    
    // Trigger celebrations for earned badges
    if (earnedBadges.isNotEmpty && onBadgeEarned != null) {
      for (final badgeName in earnedBadges) {
        onBadgeEarned!(badgeName);
      }
    }
    
    return earnedBadges;
  }

  Future<List<String>> _checkStreakBadges(int currentStreak, int maxStreak) async {
    List<String> earned = [];
    
    final streakBadges = _allBadges.where((b) => b.category == BadgeCategory.streak).toList();
    print('DEBUG: Found ${streakBadges.length} streak badges to check');
    
    for (final badge in streakBadges) {
      final progress = _gamificationData.badges[badge.id]!;
      print('DEBUG: Checking badge ${badge.name} - requirement: ${badge.requirement}, currentStreak: $currentStreak, earned: ${progress.earned}');
      
      if (badge.maxEarnings == 1) {
        // One-time streak badges
        if (!progress.earned && currentStreak >= badge.requirement) {
          print('DEBUG: Awarding badge: ${badge.name}');
          await _awardBadge(badge.id);
          earned.add(badge.name);
        }
      } else {
        // Repeatable streak badges
        if (progress.canEarnMore && maxStreak >= badge.requirement) {
          print('DEBUG: Awarding repeatable badge: ${badge.name}');
          await _awardBadge(badge.id);
          earned.add('${badge.name} (${progress.timesEarned}/${badge.maxEarnings})');
        }
      }
    }
    
    return earned;
  }

  Future<List<String>> _checkTotalGoalsBadges(int totalGoals) async {
    List<String> earned = [];
    
    for (final badge in _allBadges.where((b) => b.category == BadgeCategory.totalGoals)) {
      final progress = _gamificationData.badges[badge.id]!;
      
      if (!progress.earned && totalGoals >= badge.requirement) {
        await _awardBadge(badge.id);
        earned.add(badge.name);
      }
    }
    
    return earned;
  }

  Future<List<String>> _checkSpecialBadges(int currentStreak, int totalGoals, bool hasGap) async {
    List<String> earned = [];
    
    // Perfectionist badge logic would need completion rate calculation
    // Comeback Kid badge logic would need gap detection
    // Marathon Runner badge would need yearly goal tracking
    
    return earned;
  }

  Future<void> _awardBadge(String badgeId) async {
    final badge = _allBadges.firstWhere((b) => b.id == badgeId);
    final progress = _gamificationData.badges[badgeId]!;
    
    if (badge.maxEarnings == 1) {
      progress.earned = true;
      progress.earnedDate = DateTime.now();
      progress.timesEarned = 1;
    } else {
      progress.timesEarned++;
      if (progress.timesEarned == 1) {
        progress.earned = true;
        progress.earnedDate = DateTime.now();
      }
    }
    
    // Award XP
    await awardXP(badge.xpValue, reason: 'Badge earned: ${badge.name}');
  }

  List<Badge> getBadgesByCategory(BadgeCategory category) {
    return _allBadges.where((badge) => badge.category == category).toList();
  }

  List<Badge> getEarnedBadges() {
    return _allBadges.where((badge) => _gamificationData.badges[badge.id]?.earned == true).toList();
  }

  BadgeProgress? getBadgeProgress(String badgeId) {
    return _gamificationData.badges[badgeId];
  }

  Future<void> _saveGamificationData() async {
    _gamificationData.lastUpdated = DateTime.now();
    await _storageService.saveGamificationData(_gamificationData);
  }

  Future<void> reset() async {
    _gamificationData = GamificationData();
    _initializeBadges();
    await _saveGamificationData();
    notifyListeners();
  }
} 