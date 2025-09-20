import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/colors.dart';
import '../../../core/theme/text_styles.dart';

class JournalPage extends ConsumerStatefulWidget {
  const JournalPage({Key? key}) : super(key: key);

  @override
  ConsumerState<JournalPage> createState() => _JournalPageState();
}

class _JournalPageState extends ConsumerState<JournalPage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final PageController _pageController = PageController();

  // Mock journal entries
  List<JournalEntry> _journalEntries = [
    JournalEntry(
      id: '1',
      title: 'Peaceful Morning',
      content:
          'Started my day with meditation and felt really centered. The anxiety from yesterday seems to have faded. Grateful for this moment of calm.',
      mood: 'calm',
      moodColor: Colors.blue,
      date: DateTime.now().subtract(const Duration(hours: 2)),
      tags: ['meditation', 'gratitude', 'morning'],
    ),
    JournalEntry(
      id: '2',
      title: 'Work Stress',
      content:
          'Difficult day at work. Deadline pressure is getting to me. Need to remember to take breaks and practice the breathing exercises.',
      mood: 'stressed',
      moodColor: Colors.orange,
      date: DateTime.now().subtract(const Duration(days: 1)),
      tags: ['work', 'stress', 'breathing'],
    ),
    JournalEntry(
      id: '3',
      title: 'Evening Reflection',
      content:
          'Took a long walk in the park today. Nature always helps me reset. Feeling hopeful about tomorrow and the progress I\'m making.',
      mood: 'hopeful',
      moodColor: Colors.green,
      date: DateTime.now().subtract(const Duration(days: 2)),
      tags: ['nature', 'walking', 'progress'],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('My Journal'),
        backgroundColor: Colors.white,
        foregroundColor: MindSpaceColors.textDark,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          labelColor: MindSpaceColors.primaryBlue,
          unselectedLabelColor: MindSpaceColors.textLight,
          indicatorColor: MindSpaceColors.primaryBlue,
          tabs: const [
            Tab(text: 'Journal'),
            Tab(text: 'Mood Tracker'),
            Tab(text: 'Insights'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: _showSearchDialog,
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildJournalTab(),
          _buildMoodTrackerTab(),
          _buildInsightsTab(),
        ],
      ),
      floatingActionButton:
          _tabController.index == 0
              ? FloatingActionButton(
                onPressed: _showNewEntryDialog,
                backgroundColor: MindSpaceColors.primaryBlue,
                child: const Icon(Icons.add, color: Colors.white),
              )
              : null,
    );
  }

  Widget _buildJournalTab() {
    return Column(
      children: [
        _buildJournalHeader(),
        Expanded(
          child:
              _journalEntries.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _journalEntries.length,
                    itemBuilder: (context, index) {
                      return _buildJournalCard(_journalEntries[index]);
                    },
                  ),
        ),
      ],
    );
  }

  Widget _buildJournalHeader() {
    final today = DateTime.now();
    final todayEntries =
        _journalEntries.where((entry) => _isSameDay(entry.date, today)).length;

    return Container(
      margin: const EdgeInsets.all(16),
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
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Today\'s Reflection',
                  style: AppTextStyles.h2.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  todayEntries > 0
                      ? '$todayEntries entries today'
                      : 'No entries yet today',
                  style: AppTextStyles.body2.copyWith(
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.book, color: Colors.white, size: 32),
          ),
        ],
      ),
    );
  }

  Widget _buildJournalCard(JournalEntry entry) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showEntryDetails(entry),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: entry.moodColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        entry.title,
                        style: AppTextStyles.h3.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Text(
                      _formatDate(entry.date),
                      style: AppTextStyles.caption.copyWith(
                        color: MindSpaceColors.textLight,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  entry.content,
                  style: AppTextStyles.body2.copyWith(
                    color: MindSpaceColors.textLight,
                    height: 1.4,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                if (entry.tags.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children:
                        entry.tags
                            .map(
                              (tag) => Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: entry.moodColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  '#$tag',
                                  style: AppTextStyles.caption.copyWith(
                                    color: entry.moodColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMoodTrackerTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMoodOverview(),
          const SizedBox(height: 24),
          Text(
            'Weekly Mood Pattern',
            style: AppTextStyles.h3.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),
          _buildMoodChart(),
          const SizedBox(height: 24),
          Text(
            'Quick Mood Check',
            style: AppTextStyles.h3.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),
          _buildQuickMoodSelector(),
        ],
      ),
    );
  }

  Widget _buildMoodOverview() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'Current Mood',
            style: AppTextStyles.h3.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.sentiment_satisfied,
              size: 40,
              color: Colors.blue,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Calm',
            style: AppTextStyles.h2.copyWith(
              color: Colors.blue,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'You\'ve been feeling calm today',
            style: AppTextStyles.body2.copyWith(
              color: MindSpaceColors.textLight,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMoodChart() {
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final moodLevels = [3, 4, 2, 5, 4, 3, 4]; // Mock data

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(days.length, (index) {
              return Column(
                children: [
                  Container(
                    width: 4,
                    height: moodLevels[index] * 15.0,
                    decoration: BoxDecoration(
                      color: _getMoodColor(moodLevels[index]),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    days[index],
                    style: AppTextStyles.caption.copyWith(
                      color: MindSpaceColors.textLight,
                    ),
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickMoodSelector() {
    final moods = [
      {'emoji': '😊', 'label': 'Happy', 'color': Colors.yellow},
      {'emoji': '😌', 'label': 'Calm', 'color': Colors.blue},
      {'emoji': '😟', 'label': 'Anxious', 'color': Colors.orange},
      {'emoji': '😢', 'label': 'Sad', 'color': Colors.indigo},
      {'emoji': '😴', 'label': 'Tired', 'color': Colors.purple},
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'How are you feeling right now?',
            style: AppTextStyles.body1.copyWith(fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children:
                moods
                    .map(
                      (mood) => GestureDetector(
                        onTap: () => _logQuickMood(mood['label'] as String),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: (mood['color'] as Color).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: (mood['color'] as Color).withOpacity(0.3),
                            ),
                          ),
                          child: Column(
                            children: [
                              Text(
                                mood['emoji'] as String,
                                style: const TextStyle(fontSize: 24),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                mood['label'] as String,
                                style: AppTextStyles.caption.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                    .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildInsightsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInsightCard(
            'Writing Streak',
            '🔥',
            '7 days',
            'Keep up the great work!',
            Colors.orange,
          ),
          const SizedBox(height: 16),
          _buildInsightCard(
            'Most Common Mood',
            '😌',
            'Calm',
            'You\'ve been feeling calm 60% of the time',
            Colors.blue,
          ),
          const SizedBox(height: 16),
          _buildInsightCard(
            'Weekly Progress',
            '📈',
            'Improving',
            'Your mood has been trending positively',
            Colors.green,
          ),
          const SizedBox(height: 16),
          _buildRecommendations(),
        ],
      ),
    );
  }

  Widget _buildInsightCard(
    String title,
    String emoji,
    String value,
    String description,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(emoji, style: const TextStyle(fontSize: 24)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.body2.copyWith(
                    color: MindSpaceColors.textLight,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: AppTextStyles.h2.copyWith(
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: AppTextStyles.caption.copyWith(
                    color: MindSpaceColors.textLight,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendations() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Personalized Recommendations',
            style: AppTextStyles.h3.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),
          _buildRecommendationItem(
            'Continue your morning meditation practice',
            'Your entries show better mood on meditation days',
            Icons.self_improvement,
          ),
          _buildRecommendationItem(
            'Try journaling before stressful work days',
            'Writing helps you process emotions better',
            Icons.edit,
          ),
          _buildRecommendationItem(
            'Schedule more nature walks',
            'Your mood improves significantly after outdoor activities',
            Icons.nature_people,
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendationItem(
    String title,
    String description,
    IconData icon,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, color: MindSpaceColors.primaryBlue, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.body2.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  description,
                  style: AppTextStyles.caption.copyWith(
                    color: MindSpaceColors.textLight,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.book_outlined, size: 64, color: MindSpaceColors.textLight),
          const SizedBox(height: 16),
          Text(
            'Start Your Journal Journey',
            style: AppTextStyles.h2.copyWith(color: MindSpaceColors.textLight),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap the + button to write your first entry',
            style: AppTextStyles.body2.copyWith(
              color: MindSpaceColors.textLight,
            ),
          ),
        ],
      ),
    );
  }

  Color _getMoodColor(int level) {
    switch (level) {
      case 1:
        return Colors.red;
      case 2:
        return Colors.orange;
      case 3:
        return Colors.yellow;
      case 4:
        return Colors.lightGreen;
      case 5:
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date).inDays;

    if (difference == 0) {
      return 'Today';
    } else if (difference == 1) {
      return 'Yesterday';
    } else if (difference < 7) {
      return '${difference} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  void _showNewEntryDialog() {
    final titleController = TextEditingController();
    final contentController = TextEditingController();
    String selectedMood = 'calm';
    Color selectedMoodColor = Colors.blue;

    showDialog(
      context: context,
      builder:
          (context) => StatefulBuilder(
            builder:
                (context, setState) => AlertDialog(
                  title: const Text('New Journal Entry'),
                  content: SizedBox(
                    width: double.maxFinite,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: titleController,
                          decoration: const InputDecoration(
                            labelText: 'Title',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: contentController,
                          decoration: const InputDecoration(
                            labelText: 'What\'s on your mind?',
                            border: OutlineInputBorder(),
                          ),
                          maxLines: 4,
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            const Text('Mood: '),
                            DropdownButton<String>(
                              value: selectedMood,
                              items: const [
                                DropdownMenuItem(
                                  value: 'happy',
                                  child: Text('😊 Happy'),
                                ),
                                DropdownMenuItem(
                                  value: 'calm',
                                  child: Text('😌 Calm'),
                                ),
                                DropdownMenuItem(
                                  value: 'anxious',
                                  child: Text('😟 Anxious'),
                                ),
                                DropdownMenuItem(
                                  value: 'sad',
                                  child: Text('😢 Sad'),
                                ),
                              ],
                              onChanged: (value) {
                                setState(() {
                                  selectedMood = value!;
                                  selectedMoodColor = _getMoodColorByName(
                                    value,
                                  );
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (titleController.text.isNotEmpty &&
                            contentController.text.isNotEmpty) {
                          _addNewEntry(
                            titleController.text,
                            contentController.text,
                            selectedMood,
                            selectedMoodColor,
                          );
                          Navigator.pop(context);
                        }
                      },
                      child: const Text('Save'),
                    ),
                  ],
                ),
          ),
    );
  }

  Color _getMoodColorByName(String mood) {
    switch (mood) {
      case 'happy':
        return Colors.yellow;
      case 'calm':
        return Colors.blue;
      case 'anxious':
        return Colors.orange;
      case 'sad':
        return Colors.indigo;
      default:
        return Colors.grey;
    }
  }

  void _addNewEntry(
    String title,
    String content,
    String mood,
    Color moodColor,
  ) {
    final newEntry = JournalEntry(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      content: content,
      mood: mood,
      moodColor: moodColor,
      date: DateTime.now(),
      tags: [],
    );

    setState(() {
      _journalEntries.insert(0, newEntry);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Journal entry saved!'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showEntryDetails(JournalEntry entry) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(entry.title),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: entry.moodColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        entry.mood.toUpperCase(),
                        style: AppTextStyles.caption.copyWith(
                          fontWeight: FontWeight.w600,
                          color: entry.moodColor,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        _formatDate(entry.date),
                        style: AppTextStyles.caption.copyWith(
                          color: MindSpaceColors.textLight,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    entry.content,
                    style: AppTextStyles.body2.copyWith(height: 1.4),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ],
          ),
    );
  }

  void _showSearchDialog() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Search functionality coming soon!'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _logQuickMood(String mood) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Mood logged: $mood'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

// Data Models
class JournalEntry {
  final String id;
  final String title;
  final String content;
  final String mood;
  final Color moodColor;
  final DateTime date;
  final List<String> tags;

  JournalEntry({
    required this.id,
    required this.title,
    required this.content,
    required this.mood,
    required this.moodColor,
    required this.date,
    required this.tags,
  });
}
