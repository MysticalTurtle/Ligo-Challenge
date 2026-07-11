import 'package:ligo_challenge/core/utils/result.dart';
import 'package:ligo_challenge/features/auth/domain/entities/user.dart';
import 'package:ligo_challenge/features/auth/domain/repositories/auth_repository.dart';

class LoginUsecase {
  LoginUsecase({required this._authRepository});

  final AuthRepository _authRepository;

  Future<Result<User>> call({
    required String username,
    required String password,
  }) async {
    if (username.trim().isEmpty || password.trim().isEmpty) {
      return const Failure('Please enter both username and password');
    }

    return _authRepository.login(username, password);
  }
}
