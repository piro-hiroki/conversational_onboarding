import 'package:flutter/material.dart';

import '../controller.dart';
import '../step.dart';
import 'step_frame.dart';

/// Display-only step for a welcome or intro screen. Shows an optional
/// [animation] widget above the title and an explicit Continue button.
class SplashStep extends OnboardingStep {
  const SplashStep({
    super.id,
    required this.title,
    this.subtitle,
    this.animation,
    this.continueLabel,
  });

  final String title;
  final String? subtitle;
  final Widget? animation;
  final String? continueLabel;

  @override
  Widget build(BuildContext context, OnboardingController controller) {
    return StepFrame(
      title: title,
      subtitle: subtitle,
      centerTitle: true,
      showPrimaryAction: true,
      child: Center(
        child: animation ?? const SizedBox.shrink(),
      ),
    );
  }
}

/// Display-only informational step, identical to [SplashStep] but typically
/// used mid-flow to give context before the next question.
class InfoStep extends OnboardingStep {
  const InfoStep({
    super.id,
    required this.title,
    this.subtitle,
    this.icon,
    this.child,
  });

  final String title;
  final String? subtitle;
  final IconData? icon;
  final Widget? child;

  @override
  Widget build(BuildContext context, OnboardingController controller) {
    return StepFrame(
      title: title,
      subtitle: subtitle,
      centerTitle: true,
      showPrimaryAction: true,
      child: Center(
        child: child ??
            (icon != null
                ? Icon(icon, size: 96, color: controller.theme.resolvePrimary(context))
                : const SizedBox.shrink()),
      ),
    );
  }
}
