import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../profile/presentation/providers/profile_provider.dart';

class _Entry {
  const _Entry(this.name, this.xp, this.color, {this.isYou = false});

  final String name;
  final int xp;
  final Color color;
  final bool isYou;
}

/// Sample players until the real weekly leaderboard comes from Firestore.
const _samplePlayers = [
  _Entry('Mia', 2340, AppColors.yellow),
  _Entry('Ravi', 2010, AppColors.cyan),
  _Entry('Kai', 1880, AppColors.pink),
  _Entry('Noor', 1720, AppColors.green),
  _Entry('Leo', 1512, AppColors.primaryLight),
  _Entry('Ana', 1430, AppColors.cyan),
];

class LeaderboardScreen extends ConsumerStatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  ConsumerState<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends ConsumerState<LeaderboardScreen> {
  int _tab = 0;

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(playerProfileProvider).value;
    final entries = [
      ..._samplePlayers,
      _Entry(
        profile?.displayName ?? 'You',
        profile?.totalXp ?? 0,
        AppColors.primary,
        isYou: true,
      ),
    ]..sort((a, b) => b.xp.compareTo(a.xp));

    return Scaffold(
      appBar: AppBar(title: const Text('Leaderboard')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        children: [
          Row(
            children: [
              for (final (i, label) in const [
                'WEEKLY',
                'FRIENDS',
                'ALL TIME',
              ].indexed)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(label),
                    selected: _tab == i,
                    onSelected: (_) => setState(() => _tab = i),
                    selectedColor: AppColors.primary,
                    labelStyle: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: _tab == i ? Colors.white : AppColors.textSecondary,
                    ),
                    side: const BorderSide(color: AppColors.border),
                    showCheckmark: false,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(child: _Podium(entry: entries[1], rank: 2, height: 70)),
              Expanded(child: _Podium(entry: entries[0], rank: 1, height: 100)),
              Expanded(child: _Podium(entry: entries[2], rank: 3, height: 50)),
            ],
          ),
          const SizedBox(height: 16),
          for (var i = 3; i < entries.length; i++)
            _Row(rank: i + 1, entry: entries[i]),
          const SizedBox(height: 8),
          const Center(
            child: Text(
              'Sample players for now',
              style: TextStyle(color: AppColors.textMuted, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}

class _Podium extends StatelessWidget {
  const _Podium({
    required this.entry,
    required this.rank,
    required this.height,
  });

  final _Entry entry;
  final int rank;
  final double height;

  @override
  Widget build(BuildContext context) {
    final c = entry.color;
    return Column(
      children: [
        CircleAvatar(
          radius: rank == 1 ? 28 : 22,
          backgroundColor: c,
          child: Text(
            entry.name.isEmpty ? '?' : entry.name[0].toUpperCase(),
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          entry.isYou ? '${entry.name} (you)' : entry.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
        ),
        Text(
          '${entry.xp} XP',
          style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
        ),
        const SizedBox(height: 6),
        Container(
          height: height,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            gradient: LinearGradient(
              colors: [c.withValues(alpha: 0.6), c.withValues(alpha: 0.1)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          alignment: Alignment.topCenter,
          padding: const EdgeInsets.only(top: 8),
          child: Text(
            '$rank',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: c,
            ),
          ),
        ),
      ],
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.rank, required this.entry});

  final int rank;
  final _Entry entry;

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: 10),
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
    decoration: BoxDecoration(
      color: entry.isYou ? AppColors.primaryTint : AppColors.surface,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(
        color: entry.isYou ? AppColors.primary : AppColors.border,
      ),
    ),
    child: Row(
      children: [
        SizedBox(
          width: 24,
          child: Text(
            '$rank',
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              color: AppColors.textSecondary,
            ),
          ),
        ),
        CircleAvatar(
          radius: 16,
          backgroundColor: entry.color,
          child: Text(
            entry.name.isEmpty ? '?' : entry.name[0].toUpperCase(),
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            entry.isYou ? '${entry.name} (you)' : entry.name,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        Text(
          '${entry.xp}',
          style: const TextStyle(
            fontWeight: FontWeight.w800,
            color: AppColors.cyan,
          ),
        ),
      ],
    ),
  );
}
