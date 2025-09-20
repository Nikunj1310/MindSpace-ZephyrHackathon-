import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/colors.dart';
import '../../../core/theme/text_styles.dart';
import '../../providers/auth_provider.dart';

class ChatPage extends ConsumerStatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends ConsumerState<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  // Mock chat messages
  List<ChatMessage> _messages = [
    ChatMessage(
      id: '1',
      content: 'Hi there! How are you feeling today?',
      senderId: 'mentor1',
      senderName: 'Dr. Sarah',
      timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
      isFromCurrentUser: false,
      senderRole: 'mentor',
    ),
    ChatMessage(
      id: '2',
      content:
          'I\'ve been feeling a bit anxious lately. Work has been overwhelming.',
      senderId: 'user1',
      senderName: 'You',
      timestamp: DateTime.now().subtract(const Duration(minutes: 25)),
      isFromCurrentUser: true,
      senderRole: 'user',
    ),
    ChatMessage(
      id: '3',
      content:
          'I understand that work stress can be really challenging. Have you tried any grounding techniques we discussed?',
      senderId: 'mentor1',
      senderName: 'Dr. Sarah',
      timestamp: DateTime.now().subtract(const Duration(minutes: 20)),
      isFromCurrentUser: false,
      senderRole: 'mentor',
    ),
  ];

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserProvider);
    final isAdmin = currentUser?.role == 'admin';
    final isMentor = currentUser?.role == 'mentor';

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: isAdmin ? const Text('Admin Panel') : const Text('Support Chat'),
        backgroundColor: Colors.white,
        foregroundColor: MindSpaceColors.textDark,
        elevation: 0,
        actions: [
          if (isAdmin) ...[
            IconButton(
              icon: const Icon(Icons.dashboard),
              onPressed: _showAdminDashboard,
            ),
            IconButton(
              icon: const Icon(Icons.people),
              onPressed: _showUserManagement,
            ),
          ],
          if (isMentor) ...[
            IconButton(
              icon: const Icon(Icons.assignment),
              onPressed: _showMentorTools,
            ),
          ],
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: _showOptionsMenu,
          ),
        ],
      ),
      body: Column(
        children: [
          if (isAdmin) _buildAdminHeader(),
          if (isMentor) _buildMentorHeader(),
          Expanded(child: _buildMessageList()),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildAdminHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.red.shade400, Colors.red.shade600],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.admin_panel_settings, color: Colors.white),
          const SizedBox(width: 8),
          Text(
            'Admin Mode - Monitor & Support',
            style: AppTextStyles.body2.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '24 active',
              style: AppTextStyles.caption.copyWith(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMentorHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            MindSpaceColors.primaryBlue,
            MindSpaceColors.primaryBlue.withOpacity(0.8),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.psychology, color: Colors.white),
          const SizedBox(width: 8),
          Text(
            'Mentor Chat - Supporting Member',
            style: AppTextStyles.body2.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Colors.greenAccent,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  'Online',
                  style: AppTextStyles.caption.copyWith(color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: _messages.length,
      itemBuilder: (context, index) {
        final message = _messages[index];
        return _buildMessageBubble(message);
      },
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    final bool isCurrentUser = message.isFromCurrentUser;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment:
            isCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isCurrentUser) ...[
            _buildAvatar(message),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.75,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color:
                    isCurrentUser ? MindSpaceColors.primaryBlue : Colors.white,
                borderRadius: BorderRadius.circular(16).copyWith(
                  bottomLeft:
                      isCurrentUser
                          ? const Radius.circular(16)
                          : const Radius.circular(4),
                  bottomRight:
                      isCurrentUser
                          ? const Radius.circular(4)
                          : const Radius.circular(16),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!isCurrentUser)
                    Row(
                      children: [
                        Text(
                          message.senderName,
                          style: AppTextStyles.caption.copyWith(
                            fontWeight: FontWeight.w600,
                            color: _getRoleColor(message.senderRole),
                          ),
                        ),
                        if (message.senderRole == 'mentor' ||
                            message.senderRole == 'admin') ...[
                          const SizedBox(width: 4),
                          Icon(
                            message.senderRole == 'admin'
                                ? Icons.admin_panel_settings
                                : Icons.verified,
                            size: 12,
                            color: _getRoleColor(message.senderRole),
                          ),
                        ],
                      ],
                    ),
                  if (!isCurrentUser) const SizedBox(height: 4),
                  Text(
                    message.content,
                    style: AppTextStyles.body2.copyWith(
                      color:
                          isCurrentUser
                              ? Colors.white
                              : MindSpaceColors.textDark,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatTime(message.timestamp),
                    style: AppTextStyles.caption.copyWith(
                      color:
                          isCurrentUser
                              ? Colors.white.withOpacity(0.8)
                              : MindSpaceColors.textLight,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isCurrentUser) ...[
            const SizedBox(width: 8),
            _buildAvatar(message),
          ],
        ],
      ),
    );
  }

  Widget _buildAvatar(ChatMessage message) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: _getRoleColor(message.senderRole).withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(
        _getRoleIcon(message.senderRole),
        size: 18,
        color: _getRoleColor(message.senderRole),
      ),
    );
  }

  Color _getRoleColor(String role) {
    switch (role) {
      case 'admin':
        return Colors.red;
      case 'mentor':
        return MindSpaceColors.primaryBlue;
      default:
        return Colors.grey;
    }
  }

  IconData _getRoleIcon(String role) {
    switch (role) {
      case 'admin':
        return Icons.admin_panel_settings;
      case 'mentor':
        return Icons.psychology;
      default:
        return Icons.person;
    }
  }

  String _formatTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showAttachmentOptions,
            color: MindSpaceColors.textLight,
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(24),
              ),
              child: TextField(
                controller: _messageController,
                decoration: const InputDecoration(
                  hintText: 'Type your message...',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                maxLines: null,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            decoration: BoxDecoration(
              color: MindSpaceColors.primaryBlue,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.send, color: Colors.white),
              onPressed: _sendMessage,
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    final newMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: _messageController.text.trim(),
      senderId: 'current_user',
      senderName: 'You',
      timestamp: DateTime.now(),
      isFromCurrentUser: true,
      senderRole: 'user',
    );

    setState(() {
      _messages.add(newMessage);
      _messageController.clear();
    });

    // Auto scroll to bottom
    Future.delayed(const Duration(milliseconds: 100), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });

    // Simulate response for demo
    _simulateResponse();
  }

  void _simulateResponse() {
    final currentUser = ref.read(currentUserProvider);
    if (currentUser?.role == 'user') {
      Future.delayed(const Duration(seconds: 2), () {
        final response = ChatMessage(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          content:
              'Thank you for sharing. I\'m here to support you. Can you tell me more about what specifically is causing you anxiety?',
          senderId: 'mentor1',
          senderName: 'Dr. Sarah',
          timestamp: DateTime.now(),
          isFromCurrentUser: false,
          senderRole: 'mentor',
        );

        setState(() {
          _messages.add(response);
        });

        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }

  void _showAttachmentOptions() {
    showModalBottomSheet(
      context: context,
      builder:
          (context) => Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildAttachmentOption(
                  icon: Icons.photo_library,
                  title: 'Photo',
                  onTap: () => Navigator.pop(context),
                ),
                _buildAttachmentOption(
                  icon: Icons.insert_drive_file,
                  title: 'Document',
                  onTap: () => Navigator.pop(context),
                ),
                _buildAttachmentOption(
                  icon: Icons.mood,
                  title: 'Mood Update',
                  onTap: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
    );
  }

  Widget _buildAttachmentOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(leading: Icon(icon), title: Text(title), onTap: onTap);
  }

  void _showAdminDashboard() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Admin Dashboard'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildAdminStat('Active Users', '124'),
                _buildAdminStat('Open Support Tickets', '8'),
                _buildAdminStat('Mentors Online', '6'),
                _buildAdminStat('System Status', 'Healthy'),
              ],
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

  Widget _buildAdminStat(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.body2),
          Text(
            value,
            style: AppTextStyles.body2.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  void _showUserManagement() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('User management panel coming soon!'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showMentorTools() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Mentor tools coming soon!'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showOptionsMenu() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Chat options coming soon!'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

// Data Models
class ChatMessage {
  final String id;
  final String content;
  final String senderId;
  final String senderName;
  final DateTime timestamp;
  final bool isFromCurrentUser;
  final String senderRole;

  ChatMessage({
    required this.id,
    required this.content,
    required this.senderId,
    required this.senderName,
    required this.timestamp,
    required this.isFromCurrentUser,
    required this.senderRole,
  });
}
