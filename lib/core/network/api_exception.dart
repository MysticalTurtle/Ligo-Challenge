import 'package:dio/dio.dart';

/// Standardized API exception
class ApiException implements Exception {
  ApiException({
    required this.message,
    this.statusCode,
    this.data,
  });

  factory ApiException.fromDioException(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.transformTimeout:
        return ApiException(
          message: 'Connection timeout. Please try again.',
        );

      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final data = error.response?.data;

        String message;
        if (data is Map<String, dynamic> && data.containsKey('message')) {
          message = data['message'] as String;
        } else if (statusCode == 401) {
          message = 'Unauthorized. Please login again.';
        } else if (statusCode == 403) {
          message = 'Access forbidden.';
        } else if (statusCode == 404) {
          message = 'Resource not found.';
        } else if (statusCode != null && statusCode >= 500) {
          message = 'Server error. Please try again later.';
        } else {
          message = 'An error occurred. Please try again.';
        }

        return ApiException(
          message: message,
          statusCode: statusCode,
          data: data,
        );

      case DioExceptionType.cancel:
        return ApiException(
          message: 'Request cancelled.',
        );

      case DioExceptionType.connectionError:
        return ApiException(
          message: 'No internet connection.',
        );

      case DioExceptionType.badCertificate:
        return ApiException(
          message: 'Certificate verification failed.',
        );

      case DioExceptionType.unknown:
        return ApiException(
          message: 'An unexpected error occurred.',
        );
    }
  }

  final String message;
  final int? statusCode;
  final dynamic data;

  @override
  String toString() => message;
}
