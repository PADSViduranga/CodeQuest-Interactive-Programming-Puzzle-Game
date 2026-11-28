class PlayerProfile {
  const PlayerProfile({
    required this.uid,
    required this.displayName,
    required this.isGuest,
    required this.avatarId,
    required this.totalXp,
    required this.level,
    required this.currentStreak,
    this.selectedLanguage,
    this.selectedLevel,
    this.badges = const [],
    this.lastStreakDay,
    this.lastDailyBonusDay,
    this.recentDays = const [],
    this.stats = const {},
    this.achievements = const [],
  });

  final String uid;
  final String displayName;
  final bool isGuest;
  final String avatarId;
  final int totalXp;
  final int level;
  final int currentStreak;
  final String? selectedLanguage;
  final String? selectedLevel;

  /// Ids of the badges the player has earned (set by the server).
  final List<String> badges;

  /// The last day (UTC, YYYY-MM-DD) the player won something.
  final String? lastStreakDay;

  /// The last day (UTC, YYYY-MM-DD) the daily bonus was claimed.
  final String? lastDailyBonusDay;

  /// The most recent days (UTC, YYYY-MM-DD) the player won something.
  final List<String> recentDays;

  /// Progress counters kept by the server (puzzlesSolved, miniGamesWon, ...).
  final Map<String, int> stats;

  /// Ids of the achievements the player has unlocked.
  final List<String> achievements;

  factory PlayerProfile.fromMap(String uid, Map<String, dynamic> m) {
    return PlayerProfile(
      uid: uid,
      displayName: (m['displayName'] as String?) ?? 'Player',
      isGuest: (m['isGuest'] as bool?) ?? false,
      avatarId: (m['avatarId'] as String?) ?? 'mito_1',
      totalXp: (m['totalXp'] as num?)?.toInt() ?? 0,
      level: (m['level'] as num?)?.toInt() ?? 1,
      currentStreak: (m['currentStreak'] as num?)?.toInt() ?? 0,
      selectedLanguage: m['selectedLanguage'] as String?,
      selectedLevel: m['selectedLevel'] as String?,
      badges: (m['badges'] as List?)?.whereType<String>().toList() ?? const [],
      lastStreakDay: m['lastStreakDay'] as String?,
      lastDailyBonusDay: m['lastDailyBonusDay'] as String?,
      recentDays:
          (m['recentDays'] as List?)?.whereType<String>().toList() ?? const [],
      stats: _readStats(m['stats']),
      achievements:
          (m['achievements'] as List?)?.whereType<String>().toList() ??
          const [],
    );
  }
}

Map<String, int> _readStats(Object? raw) {
  if (raw is! Map) return const {};
  return {
    for (final e in raw.entries)
      if (e.key is String && e.value is num)
        e.key as String: (e.value as num).toInt(),
  };
}
