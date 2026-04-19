import 'dart:async';

import 'package:flutter/material.dart';

import '../controller.dart';
import '../scope.dart';
import '../step.dart';
import 'step_frame.dart';

/// "Analyzing your answers..." style step. Cycles through [messages] and
/// auto-advances after [duration]. Purely theatrical — it exists so flows
/// feel personalized, following the Cal AI / Noom pattern.
class PersonalizingStep extends OnboardingStep {
  const PersonalizingStep({
    super.id,
    required this.messages,
    this.duration = const Duration(seconds: 3),
    this.title,
  });

  final List<String> messages;
  final Duration duration;
  final String? title;

  @override
  Widget build(BuildContext context, OnboardingController controller) {
    return _PersonalizingView(step: this);
  }
}

class _PersonalizingView extends StatefulWidget {
  const _PersonalizingView({required this.step});
  final PersonalizingStep step;
  @override
  State<_PersonalizingView> createState() => _PersonalizingViewState();
}

class _PersonalizingViewState extends State<_PersonalizingView>
    with TickerProviderStateMixin {
  late final AnimationController _progress;
  int _messageIndex = 0;
  Timer? _messageTimer;
  bool _advanced = false;

  @override
  void initState() {
    super.initState();
    _progress = AnimationController(
      vsync: this,
      duration: widget.step.duration,
    )..forward();

    final perMessage = Duration(
      milliseconds:
          (widget.step.duration.inMilliseconds / widget.step.messages.length)
              .round(),
    );
    _messageTimer = Timer.periodic(perMessage, (t) {
      if (!mounted) return;
      setState(() {
        _messageIndex =
            (_messageIndex + 1).clamp(0, widget.step.messages.length - 1);
      });
    });

    _progress.addStatusListener((s) {
      if (s == AnimationStatus.completed && mounted && !_advanced) {
        _advanced = true;
        OnboardingScope.of(context).next();
      }
    });
  }

  @override
  void dispose() {
    _progress.dispose();
    _messageTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = OnboardingScope.of(context);
    final primary = controller.theme.resolvePrimary(context);
    final messages = widget.step.messages;
    final current = messages.isEmpty ? '' : messages[_messageIndex];

    return StepFrame(
      title: widget.step.title,
      centerTitle: true,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 96,
              height: 96,
              child: AnimatedBuilder(
                animation: _progress,
                builder: (context, _) {
                  return CircularProgressIndicator(
                    value: _progress.value,
                    strokeWidth: 6,
                    color: primary,
                    backgroundColor: primary.withValues(alpha: 0.15),
                  );
                },
              ),
            ),
            const SizedBox(height: 32),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Text(
                current,
                key: ValueKey(_messageIndex),
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
