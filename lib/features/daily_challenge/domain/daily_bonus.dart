enum DailyBonusStatus { locked, ready, claimed }

const dailyBonusXp = 150;

/// The UTC calendar day as YYYY-MM-DD. The server counts days in UTC, so the
/// app does too, which keeps the week dots and the countdown in step with it.
String dayKeyUtc(DateTime when) {
  final u = when.toUtc();
  final y = u.year.toString().padLeft(4, '0');
  final m = u.month.toString().padLeft(2, '0');
  final d = u.day.toString().padLeft(2, '0');
  return '$y-$m-$d';
}

/// Where the player stands with today's bonus (same rules as the server).
DailyBonusStatus computeDailyBonusStatus({
  String? lastStreakDay,
  String? lastDailyBonusDay,
  required String today,
}) {
  if (lastDailyBonusDay == today) return DailyBonusStatus.claimed;
  if (lastStreakDay == today) return DailyBonusStatus.ready;
  return DailyBonusStatus.locked;
}

/// The seven day keys of the UTC week that contains [now], Monday first.
List<String> weekDayKeys(DateTime now) {
  final u = now.toUtc();
  final day = DateTime.utc(u.year, u.month, u.day);
  final monday = day.subtract(Duration(days: day.weekday - 1));
  return [for (var i = 0; i < 7; i++) dayKeyUtc(monday.add(Duration(days: i)))];
}

/// Time left until the server's day changes (UTC midnight).
Duration untilNextUtcDay(DateTime now) {
  final u = now.toUtc();
  final next = DateTime.utc(u.year, u.month, u.day + 1);
  return next.difference(u);
}
