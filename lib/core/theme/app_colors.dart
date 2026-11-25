import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Rich violet base (brighter than black, feels like a game)
  static const background = Color(0xFF1A0B4D);
  static const surface = Color(0xFF281366);
  static const surfaceRaised = Color(0xFF371C86);
  static const border = Color(0xFF5230B8);

  // Brand violet for main buttons
  static const primary = Color(0xFF9B5CFF);
  static const primaryLight = Color(0xFFC7A6FF);
  static const primaryDark = Color(0xFF6A2FE0);

  // Each accent has one job
  static const cyan = Color(0xFF2EE6FF); // timers and info
  static const green = Color(0xFF4DFF7C); // correct answers
  static const yellow = Color(0xFFFFD21F); // XP and coins
  static const pink = Color(0xFFFF4FA3); // streaks and combos
  static const danger = Color(0xFFFF4D4D); // wrong answers and lives

  static const textPrimary = Color(0xFFFFFFFF);
  static const textSecondary = Color(0xFFD3C4FF);
  static const textMuted = Color(0xFF9C86E0);

  // Dark tints behind each accent
  static const primaryTint = Color(0xFF3A1D8F);
  static const cyanTint = Color(0xFF0B3A66);
  static const greenTint = Color(0xFF0B4A3A);
  static const yellowTint = Color(0xFF4D3A0B);
  static const dangerTint = Color(0xFF591236);

  // Gradients and glow for rewards
  static const brandGradient = LinearGradient(
    colors: [primary, pink],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
  static const xpGradient = LinearGradient(colors: [yellow, pink]);
  static const progressGradient = LinearGradient(colors: [primary, cyan]);

  static List<BoxShadow> glow(Color c) => [
    BoxShadow(color: c.withValues(alpha: 0.6), blurRadius: 24),
  ];

  // Aliases used by older screens.
  static Color get pinkRed => pink;
  static Color get redTint => dangerTint;
  static Color get purpleTint => primaryTint;
}
