import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'model/ElectricianQuestion.dart';

/// A stable batch for each local calendar day, in database ID order.
class TodayQuestionsService {
  TodayQuestionsService({DateTime Function()? now})
    : _now = now ?? DateTime.now;
  final DateTime Function() _now;
  static const _key = 'daily_quiz_v2';
  Map<String, dynamic>? _session;

  String get currentDay {
    final now = _now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }

  Map<int, dynamic> get answers => {
    for (final entry in ((_session?['answers'] as Map?) ?? {}).entries)
      int.parse(entry.key.toString()): entry.value,
  };

  Future<List<ElectricianQuestion>> getTodaysQuestions(
    List<ElectricianQuestion> questions,
  ) async {
    if (questions.isEmpty) return [];
    final ordered = List<ElectricianQuestion>.of(questions)
      ..sort((a, b) {
        final result = (a.id ?? 0).compareTo(b.id ?? 0);
        return result == 0 ? a.uuid.compareTo(b.uuid) : result;
      });
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_key);
    _session = saved == null
        ? null
        : Map<String, dynamic>.from(jsonDecode(saved));
    var start = (_session?['start'] as int?) ?? 0;
    if (_session == null) {
      // The old cursor stored the NEXT day's start, even on the same day.
      final legacyDate = DateTime.tryParse(
        prefs.getString('last_access_date') ?? '',
      );
      final next = prefs.getInt('last_question_index') ?? 0;
      if (legacyDate != null) {
        final legacyDay = DateTime(
          legacyDate.year,
          legacyDate.month,
          legacyDate.day,
        ).toString().substring(0, 10);
        start = legacyDay == currentDay
            ? (next == 0 ? ((ordered.length - 1) ~/ 10) * 10 : next - 10)
            : next;
      }
    } else if (_session!['day'] != currentDay) {
      // UTC date-only arithmetic avoids daylight-saving 23/25-hour days.
      final previous = DateTime.parse('${_session!['day']}T00:00:00Z');
      final today = DateTime.parse('${currentDay}T00:00:00Z');
      final days = today.difference(previous).inDays;
      start += (days > 0 ? days : 0) * 10;
    }
    start %= ordered.length;
    if (_session == null || _session!['day'] != currentDay) {
      _session = {
        'day': currentDay,
        'start': start,
        'answers': <String, dynamic>{},
      };
      await prefs.setString(_key, jsonEncode(_session));
      await prefs.setInt('questions_read_today', 0);
    }
    // Wrap only after exhausting the bank; never duplicate within a small bank.
    final count = ordered.length < 10 ? ordered.length : 10;
    return List.generate(count, (i) => ordered[(start + i) % ordered.length]);
  }

  Future<int> getQuestionsReadToday() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_key);
    if (saved == null) return 0;
    final session = jsonDecode(saved) as Map;
    return session['day'] == currentDay
        ? (session['answers'] as Map).length
        : 0;
  }

  /// Ignore a submission from yesterday if midnight passed while it was open.
  Future<bool> saveAnswers(Map<int, dynamic> answers) async {
    if (_session == null || _session!['day'] != currentDay) return false;
    final prefs = await SharedPreferences.getInstance();
    _session!['answers'] = {
      for (final entry in answers.entries) '${entry.key}': entry.value,
    };
    await prefs.setString(_key, jsonEncode(_session));
    await prefs.setInt('questions_read_today', answers.length);
    return true;
  }
}
