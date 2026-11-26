import 'package:flutter/foundation.dart';

class PlayerProgress extends ChangeNotifier {
  PlayerProgress._();

  static final PlayerProgress instance = PlayerProgress._();
  static const xpPerLevel = 1600;

  int level = 8;
  int xp = 1240;
  int coins = 320;
  final Set<String> completedGames = {};

  double get levelProgress => xp / xpPerLevel;

  void recordWin(String gameId, int reward) {
    xp += reward;
    coins += reward ~/ 10;
    completedGames.add(gameId);
    while (xp >= xpPerLevel) {
      xp -= xpPerLevel;
      level++;
    }
    notifyListeners();
  }
}
