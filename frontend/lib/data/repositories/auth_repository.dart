import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../models/auth_response.dart';
import '../models/login_request.dart';
import '../models/register_request.dart';
import '../services/auth_service.dart';

class AuthRepository {
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _userKey = 'user_data';
  static const String _isLoggedInKey = 'is_logged_in';

  /// Login user and store tokens locally
  Future<AuthResponse> login(String userName, String password) async {
    final loginRequest = LoginRequest(userName: userName, password: password);

    final response = await AuthService.login(loginRequest);

    if (response.success && response.tokens != null && response.user != null) {
      await _storeAuthData(
        accessToken: response.tokens!.accessToken,
        refreshToken: response.tokens!.refreshToken,
        user: response.user!,
      );
    }

    return response;
  }

  /// Register new user and store tokens locally
  Future<AuthResponse> register({
    required String userName,
    required String fullName,
    required String email,
    required String password,
    int currentMood = 5,
    String emoji = "😐",
    String role = 'user',
  }) async {
    final registerRequest = RegisterRequest(
      userName: userName,
      fullName: fullName,
      email: email,
      password: password,
      currentMood: currentMood,
      emoji: emoji,
      role: role,
    );

    final response = await AuthService.register(registerRequest);

    if (response.success && response.tokens != null && response.user != null) {
      await _storeAuthData(
        accessToken: response.tokens!.accessToken,
        refreshToken: response.tokens!.refreshToken,
        user: response.user!,
      );
    }

    return response;
  }

  /// Refresh access token
  Future<AuthResponse> refreshToken() async {
    final currentRefreshToken = await getRefreshToken();
    if (currentRefreshToken == null) {
      return const AuthResponse(
        success: false,
        message: 'No refresh token found',
        error: 'Authentication required',
      );
    }

    final response = await AuthService.refreshToken(currentRefreshToken);

    if (response.success && response.tokens != null) {
      await _storeTokens(
        accessToken: response.tokens!.accessToken,
        refreshToken: response.tokens!.refreshToken,
      );
    }

    return response;
  }

  /// Logout user and clear all stored data
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_accessTokenKey);
    await prefs.remove(_refreshTokenKey);
    await prefs.remove(_userKey);
    await prefs.setBool(_isLoggedInKey, false);
  }

  /// Get stored access token
  Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_accessTokenKey);
  }

  /// Get stored refresh token
  Future<String?> getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_refreshTokenKey);
  }

  /// Get stored user data
  Future<User?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_userKey);
    if (userJson != null) {
      try {
        final userMap = jsonDecode(userJson) as Map<String, dynamic>;
        return User.fromJson(userMap);
      } catch (e) {
        // If there's an error parsing user data, clear it
        await prefs.remove(_userKey);
        return null;
      }
    }
    return null;
  }

  /// Check if user is logged in
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }

  /// Check if user has valid authentication
  Future<bool> hasValidAuth() async {
    final accessToken = await getAccessToken();
    final refreshToken = await getRefreshToken();
    return accessToken != null && refreshToken != null;
  }

  /// Get user profile from server
  Future<AuthResponse> getUserProfile(String userId) async {
    final accessToken = await getAccessToken();
    if (accessToken == null) {
      return const AuthResponse(
        success: false,
        message: 'No access token found',
        error: 'Authentication required',
      );
    }

    return AuthService.getUserProfile(userId, accessToken);
  }

  /// Store authentication data locally
  Future<void> _storeAuthData({
    required String accessToken,
    required String refreshToken,
    required User user,
  }) async {
    await _storeTokens(accessToken: accessToken, refreshToken: refreshToken);
    await _storeUser(user);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLoggedInKey, true);
  }

  /// Store tokens locally
  Future<void> _storeTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_accessTokenKey, accessToken);
    await prefs.setString(_refreshTokenKey, refreshToken);
  }

  /// Store user data locally
  Future<void> _storeUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, jsonEncode(user.toJson()));
  }

  /// Initialize auth state (call this on app start)
  Future<void> initializeAuth() async {
    final hasAuth = await hasValidAuth();
    final prefs = await SharedPreferences.getInstance();

    if (!hasAuth) {
      await prefs.setBool(_isLoggedInKey, false);
    }
  }
}
