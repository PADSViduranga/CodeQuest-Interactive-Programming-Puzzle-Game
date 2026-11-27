import 'package:flutter/foundation.dart';

/// Mini-game header state. XP and level come from the server-owned profile
/// through [sync]; only coins and completed games are tracked locally.
class PlayerProgress extends ChangeNotifier {
  PlayerProgress._();

  static final PlayerProgress instance = PlayerProgress._();
  static const xpPerLevel = 100;

  int level = 1;
  int xp = 0;
  int coins = 0;
  final Set<String> completedGames = {};

  double get levelProgress => xp / xpPerLevel;

  void sync(int totalXp, int serverLevel) {
    level = serverLevel;
    xp = totalXp % xpPerLevel;
    notifyListeners();
  }

  void recordWin(String gameId, int reward) {
    coins += reward ~/ 10;
    completedGames.add(gameId);
    notifyListeners();
  }
}
