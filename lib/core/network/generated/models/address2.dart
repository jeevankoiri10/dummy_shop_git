// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'coordinates2.dart';

part 'address2.g.dart';

@JsonSerializable()
class Address2 {
  const Address2({
    this.address,
    this.city,
    this.state,
    this.stateCode,
    this.postalCode,
    this.coordinates,
    this.country,
  });
  
  factory Address2.fromJson(Map<String, Object?> json) => _$Address2FromJson(json);
  
  final String? address;
  final String? city;
  final String? state;
  final String? stateCode;
  final String? postalCode;
  final Coordinates2? coordinates;
  final String? country;

  Map<String, Object?> toJson() => _$Address2ToJson(this);
}
