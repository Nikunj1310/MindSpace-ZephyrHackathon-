import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'core/constants/routes.dart';
import 'presentation/pages/auth/login_page.dart';
import 'presentation/pages/auth/signup_page.dart';
import 'presentation/pages/main_navigation_page.dart';
import 'presentation/pages/home_page.dart';
import 'presentation/pages/community/community_feed_page.dart';
import 'presentation/pages/gamification/gamification_page.dart';
import 'presentation/pages/chat/chat_page.dart';
import 'presentation/pages/journal/journal_page.dart';
import 'presentation/pages/settings/settings_page.dart';
import 'presentation/widgets/auth_wrapper.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: MindSpaceApp()));
}

class MindSpaceApp extends StatelessWidget {
  const MindSpaceApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MindSpace - Mental Wellness Platform',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      home: const AuthWrapper(),
      routes: {
        AppRoutes.login: (context) => const LoginPage(),
        AppRoutes.signup: (context) => const SignupPage(),
        AppRoutes.home: (context) => const HomePage(),
        AppRoutes.dashboard: (context) => const MainNavigationPage(),
        AppRoutes.community: (context) => const CommunityFeedPage(),
        AppRoutes.gamification: (context) => const GamificationPage(),
        AppRoutes.chat: (context) => const ChatPage(),
        AppRoutes.journal: (context) => const JournalPage(),
        AppRoutes.settings: (context) => const SettingsPage(),
        AppRoutes.admin:
            (context) =>
                const ChatPage(), // Admin panel uses chat page with admin features
      },
    );
  }
}
