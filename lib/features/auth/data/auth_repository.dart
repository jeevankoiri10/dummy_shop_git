import 'package:dio/dio.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/network/generated/export.dart' as api;
import '../../../core/storage/token_storage.dart';
import 'models/user.dart';

abstract interface class AuthRepository {
  /// Throws [ApiException] on failure.
  Future<User> login({required String username, required String password});

  /// Current user, or null if there's no valid token.
  Future<User?> restoreSession();

  Future<void> logout();
}

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({required Dio dio, required TokenStorage tokenStorage})
      : _client = api.AuthClient(dio),
        _tokenStorage = tokenStorage;

  final api.AuthClient _client;
  final TokenStorage _tokenStorage;

  @override
  Future<User> login({
    required String username,
    required String password,
  }) async {
    try {
      final res = await _client.authLogin(
        body: api.AuthLoginRequestBody(
          username: username,
          password: password,
          expiresInMins: 60,
        ),
      );
      final accessToken = res.accessToken!;
      await _tokenStorage.saveTokens(
        accessToken: accessToken,
        refreshToken: res.refreshToken,
      );
      return User.fromLogin(res);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  @override
  Future<User?> restoreSession() async {
    final token = await _tokenStorage.readAccessToken();
    if (token == null || token.isEmpty) return null;
    try {
      return User.fromApi(await _client.authMe());
    } on DioException catch (e) {
      final error = ApiException.fromDio(e);
      if (error.isUnauthorized) {
        await _tokenStorage.clear();
        return null;
      }
      throw error;
    }
  }

  @override
  Future<void> logout() => _tokenStorage.clear();
}
