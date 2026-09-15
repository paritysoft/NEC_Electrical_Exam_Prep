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
import 'ui/pages/home_updated.dart';
import 'ui/pages/data/QuestionCache.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'ui/pages/subscription/subscription_service.dart';
import 'package:timezone/data/latest.dart' as tz;

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');

  // Firebase is configured for the mobile apps in this project.
  if (Platform.isAndroid || Platform.isIOS) {
    await Firebase.initializeApp();
  }

  tz.initializeTimeZones();
  if (Platform.isAndroid) {
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
  if (Platform.isAndroid || Platform.isIOS) {
    await flutterLocalNotificationsPlugin.initialize(
      settings: initializationSettings,
    );
  }

  await SubscriptionService.instance.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer = FirebaseAnalyticsObserver(
    analytics: analytics,
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: app_title,
      navigatorObservers: [if (Platform.isAndroid || Platform.isIOS) observer],
      // Attach observer for automatic event tracking
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.light,
      theme: light,
      darkTheme: light,
      home: const StartupScreen(),
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

class StartupScreen extends StatefulWidget {
  const StartupScreen({super.key});
  @override
  State<StartupScreen> createState() => _StartupScreenState();
}

class _StartupScreenState extends State<StartupScreen> {
  late Future<bool> _ready = _load();
  Future<bool> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final completed = prefs.getBool('onboarding_completed') ?? false;
    if (completed) await loadQuestions();
    return completed;
  }

  @override
  Widget build(BuildContext context) => FutureBuilder<bool>(
    future: _ready,
    builder: (context, snapshot) {
      if (snapshot.hasError) {
        return Scaffold(
          body: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Unable to load your questions.'),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: () => setState(() => _ready = _load()),
                  child: const Text('Try again'),
                ),
              ],
            ),
          ),
        );
      }
      if (!snapshot.hasData) {
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      }
      return snapshot.data! ? const QuizHomePage() : const OnboardingScreen();
    },
  );
}
