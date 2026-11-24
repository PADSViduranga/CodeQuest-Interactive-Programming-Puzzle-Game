import 'package:flutter/services.dart';

class HapticsService {
  bool enabled = true;
  Future<void> tap() async {
    if (enabled) await HapticFeedback.selectionClick();
  }

  Future<void> success() async {
    if (enabled) await HapticFeedback.mediumImpact();
  }

  Future<void> error() async {
    if (enabled) await HapticFeedback.heavyImpact();
  }
}
