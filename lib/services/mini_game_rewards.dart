import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/foundation.dart';

/// Asks the server to award XP for a won mini-game.
/// Failures are ignored so a missing server never breaks a game.
class MiniGameRewards {
  const MiniGameRewards._();

  static Future<void> award(String gameId) async {
    try {
      await FirebaseFunctions.instance.httpsCallable('awardMiniGameXp').call({
        'gameId': gameId,
      });
    } catch (e) {
      debugPrint('mini-game reward skipped: $e');
    }
  }
}
