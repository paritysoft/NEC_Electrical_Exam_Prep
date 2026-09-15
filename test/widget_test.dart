import 'package:electrician/ui/pages/data/QuestionCache.dart';
import 'package:electrician/ui/pages/home_updated.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:electrician/main.dart';
import 'package:electrician/ui/pages/onboarding/onboarding_screen.dart';

void main() {
  testWidgets('Returning users go directly home without onboarding', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({'onboarding_completed': true});
    QuestionCache().cacheQuestions([]);
    await tester.pumpWidget(MyApp());
    await tester.pumpAndSettle();
    expect(find.byType(OnboardingScreen), findsNothing);
    expect(find.byType(QuizHomePage), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
    await tester.pumpWidget(MyApp());
    await tester.pumpAndSettle();
    expect(find.byType(QuizHomePage), findsOneWidget);
    expect(find.byType(OnboardingScreen), findsNothing);
  });
  setUp(() => SharedPreferences.setMockInitialValues({}));
  testWidgets('The app opens the responsive onboarding flow', (tester) async {
    await tester.pumpWidget(MyApp());
    await tester.pumpAndSettle();
    expect(find.byType(OnboardingScreen), findsOneWidget);
    expect(find.text('Continue'), findsOneWidget);
    expect(find.byType(FilledButton), findsOneWidget);
  });
}
