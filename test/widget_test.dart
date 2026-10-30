import 'package:dummy_shop/features/auth/data/auth_repository.dart';
import 'package:dummy_shop/features/auth/data/models/user.dart';
import 'package:dummy_shop/features/auth/presentation/login/login_page.dart';
import 'package:dummy_shop/features/auth/presentation/session/session_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockAuthRepo extends Mock implements AuthRepository {}

void main() {
  late _MockAuthRepo repo;
  late SessionCubit session;

  setUp(() {
    repo = _MockAuthRepo();
    session = SessionCubit(repo);
  });

  tearDown(() => session.close());

  Widget wrap() => RepositoryProvider<AuthRepository>.value(
        value: repo,
        child: BlocProvider.value(
          value: session,
          child: const MaterialApp(home: LoginPage()),
        ),
      );

  testWidgets('shows validation errors and does not call the API when empty',
      (tester) async {
    await tester.pumpWidget(wrap());
    await tester.tap(find.byKey(const Key('login_submit')));
    await tester.pump();

    expect(find.text('Enter your username'), findsOneWidget);
    expect(find.text('Enter your password'), findsOneWidget);
    verifyNever(() => repo.login(
          username: any(named: 'username'),
          password: any(named: 'password'),
        ));
  });

  testWidgets('successful login updates the session', (tester) async {
    const user = User(
      id: 1,
      username: 'emilys',
      firstName: 'Emily',
      lastName: 'Johnson',
      email: 'e@x.com',
    );
    when(() => repo.login(username: 'emilys', password: 'emilyspass'))
        .thenAnswer((_) async => user);

    await tester.pumpWidget(wrap());
    await tester.enterText(find.byKey(const Key('login_username')), 'emilys');
    await tester.enterText(
        find.byKey(const Key('login_password')), 'emilyspass');
    await tester.tap(find.byKey(const Key('login_submit')));
    await tester.pumpAndSettle();

    expect(session.state, const SessionAuthenticated(user));
  });
}
