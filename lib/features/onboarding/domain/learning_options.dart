import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class LanguageOption {
  const LanguageOption(this.id, this.name, this.short, this.color);

  final String id; // stored in Firestore
  final String name;
  final String short;
  final Color color;
}

class LevelOption {
  const LevelOption(
    this.id,
    this.name,
    this.description,
    this.icon,
    this.color,
  );

  final String id; // stored in Firestore
  final String name;
  final String description;
  final IconData icon;
  final Color color;
}

final languageOptions = [
  LanguageOption('python', 'Python', 'Py', AppColors.yellow),
  LanguageOption('javascript', 'JavaScript', 'JS', AppColors.yellow),
  LanguageOption('java', 'Java', 'Jv', AppColors.pink),
  LanguageOption('cpp', 'C++', 'C+', AppColors.cyan),
  LanguageOption('dart', 'Dart', 'Dt', AppColors.cyan),
  LanguageOption('sql', 'SQL', 'Sq', AppColors.green),
  LanguageOption('html_css', 'HTML/CSS', 'Hc', AppColors.pink),
  LanguageOption('git', 'Git', 'Gi', AppColors.primaryLight),
];

const levelOptions = [
  LevelOption(
    'beginner',
    'Beginner',
    'New to code. Start with the basics.',
    Icons.star_rounded,
    AppColors.green,
  ),
  LevelOption(
    'intermediate',
    'Intermediate',
    'Know the basics. Ready for logic.',
    Icons.bolt_rounded,
    AppColors.cyan,
  ),
  LevelOption(
    'advanced',
    'Advanced',
    'Hard puzzles and boss stages.',
    Icons.local_fire_department_rounded,
    AppColors.pink,
  ),
];
