import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../models/activity_data.dart';

class QuizGraphBarChart extends StatefulWidget {
  @override
  _QuizActivityGraphState createState() => _QuizActivityGraphState();
}

class _QuizActivityGraphState extends State<QuizGraphBarChart> {
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
      return ActivityData(date, answeredQuestions,0);
    }).reversed.toList(); // Reverse for chronological order
  }

  void updateData(int days) {
    setState(() {
      selectedDays = days;
      activityData = getActivityData(days);
    });
  }

  List<BarChartGroupData> generateBarGroups() {
    return activityData.asMap().entries.map((entry) {
      final index = entry.key;
      final data = entry.value;
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: data.answeredQuestions.toDouble(),
            color: Colors.teal,
            width: 16,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      );
    }).toList();
  }

  Widget getBottomTitles(double value, TitleMeta meta) {
    final index = value.toInt();
    if (index < 0 || index >= activityData.length) return Container();
    final date = activityData[index].date;
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(
        "${date.day}/${date.month}",
        style: TextStyle(fontSize: 10),
      ),
    );
  }

  Widget getLeftTitles(double value, TitleMeta meta) {
    return Text(
      value.toInt().toString(),
      style: TextStyle(fontSize: 10),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "Activity Graph (Last $selectedDays Days)",
          style: Theme.of(context).textTheme.titleLarge,
        ),
        SizedBox(height: 16),
        Container(
          height: 300,
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: BarChart(
            BarChartData(
              barGroups: generateBarGroups(),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: getLeftTitles,
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: getBottomTitles,
                  ),
                ),
                topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              gridData: FlGridData(show: true),
              borderData: FlBorderData(
                show: true,
                border: Border.all(color: Colors.grey.withOpacity(0.5)),
              ),
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