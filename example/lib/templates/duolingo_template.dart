import 'package:conversational_onboarding/conversational_onboarding.dart';
import 'package:flutter/material.dart';

class DuolingoTemplate extends StatelessWidget {
  const DuolingoTemplate({super.key});

  @override
  Widget build(BuildContext context) {
    return OnboardingFlow(
      theme: const OnboardingTheme(
        primaryColor: Color(0xFF58CC02),
        optionStyle: OptionStyle.card,
        transition: OnboardingTransition.fadeScale,
        borderRadius: 16,
      ),
      onComplete: (answers) => Navigator.of(context).pop(),
      steps: const [
        SplashStep(
          title: 'Learn a new language',
          subtitle: 'Free. Fun. Effective.',
        ),
        SingleChoiceStep<String>(
          id: 'language',
          question: 'Which language?',
          style: OptionStyle.grid,
          options: [
            Choice('es', 'Spanish', emoji: '🇪🇸'),
            Choice('fr', 'French', emoji: '🇫🇷'),
            Choice('ja', 'Japanese', emoji: '🇯🇵'),
            Choice('de', 'German', emoji: '🇩🇪'),
          ],
        ),
        SingleChoiceStep<String>(
          id: 'level',
          question: 'How much do you already know?',
          options: [
            Choice('zero', 'Nothing yet', emoji: '🌱'),
            Choice('some', 'A little', emoji: '🌿'),
            Choice('lots', 'A lot', emoji: '🌳'),
          ],
        ),
        SliderStep(
          id: 'daily_minutes',
          question: 'Daily goal?',
          min: 5,
          max: 60,
          divisions: 11,
          unit: ' min',
        ),
        InfoStep(
          title: "Let's go!",
          subtitle: 'Your mascot is waiting.',
          icon: Icons.pets,
        ),
      ],
    );
  }
}
