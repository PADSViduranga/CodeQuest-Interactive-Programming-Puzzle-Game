import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../core/game_module.dart';

/// Shared engine for games where the player puts items in order.
/// Payload: { "items": [ {"id": "a", "text": "..."} ] } (already shuffled)
/// Answer shape: { "order": ["a", "b", "c"] }
class OrderingView extends StatefulWidget {
  const OrderingView({super.key, required this.args});

  final GameModuleArgs args;

  @override
  State<OrderingView> createState() => _OrderingViewState();
}

class _OrderingViewState extends State<OrderingView> {
  late final List<Map<String, dynamic>> _items;
  bool? _correct;
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    _items = (widget.args.puzzle.payload['items'] as List)
        .map((e) => Map<String, dynamic>.from(e as Map))
        .toList();
  }

  Future<void> _check() async {
    if (_submitting || _correct != null) return;
    setState(() => _submitting = true);
    try {
      final result = await widget.args.submit({
        'order': [for (final i in _items) i['id']],
      });
      if (mounted) setState(() => _correct = result.correct);
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final puzzle = widget.args.puzzle;
    final locked = _correct != null || _submitting;
    Color border = AppColors.border;
    Color fill = AppColors.surface;
    if (_correct == true) {
      border = AppColors.green;
      fill = AppColors.greenTint;
    } else if (_correct == false) {
      border = AppColors.danger;
      fill = AppColors.dangerTint;
    }

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
        const SizedBox(height: 6),
        Text(
          'Hold and drag the lines into the right order.',
          style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
        ),
        const SizedBox(height: 14),
        ReorderableListView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          buildDefaultDragHandles: !locked,
          onReorder: (oldIndex, newIndex) {
            if (locked) return;
            setState(() {
              if (newIndex > oldIndex) newIndex -= 1;
              _items.insert(newIndex, _items.removeAt(oldIndex));
            });
          },
          children: [
            for (var i = 0; i < _items.length; i++)
              Container(
                key: ValueKey(_items[i]['id']),
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: fill,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: border),
                ),
                child: Row(
                  children: [
                    Text(
                      '${i + 1}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textMuted,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _items[i]['text'] as String,
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 14,
                          height: 1.4,
                        ),
                      ),
                    ),
                    Icon(Icons.drag_indicator, color: AppColors.textMuted),
                  ],
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        FilledButton(
          onPressed: locked ? null : _check,
          child: Text(_submitting ? 'Checking...' : 'Check order'),
        ),
      ],
    );
  }
}
