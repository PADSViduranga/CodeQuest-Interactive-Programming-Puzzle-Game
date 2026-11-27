import 'package:flutter/material.dart';

/// App colors. The accent colors never change. The neutral ones (backgrounds,
/// cards, borders, text and tints) follow [isDark], which the theme builder
/// sets from the saved light/dark choice.
class AppColors {
  AppColors._();

  static bool isDark = true;

  static Color _pick(Color dark, Color light) => isDark ? dark : light;

  // Backgrounds and borders
  static Color get background =>
      _pick(const Color(0xFF0A1514), const Color(0xFFE0F5F2));
  static Color get surface =>
      _pick(const Color(0xFF12241F), const Color(0xFFFFFFFF));
  static Color get surfaceRaised =>
      _pick(const Color(0xFF1A332C), const Color(0xFFF0FAF8));
  static Color get border =>
      _pick(const Color(0xFF1F3C35), const Color(0xFFB3E3DD));

  // Teal for main buttons, with dark text on top
  static const primary = Color(0xFF2DD4BF);
  static const primaryDark = Color(0xFF159584);
  static const onPrimary = Color(0xFF03211D);
  static Color get primaryLight =>
      _pick(const Color(0xFF6BE8D6), const Color(0xFF0A6B62));

  // Each accent has one job
  static const cyan = Color(0xFF5CC8F5); // timers and info
  static const green = Color(0xFF8BE04E); // correct answers
  static const yellow = Color(0xFFFFE14D); // XP and coins
  static const pink = Color(0xFFFF8FA3); // streaks and combos
  static const danger = Color(0xFFFF6B6B); // wrong answers and lives

  // Text
  static Color get textPrimary =>
      _pick(const Color(0xFFFFFFFF), const Color(0xFF0B2F2B));
  static Color get textSecondary =>
      _pick(const Color(0xFF9CC7C0), const Color(0xFF3F6E69));
  static Color get textMuted =>
      _pick(const Color(0xFF6F9A93), const Color(0xFF7A9E99));

  // Tints behind each accent
  static Color get primaryTint =>
      _pick(const Color(0xFF123B36), const Color(0xFFD3F2EC));
  static Color get cyanTint =>
      _pick(const Color(0xFF0F3347), const Color(0xFFD6EEFA));
  static Color get greenTint =>
      _pick(const Color(0xFF1E3D12), const Color(0xFFE3F5D3));
  static Color get yellowTint =>
      _pick(const Color(0xFF4A3B12), const Color(0xFFFFF2C7));
  static Color get dangerTint =>
      _pick(const Color(0xFF4D1F2B), const Color(0xFFFFE0E0));

  // Darker versions of the bright accents, for text in light mode.
  static Color get yellowInk => _pick(yellow, const Color(0xFF9A6B00));
  static Color get cyanInk => _pick(cyan, const Color(0xFF0B76A8));
  static Color get pinkInk => _pick(pink, const Color(0xFFC72E52));
  static Color get greenInk => _pick(green, const Color(0xFF3F8A0F));

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
  static const Color pinkRed = pink;
  static Color get redTint => dangerTint;
  static Color get purpleTint => primaryTint;
}
