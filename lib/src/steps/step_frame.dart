import 'package:flutter/material.dart';

import '../scope.dart';

/// Shared chrome for step content: consistent padding, optional title and
/// subtitle, and an optional primary action button pinned to the bottom.
class StepFrame extends StatelessWidget {
  const StepFrame({
    super.key,
    this.title,
    this.subtitle,
    required this.child,
    this.primaryAction,
    this.showPrimaryAction = false,
    this.primaryEnabled = true,
    this.footer,
    this.centerTitle = false,
  });

  final String? title;
  final String? subtitle;
  final Widget child;
  final VoidCallback? primaryAction;
  final bool showPrimaryAction;
  final bool primaryEnabled;
  final Widget? footer;
  final bool centerTitle;

  @override
  Widget build(BuildContext context) {
    final controller = OnboardingScope.of(context);
    final l10n = OnboardingScope.localizationsOf(context);
    final theme = controller.theme;
    final alignment = centerTitle ? CrossAxisAlignment.center : CrossAxisAlignment.start;
    final textAlign = centerTitle ? TextAlign.center : TextAlign.start;

    return Padding(
      padding: theme.contentPadding,
      child: Column(
        crossAxisAlignment: alignment,
        children: [
          if (title != null) ...[
            const SizedBox(height: 8),
            Text(title!, style: theme.resolveTitle(context), textAlign: textAlign),
          ],
          if (subtitle != null) ...[
            const SizedBox(height: 8),
            Text(subtitle!, style: theme.resolveSubtitle(context), textAlign: textAlign),
          ],
          const SizedBox(height: 16),
          Expanded(child: child),
          if (footer != null) footer!,
          if (showPrimaryAction) ...[
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                style: theme.primaryButtonStyle,
                onPressed: primaryEnabled
                    ? (primaryAction ?? controller.next)
                    : null,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  child: Text(
                    controller.isLast ? l10n.doneLabel : l10n.continueLabel,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ],
      ),
    );
  }
}
