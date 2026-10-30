// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'coordinates.g.dart';

@JsonSerializable()
class Coordinates {
  const Coordinates({
    this.lat,
    this.lng,
  });
  
  factory Coordinates.fromJson(Map<String, Object?> json) => _$CoordinatesFromJson(json);
  
  final num? lat;
  final num? lng;

  Map<String, Object?> toJson() => _$CoordinatesToJson(this);
}
