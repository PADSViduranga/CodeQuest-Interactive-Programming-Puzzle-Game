import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/badge_catalog.dart';

/// All badges in a grid: earned ones in color, the rest locked.
class BadgesSection extends StatelessWidget {
  const BadgesSection({super.key, required this.earned});

  /// Ids of the badges the player has earned.
  final List<String> earned;

  @override
  Widget build(BuildContext context) {
    final count = badgeCatalog.where((b) => earned.contains(b.id)).length;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'BADGES  $count / ${badgeCatalog.length}',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.4,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            for (final b in badgeCatalog)
              _BadgeTile(info: b, unlocked: earned.contains(b.id)),
          ],
        ),
      ],
    );
  }
}

class _BadgeTile extends StatelessWidget {
  const _BadgeTile({required this.info, required this.unlocked});

  final BadgeInfo info;
  final bool unlocked;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: info.description,
      triggerMode: TooltipTriggerMode.tap,
      child: Container(
        width: 100,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
        decoration: BoxDecoration(
          color: unlocked ? AppColors.yellowTint : AppColors.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: unlocked ? AppColors.yellow : AppColors.border,
            width: 1.5,
          ),
        ),
        child: Column(
          children: [
            Icon(
              unlocked ? info.icon : Icons.lock_outline_rounded,
              size: 30,
              color: unlocked ? AppColors.yellowInk : AppColors.textMuted,
            ),
            const SizedBox(height: 6),
            Text(
              info.name,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: unlocked ? AppColors.textPrimary : AppColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
