import 'package:bloc/bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../util/constants.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc(this.googleSignIn) : super(LoginInitial()) {
    on<LoginWithGoogle>(onLoginWithGoogle);
  }

  late final GoogleSignIn googleSignIn;

  Future<void> onLoginWithGoogle(LoginWithGoogle event, Emitter<LoginState> emit) async {
    try {
      emit(const LoginLoading(true));

      GoogleSignInAccount? account;
      if (event.isSilently) {
        account = await googleSignIn.signInSilently();
      } else {
        account = await googleSignIn.signIn();
      }
      if (account == null) {
        throw Exception(Texts.google_signin_failed);
      }

      final pref = await SharedPreferences.getInstance();
      final accessToken = (await account.authentication).accessToken ?? '';
      if (accessToken.isNotEmpty) {
        pref.setString(PrefKeys.access_token, accessToken);
      }

      emit(const LoginLoading(false));
      emit(LoginSuccess());
    } catch (err) {
      emit(const LoginLoading(false));
      // Don't show any message to user when failed to signin silently
      if (event.isSilently) {
        emit(const LoginFailure(''));
        return;
      }
      emit(LoginFailure(err.toString()));
    }
  }
}
