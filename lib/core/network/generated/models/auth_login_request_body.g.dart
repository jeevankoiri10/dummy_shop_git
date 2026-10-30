// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_login_request_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthLoginRequestBody _$AuthLoginRequestBodyFromJson(
  Map<String, dynamic> json,
) => AuthLoginRequestBody(
  username: json['username'] as String,
  password: json['password'] as String,
  expiresInMins: (json['expiresInMins'] as num?)?.toInt(),
);

Map<String, dynamic> _$AuthLoginRequestBodyToJson(
  AuthLoginRequestBody instance,
) => <String, dynamic>{
  'username': instance.username,
  'password': instance.password,
  'expiresInMins': instance.expiresInMins,
};
