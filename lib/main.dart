import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/calendar/v3.dart';
import 'package:mark_the_date/blocs/auth/auth_bloc.dart';
import 'package:mark_the_date/blocs/events/events_bloc.dart';
import 'package:mark_the_date/blocs/login/login_bloc.dart';
import 'package:mark_the_date/ui/pages/splash_page.dart';
import 'package:mark_the_date/util/constants.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const TextStyle textStyle = TextStyle(
    color: AppColors.secondary,
    fontFamily: Fonts.Nunito,
    fontSize: 14.0,
  );

  @override
  Widget build(BuildContext context) {
    final authBloc = AuthBloc(GoogleSignIn(scopes: [CalendarApi.calendarScope]));
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => authBloc),
        BlocProvider(create: (context) => LoginBloc(authBloc.googleSignIn)),
        BlocProvider(create: (context) => EventsBloc(authBloc.googleSignIn)),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: Texts.app_name,
        theme: ThemeData(
          primaryColor: AppColors.primary,
          fontFamily: Fonts.Nunito,
          textTheme: TextTheme(
            headline2: textStyle.copyWith(fontSize: 20.0, fontWeight: FontWeight.bold),
            headline3: textStyle.copyWith(fontSize: 18.0),
            subtitle1: textStyle.copyWith(fontSize: 16.0),
            bodyText1: textStyle,
            bodyText2: textStyle.copyWith(fontWeight: FontWeight.bold),
            button: textStyle.copyWith(fontSize: 14.0, fontWeight: FontWeight.bold),
          ),
        ),
        home: const SplashPage(),
      ),
    );
  }
}
