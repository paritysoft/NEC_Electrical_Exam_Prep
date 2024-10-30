import 'package:shared_preferences/shared_preferences.dart';

import '../dependencyinjection/injection_container.dart';

class SharedPreferenceHelper {
  static setLastPurchaseToken(String lastPurchaseToken) {
    SharedPreferences prefs = serviceLocator<SharedPreferences>();
    prefs.setString("lastPurchaseToken", lastPurchaseToken);
  }

  static String? getLastPurchaseToken() {
    SharedPreferences prefs = serviceLocator<SharedPreferences>();
    return prefs.getString("lastPurchaseToken");
  }

  static setBottomSheetShown(bool isShown) {
    SharedPreferences prefs = serviceLocator<SharedPreferences>();
    prefs.setBool("isBottomSheetShown", isShown);
  }

  static bool? getBottomSheetShown() {
    SharedPreferences prefs = serviceLocator<SharedPreferences>();
    return prefs.getBool("isBottomSheetShown");
  }


  static setSplashVisit(bool isSplash) {
    SharedPreferences prefs = serviceLocator<SharedPreferences>();
    prefs.setBool("SplashVisit", isSplash);
  }

  static bool? getSplashVisit() {
    SharedPreferences prefs = serviceLocator<SharedPreferences>();
    return prefs.getBool("SplashVisit");
  }

  static setYourGoals(String yourGoals) {
    SharedPreferences prefs = serviceLocator<SharedPreferences>();
    prefs.setString("YourGoals", yourGoals);
  }

  static String? getYourGoals() {
    SharedPreferences prefs = serviceLocator<SharedPreferences>();
    return prefs.getString("YourGoals");
  }

  static setPracticeHour(String practiceHour) {
    SharedPreferences prefs = serviceLocator<SharedPreferences>();
    prefs.setString("PracticeHour", practiceHour);
  }

  static String? getPracticeHour() {
    SharedPreferences prefs = serviceLocator<SharedPreferences>();
    return prefs.getString("PracticeHour");
  }

  static setPracticeDays(List<String> practiceDays) {
    SharedPreferences prefs = serviceLocator<SharedPreferences>();
    prefs.setStringList("PracticeDays", practiceDays);
  }

  static List<String>? getPracticeDays() {
    SharedPreferences prefs = serviceLocator<SharedPreferences>();
    return prefs.getStringList("PracticeDays");
  }

  static setExamDate(String examDate) {
    SharedPreferences prefs = serviceLocator<SharedPreferences>();
    prefs.setString("ExamDate", examDate);
  }

  static String? getExamDate() {
    SharedPreferences prefs = serviceLocator<SharedPreferences>();
    return prefs.getString("ExamDate");
  }

  static setSubscription(bool isSubscription) {
    SharedPreferences prefs = serviceLocator<SharedPreferences>();
    prefs.setBool("subscription", isSubscription);
  }

  static bool? getSubscription() {
    SharedPreferences prefs = serviceLocator<SharedPreferences>();
    return prefs.getBool("subscription") ?? false;
  }
}
