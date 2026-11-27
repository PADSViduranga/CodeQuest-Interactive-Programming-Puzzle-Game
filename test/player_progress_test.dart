import 'package:flutter_test/flutter_test.dart';
import 'package:codequest/services/player_progress.dart';

void main() {
  test('sync takes level from the server and wraps XP at 100 per level', () {
    final progress = PlayerProgress.instance;

    progress.sync(250, 3);

    expect(progress.level, 3);
    expect(progress.xp, 50);
    expect(progress.levelProgress, 0.5);
  });

  test(
    'a win adds coins and marks the game cleared but leaves XP to the server',
    () {
      final progress = PlayerProgress.instance;
      progress.sync(120, 2);
      final coinsBefore = progress.coins;

      progress.recordWin('test_game', 400);

      expect(progress.coins, coinsBefore + 40);
      expect(progress.completedGames, contains('test_game'));
      expect(progress.level, 2);
      expect(progress.xp, 20);
    },
  );
}
