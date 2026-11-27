import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../core/game_module.dart';

/// Shared engine for "fill in the blank" games.
/// Payload: { "code": ["print(____(x))"], "options": [{"id","text"}] }
/// The blank is written as ____ in the code.
/// Answer shape: { "selectedOptionId": "b" }
class FillBlankView extends StatefulWidget {
  const FillBlankView({super.key, required this.args});

  final GameModuleArgs args;

  @override
  State<FillBlankView> createState() => _FillBlankViewState();
}

class _FillBlankViewState extends State<FillBlankView> {
  static const _blank = '____';

  String? _selected;
  bool? _correct;
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
    final code = (puzzle.payload['code'] as List).cast<String>();
    final options = (puzzle.payload['options'] as List)
        .map((e) => Map<String, dynamic>.from(e as Map))
        .toList();
    final selectedText = _selected == null
        ? null
        : options.firstWhere((o) => o['id'] == _selected)['text'] as String;
    final locked = _correct != null || _submitting;

    Color blankColor = AppColors.cyan;
    if (_correct == true) blankColor = AppColors.green;
    if (_correct == false) blankColor = AppColors.danger;

    const mono = TextStyle(fontFamily: 'monospace', fontSize: 14, height: 1.7);

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
                Text.rich(
                  TextSpan(
                    style: mono,
                    children: [
                      for (final part in _split(line))
                        part == _blank
                            ? TextSpan(
                                text: selectedText ?? _blank,
                                style: TextStyle(
                                  color: blankColor,
                                  fontWeight: FontWeight.w800,
                                  decoration: TextDecoration.underline,
                                  decorationColor: blankColor,
                                ),
                              )
                            : TextSpan(text: part),
                    ],
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            for (final o in options)
              GestureDetector(
                onTap: locked
                    ? null
                    : () => setState(() => _selected = o['id'] as String),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: _selected == o['id']
                        ? AppColors.primaryTint
                        : AppColors.surface,
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(
                      color: _selected == o['id']
                          ? AppColors.primary
                          : AppColors.border,
                      width: _selected == o['id'] ? 2 : 1,
                    ),
                  ),
                  child: Text(
                    o['text'] as String,
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 20),
        FilledButton(
          onPressed: (_selected == null || locked) ? null : _check,
          child: Text(_submitting ? 'Checking...' : 'Check answer'),
        ),
      ],
    );
  }

  /// Splits a line into text parts and blank markers, keeping the order.
  List<String> _split(String line) {
    final parts = <String>[];
    var rest = line;
    while (true) {
      final i = rest.indexOf(_blank);
      if (i < 0) {
        if (rest.isNotEmpty) parts.add(rest);
        break;
      }
      if (i > 0) parts.add(rest.substring(0, i));
      parts.add(_blank);
      rest = rest.substring(i + _blank.length);
    }
    return parts;
  }
}
