import 'game_module.dart';
import 'game_type.dart';

/// Finds the right mini-game for a puzzle type.
class GameFactory {
  final _modules = <GameType, GameModule>{};

  void register(GameModule module) => _modules[module.type] = module;

  GameModule moduleFor(GameType type) {
    final module = _modules[type];
    if (module == null) {
      throw StateError('No game registered for ${type.wire}');
    }
    return module;
  }
}
