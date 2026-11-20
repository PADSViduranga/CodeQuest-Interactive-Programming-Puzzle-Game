import 'package:flutter/services.dart';

class AudioService {
  bool enabled = true;
  Future<void> success() async {
    if (enabled) await SystemSound.play(SystemSoundType.click);
  }

  Future<void> error() async {
    if (enabled) await SystemSound.play(SystemSoundType.alert);
  }
}
