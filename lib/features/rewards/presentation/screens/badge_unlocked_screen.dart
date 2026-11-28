import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/celebration_background.dart';

class BadgeUnlockedScreen extends StatelessWidget {
  const BadgeUnlockedScreen({
    super.key,
    required this.name,
    required this.description,
    this.next,
    this.label = 'BADGE UNLOCKED',
  });

  final String name;
  final String description;
  final String? next;
  final String label;

  @override
  Widget build(BuildContext context) {
    return CelebrationBackground(
      glow: AppColors.yellow,
      child: Column(
        children: [
          const Spacer(),
          Transform.rotate(
            angle: 8 * math.pi / 180,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(44),
                gradient: const LinearGradient(
                  colors: [AppColors.yellow, Color(0xFFFF8A4C)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: AppColors.glow(AppColors.yellow),
              ),
              child: Transform.rotate(
                angle: -8 * math.pi / 180,
                child: const Icon(
                  Icons.local_fire_department_rounded,
                  size: 82,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 28),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.6,
              color: AppColors.yellowInk,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            name,
            style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.textSecondary),
          ),
          const Spacer(),
          FilledButton(
            onPressed: () => goNext(context, next),
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }
}
