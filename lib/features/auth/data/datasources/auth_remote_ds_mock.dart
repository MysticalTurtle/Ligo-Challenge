import 'package:dio/dio.dart';
import 'package:ligo_challenge/core/network/api_exception.dart';
import 'package:ligo_challenge/features/auth/data/datasources/auth_remote_ds.dart';
import 'package:ligo_challenge/features/auth/data/models/login_request.dart';
import 'package:ligo_challenge/features/auth/data/models/login_response.dart';

class AuthRemoteDSMock implements AuthRemoteDS {
  AuthRemoteDSMock({required this.dio});

  final Dio dio;

  @override
  Future<LoginResponse> login(LoginRequest request) async {
    await Future<void>.delayed(const Duration(seconds: 1));

    if (request.user != '12345678' || request.password != 'admin') {
      throw ApiException(
        message:
            'Credenciales inválidas. Por favor, '
            'verifica tu usuario y contraseña.',
      );
    }

    final mockResponse = {
      'token': 'mock-jwt-token-abc123',
      'user': {
        'id': 'u_001',
        'name': 'Ronald Castillo',
      },
    };

    return LoginResponse.fromJson(mockResponse);
  }

  @override
  Future<void> logout() async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
  }
}
