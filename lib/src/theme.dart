import 'package:flutter/material.dart';

/// Visual style for option widgets.
enum OptionStyle { card, list, pill, grid }

/// Transition preset between steps.
enum OnboardingTransition {
  slide,
  fadeScale,
  parallax,
  morph,
  sharedAxis,
}

/// Theme tokens shared across the flow. Pass to [OnboardingFlow.theme].
@immutable
class OnboardingTheme {
  const OnboardingTheme({
    this.primaryColor,
    this.backgroundColor,
    this.borderRadius = 20,
    this.optionStyle = OptionStyle.card,
    this.transition = OnboardingTransition.slide,
    this.transitionDuration = const Duration(milliseconds: 450),
    this.animationCurve = Curves.easeOutCubic,
    this.hapticEnabled = true,
    this.autoAdvanceDelay = const Duration(milliseconds: 320),
    this.respectReduceMotion = true,
    this.progressBarHeight = 4,
    this.contentPadding = const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
    this.titleTextStyle,
    this.subtitleTextStyle,
    this.optionTextStyle,
    this.primaryButtonStyle,
  });

  final Color? primaryColor;
  final Color? backgroundColor;
  final double borderRadius;
  final OptionStyle optionStyle;
  final OnboardingTransition transition;
  final Duration transitionDuration;
  final Curve animationCurve;
  final bool hapticEnabled;
  final Duration autoAdvanceDelay;
  final bool respectReduceMotion;
  final double progressBarHeight;
  final EdgeInsets contentPadding;
  final TextStyle? titleTextStyle;
  final TextStyle? subtitleTextStyle;
  final TextStyle? optionTextStyle;
  final ButtonStyle? primaryButtonStyle;

  Color resolvePrimary(BuildContext context) =>
      primaryColor ?? Theme.of(context).colorScheme.primary;

  Color resolveBackground(BuildContext context) =>
      backgroundColor ?? Theme.of(context).colorScheme.surface;

  TextStyle resolveTitle(BuildContext context) {
    final base = Theme.of(context).textTheme.headlineSmall ?? const TextStyle(fontSize: 24, fontWeight: FontWeight.w700);
    return titleTextStyle ?? base.copyWith(fontWeight: FontWeight.w700);
  }

  TextStyle resolveSubtitle(BuildContext context) {
    final base = Theme.of(context).textTheme.bodyMedium ?? const TextStyle(fontSize: 15);
    return subtitleTextStyle ?? base.copyWith(color: base.color?.withValues(alpha: 0.7));
  }

  TextStyle resolveOption(BuildContext context) {
    final base = Theme.of(context).textTheme.titleMedium ?? const TextStyle(fontSize: 16);
    return optionTextStyle ?? base;
  }

  OnboardingTheme copyWith({
    Color? primaryColor,
    Color? backgroundColor,
    double? borderRadius,
    OptionStyle? optionStyle,
    OnboardingTransition? transition,
    Duration? transitionDuration,
    Curve? animationCurve,
    bool? hapticEnabled,
    Duration? autoAdvanceDelay,
    bool? respectReduceMotion,
    double? progressBarHeight,
    EdgeInsets? contentPadding,
    TextStyle? titleTextStyle,
    TextStyle? subtitleTextStyle,
    TextStyle? optionTextStyle,
    ButtonStyle? primaryButtonStyle,
  }) {
    return OnboardingTheme(
      primaryColor: primaryColor ?? this.primaryColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      borderRadius: borderRadius ?? this.borderRadius,
      optionStyle: optionStyle ?? this.optionStyle,
      transition: transition ?? this.transition,
      transitionDuration: transitionDuration ?? this.transitionDuration,
      animationCurve: animationCurve ?? this.animationCurve,
      hapticEnabled: hapticEnabled ?? this.hapticEnabled,
      autoAdvanceDelay: autoAdvanceDelay ?? this.autoAdvanceDelay,
      respectReduceMotion: respectReduceMotion ?? this.respectReduceMotion,
      progressBarHeight: progressBarHeight ?? this.progressBarHeight,
      contentPadding: contentPadding ?? this.contentPadding,
      titleTextStyle: titleTextStyle ?? this.titleTextStyle,
      subtitleTextStyle: subtitleTextStyle ?? this.subtitleTextStyle,
      optionTextStyle: optionTextStyle ?? this.optionTextStyle,
      primaryButtonStyle: primaryButtonStyle ?? this.primaryButtonStyle,
    );
  }
}
