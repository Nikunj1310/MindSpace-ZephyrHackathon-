import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../pages/auth/login_page.dart';
import '../pages/main_navigation_page.dart';
import '../providers/auth_provider.dart';

class AuthWrapper extends ConsumerStatefulWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  ConsumerState<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends ConsumerState<AuthWrapper> {
  @override
  void initState() {
    super.initState();
    // Initialize auth state when the app starts
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(authNotifierProvider.notifier).initializeAuth();
    });
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    final authStatus = authState.status;

    switch (authStatus) {
      case AuthStatus.initial:
      case AuthStatus.loading:
        return const Scaffold(body: Center(child: CircularProgressIndicator()));

      case AuthStatus.authenticated:
        return const MainNavigationPage();

      case AuthStatus.unauthenticated:
      case AuthStatus.error:
        return const LoginPage();
    }
  }
}
