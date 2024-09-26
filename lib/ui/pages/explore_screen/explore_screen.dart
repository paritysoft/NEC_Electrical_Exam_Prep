import 'package:flutter/material.dart';

class ExploreScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return   Padding(
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
                      Text('Daily Task', style: TextStyle(fontSize: 18)),
                      Text('14 Questions'),
                      SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: 9 / 14,
                        backgroundColor: Colors.grey[300],
                        color: Colors.orangeAccent,
                      ),
                      SizedBox(height: 8),
                      Text('Progress: 9/14'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),

          // Quiz Section
          Text('Quiz', style: TextStyle(fontSize: 20)),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              QuizCategory(icon: Icons.sports_soccer, label: 'Football'),
              QuizCategory(icon: Icons.science, label: 'Science'),
              QuizCategory(icon: Icons.checkroom, label: 'Fashion'),
              QuizCategory(icon: Icons.movie, label: 'Movie'),
              QuizCategory(icon: Icons.music_note, label: 'Music'),
            ],
          ),
          SizedBox(height: 20),

          // More Games Section
          Text('More Games', style: TextStyle(fontSize: 20)),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              children: [
                GameCard(
                    title: 'Language Quiz',
                    questions: '15 Questions',
                    players: '24.7K',
                    icon: Icons.language),
                GameCard(
                    title: 'Exam Quiz',
                    questions: '12 Questions',
                    players: '12.5K',
                    icon: Icons.compass_calibration),
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

class GameCard extends StatelessWidget {
  final String title;
  final String questions;
  final String players;
  final IconData icon;

  GameCard({
    required this.title,
    required this.questions,
    required this.players,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(icon, size: 40, color: Colors.purple[800]),
          SizedBox(height: 10),
          Text(title, style: TextStyle(fontSize: 16)),
          SizedBox(height: 10),
          Text(questions),
          Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('$players Players'),
              Icon(Icons.bolt, color: Colors.orangeAccent),
            ],
          ),
        ],
      ),
    );
  }
}
