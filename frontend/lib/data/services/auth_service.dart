import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/constants/api_config.dart';
import '../models/auth_response.dart';
import '../models/login_request.dart';
import '../models/register_request.dart';

class AuthService {
  /// Login user with username and password
  static Future<AuthResponse> login(LoginRequest loginRequest) async {
    try {
      final url = Uri.parse(ApiConfig.loginUrl);

      final response = await http
          .post(
            url,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(loginRequest.toJson()),
          )
          .timeout(ApiConfig.timeout);

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return AuthResponse.fromJson(responseData);
      } else {
        return AuthResponse(
          success: false,
          message: responseData['message'] ?? 'Login failed',
          error: responseData['error'] ?? 'Unknown error',
        );
      }
    } catch (e) {
      return AuthResponse(
        success: false,
        message: 'Network error occurred',
        error: e.toString(),
      );
    }
  }

  /// Register new user
  static Future<AuthResponse> register(RegisterRequest registerRequest) async {
    try {
      final url = Uri.parse(ApiConfig.registerUrl);

      final response = await http
          .post(
            url,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(registerRequest.toJson()),
          )
          .timeout(ApiConfig.timeout);

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return AuthResponse.fromJson(responseData);
      } else {
        return AuthResponse(
          success: false,
          message: responseData['message'] ?? 'Registration failed',
          error: responseData['error'] ?? 'Unknown error',
        );
      }
    } catch (e) {
      return AuthResponse(
        success: false,
        message: 'Network error occurred',
        error: e.toString(),
      );
    }
  }

  /// Refresh access token using refresh token
  static Future<AuthResponse> refreshToken(String refreshToken) async {
    try {
      final url = Uri.parse(ApiConfig.refreshTokenUrl);

      final response = await http
          .post(
            url,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'refreshToken': refreshToken}),
          )
          .timeout(ApiConfig.timeout);

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return AuthResponse.fromJson(responseData);
      } else {
        return AuthResponse(
          success: false,
          message: responseData['message'] ?? 'Token refresh failed',
          error: responseData['error'] ?? 'Unknown error',
        );
      }
    } catch (e) {
      return AuthResponse(
        success: false,
        message: 'Network error occurred',
        error: e.toString(),
      );
    }
  }

  /// Get user profile by ID with authorization
  static Future<AuthResponse> getUserProfile(
    String userId,
    String accessToken,
  ) async {
    try {
      final url = Uri.parse(
        '${ApiConfig.baseUrl}${ApiConfig.authEndpoint}/profile/$userId',
      );

      final response = await http
          .get(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $accessToken',
            },
          )
          .timeout(ApiConfig.timeout);

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return AuthResponse.fromJson(responseData);
      } else {
        return AuthResponse(
          success: false,
          message: responseData['message'] ?? 'Failed to get user profile',
          error: responseData['error'] ?? 'Unknown error',
        );
      }
    } catch (e) {
      return AuthResponse(
        success: false,
        message: 'Network error occurred',
        error: e.toString(),
      );
    }
  }

  /// Check network connectivity by making a simple request
  static Future<bool> checkConnectivity() async {
    try {
      final url = Uri.parse('${ApiConfig.baseUrl}/health');
      final response = await http.get(url).timeout(const Duration(seconds: 5));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
