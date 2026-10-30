// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'address2.dart';

part 'company.g.dart';

@JsonSerializable()
class Company {
  const Company({
    this.department,
    this.name,
    this.title,
    this.address,
  });
  
  factory Company.fromJson(Map<String, Object?> json) => _$CompanyFromJson(json);
  
  final String? department;
  final String? name;
  final String? title;
  final Address2? address;

  Map<String, Object?> toJson() => _$CompanyToJson(this);
}
