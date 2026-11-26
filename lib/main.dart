import 'package:flutter/material.dart';
import 'core/theme/game_theme.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const Member4MiniGamesApp());
}

class Member4MiniGamesApp extends StatelessWidget {
  const Member4MiniGamesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Code Quest Arcade',
      debugShowCheckedModeBanner: false,
      theme: GameTheme.dark,
      home: const GameHomeScreen(),
    );
  }
}
