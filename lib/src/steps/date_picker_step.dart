import 'package:flutter/material.dart';

import '../controller.dart';
import '../scope.dart';
import '../step.dart';
import 'step_frame.dart';

/// Date selection step. Stores the selected [DateTime] under [id].
class DatePickerStep extends OnboardingStep {
  const DatePickerStep({
    required String super.id,
    required this.question,
    this.subtitle,
    this.firstDate,
    this.lastDate,
    this.initialDate,
  });

  final String question;
  final String? subtitle;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final DateTime? initialDate;

  @override
  Widget build(BuildContext context, OnboardingController controller) {
    return _DateView(step: this);
  }
}

class _DateView extends StatelessWidget {
  const _DateView({required this.step});
  final DatePickerStep step;

  @override
  Widget build(BuildContext context) {
    final controller = OnboardingScope.of(context);
    final stored = controller.answerFor(step.id!) as DateTime?;
    final value = stored ?? step.initialDate;

    return StepFrame(
      title: step.question,
      subtitle: step.subtitle,
      showPrimaryAction: true,
      primaryEnabled: value != null,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              value == null
                  ? '--'
                  : '${value.year}-${value.month.toString().padLeft(2, '0')}-${value.day.toString().padLeft(2, '0')}',
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 24),
            OutlinedButton.icon(
              icon: const Icon(Icons.calendar_today),
              label: const Text('Select date'),
              onPressed: () async {
                final now = DateTime.now();
                final picked = await showDatePicker(
                  context: context,
                  initialDate: value ?? now,
                  firstDate: step.firstDate ?? DateTime(now.year - 100),
                  lastDate: step.lastDate ?? DateTime(now.year + 10),
                );
                if (picked != null) {
                  controller.setAnswer(step.id!, picked);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
