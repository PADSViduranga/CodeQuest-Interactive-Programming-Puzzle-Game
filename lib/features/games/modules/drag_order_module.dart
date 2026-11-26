import 'package:flutter/widgets.dart';

import '../core/game_module.dart';
import '../core/game_type.dart';
import '../engines/ordering_view.dart';

class DragOrderModule extends GameModule {
  @override
  GameType get type => GameType.dragOrder;

  @override
  Widget build(BuildContext context, GameModuleArgs args) =>
      OrderingView(key: ValueKey(args.puzzle.id), args: args);
}
