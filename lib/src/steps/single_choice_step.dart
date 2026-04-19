import 'package:flutter/material.dart';

import '../controller.dart';
import '../scope.dart';
import '../step.dart';
import '../theme.dart';
import 'step_frame.dart';

/// One selectable option in a [SingleChoiceStep] or [MultiChoiceStep].
///
/// [nextSteps] lets a specific choice inject follow-up steps; this is how
/// per-answer branching is expressed without a separate [BranchStep].
@immutable
class Choice<T> {
  const Choice(
    this.value,
    this.label, {
    this.emoji,
    this.icon,
    this.description,
    this.nextSteps = const <OnboardingStep>[],
  });

  final T value;
  final String label;
  final String? emoji;
  final IconData? icon;
  final String? description;
  final List<OnboardingStep> nextSteps;
}

/// Single-choice question. Auto-advances after selection when
/// [autoAdvance] is true (the default).
class SingleChoiceStep<T> extends OnboardingStep {
  const SingleChoiceStep({
    required String super.id,
    required this.question,
    required this.options,
    this.subtitle,
    this.autoAdvance = true,
    this.style,
  });

  final String question;
  final String? subtitle;
  final List<Choice<T>> options;
  final bool autoAdvance;
  final OptionStyle? style;

  @override
  List<OnboardingStep> followUps(OnboardingController controller) {
    final answer = controller.answerFor(id!);
    for (final c in options) {
      if (c.value == answer) return c.nextSteps;
    }
    return const <OnboardingStep>[];
  }

  @override
  Widget build(BuildContext context, OnboardingController controller) {
    return _SingleChoiceView<T>(step: this);
  }
}

class _SingleChoiceView<T> extends StatelessWidget {
  const _SingleChoiceView({required this.step});

  final SingleChoiceStep<T> step;

  @override
  Widget build(BuildContext context) {
    final controller = OnboardingScope.of(context);
    final theme = controller.theme;
    final style = step.style ?? theme.optionStyle;
    final selected = controller.answerFor(step.id!);

    final optionsWidget = switch (style) {
      OptionStyle.grid => _grid(controller, selected),
      OptionStyle.pill => _pills(controller, selected),
      _ => _list(controller, selected),
    };

    return StepFrame(
      title: step.question,
      subtitle: step.subtitle,
      showPrimaryAction: !step.autoAdvance,
      primaryEnabled: selected != null,
      child: optionsWidget,
    );
  }

  Widget _list(OnboardingController controller, Object? selected) {
    return ListView.separated(
      itemCount: step.options.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, i) {
        final option = step.options[i];
        return OptionTile(
          option: _asDynamic(option),
          selected: option.value == selected,
          onTap: () => _pick(controller, option),
        );
      },
    );
  }

  Widget _grid(OnboardingController controller, Object? selected) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1,
      ),
      itemCount: step.options.length,
      itemBuilder: (context, i) {
        final option = step.options[i];
        return OptionTile(
          option: _asDynamic(option),
          selected: option.value == selected,
          onTap: () => _pick(controller, option),
          compact: true,
        );
      },
    );
  }

  Widget _pills(OnboardingController controller, Object? selected) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        for (final option in step.options)
          ChoiceChip(
            label: Text('${option.emoji ?? ''} ${option.label}'.trim()),
            selected: option.value == selected,
            onSelected: (_) => _pick(controller, option),
          ),
      ],
    );
  }

  void _pick(OnboardingController controller, Choice<T> option) {
    controller.setAnswer(step.id!, option.value, advance: step.autoAdvance);
  }

  Choice<Object?> _asDynamic(Choice<T> c) => Choice<Object?>(
        c.value,
        c.label,
        emoji: c.emoji,
        icon: c.icon,
        description: c.description,
      );
}

/// Reusable option tile so custom steps can reuse the same visual style.
class OptionTile extends StatelessWidget {
  const OptionTile({
    super.key,
    required this.option,
    required this.selected,
    required this.onTap,
    this.compact = false,
  });

  final Choice<Object?> option;
  final bool selected;
  final VoidCallback onTap;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final controller = OnboardingScope.of(context);
    final theme = controller.theme;
    final primary = theme.resolvePrimary(context);
    final radius = BorderRadius.circular(theme.borderRadius);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOutCubic,
      decoration: BoxDecoration(
        color: selected
            ? primary.withValues(alpha: 0.12)
            : Theme.of(context)
                .colorScheme
                .surfaceContainerHighest
                .withValues(alpha: 0.5),
        borderRadius: radius,
        border: Border.all(
          color: selected ? primary : Colors.transparent,
          width: 2,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: radius,
          child: Padding(
            padding: EdgeInsets.all(compact ? 12 : 16),
            child: compact ? _compact(context) : _row(context),
          ),
        ),
      ),
    );
  }

  Widget _row(BuildContext context) {
    final controller = OnboardingScope.of(context);
    final textStyle = controller.theme.resolveOption(context);
    return Row(
      children: [
        if (option.emoji != null)
          Text(option.emoji!, style: const TextStyle(fontSize: 28)),
        if (option.icon != null)
          Icon(option.icon,
              size: 28, color: controller.theme.resolvePrimary(context),),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(option.label, style: textStyle),
              if (option.description != null)
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Text(option.description!,
                      style: Theme.of(context).textTheme.bodySmall,),
                ),
            ],
          ),
        ),
        AnimatedOpacity(
          duration: const Duration(milliseconds: 200),
          opacity: selected ? 1 : 0,
          child: Icon(Icons.check_circle,
              color: controller.theme.resolvePrimary(context),),
        ),
      ],
    );
  }

  Widget _compact(BuildContext context) {
    final controller = OnboardingScope.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (option.emoji != null)
          Text(option.emoji!, style: const TextStyle(fontSize: 36)),
        if (option.icon != null)
          Icon(option.icon,
              size: 36, color: controller.theme.resolvePrimary(context),),
        const SizedBox(height: 8),
        Text(
          option.label,
          style: controller.theme.resolveOption(context),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
