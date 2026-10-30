import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:dummy_shop/core/network/api_client.dart';
import 'package:dummy_shop/core/storage/token_storage.dart';
import 'package:flutter_test/flutter_test.dart';

class _MemoryTokens implements TokenStorage {
  _MemoryTokens({this.access, this.refresh});

  String? access;
  String? refresh;

  @override
  Future<String?> readAccessToken() async => access;

  @override
  Future<String?> readRefreshToken() async => refresh;

  @override
  Future<void> saveTokens({
    required String accessToken,
    String? refreshToken,
  }) async {
    access = accessToken;
    if (refreshToken != null) refresh = refreshToken;
  }

  @override
  Future<void> clear() async => access = refresh = null;
}

/// Accepts only `Bearer new`, and answers refreshes with [refreshStatus].
class _FakeApi implements HttpClientAdapter {
  _FakeApi({this.refreshStatus = 200, this.refreshFails = false});

  final int refreshStatus;
  final bool refreshFails;
  final calls = <String>[];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    calls.add(options.path);
    if (options.path == '/auth/refresh') {
      if (refreshFails) {
        throw DioException.connectionError(
          requestOptions: options,
          reason: 'offline',
        );
      }
      return _json(refreshStatus, {
        'accessToken': 'new',
        'refreshToken': 'new-refresh',
      });
    }
    return options.headers['Authorization'] == 'Bearer new'
        ? _json(200, {'id': 1})
        : _json(401, {'message': 'Invalid/Expired Token!'});
  }

  ResponseBody _json(int status, Object body) => ResponseBody.fromString(
    jsonEncode(body),
    status,
    headers: {
      Headers.contentTypeHeader: [Headers.jsonContentType],
    },
  );

  @override
  void close({bool force = false}) {}
}

void main() {
  late _MemoryTokens tokens;
  late int expired;

  setUp(() {
    tokens = _MemoryTokens(access: 'old', refresh: 'old-refresh');
    expired = 0;
  });

  Dio client(_FakeApi api) => createDio(
    tokenStorage: tokens,
    onUnauthorized: () => expired++,
    baseUrl: 'https://example.test',
  )..httpClientAdapter = api;

  test('a 401 refreshes the tokens and retries the request', () async {
    final api = _FakeApi();

    final res = await client(api).get<Map<String, dynamic>>('/auth/me');

    expect(res.data, {'id': 1});
    expect(api.calls, ['/auth/me', '/auth/refresh', '/auth/me']);
    expect(tokens.access, 'new');
    expect(tokens.refresh, 'new-refresh');
    expect(expired, 0);
  });

  test('requests that fail together share one refresh', () async {
    final api = _FakeApi();
    final dio = client(api);

    await Future.wait([dio.get<dynamic>('/a'), dio.get<dynamic>('/b')]);

    expect(api.calls.where((p) => p == '/auth/refresh'), hasLength(1));
    expect(expired, 0);
  });

  test('a rejected refresh token ends the session', () async {
    final api = _FakeApi(refreshStatus: 403);

    await expectLater(
      client(api).get<dynamic>('/auth/me'),
      throwsA(isA<DioException>()),
    );

    expect(expired, 1);
  });

  test('no refresh token ends the session without calling the API', () async {
    tokens.refresh = null;
    final api = _FakeApi();

    await expectLater(
      client(api).get<dynamic>('/auth/me'),
      throwsA(isA<DioException>()),
    );

    expect(api.calls, ['/auth/me']);
    expect(expired, 1);
  });

  test('a network error during refresh keeps the session', () async {
    final api = _FakeApi(refreshFails: true);

    await expectLater(
      client(api).get<dynamic>('/auth/me'),
      throwsA(
        isA<DioException>().having(
          (e) => e.type,
          'type',
          DioExceptionType.connectionError,
        ),
      ),
    );

    expect(expired, 0);
    expect(tokens.refresh, 'old-refresh');
  });

  test('a failed login does not refresh or end the session', () async {
    final api = _FakeApi();

    await expectLater(
      client(api).post<dynamic>('/auth/login'),
      throwsA(isA<DioException>()),
    );

    expect(api.calls, ['/auth/login']);
    expect(expired, 0);
  });
}
