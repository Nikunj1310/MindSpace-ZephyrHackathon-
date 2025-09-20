import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/colors.dart';
import '../../../core/theme/text_styles.dart';
import '../../providers/auth_provider.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;
  bool _biometricEnabled = false;
  double _reminderFrequency = 2.0; // Times per day

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserProvider);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.white,
        foregroundColor: MindSpaceColors.textDark,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileSection(currentUser),
            const SizedBox(height: 24),
            _buildNotificationSettings(),
            const SizedBox(height: 24),
            _buildAppearanceSettings(),
            const SizedBox(height: 24),
            _buildPrivacySettings(),
            const SizedBox(height: 24),
            _buildWellnessSettings(),
            const SizedBox(height: 24),
            _buildAboutSection(),
            const SizedBox(height: 24),
            _buildDangerZone(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSection(user) {
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
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      MindSpaceColors.primaryBlue,
                      MindSpaceColors.primaryBlue.withOpacity(0.8),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _getRoleIcon(user?.role ?? 'user'),
                  color: Colors.white,
                  size: 30,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user?.name ?? 'User Name',
                      style: AppTextStyles.h3.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: _getRoleColor(
                              user?.role ?? 'user',
                            ).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            user?.role?.toUpperCase() ?? 'USER',
                            style: AppTextStyles.caption.copyWith(
                              color: _getRoleColor(user?.role ?? 'user'),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user?.email ?? 'user@example.com',
                      style: AppTextStyles.body2.copyWith(
                        color: MindSpaceColors.textLight,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: _editProfile,
                icon: const Icon(Icons.edit_outlined),
                color: MindSpaceColors.primaryBlue,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: MindSpaceColors.primaryBlue.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(Icons.favorite, color: Colors.red, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Wellness Score: 85/100',
                  style: AppTextStyles.body2.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                Text(
                  'Great!',
                  style: AppTextStyles.body2.copyWith(
                    color: Colors.green,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationSettings() {
    return _buildSettingsSection(
      title: 'Notifications',
      icon: Icons.notifications_outlined,
      children: [
        _buildSwitchTile(
          title: 'Push Notifications',
          subtitle: 'Receive wellness reminders and updates',
          value: _notificationsEnabled,
          onChanged: (value) {
            setState(() {
              _notificationsEnabled = value;
            });
          },
        ),
        _buildSliderTile(
          title: 'Daily Reminders',
          subtitle: '${_reminderFrequency.round()} times per day',
          value: _reminderFrequency,
          min: 1.0,
          max: 5.0,
          onChanged:
              _notificationsEnabled
                  ? (value) {
                    setState(() {
                      _reminderFrequency = value;
                    });
                  }
                  : null,
        ),
        _buildTile(
          title: 'Notification Schedule',
          subtitle: 'Customize when you receive reminders',
          trailing: const Icon(Icons.schedule),
          onTap: _showScheduleSettings,
        ),
      ],
    );
  }

  Widget _buildAppearanceSettings() {
    return _buildSettingsSection(
      title: 'Appearance',
      icon: Icons.palette_outlined,
      children: [
        _buildSwitchTile(
          title: 'Dark Mode',
          subtitle: 'Use dark theme for better night viewing',
          value: _darkModeEnabled,
          onChanged: (value) {
            setState(() {
              _darkModeEnabled = value;
            });
          },
        ),
        _buildTile(
          title: 'Font Size',
          subtitle: 'Medium',
          trailing: const Icon(Icons.text_fields),
          onTap: _showFontSizeSettings,
        ),
        _buildTile(
          title: 'Color Theme',
          subtitle: 'Calming Blue',
          trailing: Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: MindSpaceColors.primaryBlue,
              shape: BoxShape.circle,
            ),
          ),
          onTap: _showThemeSettings,
        ),
      ],
    );
  }

  Widget _buildPrivacySettings() {
    return _buildSettingsSection(
      title: 'Privacy & Security',
      icon: Icons.security_outlined,
      children: [
        _buildSwitchTile(
          title: 'Biometric Authentication',
          subtitle: 'Use fingerprint or face ID to unlock',
          value: _biometricEnabled,
          onChanged: (value) {
            setState(() {
              _biometricEnabled = value;
            });
          },
        ),
        _buildTile(
          title: 'Change Password',
          subtitle: 'Update your account password',
          trailing: const Icon(Icons.lock_outline),
          onTap: _changePassword,
        ),
        _buildTile(
          title: 'Data Export',
          subtitle: 'Download your journal entries and data',
          trailing: const Icon(Icons.download_outlined),
          onTap: _exportData,
        ),
        _buildTile(
          title: 'Privacy Policy',
          subtitle: 'Learn how we protect your data',
          trailing: const Icon(Icons.policy_outlined),
          onTap: _showPrivacyPolicy,
        ),
      ],
    );
  }

  Widget _buildWellnessSettings() {
    return _buildSettingsSection(
      title: 'Wellness Preferences',
      icon: Icons.self_improvement_outlined,
      children: [
        _buildTile(
          title: 'Mood Check-in Frequency',
          subtitle: 'How often to prompt for mood updates',
          trailing: const Text('2x daily'),
          onTap: _showMoodSettings,
        ),
        _buildTile(
          title: 'Crisis Resources',
          subtitle: 'Emergency contacts and helplines',
          trailing: const Icon(Icons.emergency_outlined),
          onTap: _showCrisisResources,
        ),
        _buildTile(
          title: 'Wellness Goals',
          subtitle: 'Set and track your mental health goals',
          trailing: const Icon(Icons.flag_outlined),
          onTap: _showWellnessGoals,
        ),
        _buildTile(
          title: 'Meditation Timer',
          subtitle: 'Customize meditation and breathing exercises',
          trailing: const Icon(Icons.timer_outlined),
          onTap: _showMeditationSettings,
        ),
      ],
    );
  }

  Widget _buildAboutSection() {
    return _buildSettingsSection(
      title: 'About',
      icon: Icons.info_outlined,
      children: [
        _buildTile(
          title: 'App Version',
          subtitle: '1.0.0 (Beta)',
          trailing: const Icon(Icons.info_outline),
          onTap: null,
        ),
        _buildTile(
          title: 'Terms of Service',
          subtitle: 'View our terms and conditions',
          trailing: const Icon(Icons.description_outlined),
          onTap: _showTermsOfService,
        ),
        _buildTile(
          title: 'Contact Support',
          subtitle: 'Get help with the app',
          trailing: const Icon(Icons.support_agent_outlined),
          onTap: _contactSupport,
        ),
        _buildTile(
          title: 'Rate MindSpace',
          subtitle: 'Help us improve with your feedback',
          trailing: const Icon(Icons.star_outline),
          onTap: _rateApp,
        ),
      ],
    );
  }

  Widget _buildDangerZone() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.red.withOpacity(0.3)),
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
          Row(
            children: [
              Icon(Icons.warning_outlined, color: Colors.red, size: 20),
              const SizedBox(width: 8),
              Text(
                'Danger Zone',
                style: AppTextStyles.h3.copyWith(
                  color: Colors.red,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildTile(
            title: 'Delete All Data',
            subtitle: 'Permanently remove all your entries and data',
            trailing: const Icon(
              Icons.delete_forever_outlined,
              color: Colors.red,
            ),
            onTap: _deleteAllData,
            textColor: Colors.red,
          ),
          const SizedBox(height: 8),
          _buildTile(
            title: 'Delete Account',
            subtitle: 'Permanently delete your MindSpace account',
            trailing: const Icon(
              Icons.person_remove_outlined,
              color: Colors.red,
            ),
            onTap: _deleteAccount,
            textColor: Colors.red,
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: _logout,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              minimumSize: const Size(double.infinity, 48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Logout',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
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
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: MindSpaceColors.primaryBlue.withOpacity(0.05),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Icon(icon, color: MindSpaceColors.primaryBlue, size: 20),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: AppTextStyles.h3.copyWith(
                    fontWeight: FontWeight.w600,
                    color: MindSpaceColors.primaryBlue,
                  ),
                ),
              ],
            ),
          ),
          ...children,
        ],
      ),
    );
  }

  Widget _buildTile({
    required String title,
    required String subtitle,
    required Widget trailing,
    required VoidCallback? onTap,
    Color? textColor,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.body1.copyWith(
                        fontWeight: FontWeight.w500,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: AppTextStyles.body2.copyWith(
                        color: MindSpaceColors.textLight,
                      ),
                    ),
                  ],
                ),
              ),
              trailing,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.body1.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: AppTextStyles.body2.copyWith(
                    color: MindSpaceColors.textLight,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: MindSpaceColors.primaryBlue,
          ),
        ],
      ),
    );
  }

  Widget _buildSliderTile({
    required String title,
    required String subtitle,
    required double value,
    required double min,
    required double max,
    required ValueChanged<double>? onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.body1.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: AppTextStyles.body2.copyWith(
                        color: MindSpaceColors.textLight,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Slider(
            value: value,
            min: min,
            max: max,
            divisions: (max - min).round(),
            onChanged: onChanged,
            activeColor: MindSpaceColors.primaryBlue,
          ),
        ],
      ),
    );
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

  void _editProfile() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profile editing coming soon!'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showScheduleSettings() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Notification Schedule'),
            content: const Text(
              'Customize when you want to receive wellness reminders throughout the day.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Save'),
              ),
            ],
          ),
    );
  }

  void _showFontSizeSettings() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Font size settings coming soon!'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showThemeSettings() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Theme customization coming soon!'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _changePassword() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Password change coming soon!'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _exportData() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Data export feature coming soon!'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showPrivacyPolicy() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Privacy policy viewer coming soon!'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showMoodSettings() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Mood settings coming soon!'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showCrisisResources() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Crisis Resources'),
            content: const Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Emergency Hotlines:'),
                SizedBox(height: 8),
                Text('• National Suicide Prevention Lifeline: 988'),
                Text('• Crisis Text Line: Text HOME to 741741'),
                Text('• SAMHSA National Helpline: 1-800-662-HELP'),
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

  void _showWellnessGoals() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Wellness goals coming soon!'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showMeditationSettings() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Meditation settings coming soon!'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showTermsOfService() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Terms of service viewer coming soon!'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _contactSupport() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Support contact coming soon!'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _rateApp() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('App rating coming soon!'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _deleteAllData() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Delete All Data'),
            content: const Text(
              'This will permanently delete all your journal entries, mood data, and other personal information. This action cannot be undone.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Data deletion feature coming soon!'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text(
                  'Delete',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
    );
  }

  void _deleteAccount() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Delete Account'),
            content: const Text(
              'This will permanently delete your MindSpace account and all associated data. This action cannot be undone.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Account deletion feature coming soon!'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text(
                  'Delete Account',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
    );
  }

  void _logout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Logout'),
            content: const Text('Are you sure you want to logout?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Logout'),
              ),
            ],
          ),
    );

    if (confirmed == true) {
      await ref.read(authNotifierProvider.notifier).logout();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Successfully logged out'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}
