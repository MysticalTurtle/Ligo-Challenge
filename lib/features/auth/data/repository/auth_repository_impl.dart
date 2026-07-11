import 'dart:io';

import 'package:ligo_challenge/core/network/api_exception.dart';
import 'package:ligo_challenge/core/network/connectivity/internet_connectivity.dart';
import 'package:ligo_challenge/core/storage/token_storage.dart';
import 'package:ligo_challenge/core/utils/result.dart';
import 'package:ligo_challenge/features/auth/data/datasources/auth_remote_ds.dart';
import 'package:ligo_challenge/features/auth/data/models/login_request.dart';
import 'package:ligo_challenge/features/auth/domain/entities/user.dart';
import 'package:ligo_challenge/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required this.datasource,
    required this.tokenStorage,
    required this.internetConnectivity,
  });

  final AuthRemoteDS datasource;
  final TokenStorage tokenStorage;
  final InternetConnectivity internetConnectivity;

  @override
  Future<Result<User>> login(String user, String password) async {
    if (!await internetConnectivity.hasConnection()) {
      return const Failure(
        'No hay conexión a internet. Por favor, '
        'verifica tu red e inténtalo de nuevo.',
        SocketException('No internet connection'),
      );
    }

    try {
      final request = LoginRequest(user: user, password: password);
      final response = await datasource.login(request);

      await tokenStorage.saveAccessToken(response.token);

      return Success(response.user);
    } on Exception catch (e) {
      if (e is ApiException) {
        return Failure(e.message, e);
      }
      return Failure(
        'Ocurrió un error, Por favor inténtalo de nuevo.',
        Exception(e),
      );
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
  Future<bool> isAuthenticated() async {
    return tokenStorage.hasTokens();
  }
}
