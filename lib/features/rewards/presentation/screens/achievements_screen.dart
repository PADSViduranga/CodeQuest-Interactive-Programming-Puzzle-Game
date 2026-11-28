import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../profile/presentation/providers/profile_provider.dart';
import '../../domain/achievement_catalog.dart';

/// Every achievement with the player's progress toward it.
class AchievementsScreen extends ConsumerWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(playerProfileProvider).value;
    final stats = profile?.stats ?? const <String, int>{};
    final owned = profile?.achievements ?? const <String>[];
    final done = achievementCatalog.where((a) => owned.contains(a.id)).length;

    return Scaffold(
      appBar: AppBar(title: const Text('Achievements')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            'ACHIEVEMENTS  $done / ${achievementCatalog.length}',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.4,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 12),
          for (final a in achievementCatalog)
            _AchievementTile(
              info: a,
              value: stats[a.stat] ?? 0,
              unlocked: owned.contains(a.id),
            ),
        ],
      ),
    );
  }
}

class _AchievementTile extends StatelessWidget {
  const _AchievementTile({
    required this.info,
    required this.value,
    required this.unlocked,
  });

  final AchievementInfo info;
  final int value;
  final bool unlocked;

  @override
  Widget build(BuildContext context) {
    final shown = value > info.target ? info.target : value;
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: unlocked
                    ? AppColors.yellowTint
                    : AppColors.surfaceRaised,
                border: Border.all(
                  color: unlocked ? AppColors.yellow : AppColors.border,
                  width: 1.5,
                ),
              ),
              child: Icon(
                info.icon,
                color: unlocked ? AppColors.yellowInk : AppColors.textMuted,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          info.name,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      Text(
                        unlocked ? 'Unlocked' : '+${info.rewardXp} XP',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: unlocked
                              ? AppColors.greenInk
                              : AppColors.yellowInk,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    info.description,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: shown / info.target,
                      minHeight: 8,
                      backgroundColor: AppColors.border,
                      color: unlocked ? AppColors.green : AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$shown / ${info.target}',
                    style: TextStyle(fontSize: 11, color: AppColors.textMuted),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
