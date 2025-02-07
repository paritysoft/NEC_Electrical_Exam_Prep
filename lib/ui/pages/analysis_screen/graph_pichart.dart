import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../models/activity_data.dart';
import '../../widgets/common_widget.dart';
import '../data/upadansonghro.dart';

class QuizGraphPieChart extends StatefulWidget {
  @override
  _QuizGraphPieChartState createState() => _QuizGraphPieChartState();
}

class _QuizGraphPieChartState extends State<QuizGraphPieChart> {
  int selectedDays = 7; // Default: 7 days
  List<ActivityData> activityData = [];
  bool isLoading = true; // To manage loading state

  @override
  void initState() {
    super.initState();
    fetchActivityData(selectedDays);
  }

  /// Fetch Real Data from the Database
  Future<void> fetchActivityData(int days) async {
    setState(() => isLoading = true);
    UpadanSonghro dbHelper = UpadanSonghro();

    final data = await dbHelper.getActivityDataByDays(days);

    setState(() {
      selectedDays = days;
      activityData = data;

      print("objectdata ${activityData.length}   ${activityData.first.accuracyRate}  ${activityData.first.answeredQuestions}");

      isLoading = false;
    });
  }

  /// Generate Pie Chart Sections
  List<PieChartSectionData> generatePieSections() {
    final totalQuestions = activityData.fold<int>(0, (sum, item) => sum + item.answeredQuestions);

    if (totalQuestions == 0) return [];

    return activityData.map((data) {
      final percentage = (data.answeredQuestions / totalQuestions) * 100;
      return PieChartSectionData(
        value: percentage,
        title: '${percentage.toStringAsFixed(1)}%',
        color: Colors.primaries[activityData.indexOf(data) % Colors.primaries.length],
        radius: 60,
        titleStyle: TextStyle(fontSize: 12, color: Colors.white),
      );
    }).toList();
  }

  /// Custom Button for Selection
  Widget buildFilterButton(int days, String label) {
    return ElevatedButton(
      onPressed: () => fetchActivityData(days),
      style: ElevatedButton.styleFrom(
        backgroundColor: selectedDays == days ? Colors.teal : Colors.grey[300],
        foregroundColor: selectedDays == days ? Colors.white : Colors.black,
      ),
      child: Text(label),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        smallLabel(context, "Quiz Activity (Last $selectedDays Days)"),
        SizedBox(height: 16),
        isLoading
            ? CircularProgressIndicator() // Show loading indicator
            : Container(
          height: 300,
          child: PieChart(
            PieChartData(
              sections: generatePieSections(),
              centerSpaceRadius: 40, // Doughnut-style center space
              borderData: FlBorderData(show: false),
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
