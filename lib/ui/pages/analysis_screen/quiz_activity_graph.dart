import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../models/activity_data.dart';
import '../../widgets/common_widget.dart';
import '../data/upadansonghro.dart';

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
    fetchActivityData(selectedDays); // Load initial data
  }

  /// Fetch data from the database
  Future<void> fetchActivityData(int days) async {
    UpadanSonghro dbHelper = UpadanSonghro();
    final data = await dbHelper.getActivityDataByDays(days);
    setState(() {
      selectedDays = days;
      activityData = data;
    });
  }

  /// Convert activity data into chart points
  List<FlSpot> generateSpots() {
    return activityData.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value.answeredQuestions.toDouble());
    }).toList();
  }

  /// Custom button with selection highlight
  Widget buildFilterButton(int days, String label) {
    return ElevatedButton(
      onPressed: () => fetchActivityData(days),
      style: ElevatedButton.styleFrom(
        backgroundColor: selectedDays == days ? Colors.teal : Colors.grey[300], // Highlight selected
        foregroundColor: selectedDays == days ? Colors.white : Colors.black, // Adjust text color
      ),
      child: Text(label),
    );
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
                      if (value.toInt() >= 0 && value.toInt() < activityData.length) {
                        final date = activityData[value.toInt()].date;
                        return Text("${date.day}/${date.month}");
                      }
                      return Text("");
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
            buildFilterButton(7, "7 Days"),
            buildFilterButton(15, "15 Days"),
            buildFilterButton(30, "30 Days"),
          ],
        ),
      ],
    );
  }
}
