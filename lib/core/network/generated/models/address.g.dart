// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Address _$AddressFromJson(Map<String, dynamic> json) => Address(
  address: json['address'] as String?,
  city: json['city'] as String?,
  state: json['state'] as String?,
  stateCode: json['stateCode'] as String?,
  postalCode: json['postalCode'] as String?,
  coordinates: json['coordinates'] == null
      ? null
      : Coordinates.fromJson(json['coordinates'] as Map<String, dynamic>),
  country: json['country'] as String?,
);

Map<String, dynamic> _$AddressToJson(Address instance) => <String, dynamic>{
  'address': instance.address,
  'city': instance.city,
  'state': instance.state,
  'stateCode': instance.stateCode,
  'postalCode': instance.postalCode,
  'coordinates': instance.coordinates,
  'country': instance.country,
};
