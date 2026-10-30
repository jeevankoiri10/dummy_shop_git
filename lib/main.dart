import 'package:flutter/material.dart';

import 'app.dart';
import 'core/network/api_client.dart';
import 'core/storage/token_storage.dart';
import 'features/auth/data/auth_repository.dart';
import 'features/auth/presentation/session/session_cubit.dart';
import 'features/products/data/products_repository.dart';
import 'features/users/data/users_repository.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Wired by hand, small enough not to need a DI package.
  final tokenStorage = SecureTokenStorage();

  late final SessionCubit sessionCubit;
  final dio = createDio(
    tokenStorage: tokenStorage,
    onUnauthorized: () => sessionCubit.sessionExpired(),
  );

  final authRepository =
      AuthRepositoryImpl(dio: dio, tokenStorage: tokenStorage);
  final productsRepository = ProductsRepositoryImpl(dio);
  final usersRepository = UsersRepositoryImpl(dio);
  sessionCubit = SessionCubit(authRepository)..restore();

  runApp(App(
    authRepository: authRepository,
    productsRepository: productsRepository,
    usersRepository: usersRepository,
    sessionCubit: sessionCubit,
  ));
}
