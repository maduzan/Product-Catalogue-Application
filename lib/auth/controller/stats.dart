import '../model/model.dart';

/// Represents the abstract base class for authentication states.
abstract class AuthState {
  const AuthState();
}

/// Represents the initial authentication state.
class AuthInitial extends AuthState {}

/// Represents the authentication state when loading.
class AuthLoading extends AuthState {}

/// Represents the authentication state when authentication is successful.
class AuthSuccess extends AuthState {
  const AuthSuccess({required this.session});
  final Session session;
}

class AuthFailed extends AuthState {
  const AuthFailed(this.message);
  final String message;
}

/// Represents the authentication state when logging out.
class AuthLogout extends AuthState {}
