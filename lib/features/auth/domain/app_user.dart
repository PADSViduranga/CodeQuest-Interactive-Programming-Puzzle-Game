class AppUser {
  const AppUser({
    required this.uid,
    required this.isGuest,
    this.email,
    this.displayName,
  });

  final String uid;
  final bool isGuest;
  final String? email;
  final String? displayName;
}
