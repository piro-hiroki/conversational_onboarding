import 'package:conversational_onboarding/conversational_onboarding.dart';
import 'package:flutter/material.dart';

class HeadspaceTemplate extends StatelessWidget {
  const HeadspaceTemplate({super.key});

  @override
  Widget build(BuildContext context) {
    return OnboardingFlow(
      theme: const OnboardingTheme(
        primaryColor: Color(0xFFF57C00),
        optionStyle: OptionStyle.list,
        transition: OnboardingTransition.parallax,
        transitionDuration: Duration(milliseconds: 600),
      ),
      onComplete: (answers) => Navigator.of(context).pop(),
      steps: const [
        SplashStep(
          title: 'A gentler mind',
          subtitle: 'Let us tailor a few minutes of calm for you.',
        ),
        MultiChoiceStep<String>(
          id: 'focus',
          question: "What's on your mind lately?",
          maxSelections: 3,
          options: [
            Choice('sleep', 'Trouble sleeping', emoji: '🌙'),
            Choice('stress', 'Work stress', emoji: '💼'),
            Choice('anxiety', 'Anxiety', emoji: '🫧'),
            Choice('focus', 'Focus', emoji: '🎯'),
            Choice('relationships', 'Relationships', emoji: '💞'),
          ],
        ),
        RankingStep<String>(
          id: 'priorities',
          question: 'Order these by priority',
          items: [
            Choice('morning', 'Morning routine'),
            Choice('breaks', 'Midday breaks'),
            Choice('night', 'Wind-down at night'),
          ],
        ),
        PermissionPrimingStep(
          id: 'notifications',
          title: 'Daily reminders',
          rationale: 'A small nudge each day keeps the streak alive.',
          icon: Icons.notifications_active,
        ),
        InfoStep(
          title: 'All set',
          subtitle: 'Take a deep breath. You deserve this.',
          icon: Icons.spa,
        ),
      ],
    );
  }
}
