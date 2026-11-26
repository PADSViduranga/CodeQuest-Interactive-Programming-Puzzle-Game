import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:codequest/core/theme/game_theme.dart';
import 'package:codequest/data/game_catalog.dart';
import 'package:codequest/screens/home_screen.dart';

void main() {
  test('catalog contains all 30 distinct requested games', () {
    expect(GameCatalog.games, hasLength(30));
    expect(GameCatalog.games.map((game) => game.id).toSet(), hasLength(30));
    expect(
      GameCatalog.games.map((game) => game.title),
      containsAll([
        'Predict the Output',
        'True or False Blitz',
        'Big O Sprint',
        'Git Quest',
        'Status Code Match',
        'Code Review Duel',
        'Error Decoder',
        'Naming Judge',
        'Operator Match',
        'Word Scramble',
        'Keyword Hangman',
        'Binary Blitz',
        'Syntax Speedrun',
        'Code Match',
        'Data Type Sorter',
        'Bug Hunt',
        'Block Builder',
        'Flowchart Fixer',
        'Query Builder',
        'Request Builder',
        'Log Detective',
        'Code Maze',
        'Logic Gates Lab',
        'Sort Showdown',
        'Recursion Tower',
        'Variable Tracer',
        'Stack Attack',
        'Tree Traversal',
        'Regex Rush',
        'Write the Code',
      ]),
    );
  });

  testWidgets('home screen presents the game hub and filters games', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(theme: GameTheme.dark, home: const GameHomeScreen()),
    );

    expect(find.text('CODE QUEST'), findsOneWidget);
    expect(find.text('DAILY CHALLENGE  •  +80 XP'), findsOneWidget);
    expect(find.text('30 GAMES'), findsOneWidget);

    await tester.enterText(find.byType(TextField).first, 'Regex Rush');
    await tester.pumpAndSettle();
    expect(find.text('Regex Rush'), findsNWidgets(2));
    expect(find.text('1 GAMES'), findsOneWidget);
  });

  testWidgets('home screen lays out on a mobile-sized viewport', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(theme: GameTheme.dark, home: const GameHomeScreen()),
    );

    expect(tester.takeException(), isNull);
    expect(find.text('CODE QUEST'), findsOneWidget);
    expect(find.text('30 GAMES'), findsOneWidget);
  });
}
