import 'package:commonquiz/ui/pages/analysis_screen/quiz_activity_graph.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'CategoryQuestionDataList.dart';

class AnalysisScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Overview Section with circular chart
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade200,
                  spreadRadius: 1,
                  blurRadius: 10,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                // Circular Accuracy Chart
                QuizActivityGraph(),
                SizedBox(
                  height: 120,
                  width: 120,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CircularProgressIndicator(
                        value: 0, // Change this value dynamically
                        strokeWidth: 10,
                        backgroundColor: Colors.grey.shade200,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.blue,
                        ),
                      ),
                      Text(
                        '0%',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                // Stats Overview
                Text('Accuracy Rate', style: TextStyle(color: Colors.grey)),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    StatItem(title: 'Answered Questions', value: '0'),

                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 16),

          // Study Continuity Section
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade200,
                  spreadRadius: 1,
                  blurRadius: 10,
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ContinuityItem(title: 'Quiz', value: '0'),
                ContinuityItem(title: 'SQID', value: '0'),
                ContinuityItem(title: 'Longest Streak', value: '0 Days'),
              ],
            ),
          ),
          SizedBox(height: 16),

          // Test Record Section with Graph
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade200,
                  spreadRadius: 1,
                  blurRadius: 10,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Test Record'),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    FilterButton(label: '7 Days'),
                    FilterButton(label: '30 Days'),
                    FilterButton(label: '90 Days'),
                  ],
                ),
                SizedBox(height: 16),
                // Graph

                SizedBox(
                  height: 150,
                  child: LineChart(
                    LineChartData(
                      gridData: FlGridData(show: false),
                      borderData: FlBorderData(show: false),
                      titlesData: FlTitlesData(show: false),
                      lineBarsData: [
                        LineChartBarData(
                          spots: [
                            FlSpot(0, 1),
                            FlSpot(1, 1),
                            FlSpot(2, 0),
                            FlSpot(3, 3),
                            FlSpot(4, 2),
                          ],
                          isCurved: true,
                          dotData: FlDotData(show: false),
                          belowBarData: BarAreaData(show: false),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16),

          Container(height: 600, child: CategoryQuestionDataList()),
          // Subject Analysis Section
          // Text('Subject Analysis', style: TextStyle(fontWeight: FontWeight.bold)),
          // SizedBox(height: 8),
          // SubjectCard(
          //   title: 'Definitions, Calculations, Theory, and Plans',
          //   correct: 0,
          //   missed: 0,
          //   unanswered: 218,
          //   accuracy: 0,
          // ),
          // SubjectCard(
          //   title: 'Electrical Services, Service Equipment, and Derived Systems',
          //   correct: 0,
          //   missed: 0,
          //   unanswered: 175,
          //   accuracy: 0,
          // ),
          // SubjectCard(
          //   title: 'Electrical Feeders',
          //   correct: 0,
          //   missed: 0,
          //   unanswered: 161,
          //   accuracy: 0,
          // ),
          // SubjectCard(
          //   title: 'Branch Circuit Calculations and Conductors',
          //   correct: 0,
          //   missed: 0,
          //   unanswered: 204,
          //   accuracy: 0,
          // ),
          // SubjectCard(
          //   title: 'Electrical Wiring Methods and Materials',
          //   correct: 0,
          //   missed: 0,
          //   unanswered: 174,
          //   accuracy: 0,
          // ),
        ],
      ),
    );
  }
}

// Stat Item Widget
class StatItem extends StatelessWidget {
  final String title;
  final String value;

  const StatItem({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 4),
        Text(title, style: TextStyle(color: Colors.grey)),
      ],
    );
  }
}

// Continuity Item Widget
class ContinuityItem extends StatelessWidget {
  final String title;
  final String value;

  const ContinuityItem({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 4),
        Text(title, style: TextStyle(color: Colors.grey)),
      ],
    );
  }
}

// Filter Button Widget
class FilterButton extends StatelessWidget {
  final String label;

  const FilterButton({required this.label});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.orange, backgroundColor: Colors.orange.shade100,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: Text(label),
    );
  }
}

// Subject Analysis Card
class SubjectCard extends StatelessWidget {
  final String title;
  final int correct;
  final int missed;
  final int unanswered;
  final double accuracy;

  const SubjectCard({
    required this.title,
    required this.correct,
    required this.missed,
    required this.unanswered,
    required this.accuracy,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            spreadRadius: 1,
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LinearProgressIndicator(
                      value: accuracy,
                      backgroundColor: Colors.grey.shade200,
                      color: Colors.green,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Correct Questions: $correct',
                      style: TextStyle(color: Colors.green),
                    ),
                    Text(
                      'Missed Questions: $missed',
                      style: TextStyle(color: Colors.red),
                    ),
                    Text(
                      'UnAnswered Questions: $unanswered',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}