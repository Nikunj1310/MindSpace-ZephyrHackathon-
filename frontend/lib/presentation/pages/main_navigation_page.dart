import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/colors.dart';
import '../../core/theme/text_styles.dart';
import '../providers/auth_provider.dart';
import 'community/community_feed_page.dart';
import 'gamification/gamification_page.dart';
import 'chat/chat_page.dart';
import 'journal/journal_page.dart';
import 'settings/settings_page.dart';

class MainNavigationPage extends ConsumerStatefulWidget {
  const MainNavigationPage({Key? key}) : super(key: key);

  @override
  ConsumerState<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends ConsumerState<MainNavigationPage> {
  int _selectedIndex = 0;

  static final List<Widget> _screens = [
    const CommunityFeedPage(),
    const GamificationPage(),
    const ChatPage(),
    const JournalPage(),
    const SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserProvider);

    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _screens),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(
                  index: 0,
                  icon: Icons.people_outline,
                  selectedIcon: Icons.people,
                  label: 'Community',
                ),
                _buildNavItem(
                  index: 1,
                  icon: Icons.emoji_events_outlined,
                  selectedIcon: Icons.emoji_events,
                  label: 'Progress',
                ),
                _buildNavItem(
                  index: 2,
                  icon:
                      currentUser?.role == 'admin'
                          ? Icons.admin_panel_settings_outlined
                          : Icons.chat_bubble_outline,
                  selectedIcon:
                      currentUser?.role == 'admin'
                          ? Icons.admin_panel_settings
                          : Icons.chat_bubble,
                  label: currentUser?.role == 'admin' ? 'Admin' : 'Chat',
                ),
                _buildNavItem(
                  index: 3,
                  icon: Icons.book_outlined,
                  selectedIcon: Icons.book,
                  label: 'Journal',
                ),
                _buildNavItem(
                  index: 4,
                  icon: Icons.settings_outlined,
                  selectedIcon: Icons.settings,
                  label: 'Settings',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required IconData selectedIcon,
    required String label,
  }) {
    final isSelected = _selectedIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? MindSpaceColors.primaryBlue.withOpacity(0.1)
                  : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Icon(
                isSelected ? selectedIcon : icon,
                key: ValueKey(isSelected),
                color:
                    isSelected
                        ? MindSpaceColors.primaryBlue
                        : MindSpaceColors.textLight,
                size: 24,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: AppTextStyles.caption.copyWith(
                color:
                    isSelected
                        ? MindSpaceColors.primaryBlue
                        : MindSpaceColors.textLight,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
