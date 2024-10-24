import 'package:commonquiz/ui/widgets/common_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:timezone/timezone.dart' as tz;
import '../../../main.dart';

class CalendarPage extends StatefulWidget {
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  TextEditingController _eventTitleController = TextEditingController();
  List<Appointment> _appointments = [];
  DateTime _selectedDate = DateTime.now();

  // Add Event with a reminder notification
  void _addEvent() {
    String title = _eventTitleController.text;
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Event title cannot be empty"),
      ));
      return;
    }

    Appointment newAppointment = Appointment(
      startTime: DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day, 9, 0),
      endTime: DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day, 10, 0),
      subject: title,
      color: Colors.green,
      isAllDay: true,
    );

    setState(() {
      _appointments.add(newAppointment);
      _scheduleNotification(newAppointment.startTime, title);  // Schedule reminder using TZDateTime
      _eventTitleController.clear();
    });
  }

  // Remove event and cancel its reminder
  void _removeEvent(Appointment appointment) {
    setState(() {
      _appointments.remove(appointment);
      _cancelNotification(_appointments.indexOf(appointment));  // Cancel reminder
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("Event '${appointment.subject}' removed"),
    ));
  }

  void _onCalendarTapped(CalendarTapDetails details) {
    if (details.appointments != null && details.appointments!.isNotEmpty) {
      _removeEvent(details.appointments!.first as Appointment);
    } else {
      setState(() {
        _selectedDate = details.date!;
      });
    }
  }

  // Function to show all events in a dialog
  void _showAllEvents() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: smallLabel(context, 'All Exam'),
          content: _appointments.isEmpty
              ? smallLabel(context, 'No exams available')
              : Container(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _appointments.length,
              itemBuilder: (context, index) {
                final appointment = _appointments[index];
                return ListTile(
                  title: Text(appointment.subject),
                  subtitle: Text(
                      '${appointment.startTime.toLocal()}'.split(' ')[0]),
                );
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Exam with Reminder'),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: SfCalendar(
              view: CalendarView.month,
              dataSource: EventDataSource(_appointments),
              onTap: _onCalendarTapped,
              monthViewSettings: MonthViewSettings(
                appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    TextField(
                      controller: _eventTitleController,
                      decoration: InputDecoration(
                        labelText: 'Exam Title',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: _addEvent,
                      child: Text('Add Exam'),
                    ),
                    ElevatedButton(
                      onPressed: _showAllEvents,
                      child: Text('View Exams'),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Selected Date: ${_selectedDate.toLocal()}'.split(' ')[0],
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _scheduleNotification(DateTime eventTime, String title) async {
    // Convert DateTime to TZDateTime for timezone support
    var scheduledTime = tz.TZDateTime.from(eventTime.subtract(Duration(minutes: 10)), tz.local);

    var androidDetails = const AndroidNotificationDetails(
      'event_channel_id', // Unique channel ID
      'Event Reminders',  // Channel name
      channelDescription: 'Reminder about your scheduled Exam',
      importance: Importance.max,
      priority: Priority.high,
    );

    var iosDetails = const DarwinNotificationDetails();
    var platformChannelDetails = NotificationDetails(android: androidDetails, iOS: iosDetails);

    await flutterLocalNotificationsPlugin.zonedSchedule(
      _appointments.length,  // Unique notification ID for each event
      'Exam Reminder',
      'Reminder for your exam: $title',
      scheduledTime,  // Use TZDateTime here
      platformChannelDetails,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    );
  }
  Future<void> _cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }
}

class EventDataSource extends CalendarDataSource {
  EventDataSource(List<Appointment> source) {
    appointments = source;
  }
}
