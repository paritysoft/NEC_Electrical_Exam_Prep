import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:electrician/ui/pages/data/today_questions_service.dart';
import 'random_quiz_options_test.dart' show question;

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late DateTime now;
  late TodayQuestionsService service;
  final bank = List.generate(35, (i) => question(i + 1, 1));
  setUp(() {
    SharedPreferences.setMockInitialValues({});
    now = DateTime(2026, 9, 10, 23, 59);
    service = TodayQuestionsService(now: () => now);
  });
  test(
    'ordered 1–10 remains stable on reopening even with shuffled input',
    () async {
      final reversed = bank.reversed.toList();
      expect(
        (await service.getTodaysQuestions(reversed)).map((q) => q.id),
        List.generate(10, (i) => i + 1),
      );
      await service.saveAnswers({0: 'A', 1: 'B'});
      final reopened = TodayQuestionsService(now: () => now);
      expect(
        (await reopened.getTodaysQuestions(bank)).map((q) => q.id),
        List.generate(10, (i) => i + 1),
      );
      expect(reopened.answers, {0: 'A', 1: 'B'});
      expect(await reopened.getQuestionsReadToday(), 2);
    },
  );
  test('midnight resets progress and advances to 11–20', () async {
    await service.getTodaysQuestions(bank);
    await service.saveAnswers({0: 'A'});
    now = DateTime(2026, 9, 11);
    expect(await service.getQuestionsReadToday(), 0);
    expect(await service.saveAnswers({0: 'B'}), false);
    expect(
      (await service.getTodaysQuestions(bank)).map((q) => q.id),
      List.generate(10, (i) => i + 11),
    );
    expect(service.answers, isEmpty);
  });
  test('calendar advances across skipped days and wraps at end', () async {
    await service.getTodaysQuestions(bank);
    now = DateTime(2026, 9, 13);
    expect((await service.getTodaysQuestions(bank)).map((q) => q.id), [
      31,
      32,
      33,
      34,
      35,
      1,
      2,
      3,
      4,
      5,
    ]);
    now = DateTime(2026, 9, 14);
    expect((await service.getTodaysQuestions(bank)).first.id, 6);
  });
  test('empty and small banks do not crash or duplicate', () async {
    expect(await service.getTodaysQuestions([]), isEmpty);
    expect(
      (await service.getTodaysQuestions(
        bank.take(3).toList(),
      )).map((q) => q.id),
      [1, 2, 3],
    );
  });
  test('completed quiz stays completed until next day', () async {
    await service.getTodaysQuestions(bank);
    await service.saveAnswers({for (var i = 0; i < 10; i++) i: 'A'});
    await service.getTodaysQuestions(bank);
    expect(await service.getQuestionsReadToday(), 10);
    now = DateTime(2026, 9, 11);
    await service.getTodaysQuestions(bank);
    expect(await service.getQuestionsReadToday(), 0);
  });
  test('legacy next cursor migrates back to same-day batch', () async {
    SharedPreferences.setMockInitialValues({
      'last_access_date': now.toIso8601String(),
      'last_question_index': 20,
      'questions_read_today': 10,
    });
    expect((await service.getTodaysQuestions(bank)).first.id, 11);
    expect(await service.getQuestionsReadToday(), 0);
  });
}
