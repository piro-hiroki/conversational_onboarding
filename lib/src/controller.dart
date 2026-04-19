import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'answers.dart';
import 'step.dart';
import 'theme.dart';

/// Direction of the most recent navigation transition.
enum OnboardingDirection { forward, backward, none }

/// Drives the onboarding flow: holds answers, resolves the current step
/// list based on branching, and exposes advance / back / jump controls.
class OnboardingController extends ChangeNotifier {
  OnboardingController({
    required List<OnboardingStep> steps,
    OnboardingAnswers initialAnswers = const OnboardingAnswers.empty(),
    OnboardingTheme theme = const OnboardingTheme(),
  })  : _rootSteps = List.unmodifiable(steps),
        _answers = Map<String, Object?>.from(initialAnswers.toMap()),
        _theme = theme {
    _resolved = _flatten(_rootSteps);
    _currentIndex = _resolved.isEmpty ? -1 : 0;
  }

  final List<OnboardingStep> _rootSteps;
  final Map<String, Object?> _answers;
  OnboardingTheme _theme;

  late List<OnboardingStep> _resolved;
  int _currentIndex = -1;
  OnboardingDirection _lastDirection = OnboardingDirection.none;
  bool _completed = false;

  OnboardingTheme get theme => _theme;
  set theme(OnboardingTheme value) {
    if (identical(value, _theme)) return;
    _theme = value;
    notifyListeners();
  }

  /// Flattened list of renderable steps for the current answers.
  List<OnboardingStep> get steps => List.unmodifiable(_resolved);

  /// Index of the currently displayed step within [steps], or `-1` when the
  /// flow has no steps to show.
  int get currentIndex => _currentIndex;

  OnboardingStep? get currentStep =>
      (_currentIndex >= 0 && _currentIndex < _resolved.length)
          ? _resolved[_currentIndex]
          : null;

  /// Total number of steps in the resolved flow. Updates when answers
  /// change the branching outcome.
  int get totalSteps => _resolved.length;

  /// 0.0 – 1.0 progress including the current step.
  double get progress {
    if (_resolved.isEmpty) return 0;
    return (_currentIndex + 1) / _resolved.length;
  }

  OnboardingDirection get lastDirection => _lastDirection;

  bool get isFirst => _currentIndex <= 0;
  bool get isLast => _currentIndex == _resolved.length - 1;
  bool get isCompleted => _completed;

  OnboardingAnswers get answers => OnboardingAnswers(_answers);

  Object? answerFor(String id) => _answers[id];

  /// Record an answer for a step. If [advance] is true and the step is not
  /// the last, automatically moves forward.
  void setAnswer(String id, Object? value, {bool advance = false}) {
    _answers[id] = value;
    _rebuildResolvedPreservingCurrent();
    notifyListeners();
    if (advance) next();
  }

  /// Remove an answer.
  void clearAnswer(String id) {
    _answers.remove(id);
    _rebuildResolvedPreservingCurrent();
    notifyListeners();
  }

  /// Move forward. Triggers the `onComplete` callback via [markCompleted]
  /// when advancing past the last step.
  void next() {
    if (_resolved.isEmpty) {
      _completed = true;
      notifyListeners();
      return;
    }
    if (_currentIndex < _resolved.length - 1) {
      _currentIndex++;
      _lastDirection = OnboardingDirection.forward;
      _maybeHaptic();
      notifyListeners();
    } else {
      markCompleted();
    }
  }

  /// Move backward. No-op on the first step.
  void back() {
    if (_currentIndex > 0) {
      _currentIndex--;
      _lastDirection = OnboardingDirection.backward;
      _maybeHaptic();
      notifyListeners();
    }
  }

  /// Jump to a step by id if it exists in the resolved list.
  void jumpTo(String id) {
    final idx = _resolved.indexWhere((s) => s.id == id);
    if (idx >= 0 && idx != _currentIndex) {
      _lastDirection = idx > _currentIndex
          ? OnboardingDirection.forward
          : OnboardingDirection.backward;
      _currentIndex = idx;
      notifyListeners();
    }
  }

  /// Mark the flow as completed. The host widget watches this to invoke the
  /// user-provided `onComplete` callback.
  void markCompleted() {
    if (_completed) return;
    _completed = true;
    _maybeHaptic(heavy: true);
    notifyListeners();
  }

  void _maybeHaptic({bool heavy = false}) {
    if (!_theme.hapticEnabled) return;
    // HapticFeedback goes through a platform channel, which isn't always
    // available (e.g. unit tests, web without interaction). Swallow async
    // rejection rather than crash the flow.
    final Future<void> f =
        heavy ? HapticFeedback.mediumImpact() : HapticFeedback.selectionClick();
    f.catchError((Object _) {});
  }

  void _rebuildResolvedPreservingCurrent() {
    final previousId = currentStep?.id;
    final previousIndex = _currentIndex;
    _resolved = _flatten(_rootSteps);
    if (_resolved.isEmpty) {
      _currentIndex = -1;
      return;
    }
    if (previousId != null) {
      final newIndex = _resolved.indexWhere((s) => s.id == previousId);
      if (newIndex >= 0) {
        _currentIndex = newIndex;
        return;
      }
    }
    _currentIndex = previousIndex.clamp(0, _resolved.length - 1);
  }

  List<OnboardingStep> _flatten(List<OnboardingStep> steps) {
    final out = <OnboardingStep>[];
    for (final step in steps) {
      if (step.isStructural) {
        out.addAll(_flatten(step.expand(this)));
      } else {
        out.add(step);
        final follow = step.followUps(this);
        if (follow.isNotEmpty) {
          out.addAll(_flatten(follow));
        }
      }
    }
    return out;
  }
}
