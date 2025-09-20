import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/routes.dart';
import '../../core/theme/text_styles.dart';
import '../../data/models/user.dart';
import '../providers/auth_provider.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  String selectedSection = 'community';

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(-0.3, 0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isLargeScreen = mediaQuery.size.width > 800;
    final authState = ref.watch(authNotifierProvider);
    final user = authState.user;
    final isAdmin = user?.role == 'admin';

    return Scaffold(
      body: Row(
        children: [
          // Sidebar
          SlideTransition(
            position: _slideAnimation,
            child: _buildSidebar(mediaQuery, isAdmin),
          ),
          // Main content area
          Expanded(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: _buildMainContent(isLargeScreen, user),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebar(MediaQueryData mediaQuery, bool isAdmin) {
    final sidebarWidth = mediaQuery.size.width > 800 ? 280.0 : 240.0;

    return Container(
      width: sidebarWidth,
      height: mediaQuery.size.height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            MindSpaceColors.primaryBlue.withOpacity(0.9),
            MindSpaceColors.primaryBlue.withOpacity(0.7),
            MindSpaceColors.softLavender.withOpacity(0.8),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(2, 0),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          children: [
            // App Logo/Brand
            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.psychology,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'MindSpace',
                    style: AppTextStyles.h3.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(color: Colors.white24, thickness: 1),
            // Navigation Items
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Column(
                  children: [
                    _buildNavItem(
                      icon: Icons.people,
                      label: 'Community Feed',
                      key: 'community',
                      onTap: () => _handleNavigation('community'),
                    ),
                    _buildNavItem(
                      icon: Icons.emoji_events,
                      label: 'Gamification',
                      key: 'gamification',
                      onTap: () => _handleNavigation('gamification'),
                    ),
                    _buildNavItem(
                      icon: Icons.chat,
                      label: 'One-to-One Chat',
                      key: 'chat',
                      onTap: () => _handleNavigation('chat'),
                    ),
                    if (isAdmin)
                      _buildNavItem(
                        icon: Icons.admin_panel_settings,
                        label: 'Admin Panel',
                        key: 'admin',
                        onTap: () => _handleNavigation('admin'),
                      ),
                    _buildNavItem(
                      icon: Icons.book,
                      label: 'Journals & Notes',
                      key: 'journal',
                      onTap: () => _handleNavigation('journal'),
                    ),
                    _buildNavItem(
                      icon: Icons.settings,
                      label: 'User Settings',
                      key: 'settings',
                      onTap: () => _handleNavigation('settings'),
                    ),
                  ],
                ),
              ),
            ),
            // Logout Button
            Padding(
              padding: const EdgeInsets.all(24),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _handleLogout,
                  icon: const Icon(Icons.logout, size: 18),
                  label: const Text('Sign Out'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white.withOpacity(0.2),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required String key,
    required VoidCallback onTap,
  }) {
    final isSelected = selectedSection == key;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color:
                  isSelected
                      ? Colors.white.withOpacity(0.2)
                      : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(icon, color: Colors.white, size: 22),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    label,
                    style: AppTextStyles.body2.copyWith(
                      color: Colors.white,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMainContent(bool isLargeScreen, User? user) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(
            'https://user-gen-media-assets.s3.amazonaws.com/gemini_images/163b47d2-831f-4008-816a-9e2e4e45a857.png',
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white.withOpacity(0.85),
              Colors.white.withOpacity(0.75),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile Section
                _buildProfileSection(user),
                const SizedBox(height: 40),
                // Welcome Message
                _buildWelcomeSection(),
                const SizedBox(height: 40),
                // Quick Stats or Content
                Expanded(child: _buildContentArea()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileSection(User? user) {
    final userName = user?.fullName ?? user?.userName ?? "Anonymous User";
    final userEmail = user?.email ?? "user@mindspace.com";
    final isActiveUser = user != null;
    final streakCount = user?.streakCount ?? 0;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          // Profile Picture
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [MindSpaceColors.primaryBlue, MindSpaceColors.calmMint],
              ),
              borderRadius: BorderRadius.circular(40),
              border: Border.all(color: Colors.white, width: 3),
            ),
            child: Center(
              child:
                  user?.emoji != null
                      ? Text(user!.emoji, style: const TextStyle(fontSize: 32))
                      : const Icon(Icons.person, color: Colors.white, size: 40),
            ),
          ),
          const SizedBox(width: 20),
          // User Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userName,
                  style: AppTextStyles.h3.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Text(
                  userEmail,
                  style: AppTextStyles.body2.copyWith(
                    color: MindSpaceColors.textLight,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color:
                            isActiveUser
                                ? MindSpaceColors.successGreen.withOpacity(0.2)
                                : MindSpaceColors.textLight.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        isActiveUser ? 'Active Member' : 'Guest User',
                        style: AppTextStyles.caption.copyWith(
                          color:
                              isActiveUser
                                  ? MindSpaceColors.successGreen
                                  : MindSpaceColors.textLight,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    if (streakCount > 0) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: MindSpaceColors.warningAmber.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.local_fire_department,
                              size: 16,
                              color: MindSpaceColors.warningAmber,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '$streakCount day streak',
                              style: AppTextStyles.caption.copyWith(
                                color: MindSpaceColors.warningAmber,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: MindSpaceColors.primaryBlue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: MindSpaceColors.primaryBlue.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome back to your safe space',
            style: AppTextStyles.h3.copyWith(
              color: MindSpaceColors.primaryBlue,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Take a moment to reflect, connect, and grow. Your mental wellness journey continues here.',
            style: AppTextStyles.body1.copyWith(
              color: MindSpaceColors.textDark,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentArea() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Actions',
            style: AppTextStyles.h4.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.5,
              children: [
                _buildQuickActionCard(
                  icon: Icons.edit_note,
                  title: 'New Journal Entry',
                  subtitle: 'Capture your thoughts',
                  color: MindSpaceColors.calmMint,
                  onTap: () => _handleNavigation('journal'),
                ),
                _buildQuickActionCard(
                  icon: Icons.people_outline,
                  title: 'Community',
                  subtitle: 'Connect with others',
                  color: MindSpaceColors.primaryBlue,
                  onTap: () => _handleNavigation('community'),
                ),
                _buildQuickActionCard(
                  icon: Icons.chat_bubble_outline,
                  title: 'Start Chat',
                  subtitle: 'Talk to someone',
                  color: MindSpaceColors.softLavender,
                  onTap: () => _handleNavigation('chat'),
                ),
                _buildQuickActionCard(
                  icon: Icons.emoji_events_outlined,
                  title: 'View Progress',
                  subtitle: 'Track your journey',
                  color: MindSpaceColors.warningAmber,
                  onTap: () => _handleNavigation('gamification'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withOpacity(0.3)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 32),
              const SizedBox(height: 8),
              Text(
                title,
                style: AppTextStyles.body2.copyWith(
                  fontWeight: FontWeight.w600,
                  color: MindSpaceColors.textDark,
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                subtitle,
                style: AppTextStyles.caption.copyWith(
                  color: MindSpaceColors.textLight,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleNavigation(String section) {
    setState(() {
      selectedSection = section;
    });

    // Navigate to specific pages
    switch (section) {
      case 'community':
        Navigator.pushNamed(context, AppRoutes.community);
        break;
      case 'gamification':
        Navigator.pushNamed(context, AppRoutes.gamification);
        break;
      case 'chat':
        Navigator.pushNamed(context, AppRoutes.chat);
        break;
      case 'journal':
        Navigator.pushNamed(context, AppRoutes.journal);
        break;
      case 'settings':
        Navigator.pushNamed(context, AppRoutes.settings);
        break;
      case 'admin':
        Navigator.pushNamed(context, AppRoutes.admin);
        break;
      default:
        print('Unknown section: $section');
    }
  }

  void _handleLogout() {
    // Show confirmation dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Sign Out'),
          content: const Text('Are you sure you want to sign out?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                // Clear user session/tokens using auth provider
                await ref.read(authNotifierProvider.notifier).logout();
                if (mounted) {
                  Navigator.pushReplacementNamed(context, AppRoutes.login);
                }
              },
              child: const Text('Sign Out'),
            ),
          ],
        );
      },
    );
  }
}
