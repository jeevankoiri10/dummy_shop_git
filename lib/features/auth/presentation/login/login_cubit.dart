import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/network/api_exception.dart';
import '../../data/auth_repository.dart';
import '../../data/models/user.dart';

enum LoginStatus { idle, submitting, success, failure }

class LoginState extends Equatable {
  const LoginState({
    this.status = LoginStatus.idle,
    this.errorMessage,
    this.user,
  });

  final LoginStatus status;
  final String? errorMessage;
  final User? user;

  bool get isSubmitting => status == LoginStatus.submitting;

  @override
  List<Object?> get props => [status, errorMessage, user];
}

/// Login form submit state.
class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this._authRepository) : super(const LoginState());

  final AuthRepository _authRepository;

  Future<void> submit({
    required String username,
    required String password,
  }) async {
    if (state.isSubmitting) return;
    emit(const LoginState(status: LoginStatus.submitting));
    try {
      final user = await _authRepository.login(
        username: username.trim(),
        password: password,
      );
      emit(LoginState(status: LoginStatus.success, user: user));
    } on ApiException catch (e) {
      emit(LoginState(status: LoginStatus.failure, errorMessage: e.message));
    }
  }
}
