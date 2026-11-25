import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:codequest/features/games/domain/answer_result.dart';
import 'package:codequest/features/games/presentation/providers/game_session_provider.dart';

AnswerResult _result({required bool correct, int xp = 20, int combo = 1}) =>
    AnswerResult(
      correct: correct,
      xpAwarded: correct ? xp : 0,
      newTotalXp: 0,
      newLevel: 1,
      leveledUp: false,
      comboCount: combo,
    );

void main() {
  late ProviderContainer container;
  late GameSessionNotifier session;

  setUp(() {
    container = ProviderContainer();
    addTearDown(container.dispose);
    container.listen(gameSessionProvider, (_, _) {});
    session = container.read(gameSessionProvider.notifier)..start();
  });

  GameSessionState state() => container.read(gameSessionProvider);

  test('a new session has 3 lives and no combo', () {
    expect(state().livesLeft, 3);
    expect(state().comboCount, 0);
    expect(state().sessionId, isNotEmpty);
  });

  test('a correct answer adds XP and keeps the combo', () {
    session.recordResult(_result(correct: true, xp: 30, combo: 2));
    expect(state().xpEarned, 30);
    expect(state().comboCount, 2);
    expect(state().livesLeft, 3);
  });

  test('a wrong answer costs a life and resets the combo', () {
    session.recordResult(_result(correct: true, combo: 3));
    session.recordResult(_result(correct: false));
    expect(state().livesLeft, 2);
    expect(state().comboCount, 0);
  });

  test('three wrong answers finish the session', () {
    for (var i = 0; i < 3; i++) {
      session.recordResult(_result(correct: false));
    }
    expect(state().finished, isTrue);
  });

  test('hints stop at the puzzle limit', () {
    expect(session.useHint(2), isTrue);
    expect(session.useHint(2), isTrue);
    expect(session.useHint(2), isFalse);
    session.nextPuzzle();
    expect(state().hintsUsed, 0);
  });
}
