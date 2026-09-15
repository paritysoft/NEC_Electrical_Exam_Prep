import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:electrician/util/themes.dart';
import 'package:electrician/ui/pages/home_updated.dart';
import 'package:electrician/ui/pages/explore_screen/explore_screen.dart';
import 'package:electrician/ui/pages/explore_screen/practice_by_topic_screen.dart';
import 'package:electrician/ui/pages/data/QuestionCache.dart';
import 'package:electrician/ui/widgets/quiz_session_view.dart';
import 'package:electrician/ui/widgets/responsive_layout.dart';
import 'random_quiz_options_test.dart' show question;

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
    QuestionCache().cacheQuestions([
      for (var i = 0; i < 80; i++) question(i, 1),
    ]);
  });
  for (final platform in [
    TargetPlatform.iOS,
    TargetPlatform.android,
    TargetPlatform.macOS,
    TargetPlatform.windows,
  ]) {
    testWidgets('Home promotions follow platform $platform', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1366, 1024));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await tester.pumpWidget(
        MaterialApp(
          theme: light.copyWith(platform: platform),
          home: const Scaffold(body: ExploreScreen()),
        ),
      );
      await tester.pumpAndSettle();
      final desktop =
          platform == TargetPlatform.macOS ||
          platform == TargetPlatform.windows;
      expect(
        find.text('Learn Without Limits'),
        desktop ? findsOneWidget : findsNothing,
      );
      expect(find.text('Prepare with confidence'), findsOneWidget);
      await tester.ensureVisible(find.text('Random Question'));
      await tester.pumpAndSettle();
      expect(find.text('Random Question').hitTestable(), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }
  for (final size in [
    const Size(320, 568),
    const Size(768, 1024),
    const Size(1440, 900),
  ]) {
    testWidgets('Home and navigation adapt at $size', (tester) async {
      await tester.binding.setSurfaceSize(size);
      addTearDown(() => tester.binding.setSurfaceSize(null));
      var selected = -1;
      await tester.pumpWidget(
        MaterialApp(
          theme: light,
          home: AdaptiveAppShell(
            selectedIndex: 0,
            onSelected: (index) => selected = index,
            child: const ExploreScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Study tools'), findsOneWidget);
      expect(find.text('Learn Without Limits'), findsNothing);
      await tester.ensureVisible(find.text('Random Question'));
      await tester.pumpAndSettle();
      expect(find.text('Random Question').hitTestable(), findsOneWidget);
      expect(
        find.byType(NavigationBar),
        size.width < 700 ? findsOneWidget : findsNothing,
      );
      if (size.width >= 1000) {
        await tester.tap(find.text('Analysis'));
      } else if (size.width >= 700) {
        await tester.tap(find.byTooltip('Analysis'));
      } else {
        await tester.tap(find.text('Analysis'));
      }
      expect(selected, 1);
      await tester.drag(
        find.byType(SingleChildScrollView).first,
        const Offset(0, -500),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });
    testWidgets('Topic cards and quiz actions fit at $size', (tester) async {
      await tester.binding.setSurfaceSize(size);
      addTearDown(() => tester.binding.setSurfaceSize(null));
      String? topic;
      final topics = [
        'Electrical Safety',
        'Branch Circuit Calculations and Conductors',
        'Wiring and Installations',
        'Troubleshooting',
      ];
      await tester.pumpWidget(
        MaterialApp(
          theme: light,
          home: AppScaffold(
            body: TopicSelectionView(
              topics: topics,
              onSelected: (value) => topic = value,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('1. Electrical Safety'));
      expect(topic, 'Electrical Safety');
      expect(tester.takeException(), isNull);
      String? answer;
      var next = 0;
      await tester.pumpWidget(
        MaterialApp(
          theme: light,
          home: Scaffold(
            body: QuizSessionView(
              question:
                  'Which safety procedure should be completed before servicing electrical equipment?',
              options: const [
                'Isolate and verify the supply is de-energized.',
                'Begin work immediately.',
                'Assume the circuit is safe.',
                'Use an untested instrument.',
              ],
              index: 0,
              total: 5,
              selected: null,
              onSelected: (value) => answer = value,
              onNext: () => next++,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      final option = find.text(
        'Isolate and verify the supply is de-energized.',
      );
      await tester.ensureVisible(option);
      await tester.tap(option);
      expect(answer, isNotNull);
      await tester.ensureVisible(find.text('Next'));
      await tester.tap(find.text('Next'));
      expect(next, 1);
      expect(tester.takeException(), isNull);
    });
  }
  testWidgets('Large text and long cards remain scrollable', (tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      MaterialApp(
        theme: light,
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: TextScaler.linear(2)),
          child: child!,
        ),
        home: const Scaffold(body: ExploreScreen()),
      ),
    );
    await tester.pumpAndSettle();
    await tester.drag(
      find.byType(SingleChildScrollView).first,
      const Offset(0, -700),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
}
