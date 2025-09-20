import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/colors.dart';
import '../../../core/theme/text_styles.dart';

class CommunityFeedPage extends ConsumerStatefulWidget {
  const CommunityFeedPage({Key? key}) : super(key: key);

  @override
  ConsumerState<CommunityFeedPage> createState() => _CommunityFeedPageState();
}

class _CommunityFeedPageState extends ConsumerState<CommunityFeedPage> {
  final ScrollController _scrollController = ScrollController();

  // Mock data for community posts
  final List<CommunityPost> _posts = [
    CommunityPost(
      id: '1',
      content:
          'Today marks my 7-day streak of meditation! 🧘‍♂️ Small steps but feeling more centered.',
      mood: 8,
      emoji: '🧘‍♂️',
      timeAgo: '2 hours ago',
      likes: 12,
      comments: 3,
      isAnonymous: true,
    ),
    CommunityPost(
      id: '2',
      content:
          'Struggling with anxiety today. Any tips for grounding techniques? 💙',
      mood: 4,
      emoji: '💙',
      timeAgo: '4 hours ago',
      likes: 8,
      comments: 7,
      isAnonymous: true,
    ),
    CommunityPost(
      id: '3',
      content:
          'Just completed my first therapy session. Feeling hopeful and ready to heal! ✨',
      mood: 7,
      emoji: '✨',
      timeAgo: '6 hours ago',
      likes: 25,
      comments: 12,
      isAnonymous: false,
      authorName: 'Sarah M.',
    ),
  ];

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Community'),
        backgroundColor: Colors.white,
        foregroundColor: MindSpaceColors.textDark,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshFeed,
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            // Create Post Section
            SliverToBoxAdapter(child: _buildCreatePostSection()),

            // Posts List
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => _buildPostCard(_posts[index]),
                childCount: _posts.length,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCreatePostSection() {
    return Container(
      margin: const EdgeInsets.all(16),
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
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: MindSpaceColors.primaryBlue.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.person,
                  color: MindSpaceColors.primaryBlue,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Share your thoughts anonymously...',
                  style: AppTextStyles.body2.copyWith(
                    color: MindSpaceColors.textLight,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildActionButton(
                icon: Icons.edit_outlined,
                label: 'Share',
                onTap: _showCreatePostDialog,
              ),
              const SizedBox(width: 12),
              _buildActionButton(
                icon: Icons.mood,
                label: 'Mood',
                onTap: _showMoodDialog,
              ),
              const SizedBox(width: 12),
              _buildActionButton(
                icon: Icons.photo_outlined,
                label: 'Photo',
                onTap: () => _showSnackBar('Photo sharing coming soon!'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 18, color: MindSpaceColors.textLight),
              const SizedBox(width: 4),
              Text(
                label,
                style: AppTextStyles.caption.copyWith(
                  color: MindSpaceColors.textLight,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPostCard(CommunityPost post) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
          // Post Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: _getMoodColor(post.mood).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      post.emoji,
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.isAnonymous
                            ? 'Anonymous'
                            : post.authorName ?? 'Unknown',
                        style: AppTextStyles.body1.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        post.timeAgo,
                        style: AppTextStyles.caption.copyWith(
                          color: MindSpaceColors.textLight,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _getMoodColor(post.mood).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Mood ${post.mood}/10',
                    style: AppTextStyles.caption.copyWith(
                      color: _getMoodColor(post.mood),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Post Content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              post.content,
              style: AppTextStyles.body2.copyWith(height: 1.5),
            ),
          ),

          // Post Actions
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                _buildPostAction(
                  icon: Icons.favorite_border,
                  label: '${post.likes}',
                  onTap: () => _likePost(post.id),
                ),
                const SizedBox(width: 24),
                _buildPostAction(
                  icon: Icons.chat_bubble_outline,
                  label: '${post.comments}',
                  onTap: () => _showCommentsDialog(post),
                ),
                const SizedBox(width: 24),
                _buildPostAction(
                  icon: Icons.share_outlined,
                  label: 'Share',
                  onTap: () => _sharePost(post),
                ),
                const Spacer(),
                _buildPostAction(
                  icon: Icons.bookmark_border,
                  label: 'Save',
                  onTap: () => _savePost(post.id),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPostAction({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          children: [
            Icon(icon, size: 18, color: MindSpaceColors.textLight),
            const SizedBox(width: 4),
            Text(
              label,
              style: AppTextStyles.caption.copyWith(
                color: MindSpaceColors.textLight,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getMoodColor(int mood) {
    if (mood >= 8) return Colors.green;
    if (mood >= 6) return Colors.orange;
    if (mood >= 4) return Colors.blue;
    return Colors.red;
  }

  void _showCreatePostDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildCreatePostModal(),
    );
  }

  Widget _buildCreatePostModal() {
    final TextEditingController contentController = TextEditingController();
    int selectedMood = 5;
    String selectedEmoji = '😐';
    bool isAnonymous = true;

    return StatefulBuilder(
      builder: (context, setState) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.8,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Modal Header
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Expanded(
                      child: Text(
                        'Share Your Thoughts',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        _createPost(
                          contentController.text,
                          selectedMood,
                          selectedEmoji,
                          isAnonymous,
                        );
                        Navigator.pop(context);
                      },
                      child: const Text('Post'),
                    ),
                  ],
                ),
              ),

              // Content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Anonymous Toggle
                      Row(
                        children: [
                          Switch(
                            value: isAnonymous,
                            onChanged:
                                (value) => setState(() => isAnonymous = value),
                          ),
                          const SizedBox(width: 8),
                          Text('Post anonymously', style: AppTextStyles.body2),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Mood Selector
                      Text(
                        'How are you feeling? (${selectedMood}/10)',
                        style: AppTextStyles.body2.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Slider(
                        value: selectedMood.toDouble(),
                        min: 1,
                        max: 10,
                        divisions: 9,
                        onChanged: (value) {
                          setState(() {
                            selectedMood = value.round();
                            selectedEmoji = _getEmojiForMood(selectedMood);
                          });
                        },
                      ),

                      Center(
                        child: Text(
                          selectedEmoji,
                          style: const TextStyle(fontSize: 32),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Text Input
                      Expanded(
                        child: TextField(
                          controller: contentController,
                          maxLines: null,
                          expands: true,
                          decoration: const InputDecoration(
                            hintText:
                                'Share your thoughts, feelings, or experiences...',
                            border: InputBorder.none,
                            hintStyle: TextStyle(color: Colors.grey),
                          ),
                          textAlignVertical: TextAlignVertical.top,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _getEmojiForMood(int mood) {
    switch (mood) {
      case 1:
      case 2:
        return '😢';
      case 3:
      case 4:
        return '😔';
      case 5:
      case 6:
        return '😐';
      case 7:
      case 8:
        return '🙂';
      case 9:
      case 10:
        return '😊';
      default:
        return '😐';
    }
  }

  void _showMoodDialog() {
    _showSnackBar('Mood tracking coming soon!');
  }

  void _showFilterDialog() {
    _showSnackBar('Filter options coming soon!');
  }

  void _showCommentsDialog(CommunityPost post) {
    _showSnackBar('Comments feature coming soon!');
  }

  Future<void> _refreshFeed() async {
    await Future.delayed(const Duration(seconds: 1));
    _showSnackBar('Feed refreshed!');
  }

  void _likePost(String postId) {
    _showSnackBar('Post liked!');
  }

  void _sharePost(CommunityPost post) {
    _showSnackBar('Sharing options coming soon!');
  }

  void _savePost(String postId) {
    _showSnackBar('Post saved!');
  }

  void _createPost(String content, int mood, String emoji, bool isAnonymous) {
    if (content.trim().isEmpty) {
      _showSnackBar('Please write something to share');
      return;
    }
    _showSnackBar('Post created successfully!');
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }
}

// Data Models
class CommunityPost {
  final String id;
  final String content;
  final int mood;
  final String emoji;
  final String timeAgo;
  final int likes;
  final int comments;
  final bool isAnonymous;
  final String? authorName;

  CommunityPost({
    required this.id,
    required this.content,
    required this.mood,
    required this.emoji,
    required this.timeAgo,
    required this.likes,
    required this.comments,
    required this.isAnonymous,
    this.authorName,
  });
}
