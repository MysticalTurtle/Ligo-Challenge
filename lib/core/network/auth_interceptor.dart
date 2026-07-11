import 'package:dio/dio.dart';
import 'package:ligo_challenge/core/constants/api_constants.dart';
import 'package:ligo_challenge/core/storage/token_storage.dart';

/// Interceptor for adding JWT token and handling token refresh
class AuthInterceptor extends Interceptor {
  AuthInterceptor({
    required this.tokenStorage,
    required this.dio,
  });

  final TokenStorage tokenStorage;
  final Dio dio;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Add access token to request header
    final accessToken = await tokenStorage.getAccessToken();
    if (accessToken != null && accessToken.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }

    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode == 401) {
      try {
        final refreshToken = await tokenStorage.getRefreshToken();
        if (refreshToken != null && refreshToken.isNotEmpty) {
          final newToken = await _refreshToken(refreshToken);

          if (newToken != null) {
            final options = err.requestOptions;
            options.headers['Authorization'] = 'Bearer $newToken';

            final response = await dio.fetch<dynamic>(options);
            return handler.resolve(response);
          }
        }
      } on Exception catch (_) {
        await tokenStorage.clearTokens();
      }
    }

    handler.next(err);
  }

  Future<String?> _refreshToken(String refreshToken) async {
    try {
      final response = await dio.post<Map<String, dynamic>>(
        ApiConstants.refreshTokenEndpoint,
        data: {'refresh_token': refreshToken},
        options: Options(
          headers: {'Authorization': 'Bearer $refreshToken'},
        ),
      );

      if (response.data != null) {
        final newAccessToken = response.data!['token'] as String?;
        if (newAccessToken != null) {
          await tokenStorage.saveAccessToken(newAccessToken);
          return newAccessToken;
        }
      }
    } on Exception catch (_) {
      return null;
    }
    return null;
  }
}
