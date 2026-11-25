import 'app_user.dart';

abstract class AuthRepository {
  Stream<AppUser?> authStateChanges();

  Future<void> signIn({required String email, required String password});

  Future<void> register({
    required String displayName,
    required String email,
    required String password,
  });

  Future<void> signInAsGuest();

  Future<void> sendPasswordReset(String email);

  Future<void> signOut();

  /// Confirms the player's password before a sensitive action.
  Future<void> reauthenticate(String password);

  /// Deletes the sign-in account. Call reauthenticate first.
  Future<void> deleteAccount();
}
