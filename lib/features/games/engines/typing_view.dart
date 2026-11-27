import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../core/game_module.dart';

/// Shared engine for games where the player types the answer.
/// Payload: { "code": ["..."] (optional), "placeholder": "Type here" }
/// Answer shape: { "text": "len(nums)" }
class TypingView extends StatefulWidget {
  const TypingView({super.key, required this.args});

  final GameModuleArgs args;

  @override
  State<TypingView> createState() => _TypingViewState();
}

class _TypingViewState extends State<TypingView> {
  final _controller = TextEditingController();
  bool? _correct;
  bool _submitting = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _check() async {
    final text = _controller.text.trim();
    if (text.isEmpty || _submitting || _correct != null) return;
    setState(() => _submitting = true);
    try {
      final result = await widget.args.submit({'text': text});
      if (mounted) setState(() => _correct = result.correct);
    } catch (_) {
      // The game frame already told the player. They can try again.
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final puzzle = widget.args.puzzle;
    final code = (puzzle.payload['code'] as List?)?.cast<String>();
    final placeholder =
        puzzle.payload['placeholder'] as String? ?? 'Type your answer';
    final locked = _correct != null || _submitting;

    Color border = AppColors.border;
    if (_correct == true) border = AppColors.green;
    if (_correct == false) border = AppColors.danger;

    OutlineInputBorder outline(Color c, [double w = 1]) => OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(color: c, width: w),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          puzzle.title.toUpperCase(),
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.2,
            color: AppColors.cyanInk,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          puzzle.prompt,
          style: const TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.w700,
            height: 1.25,
          ),
        ),
        if (code != null) ...[
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
            decoration: BoxDecoration(
              color: AppColors.cyanTint,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.cyan.withValues(alpha: 0.5)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final line in code)
                  Text(
                    line,
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 13,
                      height: 1.7,
                    ),
                  ),
              ],
            ),
          ),
        ],
        const SizedBox(height: 16),
        TextField(
          controller: _controller,
          enabled: !locked,
          autocorrect: false,
          enableSuggestions: false,
          onSubmitted: (_) => _check(),
          style: const TextStyle(fontFamily: 'monospace', fontSize: 16),
          decoration: InputDecoration(
            hintText: placeholder,
            filled: true,
            fillColor: AppColors.surface,
            border: outline(border),
            enabledBorder: outline(border),
            disabledBorder: outline(border),
            focusedBorder: outline(AppColors.primary, 2),
          ),
        ),
        const SizedBox(height: 16),
        FilledButton(
          onPressed: locked ? null : _check,
          child: Text(_submitting ? 'Checking...' : 'Check answer'),
        ),
      ],
    );
  }
}
