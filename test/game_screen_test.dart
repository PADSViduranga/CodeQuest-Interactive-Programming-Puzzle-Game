import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:member4_minigames/core/theme/game_theme.dart';
import 'package:member4_minigames/data/game_catalog.dart';
import 'package:member4_minigames/screens/game_screen.dart';

void main() {
  testWidgets('every catalog challenge opens without a widget error',
      (tester) async {
    for (final game in GameCatalog.games) {
      await tester.pumpWidget(MaterialApp(
        theme: GameTheme.dark,
        home: GameScreen(game: game),
      ));
      expect(find.text(game.title), findsOneWidget, reason: game.id);
      expect(tester.takeException(), isNull, reason: game.id);
    }

    await tester.pumpWidget(const SizedBox.shrink());
  });
}
