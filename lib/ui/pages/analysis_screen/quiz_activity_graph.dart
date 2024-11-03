import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../models/activity_data.dart';
import '../../widgets/common_widget.dart';

class QuizActivityGraph extends StatefulWidget {
  @override
  _QuizActivityGraphState createState() => _QuizActivityGraphState();
}

class _QuizActivityGraphState extends State<QuizActivityGraph> {
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

  List<FlSpot> generateSpots() {
    return activityData
        .asMap()
        .entries
        .map((entry) => FlSpot(entry.key.toDouble(), entry.value.answeredQuestions.toDouble()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        smallLabel(context, "Activity Graph (Last $selectedDays Days)"),
        SizedBox(height: 16),
        Container(
          height: 300,
          padding: EdgeInsets.all(16),
          child: LineChart(
            LineChartData(
              lineBarsData: [
                LineChartBarData(
                  spots: generateSpots(),
                  isCurved: true,
                  color: Colors.teal,
                  barWidth: 4,
                  belowBarData: BarAreaData(
                    show: true,
                    color: Colors.teal.withOpacity(0.3),
                  ),
                  dotData: FlDotData(show: false),
                ),
              ],
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, _) => Text(value.toInt().toString()),
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, _) {
                      final date = activityData[value.toInt()].date;
                      return Text("${date.day}/${date.month}");
                    },
                  ),
                ),
              ),
              gridData: FlGridData(show: true),
            ),
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
              onPressed: () => updateData(30),
              child: Text("30 Days"),
            ),
            ElevatedButton(
              onPressed: () => updateData(90),
              child: Text("90 Days"),
            ),
          ],
        ),
      ],
    );
  }
}
