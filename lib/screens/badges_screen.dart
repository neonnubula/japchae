import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:most_important_thing/models/badge_model.dart' as badge_model;
import 'package:most_important_thing/services/gamification_service.dart';
import 'package:most_important_thing/widgets/app_header.dart';
import 'package:intl/intl.dart';

class BadgesScreen extends StatefulWidget {
  const BadgesScreen({super.key});

  @override
  State<BadgesScreen> createState() => _BadgesScreenState();
}

class _BadgesScreenState extends State<BadgesScreen> {
  badge_model.BadgeCategory _selectedCategory = badge_model.BadgeCategory.streak;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _buildCategoryTabs(),
          const SizedBox(height: 24),
          Expanded(
            child: Consumer<GamificationService>(
              builder: (context, gamificationService, child) {
                final badges = gamificationService.getBadgesByCategory(_selectedCategory);
                return _buildBadgeGrid(badges, gamificationService);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryTabs() {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildCategoryTab(
              'Streak',
              badge_model.BadgeCategory.streak,
              Icons.local_fire_department,
            ),
          ),
          Expanded(
            child: _buildCategoryTab(
              'Total Goals',
              badge_model.BadgeCategory.totalGoals,
              Icons.flag,
            ),
          ),
          Expanded(
            child: _buildCategoryTab(
              'Special',
              badge_model.BadgeCategory.special,
              Icons.star,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryTab(String title, badge_model.BadgeCategory category, IconData icon) {
    final isSelected = _selectedCategory == category;
    return GestureDetector(
      onTap: () => setState(() => _selectedCategory = category),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF0066CC) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : Theme.of(context).iconTheme.color,
              size: 20,
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                color: isSelected ? Colors.white : Theme.of(context).textTheme.bodyMedium?.color,
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadgeGrid(List<badge_model.Badge> badges, GamificationService gamificationService) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.85,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: badges.length,
      itemBuilder: (context, index) {
        final badge = badges[index];
        final progress = gamificationService.getBadgeProgress(badge.id);
        return _buildBadgeCard(badge, progress);
      },
    );
  }

  Widget _buildBadgeCard(badge_model.Badge badge, badge_model.BadgeProgress? progress) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final isEarned = progress?.earned ?? false;
    final isInProgress = !isEarned && (progress?.progress ?? 0) > 0;

    return GestureDetector(
      onTap: () => _showBadgeDetails(badge, progress),
      child: ElevatedGradientCard(
        isDarkMode: isDarkMode,
        useGradient: isEarned,
        elevation: isEarned ? 12.0 : 6.0,
        borderRadius: 20.0,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Badge icon with state
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _getBadgeColor(badge.rarity, isEarned),
                boxShadow: isEarned ? [
                  BoxShadow(
                    color: _getBadgeColor(badge.rarity, true).withValues(alpha: 0.3),
                    blurRadius: 8,
                    spreadRadius: 2,
                  )
                ] : null,
              ),
              child: Center(
                child: isEarned
                    ? Text(
                        badge.icon,
                        style: const TextStyle(fontSize: 28),
                      )
                    : Icon(
                        isInProgress ? Icons.lock_open : Icons.lock,
                        color: Colors.white,
                        size: 24,
                      ),
              ),
            ),
            const SizedBox(height: 12),
            
            // Badge name
            Text(
              badge.name,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isEarned ? null : Colors.grey,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            
            // XP value
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFF0066CC).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '+${badge.xpValue} XP',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF0066CC),
                ),
              ),
            ),
            const SizedBox(height: 8),
            
            // Progress or earned status
            if (isEarned)
              _buildEarnedStatus(progress!)
            else if (isInProgress)
              _buildProgressBar(progress!)
            else
              _buildLockedStatus(badge),
          ],
        ),
      ),
    );
  }

  Widget _buildEarnedStatus(badge_model.BadgeProgress progress) {
    final earnedDate = progress.earnedDate!;
    return Column(
      children: [
        const Icon(Icons.check_circle, color: Colors.green, size: 16),
        const SizedBox(height: 2),
        Text(
          DateFormat('MMM d').format(earnedDate),
          style: const TextStyle(fontSize: 10, color: Colors.grey),
        ),
        if (progress.timesEarned > 1)
          Text(
            '${progress.timesEarned}x earned',
            style: const TextStyle(fontSize: 10, color: Colors.grey),
          ),
      ],
    );
  }

  Widget _buildProgressBar(badge_model.BadgeProgress progress) {
    return Column(
      children: [
        LinearProgressIndicator(
          value: progress.progressPercentage,
          backgroundColor: Colors.grey[300],
          valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF0066CC)),
        ),
        const SizedBox(height: 2),
        Text(
          '${progress.progress}%',
          style: const TextStyle(fontSize: 10, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildLockedStatus(badge_model.Badge badge) {
    return Text(
      'Reach ${badge.requirement}',
      style: const TextStyle(fontSize: 10, color: Colors.grey),
      textAlign: TextAlign.center,
    );
  }

  Color _getBadgeColor(badge_model.BadgeRarity rarity, bool isEarned) {
    if (!isEarned) return Colors.grey;
    
    switch (rarity) {
      case badge_model.BadgeRarity.common:
        return Colors.blue;
      case badge_model.BadgeRarity.rare:
        return Colors.purple;
      case badge_model.BadgeRarity.epic:
        return Colors.orange;
      case badge_model.BadgeRarity.legendary:
        return Colors.amber;
    }
  }

  void _showBadgeDetails(badge_model.Badge badge, badge_model.BadgeProgress? progress) {
    final isEarned = progress?.earned ?? false;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _getBadgeColor(badge.rarity, isEarned),
              ),
              child: Center(
                child: isEarned
                    ? Text(badge.icon, style: const TextStyle(fontSize: 20))
                    : const Icon(Icons.lock, color: Colors.white, size: 20),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                badge.name,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(badge.description),
            const SizedBox(height: 16),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0066CC).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '+${badge.xpValue} XP',
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF0066CC),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getBadgeColor(badge.rarity, true).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    badge.rarity.name.toUpperCase(),
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: _getBadgeColor(badge.rarity, true),
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            if (isEarned && progress != null) ...[
              const SizedBox(height: 16),
              Text(
                'Earned on ${DateFormat('MMMM d, yyyy').format(progress.earnedDate!)}',
                style: const TextStyle(color: Colors.grey),
              ),
              if (progress.timesEarned > 1)
                Text(
                  'Earned ${progress.timesEarned} times',
                  style: const TextStyle(color: Colors.grey),
                ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
} 