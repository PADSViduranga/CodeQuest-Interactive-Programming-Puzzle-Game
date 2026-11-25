import 'package:flutter/widgets.dart';

import '../domain/answer_result.dart';
import '../domain/puzzle.dart';
import 'game_type.dart';

/// Read only view of the running session, given to every game.
abstract class GameSessionView {
  int get livesLeft;
  int get hintsUsed;
  int get comboCount;
  Duration get elapsed;
  Set<String> get hiddenOptionIds;
}

/// Everything a game needs from the frame around it.
class GameModuleArgs {
  const GameModuleArgs({
    required this.puzzle,
    required this.session,
    required this.submit,
    required this.requestHint,
  });

  final Puzzle puzzle;
  final GameSessionView session;

  /// Sends the player's answer to the server and returns the result.
  final Future<AnswerResult> Function(Map<String, dynamic> answer) submit;
  final VoidCallback requestHint;
}

/// One mini-game. It only draws its puzzle; the frame does the rest.
abstract class GameModule {
  GameType get type;

  Widget build(BuildContext context, GameModuleArgs args);
}
