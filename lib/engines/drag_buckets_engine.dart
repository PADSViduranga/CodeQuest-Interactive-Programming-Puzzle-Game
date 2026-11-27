import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';

import '../models/game_definition.dart';

class DragBucketsEngine extends StatefulWidget {
  final List<GamePair> pairs;
  final ValueChanged<bool> onCompleted;

  const DragBucketsEngine({
    super.key,
    required this.pairs,
    required this.onCompleted,
  });

  @override
  State<DragBucketsEngine> createState() => _DragBucketsEngineState();
}

class _DragBucketsEngineState extends State<DragBucketsEngine> {
  late List<GamePair> remaining;
  final Map<String, String> placed = {};
  bool completed = false;

  @override
  void initState() {
    super.initState();
    remaining = List.of(widget.pairs)..shuffle();
  }

  List<String> get categories =>
      widget.pairs.map((p) => p.category).toSet().toList();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Drag each item into the correct bucket.',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: remaining.where((p) => !placed.containsKey(p.item)).map((
            p,
          ) {
            return Draggable<String>(
              data: p.item,
              feedback: Material(
                color: Colors.transparent,
                child: Chip(label: Text(p.item)),
              ),
              childWhenDragging: Opacity(
                opacity: .25,
                child: Chip(label: Text(p.item)),
              ),
              child: Chip(
                avatar: const Icon(Icons.drag_indicator, size: 18),
                label: Text(p.item),
                backgroundColor: AppColors.primaryTint,
                labelStyle: TextStyle(color: AppColors.textPrimary),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 18),
        ...categories.map((category) {
          final items = placed.entries
              .where((e) => e.value == category)
              .map((e) => e.key)
              .toList();
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: DragTarget<String>(
              onWillAcceptWithDetails: (_) => !completed,
              onAcceptWithDetails: (details) {
                setState(() => placed[details.data] = category);
                if (placed.length == widget.pairs.length) {
                  final correct = widget.pairs.every(
                    (p) => placed[p.item] == p.category,
                  );
                  completed = correct;
                  if (!correct) {
                    placed.clear();
                    remaining = List.of(widget.pairs)..shuffle();
                  }
                  setState(() {});
                  widget.onCompleted(correct);
                }
              },
              builder: (context, candidates, rejected) => Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: candidates.isNotEmpty
                      ? AppColors.primaryTint
                      : AppColors.surfaceRaised,
                  border: Border.all(color: AppColors.border),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.cyanInk,
                      ),
                    ),
                    const SizedBox(height: 6),
                    if (items.isEmpty)
                      Text(
                        'Drop items here',
                        style: TextStyle(color: AppColors.textSecondary),
                      )
                    else
                      Wrap(
                        spacing: 6,
                        children: items
                            .map(
                              (item) => Chip(
                                label: Text(item),
                                labelStyle: TextStyle(
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            )
                            .toList(),
                      ),
                  ],
                ),
              ),
            ),
          );
        }),
      ],
    );
  }
}
