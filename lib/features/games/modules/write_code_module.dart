import 'package:flutter/widgets.dart';

import '../core/game_module.dart';
import '../core/game_type.dart';
import '../engines/code_editor_view.dart';

class WriteCodeModule extends GameModule {
  @override
  GameType get type => GameType.writeCode;

  @override
  Widget build(BuildContext context, GameModuleArgs args) =>
      CodeEditorView(key: ValueKey(args.puzzle.id), args: args);
}
