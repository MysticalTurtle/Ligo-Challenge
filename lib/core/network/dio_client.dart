import 'package:dio/dio.dart';
import 'package:ligo_challenge/core/constants/api_constants.dart';
import 'package:ligo_challenge/core/network/auth_interceptor.dart';
import 'package:ligo_challenge/core/storage/token_storage.dart';

/// Configured Dio client with interceptors
class DioClient {
  DioClient({
    required String baseUrl,
    required TokenStorage tokenStorage,
  }) : _dio = Dio(
          BaseOptions(
            baseUrl: baseUrl,
            connectTimeout: ApiConstants.connectTimeout,
            receiveTimeout: ApiConstants.receiveTimeout,
            sendTimeout: ApiConstants.sendTimeout,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          ),
        ) {
    // Add interceptors
    _dio.interceptors.add(
      AuthInterceptor(
        tokenStorage: tokenStorage,
        dio: _dio,
      ),
    );

    // Add logging interceptor in debug mode
    _dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        requestHeader: true,
        responseHeader: false,
        error: true,
      ),
    );
  }

  final Dio _dio;

  /// Get the underlying Dio instance
  Dio get dio => _dio;
}
