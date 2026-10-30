import 'package:equatable/equatable.dart';

import '../../../../core/network/generated/export.dart' as api;

class User extends Equatable {
  const User({
    required this.id,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.image,
  });

  final int id;
  final String username;
  final String firstName;
  final String lastName;
  final String email;
  final String? image;

  String get fullName => '$firstName $lastName'.trim();

  factory User.fromLogin(api.LoginResponse res) => User(
        id: res.id!,
        username: res.username ?? '',
        firstName: res.firstName ?? '',
        lastName: res.lastName ?? '',
        email: res.email ?? '',
        image: res.image,
      );

  factory User.fromApi(api.User user) => User(
        id: user.id!,
        username: user.username ?? '',
        firstName: user.firstName ?? '',
        lastName: user.lastName ?? '',
        email: user.email ?? '',
        image: user.image,
      );

  @override
  List<Object?> get props => [id, username, firstName, lastName, email, image];
}
