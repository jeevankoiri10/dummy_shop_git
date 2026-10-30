// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/auth_login_request_body.dart';
import '../models/auth_refresh_request_body.dart';
import '../models/login_response.dart';
import '../models/tokens.dart';
import '../models/user.dart';

part 'auth_client.g.dart';

@RestApi()
abstract class AuthClient {
  factory AuthClient(Dio dio, {String? baseUrl}) = _AuthClient;

  /// Login and receive access/refresh tokens
  @POST('/auth/login')
  Future<LoginResponse> authLogin({
    @Body() required AuthLoginRequestBody body,
  });

  /// Get current authenticated user
  @GET('/auth/me')
  Future<User> authMe();

  /// Refresh access and refresh tokens
  @POST('/auth/refresh')
  Future<Tokens> authRefresh({
    @Body() AuthRefreshRequestBody? body,
  });
}
