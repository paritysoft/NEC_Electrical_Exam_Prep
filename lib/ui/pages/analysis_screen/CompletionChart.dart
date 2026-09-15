import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class CompletionProgress extends StatelessWidget {
  final int answered;
  final int total;

  const CompletionProgress({required this.answered, required this.total});

  @override
  Widget build(BuildContext context) {
    double percentage = total > 0 ? (answered / total).clamp(0.0, 1.0) : 0.0;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(width: double.infinity),
        Text(
          "Completion Progress",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 20),
        CircularPercentIndicator(
          radius: 100.0,
          lineWidth: 12.0,
          animation: true,
          animationDuration: 1200,
          percent: percentage,
          center: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "${(percentage * 100).toStringAsFixed(1)}%",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              Text("Completed", style: TextStyle(fontSize: 14)),
            ],
          ),
          circularStrokeCap: CircularStrokeCap.butt,
          progressColor: Colors.green,
          backgroundColor: Colors.grey.shade300,
        ),
        SizedBox(height: 10),
        // Text(
        //   "$answered / $total Questions Answered",
        //   style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        // ),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 10,
          runSpacing: 8,
          children: [
            Indicator(color: Colors.green, text: "Completed"),
            SizedBox(width: 10),
            Indicator(color: Colors.grey.shade300, text: "Not Completed"),
          ],
        ),
      ],
    );
  }
}

class Indicator extends StatelessWidget {
  final Color color;
  final String text;

  const Indicator({required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 12, height: 12, color: color),
        SizedBox(width: 4),
        Text(text),
      ],
    );
  }
}
