import 'package:ligo_challenge/core/utils/result.dart';
import 'package:ligo_challenge/features/auth/domain/entities/user.dart';

/// Authentication repository interface
abstract class AuthRepository {
  /// Login with username and password
  Future<Result<User>> login(String user, String password);

  /// Logout current user
  Future<void> logout();

  /// Get access token
  Future<String?> getAccessToken();

  /// Get refresh token
  Future<String?> getRefreshToken();

  /// Check if user is authenticated
  Future<bool> isAuthenticated();
}
