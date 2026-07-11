import 'package:dio/dio.dart';

class DioClient {
  DioClient({
    required String baseUrl,
  }) : _dio = Dio(
         BaseOptions(
           baseUrl: baseUrl,
           headers: {
             'Content-Type': 'application/json',
             'Accept': 'application/json',
           },
         ),
       ) {
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
