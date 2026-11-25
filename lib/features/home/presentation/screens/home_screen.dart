import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../auth/presentation/providers/guest_timer_provider.dart';
import '../../../profile/presentation/providers/profile_provider.dart';
import '../../../world_map/domain/stage.dart';
import '../../../world_map/presentation/widgets/world_map_view.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateProvider).value;
    final profile = ref.watch(playerProfileProvider).value;
    final timer = ref.watch(guestTimerProvider);
    final xp = profile?.totalXp ?? 0;
    final name = profile?.displayName ?? user?.displayName ?? 'Player';
    final left = timer.remaining;
    final mm = left.inMinutes;
    final ss = (left.inSeconds % 60).toString().padLeft(2, '0');

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hi $name',
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        Text(
                          '${_pretty(profile?.selectedLanguage)} · ${_pretty(profile?.selectedLevel)}',
                          style: const TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _Chip(
                    icon: Icons.local_fire_department_rounded,
                    text: '${profile?.currentStreak ?? 0}',
                    color: AppColors.pink,
                  ),
                  const SizedBox(width: 8),
                  _Chip(
                    icon: Icons.bolt_rounded,
                    text: '$xp',
                    color: AppColors.yellow,
                  ),
                ],
              ),
              if (timer.isGuest)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: _Chip(
                    icon: Icons.timer_outlined,
                    text: 'Guest time left $mm:$ss',
                    color: AppColors.cyan,
                  ),
                ),
              const SizedBox(height: 16),
              Text(
                sampleWorldTitle.toUpperCase(),
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                  color: AppColors.textSecondary,
                ),
              ),
              Expanded(child: WorldMapView(totalXp: xp)),
            ],
          ),
        ),
      ),
    );
  }

  String _pretty(String? id) {
    if (id == null || id.isEmpty) return '-';
    const special = {'html_css': 'HTML/CSS', 'cpp': 'C++', 'sql': 'SQL'};
    return special[id] ?? id[0].toUpperCase() + id.substring(1);
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.icon, required this.text, required this.color});

  final IconData icon;
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    decoration: BoxDecoration(
      color: color.withValues(alpha: 0.14),
      borderRadius: BorderRadius.circular(999),
      border: Border.all(color: color.withValues(alpha: 0.5)),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
      ],
    ),
  );
}
