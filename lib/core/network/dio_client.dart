import 'package:dio/dio.dart';
import 'package:ligo_challenge/core/constants/api_constants.dart';
import 'package:ligo_challenge/core/network/auth_interceptor.dart';
import 'package:ligo_challenge/core/storage/token_storage.dart';

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
    _dio.interceptors.add(
      AuthInterceptor(
        tokenStorage: tokenStorage,
        dio: _dio,
      ),
    );

    _dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        responseHeader: false,
      ),
    );
  }

  final Dio _dio;

  Dio get dio => _dio;
}
