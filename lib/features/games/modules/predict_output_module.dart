import 'package:flutter/widgets.dart';

import '../core/game_module.dart';
import '../core/game_type.dart';
import '../engines/multiple_choice_view.dart';

class PredictOutputModule extends GameModule {
  @override
  GameType get type => GameType.predictOutput;

  @override
  Widget build(BuildContext context, GameModuleArgs args) =>
      MultipleChoiceView(key: ValueKey(args.puzzle.id), args: args);
}
