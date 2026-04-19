import 'package:flutter/widgets.dart';

import '../controller.dart';
import '../step.dart';

/// Escape hatch. Renders whatever [builder] returns. Use when none of the
/// built-in step types fit.
class CustomStep extends OnboardingStep {
  const CustomStep({
    super.id,
    required this.builder,
  });

  final Widget Function(BuildContext context, OnboardingController controller)
      builder;

  @override
  Widget build(BuildContext context, OnboardingController controller) =>
      builder(context, controller);
}
