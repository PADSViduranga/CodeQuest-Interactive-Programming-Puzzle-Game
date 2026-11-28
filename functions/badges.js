/**
 * The badge catalog. Each badge has a rule that says whether a player has
 * earned it. Rules are checked right after a win, so "first_win" only needs
 * to be true when called.
 */
const BADGES = [
  {
    id: 'first_win',
    name: 'First Win',
    description: 'Solve your first puzzle.',
    earned: () => true,
  },
  {
    id: 'streak_3',
    name: 'On a Roll',
    description: 'Win 3 days in a row.',
    earned: (u) => (u.currentStreak || 0) >= 3,
  },
  {
    id: 'streak_7',
    name: 'Week Warrior',
    description: 'Win 7 days in a row.',
    earned: (u) => (u.currentStreak || 0) >= 7,
  },
  {
    id: 'level_5',
    name: 'Rising Coder',
    description: 'Reach level 5.',
    earned: (u) => (u.level || 1) >= 5,
  },
  {
    id: 'xp_500',
    name: 'XP Collector',
    description: 'Earn 500 XP in total.',
    earned: (u) => (u.totalXp || 0) >= 500,
  },
];

/**
 * Badges the player has just earned. [user] holds the profile values AFTER
 * the win (totalXp, level, currentStreak) and the badge ids already owned.
 */
function newBadges(user) {
  const have = new Set(Array.isArray(user.badges) ? user.badges : []);
  return BADGES.filter((b) => !have.has(b.id) && b.earned(user)).map(
    ({ id, name, description }) => ({ id, name, description }),
  );
}

module.exports = { BADGES, newBadges };
