import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/domain/app_user.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/profile_provider.dart';

/// Wrap signed-in screens with this. It makes sure the player's profile
/// document exists and is up to date.
class ProfileSync extends ConsumerStatefulWidget {
  const ProfileSync({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<ProfileSync> createState() => _ProfileSyncState();
}

class _ProfileSyncState extends ConsumerState<ProfileSync> {
  @override
  void initState() {
    super.initState();
    ref.listenManual(
      authStateProvider,
      (_, next) => _sync(next.value),
      fireImmediately: true,
    );
  }

  void _sync(AppUser? user) {
    if (user == null) return;
    ref
        .read(profileRepositoryProvider)
        .syncProfile(user)
        .catchError((Object e) => debugPrint('Profile sync failed: $e'));
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
