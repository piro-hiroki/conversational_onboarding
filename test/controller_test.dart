import 'package:conversational_onboarding/conversational_onboarding.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

class _Dummy extends OnboardingStep {
  const _Dummy({required String super.id});
  @override
  Widget build(BuildContext context, OnboardingController controller) =>
      const SizedBox.shrink();
}

void main() {
  group('OnboardingController', () {
    test('advances through a flat list and completes past the end', () {
      final c = OnboardingController(
        steps: const [
          _Dummy(id: 'a'),
          _Dummy(id: 'b'),
          _Dummy(id: 'c'),
        ],
      );

      expect(c.totalSteps, 3);
      expect(c.currentStep!.id, 'a');
      c.next();
      expect(c.currentStep!.id, 'b');
      c.next();
      expect(c.currentStep!.id, 'c');
      expect(c.isLast, isTrue);
      expect(c.isCompleted, isFalse);
      c.next();
      expect(c.isCompleted, isTrue);
    });

    test('back() is a no-op on the first step', () {
      final c = OnboardingController(steps: const [_Dummy(id: 'a')]);
      c.back();
      expect(c.currentIndex, 0);
    });

    test('BranchStep switches path based on answers', () {
      final c = OnboardingController(
        steps: [
          const _Dummy(id: 'start'),
          BranchStep(
            condition: (a) => a.getString('start') == 'yes',
            ifTrue: const [_Dummy(id: 'yes_1'), _Dummy(id: 'yes_2')],
            ifFalse: const [_Dummy(id: 'no_1')],
          ),
        ],
      );

      expect(c.steps.map((s) => s.id), ['start', 'no_1']);
      c.setAnswer('start', 'yes');
      expect(c.steps.map((s) => s.id), ['start', 'yes_1', 'yes_2']);
      expect(c.totalSteps, 3);
    });

    test('Choice.nextSteps inject follow-up steps', () {
      final c = OnboardingController(
        steps: const [
          SingleChoiceStep<String>(
            id: 'pick',
            question: 'Q',
            options: [
              Choice('a', 'A', nextSteps: [_Dummy(id: 'extra_a')]),
              Choice('b', 'B'),
            ],
          ),
          _Dummy(id: 'end'),
        ],
      );
      expect(c.steps.map((s) => s.id), ['pick', 'end']);

      c.setAnswer('pick', 'a');
      expect(c.steps.map((s) => s.id), ['pick', 'extra_a', 'end']);

      c.setAnswer('pick', 'b');
      expect(c.steps.map((s) => s.id), ['pick', 'end']);
    });

    test('progress reflects dynamic total', () {
      final c = OnboardingController(
        steps: [
          const _Dummy(id: 'a'),
          BranchStep(
            condition: (a) => a.getBool('flag') ?? false,
            ifTrue: const [_Dummy(id: 'x'), _Dummy(id: 'y')],
          ),
        ],
      );
      expect(c.totalSteps, 1);
      expect(c.progress, closeTo(1.0, 1e-9));
      c.setAnswer('flag', true);
      expect(c.totalSteps, 3);
      expect(c.progress, closeTo(1 / 3, 1e-9));
    });
  });

  group('OnboardingController (more)', () {
    test('jumpTo moves to a step by id', () {
      final c = OnboardingController(
        steps: const [
          _Dummy(id: 'a'),
          _Dummy(id: 'b'),
          _Dummy(id: 'c'),
        ],
      );
      c.jumpTo('c');
      expect(c.currentStep!.id, 'c');
      c.jumpTo('a');
      expect(c.currentStep!.id, 'a');
    });

    test('changing answer off a follow-up reclamps the index', () {
      final c = OnboardingController(
        steps: const [
          SingleChoiceStep<String>(
            id: 'pick',
            question: 'Q',
            options: [
              Choice('a', 'A', nextSteps: [_Dummy(id: 'extra_a')]),
              Choice('b', 'B'),
            ],
          ),
          _Dummy(id: 'end'),
        ],
      );
      c.setAnswer('pick', 'a');
      c.next();
      expect(c.currentStep!.id, 'extra_a');
      c.setAnswer('pick', 'b');
      // extra_a no longer exists; controller should not crash and should
      // point at a valid step.
      expect(c.currentStep, isNotNull);
      expect(c.steps.map((s) => s.id), ['pick', 'end']);
    });
  });

  group('OnboardingAnswers', () {
    test('typed getters coerce correctly', () {
      const a = OnboardingAnswers.empty();
      expect(a.getString('x'), isNull);

      final b = OnboardingAnswers(
        const <String, Object?>{'n': 2, 'd': 1.5, 's': 'hi', 'l': [1, 2]},
      );
      expect(b.getInt('n'), 2);
      expect(b.getDouble('n'), 2.0);
      expect(b.getDouble('d'), 1.5);
      expect(b.getString('s'), 'hi');
      expect(b.getList<int>('l'), [1, 2]);
    });
  });
}
