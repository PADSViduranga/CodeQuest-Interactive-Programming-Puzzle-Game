import 'package:firebase_auth/firebase_auth.dart' as fb;

import '../../../core/error/failures.dart';
import '../domain/app_user.dart';
import '../domain/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._auth);

  final fb.FirebaseAuth _auth;

  AppUser? _map(fb.User? u) => u == null
      ? null
      : AppUser(
          uid: u.uid,
          isGuest: u.isAnonymous,
          email: u.email,
          displayName: u.displayName,
        );

  @override
  Stream<AppUser?> authStateChanges() => _auth.userChanges().map(_map);

  @override
  Future<void> signIn({required String email, required String password}) =>
      _guard(
        () =>
            _auth.signInWithEmailAndPassword(email: email, password: password),
      );

  @override
  Future<void> register({
    required String displayName,
    required String email,
    required String password,
  }) => _guard(() async {
    final current = _auth.currentUser;
    fb.UserCredential result;
    if (current != null && current.isAnonymous) {
      // A guest becomes a real account and keeps the same uid and progress.
      final credential = fb.EmailAuthProvider.credential(
        email: email,
        password: password,
      );
      result = await current.linkWithCredential(credential);
    } else {
      result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    }
    await result.user?.updateDisplayName(displayName);
    await result.user?.reload();
  });

  @override
  Future<void> signInAsGuest() => _guard(_auth.signInAnonymously);

  @override
  Future<void> sendPasswordReset(String email) =>
      _guard(() => _auth.sendPasswordResetEmail(email: email));

  @override
  Future<void> signOut() => _auth.signOut();

  @override
  Future<void> reauthenticate(String password) => _guard(() async {
    final user = _auth.currentUser;
    final email = user?.email;
    if (user == null || email == null) {
      throw const AuthFailure('Sign in with an email account first.');
    }
    await user.reauthenticateWithCredential(
      fb.EmailAuthProvider.credential(email: email, password: password),
    );
  });

  @override
  Future<void> deleteAccount() => _guard(() async {
    final user = _auth.currentUser;
    if (user == null) {
      throw const AuthFailure('You are not signed in.');
    }
    await user.delete();
  });

  Future<void> _guard(Future<Object?> Function() action) async {
    try {
      await action();
    } on fb.FirebaseAuthException catch (e) {
      throw AuthFailure(_message(e));
    }
  }

  String _message(fb.FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return 'That email address is not valid.';
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return 'Incorrect email or password.';
      case 'email-already-in-use':
      case 'credential-already-in-use':
        return 'An account with this email already exists.';
      case 'weak-password':
        return 'Choose a stronger password (at least 8 characters).';
      case 'too-many-requests':
        return 'Too many attempts. Please wait a moment and try again.';
      case 'network-request-failed':
        return 'No internet connection. Check your network and retry.';
      case 'operation-not-allowed':
        return 'This sign-in method is not enabled in Firebase.';
      default:
        return 'Something went wrong (${e.code}). Please try again.';
    }
  }
}
