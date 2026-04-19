import 'package:conversational_onboarding/conversational_onboarding.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('OnboardingFlow advances and fires onComplete with answers',
      (tester) async {
    OnboardingAnswers? captured;

    await tester.pumpWidget(
      MaterialApp(
        home: OnboardingFlow(
          onComplete: (a) => captured = a,
          theme: const OnboardingTheme(
            transitionDuration: Duration.zero,
            autoAdvanceDelay: Duration.zero,
          ),
          steps: const [
            SplashStep(title: 'Welcome'),
            SingleChoiceStep<String>(
              id: 'pick',
              question: 'Pick one',
              options: [
                Choice('a', 'Option A'),
                Choice('b', 'Option B'),
              ],
            ),
            SummaryStep(
              title: 'Summary',
              builder: _summary,
            ),
          ],
        ),
      ),
    );

    expect(find.text('Welcome'), findsOneWidget);

    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();

    expect(find.text('Pick one'), findsOneWidget);

    await tester.tap(find.text('Option A'));
    await tester.pumpAndSettle();

    expect(find.text('Summary'), findsOneWidget);
    expect(find.text('Picked: a'), findsOneWidget);

    await tester.tap(find.text('Done'));
    await tester.pumpAndSettle();

    expect(captured, isNotNull);
    expect(captured!.getString('pick'), 'a');
  });

  testWidgets('Back button returns to the previous step', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: OnboardingFlow(
          onComplete: (_) {},
          theme: const OnboardingTheme(transitionDuration: Duration.zero),
          steps: const [
            SplashStep(title: 'First'),
            SplashStep(title: 'Second'),
          ],
        ),
      ),
    );

    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    expect(find.text('Second'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();
    expect(find.text('First'), findsOneWidget);
  });
}

Widget _summary(BuildContext context, OnboardingAnswers answers) {
  return Text('Picked: ${answers.getString('pick')}');
}
