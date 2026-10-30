// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'dimensions.g.dart';

@JsonSerializable()
class Dimensions {
  const Dimensions({
    this.width,
    this.height,
    this.depth,
  });
  
  factory Dimensions.fromJson(Map<String, Object?> json) => _$DimensionsFromJson(json);
  
  final num? width;
  final num? height;
  final num? depth;

  Map<String, Object?> toJson() => _$DimensionsToJson(this);
}
