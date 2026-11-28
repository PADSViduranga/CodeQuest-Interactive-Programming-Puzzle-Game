/** The UTC calendar day of a date, as YYYY-MM-DD. */
function dayKey(date) {
  return date.toISOString().slice(0, 10);
}

/** Whole days from day key a to day key b (both YYYY-MM-DD). */
function daysBetween(a, b) {
  const ms = Date.parse(b + 'T00:00:00Z') - Date.parse(a + 'T00:00:00Z');
  return Math.round(ms / 86400000);
}

/**
 * Works out the player's streak after a win on day [today].
 * - first win ever, or a gap of more than a day: streak restarts at 1
 * - first win on the day after the last one: streak grows by 1
 * - another win on the same day: streak stays the same
 */
function nextStreak(user, today) {
  const current = user.currentStreak || 0;
  const longest = user.longestStreak || 0;
  const last = user.lastStreakDay || null;

  let streak;
  if (!last) {
    streak = 1;
  } else {
    const gap = daysBetween(last, today);
    if (gap <= 0) streak = Math.max(current, 1); // same day (or clock went back)
    else if (gap === 1) streak = current + 1;
    else streak = 1;
  }

  return {
    currentStreak: streak,
    longestStreak: Math.max(longest, streak),
    lastStreakDay: !last || daysBetween(last, today) > 0 ? today : last,
    increased: streak > current,
  };
}

module.exports = { dayKey, daysBetween, nextStreak };
