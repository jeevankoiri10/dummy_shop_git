// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'address.dart';
import 'bank.dart';
import 'company.dart';
import 'crypto.dart';
import 'hair.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  const User({
    this.id,
    this.firstName,
    this.lastName,
    this.maidenName,
    this.age,
    this.gender,
    this.email,
    this.phone,
    this.username,
    this.password,
    this.birthDate,
    this.image,
    this.bloodGroup,
    this.height,
    this.weight,
    this.eyeColor,
    this.hair,
    this.ip,
    this.address,
    this.macAddress,
    this.university,
    this.bank,
    this.company,
    this.ein,
    this.ssn,
    this.userAgent,
    this.crypto,
    this.role,
  });
  
  factory User.fromJson(Map<String, Object?> json) => _$UserFromJson(json);
  
  final int? id;
  final String? firstName;
  final String? lastName;
  final String? maidenName;
  final int? age;
  final String? gender;
  final String? email;
  final String? phone;
  final String? username;
  final String? password;
  final String? birthDate;
  final String? image;
  final String? bloodGroup;
  final num? height;
  final num? weight;
  final String? eyeColor;
  final Hair? hair;
  final String? ip;
  final Address? address;
  final String? macAddress;
  final String? university;
  final Bank? bank;
  final Company? company;
  final String? ein;
  final String? ssn;
  final String? userAgent;
  final Crypto? crypto;
  final String? role;

  Map<String, Object?> toJson() => _$UserToJson(this);
}
