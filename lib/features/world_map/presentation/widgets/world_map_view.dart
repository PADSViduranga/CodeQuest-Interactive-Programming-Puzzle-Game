import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/stage.dart';
import '../providers/world_provider.dart';

class WorldMapView extends ConsumerWidget {
  const WorldMapView({super.key, required this.totalXp});

  final int totalXp;

  static const _offsets = [0.0, -0.55, 0.0, 0.55];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stages = ref.watch(stagesProvider).value;
    if (stages == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: stages.length,
      itemBuilder: (context, i) {
        final stage = stages[i];
        final state = stageStateFor(totalXp, stages, i);
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Align(
            alignment: Alignment(_offsets[i % _offsets.length], 0),
            child: _StageNode(
              stage: stage,
              state: state,
              onTap: () => _openStage(context, stage, state),
            ),
          ),
        );
      },
    );
  }

  void _openStage(BuildContext context, Stage stage, StageState state) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              stage.isBoss ? 'BOSS STAGE' : 'STAGE',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
                color: stage.isBoss ? AppColors.pink : AppColors.primaryLight,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              stage.title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 4),
            Text(
              stage.subtitle,
              style: TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 20),
            if (state == StageState.locked)
              Text(
                'Earn ${stage.unlockXp - totalXp} more XP to unlock this stage.',
                style: TextStyle(color: AppColors.yellowInk),
              )
            else ...[
              OutlinedButton(
                onPressed: () {
                  Navigator.of(sheetContext).pop();
                  context.push('/lesson/${stage.id}');
                },
                child: const Text('Read lesson'),
              ),
              const SizedBox(height: 10),
              FilledButton(
                onPressed: () {
                  Navigator.of(sheetContext).pop();
                  context.push('/play/${stage.id}');
                },
                child: const Text('Start stage'),
              ),
              if (kDebugMode)
                TextButton(
                  onPressed: () {
                    Navigator.of(sheetContext).pop();
                    context.push(_previewRewards());
                  },
                  child: const Text('Preview rewards (debug)'),
                ),
            ],
          ],
        ),
      ),
    );
  }
}

class _StageNode extends StatelessWidget {
  const _StageNode({
    required this.stage,
    required this.state,
    required this.onTap,
  });

  final Stage stage;
  final StageState state;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final Color color;
    final IconData icon;
    switch (state) {
      case StageState.done:
        color = AppColors.green;
        icon = Icons.check_rounded;
      case StageState.current:
        color = stage.isBoss ? AppColors.pink : AppColors.primary;
        icon = stage.isBoss
            ? Icons.local_fire_department_rounded
            : Icons.play_arrow_rounded;
      case StageState.locked:
        color = AppColors.textMuted;
        icon = Icons.lock_rounded;
    }
    final isCurrent = state == StageState.current;
    final size = isCurrent ? 76.0 : 64.0;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isCurrent ? color : color.withValues(alpha: 0.18),
              border: Border.all(color: color, width: 3),
              boxShadow: isCurrent ? AppColors.glow(color) : null,
            ),
            child: Icon(
              icon,
              size: isCurrent ? 38 : 30,
              color: isCurrent ? Colors.white : color,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            stage.title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: state == StageState.locked
                  ? AppColors.textMuted
                  : AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

/// Debug helper: opens stage complete, then level up, then a badge.
String _previewRewards() {
  final badge = Uri(
    path: '/badge',
    queryParameters: {'name': 'On Fire', 'desc': 'Play 7 days in a row.'},
  ).toString();
  final level = Uri(
    path: '/level-up',
    queryParameters: {'level': '2', 'next': badge},
  ).toString();
  return Uri(
    path: '/stage-complete',
    queryParameters: {
      'stars': '3',
      'xp': '60',
      'accuracy': '83',
      'combo': '4',
      'next': level,
    },
  ).toString();
}
