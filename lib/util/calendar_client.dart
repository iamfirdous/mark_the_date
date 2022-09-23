import 'package:flutter/material.dart';
import 'package:googleapis/calendar/v3.dart' hide Colors;
import 'package:mark_the_date/util/constants.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class GoogleDataSource extends CalendarDataSource {
  GoogleDataSource(List<Event> events) {
    appointments = events;
  }

  @override
  DateTime getStartTime(int index) {
    if (appointments?.isNotEmpty == true) {
      final event = appointments?[index] as Event;
      return event.start?.date ?? event.start?.dateTime?.toLocal() ?? DateTime.now();
    }
    return DateTime.now();
  }

  @override
  bool isAllDay(int index) {
    return appointments?[index].start.date != null;
  }

  @override
  DateTime getEndTime(int index) {
    final event = appointments?[index] as Event;
    return event.endTimeUnspecified != null && event.endTimeUnspecified == true
        ? (event.start?.date ?? event.start?.dateTime?.toLocal() ?? DateTime.now())
        : (event.end?.date != null
                ? event.end?.date?.add(const Duration(days: -1))
                : event.end?.dateTime?.toLocal()) ??
            DateTime.now();
  }

  @override
  String getLocation(int index) {
    return (appointments?[index] as Event).location ?? '';
  }

  @override
  String getNotes(int index) {
    return (appointments?[index] as Event).description ?? '';
  }

  @override
  String getSubject(int index) {
    final event = appointments?[index] as Event;
    return event.summary == null || event.summary?.isEmpty == true
        ? 'No Title'
        : (event.summary ?? '');
  }

  // @override
  // Color getColor(int index) {
  //   final event = appointments?[index] as Event;
  //   return event.kind == 'mtd' ? AppColors.primary : Colors.black;
  // }
}
