// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address2.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Address2 _$Address2FromJson(Map<String, dynamic> json) => Address2(
  address: json['address'] as String?,
  city: json['city'] as String?,
  state: json['state'] as String?,
  stateCode: json['stateCode'] as String?,
  postalCode: json['postalCode'] as String?,
  coordinates: json['coordinates'] == null
      ? null
      : Coordinates2.fromJson(json['coordinates'] as Map<String, dynamic>),
  country: json['country'] as String?,
);

Map<String, dynamic> _$Address2ToJson(Address2 instance) => <String, dynamic>{
  'address': instance.address,
  'city': instance.city,
  'state': instance.state,
  'stateCode': instance.stateCode,
  'postalCode': instance.postalCode,
  'coordinates': instance.coordinates,
  'country': instance.country,
};
