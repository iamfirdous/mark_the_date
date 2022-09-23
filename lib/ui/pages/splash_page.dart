import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mark_the_date/blocs/auth/auth_bloc.dart';
import 'package:mark_the_date/ui/pages/calendar_page.dart';
import 'package:mark_the_date/ui/pages/sign_in_page.dart';
import 'package:mark_the_date/util/constants.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<AuthBloc>(context)..add(CheckStatus());
    return BlocProvider.value(
      value: bloc,
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthStatusLoaded) {
            final route = state.isAuthorized ? CalendarPage.route : SignInPage.route;
            Navigator.pushAndRemoveUntil(context, route, (_) => false);
          }
        },
        child: Scaffold(
          body: Container(
            alignment: Alignment.center,
            child: const Image(height: 170.0, image: AssetImage(Images.logo)),
          ),
        ),
      ),
    );
  }
}
