# Gamification System Design

## Overview
A comprehensive badge, XP, and level system to motivate users and celebrate their achievements in goal completion.

## XP System

### XP Sources
- **Daily Goal Completion**: 50 XP
- **Streak Milestones**: Variable XP (see badges section)
- **Total Goals Milestones**: Variable XP (see badges section)
- **Consistency Bonus**: 10 XP for completing goals 3+ days in a row

### Level System (5 Levels)
1. **Beginner** (0-249 XP) - Just starting the journey
2. **Focused** (250-749 XP) - Building habits
3. **Committed** (750-1,749 XP) - Showing dedication
4. **Achiever** (1,750-3,999 XP) - Consistent performer
5. **Master** (4,000+ XP) - Goal mastery achieved

## Badge Categories

### 1. Streak Achievement Badges

#### First-Time Streak Badges (Earned once)
- **Day One** (1 day) - 25 XP - "Your journey begins!"
- **Getting Started** (2 days) - 30 XP - "Momentum building"
- **Three's Company** (3 days) - 35 XP - "Forming habits"
- **High Five** (5 days) - 50 XP - "Consistency pays off"
- **Lucky Seven** (7 days) - 75 XP - "One week strong!"
- **Perfect Ten** (10 days) - 100 XP - "Double digits!"
- **Two Weeks** (14 days) - 150 XP - "Fortnight achiever"
- **Three Weeks** (21 days) - 200 XP - "Habit formed"
- **Four Weeks** (28 days) - 250 XP - "Monthly master"
- **50 Day Hero** (50 days) - 400 XP - "Incredible dedication"
- **Century Club** (100 days) - 750 XP - "Legendary streak"

#### Repeatable Streak Badges (Multiple earnings possible)
- **Weekly Warrior** (7+ day streaks) - 50 XP each - Max 10 times
- **Monthly Champion** (30+ day streaks) - 200 XP each - Max 5 times
- **Quarterly Legend** (90+ day streaks) - 500 XP each - Max 3 times

### 2. Total Goals Achievement Badges

#### Milestone Badges (Earned once)
- **First Steps** (5 goals) - 50 XP - "Every journey starts with one step"
- **Ten Strong** (10 goals) - 75 XP - "Building momentum"
- **Quarter Century** (25 goals) - 125 XP - "Consistent achiever"
- **Half Century** (50 goals) - 200 XP - "Halfway to greatness"
- **Century Club** (100 goals) - 350 XP - "Goal completion master"
- **Double Century** (200 goals) - 500 XP - "Exceptional dedication"
- **Triple Century** (300 goals) - 750 XP - "Goal achievement legend"
- **Goal Titan** (500 goals) - 1000 XP - "Ultimate achievement"

#### Category Badges
- **Perfectionist** (100% completion rate for 30+ goals) - 300 XP
- **Comeback Kid** (Restart after 7+ day gap, then 14+ day streak) - 150 XP
- **Marathon Runner** (365 goals in a year) - 1000 XP

## Badge Display System

### Badge States
1. **Locked** - Gray with lock icon, shows requirements
2. **Earned** - Full color with earned date
3. **In Progress** - Partially filled progress bar

### Badge Rarity Colors
- **Common** (1-3 day streaks, 5-25 goals) - Blue
- **Rare** (7-14 day streaks, 50-100 goals) - Purple
- **Epic** (21-50 day streaks, 200+ goals) - Orange
- **Legendary** (100+ day streaks, 500+ goals) - Gold

## UI Implementation

### Stats/Badges Toggle Page
- Top toggle switch between "Stats" and "Badges"
- Stats: Current streak screen content
- Badges: New badge collection view

### Badge Layout
- Grid layout (2 columns on mobile, 3+ on larger screens)
- Each badge shows:
  - Badge icon/image
  - Badge name
  - XP value
  - Progress bar (if in progress)
  - Earned date (if earned)

### Settings XP Display
- User level and current XP at top of settings
- Progress bar to next level
- Level name and description

## Storage Requirements

### New Storage Fields
- `totalXP: int`
- `currentLevel: int`
- `badges: Map<String, BadgeProgress>`
- `allTimeStats: Map<String, dynamic>`

### Badge Progress Structure
```dart
{
  'badgeId': {
    'earned': bool,
    'earnedDate': DateTime?,
    'timesEarned': int,
    'progress': int,
    'maxEarnings': int
  }
}
```

## Notification Integration
- Badge earned notifications
- Level up notifications
- Streak milestone reminders

## Future Enhancements
- Badge sharing to social media
- Weekly/monthly leaderboards
- Seasonal/themed badges
- Custom badge creation 