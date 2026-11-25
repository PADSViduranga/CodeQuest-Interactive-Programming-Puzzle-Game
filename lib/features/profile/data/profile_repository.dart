import 'package:cloud_firestore/cloud_firestore.dart';

import '../../auth/domain/app_user.dart';
import '../domain/player_profile.dart';

class ProfileRepository {
  ProfileRepository(this._db);

  final FirebaseFirestore _db;

  DocumentReference<Map<String, dynamic>> _doc(String uid) =>
      _db.collection('users').doc(uid);

  /// Creates the profile on first sign-in and refreshes safe fields after.
  Future<void> syncProfile(AppUser user) async {
    final ref = _doc(user.uid);
    final snap = await ref.get();
    if (!snap.exists) {
      await ref.set({
        'displayName': user.displayName ?? (user.isGuest ? 'Guest' : 'Player'),
        'isGuest': user.isGuest,
        'avatarId': 'mito_1',
        'selectedLanguage': null,
        'selectedLevel': null,
        'totalXp': 0,
        'level': 1,
        'currentStreak': 0,
        'longestStreak': 0,
        'createdAt': FieldValue.serverTimestamp(),
        'lastActiveAt': FieldValue.serverTimestamp(),
        'settings': {'sound': true, 'haptics': true},
      });
    } else {
      await ref.update({
        'isGuest': user.isGuest,
        if (user.displayName != null) 'displayName': user.displayName,
        'lastActiveAt': FieldValue.serverTimestamp(),
      });
    }
  }

  Stream<PlayerProfile?> watchProfile(String uid) {
    return _doc(uid)
        .snapshots()
        .map((s) => s.exists ? PlayerProfile.fromMap(uid, s.data()!) : null);
  }

  Future<void> deleteProfile(String uid) => _doc(uid).delete();
}
