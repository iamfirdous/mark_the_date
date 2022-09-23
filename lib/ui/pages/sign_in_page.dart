import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mark_the_date/blocs/login/login_bloc.dart';
import 'package:mark_the_date/ui/pages/calendar_page.dart';
import 'package:mark_the_date/util/constants.dart';
import 'package:mark_the_date/util/utils.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({Key? key}) : super(key: key);

  static AppRoute get route => AppRoute(builder: (_) => const SignInPage());

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<LoginBloc>(context);
    return BlocProvider.value(
      value: bloc,
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 48.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BlocListener<LoginBloc, LoginState>(
                      listener: (context, state) {
                        if (state is LoginLoading) {
                          state.isLoading ? showLoader(context) : Navigator.pop(context);
                        }
                        if (state is LoginSuccess) {
                          final route = CalendarPage.route;
                          Navigator.pushAndRemoveUntil(context, route, (_) => false);
                        }
                      },
                      child: const SizedBox(),
                    ),
                    Image.asset(Images.logo, height: 64.0),
                    const SizedBox(height: 24.0),
                    Text(Texts.sign_in_title, style: Theme.of(context).textTheme.headline2),
                    const SizedBox(height: 12.0),
                    Text(Texts.note, style: Theme.of(context).textTheme.bodyText2),
                    const SizedBox(height: 2.0),
                    Text(Texts.safety_note, style: Theme.of(context).textTheme.bodyText1),
                    const SizedBox(height: 42.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      child: Column(
                        children: [
                          Image.asset(Images.date_illustration),
                          const SizedBox(height: 42.0),
                          Text(
                            Texts.app_desc,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.headline3,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                InkWell(
                  onTap: () => bloc.add(const LoginWithGoogle(false)),
                  child: Container(
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                      border: Border.all(color: AppColors.primary, width: 2.0),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(Images.google_logo, width: 24.0),
                        const SizedBox(width: 16.0),
                        Text(
                          Texts.sign_in.toUpperCase(),
                          style: Theme.of(context).textTheme.button,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
