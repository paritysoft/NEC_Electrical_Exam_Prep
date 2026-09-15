import 'dart:async';
import 'package:electrician/ui/pages/data/QuestionCache.dart';
import 'package:electrician/ui/pages/home_updated.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:electrician/ui/pages/onboarding/onboarding_screen.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));
  testWidgets('Failed loading can retry without completing onboarding early', (
    tester,
  ) async {
    var attempts = 0;
    var completed = 0;
    final pending = Completer<void>();
    await tester.pumpWidget(
      MaterialApp(
        home: OnboardingScreen(
          prepareQuestions: () async {
            attempts++;
            if (attempts == 1) throw StateError('Database unavailable');
            await pending.future;
          },
          onComplete: () => completed++,
        ),
      ),
    );
    await tester.pumpAndSettle();
    final button = find.byKey(const ValueKey('onboarding-next'));
    for (var page = 0; page < 3; page++) {
      await tester.tap(button);
      await tester.pumpAndSettle();
    }
    await tester.tap(button);
    await tester.pumpAndSettle();
    expect(
      find.text('Unable to load your questions. Please try again.'),
      findsOneWidget,
    );
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getBool('onboarding_completed'), isNot(isTrue));
    expect(completed, 0);
    await tester.pump(const Duration(seconds: 5));
    await tester.pumpAndSettle();
    await tester.tap(button);
    await tester.pump();
    expect(find.text('Loading…'), findsOneWidget);
    expect(tester.widget<FilledButton>(button).onPressed, isNull);
    expect(prefs.getBool('onboarding_completed'), isNot(isTrue));
    pending.complete();
    await tester.pumpAndSettle();
    expect(attempts, 2);
    expect(completed, 1);
    expect(prefs.getBool('onboarding_completed'), isTrue);
    expect(tester.takeException(), isNull);
  });
  testWidgets('Get Started opens home through the production navigation path', (
    tester,
  ) async {
    QuestionCache().cacheQuestions([]);
    addTearDown(() => QuestionCache().clearCache());
    await tester.pumpWidget(const MaterialApp(home: OnboardingScreen()));
    await tester.pumpAndSettle();
    final button = find.byKey(const ValueKey('onboarding-next'));
    for (var page = 0; page < 3; page++) {
      await tester.tap(button);
      await tester.pumpAndSettle();
    }
    await tester.tap(button);
    await tester.pumpAndSettle();
    expect(find.byType(QuizHomePage), findsOneWidget);
    expect(find.byType(OnboardingScreen), findsNothing);
    expect(tester.takeException(), isNull);
  });
  for (final size in [
    const Size(320, 568),
    const Size(390, 844),
    const Size(844, 390),
    const Size(1024, 1366),
  ]) {
    testWidgets('Responsive navigation at $size', (tester) async {
      await tester.binding.setSurfaceSize(size);
      addTearDown(() => tester.binding.setSurfaceSize(null));
      var completed = 0;
      await tester.pumpWidget(
        MaterialApp(home: OnboardingScreen(onComplete: () => completed++)),
      );
      await tester.pumpAndSettle();
      final button = find.byKey(const ValueKey('onboarding-next'));
      expect(tester.getSize(button).height, greaterThanOrEqualTo(56));
      // The whole colored button responds, including its edge.
      await tester.tapAt(tester.getTopLeft(button) + const Offset(14, 28));
      await tester.pumpAndSettle();
      expect(find.byTooltip('Back'), findsOneWidget);
      await tester.tap(find.byTooltip('Back'));
      await tester.pumpAndSettle();
      expect(find.byTooltip('Back'), findsNothing);
      for (var page = 0; page < 3; page++) {
        await tester.tap(button);
        await tester.pumpAndSettle();
      }
      expect(find.text('Get Started'), findsOneWidget);
      await tester.tap(button);
      await tester.tap(button);
      await tester.pumpAndSettle();
      await tester.pumpAndSettle();
      expect(completed, 1);
      expect(
        (await SharedPreferences.getInstance()).getBool('onboarding_completed'),
        isTrue,
      );
      expect(tester.takeException(), isNull);
    });
  }
  testWidgets('Skip completes once and large text keeps controls visible', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(320, 568));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    var completed = 0;
    await tester.pumpWidget(
      MaterialApp(
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: TextScaler.linear(2)),
          child: child!,
        ),
        home: OnboardingScreen(onComplete: () => completed++),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Continue').hitTestable(), findsOneWidget);
    await tester.tap(find.text('Skip'));
    await tester.tap(find.text('Skip'));
    await tester.pumpAndSettle();
    expect(completed, 1);
    expect(tester.takeException(), isNull);
  });
  testWidgets('Swiping updates the footer', (tester) async {
    await tester.pumpWidget(
      MaterialApp(home: OnboardingScreen(onComplete: () {})),
    );
    await tester.pumpAndSettle();
    await tester.drag(find.byType(PageView), const Offset(-700, 0));
    await tester.pumpAndSettle();
    expect(find.byTooltip('Back'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
