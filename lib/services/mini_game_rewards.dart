import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/foundation.dart';

/// Asks the server to award XP for a won mini-game and returns a short
/// message describing what happened. Never throws.
class MiniGameRewards {
  const MiniGameRewards._();

  static Future<String> award(String gameId) async {
    try {
      final result = await FirebaseFunctions.instance
          .httpsCallable('awardMiniGameXp')
          .call({'gameId': gameId});
      final data = Map<String, dynamic>.from(result.data as Map);
      final xp = (data['xpAwarded'] as num?)?.toInt() ?? 0;
      return xp > 0
          ? '+$xp XP saved to your profile'
          : 'Already earned today, no extra XP';
    } catch (e) {
      debugPrint('mini-game reward skipped: $e');
      final text = e.toString();
      return 'XP not saved: ${text.length > 120 ? text.substring(0, 120) : text}';
    }
  }
}
