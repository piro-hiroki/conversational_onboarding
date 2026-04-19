import 'package:flutter/material.dart';

import 'answers.dart';
import 'controller.dart';
import 'localizations.dart';
import 'scope.dart';
import 'step.dart';
import 'theme.dart';
import 'transitions.dart';

/// Top-level widget. Hosts an [OnboardingController], renders the current
/// step, handles transitions, and invokes [onComplete] when the flow ends.
///
/// ```dart
/// OnboardingFlow(
///   onComplete: (answers) => context.go('/home'),
///   steps: [
///     SplashStep(title: 'Welcome'),
///     SingleChoiceStep(
///       id: 'experience',
///       question: 'How experienced are you?',
///       options: [
///         Choice('beginner', 'Beginner'),
///         Choice('advanced', 'Advanced'),
///       ],
///     ),
///   ],
/// )
/// ```
class OnboardingFlow extends StatefulWidget {
  const OnboardingFlow({
    super.key,
    required this.steps,
    required this.onComplete,
    this.theme = const OnboardingTheme(),
    this.localizations = OnboardingLocalizations.en,
    this.initialAnswers = const OnboardingAnswers.empty(),
    this.showProgressBar = true,
    this.showBackButton = true,
    this.onStepChanged,
    this.controller,
  });

  final List<OnboardingStep> steps;
  final void Function(OnboardingAnswers answers) onComplete;
  final OnboardingTheme theme;
  final OnboardingLocalizations localizations;
  final OnboardingAnswers initialAnswers;
  final bool showProgressBar;
  final bool showBackButton;
  final void Function(int index, OnboardingStep step)? onStepChanged;

  /// Optional externally owned controller. When supplied, the host widget
  /// will not dispose it.
  final OnboardingController? controller;

  @override
  State<OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends State<OnboardingFlow> {
  late OnboardingController _controller;
  bool _ownsController = false;
  int _lastReportedIndex = -1;
  bool _didComplete = false;

  @override
  void initState() {
    super.initState();
    if (widget.controller != null) {
      _controller = widget.controller!;
    } else {
      _controller = OnboardingController(
        steps: widget.steps,
        initialAnswers: widget.initialAnswers,
        theme: widget.theme,
      );
      _ownsController = true;
    }
    _controller.addListener(_onControllerChanged);
  }

  @override
  void didUpdateWidget(OnboardingFlow oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!identical(oldWidget.theme, widget.theme)) {
      _controller.theme = widget.theme;
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerChanged);
    if (_ownsController) _controller.dispose();
    super.dispose();
  }

  void _onControllerChanged() {
    final idx = _controller.currentIndex;
    if (idx != _lastReportedIndex && idx >= 0) {
      _lastReportedIndex = idx;
      final step = _controller.currentStep;
      if (step != null) widget.onStepChanged?.call(idx, step);
    }
    if (_controller.isCompleted && !_didComplete) {
      _didComplete = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) widget.onComplete(_controller.answers);
      });
    }
    setState(() {});
  }

  Future<bool> _onWillPop() async {
    if (_controller.currentIndex > 0) {
      _controller.back();
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final theme = _controller.theme;
    final step = _controller.currentStep;
    final disableMotion =
        theme.respectReduceMotion && MediaQuery.of(context).disableAnimations;
    final duration =
        disableMotion ? Duration.zero : theme.transitionDuration;
    final transitionBuilder = transitionBuilderFor(theme.transition);

    return OnboardingScope(
      controller: _controller,
      localizations: widget.localizations,
      child: PopScope(
        canPop: _controller.currentIndex == 0,
        onPopInvokedWithResult: (didPop, _) {
          if (!didPop) _onWillPop();
        },
        child: Scaffold(
          backgroundColor: theme.resolveBackground(context),
          body: SafeArea(
            child: Column(
              children: [
                if (widget.showBackButton || widget.showProgressBar)
                  _HeaderBar(
                    showBack: widget.showBackButton,
                    showProgress: widget.showProgressBar,
                  ),
                Expanded(
                  child: AnimatedSwitcher(
                    duration: duration,
                    switchInCurve: theme.animationCurve,
                    switchOutCurve: theme.animationCurve,
                    transitionBuilder: (child, animation) {
                      return transitionBuilder(
                        child,
                        animation,
                        _controller.lastDirection,
                      );
                    },
                    layoutBuilder: (current, previous) => Stack(
                      alignment: Alignment.center,
                      children: [...previous, if (current != null) current],
                    ),
                    child: step == null
                        ? const SizedBox.expand(key: ValueKey('__empty__'))
                        : KeyedSubtree(
                            key: ValueKey(
                              'step_${_controller.currentIndex}_${step.id ?? step.runtimeType}',
                            ),
                            child: Builder(
                              builder: (innerContext) =>
                                  step.build(innerContext, _controller),
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _HeaderBar extends StatelessWidget {
  const _HeaderBar({required this.showBack, required this.showProgress});
  final bool showBack;
  final bool showProgress;

  @override
  Widget build(BuildContext context) {
    final controller = OnboardingScope.of(context);
    final theme = controller.theme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 16, 0),
      child: Row(
        children: [
          SizedBox(
            width: 48,
            height: 48,
            child: showBack && !controller.isFirst
                ? IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: controller.back,
                  )
                : const SizedBox.shrink(),
          ),
          if (showProgress)
            Expanded(
              child: TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 350),
                curve: Curves.easeOutCubic,
                tween: Tween<double>(begin: 0, end: controller.progress),
                builder: (context, value, _) {
                  return ClipRRect(
                    borderRadius:
                        BorderRadius.circular(theme.progressBarHeight),
                    child: LinearProgressIndicator(
                      value: value,
                      minHeight: theme.progressBarHeight,
                      backgroundColor: theme
                          .resolvePrimary(context)
                          .withValues(alpha: 0.12),
                      valueColor: AlwaysStoppedAnimation<Color>(
                          theme.resolvePrimary(context),),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
