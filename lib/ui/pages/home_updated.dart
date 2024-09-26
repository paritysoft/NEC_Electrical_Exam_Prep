import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:auto_size_text/auto_size_text.dart';

import '../../models/category.dart';
import '../../util/AppColors.dart';
import '../widgets/quiz_options.dart';

import 'package:flutter/material.dart';

import 'bookmark_screen/bookmarks_screen.dart';
import 'explore_screen/explore_screen.dart';
import 'leaderboard_screen/leaderboard_screen.dart';
import 'settings_screen/settings_screen.dart';


class QuizHomePage extends StatefulWidget {

  @override
  State<QuizHomePage> createState() => _QuizHomePageState();
}

class _QuizHomePageState extends State<QuizHomePage> {
  int _currentIndex = 0;
 // Track the selected tab index
  final List<Widget> _pages = [
    ExploreScreen(),
    LeaderboardScreen(),
    BookmarksScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: primary,
        elevation: 0,
        title: const Row(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage('assets/images/avatar.png'), // Replace with actual image asset
              radius: 20,
            ),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Roxane Harley',
                    style: TextStyle(color: Colors.white, fontSize: 18)),
                Text('Expert',
                    style: TextStyle(color: Colors.white70, fontSize: 14)),
              ],
            ),
            Spacer(),
            Column(
              children: [
                Icon(Icons.bolt, color: Colors.orangeAccent, size: 20),
                Text('1200', style: TextStyle(color: Colors.white)),
              ],
            )
          ],
        ),
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, // Ensure this is set to fixed
        backgroundColor: bottomNav,
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.leaderboard),
            label: 'Leaderboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark),
            label: 'Bookmarks',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        selectedItemColor: navigationBottom, // Color for the selected icon
        unselectedItemColor: Colors.grey, // Color for unselected icons
        showUnselectedLabels: true, // Show labels for unselected tabs
      ),

    );
  }
}

