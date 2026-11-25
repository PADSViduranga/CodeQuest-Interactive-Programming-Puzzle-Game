import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../auth/presentation/providers/guest_timer_provider.dart';
import '../../../auth/presentation/widgets/guest_time_limit_guard.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateProvider).value;
    final timer = ref.watch(guestTimerProvider);
    final minutes = timer.remaining.inMinutes;
    final seconds = (timer.remaining.inSeconds % 60).toString().padLeft(2, '0');

    return GuestTimeLimitGuard(
      child: Scaffold(
        appBar: AppBar(title: const Text('CodeQuest')),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                user == null
                    ? ''
                    : user.isGuest
                    ? 'Signed in as a guest'
                    : 'Signed in as ${user.displayName ?? user.email}',
              ),
              if (timer.isGuest) ...[
                const SizedBox(height: 8),
                Text('Guest time left: $minutes:$seconds'),
              ],
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () => ref.read(authRepositoryProvider).signOut(),
                child: const Text('Sign out'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
