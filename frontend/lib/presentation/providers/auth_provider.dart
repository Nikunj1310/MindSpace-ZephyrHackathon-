import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/user.dart';
import '../../data/models/auth_response.dart';
import '../../data/repositories/auth_repository.dart';

/// Authentication state enum
enum AuthStatus { initial, loading, authenticated, unauthenticated, error }

/// Authentication state class
class AuthState {
  final AuthStatus status;
  final User? user;
  final String? errorMessage;

  const AuthState({
    this.status = AuthStatus.initial,
    this.user,
    this.errorMessage,
  });

  AuthState copyWith({AuthStatus? status, User? user, String? errorMessage}) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  String toString() {
    return 'AuthState(status: $status, user: $user, errorMessage: $errorMessage)';
  }

  bool get isAuthenticated => status == AuthStatus.authenticated;
  bool get isLoading => status == AuthStatus.loading;
  bool get hasError => status == AuthStatus.error;
}

/// Authentication provider using Riverpod StateNotifier
class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _authRepository;

  AuthNotifier(this._authRepository) : super(const AuthState());

  /// Initialize authentication state on app start
  Future<void> initializeAuth() async {
    await _authRepository.initializeAuth();
    final isLoggedIn = await _authRepository.isLoggedIn();

    if (isLoggedIn) {
      final user = await _authRepository.getUser();
      if (user != null) {
        state = state.copyWith(status: AuthStatus.authenticated, user: user);
      } else {
        // Clear invalid auth state
        await _authRepository.logout();
        state = state.copyWith(status: AuthStatus.unauthenticated);
      }
    } else {
      state = state.copyWith(status: AuthStatus.unauthenticated);
    }
  }

  /// Login user
  Future<AuthResponse> login(String userName, String password) async {
    state = state.copyWith(status: AuthStatus.loading);

    try {
      final response = await _authRepository.login(userName, password);

      if (response.success && response.user != null) {
        state = state.copyWith(
          status: AuthStatus.authenticated,
          user: response.user,
          errorMessage: null,
        );
      } else {
        state = state.copyWith(
          status: AuthStatus.error,
          errorMessage: response.message,
        );
      }

      return response;
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: e.toString(),
      );

      return AuthResponse(
        success: false,
        message: 'An unexpected error occurred',
        error: e.toString(),
      );
    }
  }

  /// Register user
  Future<AuthResponse> register({
    required String userName,
    required String fullName,
    required String email,
    required String password,
    int currentMood = 5,
    String emoji = "😐",
    String role = 'user',
  }) async {
    state = state.copyWith(status: AuthStatus.loading);

    try {
      final response = await _authRepository.register(
        userName: userName,
        fullName: fullName,
        email: email,
        password: password,
        currentMood: currentMood,
        emoji: emoji,
        role: role,
      );

      if (response.success && response.user != null) {
        state = state.copyWith(
          status: AuthStatus.authenticated,
          user: response.user,
          errorMessage: null,
        );
      } else {
        state = state.copyWith(
          status: AuthStatus.error,
          errorMessage: response.message,
        );
      }

      return response;
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: e.toString(),
      );

      return AuthResponse(
        success: false,
        message: 'An unexpected error occurred',
        error: e.toString(),
      );
    }
  }

  /// Logout user
  Future<void> logout() async {
    state = state.copyWith(status: AuthStatus.loading);

    await _authRepository.logout();

    state = state.copyWith(
      status: AuthStatus.unauthenticated,
      user: null,
      errorMessage: null,
    );
  }

  /// Refresh authentication tokens
  Future<bool> refreshToken() async {
    try {
      final response = await _authRepository.refreshToken();
      return response.success;
    } catch (e) {
      return false;
    }
  }

  /// Clear error message
  void clearError() {
    if (state.hasError) {
      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        errorMessage: null,
      );
    }
  }

  /// Update user data
  void updateUser(User user) {
    state = state.copyWith(user: user);
  }
}

/// AuthRepository provider
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});

/// AuthNotifier provider
final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>((
  ref,
) {
  final authRepository = ref.watch(authRepositoryProvider);
  return AuthNotifier(authRepository);
});

/// Convenience providers for common auth state checks
final isAuthenticatedProvider = Provider<bool>((ref) {
  final authState = ref.watch(authNotifierProvider);
  return authState.isAuthenticated;
});

final currentUserProvider = Provider<User?>((ref) {
  final authState = ref.watch(authNotifierProvider);
  return authState.user;
});

final authStatusProvider = Provider<AuthStatus>((ref) {
  final authState = ref.watch(authNotifierProvider);
  return authState.status;
});

final authErrorProvider = Provider<String?>((ref) {
  final authState = ref.watch(authNotifierProvider);
  return authState.errorMessage;
});
