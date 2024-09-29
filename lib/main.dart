import 'package:commonquiz/ui/pages/home_updated.dart';
import 'package:commonquiz/util/app_constants.dart';
import 'package:commonquiz/util/themes.dart';
import 'package:flutter/material.dart';

import 'ui/pages/onboarding/onboarding_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: app_title,
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.system,
        theme: light,
        darkTheme: dark,
        home: OnboardingScreen(),

    );
  }
}
