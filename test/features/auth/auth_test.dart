import 'package:bloc_test/bloc_test.dart';
import 'package:dummy_shop/core/network/api_exception.dart';
import 'package:dummy_shop/features/auth/data/auth_repository.dart';
import 'package:dummy_shop/features/auth/data/models/user.dart';
import 'package:dummy_shop/features/auth/presentation/login/login_cubit.dart';
import 'package:dummy_shop/features/auth/presentation/session/session_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockAuthRepo extends Mock implements AuthRepository {}

const _user = User(
  id: 1,
  username: 'emilys',
  firstName: 'Emily',
  lastName: 'Johnson',
  email: 'emily.johnson@x.dummyjson.com',
);

void main() {
  late _MockAuthRepo repo;
  setUp(() => repo = _MockAuthRepo());

  group('LoginCubit', () {
    blocTest<LoginCubit, LoginState>(
      'emits submitting then success with the user',
      setUp: () => when(() => repo.login(username: 'emilys', password: 'emilyspass'))
          .thenAnswer((_) async => _user),
      build: () => LoginCubit(repo),
      act: (c) => c.submit(username: ' emilys ', password: 'emilyspass'),
      expect: () => const [
        LoginState(status: LoginStatus.submitting),
        LoginState(status: LoginStatus.success, user: _user),
      ],
    );

    blocTest<LoginCubit, LoginState>(
      'emits failure with the server message',
      setUp: () => when(() => repo.login(
                username: any(named: 'username'),
                password: any(named: 'password'),
              )).thenThrow(
          const ApiException('Invalid credentials', statusCode: 400)),
      build: () => LoginCubit(repo),
      act: (c) => c.submit(username: 'emilys', password: 'wrong'),
      expect: () => const [
        LoginState(status: LoginStatus.submitting),
        LoginState(
            status: LoginStatus.failure, errorMessage: 'Invalid credentials'),
      ],
    );
  });

  group('SessionCubit', () {
    blocTest<SessionCubit, SessionState>(
      'restore -> authenticated when a valid token exists',
      setUp: () => when(() => repo.restoreSession()).thenAnswer((_) async => _user),
      build: () => SessionCubit(repo),
      act: (c) => c.restore(),
      expect: () => const [SessionAuthenticated(_user)],
    );

    blocTest<SessionCubit, SessionState>(
      'restore -> unauthenticated when no token',
      setUp: () => when(() => repo.restoreSession()).thenAnswer((_) async => null),
      build: () => SessionCubit(repo),
      act: (c) => c.restore(),
      expect: () => const [SessionUnauthenticated()],
    );

    blocTest<SessionCubit, SessionState>(
      'sessionExpired clears tokens and shows a message',
      setUp: () => when(() => repo.logout()).thenAnswer((_) async {}),
      build: () => SessionCubit(repo),
      seed: () => const SessionAuthenticated(_user),
      act: (c) => c.sessionExpired(),
      expect: () => const [
        SessionUnauthenticated(
            message: 'Your session has expired. Please log in again.'),
      ],
      verify: (_) => verify(() => repo.logout()).called(1),
    );
  });
}
