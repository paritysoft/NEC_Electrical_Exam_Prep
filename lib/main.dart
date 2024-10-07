import 'package:commonquiz/util/app_constants.dart';
import 'package:commonquiz/util/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'ui/pages/onboarding/onboarding_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: app_title,
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.system,
        theme: light,
        darkTheme: dark,
        home: const OnboardingScreen(),

    );
  }
}
