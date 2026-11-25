import 'package:flutter_test/flutter_test.dart';

import 'package:codequest/features/auth/presentation/providers/guest_timer_provider.dart';

void main() {
  test('guest has 10 minutes before expiring', () {
    const fresh = GuestTimerState(isGuest: true);
    expect(fresh.remaining, const Duration(minutes: 10));
    expect(fresh.expired, isFalse);
  });

  test('guest expires after 10 minutes', () {
    const done = GuestTimerState(isGuest: true, used: Duration(minutes: 10));
    expect(done.remaining, Duration.zero);
    expect(done.expired, isTrue);
  });

  test('a normal player never expires', () {
    const player = GuestTimerState(used: Duration(minutes: 99));
    expect(player.expired, isFalse);
  });
}
