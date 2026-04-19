import 'package:flutter/material.dart';

import '../controller.dart';
import '../scope.dart';
import '../step.dart';
import 'step_frame.dart';

/// Numeric slider. The answer is stored as a `double` under [id].
class SliderStep extends OnboardingStep {
  const SliderStep({
    required String super.id,
    required this.question,
    required this.min,
    required this.max,
    this.subtitle,
    this.divisions,
    this.initialValue,
    this.unit,
    this.labelBuilder,
  });

  final String question;
  final String? subtitle;
  final double min;
  final double max;
  final int? divisions;
  final double? initialValue;
  final String? unit;
  final String Function(double value)? labelBuilder;

  @override
  Widget build(BuildContext context, OnboardingController controller) {
    return _SliderView(step: this);
  }
}

class _SliderView extends StatefulWidget {
  const _SliderView({required this.step});
  final SliderStep step;
  @override
  State<_SliderView> createState() => _SliderViewState();
}

class _SliderViewState extends State<_SliderView> {
  double? _value;

  @override
  Widget build(BuildContext context) {
    final controller = OnboardingScope.of(context);
    final step = widget.step;
    final stored = controller.answerFor(step.id!);
    final current = _value ??
        (stored is num ? stored.toDouble() : step.initialValue) ??
        ((step.min + step.max) / 2);

    final label = step.labelBuilder?.call(current) ??
        '${current.toStringAsFixed(step.divisions == null ? 1 : 0)}${step.unit ?? ''}';

    return StepFrame(
      title: step.question,
      subtitle: step.subtitle,
      showPrimaryAction: true,
      primaryEnabled: true,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(label,
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    color: controller.theme.resolvePrimary(context),
                    fontWeight: FontWeight.w800,
                  ),),
          const SizedBox(height: 24),
          Slider(
            value: current.clamp(step.min, step.max),
            min: step.min,
            max: step.max,
            divisions: step.divisions,
            onChanged: (v) {
              setState(() => _value = v);
              controller.setAnswer(step.id!, v);
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(step.min.toStringAsFixed(0)),
                Text(step.max.toStringAsFixed(0)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
