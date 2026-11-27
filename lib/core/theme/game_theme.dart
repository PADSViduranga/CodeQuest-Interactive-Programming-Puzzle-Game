import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_theme.dart';

/// Mini-game colors. They follow the app's teal palette and light/dark mode.
class GameTheme {
  static Color get background => AppColors.background;
  static Color get secondary => AppColors.surfaceRaised;
  static Color get card => AppColors.surface;
  static Color get purple => AppColors.primaryDark;
  static Color get neon => AppColors.primary;
  static Color get cyan => AppColors.cyanInk;
  static Color get gold => AppColors.yellowInk;
  static const heart = Color(0xFFFB7185);
  static Color get muted => AppColors.textSecondary;

  /// The theme for the current mode (name kept so existing callers work).
  static ThemeData get dark =>
      AppColors.isDark ? AppTheme.dark : AppTheme.light;
}
