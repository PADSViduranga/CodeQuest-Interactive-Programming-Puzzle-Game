import '../core/game_factory.dart';
import 'drag_order_module.dart';
import 'fill_blank_module.dart';
import 'fix_bug_module.dart';
import 'grid_module.dart';
import 'typing_module.dart';
import 'write_code_module.dart';
import 'predict_output_module.dart';

/// Every mini-game is registered here. Add one line per new game.
GameFactory buildGameFactory() {
  return GameFactory()
    ..register(PredictOutputModule())
    ..register(DragOrderModule())
    ..register(FillBlankModule())
    ..register(TypingModule())
    ..register(GridModule())
    ..register(WriteCodeModule())
    ..register(FixBugModule());
}
