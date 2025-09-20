class ApiConfig {
  // Change this to match your backend URL and port
  // Default port for Node.js/Express apps is usually 3000
  // Update this based on your .env file's PORT setting
  static const String baseUrl = 'http://localhost:3000';

  // API endpoints
  static const String authEndpoint = '/auth';

  // Full auth URLs
  static const String loginUrl = '$baseUrl$authEndpoint/login';
  static const String registerUrl = '$baseUrl$authEndpoint/register';
  static const String refreshTokenUrl = '$baseUrl$authEndpoint/refresh-token';

  // Request timeout
  static const Duration timeout = Duration(seconds: 30);
}
