// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'auth_refresh_request_body.g.dart';

@JsonSerializable()
class AuthRefreshRequestBody {
  const AuthRefreshRequestBody({
    this.refreshToken,
    this.expiresInMins,
  });
  
  factory AuthRefreshRequestBody.fromJson(Map<String, Object?> json) => _$AuthRefreshRequestBodyFromJson(json);
  
  final String? refreshToken;
  final int? expiresInMins;

  Map<String, Object?> toJson() => _$AuthRefreshRequestBodyToJson(this);
}
