import 'package:flutter/widgets.dart';

import '../core/game_module.dart';
import '../core/game_type.dart';
import '../engines/select_grid_view.dart';

class GridModule extends GameModule {
  @override
  GameType get type => GameType.grid;

  @override
  Widget build(BuildContext context, GameModuleArgs args) =>
      SelectGridView(key: ValueKey(args.puzzle.id), args: args);
}
