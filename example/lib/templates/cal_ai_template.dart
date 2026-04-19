import 'package:conversational_onboarding/conversational_onboarding.dart';
import 'package:flutter/material.dart';

class CalAiTemplate extends StatelessWidget {
  const CalAiTemplate({super.key});

  @override
  Widget build(BuildContext context) {
    return OnboardingFlow(
      theme: const OnboardingTheme(
        primaryColor: Colors.deepPurple,
        optionStyle: OptionStyle.card,
        transition: OnboardingTransition.sharedAxis,
      ),
      onComplete: (answers) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Done! ${answers.toMap()}')),
        );
        Navigator.of(context).pop();
      },
      steps: [
        const SplashStep(
          title: 'Welcome',
          subtitle: 'A quick 6 questions to personalize your plan',
        ),
        const SingleChoiceStep<String>(
          id: 'goal',
          question: "What's your primary goal?",
          options: [
            Choice('lose', 'Lose weight', emoji: '🏃'),
            Choice('maintain', 'Stay healthy', emoji: '✨'),
            Choice('gain', 'Build muscle', emoji: '💪'),
          ],
        ),
        SingleChoiceStep<String>(
          id: 'experience',
          question: "How experienced are you?",
          options: const [
            Choice('beginner', 'Beginner', emoji: '🌱'),
            Choice('intermediate', 'Intermediate', emoji: '🔥'),
            Choice('advanced', 'Advanced', emoji: '⚡'),
          ],
        ),
        BranchStep(
          condition: (a) => a.getString('experience') == 'beginner',
          ifTrue: const [
            InfoStep(
              title: "We'll start gentle",
              subtitle: 'No pressure — small wins compound.',
              icon: Icons.spa_rounded,
            ),
            SliderStep(
              id: 'goal_km',
              question: 'Weekly running distance goal?',
              min: 1,
              max: 20,
              divisions: 19,
              unit: ' km',
            ),
          ],
          ifFalse: const [
            MultiChoiceStep<String>(
              id: 'race_types',
              question: 'Which races appeal to you?',
              options: [
                Choice('5k', '5K'),
                Choice('10k', '10K'),
                Choice('half', 'Half marathon'),
                Choice('full', 'Full marathon'),
                Choice('trail', 'Trail'),
              ],
            ),
            SliderStep(
              id: 'goal_km',
              question: 'Weekly running distance goal?',
              min: 10,
              max: 100,
              divisions: 18,
              unit: ' km',
            ),
          ],
        ),
        TextInputStep(
          id: 'name',
          question: "What's your first name?",
          hintText: 'Your name',
          validator: (v) => v.isEmpty ? 'Please enter your name' : null,
        ),
        const PersonalizingStep(
          messages: [
            'Analyzing your answers…',
            'Building your weekly plan…',
            'Adding finishing touches…',
            'Ready!',
          ],
          duration: Duration(seconds: 3),
        ),
        SummaryStep(
          title: 'Your plan',
          builder: (context, answers) {
            final name = answers.getString('name') ?? 'friend';
            final km = answers.getDouble('goal_km')?.toStringAsFixed(0) ?? '?';
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hi $name!',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 12),
                Text('Weekly goal: $km km'),
                const SizedBox(height: 12),
                Text('Full answers: ${answers.toMap()}'),
              ],
            );
          },
        ),
      ],
    );
  }
}
