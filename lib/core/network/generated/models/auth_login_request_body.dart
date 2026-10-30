// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'auth_login_request_body.g.dart';

@JsonSerializable()
class AuthLoginRequestBody {
  const AuthLoginRequestBody({
    required this.username,
    required this.password,
    this.expiresInMins,
  });
  
  factory AuthLoginRequestBody.fromJson(Map<String, Object?> json) => _$AuthLoginRequestBodyFromJson(json);
  
  final String username;
  final String password;
  final int? expiresInMins;

  Map<String, Object?> toJson() => _$AuthLoginRequestBodyToJson(this);
}
