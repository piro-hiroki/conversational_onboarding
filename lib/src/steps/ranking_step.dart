import 'package:flutter/material.dart';

import '../controller.dart';
import '../scope.dart';
import '../step.dart';
import 'single_choice_step.dart';
import 'step_frame.dart';

/// Drag-to-reorder ranking step. The answer is a `List<T>` under [id] in
/// priority order (first = highest).
class RankingStep<T> extends OnboardingStep {
  const RankingStep({
    required String super.id,
    required this.question,
    required this.items,
    this.subtitle,
  });

  final String question;
  final String? subtitle;
  final List<Choice<T>> items;

  @override
  Widget build(BuildContext context, OnboardingController controller) {
    return _RankingView<T>(step: this);
  }
}

class _RankingView<T> extends StatefulWidget {
  const _RankingView({required this.step});
  final RankingStep<T> step;
  @override
  State<_RankingView<T>> createState() => _RankingViewState<T>();
}

class _RankingViewState<T> extends State<_RankingView<T>> {
  late List<Choice<T>> _order;

  @override
  void initState() {
    super.initState();
    final controller = OnboardingScope.of(context);
    final stored = controller.answerFor(widget.step.id!) as List<Object?>?;
    if (stored != null) {
      _order = [
        for (final v in stored)
          widget.step.items.firstWhere(
            (c) => c.value == v,
            orElse: () => widget.step.items.first,
          ),
      ];
      final missing =
          widget.step.items.where((c) => !_order.contains(c)).toList();
      _order.addAll(missing);
    } else {
      _order = List<Choice<T>>.from(widget.step.items);
    }
  }

  void _save(OnboardingController controller) {
    controller.setAnswer(widget.step.id!, _order.map((c) => c.value).toList());
  }

  @override
  Widget build(BuildContext context) {
    final controller = OnboardingScope.of(context);
    final theme = controller.theme;

    return StepFrame(
      title: widget.step.question,
      subtitle: widget.step.subtitle,
      showPrimaryAction: true,
      child: ReorderableListView(
        onReorder: (oldIndex, newIndex) {
          setState(() {
            if (newIndex > oldIndex) newIndex -= 1;
            final item = _order.removeAt(oldIndex);
            _order.insert(newIndex, item);
          });
          _save(controller);
        },
        children: [
          for (final (i, item) in _order.indexed)
            Container(
              key: ValueKey(item.value),
              margin: const EdgeInsets.symmetric(vertical: 5),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: theme
                    .resolvePrimary(context)
                    .withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(theme.borderRadius),
              ),
              child: Row(
                children: [
                  Text('${i + 1}.',
                      style: Theme.of(context).textTheme.titleMedium,),
                  const SizedBox(width: 12),
                  if (item.emoji != null)
                    Text(item.emoji!, style: const TextStyle(fontSize: 22)),
                  const SizedBox(width: 8),
                  Expanded(child: Text(item.label)),
                  const Icon(Icons.drag_handle),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
