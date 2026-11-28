import 'package:codequest/features/games/domain/answer_result.dart';
import 'package:codequest/features/profile/domain/player_profile.dart';
import 'package:codequest/features/rewards/domain/badge_catalog.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('an answer result reads the badges the server sends', () {
    final result = AnswerResult.fromMap({
      'correct': true,
      'newBadges': [
        // Cloud Functions hands back maps keyed by Object?, not String.
        <Object?, Object?>{
          'id': 'first_win',
          'name': 'First Win',
          'description': 'Solve your first puzzle.',
        },
      ],
    });
    expect(result.newBadges, hasLength(1));
    expect(result.newBadges.first.id, 'first_win');
    expect(result.newBadges.first.name, 'First Win');
  });

  test('an answer result without badges has an empty list', () {
    expect(AnswerResult.fromMap({'correct': true}).newBadges, isEmpty);
    expect(
      AnswerResult.fromMap({'correct': true, 'newBadges': 'oops'}).newBadges,
      isEmpty,
    );
  });

  test('a profile reads its badge ids and ignores bad entries', () {
    final p = PlayerProfile.fromMap('u1', {
      'badges': ['first_win', 3, 'streak_3'],
    });
    expect(p.badges, ['first_win', 'streak_3']);
  });

  test('an old profile with no badges field has none', () {
    expect(PlayerProfile.fromMap('u1', {}).badges, isEmpty);
  });

  test('the badge catalog matches the server badge ids', () {
    final ids = badgeCatalog.map((b) => b.id).toList();
    expect(ids.toSet(), hasLength(ids.length));
    expect(ids, ['first_win', 'streak_3', 'streak_7', 'level_5', 'xp_500']);
  });
}
