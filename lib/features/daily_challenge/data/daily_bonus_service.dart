import 'package:cloud_functions/cloud_functions.dart';

import '../../rewards/domain/earned_achievement.dart';
import '../../rewards/domain/earned_badge.dart';

/// What the server says after a daily bonus claim.
class DailyBonusResult {
  const DailyBonusResult({
    required this.status,
    this.xpAwarded = 0,
    this.totalXp = 0,
    this.level = 1,
    this.newBadges = const [],
    this.newAchievements = const [],
  });

  final String status;
  final int xpAwarded;
  final int totalXp;
  final int level;
  final List<EarnedBadge> newBadges;
  final List<EarnedAchievement> newAchievements;

  factory DailyBonusResult.fromMap(Map<String, dynamic> m) => DailyBonusResult(
    status: (m['status'] as String?) ?? 'locked',
    xpAwarded: (m['xpAwarded'] as num?)?.toInt() ?? 0,
    totalXp: (m['totalXp'] as num?)?.toInt() ?? 0,
    level: (m['level'] as num?)?.toInt() ?? 1,
    newBadges: parseEarnedBadges(m['newBadges']),
    newAchievements: parseEarnedAchievements(m['newAchievements']),
  );
}

/// Asks the server to pay today's bonus. Throws if the call fails.
Future<DailyBonusResult> claimDailyBonus() async {
  final result = await FirebaseFunctions.instance
      .httpsCallable('claimDailyBonus')
      .call();
  return DailyBonusResult.fromMap(
    Map<String, dynamic>.from(result.data as Map),
  );
}
