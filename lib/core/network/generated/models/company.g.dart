// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'company.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Company _$CompanyFromJson(Map<String, dynamic> json) => Company(
  department: json['department'] as String?,
  name: json['name'] as String?,
  title: json['title'] as String?,
  address: json['address'] == null
      ? null
      : Address2.fromJson(json['address'] as Map<String, dynamic>),
);

Map<String, dynamic> _$CompanyToJson(Company instance) => <String, dynamic>{
  'department': instance.department,
  'name': instance.name,
  'title': instance.title,
  'address': instance.address,
};
