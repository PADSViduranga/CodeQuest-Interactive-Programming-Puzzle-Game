import 'package:flutter/widgets.dart';

import '../models/game_definition.dart';
import '../screens/game_screen.dart';

/// Local integration seam. Map this method to Member 3's agreed interface
/// when it is available; this prototype does not define that shared contract.
class GameModuleAdapter {
  const GameModuleAdapter._();

  static Widget buildGameScreen(GameDefinition game) => GameScreen(game: game);
}
