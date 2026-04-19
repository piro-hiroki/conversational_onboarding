/// Declarative, conversational onboarding flows for Flutter.
///
/// The entry point is [OnboardingFlow]: pass it a list of [OnboardingStep]s
/// and an `onComplete` callback that receives the collected [OnboardingAnswers].
library;

export 'src/answers.dart';
export 'src/controller.dart';
export 'src/flow.dart';
export 'src/localizations.dart';
export 'src/scope.dart';
export 'src/step.dart';
export 'src/theme.dart';
export 'src/transitions.dart' show OnboardingTransitionBuilder;

export 'src/steps/branch_step.dart';
export 'src/steps/custom_step.dart';
export 'src/steps/date_picker_step.dart';
export 'src/steps/multi_choice_step.dart';
export 'src/steps/permission_priming_step.dart';
export 'src/steps/personalizing_step.dart';
export 'src/steps/ranking_step.dart';
export 'src/steps/single_choice_step.dart';
export 'src/steps/slider_step.dart';
export 'src/steps/splash_step.dart' show SplashStep, InfoStep;
export 'src/steps/step_frame.dart';
export 'src/steps/summary_step.dart';
export 'src/steps/text_input_step.dart';
