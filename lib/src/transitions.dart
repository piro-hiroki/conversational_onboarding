import 'package:flutter/material.dart';

import 'controller.dart';
import 'theme.dart';

/// Builds the animated transition between two step widgets.
typedef OnboardingTransitionBuilder = Widget Function(
  Widget child,
  Animation<double> animation,
  OnboardingDirection direction,
);

/// Pick a builder for the requested [OnboardingTransition] preset.
OnboardingTransitionBuilder transitionBuilderFor(OnboardingTransition type) {
  switch (type) {
    case OnboardingTransition.slide:
      return _slide;
    case OnboardingTransition.fadeScale:
      return _fadeScale;
    case OnboardingTransition.parallax:
      return _parallax;
    case OnboardingTransition.morph:
      return _morph;
    case OnboardingTransition.sharedAxis:
      return _sharedAxis;
  }
}

Widget _slide(
  Widget child,
  Animation<double> animation,
  OnboardingDirection direction,
) {
  final begin = direction == OnboardingDirection.backward
      ? const Offset(-1, 0)
      : const Offset(1, 0);
  return SlideTransition(
    position: Tween<Offset>(begin: begin, end: Offset.zero).animate(
      CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
    ),
    child: FadeTransition(opacity: animation, child: child),
  );
}

Widget _fadeScale(
  Widget child,
  Animation<double> animation,
  OnboardingDirection direction,
) {
  final curved =
      CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
  return FadeTransition(
    opacity: curved,
    child: ScaleTransition(
      scale: Tween<double>(begin: 0.96, end: 1).animate(curved),
      child: child,
    ),
  );
}

Widget _parallax(
  Widget child,
  Animation<double> animation,
  OnboardingDirection direction,
) {
  final curved =
      CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
  final dx = direction == OnboardingDirection.backward ? -0.15 : 0.15;
  return ClipRect(
    child: SlideTransition(
      position: Tween<Offset>(begin: Offset(dx, 0), end: Offset.zero)
          .animate(curved),
      child: FadeTransition(opacity: curved, child: child),
    ),
  );
}

Widget _morph(
  Widget child,
  Animation<double> animation,
  OnboardingDirection direction,
) {
  final curved =
      CurvedAnimation(parent: animation, curve: Curves.easeInOutCubic);
  return FadeTransition(
    opacity: curved,
    child: ScaleTransition(
      scale: Tween<double>(begin: 0.85, end: 1).animate(curved),
      child: child,
    ),
  );
}

Widget _sharedAxis(
  Widget child,
  Animation<double> animation,
  OnboardingDirection direction,
) {
  final curved =
      CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
  final dx = direction == OnboardingDirection.backward ? -0.25 : 0.25;
  return FadeTransition(
    opacity: curved,
    child: SlideTransition(
      position:
          Tween<Offset>(begin: Offset(dx, 0), end: Offset.zero).animate(curved),
      child: child,
    ),
  );
}
