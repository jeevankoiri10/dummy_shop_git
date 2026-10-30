import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'features/auth/data/auth_repository.dart';
import 'features/auth/presentation/login/login_page.dart';
import 'features/auth/presentation/session/session_cubit.dart';

class App extends StatelessWidget {
  const App({
    super.key,
    required this.authRepository,
    required this.sessionCubit,
  });

  final AuthRepository authRepository;
  final SessionCubit sessionCubit;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepository>.value(value: authRepository),
      ],
      child: BlocProvider.value(
        value: sessionCubit,
        child: MaterialApp(
          title: 'Dummy Shop',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorSchemeSeed: Colors.indigo,
            useMaterial3: true,
          ),
          darkTheme: ThemeData(
            colorSchemeSeed: Colors.indigo,
            brightness: Brightness.dark,
            useMaterial3: true,
          ),
          home: const _AuthGate(),
        ),
      ),
    );
  }
}

/// Picks login or products from the session state.
class _AuthGate extends StatelessWidget {
  const _AuthGate();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SessionCubit, SessionState>(
      // Session ended, close any open pages.
      listenWhen: (prev, curr) => curr is SessionUnauthenticated,
      listener: (context, _) =>
          Navigator.of(context).popUntil((route) => route.isFirst),
      buildWhen: (prev, curr) => prev.runtimeType != curr.runtimeType,
      builder: (context, state) => switch (state) {
        SessionUnknown() => const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          ),
        SessionAuthenticated() => const Scaffold(
            body: Center(child: Text('logged in!')), // TODO products
          ),
        SessionUnauthenticated(:final message) =>
          LoginPage(initialMessage: message),
      },
    );
  }
}
