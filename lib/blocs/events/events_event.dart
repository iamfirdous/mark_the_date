part of 'events_bloc.dart';

@immutable
abstract class EventsEvent {
  const EventsEvent();
}

class GetEvents extends EventsEvent {
  const GetEvents();
}

class AddEvent extends EventsEvent {
  const AddEvent(this.title, this.date);
  final String title;
  final DateTime date;
}
