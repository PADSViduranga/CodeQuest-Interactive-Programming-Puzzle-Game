import 'package:codequest/features/rewards/domain/earned_badge.dart';
import 'package:codequest/features/rewards/domain/reward_chain.dart';
import 'package:flutter_test/flutter_test.dart';

EarnedBadge badge(String id, String name) =>
    EarnedBadge(id: id, name: name, description: 'About $name');

void main() {
  test('nothing earned means no reward screens', () {
    expect(buildRewardChain(badges: const []), isNull);
  });

  test('one badge opens the badge screen with no next', () {
    final uri = Uri.parse(
      buildRewardChain(badges: [badge('first_win', 'First Win')])!,
    );
    expect(uri.path, '/badge');
    expect(uri.queryParameters['name'], 'First Win');
    expect(uri.queryParameters['desc'], 'About First Win');
    expect(uri.queryParameters.containsKey('next'), isFalse);
  });

  test('a level up comes first, then each badge in order', () {
    final first = Uri.parse(
      buildRewardChain(
        badges: [badge('a', 'Alpha'), badge('b', 'Beta & Co')],
        leveledUpTo: 5,
      )!,
    );
    expect(first.path, '/level-up');
    expect(first.queryParameters['level'], '5');

    final second = Uri.parse(first.queryParameters['next']!);
    expect(second.path, '/badge');
    expect(second.queryParameters['name'], 'Alpha');

    final third = Uri.parse(second.queryParameters['next']!);
    expect(third.path, '/badge');
    expect(third.queryParameters['name'], 'Beta & Co');
    expect(third.queryParameters.containsKey('next'), isFalse);
  });

  test('a level up on its own works', () {
    final uri = Uri.parse(buildRewardChain(badges: const [], leveledUpTo: 2)!);
    expect(uri.path, '/level-up');
    expect(uri.queryParameters.containsKey('next'), isFalse);
  });
}
