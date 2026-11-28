import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../core/game_module.dart';
import '../../../rewards/domain/earned_achievement.dart';
import '../../../rewards/domain/earned_badge.dart';
import '../../../rewards/domain/reward_chain.dart';
import '../../domain/answer_result.dart';
import '../../domain/puzzle.dart';
import '../providers/game_session_provider.dart';
import '../providers/games_providers.dart';

/// The frame around every game: close button, lives, progress, timer,
/// combo, hints and the feedback sheet. A game only draws its puzzle.
class GamePlayScreen extends ConsumerStatefulWidget {
  const GamePlayScreen({super.key, required this.stageId});

  final String stageId;

  @override
  ConsumerState<GamePlayScreen> createState() => _GamePlayScreenState();
}

class _GamePlayScreenState extends ConsumerState<GamePlayScreen> {
  int _index = 0;
  Timer? _timer;
  bool _locked = false; // true while an answer is being checked or shown

  // Rewards earned during this stage, shown after the stage-complete screen.
  final List<EarnedBadge> _badges = [];
  final List<EarnedAchievement> _achievements = [];
  int? _leveledUpTo;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(gameSessionProvider.notifier).start());
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted && !_locked) ref.read(gameSessionProvider.notifier).tick();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<AnswerResult> _submit(
    Puzzle puzzle,
    int total,
    Map<String, dynamic> answer,
  ) async {
    _locked = true;
    final session = ref.read(gameSessionProvider);
    final AnswerResult result;
    try {
      result = await ref
          .read(answerServiceProvider)
          .submitAnswer(
            puzzleId: puzzle.id,
            sessionId: session.sessionId,
            submissionId:
                '${session.sessionId}_${puzzle.id}_${session.answered}',
            answer: answer,
            timeTakenMs: session.elapsed.inMilliseconds,
            hintsUsed: session.hintsUsed,
          );
    } catch (_) {
      _locked = false;
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not check your answer. Try again.'),
          ),
        );
      }
      rethrow;
    }
    ref.read(gameSessionProvider.notifier).recordResult(result);
    if (result.leveledUp) _leveledUpTo = result.newLevel;
    for (final b in result.newBadges) {
      if (!_badges.any((e) => e.id == b.id)) _badges.add(b);
    }
    for (final a in result.newAchievements) {
      if (!_achievements.any((e) => e.id == a.id)) _achievements.add(a);
    }
    // Return first so the game can colour the answer, then show feedback.
    Future.microtask(() => _afterResult(result, total));
    return result;
  }

  Future<void> _afterResult(AnswerResult result, int total) async {
    if (!mounted) return;
    await _showFeedback(result);
    if (!mounted) return;

    final notifier = ref.read(gameSessionProvider.notifier);
    final s = ref.read(gameSessionProvider);

    if (s.finished) {
      await showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (_) => AlertDialog(
          title: const Text('Out of lives'),
          content: const Text('Take a breather and try the stage again.'),
          actions: [
            FilledButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Back to map'),
            ),
          ],
        ),
      );
      if (mounted) context.go('/home');
      return;
    }

    if (_index + 1 >= total) {
      final correct = s.correctCount;
      final stars = correct == total ? 3 : (correct >= total * 0.6 ? 2 : 1);
      final next = buildRewardChain(
        achievements: _achievements,
        badges: _badges,
        leveledUpTo: _leveledUpTo,
      );
      final url = Uri(
        path: '/stage-complete',
        queryParameters: {
          'stars': '$stars',
          'xp': '${s.xpEarned}',
          'accuracy': '${(100 * correct / total).round()}',
          'combo': '${s.comboCount < 1 ? 1 : s.comboCount}',
          if (next != null) 'next': next,
        },
      ).toString();
      context.pushReplacement(url);
      return;
    }

    notifier.nextPuzzle();
    setState(() {
      _index++;
      _locked = false;
    });
  }

  Future<void> _showFeedback(AnswerResult r) {
    final color = r.correct ? AppColors.green : AppColors.danger;
    return showModalBottomSheet<void>(
      context: context,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: r.correct ? AppColors.greenTint : AppColors.dangerTint,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(
                  r.correct ? Icons.check_circle : Icons.cancel,
                  color: color,
                  size: 28,
                ),
                const SizedBox(width: 10),
                Text(
                  r.correct ? 'Correct!' : 'Not quite',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: color,
                  ),
                ),
                const Spacer(),
                if (r.correct)
                  Text(
                    '+${r.xpAwarded} XP',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      color: AppColors.yellowInk,
                    ),
                  ),
              ],
            ),
            if (r.explanation != null) ...[
              const SizedBox(height: 10),
              Text(
                r.explanation!,
                style: TextStyle(color: AppColors.textSecondary),
              ),
            ],
            const SizedBox(height: 18),
            FilledButton(
              style: FilledButton.styleFrom(backgroundColor: color),
              onPressed: () => Navigator.of(sheetContext).pop(),
              child: const Text('Continue'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _hint(Puzzle puzzle) async {
    final notifier = ref.read(gameSessionProvider.notifier);
    final messenger = ScaffoldMessenger.of(context);
    if (!notifier.useHint(puzzle.maxHints)) {
      messenger.showSnackBar(const SnackBar(content: Text('No hints left')));
      return;
    }
    final number = ref.read(gameSessionProvider).hintsUsed;
    final text = await ref
        .read(answerServiceProvider)
        .getHint(puzzle.id, number);
    messenger.showSnackBar(
      SnackBar(content: Text('Hint: ${text ?? 'No more hints'}')),
    );
  }

  Future<void> _confirmQuit() async {
    final quit = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Quit this stage?'),
        content: const Text('Your progress in this stage will be lost.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Keep playing'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Quit'),
          ),
        ],
      ),
    );
    if (quit == true && mounted) context.go('/home');
  }

  String _mmss(Duration d) =>
      '${d.inMinutes.toString().padLeft(2, '0')}:${(d.inSeconds % 60).toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    final puzzlesAsync = ref.watch(stagePuzzlesProvider(widget.stageId));
    final session = ref.watch(gameSessionProvider);

    return Scaffold(
      body: SafeArea(
        child: puzzlesAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Could not load puzzles: $e')),
          data: (puzzles) {
            if (puzzles.isEmpty) {
              return const Center(child: Text('No puzzles in this stage yet.'));
            }
            final puzzle = puzzles[_index];
            final module = ref.read(gameFactoryProvider).moduleFor(puzzle.type);
            final args = GameModuleArgs(
              puzzle: puzzle,
              session: session,
              submit: (answer) => _submit(puzzle, puzzles.length, answer),
              requestHint: () => _hint(puzzle),
            );

            return Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: _confirmQuit,
                      ),
                      for (var i = 0; i < 3; i++)
                        Icon(
                          i < session.livesLeft
                              ? Icons.favorite
                              : Icons.favorite_border,
                          size: 20,
                          color: i < session.livesLeft
                              ? AppColors.pink
                              : AppColors.textMuted,
                        ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(99),
                          child: LinearProgressIndicator(
                            value: _index / puzzles.length,
                            minHeight: 7,
                            color: AppColors.primary,
                            backgroundColor: AppColors.border,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      _Pill(
                        icon: Icons.timer_outlined,
                        text: _mmss(session.elapsed),
                        color: AppColors.cyan,
                      ),
                      if (session.comboCount > 1) ...[
                        const SizedBox(width: 6),
                        _Pill(
                          icon: Icons.bolt,
                          text: 'x${session.comboCount}',
                          color: AppColors.yellow,
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: SingleChildScrollView(
                      child: IgnorePointer(
                        ignoring: false,
                        child: module.build(context, args),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _locked ? null : args.requestHint,
                          icon: const Icon(Icons.lightbulb_outline, size: 18),
                          label: Text(
                            'Hint (${puzzle.maxHints - session.hintsUsed} left)',
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.icon, required this.text, required this.color});

  final IconData icon;
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      color: color.withValues(alpha: 0.14),
      borderRadius: BorderRadius.circular(999),
      border: Border.all(color: color.withValues(alpha: 0.5)),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: color),
        const SizedBox(width: 3),
        Text(
          text,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
      ],
    ),
  );
}
