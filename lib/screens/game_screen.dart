import 'dart:async';
import 'package:flutter/material.dart';
import '../core/theme/game_theme.dart';
import '../data/game_catalog.dart';
import '../engines/drag_buckets_engine.dart';
import '../engines/multiple_choice_engine.dart';
import '../engines/special_game_engines.dart';
import '../engines/typing_engine.dart';
import '../models/game_definition.dart';
import '../powerups/power_up_controller.dart';
import '../services/player_progress.dart';

class GameScreen extends StatefulWidget {
  final GameDefinition game;

  const GameScreen({super.key, required this.game});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  PowerUpController powerUps = PowerUpController();
  Timer? timer;
  int secondsLeft = 60;
  int combo = 0;
  int engineKey = 0;
  bool? result;
  bool finished = false;
  bool skipped = false;
  bool freezeMessage = false;
  Set<String> hiddenOptions = {};

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted || finished || powerUps.timerFrozen) return;
      setState(() => secondsLeft--);
      if (secondsLeft <= 0) finish(false);
    });
  }

  void finish(bool correct) {
    if (finished) return;
    setState(() {
      result = correct;
      finished = true;
      if (correct) {
        combo++;
        PlayerProgress.instance
            .recordWin(widget.game.id, _xpReward(widget.game));
      }
    });
  }

  int _xpReward(GameDefinition game) {
    if (game.id == 'big_o_sprint') return 80;
    return game.difficulty == 'Hard' ? 100 : 50;
  }

  void answer(bool correct) {
    if (correct) {
      finish(true);
      return;
    }
    setState(() {
      combo = 0;
      if (powerUps.loseLife()) {
        result = false;
        finished = true;
      }
    });
    if (!finished && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Not quite — one heart used. Try again!'),
          duration: Duration(milliseconds: 1100),
        ),
      );
    }
  }

  void useSkip() {
    if (powerUps.skipUsed || finished) return;
    setState(() {
      powerUps.useSkip();
      skipped = true;
      finished = true;
      result = false;
    });
  }

  void useFiftyFifty() {
    if (widget.game.mode != GameMode.multipleChoice ||
        powerUps.fiftyFiftyUsed ||
        finished) {
      return;
    }
    setState(() {
      powerUps.useFiftyFifty();
      final wrong = widget.game.options
          .where((option) => option != widget.game.answer)
          .toList()
        ..shuffle();
      hiddenOptions = wrong.take(wrong.length > 2 ? 2 : wrong.length).toSet();
    });
  }

  void useFreeze() {
    if (powerUps.freezeUsed || finished) return;
    setState(() {
      powerUps.useFreeze();
      freezeMessage = true;
    });
  }

  void useExtraLife() {
    if (powerUps.extraLifeUsed || finished) return;
    setState(() => powerUps.useExtraLife());
  }

  void replay() {
    setState(() {
      powerUps = PowerUpController();
      secondsLeft = 60;
      combo = 0;
      result = null;
      finished = false;
      skipped = false;
      freezeMessage = false;
      hiddenOptions = {};
      engineKey++;
    });
    _startTimer();
  }

  @override
  Widget build(BuildContext context) {
    final game = widget.game;
    final progress = secondsLeft / 60;
    return Scaffold(
      appBar: AppBar(
        title: Text(game.title,
            style: const TextStyle(fontWeight: FontWeight.w800)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text('+${game.difficulty == 'Hard' ? 100 : 50} XP',
                  style: const TextStyle(
                      color: GameTheme.gold, fontWeight: FontWeight.w900)),
            ),
          )
        ],
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 820),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(18, 12, 18, 32),
              children: [
                _sessionStatus(progress),
                const SizedBox(height: 18),
                Container(
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: GameTheme.card,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                        color: GameTheme.neon.withValues(alpha: .25)),
                    boxShadow: [
                      BoxShadow(
                          color: GameTheme.neon.withValues(alpha: .08),
                          blurRadius: 24)
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.terminal,
                              color: GameTheme.cyan, size: 18),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(game.category.toUpperCase(),
                                style: const TextStyle(
                                    color: GameTheme.cyan,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 1.3)),
                          ),
                          _difficultyBadge(game.difficulty),
                        ],
                      ),
                      const SizedBox(height: 17),
                      _prompt(game),
                      const SizedBox(height: 20),
                      if (!finished)
                        KeyedSubtree(
                          key: ValueKey(engineKey),
                          child: _gameplay(game),
                        )
                      else
                        _completion(game),
                    ],
                  ),
                ),
                if (!finished) ...[
                  const SizedBox(height: 18),
                  _powerUps(game),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _sessionStatus(double progress) => Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: GameTheme.secondary,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFF2D2E49)),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Row(
                  children: List.generate(
                    powerUps.lives,
                    (_) => const Padding(
                      padding: EdgeInsets.only(right: 3),
                      child: Icon(Icons.favorite,
                          size: 18, color: GameTheme.heart),
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                Text('${powerUps.lives}',
                    style: const TextStyle(fontWeight: FontWeight.w800)),
                const Spacer(),
                const Icon(Icons.local_fire_department,
                    size: 18, color: GameTheme.gold),
                const SizedBox(width: 4),
                Text('${combo}x COMBO',
                    style: const TextStyle(
                        color: GameTheme.gold,
                        fontSize: 11,
                        fontWeight: FontWeight.w900)),
                const SizedBox(width: 18),
                Icon(Icons.timer_outlined,
                    size: 18,
                    color:
                        secondsLeft <= 10 ? GameTheme.heart : GameTheme.cyan),
                const SizedBox(width: 5),
                Text('${secondsLeft}s',
                    style: TextStyle(
                        color:
                            secondsLeft <= 10 ? GameTheme.heart : Colors.white,
                        fontWeight: FontWeight.w900)),
                if (freezeMessage && !finished)
                  IconButton(
                    tooltip: 'Resume timer',
                    onPressed: () => setState(() {
                      powerUps.unfreeze();
                      freezeMessage = false;
                    }),
                    icon: const Icon(Icons.play_arrow, color: GameTheme.cyan),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: progress.clamp(0, 1),
                minHeight: 7,
                backgroundColor: const Color(0xFF292A42),
                valueColor: AlwaysStoppedAnimation(
                    secondsLeft <= 10 ? GameTheme.heart : GameTheme.neon),
              ),
            ),
          ],
        ),
      );

  Widget _prompt(GameDefinition game) {
    final isOutputChallenge = game.id == 'predict_output';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(game.question,
            style: const TextStyle(
                fontSize: 19, height: 1.45, fontWeight: FontWeight.w800)),
        if (isOutputChallenge) ...[
          const SizedBox(height: 13),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: const Color(0xFF101322),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: const Color(0xFF343651)),
            ),
            child: const Text('print(2 + 3 * 2)',
                style: TextStyle(
                    color: GameTheme.cyan,
                    fontSize: 15,
                    fontFamily: 'monospace',
                    height: 1.5)),
          ),
        ],
      ],
    );
  }

  Widget _gameplay(GameDefinition game) {
    switch (game.mode) {
      case GameMode.multipleChoice:
        return MultipleChoiceEngine(
          question: '',
          options: game.options,
          correctAnswer: game.answer,
          hiddenOptions: hiddenOptions,
          onAnswered: answer,
        );
      case GameMode.typing:
        return TypingEngine(
          question: '',
          correctAnswer: game.answer,
          hint: game.hint,
          multiline: game.id == 'write_the_code',
          onAnswered: answer,
        );
      case GameMode.dragBuckets:
        return DragBucketsEngine(
          pairs: game.pairs,
          onCompleted: answer,
        );
      case GameMode.hangman:
        return HangmanEngine(
          word: game.answer,
          question: '',
          onCompleted: answer,
        );
      case GameMode.codeLine:
        return CodeLineEngine(
          lines: game.codeLines,
          answer: game.answer,
          onAnswered: answer,
        );
      case GameMode.ordering:
        return OrderingEngine(
          correctOrder: game.sequence,
          onCompleted: answer,
        );
      case GameMode.logicGate:
        return LogicGateEngine(
          gates: game.options,
          answer: game.answer,
          onAnswered: answer,
        );
      case GameMode.sorting:
        return SortingEngine(values: game.sortValues, onCompleted: answer);
      case GameMode.stack:
        final pushValues = game.sequence
            .where((operation) => operation.startsWith('PUSH '))
            .map((operation) => int.parse(operation.substring(5)))
            .toList();
        return StackEngine(
          pushValues: pushValues,
          expectedTop: int.parse(game.answer),
          onCompleted: answer,
        );
    }
  }

  Widget _completion(GameDefinition game) {
    final won = result == true;
    final nextIndex =
        (GameCatalog.games.indexOf(game) + 1) % GameCatalog.games.length;
    final nextGame = GameCatalog.games[nextIndex];
    return Column(
      children: [
        Icon(
          won
              ? Icons.emoji_events_rounded
              : skipped
                  ? Icons.skip_next_rounded
                  : Icons.sentiment_dissatisfied_rounded,
          size: 68,
          color: won ? GameTheme.gold : GameTheme.heart,
        ),
        const SizedBox(height: 10),
        Text(
          won
              ? 'CHALLENGE CLEARED!'
              : skipped
                  ? 'RUN SKIPPED'
                  : 'RUN OVER',
          textAlign: TextAlign.center,
          style: const TextStyle(
              fontSize: 22, fontWeight: FontWeight.w900, letterSpacing: 1),
        ),
        const SizedBox(height: 7),
        Text(
          won
              ? 'You earned ${_xpReward(game)} XP'
              : 'Correct answer: ${game.answer.isEmpty ? 'review the explanation' : game.answer}',
          textAlign: TextAlign.center,
          style: const TextStyle(color: GameTheme.gold),
        ),
        const SizedBox(height: 8),
        Text(game.explanation,
            textAlign: TextAlign.center,
            style: const TextStyle(color: GameTheme.muted, height: 1.4)),
        const SizedBox(height: 20),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 10,
          runSpacing: 8,
          children: [
            OutlinedButton.icon(
              onPressed: replay,
              icon: const Icon(Icons.replay),
              label: const Text('Replay'),
            ),
            FilledButton.icon(
              onPressed: () => Navigator.of(context).pushReplacement(
                MaterialPageRoute<void>(
                    builder: (_) => GameScreen(game: nextGame)),
              ),
              icon: const Icon(Icons.arrow_forward),
              label: const Text('Next challenge'),
            ),
            TextButton.icon(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.grid_view),
              label: const Text('Game hub'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _powerUps(GameDefinition game) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: GameTheme.secondary,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFF2D2E49)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('POWER-UPS',
                style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 11,
                    letterSpacing: 1.2)),
            const SizedBox(height: 11),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _powerButton(
                    'Skip', Icons.skip_next, powerUps.skipUsed, useSkip),
                _powerButton(
                    '50/50',
                    Icons.filter_2,
                    powerUps.fiftyFiftyUsed ||
                        game.mode != GameMode.multipleChoice,
                    useFiftyFifty),
                _powerButton(
                    'Freeze', Icons.ac_unit, powerUps.freezeUsed, useFreeze),
                _powerButton('Extra life', Icons.favorite,
                    powerUps.extraLifeUsed, useExtraLife),
              ],
            ),
            const SizedBox(height: 9),
            const Text('Each boost can be used once per run.',
                style: TextStyle(color: GameTheme.muted, fontSize: 11)),
          ],
        ),
      );

  Widget _powerButton(
          String label, IconData icon, bool disabled, VoidCallback action) =>
      OutlinedButton.icon(
        onPressed: disabled ? null : action,
        icon: Icon(icon, size: 17),
        label: Text(label),
        style: OutlinedButton.styleFrom(
          foregroundColor: GameTheme.cyan,
          side: const BorderSide(color: Color(0xFF454363)),
        ),
      );

  Widget _difficultyBadge(String difficulty) {
    final color = difficulty == 'Hard'
        ? GameTheme.heart
        : difficulty == 'Medium'
            ? GameTheme.gold
            : const Color(0xFF34D399);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
          color: color.withValues(alpha: .12),
          borderRadius: BorderRadius.circular(30)),
      child: Text(difficulty.toUpperCase(),
          style: TextStyle(
              color: color,
              fontSize: 9,
              fontWeight: FontWeight.w900,
              letterSpacing: .5)),
    );
  }
}

class HangmanEngine extends StatefulWidget {
  final String word;
  final String question;
  final ValueChanged<bool> onCompleted;

  const HangmanEngine({
    super.key,
    required this.word,
    required this.question,
    required this.onCompleted,
  });

  @override
  State<HangmanEngine> createState() => _HangmanEngineState();
}

class _HangmanEngineState extends State<HangmanEngine> {
  final Set<String> guessed = {};
  int mistakes = 0;
  static const maxMistakes = 6;
  bool ended = false;

  @override
  Widget build(BuildContext context) {
    final letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'.split('');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          widget.word
              .split('')
              .map((letter) => guessed.contains(letter) ? letter : '_')
              .join(' '),
          textAlign: TextAlign.center,
          style: const TextStyle(
              color: GameTheme.cyan,
              fontSize: 28,
              letterSpacing: 3,
              fontWeight: FontWeight.w900,
              fontFamily: 'monospace'),
        ),
        const SizedBox(height: 8),
        Text('MISSES  $mistakes / $maxMistakes',
            textAlign: TextAlign.center,
            style: const TextStyle(color: GameTheme.heart)),
        const SizedBox(height: 14),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 5,
          runSpacing: 5,
          children: letters
              .map(
                (letter) => SizedBox(
                  width: 39,
                  height: 42,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      padding: EdgeInsets.zero,
                      backgroundColor: guessed.contains(letter)
                          ? const Color(0xFF343651)
                          : GameTheme.purple,
                    ),
                    onPressed: guessed.contains(letter) || ended
                        ? null
                        : () {
                            setState(() {
                              guessed.add(letter);
                              if (!widget.word.contains(letter)) mistakes++;
                              if (widget.word
                                  .split('')
                                  .every(guessed.contains)) {
                                ended = true;
                                widget.onCompleted(true);
                              } else if (mistakes >= maxMistakes) {
                                ended = true;
                                widget.onCompleted(false);
                              }
                            });
                          },
                    child: Text(letter),
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}
