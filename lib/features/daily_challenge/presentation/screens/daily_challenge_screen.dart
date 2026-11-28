import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../profile/presentation/providers/profile_provider.dart';
import '../../../rewards/domain/reward_chain.dart';
import '../../data/daily_bonus_service.dart';
import '../../domain/daily_bonus.dart';

class DailyChallengeScreen extends ConsumerStatefulWidget {
  const DailyChallengeScreen({super.key});

  @override
  ConsumerState<DailyChallengeScreen> createState() =>
      _DailyChallengeScreenState();
}

class _DailyChallengeScreenState extends ConsumerState<DailyChallengeScreen> {
  Timer? _timer;
  Duration _left = untilNextUtcDay(DateTime.now());
  bool _claiming = false;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() => _left = untilNextUtcDay(DateTime.now()));
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _two(int n) => n.toString().padLeft(2, '0');

  Future<void> _claim() async {
    if (_claiming) return;
    final oldLevel = ref.read(playerProfileProvider).value?.level ?? 1;
    setState(() => _claiming = true);
    try {
      final r = await claimDailyBonus();
      if (!mounted) return;
      final chain = buildRewardChain(
        badges: r.newBadges,
        achievements: r.newAchievements,
        leveledUpTo: r.level > oldLevel ? r.level : null,
      );
      if (chain != null) {
        context.push(chain);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              r.xpAwarded > 0
                  ? '+${r.xpAwarded} XP added to your profile'
                  : 'Nothing to claim right now',
            ),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      final text = e.toString();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Could not claim the bonus: '
            '${text.length > 100 ? text.substring(0, 100) : text}',
          ),
        ),
      );
    } finally {
      if (mounted) setState(() => _claiming = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(playerProfileProvider).value;
    final now = DateTime.now();
    final today = dayKeyUtc(now);
    final streak = profile?.currentStreak ?? 0;
    final status = computeDailyBonusStatus(
      lastStreakDay: profile?.lastStreakDay,
      lastDailyBonusDay: profile?.lastDailyBonusDay,
      today: today,
    );
    final week = weekDayKeys(now);
    final recent = profile?.recentDays ?? const <String>[];
    final todayIndex = week.indexOf(today);
    const days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

    final subtitle = switch (status) {
      DailyBonusStatus.locked => 'Win any puzzle or mini-game today',
      DailyBonusStatus.ready => 'You earned it. Claim your bonus!',
      DailyBonusStatus.claimed => 'Completed today. See you tomorrow!',
    };
    final caption = switch (status) {
      DailyBonusStatus.locked => 'unlocks after your first win today',
      DailyBonusStatus.ready => 'ready to claim',
      DailyBonusStatus.claimed => 'bonus collected',
    };

    return Scaffold(
      appBar: AppBar(title: const Text('Daily challenge')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              gradient: LinearGradient(
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
                Text(
                  "TODAY'S BONUS",
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.4,
                    color: AppColors.yellowInk,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Daily bonus',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.textSecondary),
                ),
                const SizedBox(height: 14),
                Text(
                  '+$dailyBonusXp XP',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.w900,
                    color: AppColors.yellowInk,
                  ),
                ),
                Text(
                  caption,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
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
                        style: TextStyle(
                          color: AppColors.pinkInk,
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
                          done: recent.contains(week[i]),
                          today: i == todayIndex,
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          switch (status) {
            DailyBonusStatus.locked => FilledButton(
              onPressed: () => context.go('/home'),
              child: const Text('Go win something'),
            ),
            DailyBonusStatus.ready => FilledButton(
              onPressed: _claiming ? null : _claim,
              child: Text(
                _claiming ? 'Claiming...' : 'Claim +$dailyBonusXp XP',
              ),
            ),
            DailyBonusStatus.claimed => const FilledButton(
              onPressed: null,
              child: Text('Completed today'),
            ),
          },
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
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w800,
            color: AppColors.cyanInk,
          ),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
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
            ? Icon(Icons.check, size: 16, color: AppColors.greenInk)
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
