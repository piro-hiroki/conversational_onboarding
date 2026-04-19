import 'package:flutter/widgets.dart';

import 'controller.dart';
import 'localizations.dart';

/// Provides the [OnboardingController] and [OnboardingLocalizations] to
/// descendant step widgets. Access with [OnboardingScope.of].
class OnboardingScope extends InheritedNotifier<OnboardingController> {
  const OnboardingScope({
    super.key,
    required OnboardingController controller,
    required this.localizations,
    required super.child,
  }) : super(notifier: controller);

  final OnboardingLocalizations localizations;

  OnboardingController get controller => notifier!;

  static OnboardingController of(BuildContext context) {
    final scope =
        context.dependOnInheritedWidgetOfExactType<OnboardingScope>();
    assert(scope != null, 'No OnboardingScope found in context');
    return scope!.controller;
  }

  static OnboardingLocalizations localizationsOf(BuildContext context) {
    final scope =
        context.dependOnInheritedWidgetOfExactType<OnboardingScope>();
    return scope?.localizations ?? OnboardingLocalizations.en;
  }

  @override
  bool updateShouldNotify(OnboardingScope oldWidget) {
    return super.updateShouldNotify(oldWidget) ||
        oldWidget.localizations != localizations;
  }
}
