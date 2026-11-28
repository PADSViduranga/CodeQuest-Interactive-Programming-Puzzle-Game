import 'package:codequest/core/theme/app_theme.dart';
import 'package:codequest/features/daily_challenge/domain/daily_bonus.dart';
import 'package:codequest/features/daily_challenge/presentation/screens/daily_challenge_screen.dart';
import 'package:codequest/features/profile/domain/player_profile.dart';
import 'package:codequest/features/profile/presentation/providers/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

PlayerProfile profile({String? won, String? claimed, List<String>? days}) =>
    PlayerProfile(
      uid: 'u',
      displayName: 'sav',
      isGuest: false,
      avatarId: 'mito_1',
      totalXp: 0,
      level: 1,
      currentStreak: won == null ? 0 : 1,
      lastStreakDay: won,
      lastDailyBonusDay: claimed,
      recentDays: days ?? const [],
    );

Future<void> show(WidgetTester tester, PlayerProfile? p) async {
  tester.view.physicalSize = const Size(800, 1600);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [playerProfileProvider.overrideWith((ref) => Stream.value(p))],
      child: MaterialApp(
        theme: AppTheme.dark,
        home: const DailyChallengeScreen(),
      ),
    ),
  );
  await tester.pump();
  await tester.pump();
}

void main() {
  final today = dayKeyUtc(DateTime.now());

  testWidgets('before a win the bonus is locked', (tester) async {
    await show(tester, profile());
    expect(find.text('Win any puzzle or mini-game today'), findsOneWidget);
    expect(find.text('Go win something'), findsOneWidget);
    expect(find.textContaining('Claim'), findsNothing);
  });

  testWidgets('after a win the bonus can be claimed', (tester) async {
    await show(tester, profile(won: today, days: [today]));
    expect(find.text('Claim +150 XP'), findsOneWidget);
    expect(find.byIcon(Icons.check), findsOneWidget);
  });

  testWidgets('after claiming it shows completed', (tester) async {
    await show(tester, profile(won: today, claimed: today, days: [today]));
    expect(find.text('Completed today'), findsOneWidget);
    expect(find.textContaining('Claim'), findsNothing);
  });

  testWidgets('the week dots show only days really won', (tester) async {
    await show(tester, profile());
    expect(find.byIcon(Icons.check), findsNothing);
  });
}
