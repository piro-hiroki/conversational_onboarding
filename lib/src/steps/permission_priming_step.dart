import 'package:flutter/material.dart';

import '../controller.dart';
import '../step.dart';
import 'step_frame.dart';

/// Soft-ask before a system permission prompt. The package stays
/// permission-agnostic: call your own permission logic in [onAllowTap] and
/// advance/retreat explicitly via the provided controller. The Boolean the
/// user records (allow vs skip) is stored under [id] for downstream steps.
class PermissionPrimingStep extends OnboardingStep {
  const PermissionPrimingStep({
    required String super.id,
    required this.title,
    required this.rationale,
    this.icon,
    this.allowLabel = 'Allow',
    this.skipLabel = 'Not now',
    this.onAllowTap,
  });

  final String title;
  final String rationale;
  final IconData? icon;
  final String allowLabel;
  final String skipLabel;
  final Future<bool> Function(BuildContext context)? onAllowTap;

  @override
  Widget build(BuildContext context, OnboardingController controller) {
    return StepFrame(
      title: title,
      subtitle: rationale,
      centerTitle: true,
      footer: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () async {
                final granted = await onAllowTap?.call(context) ?? true;
                controller.setAnswer(id!, granted, advance: true);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: Text(allowLabel),
              ),
            ),
          ),
          TextButton(
            onPressed: () => controller.setAnswer(id!, false, advance: true),
            child: Text(skipLabel),
          ),
        ],
      ),
      child: Center(
        child: Icon(
          icon ?? Icons.notifications_active,
          size: 96,
          color: controller.theme.resolvePrimary(context),
        ),
      ),
    );
  }
}
