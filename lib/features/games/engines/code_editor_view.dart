import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../core/game_module.dart';

/// Shared engine for games where the player writes or fixes real code.
/// The code runs on the server against hidden tests.
/// Payload: { "starter": "code...", "examples": [ {"input": "4", "output": "8"} ] }
/// Answer shape: { "code": "..." }
class CodeEditorView extends StatefulWidget {
  const CodeEditorView({super.key, required this.args});

  final GameModuleArgs args;

  @override
  State<CodeEditorView> createState() => _CodeEditorViewState();
}

class _CodeEditorViewState extends State<CodeEditorView> {
  late final TextEditingController _controller;
  bool? _correct;
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: widget.args.puzzle.payload['starter'] as String? ?? '',
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _run() async {
    final code = _controller.text;
    if (code.trim().isEmpty || _submitting || _correct != null) return;
    setState(() => _submitting = true);
    try {
      final result = await widget.args.submit({'code': code});
      if (mounted) setState(() => _correct = result.correct);
    } catch (_) {
      // The game frame already told the player. They can run it again.
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final puzzle = widget.args.puzzle;
    final examples =
        (puzzle.payload['examples'] as List?)
            ?.map((e) => Map<String, dynamic>.from(e as Map))
            .toList() ??
        const <Map<String, dynamic>>[];
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
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.2,
            color: AppColors.cyan,
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
        for (var i = 0; i < examples.length; i++) ...[
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: Text(
              'Example ${i + 1}\nInput:  ${examples[i]['input']}\nOutput: ${examples[i]['output']}',
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 12,
                height: 1.5,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
        const SizedBox(height: 14),
        TextField(
          controller: _controller,
          enabled: !locked,
          minLines: 9,
          maxLines: null,
          keyboardType: TextInputType.multiline,
          autocorrect: false,
          enableSuggestions: false,
          style: const TextStyle(
            fontFamily: 'monospace',
            fontSize: 14,
            height: 1.5,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.cyanTint,
            border: outline(border),
            enabledBorder: outline(border),
            disabledBorder: outline(border),
            focusedBorder: outline(AppColors.primary, 2),
          ),
        ),
        const SizedBox(height: 16),
        FilledButton.icon(
          onPressed: locked ? null : _run,
          icon: const Icon(Icons.play_arrow),
          label: Text(_submitting ? 'Running tests...' : 'Run and check'),
        ),
      ],
    );
  }
}
