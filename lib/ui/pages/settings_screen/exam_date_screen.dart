import 'package:electrician/subscription/core/sharepref_helper.dart';
import 'package:electrician/ui/widgets/common_widget.dart';
import 'package:electrician/util/AppColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
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
        content: smallLabel(context, "Exam title cannot be empty",
          color: Colors.white),
        backgroundColor: primary));
      return;
    }

    Appointment newAppointment = Appointment(
      startTime: DateTime(
          _selectedDate.year, _selectedDate.month, _selectedDate.day, 9, 0),
      endTime: DateTime(
          _selectedDate.year, _selectedDate.month, _selectedDate.day, 10, 0),
      subject: title,
      color: Colors.green,
      isAllDay: true,
    );

    setState(() {
      SharedPreferenceHelper.setExamDate(newAppointment.startTime.toIso8601String());
      _appointments.add(newAppointment);
      _scheduleNotification(newAppointment.startTime,
          title); // Schedule reminder using TZDateTime
      _eventTitleController.clear();
    });
  }

  // Remove event and cancel its reminder
  void _removeEvent(Appointment appointment) {
    setState(() {
      _appointments.remove(appointment);
      _cancelNotification(
          _appointments.indexOf(appointment)); // Cancel reminder
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: smallLabel(context, "Exam '${appointment.subject}' removed",
          color: Colors.white),
      backgroundColor: primary,
    ));
  }

  void _onCalendarTapped(CalendarTapDetails details) {
    if (details.appointments != null && details.appointments!.isNotEmpty) {
      _showConfirmationDialog(
          context, details.appointments!.first as Appointment);
    } else {
      setState(() {
        _selectedDate = details.date!;
      });
    }
  }

  void _showConfirmationDialog(BuildContext context, Appointment appointment) {
    Alert(
      context: context,
      type: AlertType.warning,
      title: "Confirmation",
      desc: "Are you sure you want to proceed?",
      buttons: [
        DialogButton(
          child: Text(
            "Cancel",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          onPressed: () => Navigator.pop(context),
          color: Colors.grey,
        ),
        DialogButton(
          child: Text(
            "Confirm",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          onPressed: () {
            _removeEvent(appointment);
            Navigator.pop(context);
          },
          color: Colors.blue,
        ),
      ],
    ).show();
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
      appBar: appBarCustom(context, "Create Exam with Reminder"),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _eventTitleController,
              decoration: InputDecoration(
                labelText: 'Exam Title',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            flex: 3,
            child: SfCalendar(
              showNavigationArrow: true,
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
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: _showAllEvents,
                            child: smallLabel(context, 'View Exams',
                                color: Colors.white),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: primary,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 40, vertical: 15),
                                textStyle: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          ElevatedButton(
                            onPressed: _addEvent,
                            child: smallLabel(context, 'Add Exam',
                                color: Colors.white),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: primary,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 40, vertical: 15),
                                textStyle: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                          )
                        ]),

                    SizedBox(height: 10),
                    // smallLabel(context,
                    //   'Selected Date: ${_selectedDate.toLocal()}'.split(' ')[0],
                    //  textSize: 16
                    // ),
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
    var scheduledTime =
        tz.TZDateTime.from(eventTime.subtract(Duration(minutes: 10)), tz.local);

    var androidDetails = const AndroidNotificationDetails(
      'event_channel_id', // Unique channel ID
      'Exam Reminders', // Channel name
      channelDescription: 'Reminder about your scheduled Exam',
      importance: Importance.max,
      priority: Priority.high,
    );

    var iosDetails = const DarwinNotificationDetails();
    var platformChannelDetails =
        NotificationDetails(android: androidDetails, iOS: iosDetails);

    await flutterLocalNotificationsPlugin.zonedSchedule(
      _appointments.length, // Unique notification ID for each event
      'Exam Reminder',
      'Reminder for your exam: $title',
      scheduledTime, // Use TZDateTime here
      platformChannelDetails,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
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
