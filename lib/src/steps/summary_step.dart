import 'package:flutter/material.dart';

import '../answers.dart';
import '../controller.dart';
import '../scope.dart';
import '../step.dart';
import 'step_frame.dart';

/// Final review screen. Use [builder] to render a custom summary of the
/// collected answers; tapping the primary action completes the flow.
class SummaryStep extends OnboardingStep {
  const SummaryStep({
    super.id,
    this.title,
    this.subtitle,
    required this.builder,
  });

  final String? title;
  final String? subtitle;
  final Widget Function(BuildContext context, OnboardingAnswers answers)
      builder;

  @override
  Widget build(BuildContext context, OnboardingController controller) {
    return StepFrame(
      title: title,
      subtitle: subtitle,
      showPrimaryAction: true,
      child: SingleChildScrollView(
        child: builder(context, OnboardingScope.of(context).answers),
      ),
    );
  }
}
