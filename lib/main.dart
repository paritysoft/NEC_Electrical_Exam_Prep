
import 'dart:io';

import 'package:electrician/subscription/presentation/subscription/bloc/provider_list.dart';
import 'package:electrician/util/app_constants.dart';
import 'package:electrician/util/notification.dart';
import 'package:electrician/util/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import '../subscription/dependencyinjection/injection_container.dart' as ic;
import 'ui/pages/onboarding/onboarding_screen.dart';
import 'package:timezone/data/latest.dart' as tz;

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  tz.initializeTimeZones();
  if(!Platform.isMacOS){
    await checkAndRequestExactAlarmPermission();
  }

  ic.init();

  // Initialize the notifications
  const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
  const DarwinInitializationSettings initializationSettingsIOS = DarwinInitializationSettings();
  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
  );
  if(!Platform.isMacOS) {
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: providers,
      child: MaterialApp(
          title: app_title,
          debugShowCheckedModeBanner: false,
          themeMode: ThemeMode.light,
          theme: light,
          darkTheme: light,
          home: const OnboardingScreen(),

      ),
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