// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'coordinates2.g.dart';

@JsonSerializable()
class Coordinates2 {
  const Coordinates2({
    this.lat,
    this.lng,
  });
  
  factory Coordinates2.fromJson(Map<String, Object?> json) => _$Coordinates2FromJson(json);
  
  final num? lat;
  final num? lng;

  Map<String, Object?> toJson() => _$Coordinates2ToJson(this);
}
