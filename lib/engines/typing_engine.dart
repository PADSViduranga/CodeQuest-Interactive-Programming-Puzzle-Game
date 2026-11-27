import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';

class TypingEngine extends StatefulWidget {
  final String question;
  final String correctAnswer;
  final String? hint;
  final ValueChanged<bool> onAnswered;
  final bool multiline;

  const TypingEngine({
    super.key,
    required this.question,
    required this.correctAnswer,
    required this.onAnswered,
    this.hint,
    this.multiline = false,
  });

  @override
  State<TypingEngine> createState() => _TypingEngineState();
}

class _TypingEngineState extends State<TypingEngine> {
  final controller = TextEditingController();
  bool submitted = false;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

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
        if (widget.hint != null) ...[
          const SizedBox(height: 10),
          Text(
            'Hint: ${widget.hint}',
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ],
        const SizedBox(height: 18),
        TextField(
          controller: controller,
          enabled: !submitted,
          minLines: widget.multiline ? 3 : 1,
          maxLines: widget.multiline ? 5 : 1,
          style: TextStyle(color: AppColors.cyanInk, fontFamily: 'monospace'),
          decoration: InputDecoration(
            labelText: widget.multiline
                ? 'Write your code'
                : 'Type your answer',
            border: const OutlineInputBorder(),
          ),
          onSubmitted: (_) => submit(),
        ),
        const SizedBox(height: 14),
        FilledButton(
          onPressed: submitted ? null : submit,
          child: const Text('Check answer'),
        ),
      ],
    );
  }

  void submit() {
    if (controller.text.trim().isEmpty || submitted) return;
    final correct =
        controller.text.trim().toLowerCase() ==
        widget.correctAnswer.trim().toLowerCase();
    if (correct) {
      setState(() => submitted = true);
    } else {
      // Clear an incorrect attempt so an available extra life can be used.
      setState(() => controller.clear());
    }
    widget.onAnswered(correct);
  }
}
