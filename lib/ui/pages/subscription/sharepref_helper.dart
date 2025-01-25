import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceHelper {
  static SharedPreferences? _prefs;

  /// Initialize SharedPreferences
  static Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// Reset SharedPreferences
  static Future<void> resetPreferences() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// Set last purchase token
  static Future<void> setLastPurchaseToken(String lastPurchaseToken) async {
    await _prefs?.setString("lastPurchaseToken", lastPurchaseToken);
  }

  static String? getLastPurchaseToken() {
    return _prefs?.getString("lastPurchaseToken");
  }

  static Future<void> setBottomSheetShown(bool isShown) async {
    await _prefs?.setBool("isBottomSheetShown", isShown);
  }

  static bool? getBottomSheetShown() {
    return _prefs?.getBool("isBottomSheetShown");
  }

  static Future<void> setSplashVisit(bool isSplash) async {
    await _prefs?.setBool("SplashVisit", isSplash);
  }

  static bool? getSplashVisit() {
    return _prefs?.getBool("SplashVisit");
  }

  static Future<void> setYourGoals(String yourGoals) async {
    await _prefs?.setString("YourGoals", yourGoals);
  }

  static String? getYourGoals() {
    return _prefs?.getString("YourGoals");
  }

  static Future<void> setPracticeHour(String practiceHour) async {
    await _prefs?.setString("PracticeHour", practiceHour);
  }

  static String? getPracticeHour() {
    return _prefs?.getString("PracticeHour");
  }

  static Future<void> setPracticeDays(List<String> practiceDays) async {
    await _prefs?.setStringList("PracticeDays", practiceDays);
  }

  static List<String>? getPracticeDays() {
    return _prefs?.getStringList("PracticeDays");
  }

  static Future<void> setExamDate(String examDate) async {
    await _prefs?.setString("ExamDate", examDate);
  }

  static String? getExamDate() {
    return _prefs?.getString("ExamDate");
  }

  static Future<void> setSubscription(bool isSubscription) async {
    await _prefs?.setBool("subscription", isSubscription);
  }

  static bool? getSubscription() {
    return _prefs?.getBool("subscription") ?? false;
  }
}
