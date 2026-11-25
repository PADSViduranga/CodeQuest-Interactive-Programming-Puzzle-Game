import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSettings {
  const AppSettings({this.sound = true, this.haptics = true});

  final bool sound;
  final bool haptics;

  AppSettings copyWith({bool? sound, bool? haptics}) =>
      AppSettings(sound: sound ?? this.sound, haptics: haptics ?? this.haptics);
}

class SettingsNotifier extends Notifier<AppSettings> {
  static const _soundKey = 'settings_sound';
  static const _hapticsKey = 'settings_haptics';

  @override
  AppSettings build() {
    Future.microtask(_load);
    return const AppSettings();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    state = AppSettings(
      sound: prefs.getBool(_soundKey) ?? true,
      haptics: prefs.getBool(_hapticsKey) ?? true,
    );
  }

  Future<void> setSound(bool value) async {
    state = state.copyWith(sound: value);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_soundKey, value);
  }

  Future<void> setHaptics(bool value) async {
    state = state.copyWith(haptics: value);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_hapticsKey, value);
  }
}

final settingsProvider = NotifierProvider<SettingsNotifier, AppSettings>(
  SettingsNotifier.new,
);
