import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mark_the_date/util/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(this.googleSignIn) : super(AuthInitial()) {
    on<CheckStatus>(onCheckStatus);
    on<Logout>(onLogout);
  }

  late final GoogleSignIn googleSignIn;

  Future<void> onCheckStatus(CheckStatus event, Emitter<AuthState> emit) async {
    try {
      emit(const AuthLoading(true));
      await Future.delayed(const Duration(milliseconds: 800));

      final account = await googleSignIn.signInSilently();
      final pref = await SharedPreferences.getInstance();
      final accessToken = (await account?.authentication)?.accessToken ?? '';
      if (accessToken.isNotEmpty) {
        pref.setString(PrefKeys.access_token, accessToken);
      }

      emit(const AuthLoading(false));
      emit(AuthStatusLoaded(account != null));
    } catch (e) {
      emit(const AuthLoading(false));
      emit(AuthError(e.toString()));
    }
  }

  Future<void> onLogout(Logout event, Emitter<AuthState> emit) async {
    try {
      emit(const AuthLoading(true));
      await GoogleSignIn().disconnect();
      await googleSignIn.signOut();
      emit(const AuthLoading(false));
      emit(const AuthStatusLoaded(false, true));
    } catch (e) {
      emit(const AuthLoading(false));
      emit(AuthError(e.toString()));
    }
  }
}
