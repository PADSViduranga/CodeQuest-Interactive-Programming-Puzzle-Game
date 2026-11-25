import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../guest/guest_limit_dialog.dart';
import '../providers/auth_provider.dart';
import '../providers/guest_timer_provider.dart';

/// Wrap any signed-in screen with this. It runs the guest timer, pauses it
/// when the app goes to the background, and shows the popup at 10 minutes.
class GuestTimeLimitGuard extends ConsumerStatefulWidget {
  const GuestTimeLimitGuard({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<GuestTimeLimitGuard> createState() =>
      _GuestTimeLimitGuardState();
}

class _GuestTimeLimitGuardState extends ConsumerState<GuestTimeLimitGuard>
    with WidgetsBindingObserver {
  bool _showing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    ref
        .read(guestTimerProvider.notifier)
        .setForeground(state == AppLifecycleState.resumed);
  }

  Future<void> _showPopup() async {
    if (_showing || !mounted) return;
    _showing = true;
    await showGuestLimitDialog(
      context,
      onRegister: () async {
        await context.push('/register');
        _showing = false;
        if (mounted && ref.read(guestTimerProvider).expired) _showPopup();
      },
      onLogin: () {
        _showing = false;
        ref.read(authRepositoryProvider).signOut();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(guestTimerProvider);
    ref.listen(guestTimerProvider, (prev, next) {
      if (next.expired && !(prev?.expired ?? false)) _showPopup();
    });
    return widget.child;
  }
}
