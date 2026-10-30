// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'hair.g.dart';

@JsonSerializable()
class Hair {
  const Hair({
    this.color,
    this.type,
  });
  
  factory Hair.fromJson(Map<String, Object?> json) => _$HairFromJson(json);
  
  final String? color;
  final String? type;

  Map<String, Object?> toJson() => _$HairToJson(this);
}
