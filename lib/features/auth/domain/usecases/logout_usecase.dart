import 'package:ligo_challenge/features/auth/domain/repositories/auth_repository.dart';

/// Use case for user logout
class LogoutUsecase {
  LogoutUsecase({required this._authRepository});

  final AuthRepository _authRepository;

  /// Execute logout
  ///
  /// Logs out the current user and clears stored tokens.
  Future<void> call() async {
    await _authRepository.logout();
  }
}
