import 'package:dio/dio.dart';

/// The only error the UI sees.
class ApiException implements Exception {
  const ApiException(
    this.message, {
    this.statusCode,
    this.isNetworkError = false,
  });

  final String message;
  final int? statusCode;
  final bool isNetworkError;

  bool get isUnauthorized => statusCode == 401;

  factory ApiException.fromDio(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.transformTimeout:
        return const ApiException(
          'The server took too long to respond. Please try again.',
          isNetworkError: true,
        );
      case DioExceptionType.connectionError:
        return const ApiException(
          'No internet connection. Check your network and try again.',
          isNetworkError: true,
        );
      case DioExceptionType.badResponse:
        final status = e.response?.statusCode;
        return ApiException(
          _serverMessage(e.response?.data) ?? _fallbackFor(status),
          statusCode: status,
        );
      case DioExceptionType.cancel:
        return const ApiException('Request was cancelled.');
      case DioExceptionType.badCertificate:
      case DioExceptionType.unknown:
        return const ApiException('Something went wrong. Please try again.');
    }
  }

  /// Errors look like `{ "message": "..." }`.
  static String? _serverMessage(Object? data) {
    if (data is Map && data['message'] is String) {
      return data['message'] as String;
    }
    return null;
  }

  static String _fallbackFor(int? status) {
    if (status == null) return 'Unexpected server response.';
    if (status == 401) return 'Your session has expired. Please log in again.';
    if (status == 404) return 'Not found.';
    if (status >= 500) return 'Server error ($status). Please try later.';
    return 'Request failed ($status).';
  }

  @override
  String toString() => 'ApiException($statusCode): $message';
}
