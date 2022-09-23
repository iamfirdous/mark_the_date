part of 'login_bloc.dart';

@immutable
abstract class LoginState {
  const LoginState();
}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {
  const LoginLoading(this.isLoading);
  final bool isLoading;
}

class LoginSuccess extends LoginState {}

class LoginFailure extends LoginState {
  const LoginFailure(this.errorMessage);
  final String errorMessage;
}

class CredsUpdated extends LoginState {
  const CredsUpdated(this.email, this.password);
  final String email;
  final String password;
}
