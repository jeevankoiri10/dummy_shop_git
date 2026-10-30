import 'package:dummy_shop/core/network/api_exception.dart';
import 'package:dummy_shop/core/network/generated/export.dart' as api;
import 'package:dummy_shop/features/users/data/models/user_profile.dart';
import 'package:dummy_shop/features/users/data/users_repository.dart';
import 'package:dummy_shop/features/users/presentation/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockUsersRepo extends Mock implements UsersRepository {}

void main() {
  const json = {
    'id': 1,
    'username': 'emilys',
    'firstName': 'Emily',
    'lastName': 'Johnson',
    'email': 'emily.johnson@x.dummyjson.com',
    'phone': '+81 965-431-3024',
    'address': {'city': 'Phoenix', 'country': 'United States'},
    'company': {'name': 'Dooley, Kozey and Cronin', 'title': 'Sales Manager'},
  };

  test('UserProfile maps the generated user', () {
    final profile = UserProfile.fromApi(api.User.fromJson(json));

    expect(profile.fullName, 'Emily Johnson');
    expect(profile.city, 'Phoenix');
    expect(profile.companyTitle, 'Sales Manager');
  });

  testWidgets('shows the profile, and retries after an error', (tester) async {
    final repo = _MockUsersRepo();
    when(() => repo.fetchUser(1))
        .thenAnswer((_) async => throw const ApiException('Server is down'));

    await tester.pumpWidget(
      RepositoryProvider<UsersRepository>.value(
        value: repo,
        child: const MaterialApp(home: ProfilePage(userId: 1)),
      ),
    );
    await tester.pump();
    expect(find.text('Server is down'), findsOneWidget);

    when(() => repo.fetchUser(1))
        .thenAnswer((_) async => UserProfile.fromApi(api.User.fromJson(json)));
    await tester.tap(find.text('Try again'));
    await tester.pump();
    await tester.pump();

    expect(find.text('Emily Johnson'), findsOneWidget);
    expect(find.text('Phoenix, United States'), findsOneWidget);
  });
}
