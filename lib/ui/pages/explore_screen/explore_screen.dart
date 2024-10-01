import 'package:flutter/material.dart';
import '../../../util/app_constants.dart';
import '../../widgets/common_widget.dart';
import '../../widgets/quiz_options.dart';

class ExploreScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Daily Task Card
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Icon(Icons.anchor, color: Colors.purple, size: 40),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      smallLabel(
                        context,
                        'Daily Task',
                      ),
                      smallLabel(context, '10 Questions'),
                      SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: 7 / 10,
                        backgroundColor: Colors.grey[300],
                        color: Colors.orangeAccent,
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                              flex: 1,
                              child: smallLabel(context, 'Progress: ')),
                          Expanded(
                              flex: 1,
                              child: smallLabel(context, '7/10',
                                  alignment: TextAlign.end))
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: sizeBox16),

          // Quiz Section
          // Text('Quiz', style: TextStyle(fontSize: 20)),
          // SizedBox(height: 10),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     QuizCategory(icon: Icons.sports_soccer, label: 'Football'),
          //     QuizCategory(icon: Icons.science, label: 'Science'),
          //     QuizCategory(icon: Icons.checkroom, label: 'Fashion'),
          //     QuizCategory(icon: Icons.movie, label: 'Movie'),
          //     QuizCategory(icon: Icons.music_note, label: 'Music'),
          //   ],
          // ),

          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.amber[600],
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              //Center Row contents horizontally,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Opacity(
                  opacity: 0.5,
                  child: Image.asset("assets/images/ic_premium.png",
                      height: 20, width: 20, fit: BoxFit.cover),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(4, 4, 4, 4),
                  child: Center(
                      child: title15BoldColor(context, 'Unlock All Features')),
                ),
                Opacity(
                  opacity: 0.3,
                  child: Image.asset("assets/images/ic_premium.png",
                      height: 20, width: 20, fit: BoxFit.cover),
                ),
              ],
            ),
          ),
          // More Games Section
          SizedBox(height: sizeBox16),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              children: [
                QuizCard(
                    title: 'Random Question',
                    questions: '10 Questions',
                    isPremium: false,
                    icon: Icons.language,
                    onTap: () {
                      _categoryPressed(context, "Random Question");

                    }),
                QuizCard(
                    title: 'Practice By Topic',
                    questions: '1200 Questions',
                    isPremium: true,
                    icon: Icons.compass_calibration,
                    onTap: () {}),
                QuizCard(
                    title: 'Mock Quiz',
                    questions: 'Overcome your fears',
                    isPremium: true,
                    icon: Icons.language,
                    onTap: () {}),
                QuizCard(
                    title: 'Time Quiz',
                    questions: 'Beat the Clock',
                    isPremium: true,
                    icon: Icons.compass_calibration,
                    onTap: () {}),
                QuizCard(
                    title: 'Your Questions',
                    questions: 'Challenge Your Knowledge',
                    isPremium: true,
                    icon: Icons.compass_calibration,
                    onTap: () {}),
                QuizCard(
                    title: 'Records',
                    questions: 'Preserve Your Achievements',
                    isPremium: true,
                    icon: Icons.compass_calibration,
                    onTap: () {}),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class QuizCategory extends StatelessWidget {
  final IconData icon;
  final String label;

  QuizCategory({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: Colors.purple[100],
          child: Icon(icon, color: Colors.purple[800]),
          radius: 30,
        ),
        SizedBox(height: 8),
        Text(label, style: TextStyle(color: Colors.purple[800])),
      ],
    );
  }
}

class QuizCard extends StatelessWidget {
  final String title;
  final String questions;
  final bool isPremium;
  final IconData icon;
  final VoidCallback onTap;

  QuizCard({
    required this.title,
    required this.questions,
    required this.isPremium,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, size: 40, color: Colors.purple[800]),
                if (isPremium)
                  Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.deepOrange,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: smallLabel(context, "Premium",
                          color: Colors.white, textSize: 6))
              ],
            ),
            SizedBox(height: 10),
            smallLabel(context, title),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: smallLabel(context, questions, textSize: 10),
                ),
                Icon(Icons.bolt, color: Colors.orangeAccent, size: 16),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

_categoryPressed(BuildContext context, String category) {
  showModalBottomSheet(
    context: context,
    builder: (sheetContext) => BottomSheet(
      builder: (_) => QuizOptionsDialog(
        category: category,
      ),
      onClosing: () {},
    ),
  );
}
