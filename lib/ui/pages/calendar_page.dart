import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mark_the_date/blocs/auth/auth_bloc.dart';
import 'package:mark_the_date/blocs/events/events_bloc.dart';
import 'package:mark_the_date/ui/pages/sign_in_page.dart';
import 'package:mark_the_date/util/calendar_client.dart';
import 'package:mark_the_date/util/constants.dart';
import 'package:mark_the_date/util/utils.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CalendarPage extends StatelessWidget {
  const CalendarPage({Key? key}) : super(key: key);

  static AppRoute get route => AppRoute(builder: (_) => const CalendarPage());

  @override
  Widget build(BuildContext context) {
    final authBloc = BlocProvider.of<AuthBloc>(context);
    final bloc = BlocProvider.of<EventsBloc>(context)..add(const GetEvents());

    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: bloc),
        BlocProvider.value(value: authBloc),
      ],
      child: Scaffold(
        appBar: AppBar(
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarIconBrightness: Brightness.light,
          ),
          backgroundColor: AppColors.primary,
          title: const Text(Texts.app_name),
          actions: [
            BlocListener<AuthBloc, AuthState>(
              listener: (context, state) {
                if (state is AuthLoading) {
                  state.isLoading ? showLoader(context) : Navigator.pop(context);
                }
                if (state is AuthStatusLoaded && state.isLogout) {
                  Navigator.pushAndRemoveUntil(context, SignInPage.route, (_) => false);
                }
              },
              child: const SizedBox(),
            ),
            BlocListener<EventsBloc, EventsState>(
              listener: (context, state) {
                if (state is EventsLoading) {
                  state.isLoading ? showLoader(context) : Navigator.pop(context);
                }
                if (state is EventsLoaded && state.isEventAdded) {
                  Navigator.pop(context);
                }
              },
              child: const SizedBox(),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: InkWell(
                onTap: () => authBloc.add(Logout()),
                child: const Icon(Icons.logout),
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 48.0),
            child: BlocBuilder<EventsBloc, EventsState>(
              builder: (context, state) {
                var dataSource = GoogleDataSource([]);
                if (state is EventsLoaded) {
                  dataSource = GoogleDataSource(state.events);
                }
                return SfCalendar(
                  dataSource: dataSource,
                  onTap: (details) {
                    if (details.appointments != null) {
                      return;
                    }
                    showDialog(
                      context: context,
                      builder: (_) => AddEventBottomSheet(details: details),
                    );
                  },
                  view: CalendarView.week,
                  cellBorderColor: AppColors.secondary,
                  todayHighlightColor: AppColors.primary,
                  selectionDecoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border.all(color: AppColors.primary, width: 2.0),
                    borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                    shape: BoxShape.rectangle,
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class AddEventBottomSheet extends StatelessWidget {
  AddEventBottomSheet({Key? key, required this.details}) : super(key: key);

  final CalendarTapDetails details;
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<EventsBloc>(context);
    final dateStyle = Theme.of(context).textTheme.subtitle1?.copyWith(
          fontWeight: FontWeight.bold,
        );
    return AlertDialog(
      title: Text('Add event', style: Theme.of(context).textTheme.headline2),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (details.date != null) ...[
            Text('Date: ', style: Theme.of(context).textTheme.subtitle1),
            Text(getDate(details.date!), style: dateStyle),
          ],
          TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: 'Add event title'),
          ),
          const SizedBox(height: 12.0),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                if (controller.text.isEmpty) {
                  return;
                }
                bloc.add(AddEvent(controller.text, details.date ?? DateTime.now()));
              },
              style: TextButton.styleFrom(backgroundColor: AppColors.primary),
              child: Text(
                'Save'.toUpperCase(),
                style: Theme.of(context).textTheme.button?.copyWith(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String getDate(DateTime date) {
    return '${date.day}-${date.month}-${date.year} at ${date.hour}:${date.minute < 9 ? '0${date.minute}' : date.minute}';
  }
}
