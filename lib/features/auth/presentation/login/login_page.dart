import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/auth_repository.dart';
import '../session/session_cubit.dart';
import 'login_cubit.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key, this.initialMessage});

  /// e.g. session expired.
  final String? initialMessage;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(context.read<AuthRepository>()),
      child: _LoginView(initialMessage: initialMessage),
    );
  }
}

class _LoginView extends StatefulWidget {
  const _LoginView({this.initialMessage});

  final String? initialMessage;

  @override
  State<_LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<_LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _username = TextEditingController();
  final _password = TextEditingController();
  bool _obscure = true;

  @override
  void initState() {
    super.initState();
    final message = widget.initialMessage;
    if (message != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(message)));
      });
    }
  }

  @override
  void dispose() {
    _username.dispose();
    _password.dispose();
    super.dispose();
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;
    context
        .read<LoginCubit>()
        .submit(username: _username.text, password: _password.text);
  }

  void _fillTestAccount() {
    _username.text = 'emilys';
    _password.text = 'emilyspass';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocConsumer<LoginCubit, LoginState>(
      listenWhen: (prev, curr) => prev.status != curr.status,
      listener: (context, state) {
        if (state.status == LoginStatus.success && state.user != null) {
          context.read<SessionCubit>().loggedIn(state.user!);
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: AutofillGroup(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Icon(Icons.storefront_rounded,
                              size: 64, color: theme.colorScheme.primary),
                          const SizedBox(height: 16),
                          Text('Welcome back',
                              textAlign: TextAlign.center,
                              style: theme.textTheme.headlineSmall),
                          const SizedBox(height: 4),
                          Text('Sign in to browse products',
                              textAlign: TextAlign.center,
                              style: theme.textTheme.bodyMedium),
                          const SizedBox(height: 32),
                          TextFormField(
                            key: const Key('login_username'),
                            controller: _username,
                            enabled: !state.isSubmitting,
                            autofillHints: const [AutofillHints.username],
                            textInputAction: TextInputAction.next,
                            autocorrect: false,
                            decoration: const InputDecoration(
                              labelText: 'Username',
                              prefixIcon: Icon(Icons.person_outline),
                              border: OutlineInputBorder(),
                            ),
                            validator: (v) => (v == null || v.trim().isEmpty)
                                ? 'Enter your username'
                                : null,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            key: const Key('login_password'),
                            controller: _password,
                            enabled: !state.isSubmitting,
                            obscureText: _obscure,
                            autofillHints: const [AutofillHints.password],
                            textInputAction: TextInputAction.done,
                            onFieldSubmitted: (_) => _submit(),
                            decoration: InputDecoration(
                              labelText: 'Password',
                              prefixIcon: const Icon(Icons.lock_outline),
                              border: const OutlineInputBorder(),
                              suffixIcon: IconButton(
                                tooltip: _obscure ? 'Show password' : 'Hide password',
                                icon: Icon(_obscure
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined),
                                onPressed: () =>
                                    setState(() => _obscure = !_obscure),
                              ),
                            ),
                            validator: (v) => (v == null || v.isEmpty)
                                ? 'Enter your password'
                                : null,
                          ),
                          if (state.status == LoginStatus.failure &&
                              state.errorMessage != null) ...[
                            const SizedBox(height: 16),
                            _ErrorBanner(message: state.errorMessage!),
                          ],
                          const SizedBox(height: 24),
                          FilledButton(
                            key: const Key('login_submit'),
                            onPressed: state.isSubmitting ? null : _submit,
                            style: FilledButton.styleFrom(
                              minimumSize: const Size.fromHeight(48),
                            ),
                            child: state.isSubmitting
                                ? const SizedBox.square(
                                    dimension: 20,
                                    child: CircularProgressIndicator(
                                        strokeWidth: 2),
                                  )
                                : const Text('Log in'),
                          ),
                          const SizedBox(height: 8),
                          TextButton(
                            onPressed:
                                state.isSubmitting ? null : _fillTestAccount,
                            child: const Text('Use test account (emilys)'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  const _ErrorBanner({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: scheme.errorContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: scheme.onErrorContainer),
          const SizedBox(width: 8),
          Expanded(
            child: Text(message,
                style: TextStyle(color: scheme.onErrorContainer)),
          ),
        ],
      ),
    );
  }
}
