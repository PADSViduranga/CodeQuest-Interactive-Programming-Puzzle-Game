/// An achievement the server has just unlocked for the player.
class EarnedAchievement {
  const EarnedAchievement({
    required this.id,
    required this.name,
    required this.description,
    required this.rewardXp,
  });

  final String id;
  final String name;
  final String description;
  final int rewardXp;

  factory EarnedAchievement.fromMap(Map<String, dynamic> m) =>
      EarnedAchievement(
        id: (m['id'] as String?) ?? '',
        name: (m['name'] as String?) ?? 'Achievement',
        description: (m['description'] as String?) ?? '',
        rewardXp: (m['rewardXp'] as num?)?.toInt() ?? 0,
      );
}

/// Reads the `newAchievements` list from a server response. Anything that is
/// not a list of maps gives an empty list.
List<EarnedAchievement> parseEarnedAchievements(Object? raw) {
  if (raw is! List) return const [];
  return [
    for (final a in raw)
      if (a is Map) EarnedAchievement.fromMap(Map<String, dynamic>.from(a)),
  ];
}
