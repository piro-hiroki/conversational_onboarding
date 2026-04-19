import 'package:flutter/widgets.dart';

import 'controller.dart';

/// Base class for every onboarding step.
///
/// A step either renders its own UI ([build]) or expands into a sub-list of
/// steps ([expand]) — the latter is how branching works.
///
/// Steps are declarative: the same instance may be rebuilt many times as
/// answers change. Do not store mutable runtime state on a step; use the
/// [OnboardingController] (via [OnboardingScope.of]) instead.
abstract class OnboardingStep {
  const OnboardingStep({this.id});

  /// Optional identifier used to key the answer stored for this step.
  ///
  /// Display-only steps ([SplashStep], [InfoStep], [PersonalizingStep])
  /// typically omit the id. Steps that collect input must supply one so the
  /// final `answers` map is unambiguous.
  final String? id;

  /// Whether this step is purely structural (produces child steps rather
  /// than rendering its own UI). [BranchStep] returns `true`.
  bool get isStructural => false;

  /// Expand into child steps. Only called when [isStructural] is true.
  List<OnboardingStep> expand(OnboardingController controller) =>
      const <OnboardingStep>[];

  /// Optional follow-up steps to inject after this step, computed from the
  /// answer that was just recorded. [SingleChoiceStep] uses this to support
  /// per-choice branching.
  List<OnboardingStep> followUps(OnboardingController controller) =>
      const <OnboardingStep>[];

  /// Render the step.
  Widget build(BuildContext context, OnboardingController controller);
}
