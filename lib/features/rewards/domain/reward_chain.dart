import 'earned_badge.dart';

/// Builds the link to the first reward screen to show after a stage, or null
/// when there is nothing to show. Level up comes first, then each badge.
/// Every screen carries the rest of the chain in its `next` parameter.
String? buildRewardChain({
  required List<EarnedBadge> badges,
  int? leveledUpTo,
}) {
  String? chain;
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
