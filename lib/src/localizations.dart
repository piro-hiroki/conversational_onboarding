import 'package:flutter/material.dart';

/// User-facing strings. Replace by passing a subclass or calling [copyWith].
@immutable
class OnboardingLocalizations {
  const OnboardingLocalizations({
    this.nextLabel = 'Next',
    this.backLabel = 'Back',
    this.skipLabel = 'Skip',
    this.continueLabel = 'Continue',
    this.doneLabel = 'Done',
    this.selectAtLeast = 'Select at least {min}',
    this.selectAtMost = 'Select at most {max}',
    this.requiredField = 'Required',
  });

  final String nextLabel;
  final String backLabel;
  final String skipLabel;
  final String continueLabel;
  final String doneLabel;
  final String selectAtLeast;
  final String selectAtMost;
  final String requiredField;

  static const OnboardingLocalizations en = OnboardingLocalizations();

  static const OnboardingLocalizations ja = OnboardingLocalizations(
    nextLabel: '次へ',
    backLabel: '戻る',
    skipLabel: 'スキップ',
    continueLabel: '続ける',
    doneLabel: '完了',
    selectAtLeast: '{min}個以上選択してください',
    selectAtMost: '{max}個まで選択できます',
    requiredField: '入力してください',
  );

  OnboardingLocalizations copyWith({
    String? nextLabel,
    String? backLabel,
    String? skipLabel,
    String? continueLabel,
    String? doneLabel,
    String? selectAtLeast,
    String? selectAtMost,
    String? requiredField,
  }) {
    return OnboardingLocalizations(
      nextLabel: nextLabel ?? this.nextLabel,
      backLabel: backLabel ?? this.backLabel,
      skipLabel: skipLabel ?? this.skipLabel,
      continueLabel: continueLabel ?? this.continueLabel,
      doneLabel: doneLabel ?? this.doneLabel,
      selectAtLeast: selectAtLeast ?? this.selectAtLeast,
      selectAtMost: selectAtMost ?? this.selectAtMost,
      requiredField: requiredField ?? this.requiredField,
    );
  }
}
