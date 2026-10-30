// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'coordinates.dart';

part 'address.g.dart';

@JsonSerializable()
class Address {
  const Address({
    this.address,
    this.city,
    this.state,
    this.stateCode,
    this.postalCode,
    this.coordinates,
    this.country,
  });
  
  factory Address.fromJson(Map<String, Object?> json) => _$AddressFromJson(json);
  
  final String? address;
  final String? city;
  final String? state;
  final String? stateCode;
  final String? postalCode;
  final Coordinates? coordinates;
  final String? country;

  Map<String, Object?> toJson() => _$AddressToJson(this);
}
