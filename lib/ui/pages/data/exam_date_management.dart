import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:flutter/material.dart';

class ExamDateManagement {
  static const String _eventKey = 'calendar_events';

  // Save events to shared preferences
  Future<void> saveEvents(List<Appointment> appointments) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> eventList = appointments.map((appointment) {
      return jsonEncode({
        'startTime': appointment.startTime.toIso8601String(),
        'endTime': appointment.endTime.toIso8601String(),
        'subject': appointment.subject,
        'color': appointment.color.value.toString(),
      });
    }).toList();
    await prefs.setStringList(_eventKey, eventList);
  }

  // Load events from shared preferences
  Future<List<Appointment>> loadEvents() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? eventList = prefs.getStringList(_eventKey);

    if (eventList == null) {
      return [];
    }

    return eventList.map((eventString) {
      Map<String, dynamic> eventMap = jsonDecode(eventString);
      return Appointment(
        startTime: DateTime.parse(eventMap['startTime']),
        endTime: DateTime.parse(eventMap['endTime']),
        subject: eventMap['subject'],
        color: Color(int.parse(eventMap['color'])),
      );
    }).toList();
  }

  // Remove an event and save the updated list
  Future<void> removeEvent(Appointment appointmentToRemove) async {
    List<Appointment> events = await loadEvents();
    events.removeWhere((event) =>
    event.startTime == appointmentToRemove.startTime &&
        event.endTime == appointmentToRemove.endTime &&
        event.subject == appointmentToRemove.subject
    );
    await saveEvents(events);
  }
}
