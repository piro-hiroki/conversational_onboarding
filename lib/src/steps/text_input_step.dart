import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../controller.dart';
import '../scope.dart';
import '../step.dart';
import 'step_frame.dart';

/// Free-form text entry. Answer is stored as a `String` under [id].
class TextInputStep extends OnboardingStep {
  const TextInputStep({
    required String super.id,
    required this.question,
    this.subtitle,
    this.hintText,
    this.initialValue,
    this.validator,
    this.keyboardType,
    this.inputFormatters,
    this.maxLength,
    this.obscureText = false,
    this.autofocus = true,
  });

  final String question;
  final String? subtitle;
  final String? hintText;
  final String? initialValue;
  final String? Function(String value)? validator;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLength;
  final bool obscureText;
  final bool autofocus;

  @override
  Widget build(BuildContext context, OnboardingController controller) {
    return _TextInputView(step: this);
  }
}

class _TextInputView extends StatefulWidget {
  const _TextInputView({required this.step});
  final TextInputStep step;
  @override
  State<_TextInputView> createState() => _TextInputViewState();
}

class _TextInputViewState extends State<_TextInputView> {
  late TextEditingController _c;
  String? _error;

  @override
  void initState() {
    super.initState();
    final controller = OnboardingScope.of(context);
    final stored = controller.answerFor(widget.step.id!) as String?;
    _c = TextEditingController(text: stored ?? widget.step.initialValue ?? '');
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  void _submit() {
    final controller = OnboardingScope.of(context);
    final value = _c.text.trim();
    final err = widget.step.validator?.call(value);
    if (err != null) {
      setState(() => _error = err);
      return;
    }
    controller.setAnswer(widget.step.id!, value, advance: true);
  }

  @override
  Widget build(BuildContext context) {
    final step = widget.step;
    return StepFrame(
      title: step.question,
      subtitle: step.subtitle,
      showPrimaryAction: true,
      primaryEnabled: _c.text.trim().isNotEmpty,
      primaryAction: _submit,
      child: TextField(
        controller: _c,
        autofocus: step.autofocus,
        obscureText: step.obscureText,
        keyboardType: step.keyboardType,
        inputFormatters: step.inputFormatters,
        maxLength: step.maxLength,
        onChanged: (_) => setState(() => _error = null),
        onSubmitted: (_) => _submit(),
        decoration: InputDecoration(
          hintText: step.hintText,
          errorText: _error,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
