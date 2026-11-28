import 'package:codequest/core/theme/app_theme.dart';
import 'package:codequest/features/profile/domain/player_profile.dart';
import 'package:codequest/features/profile/presentation/providers/profile_provider.dart';
import 'package:codequest/features/rewards/presentation/screens/achievements_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

PlayerProfile profile({
  Map<String, int> stats = const {},
  List<String> achievements = const [],
}) => PlayerProfile(
  uid: 'u',
  displayName: 'sav',
  isGuest: false,
  avatarId: 'mito_1',
  totalXp: 0,
  level: 1,
  currentStreak: 0,
  stats: stats,
  achievements: achievements,
);

Future<void> show(WidgetTester tester, PlayerProfile? p) async {
  tester.view.physicalSize = const Size(800, 2000);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [playerProfileProvider.overrideWith((ref) => Stream.value(p))],
      child: MaterialApp(
        theme: AppTheme.dark,
        home: const AchievementsScreen(),
      ),
    ),
  );
  await tester.pump();
  await tester.pump();
}

void main() {
  testWidgets('a new player sees every goal at zero', (tester) async {
    await show(tester, profile());
    expect(find.text('ACHIEVEMENTS  0 / 5'), findsOneWidget);
    expect(find.text('Puzzle Solver'), findsOneWidget);
    expect(find.text('0 / 10'), findsNWidgets(2)); // puzzles and mini-games
    expect(find.text('Unlocked'), findsNothing);
  });

  testWidgets('progress and unlocked goals come from the profile', (
    tester,
  ) async {
    await show(
      tester,
      profile(
        stats: {'puzzlesSolved': 4, 'miniGamesWon': 12},
        achievements: ['minigames_10'],
      ),
    );
    expect(find.text('ACHIEVEMENTS  1 / 5'), findsOneWidget);
    expect(find.text('4 / 10'), findsOneWidget);
    expect(find.text('4 / 50'), findsOneWidget);
    // 12 wins are shown capped at the target of 10.
    expect(find.text('10 / 10'), findsOneWidget);
    expect(find.text('Unlocked'), findsOneWidget);
  });
}
