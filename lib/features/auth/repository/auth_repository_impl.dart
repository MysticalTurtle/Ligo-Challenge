import 'package:ligo_challenge/core/network/api_exception.dart';
import 'package:ligo_challenge/core/storage/token_storage.dart';
import 'package:ligo_challenge/core/utils/result.dart';
import 'package:ligo_challenge/features/auth/data/datasources/auth_remote_ds.dart';
import 'package:ligo_challenge/features/auth/data/models/login_request.dart';
import 'package:ligo_challenge/features/auth/domain/entities/user.dart';
import 'package:ligo_challenge/features/auth/domain/repositories/auth_repository.dart';

/// Auth repository implementation
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required this.datasource,
    required this.tokenStorage,
  });

  final AuthRemoteDS datasource;
  final TokenStorage tokenStorage;

  @override
  Future<Result<User>> login(String user, String password) async {
    try {
      final request = LoginRequest(user: user, password: password);
      final response = await datasource.login(request);

      // Save tokens to secure storage
      await tokenStorage.saveAccessToken(response.token);
      // In a real app, refresh token would be different
      await tokenStorage.saveRefreshToken(response.token);

      return Success(response.user);
    } catch (e) {
      if (e is ApiException) {
        return Failure(e.message, e);
      }
      return Failure('Login failed. Please try again.', Exception(e));
    }
  }

  @override
  Future<void> logout() async {
    await tokenStorage.clearTokens();
  }

  @override
  Future<String?> getAccessToken() async {
    return tokenStorage.getAccessToken();
  }

  @override
  Future<String?> getRefreshToken() async {
    return tokenStorage.getRefreshToken();
  }

  @override
  Future<bool> isAuthenticated() async {
    return tokenStorage.hasTokens();
  }
}
