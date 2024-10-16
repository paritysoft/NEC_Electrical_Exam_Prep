import 'package:shared_preferences/shared_preferences.dart';

import 'model/ElectricianQuestion.dart';

class TodayQuestionsService {
  static const String _lastDateKey = 'last_access_date';
  static const String _lastIndexKey = 'last_question_index';
  static const String _questionsReadTodayKey = 'questions_read_today';
  static const int _questionsPerDay = 10;

  // Method to fetch today's questions
  Future<List<ElectricianQuestion>> getTodaysQuestions(List<ElectricianQuestion> questionList) async {
    final prefs = await SharedPreferences.getInstance();

    // Get the stored last access date and last index
    String? lastAccessDateStr = prefs.getString(_lastDateKey);
    int lastIndex = prefs.getInt(_lastIndexKey) ?? 0;

    DateTime today = DateTime.now();
    DateTime? lastAccessDate = lastAccessDateStr != null ? DateTime.parse(lastAccessDateStr) : null;

    // If the last access date is null or different from today, reset the index and choose new questions
    if (lastAccessDate == null || !_isSameDay(today, lastAccessDate)) {
      // Pick the next 10 questions starting from lastIndex
      int endIndex = (lastIndex + _questionsPerDay) > questionList.length
          ? questionList.length
          : lastIndex + _questionsPerDay;

      List<ElectricianQuestion> todaysQuestions = questionList.sublist(lastIndex, endIndex);

      // Update index for the next day or wrap around if needed
      int newIndex = endIndex == questionList.length ? 0 : endIndex;
      prefs.setInt(_lastIndexKey, newIndex); // Save the new index

      // Store today's questions in SharedPreferences as a JSON string
      prefs.setString(_lastDateKey, today.toIso8601String()); // Store today's date

      return todaysQuestions;
    }else{
      List<ElectricianQuestion> todaysQuestions = questionList.sublist(lastIndex, lastIndex + _questionsPerDay);
      return todaysQuestions;
    }

    // Fallback: return empty list if something went wrong

  }

  // Helper method to check if two dates are the same day

  // Helper method to check if two dates are the same day
  bool _isSameDay(DateTime date1, DateTime date2) {

    return date1.year == date2.year && date1.month == date2.month && date1.day == date2.day;
  }

  // Separate method to update questionsReadToday value
  Future<void> updateQuestionsReadToday(int questionsRead) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt(_questionsReadTodayKey, questionsRead);
  }

}
