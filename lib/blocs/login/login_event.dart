part of 'login_bloc.dart';

@immutable
abstract class LoginEvent {
  const LoginEvent();
}

class LoginWithGoogle extends LoginEvent {
  const LoginWithGoogle(this.isSilently);
  final bool isSilently;
}
