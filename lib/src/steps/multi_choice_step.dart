import 'package:flutter/material.dart';

import '../controller.dart';
import '../scope.dart';
import '../step.dart';
import 'single_choice_step.dart';
import 'step_frame.dart';

/// Multiple-select question. Stores a `List` of selected values under [id].
///
/// [minSelections] and [maxSelections] constrain how many can be chosen.
class MultiChoiceStep<T> extends OnboardingStep {
  const MultiChoiceStep({
    required String super.id,
    required this.question,
    required this.options,
    this.subtitle,
    this.minSelections = 1,
    this.maxSelections,
  });

  final String question;
  final String? subtitle;
  final List<Choice<T>> options;
  final int minSelections;
  final int? maxSelections;

  @override
  Widget build(BuildContext context, OnboardingController controller) {
    return _MultiChoiceView<T>(step: this);
  }
}

class _MultiChoiceView<T> extends StatelessWidget {
  const _MultiChoiceView({required this.step});

  final MultiChoiceStep<T> step;

  @override
  Widget build(BuildContext context) {
    final controller = OnboardingScope.of(context);
    final current = controller.answerFor(step.id!) as List<Object?>? ?? const [];
    final canContinue = current.length >= step.minSelections;

    return StepFrame(
      title: step.question,
      subtitle: step.subtitle,
      showPrimaryAction: true,
      primaryEnabled: canContinue,
      child: ListView.separated(
        itemCount: step.options.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (context, i) {
          final option = step.options[i];
          final selected = current.contains(option.value);
          return OptionTile(
            option: Choice<Object?>(
              option.value,
              option.label,
              emoji: option.emoji,
              icon: option.icon,
              description: option.description,
            ),
            selected: selected,
            onTap: () => _toggle(controller, current, option, selected),
          );
        },
      ),
    );
  }

  void _toggle(
    OnboardingController controller,
    List<Object?> current,
    Choice<T> option,
    bool selected,
  ) {
    final next = List<T>.from(current.whereType<T>());
    if (selected) {
      next.remove(option.value);
    } else {
      if (step.maxSelections != null && next.length >= step.maxSelections!) {
        return;
      }
      next.add(option.value);
    }
    controller.setAnswer(step.id!, next);
  }
}
