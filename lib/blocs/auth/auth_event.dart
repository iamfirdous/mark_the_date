part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent {
  const AuthEvent();
}

class Logout extends AuthEvent {}

class CheckStatus extends AuthEvent {}
