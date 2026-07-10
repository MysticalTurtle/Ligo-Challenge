/// API constants and endpoints
class ApiConstants {
  ApiConstants._();

  // Base URLs per environment
  static const String developmentBaseUrl = 'https://dev-api.example.com';
  static const String stagingBaseUrl = 'https://staging-api.example.com';
  static const String productionBaseUrl = 'https://api.example.com';

  // Auth endpoints
  static const String loginEndpoint = '/auth/login';
  static const String refreshTokenEndpoint = '/auth/refresh';

  // Movements endpoints
  static const String movementsEndpoint = '/movements';
  static String movementDetailEndpoint(String id) => '/movements/$id';

  // Timeouts
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);
}
