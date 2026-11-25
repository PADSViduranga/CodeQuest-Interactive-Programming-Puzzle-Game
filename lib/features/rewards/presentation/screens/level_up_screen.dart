import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/celebration_background.dart';

class LevelUpScreen extends StatelessWidget {
  const LevelUpScreen({super.key, required this.level, this.next});

  final int level;
  final String? next;

  @override
  Widget build(BuildContext context) {
    return CelebrationBackground(
      child: Column(
        children: [
          const Spacer(),
          Container(
            width: 180,
            height: 180,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: AppColors.brandGradient,
              boxShadow: AppColors.glow(AppColors.primary),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'LEVEL',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 2,
                  ),
                ),
                Text(
                  '$level',
                  style: const TextStyle(
                    fontSize: 72,
                    fontWeight: FontWeight.w900,
                    height: 1,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'You levelled up!',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 20),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _Reward('+1 Freeze', AppColors.cyan),
              SizedBox(width: 8),
              _Reward('+1 Hint', AppColors.yellow),
              SizedBox(width: 8),
              _Reward('+1 Life', AppColors.pink),
            ],
          ),
          const Spacer(),
          FilledButton(
            onPressed: () => goNext(context, next),
            child: const Text('Awesome!'),
          ),
        ],
      ),
    );
  }
}

class _Reward extends StatelessWidget {
  const _Reward(this.text, this.color);

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    decoration: BoxDecoration(
      color: color.withValues(alpha: 0.15),
      borderRadius: BorderRadius.circular(999),
      border: Border.all(color: color.withValues(alpha: 0.6)),
    ),
    child: Text(
      text,
      style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: color),
    ),
  );
}
