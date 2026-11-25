import '../core/game_type.dart';

/// One puzzle as the app sees it. It never contains the correct answer.
class Puzzle {
  const Puzzle({
    required this.id,
    required this.type,
    required this.language,
    required this.level,
    required this.title,
    required this.prompt,
    required this.payload,
    this.difficulty = 1,
    this.xpReward = 20,
    this.maxHints = 2,
  });

  final String id;
  final GameType type;
  final String language;
  final String level;
  final String title;
  final String prompt;

  /// Game specific data (code lines, options, items, grid...).
  final Map<String, dynamic> payload;
  final int difficulty;
  final int xpReward;
  final int maxHints;

  factory Puzzle.fromMap(String id, Map<String, dynamic> map) => Puzzle(
    id: id,
    type: GameType.fromWire(map['type'] as String),
    language: map['language'] as String? ?? 'python',
    level: map['level'] as String? ?? 'beginner',
    title: map['title'] as String? ?? '',
    prompt: map['prompt'] as String? ?? '',
    payload: Map<String, dynamic>.from(map['payload'] as Map? ?? const {}),
    difficulty: (map['difficulty'] as num?)?.toInt() ?? 1,
    xpReward: (map['xpReward'] as num?)?.toInt() ?? 20,
    maxHints: (map['maxHints'] as num?)?.toInt() ?? 2,
  );
}
