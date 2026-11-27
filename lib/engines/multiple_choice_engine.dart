import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';

class MultipleChoiceEngine extends StatefulWidget {
  final String question;
  final List<String> options;
  final String correctAnswer;
  final ValueChanged<bool> onAnswered;
  final Set<String> hiddenOptions;

  const MultipleChoiceEngine({
    super.key,
    required this.question,
    required this.options,
    required this.correctAnswer,
    required this.onAnswered,
    this.hiddenOptions = const {},
  });

  @override
  State<MultipleChoiceEngine> createState() => _MultipleChoiceEngineState();
}

class _MultipleChoiceEngineState extends State<MultipleChoiceEngine> {
  String? selected;
  bool submitted = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          widget.question,
          style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 18),
        ...widget.options.where((o) => !widget.hiddenOptions.contains(o)).map((
          option,
        ) {
          final isSelected = selected == option;
          final isCorrect = submitted && option == widget.correctAnswer;
          final isWrong = submitted && isSelected && !isCorrect;
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.all(15),
                alignment: Alignment.centerLeft,
                backgroundColor: isCorrect
                    ? AppColors.greenTint
                    : isWrong
                    ? AppColors.dangerTint
                    : isSelected
                    ? AppColors.primaryTint
                    : AppColors.surfaceRaised,
                side: BorderSide(
                  color: isCorrect
                      ? AppColors.cyanInk
                      : isWrong
                      ? AppColors.danger
                      : isSelected
                      ? AppColors.primary
                      : AppColors.border,
                ),
              ),
              onPressed: submitted
                  ? null
                  : () => setState(() => selected = option),
              child: Text(
                option,
                style: TextStyle(color: AppColors.textPrimary, height: 1.35),
              ),
            ),
          );
        }),
        const SizedBox(height: 8),
        FilledButton(
          onPressed: selected == null || submitted
              ? null
              : () {
                  final correct = selected == widget.correctAnswer;
                  if (correct) {
                    setState(() => submitted = true);
                  } else {
                    // A wrong attempt can be retried if the player still has a life.
                    setState(() {
                      selected = null;
                      submitted = false;
                    });
                  }
                  widget.onAnswered(correct);
                },
          child: const Text('Submit answer'),
        ),
      ],
    );
  }
}
