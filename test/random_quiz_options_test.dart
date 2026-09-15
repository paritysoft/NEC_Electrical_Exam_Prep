import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:electrician/ui/widgets/quiz_options_dialog.dart';
import 'package:electrician/ui/pages/data/model/ElectricianQuestion.dart';

ElectricianQuestion question(int id, int level) => ElectricianQuestion(
  id: id,
  uuid: '$id',
  question: 'Question $id',
  explanation: '',
  incorrectAnswer1: 'B',
  incorrectAnswer2: 'C',
  incorrectAnswer3: 'D',
  correctAnswer: 'A',
  topicName: '',
  category: '',
  level: level,
  status: 0,
  collected: 0,
  reported: 0,
  isLike: 0,
  correctCount: 0,
  incorrectCount: 0,
  givenAnswer: '',
  isDefault: 0,
  examTitle: '',
);
void main() {
  final questions = [
    for (var level = 1; level <= 3; level++)
      for (var i = 0; i < 25; i++) question(level * 100 + i, level),
  ];
  test('Free attempts always use five easy questions and can repeat', () async {
    for (var attempt = 0; attempt < 20; attempt++) {
      final result = await selectRandomQuizQuestions(
        questions,
        isSubscribed: false,
        count: 20,
        difficulty: 'hard',
      );
      expect(result.length, 5);
      expect(result.every((q) => q.level == 1), isTrue);
      expect(result.map((q) => q.id).toSet().length, 5);
    }
  });
  test('Premium respects count and difficulty', () async {
    final result = await selectRandomQuizQuestions(
      questions,
      isSubscribed: true,
      count: 20,
      difficulty: 'medium',
    );
    expect(result.length, 20);
    expect(result.every((q) => q.level == 2), isTrue);
  });
  test('Free mode never falls back to harder questions', () async {
    final result = await selectRandomQuizQuestions(
      [question(1, 3)],
      isSubscribed: false,
      count: 5,
    );
    expect(result, isEmpty);
  });
  for (final subscribed in [false, true]) {
    testWidgets('Options are readable and gated: premium=$subscribed', (
      tester,
    ) async {
      GoogleFonts.config.allowRuntimeFetching = false;
      await tester.binding.setSurfaceSize(const Size(390, 844));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: QuizOptionsDialog(
              category: 'Random Question',
              isSubscribed: subscribed,
            ),
          ),
        ),
      );
      for (final label in [
        '5',
        '10',
        '15',
        '20',
        'Any',
        'Easy',
        'Medium',
        'Hard',
      ]) {
        final finder = find.widgetWithText(ActionChip, label);
        final chip = tester.widget<ActionChip>(finder);
        final enabled = subscribed || label == '5' || label == 'Easy';
        expect(chip.onPressed != null, enabled);
        if (!enabled) {
          expect((chip.label as Text).style!.color, Colors.grey.shade700);
          expect(chip.disabledColor, Colors.grey.shade200);
          expect(chip.avatar, isA<Icon>());
        }
      }
      expect(tester.takeException(), isNull);
    });
  }
}
