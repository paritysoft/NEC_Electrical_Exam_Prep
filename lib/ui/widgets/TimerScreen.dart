import 'dart:async';
import 'package:commonquiz/ui/widgets/common_widget.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class TimerWidget extends StatefulWidget {
  final int initialTime; // Total time in seconds (e.g., 300 for 5 minutes)

  TimerWidget({Key? key, required this.initialTime}) : super(key: key);

  @override
  _TimerWidgetState createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  late Timer _timer;
  late int _remainingTime;  // Track remaining time in seconds
  double _percent = 1.0;    // Start at full circle (100%)
  late int _totalTime;      // Store total time to calculate percentage

  @override
  void initState() {
    super.initState();
    _remainingTime = widget.initialTime;
    _totalTime = widget.initialTime;
    startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();  // Clean up the timer when the widget is disposed
    super.dispose();
  }

  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingTime > 0) {
          _remainingTime--;
          _percent = _remainingTime / _totalTime;
        } else {
          _timer.cancel();
          // Add logic for when time runs out
        }
      });
    });
  }

  // Function to format time into hh:mm:ss
  String formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '00:${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160, // Set the height of the TimerWidget
      width: 150, // Set the width of the TimerWidget
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularPercentIndicator(
            radius: 65.0, // Match the height and width for a circular effect
            lineWidth: 13.0,
            animation: true,
            percent: _percent,
            center: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                smallLabel(context,
                  'Remaining Time',
                textSize: 9),
                SizedBox(height: 4),
                title15BoldColor(context,
                  formatTime(_remainingTime),
                ),
              ],
            ),
            progressColor: Colors.orange,
            backgroundColor: Colors.grey.shade200,
            circularStrokeCap: CircularStrokeCap.round,
          ),

        ],
      ),
    );
  }
}
