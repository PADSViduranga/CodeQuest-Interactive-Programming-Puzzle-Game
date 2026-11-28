/**
 * Achievements are goals with progress. Each one watches a counter in the
 * player's `stats` and pays its XP once, when the target is reached.
 */
const ACHIEVEMENTS = [
  {
    id: 'puzzle_10',
    name: 'Puzzle Solver',
    description: 'Solve 10 puzzles.',
    stat: 'puzzlesSolved',
    target: 10,
    rewardXp: 100,
  },
  {
    id: 'puzzle_50',
    name: 'Puzzle Master',
    description: 'Solve 50 puzzles.',
    stat: 'puzzlesSolved',
    target: 50,
    rewardXp: 300,
  },
  {
    id: 'minigames_10',
    name: 'Arcade Fan',
    description: 'Win 10 mini-games.',
    stat: 'miniGamesWon',
    target: 10,
    rewardXp: 100,
  },
  {
    id: 'combo_5',
    name: 'Combo King',
    description: 'Reach a 5-answer combo.',
    stat: 'bestCombo',
    target: 5,
    rewardXp: 100,
  },
  {
    id: 'bonus_7',
    name: 'Bonus Hunter',
    description: 'Claim the daily bonus 7 times.',
    stat: 'bonusesClaimed',
    target: 7,
    rewardXp: 150,
  },
];

/** A counter from a stats object, or 0 when it is missing or not a number. */
function readStat(stats, stat) {
  const base = stats && typeof stats === 'object' ? stats : {};
  const v = base[stat];
  return typeof v === 'number' && v > 0 ? v : 0;
}

/** Progress toward [achievement], never above its target. */
function progress(user, achievement) {
  return Math.min(readStat(user.stats, achievement.stat), achievement.target);
}

/**
 * Achievements the player's stats have reached that they do not have yet,
 * and the XP they pay together.
 */
function newAchievements(user) {
  const have = new Set(Array.isArray(user.achievements) ? user.achievements : []);
  const done = ACHIEVEMENTS.filter(
    (a) => !have.has(a.id) && readStat(user.stats, a.stat) >= a.target,
  );
  return {
    unlocked: done.map(({ id, name, description, rewardXp }) => ({
      id,
      name,
      description,
      rewardXp,
    })),
    bonusXp: done.reduce((sum, a) => sum + a.rewardXp, 0),
  };
}

/** A copy of [stats] with the counter [stat] raised by [by]. */
function bumpStat(stats, stat, by = 1) {
  const base = stats && typeof stats === 'object' ? stats : {};
  return { ...base, [stat]: readStat(base, stat) + by };
}

/** A copy of [stats] where [stat] is at least [value] (for "best" counters). */
function maxStat(stats, stat, value) {
  const base = stats && typeof stats === 'object' ? stats : {};
  return { ...base, [stat]: Math.max(readStat(base, stat), value) };
}

module.exports = { ACHIEVEMENTS, readStat, progress, newAchievements, bumpStat, maxStat };
