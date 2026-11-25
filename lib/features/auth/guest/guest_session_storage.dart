import 'package:shared_preferences/shared_preferences.dart';

/// Keeps how many seconds each guest has already played on this device.
class GuestSessionStorage {
  String _key(String uid) => 'guest_used_seconds_$uid';

  Future<int> loadUsedSeconds(String uid) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_key(uid)) ?? 0;
  }

  Future<void> saveUsedSeconds(String uid, int seconds) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_key(uid), seconds);
  }
}
