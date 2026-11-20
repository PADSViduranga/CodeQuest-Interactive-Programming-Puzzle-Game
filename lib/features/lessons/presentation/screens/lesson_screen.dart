import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_widgets.dart';
import '../../../games/presentation/screens/practice_screen.dart';

class LessonScreen extends StatelessWidget {
  const LessonScreen({super.key});

  static const code = "score = 100\nif score >= 80:\n    print('Great job!')";

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('The branching forest')),
    body: ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
      children: [
        const ProgressBar(value: .35),
        const SizedBox(height: 24),
        const Text('Make decisions with if', style: AppTextStyles.title),
        const SizedBox(height: 8),
        const Text(
          'Teach your code to choose what happens next.',
          style: AppTextStyles.body,
        ),
        const SizedBox(height: 22),
        const MitoBubble(
          message: 'Sometimes code needs to ask a question. The if statement is your decision-making superpower!',
          mood: MitoMood.thinking,
        ),
        const SizedBox(height: 24),
        const SectionTitle('The if statement'),
        const SizedBox(height: 10),
        const Text(
          'Use if to run a block of code only when a condition is true.',
          style: AppTextStyles.body,
        ),
        const SizedBox(height: 14),
        CodeCard(code: code, onCopy: () => _copy(context)),
        const SizedBox(height: 22),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.yellowTint,
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.lightbulb_outline, color: AppColors.yellow),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Tip: Conditions use comparisons like >=, ==, and !=.',
                  style: AppTextStyles.body,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 28),
        AppButton(
          label: 'Start practice',
          icon: Icons.play_arrow_rounded,
          onPressed: () => Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => const PracticeScreen())),
        ),
      ],
    ),
  );

  static Future<void> _copy(BuildContext context) async {
    await Clipboard.setData(const ClipboardData(text: code));
    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Code copied to clipboard')));
    }
  }
}
