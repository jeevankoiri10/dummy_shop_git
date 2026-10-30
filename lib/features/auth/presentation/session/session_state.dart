part of 'session_cubit.dart';

sealed class SessionState extends Equatable {
  const SessionState();

  @override
  List<Object?> get props => [];
}

/// Storage not checked yet.
final class SessionUnknown extends SessionState {
  const SessionUnknown();
}

final class SessionAuthenticated extends SessionState {
  const SessionAuthenticated(this.user);

  /// Null if restored offline.
  final User? user;

  @override
  List<Object?> get props => [user];
}

final class SessionUnauthenticated extends SessionState {
  const SessionUnauthenticated({this.message});

  /// Shown on the login screen.
  final String? message;

  @override
  List<Object?> get props => [message];
}
