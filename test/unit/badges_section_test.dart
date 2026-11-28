import 'package:codequest/core/theme/app_theme.dart';
import 'package:codequest/features/rewards/presentation/widgets/badges_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget host(List<String> earned) => MaterialApp(
  theme: AppTheme.dark,
  home: Scaffold(body: BadgesSection(earned: earned)),
);

void main() {
  testWidgets('shows how many badges are earned and locks the rest', (
    tester,
  ) async {
    await tester.pumpWidget(host(['first_win', 'streak_3']));
    expect(find.text('BADGES  2 / 5'), findsOneWidget);
    expect(find.text('First Win'), findsOneWidget);
    expect(find.text('On a Roll'), findsOneWidget);
    expect(find.byIcon(Icons.lock_outline_rounded), findsNWidgets(3));
  });

  testWidgets('a new player has every badge locked', (tester) async {
    await tester.pumpWidget(host(const []));
    expect(find.text('BADGES  0 / 5'), findsOneWidget);
    expect(find.byIcon(Icons.lock_outline_rounded), findsNWidgets(5));
  });
}
