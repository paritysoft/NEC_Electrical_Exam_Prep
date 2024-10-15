import 'package:shared_preferences/shared_preferences.dart';

import 'model/ElectricianQuestion.dart';

class TodayQuestionsService {
  static const String _lastDateKey = 'last_access_date';
  static const String _lastIndexKey = 'last_question_index';
  static const String _questionsReadTodayKey = 'questions_read_today';
  static const int _questionsPerDay = 10;



  TodayQuestionsService();

  // Method to fetch today's questions
  Future<List<ElectricianQuestion>> getTodaysQuestions( List<ElectricianQuestion> questions) async {
    final prefs = await SharedPreferences.getInstance();

    // Get the stored last access date, index, and how many questions have been read today
    String? lastAccessDateStr = prefs.getString(_lastDateKey);
    int lastIndex = prefs.getInt(_lastIndexKey) ?? 0;
    int questionsReadToday = prefs.getInt(_questionsReadTodayKey) ?? 0;

    DateTime today = DateTime.now();
    DateTime? lastAccessDate = lastAccessDateStr != null ? DateTime.parse(lastAccessDateStr) : null;

    // If the date has changed, reset the index and questions read today count
    if (lastAccessDate == null || !_isSameDay(today, lastAccessDate)) {
      lastIndex = 0; // Start from the beginning each new day
      questionsReadToday = 0; // Reset the number of questions read today
      prefs.setString(_lastDateKey, today.toIso8601String());
    }

    // Calculate how many questions can still be retrieved today
    int remainingQuestionsToday = _questionsPerDay - questionsReadToday;
    if (remainingQuestionsToday <= 0) {
      // If the daily limit has already been reached, return an empty list
      return [];
    }

    // Get the next set of questions based on last index and remaining questions today
    int endIndex = (lastIndex + remainingQuestionsToday) > questions.length
        ? questions.length
        : lastIndex + remainingQuestionsToday;

    List<ElectricianQuestion> todaysQuestions = questions.sublist(lastIndex, endIndex);
    print("questionList today ${todaysQuestions.length}  $lastIndex  $endIndex");

    // Update the last index for tomorrow
    int newIndex = endIndex == questions.length ? 0 : endIndex; // Reset index if the end is reached
    prefs.setInt(_lastIndexKey, newIndex);

    // Update the number of questions read today
    await _updateQuestionsReadToday(todaysQuestions.length);
    print("questionList today ${todaysQuestions.length}");


    return todaysQuestions;
  }

  // Separate method to update questionsReadToday value
  Future<void> _updateQuestionsReadToday(int questionsRead) async {
    final prefs = await SharedPreferences.getInstance();
    int currentQuestionsReadToday = prefs.getInt(_questionsReadTodayKey) ?? 0;

    // Update the number of questions read today
    currentQuestionsReadToday += questionsRead;
    prefs.setInt(_questionsReadTodayKey, currentQuestionsReadToday);
  }

  // Helper method to check if two dates are the same day
  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year && date1.month == date2.month && date1.day == date2.day;
  }
}