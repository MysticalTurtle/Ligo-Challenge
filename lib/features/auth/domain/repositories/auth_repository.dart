import 'package:ligo_challenge/core/utils/result.dart';
import 'package:ligo_challenge/features/auth/domain/entities/user.dart';

abstract class AuthRepository {
  Future<Result<User>> login(String user, String password);

  Future<void> logout();

  Future<String?> getAccessToken();

  Future<bool> isAuthenticated();
}
