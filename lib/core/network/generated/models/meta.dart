// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'meta.g.dart';

@JsonSerializable()
class Meta {
  const Meta({
    this.createdAt,
    this.updatedAt,
    this.barcode,
    this.qrCode,
  });
  
  factory Meta.fromJson(Map<String, Object?> json) => _$MetaFromJson(json);
  
  final String? createdAt;
  final String? updatedAt;
  final String? barcode;
  final String? qrCode;

  Map<String, Object?> toJson() => _$MetaToJson(this);
}
