import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/guest_limits.dart';
import '../../domain/app_user.dart';
import '../../guest/guest_session_storage.dart';
import 'auth_provider.dart';

class GuestTimerState {
  const GuestTimerState({this.isGuest = false, this.used = Duration.zero});

  final bool isGuest;
  final Duration used;

  Duration get remaining {
    final left = GuestLimits.sessionLimit - used;
    return left.isNegative ? Duration.zero : left;
  }

  bool get expired => isGuest && used >= GuestLimits.sessionLimit;

  GuestTimerState copyWith({Duration? used}) =>
      GuestTimerState(isGuest: isGuest, used: used ?? this.used);
}

class GuestTimerNotifier extends Notifier<GuestTimerState> {
  final _storage = GuestSessionStorage();
  Timer? _timer;
  String? _uid;
  bool _foreground = true;

  @override
  GuestTimerState build() {
    ref.onDispose(() => _timer?.cancel());
    ref.listen(authStateProvider, (_, next) => _onUser(next.value));
    Future.microtask(() => _onUser(ref.read(authStateProvider).value));
    return const GuestTimerState();
  }

  Future<void> _onUser(AppUser? user) async {
    _timer?.cancel();
    if (user == null || !user.isGuest) {
      _uid = null;
      state = const GuestTimerState();
      return;
    }
    _uid = user.uid;
    final seconds = await _storage.loadUsedSeconds(user.uid);
    if (_uid != user.uid) return;
    state = GuestTimerState(isGuest: true, used: Duration(seconds: seconds));
    _start();
  }

  void _start() {
    _timer?.cancel();
    if (!state.isGuest || state.expired || !_foreground) return;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      final next = state.used + const Duration(seconds: 1);
      state = state.copyWith(used: next);
      _storage.saveUsedSeconds(_uid!, next.inSeconds);
      if (state.expired) _timer?.cancel();
    });
  }

  /// The timer only runs while the app is on screen.
  void setForeground(bool value) {
    _foreground = value;
    if (value) {
      _start();
    } else {
      _timer?.cancel();
    }
  }
}

final guestTimerProvider =
    NotifierProvider<GuestTimerNotifier, GuestTimerState>(
      GuestTimerNotifier.new,
    );
