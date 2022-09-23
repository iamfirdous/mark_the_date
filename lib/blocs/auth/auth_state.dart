part of 'auth_bloc.dart';

@immutable
abstract class AuthState {
  const AuthState();
}

class AuthInitial extends AuthState {}

class AuthStatusLoaded extends AuthState {
  const AuthStatusLoaded(this.isAuthorized, [this.isLogout = false]);
  final bool isAuthorized;
  final bool isLogout;
}

class AuthLoading extends AuthState {
  const AuthLoading(this.isLoading);
  final bool isLoading;
}

class AuthError extends AuthState {
  const AuthError(this.error);
  final String error;
}
