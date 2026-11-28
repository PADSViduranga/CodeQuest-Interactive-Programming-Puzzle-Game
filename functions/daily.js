const DAILY_BONUS_XP = 150;

/**
 * Where the player stands with today's bonus.
 * - 'claimed': already collected today
 * - 'ready': won something today and not collected yet
 * - 'locked': has not won anything today
 */
function dailyBonusStatus(user, today) {
  if (user.lastDailyBonusDay === today) return 'claimed';
  if (user.lastStreakDay === today) return 'ready';
  return 'locked';
}

module.exports = { DAILY_BONUS_XP, dailyBonusStatus };
