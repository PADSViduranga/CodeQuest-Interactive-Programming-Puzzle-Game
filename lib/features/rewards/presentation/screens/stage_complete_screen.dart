import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/celebration_background.dart';

class StageCompleteScreen extends StatelessWidget {
  const StageCompleteScreen({
    super.key,
    required this.stars,
    required this.xp,
    required this.accuracy,
    required this.combo,
    this.next,
  });

  final int stars;
  final int xp;
  final int accuracy;
  final int combo;
  final String? next;

  @override
  Widget build(BuildContext context) {
    return CelebrationBackground(
      child: Column(
        children: [
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              for (var i = 0; i < 3; i++)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Icon(
                    Icons.star_rounded,
                    size: i == 1 ? 76 : 56,
                    color: i < stars ? AppColors.yellow : AppColors.border,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Stage clear!',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.8,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(child: _Stat('+$xp', 'XP earned', AppColors.yellow)),
              const SizedBox(width: 10),
              Expanded(child: _Stat('$accuracy%', 'Accuracy', AppColors.green)),
              const SizedBox(width: 10),
              Expanded(child: _Stat('x$combo', 'Best combo', AppColors.pink)),
            ],
          ),
          const Spacer(),
          FilledButton(
            onPressed: () => goNext(context, next),
            child: const Text('Continue'),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () => context.go('/home'),
            child: const Text('Back to map'),
          ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat(this.value, this.label, this.color);

  final String value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(vertical: 14),
    decoration: BoxDecoration(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: AppColors.border),
    ),
    child: Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: color,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
        ),
      ],
    ),
  );
}
