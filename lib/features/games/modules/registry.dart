import '../core/game_factory.dart';
import 'drag_order_module.dart';
import 'predict_output_module.dart';

/// Every mini-game is registered here. Add one line per new game.
GameFactory buildGameFactory() {
  return GameFactory()
    ..register(PredictOutputModule())
    ..register(DragOrderModule());
}
