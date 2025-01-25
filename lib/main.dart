import 'dart:io';
import 'package:electrician/util/app_constants.dart';
import 'package:electrician/util/notification.dart';
import 'package:electrician/util/themes.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'ui/pages/onboarding/onboarding_screen.dart';
import 'package:timezone/data/latest.dart' as tz;

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');

  await Firebase.initializeApp(); // Initialize Firebase

  tz.initializeTimeZones();
  if (!Platform.isMacOS) {
    await checkAndRequestExactAlarmPermission();
  }


  // Initialize the notifications
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  const DarwinInitializationSettings initializationSettingsIOS =
      DarwinInitializationSettings();
  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
  );
  if (!Platform.isMacOS) {
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: app_title,
        navigatorObservers: [observer],
        // Attach observer for automatic event tracking
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.light,
        theme: light,
        darkTheme: light,
        home: const OnboardingScreen(),

    );
  }
}
// final sl = GetIt.instance;
//
// Future<void> setup() async {
//   // Register SharedPreferences
//   final sharedPreferences = await SharedPreferences.getInstance();
//   sl.registerSingleton<SharedPreferences>(sharedPreferences);
//
// }


