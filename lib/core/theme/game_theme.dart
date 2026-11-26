import 'package:flutter/material.dart';

class GameTheme {
  static const background = Color(0xFF0D0F1C);
  static const secondary = Color(0xFF15172A);
  static const card = Color(0xFF1C1B35);
  static const purple = Color(0xFF7139C5);
  static const neon = Color(0xFFA855F7);
  static const cyan = Color(0xFF22D3EE);
  static const gold = Color(0xFFFBBF24);
  static const heart = Color(0xFFFB7185);
  static const muted = Color(0xFFA6A6BD);

  static ThemeData get dark {
    final scheme = ColorScheme.fromSeed(
      seedColor: neon,
      brightness: Brightness.dark,
      primary: neon,
      secondary: cyan,
      surface: card,
      error: heart,
    );
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: scheme,
      scaffoldBackgroundColor: background,
      appBarTheme: const AppBarTheme(
        backgroundColor: background,
        foregroundColor: Colors.white,
        centerTitle: false,
        elevation: 0,
      ),
      cardTheme: CardThemeData(
        color: card,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: secondary,
        hintStyle: const TextStyle(color: muted),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFF343651)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFF343651)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: neon, width: 1.5),
        ),
      ),
    );
  }
}
