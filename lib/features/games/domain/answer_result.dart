import '../../rewards/domain/earned_badge.dart';

/// What the server says after an answer is submitted.
class AnswerResult {
  const AnswerResult({
    required this.correct,
    this.xpAwarded = 0,
    this.newTotalXp = 0,
    this.newLevel = 1,
    this.leveledUp = false,
    this.comboCount = 0,
    this.explanation,
    this.newBadges = const [],
  });

  final bool correct;
  final int xpAwarded;
  final int newTotalXp;
  final int newLevel;
  final bool leveledUp;
  final int comboCount;
  final String? explanation;
  final List<EarnedBadge> newBadges;

  factory AnswerResult.fromMap(Map<String, dynamic> map) => AnswerResult(
    correct: map['correct'] as bool? ?? false,
    xpAwarded: (map['xpAwarded'] as num?)?.toInt() ?? 0,
    newTotalXp: (map['newTotalXp'] as num?)?.toInt() ?? 0,
    newLevel: (map['newLevel'] as num?)?.toInt() ?? 1,
    leveledUp: map['leveledUp'] as bool? ?? false,
    comboCount: (map['comboCount'] as num?)?.toInt() ?? 0,
    explanation: map['explanation'] as String?,
    newBadges: parseEarnedBadges(map['newBadges']),
  );
}
