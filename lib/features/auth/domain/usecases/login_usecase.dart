import 'package:ligo_challenge/core/utils/result.dart';
import 'package:ligo_challenge/features/auth/domain/entities/user.dart';
import 'package:ligo_challenge/features/auth/domain/repositories/auth_repository.dart';

/// Use case for user login
class LoginUsecase {
  LoginUsecase({required this._authRepository});

  final AuthRepository _authRepository;

  /// Execute login
  ///
  /// Takes [username] and [password] and attempts to authenticate the user.
  /// Returns [Result<User>] with user data on success or error message on failure.
  Future<Result<User>> call({
    required String username,
    required String password,
  }) async {
    // Validate input
    if (username.trim().isEmpty || password.trim().isEmpty) {
      return const Failure('Please enter both username and password');
    }

    // Call repository to perform login
    return _authRepository.login(username, password);
  }
}
