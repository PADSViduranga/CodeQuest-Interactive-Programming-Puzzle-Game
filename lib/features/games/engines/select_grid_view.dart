import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../core/game_module.dart';

/// Shared engine for "tap every cell that fits" games.
/// Payload: { "cells": [ {"id": "c1", "text": "my_name"} ], "columns": 2 }
/// Answer shape: { "selected": ["c1", "c3"] }
class SelectGridView extends StatefulWidget {
  const SelectGridView({super.key, required this.args});

  final GameModuleArgs args;

  @override
  State<SelectGridView> createState() => _SelectGridViewState();
}

class _SelectGridViewState extends State<SelectGridView> {
  final _selected = <String>{};
  bool? _correct;
  bool _submitting = false;

  Future<void> _check() async {
    if (_selected.isEmpty || _submitting || _correct != null) return;
    setState(() => _submitting = true);
    try {
      final result = await widget.args.submit({'selected': _selected.toList()});
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
    final cells = (puzzle.payload['cells'] as List)
        .map((e) => Map<String, dynamic>.from(e as Map))
        .toList();
    final columns = (puzzle.payload['columns'] as num?)?.toInt() ?? 2;
    final locked = _correct != null || _submitting;

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
        const SizedBox(height: 6),
        const Text(
          'Tap every cell that fits, then check.',
          style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
        ),
        const SizedBox(height: 14),
        GridView.count(
          crossAxisCount: columns,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 2.6,
          children: [for (final c in cells) _cell(c, locked)],
        ),
        const SizedBox(height: 18),
        FilledButton(
          onPressed: (_selected.isEmpty || locked) ? null : _check,
          child: Text(_submitting ? 'Checking...' : 'Check answer'),
        ),
      ],
    );
  }

  Widget _cell(Map<String, dynamic> c, bool locked) {
    final id = c['id'] as String;
    final on = _selected.contains(id);
    Color border = on ? AppColors.primary : AppColors.border;
    Color fill = on ? AppColors.primaryTint : AppColors.surface;
    if (on && _correct == true) {
      border = AppColors.green;
      fill = AppColors.greenTint;
    } else if (on && _correct == false) {
      border = AppColors.danger;
      fill = AppColors.dangerTint;
    }
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: locked
          ? null
          : () => setState(() {
              if (!_selected.remove(id)) _selected.add(id);
            }),
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: fill,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: border, width: on ? 2 : 1),
        ),
        child: Text(
          c['text'] as String,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontFamily: 'monospace',
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
