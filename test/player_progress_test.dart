import 'package:flutter_test/flutter_test.dart';
import 'package:member4_minigames/services/player_progress.dart';

void main() {
  test('game rewards update XP, coins, level and cleared-game progress', () {
    final progress = PlayerProgress.instance;

    progress.recordWin('test_game', 400);

    expect(progress.level, 9);
    expect(progress.xp, 40);
    expect(progress.coins, 360);
    expect(progress.completedGames, contains('test_game'));
  });
}
