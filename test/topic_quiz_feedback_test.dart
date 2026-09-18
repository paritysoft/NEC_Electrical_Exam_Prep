import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:electrician/ui/pages/quiz_page.dart';
import 'package:electrician/ui/widgets/quiz_options_dialog_topic.dart';
import 'random_quiz_options_test.dart' show question;

void main() {
  setUp(() => GoogleFonts.config.allowRuntimeFetching = false);

  testWidgets(
    'Topic dialog selects the final partial range and resets on count change',
    (tester) async {
      final bank = List.generate(35, (i) => question(i + 1, 1));
      List<dynamic>? result;
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => Scaffold(
              body: TextButton(
                onPressed: () async {
                  result = await showDialog(
                    context: context,
                    builder: (_) => QuizOptionsDialogTopic(
                      category: 'Topic',
                      allQuestions: bank,
                    ),
                  );
                },
                child: const Text('Open'),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();
      expect(
        tester
            .widget<FilledButton>(
              find.widgetWithText(FilledButton, 'Start Quiz'),
            )
            .onPressed,
        isNull,
      );
      await tester.tap(find.text('31 – 35'));
      await tester.pump();
      await tester.tap(find.text('10'));
      await tester.pump();
      expect(
        tester
            .widget<FilledButton>(
              find.widgetWithText(FilledButton, 'Start Quiz'),
            )
            .onPressed,
        isNull,
      );
      await tester.tap(find.text('31 – 35'));
      await tester.pump();
      await tester.tap(find.text('Start Quiz'));
      await tester.pumpAndSettle();
      expect(result!.map((q) => q.id), [31, 32, 33, 34, 35]);
      expect(tester.takeException(), isNull);
    },
  );

  for (final answer in ['A', 'B']) {
    testWidgets(
      'Answer $answer reveals feedback, locks choice and resets on Next',
      (tester) async {
        final first = question(1, 1)..explanation = 'Explanation &amp; details';
        await tester.pumpWidget(
          MaterialApp(home: QuizPage(questions: [first, question(2, 1)])),
        );
        expect(find.text('Explanation'), findsNothing);
        await tester.tap(find.text(answer));
        await tester.pump();
        expect(find.text('Your answer: $answer'), findsOneWidget);
        expect(find.text('Correct answer: A'), findsOneWidget);
        expect(find.text('Explanation & details'), findsOneWidget);
        expect(
          find.text(answer == 'A' ? 'Correct!' : 'Incorrect'),
          findsOneWidget,
        );
        for (final tile in tester.widgetList<RadioListTile<String>>(
          find.byType(RadioListTile<String>),
        )) {
          expect(tile.onChanged, isNull);
        }
        await tester.ensureVisible(find.text('Next'));
        await tester.tap(find.text('Next'));
        await tester.pumpAndSettle();
        expect(find.text('Question 2'), findsOneWidget);
        expect(find.text('Explanation'), findsNothing);
        expect(tester.takeException(), isNull);
      },
    );
  }
}
