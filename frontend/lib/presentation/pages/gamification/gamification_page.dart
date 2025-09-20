import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/colors.dart';
import '../../../core/theme/text_styles.dart';

class GamificationPage extends ConsumerStatefulWidget {
  const GamificationPage({Key? key}) : super(key: key);

  @override
  ConsumerState<GamificationPage> createState() => _GamificationPageState();
}

class _GamificationPageState extends ConsumerState<GamificationPage>
    with TickerProviderStateMixin {
  late AnimationController _streakAnimationController;
  late AnimationController _progressAnimationController;
  late Animation<double> _streakAnimation;
  late Animation<double> _progressAnimation;

  // Mock user data
  final UserProgress userProgress = UserProgress(
    currentStreak: 7,
    longestStreak: 21,
    totalMoodEntries: 45,
    totalJournalEntries: 23,
    level: 5,
    currentXP: 1250,
    xpToNextLevel: 500,
    totalXP: 1750,
  );

  @override
  void initState() {
    super.initState();
    _streakAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _progressAnimationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _streakAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _streakAnimationController,
        curve: Curves.elasticOut,
      ),
    );
    _progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _progressAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    _streakAnimationController.forward();
    _progressAnimationController.forward();
  }

  @override
  void dispose() {
    _streakAnimationController.dispose();
    _progressAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Your Journey'),
        backgroundColor: Colors.white,
        foregroundColor: MindSpaceColors.textDark,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: _showInfoDialog,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildLevelCard(),
            const SizedBox(height: 16),
            _buildStreakSection(),
            const SizedBox(height: 16),
            _buildStatsGrid(),
            const SizedBox(height: 16),
            _buildAchievementsSection(),
            const SizedBox(height: 16),
            _buildWeeklyProgress(),
          ],
        ),
      ),
    );
  }

  Widget _buildLevelCard() {
    double progressPercent = userProgress.currentXP / userProgress.totalXP;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            MindSpaceColors.primaryBlue,
            MindSpaceColors.primaryBlue.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: MindSpaceColors.primaryBlue.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Level ${userProgress.level}',
                    style: AppTextStyles.h2.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Wellness Explorer',
                    style: AppTextStyles.body2.copyWith(color: Colors.white70),
                  ),
                ],
              ),
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.emoji_events,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${userProgress.currentXP} XP',
                    style: AppTextStyles.body2.copyWith(color: Colors.white),
                  ),
                  Text(
                    '${userProgress.xpToNextLevel} XP to Level ${userProgress.level + 1}',
                    style: AppTextStyles.body2.copyWith(color: Colors.white70),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              AnimatedBuilder(
                animation: _progressAnimation,
                builder: (context, child) {
                  return LinearProgressIndicator(
                    value: progressPercent * _progressAnimation.value,
                    backgroundColor: Colors.white.withOpacity(0.3),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Colors.white,
                    ),
                    minHeight: 8,
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStreakSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Current Streak',
                style: AppTextStyles.body1.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.local_fire_department,
                      color: Colors.orange,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'On Fire!',
                      style: AppTextStyles.caption.copyWith(
                        color: Colors.orange,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          AnimatedBuilder(
            animation: _streakAnimation,
            builder: (context, child) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${(userProgress.currentStreak * _streakAnimation.value).round()}',
                    style: AppTextStyles.h1.copyWith(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: MindSpaceColors.primaryBlue,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Days',
                        style: AppTextStyles.body1.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text('in a row', style: AppTextStyles.caption),
                    ],
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 16),
          Text(
            'Keep going! Your longest streak was ${userProgress.longestStreak} days.',
            style: AppTextStyles.caption,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.2,
      children: [
        _buildStatCard(
          title: 'Mood Entries',
          value: '${userProgress.totalMoodEntries}',
          icon: Icons.mood,
          color: Colors.green,
        ),
        _buildStatCard(
          title: 'Journal Entries',
          value: '${userProgress.totalJournalEntries}',
          icon: Icons.book,
          color: Colors.blue,
        ),
        _buildStatCard(
          title: 'Longest Streak',
          value: '${userProgress.longestStreak}',
          icon: Icons.trending_up,
          color: Colors.orange,
        ),
        _buildStatCard(
          title: 'Total XP',
          value: '${userProgress.totalXP}',
          icon: Icons.star,
          color: Colors.purple,
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: AppTextStyles.h3.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: AppTextStyles.caption,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementsSection() {
    List<Achievement> achievements = [
      Achievement(
        title: 'First Steps',
        description: 'Complete your first mood entry',
        icon: Icons.directions_walk,
        isUnlocked: true,
        color: Colors.green,
      ),
      Achievement(
        title: 'Consistent Creator',
        description: 'Log mood for 7 days straight',
        icon: Icons.schedule,
        isUnlocked: true,
        color: Colors.blue,
      ),
      Achievement(
        title: 'Reflection Master',
        description: 'Write 10 journal entries',
        icon: Icons.edit,
        isUnlocked: true,
        color: Colors.purple,
      ),
      Achievement(
        title: 'Community Helper',
        description: 'Help 5 community members',
        icon: Icons.people_alt,
        isUnlocked: false,
        color: Colors.orange,
      ),
      Achievement(
        title: 'Mindfulness Guru',
        description: 'Maintain a 30-day streak',
        icon: Icons.self_improvement,
        isUnlocked: false,
        color: Colors.indigo,
      ),
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Achievements',
                style: AppTextStyles.body1.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextButton(
                onPressed: _showAllAchievements,
                child: const Text('View All'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...achievements
              .take(3)
              .map((achievement) => _buildAchievementItem(achievement)),
        ],
      ),
    );
  }

  Widget _buildAchievementItem(Achievement achievement) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color:
            achievement.isUnlocked
                ? achievement.color.withOpacity(0.1)
                : Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color:
              achievement.isUnlocked
                  ? achievement.color.withOpacity(0.3)
                  : Colors.grey.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color:
                  achievement.isUnlocked
                      ? achievement.color.withOpacity(0.2)
                      : Colors.grey.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              achievement.icon,
              color: achievement.isUnlocked ? achievement.color : Colors.grey,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  achievement.title,
                  style: AppTextStyles.body2.copyWith(
                    fontWeight: FontWeight.w600,
                    color:
                        achievement.isUnlocked
                            ? MindSpaceColors.textDark
                            : Colors.grey,
                  ),
                ),
                Text(
                  achievement.description,
                  style: AppTextStyles.caption.copyWith(
                    color:
                        achievement.isUnlocked
                            ? MindSpaceColors.textLight
                            : Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          if (achievement.isUnlocked)
            Icon(Icons.check_circle, color: achievement.color, size: 20),
        ],
      ),
    );
  }

  Widget _buildWeeklyProgress() {
    List<DayProgress> weekProgress = [
      DayProgress('Mon', true),
      DayProgress('Tue', true),
      DayProgress('Wed', true),
      DayProgress('Thu', true),
      DayProgress('Fri', true),
      DayProgress('Sat', true),
      DayProgress('Sun', true),
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'This Week\'s Progress',
            style: AppTextStyles.body1.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children:
                weekProgress.map((day) => _buildDayIndicator(day)).toList(),
          ),
          const SizedBox(height: 16),
          Text(
            'Perfect week! You\'ve been consistent with your wellness journey.',
            style: AppTextStyles.caption,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildDayIndicator(DayProgress day) {
    return Column(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color:
                day.completed
                    ? MindSpaceColors.primaryBlue
                    : Colors.grey.withOpacity(0.3),
            shape: BoxShape.circle,
          ),
          child:
              day.completed
                  ? const Icon(Icons.check, color: Colors.white, size: 18)
                  : null,
        ),
        const SizedBox(height: 8),
        Text(
          day.day,
          style: AppTextStyles.caption.copyWith(
            color: day.completed ? MindSpaceColors.primaryBlue : Colors.grey,
            fontWeight: day.completed ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  void _showInfoDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('How XP Works'),
            content: const Text(
              '• Daily mood entry: +50 XP\n'
              '• Journal entry: +100 XP\n'
              '• Community interaction: +25 XP\n'
              '• Weekly streak bonus: +200 XP\n'
              '• Helping others: +75 XP',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Got it!'),
              ),
            ],
          ),
    );
  }

  void _showAllAchievements() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('All achievements screen coming soon!'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

// Data Models
class UserProgress {
  final int currentStreak;
  final int longestStreak;
  final int totalMoodEntries;
  final int totalJournalEntries;
  final int level;
  final int currentXP;
  final int xpToNextLevel;
  final int totalXP;

  UserProgress({
    required this.currentStreak,
    required this.longestStreak,
    required this.totalMoodEntries,
    required this.totalJournalEntries,
    required this.level,
    required this.currentXP,
    required this.xpToNextLevel,
    required this.totalXP,
  });
}

class Achievement {
  final String title;
  final String description;
  final IconData icon;
  final bool isUnlocked;
  final Color color;

  Achievement({
    required this.title,
    required this.description,
    required this.icon,
    required this.isUnlocked,
    required this.color,
  });
}

class DayProgress {
  final String day;
  final bool completed;

  DayProgress(this.day, this.completed);
}
