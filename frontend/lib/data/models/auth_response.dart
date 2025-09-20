import 'user.dart';

class AuthTokens {
  final String accessToken;
  final String refreshToken;

  const AuthTokens({required this.accessToken, required this.refreshToken});

  factory AuthTokens.fromJson(Map<String, dynamic> json) {
    return AuthTokens(
      accessToken: json['accessToken'] ?? '',
      refreshToken: json['refreshToken'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'accessToken': accessToken, 'refreshToken': refreshToken};
  }
}

class AuthResponse {
  final bool success;
  final String message;
  final User? user;
  final AuthTokens? tokens;
  final String? error;

  const AuthResponse({
    required this.success,
    required this.message,
    this.user,
    this.tokens,
    this.error,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      tokens:
          json['tokens'] != null ? AuthTokens.fromJson(json['tokens']) : null,
      error: json['error'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      if (user != null) 'user': user!.toJson(),
      if (tokens != null) 'tokens': tokens!.toJson(),
      if (error != null) 'error': error,
    };
  }

  @override
  String toString() {
    return 'AuthResponse(success: $success, message: $message, user: $user, hasTokens: ${tokens != null})';
  }
}
