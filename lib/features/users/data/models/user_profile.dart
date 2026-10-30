import 'package:equatable/equatable.dart';

import '../../../../core/network/generated/export.dart' as api;

/// The profile page's view of `GET /users/{id}`. The API also returns the
/// password, which is never requested or kept here.
class UserProfile extends Equatable {
  const UserProfile({
    required this.id,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.phone,
    this.birthDate,
    this.image,
    this.city,
    this.country,
    this.companyName,
    this.companyTitle,
  });

  final int id;
  final String username;
  final String firstName;
  final String lastName;
  final String email;
  final String? phone;
  final String? birthDate;
  final String? image;
  final String? city;
  final String? country;
  final String? companyName;
  final String? companyTitle;

  String get fullName => '$firstName $lastName'.trim();

  factory UserProfile.fromApi(api.User user) => UserProfile(
        id: user.id!,
        username: user.username ?? '',
        firstName: user.firstName ?? '',
        lastName: user.lastName ?? '',
        email: user.email ?? '',
        phone: user.phone,
        birthDate: user.birthDate,
        image: user.image,
        city: user.address?.city,
        country: user.address?.country,
        companyName: user.company?.name,
        companyTitle: user.company?.title,
      );

  @override
  List<Object?> get props => [id, username, firstName, lastName, email];
}
