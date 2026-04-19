import 'package:flutter/material.dart';

import 'templates/cal_ai_template.dart';
import 'templates/duolingo_template.dart';
import 'templates/headspace_template.dart';

void main() => runApp(const ExampleApp());

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'conversational_onboarding demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const _Home(),
    );
  }
}

class _Home extends StatelessWidget {
  const _Home();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Onboarding templates')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _TemplateCard(
            title: 'Cal AI style',
            subtitle: 'Health / fitness, analyzing-your-plan reveal',
            color: Colors.deepPurple,
            onTap: () => _open(context, const CalAiTemplate()),
          ),
          const SizedBox(height: 12),
          _TemplateCard(
            title: 'Duolingo style',
            subtitle: 'Learning app, level + goal + mascot',
            color: Colors.green,
            onTap: () => _open(context, const DuolingoTemplate()),
          ),
          const SizedBox(height: 12),
          _TemplateCard(
            title: 'Headspace style',
            subtitle: 'Wellness, softer pacing',
            color: Colors.orange,
            onTap: () => _open(context, const HeadspaceTemplate()),
          ),
        ],
      ),
    );
  }

  void _open(BuildContext context, Widget child) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => child));
  }
}

class _TemplateCard extends StatelessWidget {
  const _TemplateCard({
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [color.withValues(alpha: 0.8), color],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.9),
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
