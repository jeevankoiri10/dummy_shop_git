// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'tokens.g.dart';

@JsonSerializable()
class Tokens {
  const Tokens({
    this.accessToken,
    this.refreshToken,
  });
  
  factory Tokens.fromJson(Map<String, Object?> json) => _$TokensFromJson(json);
  
  final String? accessToken;
  final String? refreshToken;

  Map<String, Object?> toJson() => _$TokensToJson(this);
}
