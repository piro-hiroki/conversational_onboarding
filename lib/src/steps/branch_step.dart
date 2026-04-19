import 'package:flutter/widgets.dart';

import '../answers.dart';
import '../controller.dart';
import '../step.dart';

/// Structural step. Does not render; expands to one of two branches based
/// on [condition]. Use when per-choice `nextSteps` isn't expressive enough.
class BranchStep extends OnboardingStep {
  const BranchStep({
    required this.condition,
    required this.ifTrue,
    this.ifFalse = const <OnboardingStep>[],
  });

  final bool Function(OnboardingAnswers answers) condition;
  final List<OnboardingStep> ifTrue;
  final List<OnboardingStep> ifFalse;

  @override
  bool get isStructural => true;

  @override
  List<OnboardingStep> expand(OnboardingController controller) {
    return condition(controller.answers) ? ifTrue : ifFalse;
  }

  @override
  Widget build(BuildContext context, OnboardingController controller) {
    return const SizedBox.shrink();
  }
}
