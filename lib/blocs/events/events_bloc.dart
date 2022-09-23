import 'package:bloc/bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/calendar/v3.dart';
import 'package:googleapis_auth/googleapis_auth.dart';
import 'package:http/http.dart' as http;
import 'package:mark_the_date/util/constants.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'events_event.dart';
part 'events_state.dart';

class EventsBloc extends Bloc<EventsEvent, EventsState> {
  EventsBloc(this.googleSignIn) : super(EventsInitial()) {
    on<GetEvents>(onGetEvents);
    on<AddEvent>(onAddEvent);
  }

  late final GoogleSignIn googleSignIn;

  Future<void> onGetEvents(GetEvents event, Emitter<EventsState> emit) async {
    try {
      emit(const EventsLoading(true));

      final isSignedIn = await googleSignIn.isSignedIn();
      if (!isSignedIn) {
        throw Exception('Not authenticated');
      }
      final httpClient = (await googleSignIn.authClient())!;
      final calendarApi = CalendarApi(httpClient);
      final calEvents = await calendarApi.events.list('primary');
      final events = calEvents.items?.where((i) => i.start != null).toList() ?? [];

      emit(const EventsLoading(false));
      emit(EventsLoaded(events));
    } catch (e) {
      emit(const EventsLoading(false));
      emit(EventsError(e.toString()));
    }
  }

  Future<void> onAddEvent(AddEvent event, Emitter<EventsState> emit) async {
    try {
      emit(const EventsLoading(true));

      final isSignedIn = await googleSignIn.isSignedIn();
      if (!isSignedIn) {
        throw Exception('Not authenticated');
      }
      final httpClient = (await googleSignIn.authClient())!;
      final calendarApi = CalendarApi(httpClient);

      final e = Event(
        summary: event.title,
        start: EventDateTime(dateTime: event.date),
        end: EventDateTime(dateTime: event.date.add(const Duration(hours: 1))),
      );
      await calendarApi.events.insert(e, 'primary');

      final calEvents = await calendarApi.events.list('primary');
      final events = calEvents.items?.where((i) => i.start != null).toList() ?? [];

      emit(const EventsLoading(false));
      emit(EventsLoaded(events, true));
    } catch (e) {
      emit(const EventsLoading(false));
      emit(EventsError(e.toString()));
    }
  }
}

extension GoogleApisGoogleSignInAuth on GoogleSignIn {
  /// Retrieve a `googleapis` authenticated client.
  Future<AuthClient?> authClient() async {
    final pref = await SharedPreferences.getInstance();
    final accessToken = pref.getString(PrefKeys.access_token);
    if (accessToken == null || accessToken.isEmpty) {
      return null;
    }
    final AccessCredentials credentials = AccessCredentials(
      AccessToken(
        'Bearer',
        accessToken,
        DateTime.now().toUtc().add(const Duration(days: 365)),
      ),
      null, // We don't have a refreshToken
      scopes,
    );

    return authenticatedClient(http.Client(), credentials);
  }
}
