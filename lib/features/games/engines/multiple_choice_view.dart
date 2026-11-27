import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../core/game_module.dart';

/// Shared engine for games that show a prompt, optional code and options.
/// Answer shape: { "selectedOptionId": "b" }
class MultipleChoiceView extends StatefulWidget {
  const MultipleChoiceView({super.key, required this.args});

  final GameModuleArgs args;

  @override
  State<MultipleChoiceView> createState() => _MultipleChoiceViewState();
}

class _MultipleChoiceViewState extends State<MultipleChoiceView> {
  String? _selected;
  bool? _correct; // null until the server answers
  bool _submitting = false;

  Future<void> _check() async {
    if (_selected == null || _submitting || _correct != null) return;
    setState(() => _submitting = true);
    try {
      final result = await widget.args.submit({'selectedOptionId': _selected});
      if (mounted) setState(() => _correct = result.correct);
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final puzzle = widget.args.puzzle;
    final code = (puzzle.payload['code'] as List?)?.cast<String>();
    final options = (puzzle.payload['options'] as List)
        .map((e) => Map<String, dynamic>.from(e as Map))
        .toList();
    final hidden = widget.args.session.hiddenOptionIds;

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
          _CodeBox(lines: code),
        ],
        const SizedBox(height: 14),
        for (var i = 0; i < options.length; i++)
          if (!hidden.contains(options[i]['id']))
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _OptionTile(
                letter: String.fromCharCode(65 + i),
                text: options[i]['text'] as String,
                selected: _selected == options[i]['id'],
                result: _selected == options[i]['id'] ? _correct : null,
                onTap: _correct != null || _submitting
                    ? null
                    : () => setState(
                        () => _selected = options[i]['id'] as String,
                      ),
              ),
            ),
        const SizedBox(height: 8),
        FilledButton(
          onPressed: (_selected == null || _submitting || _correct != null)
              ? null
              : _check,
          child: Text(_submitting ? 'Checking...' : 'Check answer'),
        ),
      ],
    );
  }
}

class _CodeBox extends StatelessWidget {
  const _CodeBox({required this.lines});

  final List<String> lines;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
    decoration: BoxDecoration(
      color: AppColors.cyanTint,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: AppColors.cyan.withValues(alpha: 0.5)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < lines.length; i++)
          Row(
            children: [
              SizedBox(
                width: 22,
                child: Text(
                  '${i + 1}',
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 12,
                    height: 1.7,
                    color: AppColors.textMuted,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  lines[i],
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 13,
                    height: 1.7,
                  ),
                ),
              ),
            ],
          ),
      ],
    ),
  );
}

class _OptionTile extends StatelessWidget {
  const _OptionTile({
    required this.letter,
    required this.text,
    required this.selected,
    required this.result,
    required this.onTap,
  });

  final String letter;
  final String text;
  final bool selected;
  final bool? result;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    Color border = AppColors.border;
    Color fill = AppColors.surface;
    if (selected) {
      border = AppColors.primary;
      fill = AppColors.primaryTint;
    }
    if (result == true) {
      border = AppColors.green;
      fill = AppColors.greenTint;
    } else if (result == false) {
      border = AppColors.danger;
      fill = AppColors.dangerTint;
    }
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: fill,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: border, width: selected ? 2 : 1),
          boxShadow: selected ? AppColors.glow(border) : null,
        ),
        child: Row(
          children: [
            Container(
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                color: AppColors.surfaceRaised,
                borderRadius: BorderRadius.circular(8),
              ),
              alignment: Alignment.center,
              child: Text(
                letter,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                text,
                style: const TextStyle(fontFamily: 'monospace', fontSize: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
