import 'package:flutter/material.dart';

/// How the app shows an achievement. The server counts the progress and
/// pays the XP; this list only describes the goals (keep it in step with
/// functions/achievements.js).
class AchievementInfo {
  const AchievementInfo(
    this.id,
    this.name,
    this.description,
    this.stat,
    this.target,
    this.rewardXp,
    this.icon,
  );

  final String id;
  final String name;
  final String description;

  /// The counter in the profile's `stats` this achievement watches.
  final String stat;
  final int target;
  final int rewardXp;
  final IconData icon;
}

const achievementCatalog = [
  AchievementInfo(
    'puzzle_10',
    'Puzzle Solver',
    'Solve 10 puzzles.',
    'puzzlesSolved',
    10,
    100,
    Icons.extension_rounded,
  ),
  AchievementInfo(
    'puzzle_50',
    'Puzzle Master',
    'Solve 50 puzzles.',
    'puzzlesSolved',
    50,
    300,
    Icons.psychology_rounded,
  ),
  AchievementInfo(
    'minigames_10',
    'Arcade Fan',
    'Win 10 mini-games.',
    'miniGamesWon',
    10,
    100,
    Icons.sports_esports_rounded,
  ),
  AchievementInfo(
    'combo_5',
    'Combo King',
    'Reach a 5-answer combo.',
    'bestCombo',
    5,
    100,
    Icons.bolt_rounded,
  ),
  AchievementInfo(
    'bonus_7',
    'Bonus Hunter',
    'Claim the daily bonus 7 times.',
    'bonusesClaimed',
    7,
    150,
    Icons.card_giftcard_rounded,
  ),
];
