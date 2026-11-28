import 'package:codequest/features/daily_challenge/data/daily_bonus_service.dart';
import 'package:codequest/features/daily_challenge/domain/daily_bonus.dart';
import 'package:codequest/features/profile/domain/player_profile.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('day keys are padded', () {
    expect(dayKeyUtc(DateTime.utc(2026, 3, 5)), '2026-03-05');
  });

  test('day keys use UTC, not the local clock', () {
    // 3 am in Sri Lanka is still the day before in UTC.
    expect(
      dayKeyUtc(DateTime.parse('2026-11-28T03:00:00+05:30')),
      '2026-11-27',
    );
  });

  test('the week runs Monday to Sunday', () {
    expect(weekDayKeys(DateTime.utc(2026, 11, 28, 10)), [
      '2026-11-23',
      '2026-11-24',
      '2026-11-25',
      '2026-11-26',
      '2026-11-27',
      '2026-11-28',
      '2026-11-29',
    ]);
  });

  test('a week can cross a month boundary', () {
    final week = weekDayKeys(DateTime.utc(2026, 12, 2));
    expect(week.first, '2026-11-30');
    expect(week[1], '2026-12-01');
    expect(week.last, '2026-12-06');
  });

  test('a new player is locked', () {
    expect(
      computeDailyBonusStatus(today: '2026-11-28'),
      DailyBonusStatus.locked,
    );
  });

  test('winning today makes the bonus ready', () {
    expect(
      computeDailyBonusStatus(lastStreakDay: '2026-11-28', today: '2026-11-28'),
      DailyBonusStatus.ready,
    );
  });

  test('a claimed bonus stays claimed for the day', () {
    expect(
      computeDailyBonusStatus(
        lastStreakDay: '2026-11-28',
        lastDailyBonusDay: '2026-11-28',
        today: '2026-11-28',
      ),
      DailyBonusStatus.claimed,
    );
  });

  test('the countdown ends at UTC midnight', () {
    expect(
      untilNextUtcDay(DateTime.utc(2026, 11, 28, 18, 30)),
      const Duration(hours: 5, minutes: 30),
    );
  });

  test('a claim result is read from the server response', () {
    final r = DailyBonusResult.fromMap({
      'status': 'claimed',
      'xpAwarded': 150,
      'totalXp': 200,
      'level': 3,
      'newBadges': [
        <Object?, Object?>{'id': 'a', 'name': 'A', 'description': 'd'},
      ],
    });
    expect(r.status, 'claimed');
    expect(r.xpAwarded, 150);
    expect(r.level, 3);
    expect(r.newBadges.single.name, 'A');
  });

  test('the profile reads its daily fields', () {
    final p = PlayerProfile.fromMap('u', {
      'lastStreakDay': '2026-11-28',
      'lastDailyBonusDay': '2026-11-27',
      'recentDays': ['2026-11-27', 5, '2026-11-28'],
    });
    expect(p.lastStreakDay, '2026-11-28');
    expect(p.lastDailyBonusDay, '2026-11-27');
    expect(p.recentDays, ['2026-11-27', '2026-11-28']);
    expect(PlayerProfile.fromMap('u', {}).recentDays, isEmpty);
  });
}
