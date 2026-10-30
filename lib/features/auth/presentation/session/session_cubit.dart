import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/network/api_exception.dart';
import '../../data/auth_repository.dart';
import '../../data/models/user.dart';

part 'session_state.dart';

/// App-wide auth status.
class SessionCubit extends Cubit<SessionState> {
  SessionCubit(this._authRepository) : super(const SessionUnknown());

  final AuthRepository _authRepository;

  /// Runs on startup.
  Future<void> restore() async {
    try {
      final user = await _authRepository.restoreSession();
      emit(user == null ? const SessionUnauthenticated() : SessionAuthenticated(user));
    } on ApiException {
      // Offline with a token, let them in. Next request re-checks it.
      emit(const SessionAuthenticated(null));
    }
  }

  void loggedIn(User user) => emit(SessionAuthenticated(user));

  Future<void> logout() async {
    await _authRepository.logout();
    emit(const SessionUnauthenticated());
  }

  /// Called on any 401.
  Future<void> sessionExpired() async {
    if (state is! SessionAuthenticated) return;
    await _authRepository.logout();
    emit(const SessionUnauthenticated(
      message: 'Your session has expired. Please log in again.',
    ));
  }
}
