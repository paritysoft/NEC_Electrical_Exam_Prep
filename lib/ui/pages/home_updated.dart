import 'package:electrician/util/app_constants.dart';
import 'package:flutter/material.dart';
import '../../subscription/core/sharepref_helper.dart';
import '../../subscription/presentation/subscription/screen/subscription_page.dart';
import '../../util/AppColors.dart';
import '../widgets/common_widget.dart';
import '../widgets/quiz_options_dialog.dart';
import 'analysis_screen/analysis_screen.dart';
import 'data/upadansonghro.dart';
import 'explore_screen/explore_screen.dart';
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
    AnalysisScreen(),
    SettingsScreen(),
  ];

  @override
  void initState() {
    super.initState();
    if (SharedPreferenceHelper.getSubscription() == false) {
      gotToSubscriptionPage(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: primary,
        elevation: 0,
        title: Row(
          children: [
            const CircleAvatar(
              backgroundImage: AssetImage('assets/images/avatar.png'), // Replace with actual image asset
              radius: 20,
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                smallLabel(context, app_title,
                    color: Colors.white),
              ],
            ),
            const Spacer(),
            const Column(
              children: [
                Icon(Icons.bolt, color: Colors.orangeAccent, size: 20),
               // Text('1200', style: TextStyle(color: Colors.white)),
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
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.leaderboard),
          //   label: 'Leaderboard',
          // ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark),
            label: 'Analysis',
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


