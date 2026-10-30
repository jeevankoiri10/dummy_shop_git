// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/user.dart';

part 'users_client.g.dart';

@RestApi()
abstract class UsersClient {
  factory UsersClient(Dio dio, {String? baseUrl}) = _UsersClient;

  /// Get a single user.
  ///
  /// [id] - Resource id.
  ///
  /// [select] - Comma-separated fields to include (id is always included).
  ///
  /// [delay] - Artificial response delay in milliseconds (0–5000).
  @GET('/users/{id}')
  Future<User> getUserById({
    @Path('id') required int id,
    @Query('select') String? select,
    @Query('delay') int? delay,
  });
}
