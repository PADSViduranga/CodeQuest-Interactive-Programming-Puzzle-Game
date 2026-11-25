import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/game_module.dart';
import '../../data/answer_service.dart';
import '../../data/demo_answer_service.dart';
import '../../domain/answer_result.dart';

final answerServiceProvider = Provider<AnswerService>(
  (ref) => kDebugMode
      ? DemoAnswerService()
      : CloudAnswerService(FirebaseFunctions.instance),
);

class GameSessionState implements GameSessionView {
  const GameSessionState({
    this.sessionId = '',
    this.livesLeft = 3,
    this.hintsUsed = 0,
    this.comboCount = 0,
    this.elapsed = Duration.zero,
    this.hiddenOptionIds = const {},
    this.answered = 0,
    this.correctCount = 0,
    this.xpEarned = 0,
  });

  @override
  final int livesLeft;
  @override
  final int hintsUsed;
  @override
  final int comboCount;
  @override
  final Duration elapsed;
  @override
  final Set<String> hiddenOptionIds;

  final String sessionId;
  final int answered;
  final int correctCount;
  final int xpEarned;

  bool get finished => livesLeft <= 0;

  GameSessionState copyWith({
    int? livesLeft,
    int? hintsUsed,
    int? comboCount,
    Duration? elapsed,
    Set<String>? hiddenOptionIds,
    int? answered,
    int? correctCount,
    int? xpEarned,
  }) => GameSessionState(
    sessionId: sessionId,
    livesLeft: livesLeft ?? this.livesLeft,
    hintsUsed: hintsUsed ?? this.hintsUsed,
    comboCount: comboCount ?? this.comboCount,
    elapsed: elapsed ?? this.elapsed,
    hiddenOptionIds: hiddenOptionIds ?? this.hiddenOptionIds,
    answered: answered ?? this.answered,
    correctCount: correctCount ?? this.correctCount,
    xpEarned: xpEarned ?? this.xpEarned,
  );
}

class GameSessionNotifier extends Notifier<GameSessionState> {
  @override
  GameSessionState build() => const GameSessionState();

  /// Starts a fresh play session (3 lives, no combo).
  void start() {
    state = GameSessionState(
      sessionId: DateTime.now().microsecondsSinceEpoch.toString(),
    );
  }

  /// Resets the per-puzzle values before the next puzzle.
  void nextPuzzle() {
    state = state.copyWith(
      hintsUsed: 0,
      elapsed: Duration.zero,
      hiddenOptionIds: const {},
    );
  }

  void tick() {
    state = state.copyWith(elapsed: state.elapsed + const Duration(seconds: 1));
  }

  /// Returns false when the puzzle has no hints left.
  bool useHint(int maxHints) {
    if (state.hintsUsed >= maxHints) return false;
    state = state.copyWith(hintsUsed: state.hintsUsed + 1);
    return true;
  }

  void hideOptions(Set<String> ids) {
    state = state.copyWith(hiddenOptionIds: {...state.hiddenOptionIds, ...ids});
  }

  void recordResult(AnswerResult r) {
    if (r.correct) {
      state = state.copyWith(
        comboCount: r.comboCount,
        correctCount: state.correctCount + 1,
        xpEarned: state.xpEarned + r.xpAwarded,
        answered: state.answered + 1,
      );
    } else {
      state = state.copyWith(
        livesLeft: state.livesLeft - 1,
        comboCount: 0,
        answered: state.answered + 1,
      );
    }
  }
}

final gameSessionProvider =
    NotifierProvider.autoDispose<GameSessionNotifier, GameSessionState>(
      GameSessionNotifier.new,
    );
