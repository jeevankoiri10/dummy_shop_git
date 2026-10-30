// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_refresh_request_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthRefreshRequestBody _$AuthRefreshRequestBodyFromJson(
  Map<String, dynamic> json,
) => AuthRefreshRequestBody(
  refreshToken: json['refreshToken'] as String?,
  expiresInMins: (json['expiresInMins'] as num?)?.toInt(),
);

Map<String, dynamic> _$AuthRefreshRequestBodyToJson(
  AuthRefreshRequestBody instance,
) => <String, dynamic>{
  'refreshToken': instance.refreshToken,
  'expiresInMins': instance.expiresInMins,
};
