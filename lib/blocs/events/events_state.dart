part of 'events_bloc.dart';

@immutable
abstract class EventsState {
  const EventsState();
}

class EventsInitial extends EventsState {}

class EventsLoading extends EventsState {
  const EventsLoading(this.isLoading);
  final bool isLoading;
}

class EventsLoaded extends EventsState {
  const EventsLoaded(this.events, [this.isEventAdded = false]);
  final List<Event> events;
  final bool isEventAdded;
}

class EventsError extends EventsState {
  const EventsError(this.error);
  final String error;
}
