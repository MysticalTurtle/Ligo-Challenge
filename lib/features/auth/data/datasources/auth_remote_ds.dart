import 'package:ligo_challenge/features/auth/data/models/login_request.dart';
import 'package:ligo_challenge/features/auth/data/models/login_response.dart';

abstract class AuthRemoteDS {
  Future<LoginResponse> login(LoginRequest request);
  Future<void> logout();
}
