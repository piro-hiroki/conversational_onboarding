# conversational_onboarding

Declarative, conversational onboarding flows for Flutter. Build Cal AI /
Duolingo / Headspace-style onboarding with branching, animations, and a
typed answers map — in ~30 lines.

[![pub package](https://img.shields.io/pub/v/conversational_onboarding.svg)](https://pub.dev/packages/conversational_onboarding)

## Why

Most onboarding packages stop at "swipe through some screens". Modern
high-converting apps instead ask the user a handful of questions, show a
tailored summary, then open the paywall. That pattern is repetitive to
build by hand — state, branching, transitions, progress bars, the
"analyzing your answers…" reveal. This package packages it up.

## Install

```yaml
dependencies:
  conversational_onboarding: ^0.1.0
```

## 30-line example

```dart
import 'package:conversational_onboarding/conversational_onboarding.dart';

OnboardingFlow(
  onComplete: (answers) => Navigator.of(context).pushReplacementNamed('/home'),
  steps: [
    SplashStep(title: 'Welcome', subtitle: 'A few quick questions…'),
    SingleChoiceStep<String>(
      id: 'experience',
      question: 'How experienced are you?',
      options: const [
        Choice('beginner', 'Beginner', emoji: '🌱'),
        Choice('intermediate', 'Intermediate', emoji: '🔥'),
        Choice('advanced', 'Advanced', emoji: '⚡'),
      ],
    ),
    BranchStep(
      condition: (a) => a.getString('experience') == 'beginner',
      ifTrue: const [SliderStep(id: 'goal_km', question: 'Weekly goal?', min: 1, max: 20)],
      ifFalse: const [SliderStep(id: 'goal_km', question: 'Weekly goal?', min: 10, max: 100)],
    ),
    TextInputStep(id: 'name', question: "What's your first name?"),
    const PersonalizingStep(
      messages: ['Analyzing…', 'Building your plan…', 'Ready!'],
      duration: Duration(seconds: 3),
    ),
    SummaryStep(
      title: 'Your plan',
      builder: (ctx, answers) => Text('Hi ${answers.getString('name')}!'),
    ),
  ],
)
```

## Step catalogue

| Step | Purpose |
|---|---|
| `SplashStep` | Intro / welcome with optional animation |
| `InfoStep` | Informational break between questions |
| `SingleChoiceStep` | Pick one. Auto-advances. Card / grid / pill styles |
| `MultiChoiceStep` | Pick several, with min / max constraints |
| `SliderStep` | Numeric input |
| `TextInputStep` | Free-form text, validator, keyboard type |
| `DatePickerStep` | Date selection |
| `RankingStep` | Drag to reorder by priority |
| `PermissionPrimingStep` | Soft-ask before a system permission prompt |
| `PersonalizingStep` | "Analyzing your answers…" theatrical reveal |
| `SummaryStep` | Custom widget that renders the collected answers |
| `BranchStep` | Structural; picks between two sub-lists |
| `CustomStep` | Escape hatch — render any widget |

## Branching

Two mechanisms, use whichever fits:

**Per-choice follow-ups** — a `Choice` can carry its own `nextSteps`, which
are inserted after the choice step:

```dart
SingleChoiceStep<String>(
  id: 'goal',
  question: 'Primary goal?',
  options: const [
    Choice('lose',    'Lose weight',  nextSteps: weightFlow),
    Choice('muscle',  'Build muscle', nextSteps: muscleFlow),
    Choice('health',  'Stay healthy'),
  ],
)
```

**Structural branches** — for more complex conditions:

```dart
BranchStep(
  condition: (a) => a.getInt('age') != null && a.getInt('age')! < 18,
  ifTrue:  [...minorFlow],
  ifFalse: [...adultFlow],
)
```

The progress bar automatically recalculates when branches change.

## Theming

```dart
OnboardingFlow(
  theme: const OnboardingTheme(
    primaryColor: Colors.deepPurple,
    borderRadius: 20,
    optionStyle: OptionStyle.card,     // card / list / pill / grid
    transition: OnboardingTransition.sharedAxis,
    animationCurve: Curves.easeOutCubic,
    hapticEnabled: true,
    respectReduceMotion: true,         // honors OS accessibility setting
  ),
  localizations: OnboardingLocalizations.ja, // built-in EN + JA
  steps: [...],
  onComplete: (_) {},
)
```

## Accessing answers later

`onComplete` receives an `OnboardingAnswers` map with typed accessors:

```dart
onComplete: (answers) {
  final name = answers.getString('name');
  final goalKm = answers.getDouble('goal_km');
  final races = answers.getList<String>('race_types') ?? const [];
  // persist, or push to your home route.
},
```

## Accessibility

- Transitions honor the OS "reduce motion" setting by default.
- All option tiles use standard Material hit targets and
  `HapticFeedback.selectionClick()`.
- Text styles inherit from `Theme.of(context)` so font-size scaling works.

## State management

The package is intentionally free of external state management dependencies.
Internally it uses an `InheritedNotifier` + `ChangeNotifier` — which means
it never conflicts with your Riverpod / Bloc / Provider setup.

If you want to drive the flow from the outside (e.g. to skip to a specific
step from a deep link), pass an `OnboardingController` yourself:

```dart
final controller = OnboardingController(steps: steps);
OnboardingFlow(controller: controller, steps: steps, onComplete: ...);
controller.jumpTo('goal'); // anywhere in your app
```

## Example app

The `example/` folder contains three runnable templates: Cal AI, Duolingo
and Headspace styles.

```bash
cd example
flutter run
```

## License

MIT.
