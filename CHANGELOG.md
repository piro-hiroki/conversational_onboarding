# Changelog

## 0.1.0

Initial release.

- `OnboardingFlow` host widget with pluggable transitions
  (slide / fade-scale / parallax / morph / shared-axis).
- Declarative step types: `SplashStep`, `InfoStep`, `SingleChoiceStep`,
  `MultiChoiceStep`, `SliderStep`, `TextInputStep`, `DatePickerStep`,
  `RankingStep`, `PermissionPrimingStep`, `PersonalizingStep`,
  `SummaryStep`, `BranchStep`, `CustomStep`.
- Branching via per-choice `nextSteps` and structural `BranchStep`.
- Dynamic progress bar that recomputes when branches change.
- `OnboardingTheme` with colors, option styles, transitions, haptics,
  reduce-motion awareness.
- Built-in `OnboardingLocalizations` for English and Japanese.
- Typed `OnboardingAnswers` map passed to `onComplete`.
- Example app with Cal AI, Duolingo and Headspace templates.
