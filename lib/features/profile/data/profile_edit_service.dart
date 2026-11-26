import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Loads and saves the two profile fields a player may change:
/// display name and avatar. XP and level stay server-only.
class ProfileEditService {
  ProfileEditService(this._db, this._auth);

  final FirebaseFirestore _db;
  final FirebaseAuth _auth;

  User _user() {
    final user = _auth.currentUser;
    if (user == null) throw StateError('Not signed in');
    return user;
  }

  Future<({String displayName, String avatarId})> load() async {
    final user = _user();
    final snap = await _db.collection('users').doc(user.uid).get();
    final data = snap.data() ?? const <String, dynamic>{};
    return (
      displayName:
          (data['displayName'] as String?) ?? user.displayName ?? 'Player',
      avatarId: (data['avatarId'] as String?) ?? 'mito_1',
    );
  }

  Future<void> save({
    required String displayName,
    required String avatarId,
  }) async {
    final user = _user();
    await _db.collection('users').doc(user.uid).update({
      'displayName': displayName,
      'avatarId': avatarId,
      'lastActiveAt': FieldValue.serverTimestamp(),
    });
    await user.updateDisplayName(displayName);
  }
}

final profileEditServiceProvider = Provider<ProfileEditService>(
  (ref) =>
      ProfileEditService(FirebaseFirestore.instance, FirebaseAuth.instance),
);
