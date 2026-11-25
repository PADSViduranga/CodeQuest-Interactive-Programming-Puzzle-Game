import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../profile/presentation/providers/profile_provider.dart';

class DailyChallengeScreen extends ConsumerStatefulWidget {
  const DailyChallengeScreen({super.key});

  @override
  ConsumerState<DailyChallengeScreen> createState() =>
      _DailyChallengeScreenState();
}

class _DailyChallengeScreenState extends ConsumerState<DailyChallengeScreen> {
  Timer? _timer;
  Duration _left = _untilMidnight();

  static Duration _untilMidnight() {
    final now = DateTime.now();
    final midnight = DateTime(now.year, now.month, now.day + 1);
    return midnight.difference(now);
  }

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() => _left = _untilMidnight());
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _two(int n) => n.toString().padLeft(2, '0');

  @override
  Widget build(BuildContext context) {
    final streak = ref.watch(playerProfileProvider).value?.currentStreak ?? 0;
    final todayIndex = DateTime.now().weekday - 1; // Monday = 0
    const days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

    return Scaffold(
      appBar: AppBar(title: const Text('Daily challenge')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              gradient: const LinearGradient(
                colors: [AppColors.yellowTint, AppColors.surface],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border.all(
                color: AppColors.yellow.withValues(alpha: 0.5),
              ),
            ),
            child: Column(
              children: [
                const Text(
                  "TODAY'S CHALLENGE",
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.4,
                    color: AppColors.yellow,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Bug Hunt',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 2),
                const Text(
                  'Find the line with the bug',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
                const SizedBox(height: 14),
                const Text(
                  '+150 XP',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.w900,
                    color: AppColors.yellow,
                  ),
                ),
                const Text(
                  'bonus for today only',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'RESETS IN',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(child: _Time(_two(_left.inHours), 'hours')),
              const SizedBox(width: 10),
              Expanded(child: _Time(_two(_left.inMinutes % 60), 'mins')),
              const SizedBox(width: 10),
              Expanded(child: _Time(_two(_left.inSeconds % 60), 'secs')),
            ],
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'This week',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                      Text(
                        '$streak day streak',
                        style: const TextStyle(
                          color: AppColors.pink,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      for (var i = 0; i < 7; i++)
                        _DayDot(
                          label: days[i],
                          done: i <= todayIndex && todayIndex - i < streak,
                          today: i == todayIndex,
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          const FilledButton(
            onPressed: null,
            child: Text('Play now (coming soon)'),
          ),
        ],
      ),
    );
  }
}

class _Time extends StatelessWidget {
  const _Time(this.value, this.label);

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(vertical: 12),
    decoration: BoxDecoration(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: AppColors.border),
    ),
    child: Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w800,
            color: AppColors.cyan,
          ),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
        ),
      ],
    ),
  );
}

class _DayDot extends StatelessWidget {
  const _DayDot({required this.label, required this.done, required this.today});

  final String label;
  final bool done;
  final bool today;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: done ? AppColors.greenTint : AppColors.surface,
          border: Border.all(
            color: done
                ? AppColors.green
                : (today ? AppColors.primary : AppColors.border),
            width: today ? 2 : 1.5,
          ),
        ),
        child: done
            ? const Icon(Icons.check, size: 16, color: AppColors.green)
            : null,
      ),
      const SizedBox(height: 4),
      Text(
        label,
        style: TextStyle(
          fontSize: 10,
          color: today ? AppColors.primaryLight : AppColors.textMuted,
        ),
      ),
    ],
  );
}
