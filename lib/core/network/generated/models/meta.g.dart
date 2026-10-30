// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meta.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Meta _$MetaFromJson(Map<String, dynamic> json) => Meta(
  createdAt: json['createdAt'] as String?,
  updatedAt: json['updatedAt'] as String?,
  barcode: json['barcode'] as String?,
  qrCode: json['qrCode'] as String?,
);

Map<String, dynamic> _$MetaToJson(Meta instance) => <String, dynamic>{
  'createdAt': instance.createdAt,
  'updatedAt': instance.updatedAt,
  'barcode': instance.barcode,
  'qrCode': instance.qrCode,
};
