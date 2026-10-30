import 'package:dio/dio.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/network/generated/export.dart' as api;
import 'models/user_profile.dart';

abstract interface class UsersRepository {
  /// Throws [ApiException] on failure.
  Future<UserProfile> fetchUser(int id);
}

class UsersRepositoryImpl implements UsersRepository {
  UsersRepositoryImpl(Dio dio) : _client = api.UsersClient(dio);

  final api.UsersClient _client;

  /// Only the fields the UI uses, which keeps the password out of the response.
  static const _fields =
      'id,username,firstName,lastName,email,phone,birthDate,image,address,company';

  @override
  Future<UserProfile> fetchUser(int id) async {
    try {
      final user = await _client.getUserById(id: id, select: _fields);
      return UserProfile.fromApi(user);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }
}
