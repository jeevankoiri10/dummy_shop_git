import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../storage/token_storage.dart';
import 'generated/export.dart' as api;

const kBaseUrl = String.fromEnvironment(
  'API_BASE_URL',
  defaultValue: 'https://dummyjson.com',
);

/// Shared Dio client. Adds the token and reports 401s.
Dio createDio({
  required TokenStorage tokenStorage,
  required VoidCallback onUnauthorized,
  String baseUrl = kBaseUrl,
}) {
  final dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 15),
      contentType: Headers.jsonContentType,
      responseType: ResponseType.json,
    ),
  );

  dio.interceptors.add(
    AuthInterceptor(
      dio: dio,
      tokenStorage: tokenStorage,
      onUnauthorized: onUnauthorized,
    ),
  );

  if (kDebugMode) {
    dio.interceptors.add(
      LogInterceptor(
        requestBody: false,
        responseBody: false,
        logPrint: (o) => debugPrint(o.toString()),
      ),
    );
  }
  return dio;
}

class AuthInterceptor extends Interceptor {
  AuthInterceptor({
    required this.dio,
    required this.tokenStorage,
    required this.onUnauthorized,
  });

  final Dio dio;
  final TokenStorage tokenStorage;
  final VoidCallback onUnauthorized;

  /// No token or logout for these.
  static const _publicPaths = {'/auth/login', '/auth/refresh'};
  static const _retriedKey = 'auth.retried';

  /// Separate client, so a failed refresh can't trigger another refresh.
  late final api.AuthClient _refreshClient = api.AuthClient(
    Dio(dio.options.copyWith())..httpClientAdapter = dio.httpClientAdapter,
  );

  /// Requests that fail together share one refresh.
  Future<bool>? _refreshing;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (!_publicPaths.contains(options.path)) {
      final token = await tokenStorage.readAccessToken();
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final options = err.requestOptions;
    if (err.response?.statusCode != 401 ||
        _publicPaths.contains(options.path)) {
      handler.next(err);
      return;
    }
    if (options.extra[_retriedKey] == true) {
      onUnauthorized();
      handler.next(err);
      return;
    }

    try {
      final refreshed = await (_refreshing ??=
          _refresh().whenComplete(() => _refreshing = null));
      if (!refreshed) {
        onUnauthorized();
        handler.next(err);
        return;
      }
      options.extra[_retriedKey] = true;
      handler.resolve(await dio.fetch<dynamic>(options));
    } on DioException catch (e) {
      handler.next(e);
    }
  }

  /// False if the session is over. Network errors are rethrown, because they
  /// don't mean the refresh token is bad.
  Future<bool> _refresh() async {
    final refreshToken = await tokenStorage.readRefreshToken();
    if (refreshToken == null || refreshToken.isEmpty) return false;
    try {
      final tokens = await _refreshClient.authRefresh(
        body: api.AuthRefreshRequestBody(
          refreshToken: refreshToken,
          expiresInMins: 60,
        ),
      );
      final accessToken = tokens.accessToken;
      if (accessToken == null || accessToken.isEmpty) return false;
      await tokenStorage.saveTokens(
        accessToken: accessToken,
        refreshToken: tokens.refreshToken,
      );
      return true;
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      if (status != null && status >= 400 && status < 500) return false;
      rethrow;
    }
  }
}
