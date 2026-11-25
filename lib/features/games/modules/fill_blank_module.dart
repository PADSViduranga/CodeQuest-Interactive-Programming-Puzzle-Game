import 'package:flutter/widgets.dart';

import '../core/game_module.dart';
import '../core/game_type.dart';
import '../engines/fill_blank_view.dart';

class FillBlankModule extends GameModule {
  @override
  GameType get type => GameType.fillBlank;

  @override
  Widget build(BuildContext context, GameModuleArgs args) =>
      FillBlankView(key: ValueKey(args.puzzle.id), args: args);
}
