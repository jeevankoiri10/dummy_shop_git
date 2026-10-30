// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'crypto.g.dart';

@JsonSerializable()
class Crypto {
  const Crypto({
    this.coin,
    this.wallet,
    this.network,
  });
  
  factory Crypto.fromJson(Map<String, Object?> json) => _$CryptoFromJson(json);
  
  final String? coin;
  final String? wallet;
  final String? network;

  Map<String, Object?> toJson() => _$CryptoToJson(this);
}
