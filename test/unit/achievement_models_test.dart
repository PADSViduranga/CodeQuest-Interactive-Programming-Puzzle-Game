import 'package:codequest/features/daily_challenge/data/daily_bonus_service.dart';
import 'package:codequest/features/games/domain/answer_result.dart';
import 'package:codequest/features/profile/domain/player_profile.dart';
import 'package:codequest/features/rewards/domain/achievement_catalog.dart';
import 'package:codequest/features/rewards/domain/earned_achievement.dart';
import 'package:codequest/features/rewards/domain/earned_badge.dart';
import 'package:codequest/features/rewards/domain/reward_chain.dart';
import 'package:flutter_test/flutter_test.dart';

const nice = EarnedAchievement(
  id: 'puzzle_10',
  name: 'Puzzle Solver',
  description: 'Solve 10 puzzles.',
  rewardXp: 100,
);

void main() {
  test('an answer result reads the achievements the server sends', () {
    final r = AnswerResult.fromMap({
      'correct': true,
      'newAchievements': [
        <Object?, Object?>{
          'id': 'puzzle_10',
          'name': 'Puzzle Solver',
          'description': 'Solve 10 puzzles.',
          'rewardXp': 100,
        },
      ],
    });
    expect(r.newAchievements.single.name, 'Puzzle Solver');
    expect(r.newAchievements.single.rewardXp, 100);
    expect(AnswerResult.fromMap({'correct': true}).newAchievements, isEmpty);
  });

  test('a daily bonus result reads achievements too', () {
    final r = DailyBonusResult.fromMap({
      'status': 'claimed',
      'newAchievements': [
        <Object?, Object?>{
          'id': 'bonus_7',
          'name': 'Bonus Hunter',
          'rewardXp': 150,
        },
      ],
    });
    expect(r.newAchievements.single.id, 'bonus_7');
  });

  test('a profile reads its stats and achievements', () {
    final p = PlayerProfile.fromMap('u', {
      'stats': {'puzzlesSolved': 4, 'bestCombo': 3.0, 'bad': 'x'},
      'achievements': ['puzzle_10', 7],
    });
    expect(p.stats, {'puzzlesSolved': 4, 'bestCombo': 3});
    expect(p.achievements, ['puzzle_10']);
    final empty = PlayerProfile.fromMap('u', {});
    expect(empty.stats, isEmpty);
    expect(empty.achievements, isEmpty);
  });

  test('the achievement catalog matches the server list', () {
    expect(
      achievementCatalog.map(
        (a) => '${a.id}:${a.stat}:${a.target}:${a.rewardXp}',
      ),
      [
        'puzzle_10:puzzlesSolved:10:100',
        'puzzle_50:puzzlesSolved:50:300',
        'minigames_10:miniGamesWon:10:100',
        'combo_5:bestCombo:5:100',
        'bonus_7:bonusesClaimed:7:150',
      ],
    );
  });

  test(
    'an achievement alone opens the unlock screen with its label and XP',
    () {
      final uri = Uri.parse(
        buildRewardChain(badges: const [], achievements: [nice])!,
      );
      expect(uri.path, '/badge');
      expect(uri.queryParameters['name'], 'Puzzle Solver');
      expect(uri.queryParameters['desc'], 'Solve 10 puzzles. +100 XP');
      expect(uri.queryParameters['label'], 'ACHIEVEMENT UNLOCKED');
      expect(uri.queryParameters.containsKey('next'), isFalse);
    },
  );

  test('the chain goes level up, then badges, then achievements', () {
    final first = Uri.parse(
      buildRewardChain(
        badges: const [
          EarnedBadge(id: 'first_win', name: 'First Win', description: 'd'),
        ],
        achievements: [nice],
        leveledUpTo: 4,
      )!,
    );
    expect(first.path, '/level-up');

    final second = Uri.parse(first.queryParameters['next']!);
    expect(second.path, '/badge');
    expect(second.queryParameters['name'], 'First Win');
    expect(second.queryParameters.containsKey('label'), isFalse);

    final third = Uri.parse(second.queryParameters['next']!);
    expect(third.queryParameters['name'], 'Puzzle Solver');
    expect(third.queryParameters['label'], 'ACHIEVEMENT UNLOCKED');
    expect(third.queryParameters.containsKey('next'), isFalse);
  });
}
