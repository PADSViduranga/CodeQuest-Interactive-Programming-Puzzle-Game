import 'earned_achievement.dart';
import 'earned_badge.dart';

/// Builds the link to the first reward screen to show after a stage or a
/// bonus claim, or null when there is nothing to show. The order is: level
/// up, then each badge, then each achievement. Every screen carries the rest
/// of the chain in its `next` parameter.
String? buildRewardChain({
  required List<EarnedBadge> badges,
  List<EarnedAchievement> achievements = const [],
  int? leveledUpTo,
}) {
  String? chain;
  for (final a in achievements.reversed) {
    chain = Uri(
      path: '/badge',
      queryParameters: {
        'name': a.name,
        'desc': '${a.description} +${a.rewardXp} XP',
        'label': 'ACHIEVEMENT UNLOCKED',
        if (chain != null) 'next': chain,
      },
    ).toString();
  }
  for (final b in badges.reversed) {
    chain = Uri(
      path: '/badge',
      queryParameters: {
        'name': b.name,
        'desc': b.description,
        if (chain != null) 'next': chain,
      },
    ).toString();
  }
  if (leveledUpTo != null) {
    chain = Uri(
      path: '/level-up',
      queryParameters: {
        'level': '$leveledUpTo',
        if (chain != null) 'next': chain,
      },
    ).toString();
  }
  return chain;
}
