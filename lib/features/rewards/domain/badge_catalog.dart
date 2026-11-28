import 'package:flutter/material.dart';

/// How the app shows a badge. The server decides who earns each one; this
/// list only describes them (keep the ids in step with functions/badges.js).
class BadgeInfo {
  const BadgeInfo(this.id, this.name, this.description, this.icon);

  final String id;
  final String name;
  final String description;
  final IconData icon;
}

const badgeCatalog = [
  BadgeInfo(
    'first_win',
    'First Win',
    'Solve your first puzzle.',
    Icons.flag_rounded,
  ),
  BadgeInfo(
    'streak_3',
    'On a Roll',
    'Win 3 days in a row.',
    Icons.local_fire_department_rounded,
  ),
  BadgeInfo(
    'streak_7',
    'Week Warrior',
    'Win 7 days in a row.',
    Icons.whatshot_rounded,
  ),
  BadgeInfo(
    'level_5',
    'Rising Coder',
    'Reach level 5.',
    Icons.trending_up_rounded,
  ),
  BadgeInfo(
    'xp_500',
    'XP Collector',
    'Earn 500 XP in total.',
    Icons.bolt_rounded,
  ),
];
