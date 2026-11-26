import 'package:flutter/widgets.dart';

import '../core/game_module.dart';
import '../core/game_type.dart';
import '../engines/typing_view.dart';

class TypingModule extends GameModule {
  @override
  GameType get type => GameType.typing;

  @override
  Widget build(BuildContext context, GameModuleArgs args) =>
      TypingView(key: ValueKey(args.puzzle.id), args: args);
}
