import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../models/activity_data.dart';

class QuizGraphPicChart extends StatefulWidget {
  @override
  _QuizActivityGraphState createState() => _QuizActivityGraphState();
}

class _QuizActivityGraphState extends State<QuizGraphPicChart> {
  int selectedDays = 7; // Default to 7 days

  List<ActivityData> activityData = [];

  @override
  void initState() {
    super.initState();
    activityData = getActivityData(selectedDays); // Load initial data
  }

  List<ActivityData> getActivityData(int days) {
    final now = DateTime.now();
    return List.generate(days, (index) {
      final date = now.subtract(Duration(days: index));
      final answeredQuestions = (10 + index * 2); // Replace with actual data
      final accuracyRate = (60 + index % 20).toDouble(); // Replace with actual data
      return ActivityData(date, answeredQuestions, accuracyRate);
    });
  }

  void updateData(int days) {
    setState(() {
      selectedDays = days;
      activityData = getActivityData(days);
    });
  }

  List<PieChartSectionData> generatePieSections() {
    final totalQuestions = activityData.fold<int>(
      0,
          (sum, item) => sum + item.answeredQuestions,
    );

    return activityData.map((data) {
      final percentage = (data.answeredQuestions / totalQuestions) * 100;
      return PieChartSectionData(
        value: percentage,
        title: '${percentage.toStringAsFixed(1)}%',
        color: Colors.primaries[activityData.indexOf(data) % Colors.primaries.length],
        radius: 60,
        titleStyle: const TextStyle(fontSize: 12, color: Colors.white),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        smallLabel(context, "Activity Graph (Last $selectedDays Days)"),
        SizedBox(height: 16),
        Container(
          height: 300,
          child: PieChart(
            PieChartData(
              sections: generatePieSections(),
              centerSpaceRadius: 40, // Doughnut-style center space
              borderData: FlBorderData(show: false),
              sectionsSpace: 4,
              pieTouchData: PieTouchData(
                touchCallback: (FlTouchEvent event, pieTouchResponse) {
                  if (pieTouchResponse != null &&
                      pieTouchResponse.touchedSection != null) {
                    final index =
                        pieTouchResponse.touchedSection!.touchedSectionIndex;

                    setState(() {
                      // Highlight the touched section
                      for (var i = 0; i < activityData.length; i++) {
                        final current = generatePieSections()[i];
                        if (i == index) {
                          current.copyWith(radius: 70);
                        }
                      }
                    });
                  }
                },
              ),
            ),
            swapAnimationDuration: const Duration(milliseconds: 800),
            swapAnimationCurve: Curves.easeInOut,
          ),
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton(
              onPressed: () => updateData(7),
              child: Text("7 Days"),
            ),
            ElevatedButton(
              onPressed: () => updateData(15),
              child: Text("15 Days"),
            ),
            ElevatedButton(
              onPressed: () => updateData(30),
              child: Text("30 Days"),
            ),
          ],
        ),
      ],
    );
  }
}

Widget smallLabel(BuildContext context, String text) {
  return Text(
    text,
    style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 14),
  );
}